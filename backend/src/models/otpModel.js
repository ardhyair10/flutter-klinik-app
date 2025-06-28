// src/models/otpModel.js
const db = require('./db');

exports.create = async (email, otpHash, userData, expiresAt) => {
  // Hapus OTP lama untuk email yang sama jika ada
  await db.query('DELETE FROM otp_verifications WHERE email = ?', [email]);
  
  // Simpan data baru
  const [result] = await db.query(
    'INSERT INTO otp_verifications (email, otp_hash, user_data, expires_at) VALUES (?, ?, ?, ?)',
    [email, otpHash, JSON.stringify(userData), expiresAt]
  );
  return result.insertId;
};

exports.findByEmail = async (email) => {
  const [rows] = await db.query('SELECT * FROM otp_verifications WHERE email = ?', [email]);
  return rows[0];
};

exports.deleteByEmail = async (email) => {
  await db.query('DELETE FROM otp_verifications WHERE email = ?', [email]);
};

exports.deleteExpiredOtps = async () => {
  // NOW() adalah fungsi SQL untuk mendapatkan waktu saat ini
  const [result] = await db.query('DELETE FROM otp_verifications WHERE expires_at < NOW()');
  return result;
};