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
	db.ExecContext(ctx, untrusted)
	db.QueryOneContext(ctx, pg.Scan(&version), untrusted)

	var user User
	db.Model(&user).
		ColumnExpr(untrusted).
		Join(untrusted).
		Where(untrusted, 123).
		OrderExpr(untrusted).
		Select()
}
