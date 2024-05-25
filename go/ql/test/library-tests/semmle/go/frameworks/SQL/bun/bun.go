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

	ctx := context.Background()
	sqlite, err := sql.Open(sqliteshim.ShimName, "file::memory:?cache=shared")
	if err != nil {
		panic(err)
	}
	db := bun.NewDB(sqlite, sqlitedialect.New())
	bun.NewRawQuery(db, untrusted)

	db.ExecContext(ctx, untrusted)
	db.PrepareContext(ctx, untrusted)
	db.QueryContext(ctx, untrusted)
	db.QueryRowContext(ctx, untrusted)

	db.Exec(untrusted)
	db.NewRaw(untrusted)
	db.Prepare(untrusted)
	db.Query(untrusted)
	db.QueryRow(untrusted)
	db.Raw(untrusted)

	db.NewSelect().ColumnExpr(untrusted)
	db.NewSelect().DistinctOn(untrusted)
	db.NewSelect().For(untrusted)
	db.NewSelect().GroupExpr(untrusted)
	db.NewSelect().Having(untrusted)
	db.NewSelect().ModelTableExpr(untrusted)
	db.NewSelect().OrderExpr(untrusted)
	db.NewSelect().TableExpr(untrusted)
	db.NewSelect().Where(untrusted)
	db.NewSelect().WhereOr(untrusted)
}
