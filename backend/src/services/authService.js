// src/services/authService.js

const userModel = require('../models/userModel');
const passwordResetTokenModel = require('../models/passwordResetTokenModel');
const emailService = require('./emailService'); // <-- PASTIKAN BARIS INI ADA
const bcrypt = require('bcryptjs');

// Fungsi Login
exports.login = async (username, password) => {
  const user = await userModel.findByUsername(username);
  if (!user) {
    console.log(`[AuthService - Login] User tidak ditemukan untuk username: ${username}`);
    return { success: false, message: 'Username atau password salah' };
  }
  console.log(`[AuthService - Login] User ditemukan: ${user.username}, ID: ${user.user_id}, Email: ${user.email}`);
  console.log(`[AuthService - Login] Password dari input: '${password}'`); // Log raw password
  console.log(`[AuthService - Login] process.env.PASSWORD_PEPPER: '${process.env.PASSWORD_PEPPER}'`);

  const pepperedPassword = password + process.env.PASSWORD_PEPPER;
  console.log(`[AuthService - Login] Password di-pepper: '${pepperedPassword}'`);
  console.log(`[AuthService - Login] Hash tersimpan di DB (user.password): '${user.password}'`);

  const isMatch = await bcrypt.compare(pepperedPassword, user.password);
  if (!isMatch) {
    console.log(`[AuthService - Login] bcrypt.compare hasilnya: GAGAL (password tidak cocok)`);
    return { success: false, message: 'Username atau password salah' };
  }
  console.log(`[AuthService - Login] bcrypt.compare hasilnya: SUKSES (password cocok)`);

  return {
    success: true,
    user: {
      id: user.user_id,
      nama_depan: user.nama_depan, // Kirim nama_depan
      nama_belakang: user.nama_belakang, // Kirim nama_belakang (bisa null jika memang begitu dari DB)
      username: user.username,
      role: user.role,
    },
  };
};


// Fungsi untuk meminta reset password
exports.requestPasswordReset = async (email) => {
  const user = await userModel.findByEmail(email);
  if (!user) {
    console.log(`Permintaan reset untuk email tidak terdaftar: ${email}. Mengirim respon generik.`);
    return;
  }

  const otp = Math.floor(100000 + Math.random() * 900000).toString();
  console.log(`Generated Password Reset OTP for ${email}: ${otp}`);

  const otpHash = await bcrypt.hash(otp, 10);
  const expiresAt = new Date(Date.now() + 10 * 60 * 1000); // Berlaku 10 menit

  await passwordResetTokenModel.create(email, otpHash, expiresAt);
  
  // Baris ini sekarang akan berjalan tanpa error
  await emailService.sendPasswordResetOtp(email, otp);
};
// --- TAMBAHAN FUNGSI BARU ---
exports.resetPasswordWithOtp = async (email, otp, newPassword) => {
  console.log(`[AuthService] Memulai verifikasi untuk email: ${email}`);
  
  // 1. Cari data OTP di database
  const otpData = await passwordResetTokenModel.findByEmail(email);
  if (!otpData) throw new Error('Permintaan reset tidak valid atau sudah kedaluwarsa.');
  console.log("[AuthService] Data OTP ditemukan:", otpData);

  // 2. Cek apakah sudah kedaluwarsa
  if (new Date() > new Date(otpData.expires_at)) {
    await passwordResetTokenModel.deleteByEmail(email);
    throw new Error('Kode OTP sudah kedaluwarsa.');
  }
  console.log("[AuthService] OTP belum kedaluwarsa.");

  // 3. Bandingkan OTP yang diinput dengan hash di DB
  const isOtpMatch = await bcrypt.compare(otp, otpData.token);
  console.log(`[AuthService] Hasil perbandingan OTP (isOtpMatch): ${isOtpMatch}`);
  if (!isOtpMatch) throw new Error('Kode OTP salah.');

  // 4. Jika cocok, hash password baru
  console.log("[AuthService] OTP cocok. Menyiapkan hash untuk password baru...");
  const pepperedPassword = newPassword + process.env.PASSWORD_PEPPER;
  const hashedPassword = await bcrypt.hash(pepperedPassword, 10);
  console.log("[AuthService] Hash password baru dibuat:", hashedPassword);

  // 5. Update password user di tabel utama
  console.log("[AuthService] Memanggil userModel.updatePassword...");
  const updateResult = await userModel.updatePassword(email, hashedPassword);
  // --- PERIKSA HASIL UPDATE ---
  if (!updateResult || updateResult.affectedRows === 0) {
    console.error(`[AuthService] GAGAL mengupdate password di DB untuk email: ${email}. AffectedRows: ${updateResult ? updateResult.affectedRows : 'null'}`);
    throw new Error('Gagal memperbarui password di database. Silakan coba lagi atau hubungi administrator.');
  }
  console.log(`[AuthService] SUKSES mengupdate password di DB untuk email: ${email}. AffectedRows: ${updateResult.affectedRows}`);
  // --------------------------


  // 6. Hapus token OTP agar tidak bisa digunakan lagi
  await passwordResetTokenModel.deleteByEmail(email);
  console.log(`[AuthService] Token OTP untuk email ${email} telah dihapus.`);

  return { success: true, message: 'Password berhasil direset.' };
};