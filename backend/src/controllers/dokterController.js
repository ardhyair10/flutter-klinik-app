const dokterService = require('../services/dokterService');

exports.getDokterByPoliId = async (req, res) => {
  try {
    // Ambil poliId dari parameter URL, contoh: /dokter/poli/2
    const poliId = req.params.poliId;
    const dokterList = await dokterService.getByPoliId(poliId);
    res.json(dokterList);
  } catch (error) {
    console.error("Error di dokterController:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};