// Adapted from https://github.com/tediousjs/node-mssql#readme
const sql = require('mssql')
 
async () => {
    try {
        const pool = await sql.connect('mssql://username:password@localhost/database')
        const result = await sql.query`select * from mytable where id = ${value}`
        console.dir(result)

        sql.query('SELECT 123');
    } catch (err) {
        // ... error checks 
    }
}
