const express = require('express');
const router = express.Router();
const { getTraining } = require('../controllers/trainingController');
router.get('/', getTraining);
module.exports = router;
