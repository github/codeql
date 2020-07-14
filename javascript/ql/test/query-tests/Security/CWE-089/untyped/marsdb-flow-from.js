const MarsDB = require("marsdb");

const myDoc = new MarsDB.Collection("myDoc");

const db = {
  myDoc
};

module.exports = db;
