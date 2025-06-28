// src/models/passwordResetTokenModel.js

const db = require('./db');

// Membuat atau memperbarui token untuk sebuah email
exports.create = async (email, tokenHash, expiresAt) => {
  // Hapus token lama untuk email yang sama jika ada, agar tidak duplikat
  await db.query('DELETE FROM password_reset_tokens WHERE email = ?', [email]);
  
  // Simpan token yang baru
  const [result] = await db.query(
    'INSERT INTO password_reset_tokens (email, token, expires_at) VALUES (?, ?, ?)',
    [email, tokenHash, expiresAt]
  );
  return result.insertId;
};

// Mencari token berdasarkan email
exports.findByEmail = async (email) => {
  const [rows] = await db.query('SELECT * FROM password_reset_tokens WHERE email = ?', [email]);
  return rows[0];
};

// Menghapus token setelah digunakan
exports.deleteByEmail = async (email) => {
  await db.query('DELETE FROM password_reset_tokens WHERE email = ?', [email]);
};