// src/services/janjiTemuService.js
const janjiTemuModel = require('../models/janjiTemuModel');

exports.create = async (data) => {
  console.log("[Service] Menerima data dari controller, meneruskan ke model:", data);
  const janjiBaru = await janjiTemuModel.create(data);
  return janjiBaru;
};
// --- TAMBAHAN FUNGSI BARU ---
exports.getByUserId = async (userId) => {
  const riwayat = await janjiTemuModel.findByUserId(userId);
  return riwayat;
};
exports.getNextByUserId = async (userId) => {
  return await janjiTemuModel.findNextByUserId(userId);
};