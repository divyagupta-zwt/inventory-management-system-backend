const db = require('../config/db');

exports.getStock = async (req, res) => {
    try {
        const warehouseId = req.params.id;

        const [rows] = await db.query(`
            SELECT 
                ws.warehouse_id,
                p.product_id,
                p.product_name,
                p.sku,
                ws.quantity AS available_quantity,
                p.price
            FROM warehouse_stock ws
            JOIN products p 
                ON ws.product_id = p.product_id
            WHERE ws.warehouse_id = ?
            ORDER BY p.product_name;
        `, [warehouseId]);

        res.json(rows);

    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.getWarehouses = async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT 
                warehouse_id,
                warehouse_name,
                location
            FROM warehouse;
        `);

        res.json(rows);

    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
