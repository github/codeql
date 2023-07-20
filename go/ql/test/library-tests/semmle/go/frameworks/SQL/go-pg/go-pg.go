package main

import (
	"context"
	pg "github.com/go-pg/pg/v10"
)

type Profile struct {
	ID   int
	Lang string
}

type User struct {
	ID        int
	Name      string
	ProfileID int
	Profile   *Profile `pg:"-"`
}

func getUntrustedString() string {
	return "trouble"
}

func main() {

	untrusted := getUntrustedString()

	ctx := context.Background()
	db := pg.Connect(&pg.Options{
		Addr:     ":5432",
		User:     "user",
		Password: "pass",
		Database: "db_name",
	})

	var version string

	db.Exec(untrusted)
	db.ExecOne(untrusted)
	db.Prepare(untrusted)

	db.ExecContext(ctx, untrusted)
	db.ExecOneContext(ctx, untrusted)
	db.Query(&version, untrusted)
	db.QueryOne(&version, untrusted)

	db.QueryOneContext(ctx, pg.Scan(&version), untrusted)
	db.QueryContext(ctx, &version, untrusted)

	var user User
	db.Model(&user).
		ColumnExpr(untrusted).
		Join(untrusted).
		Where(untrusted, 123).
		OrderExpr(untrusted).
		GroupExpr(untrusted).
		TableExpr(untrusted).
		WhereIn(untrusted, 1).
		WhereInMulti(untrusted, 1).
		WhereOr(untrusted, 1).
		For(untrusted).
		Having(untrusted).
		Select()
}
