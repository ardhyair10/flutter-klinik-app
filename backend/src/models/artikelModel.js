const db = require('./db');

exports.findAll = async () => {
  // Hanya ambil id dan judul untuk daftar
  const [rows] = await db.query('SELECT id, judul FROM artikel ORDER BY created_at DESC');
  return rows;
};

exports.findById = async (id) => {
  // Ambil semua data untuk halaman detail
  const [rows] = await db.query('SELECT * FROM artikel WHERE id = ?', [id]);
  return rows[0];
};