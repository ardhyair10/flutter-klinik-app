// src/models/dokterModel.js
const db = require('./db');

exports.findByPoliId = async (poliId) => {
  const [rows] = await db.query('SELECT * FROM dokter WHERE poli_id = ?', [poliId]);
  return rows;
};