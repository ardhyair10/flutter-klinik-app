// src/controllers/authController.js

const authService = require('../services/authService');

// Fungsi Login
exports.login = async (req, res) => {
  try {
    const { username, password } = req.body;
    const result = await authService.login(username, password);

    if (result.success) {
      req.session.user = result.user;
      res.json({ user: result.user });
    } else {
      res.status(401).json({ message: result.message });
    }
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ message: 'Internal Server Error' });
  }
};

// Fungsi Lupa Password
exports.forgotPassword = async (req, res) => {
  try {
    await authService.requestPasswordReset(req.body.email);
    res.status(200).json({ message: 'Jika email Anda terdaftar, instruksi reset akan dikirimkan.' });
  } catch (error) {
    console.error('Forgot Password Error:', error);
    res.status(500).json({ message: 'Terjadi kesalahan pada server' });
  }
};

// Fungsi Reset Password
exports.resetPassword = async (req, res) => {
  try {
    const { email, otp, newPassword } = req.body;
    const result = await authService.resetPasswordWithOtp(email, otp, newPassword);
    res.status(200).json(result);
  } catch (error) {
    console.error('Reset Password Error:', error.message);
    res.status(400).json({ message: error.message });
  }
};

// Fungsi untuk mendapatkan data user yang login
exports.getMe = (req, res) => {
  if (req.session && req.session.user) {
    res.status(200).json(req.session.user);
  } else {
    res.status(401).json({ message: 'Tidak ada sesi yang aktif.' });
  }
};