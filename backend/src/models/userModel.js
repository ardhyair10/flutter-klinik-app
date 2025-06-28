const db = require('../models/db');

// Fungsi untuk mencari user berdasarkan username
// Pastikan diawali dengan 'exports.'
exports.findByUsername = async (username) => {
  const [rows] = await db.query('SELECT * FROM user WHERE username = ?', [username]);
  return rows[0];
};

// Fungsi untuk mencari user berdasarkan email
// Pastikan diawali dengan 'exports.'
exports.findByEmail = async (email) => {
  const [rows] = await db.query('SELECT * FROM user WHERE email = ?', [email]);
  return rows[0];
};

// Fungsi untuk membuat user baru
// Pastikan diawali dengan 'exports.'
exports.createUser = async (userData) => {
 const { nama_depan, nama_belakang, username, email, password, role, jenis_kelamin, ttl } = userData;
   const [result] = await db.query(
    // Tambahkan kolom 'ttl' dan 'jenis_kelamin' ke query
    'INSERT INTO user (nama_depan, nama_belakang, username, email, password, role, jenis_kelamin, ttl) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
    [nama_depan, nama_belakang || null, username, email, password, role, jenis_kelamin, ttl || null]
  );
  return { id: result.insertId, ...userData };
};

// Fungsi untuk mengambil semua data user
// Pastikan diawali dengan 'exports.'
exports.findAll = async () => {
  const [rows] = await db.query('SELECT user_id, nama_depan, nama_belakang, username, email, role, ttl FROM user');
  return rows;
};

// Fungsi untuk mengambil satu user berdasarkan ID
// Pastikan diawali dengan 'exports.'
exports.findById = async (id) => {
  const [rows] = await db.query('SELECT user_id, nama_depan, nama_belakang, username, email, role, ttl FROM user WHERE user_id = ?', [id]);
  return rows[0];
};
exports.updatePassword = async (email, hashedPassword) => {
  // --- LOG DI SINI ---
  console.log(`[UserModel] Menjalankan query UPDATE password untuk email: ${email}`);
  
  const [result] = await db.query(
    'UPDATE user SET password = ? WHERE email = ?',
    [hashedPassword, email]
  );
  
  console.log('[UserModel] Hasil query UPDATE:', result);
  return result;
};
// Pastikan TIDAK ADA baris "module.exports = ..." lain di file ini.