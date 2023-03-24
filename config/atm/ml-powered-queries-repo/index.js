const startApp = require('./app').startApp;

Logger = require('./logger').Logger;
Note = require('./models/note').Note;
User = require('./models/user').User;

startApp();
