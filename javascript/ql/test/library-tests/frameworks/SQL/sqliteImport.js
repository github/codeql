const { db } = require('./sqlite');
db.run("UPDATE foo SET bar = ? WHERE id = ?", "bar", 2);
