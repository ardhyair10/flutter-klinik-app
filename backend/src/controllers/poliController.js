const db = require('../models/db');

exports.getPoli = async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM poli');
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Internal Server Error' });
  }
}