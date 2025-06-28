const db = require('./db');

exports.findByUserId = async (userId) => {
  const query = `
    SELECT 
      r.id,
      r.tanggal_resep,
      r.detail_obat,
      p.nama_poli,
      d.nama_dokter
    FROM resep_obat r
    JOIN janji_temu jt ON r.janji_temu_id = jt.id
    JOIN poli p ON jt.poli_id = p.id_poli
    JOIN dokter d ON jt.dokter_id = d.id
    WHERE jt.user_id = ?
    ORDER BY r.tanggal_resep DESC
  `;
  const [rows] = await db.query(query, [userId]);
  return rows;
};