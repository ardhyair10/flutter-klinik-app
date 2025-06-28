const adminMiddleware = (req, res, next) => {
  // Middleware ini dijalankan SETELAH authMiddleware, jadi req.session.user pasti ada
  if (req.session.user.role === 'admin') {
    return next(); // Lanjutkan jika rolenya admin
  } else {
    // Kirim error 403 Forbidden jika bukan admin
    return res.status(403).json({ message: 'Akses ditolak. Fitur ini hanya untuk admin.' });
  }
};

module.exports = adminMiddleware;