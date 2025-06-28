const resepObatService = require('../services/resepObatService');

exports.getResepObatByUserId = async (req, res) => {
  try {
    const userId = req.session.user.id;
    if (!userId) {
      return res.status(401).json({ message: "Anda harus login" });
    }
    const resep = await resepObatService.getByUserId(userId);
    res.json(resep);
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error" });
  }
};