// src/controllers/janjiTemuController.js
const janjiTemuService = require('../services/janjiTemuService');

exports.createJanjiTemu = async (req, res) => {
  console.log("\n[Controller] Menerima permintaan POST /janji-temu");
  console.log("[Controller] Body Request:", req.body);

  try {
    // --- PERBAIKAN DI SINI ---
    // Cek dulu apakah sesi user ada sebelum mencoba mengakses isinya
    if (!req.session || !req.session.user) {
      // Jika tidak ada sesi, kirim error 401 Unauthorized
      return res.status(401).json({ message: "Akses ditolak. Silakan login terlebih dahulu." });
    }

    const userId = req.session.user.id;
    console.log(`[Controller] User ID dari sesi: ${userId}`);
    
    const data = { ...req.body, userId };
    console.log("[Controller] Data yang dikirim ke service:", data);

    const janjiBaru = await janjiTemuService.create(data);
    res.status(201).json({ message: 'Janji temu berhasil dibuat', data: janjiBaru });
    
  } catch (error) {
    console.error("❌ Error di janjiTemuController:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};
// --- TAMBAHAN FUNGSI BARU ---
exports.getRiwayatByUserId = async (req, res) => {
  try {
    // Ambil user id dari sesi yang login. Ini kuncinya!
    const userId = req.session.user.id;
    if (!userId) {
      return res.status(401).json({ message: "Anda harus login terlebih dahulu" });
    }

    const riwayat = await janjiTemuService.getByUserId(userId);
    res.json(riwayat);
  } catch (error) {
    console.error("Error di getRiwayatByUserId:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};
exports.getNextJanjiTemu = async (req, res) => {
  try {
    const userId = req.session.user.id;
    if (!userId) {
      return res.status(401).json({ message: "Anda harus login" });
    }
    const janjiTemu = await janjiTemuService.getNextByUserId(userId);
    // Kirim janji temu (bisa jadi kosong/null jika tidak ada)
    res.json(janjiTemu);
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error" });
  }
};