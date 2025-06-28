const artikelService = require('../services/artikelService');

exports.getAllArtikel = async (req, res) => {
  try {
    const artikel = await artikelService.getAll();
    res.json(artikel);
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.getArtikelById = async (req, res) => {
  try {
    const artikel = await artikelService.getById(req.params.id);
    if (artikel) {
      res.json(artikel);
    } else {
      res.status(404).json({ message: "Artikel tidak ditemukan" });
    }
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error" });
  }
};