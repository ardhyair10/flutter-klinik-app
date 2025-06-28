// src/controllers/userController.js

const userService = require('../services/userService');

// --- FUNGSI-FUNGSI MANAJEMEN USER ---
exports.getAllUsers = async (req, res) => { /* ... kode Anda ... */ };
exports.getUserById = async (req, res) => { /* ... kode Anda ... */ };

// --- FUNGSI-FUNGSI UNTUK ALUR REGISTRASI DENGAN OTP ---
exports.requestRegister = async (req, res) => {
  // --- TAMBAHKAN LOG INI UNTUK MELIHAT DATA DARI FLUTTER ---
  console.log("\n[Controller] Menerima permintaan request-otp dengan body:", req.body);

  try {
    const result = await userService.requestRegistration(req.body);
    res.status(200).json(result);
  } catch (error) {
    // Log ini akan memberitahu kita jika ada error dari service
    console.error("[Controller] Error di requestRegister:", error.message);
    res.status(400).json({ message: error.message });
  }
};

exports.verifyRegister = async (req, res) => {
  try {
    const { email, otp } = req.body;
    const newUser = await userService.verifyRegistration(email, otp);
    res.status(201).json({ message: 'Registrasi berhasil', user: newUser });
  } catch (error) {
    // --- PASTIKAN BARIS INI ADA ---
    console.error('VERIFICATION ERROR:', error.message); 
    
    res.status(400).json({ message: error.message });
  }
};