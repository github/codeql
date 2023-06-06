const app = require("express")(),
      pg = require("pg"),
      SqlString = require('sqlstring'),
      pool = new pg.Pool(config);

app.get("search", function handler(req, res) {
  // GOOD: the category is escaped using mysql.escape
  var query1 =
    "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='" +
    SqlString.escape(req.params.category) +
    "' ORDER BY PRICE";
  pool.query(query1, [], function(err, results) {
    // process results
  });
});
