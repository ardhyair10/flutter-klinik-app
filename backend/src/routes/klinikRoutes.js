const express = require('express');
const router = express.Router();
const klinikController = require('../controllers/klinikController');

// URL: GET /klinik
router.get('/', klinikController.getAllKlinik);

module.exports = router;