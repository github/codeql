package main

//go:generate depstubber -vendor github.com/Masterminds/squirrel "" Select,Expr

import (
	"context"
	"database/sql"

	"github.com/Masterminds/squirrel"
)

func test(db *sql.DB, query string, ctx context.Context) {
	db.Exec(query)
	db.ExecContext(ctx, query)
	db.Prepare(query)
	db.PrepareContext(ctx, query)
	db.Query(query)
	db.QueryContext(ctx, query)
	db.QueryRow(query)
	db.QueryRowContext(ctx, query)
}

func squirrelTest(querypart string) {
	squirrel.Select("*").From("users").Where(squirrel.Expr(querypart))
	squirrel.Select("*").From("users").Suffix(querypart)
}

func test2(tx *sql.Tx, query string, ctx context.Context) {
	tx.Exec(query)
	tx.ExecContext(ctx, query)
	tx.Prepare(query)
	tx.PrepareContext(ctx, query)
	tx.Query(query)
	tx.QueryContext(ctx, query)
	tx.QueryRow(query)
	tx.QueryRowContext(ctx, query)
}

func main() {}
