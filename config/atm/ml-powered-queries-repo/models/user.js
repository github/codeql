const mongoose = require('mongoose');

module.exports.User = mongoose.model('User', new mongoose.Schema({
  name: String,
  token: String
}));
