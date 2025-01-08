package test

import (
	"context"

	"github.com/jmoiron/sqlx"
)

func test_sqlx(q sqlx.Ext) {
	var user User

	err := sqlx.Get(q, &user, "SELECT * FROM users WHERE id = 1") // $ source
	ignore(err)

	err = sqlx.Select(q, &user, "SELECT * FROM users WHERE id = 1") // $ source
	ignore(err)

	rows, err := sqlx.NamedQuery(q, "SELECT * FROM users WHERE id = :id", map[string]any{"id": 1}) // $ source
	ignore(err)

	var user2 User

	rows.StructScan(&user2)

	sink(user2) // $ hasTaintFlow="user2"
}

func test_sqlx_ctx(ctx context.Context, q sqlx.ExtContext) {
	var user User

	err := sqlx.GetContext(ctx, q, &user, "SELECT * FROM users WHERE id = 1") // $ source
	ignore(err)

	err = sqlx.SelectContext(ctx, q, &user, "SELECT * FROM users WHERE id = 1") // $ source
	ignore(err)

	rows, err := sqlx.NamedQueryContext(ctx, q, "SELECT * FROM users WHERE id = :id", map[string]any{"id": 1}) // $ source
	ignore(err)

	var user2 User

	rows.StructScan(&user2)

	sink(user2) // $ hasTaintFlow="user2"
}

func test_sqlx_Conn(conn *sqlx.Conn) {
	var user User
	conn.GetContext(nil, &user, "SELECT * FROM users WHERE id = 1") // $ source

	var user2 User
	conn.SelectContext(nil, &user2, "SELECT * FROM users WHERE id = 1") // $ source

	row := conn.QueryRowxContext(nil, "SELECT * FROM users WHERE id = 1") // $ source

	userMap := make(map[string]interface{})
	row.MapScan(userMap)
	id := userMap["id"].(int)
	sink(id) // $ hasTaintFlow="id"

	rows, err := conn.QueryxContext(nil, "SELECT * FROM users WHERE id = 1") // $ source
	ignore(err)

	for rows.Next() {
		var id int
		var name string
		err = rows.Scan(&id, &name)

		if err != nil {
			return
		}

		sink(id, name) // $ hasTaintFlow="id" hasTaintFlow="name"
	}
}

func test_sqlx_DB(db *sqlx.DB) {
	example, err := db.Query("SELECT * FROM users") // $ source
	ignore(example, err)

	rows, err := db.Queryx("SELECT * FROM users") // $ source

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

		valmap := make(map[string]interface{})
		rows.MapScan(valmap)

		id = valmap["id"].(int)
		sink(id) // $ hasTaintFlow="id"

		var user User
		rows.StructScan(&user)
		sink(user) // $ hasTaintFlow="user"
	}

	row := db.QueryRowx("SELECT * FROM users WHERE id = 1") // $ source

	userMap := make(map[string]interface{})
	row.MapScan(userMap)

	id := userMap["id"].(int)
	sink(id) // $ hasTaintFlow="id"

	var user User
	row.StructScan(&user)
	sink(user) // $ hasTaintFlow="user"

	var user2 User
	db.Get(&user2, "SELECT * FROM users WHERE id = 1") // $ source

	var user3 User
	db.GetContext(nil, &user3, "SELECT * FROM users WHERE id = 1") // $ source

	var user4 User
	rows, err = db.NamedQueryContext(nil, "SELECT * FROM users WHERE id = :id", map[string]any{"id": 1}) // $ source
	ignore(err)
	rows.StructScan(&user4)
	sink(user4) // $ hasTaintFlow="user4"

	var user5 User
	db.Select(&user5, "SELECT * FROM users WHERE id = 1") // $ source
}

func test_sqlx_NamedStmt(stmt *sqlx.NamedStmt) {
	example, err := stmt.Query("SELECT * FROM users") // $ source
	ignore(example, err)

	rows, err := stmt.Queryx("SELECT * FROM users") // $ source

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

		valmap := make(map[string]interface{})
		rows.MapScan(valmap)

		id = valmap["id"].(int)
		sink(id) // $ hasTaintFlow="id"

		var user User
		rows.StructScan(&user)
		sink(user) // $ hasTaintFlow="user"
	}

	row := stmt.QueryRowx("SELECT * FROM users WHERE id = 1") // $ source

	userMap := make(map[string]interface{})
	row.MapScan(userMap)

	id := userMap["id"].(int)
	sink(id) // $ hasTaintFlow="id"

	var user User
	row.StructScan(&user)
	sink(user) // $ hasTaintFlow="user"

	var user2 User
	stmt.Get(&user2, "SELECT * FROM users WHERE id = 1") // $ source

	var user3 User
	stmt.GetContext(nil, &user3, "SELECT * FROM users WHERE id = 1") // $ source

	var user4 User
	stmt.Select(&user4, "SELECT * FROM users WHERE id = 1") // $ source
}

func test_sqlx_Stmt(stmt *sqlx.Stmt) {
	example, err := stmt.Query("SELECT * FROM users") // $ source
	ignore(example, err)

	rows, err := stmt.Queryx("SELECT * FROM users") // $ source

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

		valmap := make(map[string]interface{})
		rows.MapScan(valmap)

		id = valmap["id"].(int)
		sink(id) // $ hasTaintFlow="id"

		var user User
		rows.StructScan(&user)
		sink(user) // $ hasTaintFlow="user"
	}

	row := stmt.QueryRowx("SELECT * FROM users WHERE id = 1") // $ source

	userMap := make(map[string]interface{})
	row.MapScan(userMap)

	id := userMap["id"].(int)
	sink(id) // $ hasTaintFlow="id"

	var user User
	row.StructScan(&user)
	sink(user) // $ hasTaintFlow="user"

	var user2 User
	stmt.Get(&user2, "SELECT * FROM users WHERE id = 1") // $ source

	var user3 User
	stmt.GetContext(nil, &user3, "SELECT * FROM users WHERE id = 1") // $ source

	var user4 User
	stmt.Select(&user4, "SELECT * FROM users WHERE id = 1") // $ source
}

func test_sqlx_Tx(tx *sqlx.Tx) {
	example, err := tx.Query("SELECT * FROM users") // $ source
	ignore(example, err)

	rows, err := tx.Queryx("SELECT * FROM users") // $ source

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

		valmap := make(map[string]interface{})
		rows.MapScan(valmap)

		id = valmap["id"].(int)
		sink(id) // $ hasTaintFlow="id"

		var user User
		rows.StructScan(&user)
		sink(user) // $ hasTaintFlow="user"
	}

	row := tx.QueryRowx("SELECT * FROM users WHERE id = 1") // $ source

	userMap := make(map[string]interface{})
	row.MapScan(userMap)

	id := userMap["id"].(int)
	sink(id) // $ hasTaintFlow="id"

	var user User
	row.StructScan(&user)
	sink(user) // $ hasTaintFlow="user"

	var user2 User
	tx.Get(&user2, "SELECT * FROM users WHERE id = 1") // $ source

	var user3 User
	tx.GetContext(nil, &user3, "SELECT * FROM users WHERE id = 1") // $ source

	var user4 User
	rows, err = tx.NamedQuery("SELECT * FROM users WHERE id = :id", map[string]any{"id": 1}) // $ source
	ignore(err)
	rows.StructScan(&user4)
	sink(user4) // $ hasTaintFlow="user4"

	var user5 User
	tx.Select(&user5, "SELECT * FROM users WHERE id = 1") // $ source
}
