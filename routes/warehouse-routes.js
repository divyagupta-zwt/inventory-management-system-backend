const express= require('express');
const router= express.Router();
const {getStock, getWarehouses}= require('../controllers/warehouse-controller');

router.get('/', getWarehouses);
router.get('/:id/stock', getStock);

module.exports= router;