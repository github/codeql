const pg = require('pg');
const pool = new pg.Pool(config);

function handler(req, res) {
  // BAD: the category might have SQL special characters in it
  var query1 = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
             + req.params.category + "' ORDER BY PRICE";
  pool.query(query1, [], function(err, results) {
    // process results
  });

  // GOOD: use parameters
  var query2 = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY=$1"
             + " ORDER BY PRICE";
  pool.query(query2, [req.params.category], function(err, results) {
      // process results
  });
}
