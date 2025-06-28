const dokterModel = require('../models/dokterModel');

exports.getByPoliId = async (poliId) => {
  const dokterList = await dokterModel.findByPoliId(poliId);
  return dokterList;
};