const pgp = require('pg-promise')();

require('express')().get('/foo', (req, res) => {
  const db = pgp(process.env['DB_CONNECTION_STRING']);

  var query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
             + req.params.category + "' ORDER BY PRICE";
  
  db.any(query); // NOT OK
  db.many(query); // NOT OK
  db.manyOrNone(query); // NOT OK
  db.map(query); // NOT OK
  db.multi(query); // NOT OK
  db.multiResult(query); // NOT OK
  db.none(query); // NOT OK
  db.one(query); // NOT OK
  db.oneOrNone(query); // NOT OK
  db.query(query); // NOT OK
  db.result(query); // NOT OK
  
  db.one({
    text: query // NOT OK
  });
  db.one({
    text: 'SELECT * FROM news where id = $1', // OK
    values: req.params.id, // OK
  });
  db.one({
    text: 'SELECT * FROM news where id = $1:raw',
    values: req.params.id, // NOT OK - interpreted as raw parameter
  });
  db.one({
    text: 'SELECT * FROM news where id = $1^',
    values: req.params.id, // NOT OK
  });
  db.one({
    text: 'SELECT * FROM news where id = $1:raw AND name = $2:raw AND foo = $3',
    values: [
      req.params.id, // NOT OK
      req.params.name, // NOT OK
      req.params.foo, // OK - not using raw interpolation
    ]
  });
  db.one({
    text: 'SELECT * FROM news where id = ${id}:raw AND name = ${name}',
    values: {
      id: req.params.id, // NOT OK
      name: req.params.name, // OK - not using raw interpolation
    }
  });
  db.one({
    text: "SELECT * FROM news where id = ${id}:value AND name LIKE '%${name}:value%' AND title LIKE \"%${title}:value%\"",
    values: {
      id: req.params.id, // NOT OK
      name: req.params.name, // OK - :value cannot break out of single quotes
      title: req.params.title, // NOT OK - enclosed by wrong type of quote
    }
  });
  db.task(t => {
      return t.one(query); // NOT OK
  });
  db.task(
    { cnd: t => t.one(query) }, // NOT OK
    t => t.one(query) // NOT OK
  );
});
