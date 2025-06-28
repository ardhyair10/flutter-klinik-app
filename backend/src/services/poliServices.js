const db = require('../models/db');

const getPoli = async () => {
  const [rows] = await db.query('SELECT * FROM poli');
  return rows.length > 0 ? rows[0] : null;
};

module.exports = {
  getPoli
};
