// src/models/janjiTemuModel.js
const db = require('./db');

exports.create = async (data) => {
  // === PERBAIKAN DI SINI: tambahkan dokterId di dalam kurung kurawal ===
  const { userId, poliId, dokterId, tanggal, waktu, keluhan } = data;

  try {
    console.log('[Model] Data yang siap untuk di-INSERT:', { userId, poliId, dokterId, tanggal, waktu, keluhan });
    
    // Pastikan urutan dan jumlah '?' cocok dengan parameter di bawah
    const [result] = await db.query(
      'INSERT INTO janji_temu (user_id, poli_id, dokter_id, tanggal, waktu, keluhan) VALUES (?, ?, ?, ?, ?, ?)',
      [userId, poliId, dokterId, tanggal, waktu, keluhan]
    );
    
    console.log('[Model] Query INSERT berhasil, ID baru:', result.insertId);
    return { id: result.insertId };
  } catch (sqlError) {
    console.error("❌ DATABASE ERROR di janjiTemuModel.create:", sqlError);
    throw sqlError;
  }
};

exports.findByUserId = async (userId) => {
  const query = `
    SELECT 
      jt.id, 
      jt.tanggal, 
      jt.waktu, 
      jt.keluhan, 
      jt.status, 
      p.nama_poli,
      d.nama_dokter 
    FROM janji_temu jt
    JOIN poli p ON jt.poli_id = p.id_poli
    JOIN dokter d ON jt.dokter_id = d.id
    WHERE jt.user_id = ?
    ORDER BY jt.tanggal DESC, jt.waktu DESC
  `;
  const [rows] = await db.query(query, [userId]);
  return rows;
};
exports.findNextByUserId = async (userId) => {
  // Query ini mengambil 1 janji temu yang tanggalnya hari ini atau di masa depan,
  // lalu diurutkan dari yang paling dekat.
  const query = `
    SELECT 
      jt.id, jt.tanggal, jt.waktu, jt.keluhan, jt.status, 
      p.nama_poli, d.nama_dokter 
    FROM janji_temu jt
    JOIN poli p ON jt.poli_id = p.id_poli
    JOIN dokter d ON jt.dokter_id = d.id
    WHERE jt.user_id = ? AND jt.tanggal >= CURDATE()
    ORDER BY jt.tanggal ASC, jt.waktu ASC
    LIMIT 1
  `;
  const [rows] = await db.query(query, [userId]);
  return rows[0]; // Mengembalikan satu data, atau undefined jika tidak ada
};