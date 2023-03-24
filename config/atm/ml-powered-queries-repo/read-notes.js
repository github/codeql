const mongoose = require('mongoose');

Logger = require('./logger').Logger;
Note = require('./models/note').Note;
User = require('./models/user').User;

(async () => {
  if (process.argv.length != 3) {
    Logger.log("Outputs all notes visible to a user.  Usage: node read-notes.js <token>")
    return;
  }

  // Open the default mongoose connection
  await mongoose.connect('mongodb://localhost:27017/notes', { useFindAndModify: false });

  const ownerToken = process.argv[2];

  const user = await User.findOne({
    token: ownerToken
  }).exec();

  const notes = await Note.find({
    $or: [
      { isPublic: true },
      { ownerToken }
    ]
  }).exec();

  notes.map(note => {
    Logger.log("Title:" + note.title);
    Logger.log("By:" + user.name);
    Logger.log("Body:" + note.body);
    Logger.log();
  });

  await mongoose.connection.close();
})();
