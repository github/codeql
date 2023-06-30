package main

import (
	"context"
	"database/sql"

	"github.com/uptrace/bun"
	"github.com/uptrace/bun/dialect/sqlitedialect"
	"github.com/uptrace/bun/driver/sqliteshim"
)

func getUntrustedString() string {
	return "trouble"
}

func main() {
	untrusted := getUntrustedString()

	var num int
	ctx := context.Background()
	sqlite, err := sql.Open(sqliteshim.ShimName, "file::memory:?cache=shared")
	if err != nil {
		panic(err)
	}
	db := bun.NewDB(sqlite, sqlitedialect.New())
	db.Exec(untrusted)
	db.ExecContext(ctx, untrusted)
	db.QueryRowContext(ctx, untrusted).Scan(&num)
	db.NewSelect().ColumnExpr(untrusted).Exec(ctx)
	db.NewRaw(untrusted).Scan(ctx, &num)
	db.QueryContext(ctx, untrusted)
	db.QueryRowContext(ctx, untrusted)
	db.QueryRow(untrusted)
	db.Raw(untrusted)
	db.Query(untrusted)
	db.Prepare(untrusted)
	db.PrepareContext(ctx, untrusted)
	bun.NewRawQuery(db, untrusted)
}
