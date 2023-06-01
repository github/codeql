const app = require("express")(),
      pg = require("pg"),
      pool = new pg.Pool(config);

app.get("search", function handler(req, res) {
  // GOOD: use parameters
  var query2 =
    "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY=$1 ORDER BY PRICE";
  pool.query(query2, [req.params.category], function(err, results) {
    // process results
  });
});
