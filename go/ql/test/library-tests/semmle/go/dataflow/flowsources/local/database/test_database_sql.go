package test

import (
	"database/sql"
)

// test querying a Conn
func testConnQuery(conn *sql.Conn) {
	rows, err := conn.QueryContext(nil, "SELECT * FROM users") // $ source

	if err != nil {
		return
	}

	defer rows.Close()

	for rows.Next() {
		var id int
		var name string
		err = rows.Scan(&id, &name)
		if err != nil {
			return
		}

		sink(id, name) // $ hasTaintFlow="id" hasTaintFlow="name"
	}

	row := conn.QueryRowContext(nil, "SELECT * FROM users WHERE id = 1") // $ source

	var id int
	var name string

	err = row.Scan(&id, &name)

	sink(id, name) // $ hasTaintFlow="id" hasTaintFlow="name"
}

// test querying a DB
func testDBQuery(db *sql.DB) {
	example, err := db.Query("SELECT * FROM users") // $ source
	ignore(example)

	rows, err := db.QueryContext(nil, "SELECT * FROM users") // $ source

	if err != nil {
		return
	}

	defer rows.Close()

	for rows.Next() {
		var id int
		var name string
		err = rows.Scan(&id, &name)

		if err != nil {
			return
		}

		sink(id, name) // $ hasTaintFlow="id" hasTaintFlow="name"
	}

	row := db.QueryRowContext(nil, "SELECT * FROM users WHERE id = 1") // $ source

	var id int
	var name string

	err = row.Scan(&id, &name)

	sink(id, name) // $ hasTaintFlow="id" hasTaintFlow="name"

	dog := db.QueryRow("SELECT * FROM dogs WHERE id = 1") // $ source
	ignore(dog)
}

// test querying a Stmt
func testStmtQuery(stmt *sql.Stmt) {
	example, err := stmt.Query("SELECT * FROM users") // $ source
	ignore(example)

	rows, err := stmt.QueryContext(nil, "SELECT * FROM users") // $ source

	if err != nil {
		return
	}

	defer rows.Close()

	for rows.Next() {
		var id int
		var name string
		err = rows.Scan(&id, &name)

		if err != nil {
			return
		}

		sink(id, name) // $ hasTaintFlow="id" hasTaintFlow="name"
	}

	row := stmt.QueryRowContext(nil, "SELECT * FROM users WHERE id = 1") // $ source

	var id int
	var name string

	err = row.Scan(&id, &name)

	if err != nil {
		return
	}

	sink(id, name) // $ hasTaintFlow="id" hasTaintFlow="name"

	dog := stmt.QueryRow("SELECT * FROM dogs WHERE id = 1") // $ source
	ignore(dog)
}

// test querying a Tx
func testTxQuery(tx *sql.Tx) {
	example, err := tx.Query("SELECT * FROM users") // $ source
	ignore(example)

	rows, err := tx.QueryContext(nil, "SELECT * FROM users") // $ source
	if err != nil {
		return
	}

	defer rows.Close()

	for rows.Next() {
		var id int
		var name string
		err = rows.Scan(&id, &name)

		if err != nil {
			return
		}

		sink(id, name) // $ hasTaintFlow="id" hasTaintFlow="name"
	}

	row := tx.QueryRowContext(nil, "SELECT * FROM users WHERE id = 1") // $ source

	var id int
	var name string

	err = row.Scan(&id, &name)

	if err != nil {
		return
	}

	sink(id, name) // $ hasTaintFlow="id" hasTaintFlow="name"

	dog := tx.QueryRow("SELECT * FROM dogs WHERE id = 1") // $ source
	ignore(dog)
}
