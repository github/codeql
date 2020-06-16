let dbClient = require("mongodb").MongoClient,
  db = null;
module.exports = {
  db: () => {
    return db;
  },
  connect: fn => {
    dbClient.connect(process.env.DB_URL, {}, (err, client) => {
      db = client.db(process.env.DB_NAME);
      return fn(err);
    });
  }
};
