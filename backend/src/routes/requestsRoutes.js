const express = require('express');
const router = express.Router();
const { getRequests } = require('../controllers/requestsController');
router.get('/', getRequests);
module.exports = router;
