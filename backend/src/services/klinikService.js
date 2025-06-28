const klinikModel = require('../models/klinikModel');

exports.getAll = async () => {
  return await klinikModel.findAll();
};