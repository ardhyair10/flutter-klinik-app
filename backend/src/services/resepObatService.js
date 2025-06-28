const resepObatModel = require('../models/resepObatModel');

exports.getByUserId = async (userId) => {
  return await resepObatModel.findByUserId(userId);
};