package test

//go:generate depstubber -vendor github.com/uptrace/bun Conn,DB,RawQuery,SelectQuery,Tx

import (
	"context"

	"github.com/uptrace/bun"
)

func Test_bun_conn(conn bun.Conn) {
	ctx := context.Background()

	rows1, _ := conn.QueryContext(ctx, "SELECT * FROM users") // $ source
	conn.QueryRowContext(ctx, "SELECT * FROM users")          // $ source

	ignore(rows1)
}

func Test_bun_db(db bun.DB) {
	ctx := context.Background()

	rows1, _ := db.Query("SELECT * FROM users") // $ source

	for rows1.Next() {
		var user User
		db.ScanRow(ctx, rows1, &user)
		sink(user) // $ hasTaintFlow="user"
	}

	rows2, _ := db.QueryContext(ctx, "SELECT * FROM users") // $ source
	var users []User

	db.ScanRows(ctx, rows2, &users)
	sink(users) // $ hasTaintFlow="users"

	db.QueryRow("SELECT * FROM users")             // $ source
	db.QueryRowContext(ctx, "SELECT * FROM users") // $ source
}

func Test_bun_rawquery(q bun.RawQuery) {
	ctx := context.Background()

	var u1 []User
	q.Exec(ctx, &u1) // $ source
	var u2 []User
	q.Scan(ctx, &u2) // $ source
}

func Test_bun_selectquery(q bun.SelectQuery) {
	ctx := context.Background()

	rows, _ := q.Rows(ctx) // $ source
	var u1 []User
	q.Exec(ctx, &u1) // $ source
	var u2 []User
	q.Model(&u2).Scan(ctx) // $ source
	var u3 map[string]interface{}
	q.Scan(ctx, &u3) // $ source
	var u4 []User
	q.Model(&u4).ScanAndCount(ctx) // $ source
	var u5 map[string]interface{}
	q.ScanAndCount(ctx, &u5) // $ source

	ignore(rows)
}

func Test_bun_tx(tx bun.Tx) {
	ctx := context.Background()

	rows1, _ := tx.Query("SELECT * FROM users")             // $ source
	rows2, _ := tx.QueryContext(ctx, "SELECT * FROM users") // $ source
	tx.QueryRow("SELECT * FROM users")                      // $ source
	tx.QueryRowContext(ctx, "SELECT * FROM users")          // $ source

	ignore(rows1, rows2)
}
