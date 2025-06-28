const express = require('express');
const router = express.Router();
const resepObatController = require('../controllers/resepObatController');

// URL: GET /resep-obat
router.get('/', resepObatController.getResepObatByUserId);

module.exports = router;