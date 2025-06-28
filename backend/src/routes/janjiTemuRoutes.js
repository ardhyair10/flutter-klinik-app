const express = require('express');
const router = express.Router();
const janjiTemuController = require('../controllers/janjiTemuController');

// URL: POST /janji-temu
router.post('/', janjiTemuController.createJanjiTemu);
router.get('/riwayat', janjiTemuController.getRiwayatByUserId);
router.get('/berikutnya', janjiTemuController.getNextJanjiTemu);
// Nanti Anda bisa tambahkan rute lain di sini, misal GET untuk melihat riwayat
// router.get('/', ...);

module.exports = router;