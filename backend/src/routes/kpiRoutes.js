const express = require('express');
const router = express.Router();
const { getKPIs } = require('../controllers/kpiController');
router.get('/', getKPIs);
module.exports = router;
