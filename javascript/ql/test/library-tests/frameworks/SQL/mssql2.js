// Adapted from https://github.com/tediousjs/node-mssql#readme
const sql = require('mssql')
 
const request = new sql.Request()
request.query('select 1 as number', (err, result) => {
    // ... error checks

    console.log(result.recordset[0].number) // return 1

    // ...
})

request.batch('create procedure #temporary as select * from table', (err, result) => {
    // ... error checks
})

class C {
    constructor(req) {
        this.req = req;
    }
    send() {
        this.req.query('select 1 as number', (err, result) => {})
    }
}
new C(new sql.Request());
