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
	bun.NewRawQuery(db, untrusted) // $ querystring=untrusted

	db.ExecContext(ctx, untrusted)     // $ querystring=untrusted
	db.PrepareContext(ctx, untrusted)  // $ querystring=untrusted
	db.QueryContext(ctx, untrusted)    // $ querystring=untrusted
	db.QueryRowContext(ctx, untrusted) // $ querystring=untrusted

	db.Exec(untrusted)     // $ querystring=untrusted
	db.NewRaw(untrusted)   // $ querystring=untrusted
	db.Prepare(untrusted)  // $ querystring=untrusted
	db.Query(untrusted)    // $ querystring=untrusted
	db.QueryRow(untrusted) // $ querystring=untrusted
	db.Raw(untrusted)      // $ querystring=untrusted

	db.NewSelect().ColumnExpr(untrusted)     // $ querystring=untrusted
	db.NewSelect().DistinctOn(untrusted)     // $ querystring=untrusted
	db.NewSelect().For(untrusted)            // $ querystring=untrusted
	db.NewSelect().GroupExpr(untrusted)      // $ querystring=untrusted
	db.NewSelect().Having(untrusted)         // $ querystring=untrusted
	db.NewSelect().ModelTableExpr(untrusted) // $ querystring=untrusted
	db.NewSelect().OrderExpr(untrusted)      // $ querystring=untrusted
	db.NewSelect().TableExpr(untrusted)      // $ querystring=untrusted
	db.NewSelect().Where(untrusted)          // $ querystring=untrusted
	db.NewSelect().WhereOr(untrusted)        // $ querystring=untrusted
}
