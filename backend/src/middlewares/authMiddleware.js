// src/middlewares/authMiddleware.js

const authMiddleware = (req, res, next) => {
  // Cek apakah data user ada di dalam sesi
  if (req.session && req.session.user) {
    // Jika ada, lanjutkan ke controller selanjutnya
    return next();
  } else {
    // Jika tidak ada, kirim error 401 Unauthorized
    return res.status(401).json({ message: 'Akses ditolak. Silakan login terlebih dahulu.' });
  }
};

module.exports = authMiddleware;