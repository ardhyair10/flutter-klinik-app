const artikelModel = require('../models/artikelModel');

exports.getAll = async () => {
  return await artikelModel.findAll();
};

exports.getById = async (id) => {
  return await artikelModel.findById(id);
};