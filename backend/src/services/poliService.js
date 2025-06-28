const poliModel = require('../models/poliModel');
exports.getAll = async () => await poliModel.findAll();
exports.create = async (poli) => await poliModel.create(poli);
exports.update = async (id, poli) => await poliModel.update(id, poli);
exports.remove = async (id) => await poliModel.remove(id);