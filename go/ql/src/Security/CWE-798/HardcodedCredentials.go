package main

import (
	"database/sql"
	"fmt"

	_ "github.com/lib/pq"
)

const (
	user     = "dbuser"
	password = "s3cretp4ssword"
)

func connect() *sql.DB {
	connStr := fmt.Sprintf("postgres://%s:%s@localhost/pqgotest", user, password)
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		return nil
	}
	return db
}
