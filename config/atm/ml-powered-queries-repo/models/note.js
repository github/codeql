const mongoose = require('mongoose');

module.exports.Note = mongoose.model('Note', new mongoose.Schema({
  title: String,
  body: String,
  ownerToken: String,
  isPublic: Boolean
}));
