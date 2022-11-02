const mongoose = require('mongoose');

Logger = require('./logger').Logger;
Note = require('./models/note').Note;

(async () => {
  if (process.argv.length != 5) {
    Logger.log("Creates a private note.  Usage: node add-note.js <token> <title> <body>")
    return;
  }

  // Open the default mongoose connection
  await mongoose.connect('mongodb://localhost:27017/notes', { useFindAndModify: false });

  const [userToken, title, body] = process.argv.slice(2);
  await Note.create({ title, body, userToken });

  Logger.log(`Created private note with title ${title} and body ${body} belonging to user with token ${userToken}.`);

  await mongoose.connection.close();
})();
