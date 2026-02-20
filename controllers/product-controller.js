const db= require('../config/db');

exports.getProducts= async(req, res)=>{
    try{
        const [rows]=await db.query(`select product_name, sku, price from products;`);
        res.json(rows);
    }catch(error){
        res.status(400).json({error: error.message});
    }
}

exports.getProductById= async(req, res)=>{
    try{
        const [rows]=await db.query(`select product_name, sku, price from products where product_id=?;`,[req.params.id]);
        res.json(rows);
    }catch(error){
        res.status(400).json({error: error.message});
    }
}