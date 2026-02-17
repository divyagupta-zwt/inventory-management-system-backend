require('dotenv').config();
const express= require('express');
const app= express();
const cors= require('cors');
const orderRoutes= require('./routes/order-routes');
const warehouseRoutes= require('./routes/warehouse-routes')
const productRoutes= require('./routes/product-routes')

app.use(express.json());
app.use(cors());
app.use('/api/orders', orderRoutes);
app.use('/api/warehouse', warehouseRoutes);
app.use('/api/products', productRoutes);

const PORT= process.env.PORT || 3000;

app.listen(PORT,()=>{
    console.log(`Server is running at http://localhost:${PORT}`);
});