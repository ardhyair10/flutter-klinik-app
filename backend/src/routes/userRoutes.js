// src/routes/userRoutes.js

const express = require('express');
const router = express.Router();

// 1. Impor semua fungsi yang dibutuhkan dari controller dalam satu baris
const {
  getAllUsers,
  getUserById,
  requestRegister,
  verifyRegister,
} = require('../controllers/userController');

// Middleware untuk API Key jika diperlukan
// const apiKeyMiddleware = require('../middlewares/apiKey');

// --- Rute untuk Manajemen Pengguna ---

// URL: GET /users (atau /api/users tergantung index.js)
// router.get('/', apiKeyMiddleware, getAllUsers);

// URL: GET /users/:id (atau /api/users/:id)
// router.get('/:id', apiKeyMiddleware, getUserById);


// --- Rute untuk Alur Registrasi dengan OTP ---
// Rute '/register' yang lama sudah dihapus.

// URL: POST /register/request-otp
router.post('/register/request-otp', requestRegister);

// URL: POST /register/verify-otp
router.post('/register/verify-otp', verifyRegister);


module.exports = router;