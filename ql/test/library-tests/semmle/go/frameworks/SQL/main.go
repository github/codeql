package main

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

func main() {}
