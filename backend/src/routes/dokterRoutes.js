const express = require('express');
const router = express.Router();
const dokterController = require('../controllers/dokterController');

// URL akan menjadi: GET /dokter/poli/:poliId
router.get('/poli/:poliId', dokterController.getDokterByPoliId);

module.exports = router;