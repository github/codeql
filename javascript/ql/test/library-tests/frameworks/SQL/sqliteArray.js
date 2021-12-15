var sqlite = require('sqlite3');

let databaseNames = [":memory:", ":foo:"];
let databases = databaseNames.map(name => new sqlite.Database(name));
for (let db of databases) {
    db.run("UPDATE tbl SET name = ? WHERE id = ?", "bar", 2);
}
