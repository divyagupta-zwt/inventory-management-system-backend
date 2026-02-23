CREATE DEFINER=`root`@`localhost` PROCEDURE `place_order`(
    IN p_customer_name VARCHAR(100),
    IN p_warehouse_id INT,
    IN p_items JSON,
    OUT p_order_id INT
)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE items_count INT;
    DECLARE v_product_id INT;
    DECLARE v_quantity INT;
    DECLARE v_unit_price DECIMAL(10,2);
    DECLARE v_total_price DECIMAL(10,2);
    DECLARE v_total_amount DECIMAL(10,2) DEFAULT 0;

    START TRANSACTION;

    IF NOT EXISTS (
        SELECT 1 FROM warehouse
        WHERE warehouse_id = p_warehouse_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid warehouse';
    END IF;

    SET items_count = JSON_LENGTH(p_items);

    SET i = 0;

    WHILE i < items_count DO
        SET v_product_id = JSON_UNQUOTE(JSON_EXTRACT(p_items, CONCAT('$[', i, '].product_id')));
        SET v_quantity = JSON_UNQUOTE(JSON_EXTRACT(p_items, CONCAT('$[', i, '].quantity')));

        IF NOT EXISTS (
            SELECT 1 FROM products WHERE product_id = v_product_id
        ) THEN
            SET @message_text = CONCAT('Invalid product_id ', v_product_id);
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = @message_text;
        END IF;

        IF (SELECT quantity FROM warehouse_stock
            WHERE warehouse_id = p_warehouse_id
            AND product_id = v_product_id) < v_quantity THEN
            SET @message_text = CONCAT('Insufficient stock for product_id ', v_product_id);
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = @message_text;
        END IF;

        SET i = i + 1;
    END WHILE;

    INSERT INTO orders(customer_name, order_date, warehouse_id, status)
    VALUES (p_customer_name, NOW(), p_warehouse_id, 'PLACED');

    SET p_order_id = LAST_INSERT_ID();

    SET i = 0;

    WHILE i < items_count DO
        SET v_product_id = JSON_UNQUOTE(JSON_EXTRACT(p_items, CONCAT('$[', i, '].product_id')));
        SET v_quantity = JSON_UNQUOTE(JSON_EXTRACT(p_items, CONCAT('$[', i, '].quantity')));

        SELECT price INTO v_unit_price
        FROM products
        WHERE product_id = v_product_id;

        SET v_total_price = v_quantity * v_unit_price;

        INSERT INTO order_items(
            order_id,
            product_id,
            quantity,
            unit_price,
            total_price
        )
        VALUES (
            p_order_id,
            v_product_id,
            v_quantity,
            v_unit_price,
            v_total_price
        );

        UPDATE warehouse_stock
        SET quantity = quantity - v_quantity
        WHERE warehouse_id = p_warehouse_id
        AND product_id = v_product_id;

        SET v_total_amount = v_total_amount + v_total_price;

        SET i = i + 1;
    END WHILE;

    UPDATE orders
    SET total_amount = v_total_amount
    WHERE order_id = p_order_id;

    COMMIT;
END