const db = require('./db');

// Mengambil semua poli
exports.findAll = async () => {
  const [rows] = await db.query('SELECT * FROM poli ORDER BY nama_poli ASC');
  return rows;
};

// Menambah poli baru
exports.create = async (poli) => {
  const { nama_poli, deskripsi_poli } = poli;
  const [result] = await db.query('INSERT INTO poli (nama_poli, deskripsi_poli) VALUES (?, ?)', [nama_poli, deskripsi_poli]);
  return { id: result.insertId, ...poli };
};

// Mengubah poli
exports.update = async (id, poli) => {
  const { nama_poli, deskripsi_poli } = poli;
  await db.query('UPDATE poli SET nama_poli = ?, deskripsi_poli = ? WHERE id_poli = ?', [nama_poli, deskripsi_poli, id]);
  return { id, ...poli };
};

// Menghapus poli
exports.remove = async (id) => {
  await db.query('DELETE FROM poli WHERE id_poli = ?', [id]);
  return { message: 'Poli berhasil dihapus' };
};