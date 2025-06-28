// src/routes/authRoutes.js

const express = require('express');
const router = express.Router();
// PASTIKAN NAMA INI SAMA PERSIS (tanpa 's')
const authController = require('../controllers/authController'); 
const authMiddleware = require('../middlewares/authMiddleware');

// Rute-rute publik
router.post('/login', authController.login);
router.post('/forgot-password', authController.forgotPassword);
router.post('/reset-password', authController.resetPassword);

// Rute yang diproteksi
router.get('/me', authMiddleware, authController.getMe);

module.exports = router;