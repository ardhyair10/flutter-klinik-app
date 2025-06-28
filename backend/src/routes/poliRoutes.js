const express = require('express');
const router = express.Router();
const apiKeyMiddleware = require('../middlewares/apiKey'); // pastikan ini benar
const { getPoli } = require('../controllers/poliController'); // pastikan ini benar
router.get('/poli', apiKeyMiddleware, getPoli); // Endpoint untuk mendapatkan data poli
module.exports = router;