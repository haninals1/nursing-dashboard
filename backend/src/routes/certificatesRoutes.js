const express = require('express');
const router = express.Router();
const { getsCertificates } = require('../controllers/certificatesController');
router.get('/', getsCertificates);
module.exports = router;
