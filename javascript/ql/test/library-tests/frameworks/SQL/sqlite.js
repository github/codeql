import sqlite3 from 'sqlite3'
import { open } from 'sqlite'

open({
  filename: 'database.sqlite',
  driver: sqlite3.Database
}).then(async (db) => {
  db.get('SELECT name,id FROM table1 WHERE id > 5' + " OR id = 1").then(results => {
    console.log(results)
  })
  db.all('SELECT name,id FROM table1 WHERE id > 5' + " OR id = 1").then(results => {
    console.log(results)
  })
  db.run('SELECT name,id FROM table1 WHERE id > 5').then(results => {
    console.log(results)
  })
  db.prepare('SELECT name,id FROM table1 WHERE id > 5'
    + " OR id = 1").then(results => {
      results.all().then(result => {
        console.log(result)
      })
    })
  try {
    await db.each('SELECT name,id FROM table1 WHERE id > 5' + " OR id = 1", (err, row) => {
      console.log(row)
    })

  } catch (e) {
    throw e
  }
})


