const pgp = require('pg-promise')();

require('express')().get('/foo', (req, res) => {
  const db = pgp(process.env['DB_CONNECTION_STRING']);

  var query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
             + req.params.category + "' ORDER BY PRICE"; // $ Source

  db.any(query); // $ Alert
  db.many(query); // $ Alert
  db.manyOrNone(query); // $ Alert
  db.map(query); // $ Alert
  db.multi(query); // $ Alert
  db.multiResult(query); // $ Alert
  db.none(query); // $ Alert
  db.one(query); // $ Alert
  db.oneOrNone(query); // $ Alert
  db.query(query); // $ Alert
  db.result(query); // $ Alert

  db.one({
    text: query // $ Alert
  });
  db.one({
    text: 'SELECT * FROM news where id = $1',
    values: req.params.id,
  });
  db.one({
    text: 'SELECT * FROM news where id = $1:raw',
    values: req.params.id, // $ Alert - interpreted as raw parameter
  });
  db.one({
    text: 'SELECT * FROM news where id = $1^',
    values: req.params.id, // $ Alert
  });
  db.one({
    text: 'SELECT * FROM news where id = $1:raw AND name = $2:raw AND foo = $3',
    values: [
      req.params.id, // $ Alert
      req.params.name, // $ Alert
      req.params.foo, // OK - not using raw interpolation
    ]
  });
  db.one({
    text: 'SELECT * FROM news where id = ${id}:raw AND name = ${name}',
    values: {
      id: req.params.id, // $ Alert
      name: req.params.name, // OK - not using raw interpolation
    }
  });
  db.one({
    text: "SELECT * FROM news where id = ${id}:value AND name LIKE '%${name}:value%' AND title LIKE \"%${title}:value%\"",
    values: {
      id: req.params.id, // $ Alert
      name: req.params.name, // OK - :value cannot break out of single quotes
      title: req.params.title, // $ Alert - enclosed by wrong type of quote
    }
  });
  db.task(t => {
      return t.one(query); // $ Alert
  });
  db.taskIf(
    { cnd: t => t.one(query) }, // $ Alert
    t => t.one(query) // $ Alert
  );
});
