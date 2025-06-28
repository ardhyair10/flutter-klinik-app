// src/scheduler.js

const cron = require('node-cron');
const otpModel = require('../models/otpModel'); // <-- PATH SUDAH DIPERBAIKI

// Fungsi untuk memulai semua tugas terjadwal
const start = () => {
  console.log('🕒 Penjadwal tugas diaktifkan.');

  // Jadwalkan tugas untuk berjalan setiap jam
  cron.schedule('0 * * * *', async () => {
    console.log('⏰ Menjalankan tugas pembersihan OTP kedaluwarsa...');
    try {
      const result = await otpModel.deleteExpiredOtps();
      if (result.affectedRows > 0) {
        console.log(`✅ Berhasil membersihkan ${result.affectedRows} OTP yang kedaluwarsa.`);
      } else {
        console.log('🧹 Tidak ada OTP kedaluwarsa yang perlu dibersihkan.');
      }
    } catch (error) {
      console.error('❌ Gagal menjalankan tugas pembersihan OTP:', error);
    }
  });
};

module.exports = { start };