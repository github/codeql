const pg = require('pg');

function PgWrapper() {
    this.pool = new pg.Pool({});
}

PgWrapper.prototype.query = function (query, params, cb) {
    this.pool.query(query, params || [], cb);
};
