const klinikService = require('../services/klinikService');

exports.getAllKlinik = async (req, res) => {
  try {
    const klinikList = await klinikService.getAll();
    res.json(klinikList);
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error" });
  }
};