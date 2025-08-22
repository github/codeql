package main

//go:generate depstubber -vendor github.com/Masterminds/squirrel DeleteBuilder,InsertBuilder,SelectBuilder,UpdateBuilder Delete,Expr,Insert,Select,Update

import (
	"context"
	"database/sql"
)

var (
	query1  string
	query2  string
	query3  string
	query4  string
	query5  string
	query6  string
	query7  string
	query8  string
	query11 string
	query12 string
	query13 string
	query14 string
	query15 string
	query16 string
	query17 string
	query18 string
	query21 string
	query22 string
	query23 string
)

func test(db *sql.DB, ctx context.Context) {
	db.Exec(query1)                 // $ query=query1
	db.ExecContext(ctx, query2)     // $ query=query2
	db.Prepare(query3)              // $ querystring=query3
	db.PrepareContext(ctx, query4)  // $ querystring=query4
	db.Query(query5)                // $ query=query5
	db.QueryContext(ctx, query6)    // $ query=query6
	db.QueryRow(query7)             // $ query=query7
	db.QueryRowContext(ctx, query8) // $ query=query8
}

func test2(tx *sql.Tx, query string, ctx context.Context) {
	tx.Exec(query11)                 // $ query=query11
	tx.ExecContext(ctx, query12)     // $ query=query12
	tx.Prepare(query13)              // $ querystring=query13
	tx.PrepareContext(ctx, query14)  // $ querystring=query14
	tx.Query(query15)                // $ query=query15
	tx.QueryContext(ctx, query16)    // $ query=query16
	tx.QueryRow(query17)             // $ query=query17
	tx.QueryRowContext(ctx, query18) // $ query=query18
}

func test3(db *sql.DB, ctx context.Context) {
	stmt1, _ := db.Prepare(query21)             // $ SPURIOUS: querystring=query21
	stmt1.Exec()                                // $ MISSING: query=query21
	stmt2, _ := db.PrepareContext(ctx, query22) // $ SPURIOUS: querystring=query22
	stmt2.ExecContext(ctx)                      // $ MISSING: query=query22
	stmt3, _ := db.Prepare(query23)             // $ SPURIOUS: querystring=query23
	runQuery(stmt3)
}

func runQuery(stmt *sql.Stmt) {
	stmt.Exec() // $ MISSING: query=query23
}

func main() {}
