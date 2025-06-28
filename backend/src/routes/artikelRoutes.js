const express = require('express');
const router = express.Router();
const artikelController = require('../controllers/artikelController');

// URL: GET /artikel
router.get('/', artikelController.getAllArtikel);
// URL: GET /artikel/1
router.get('/:id', artikelController.getArtikelById);

module.exports = router;