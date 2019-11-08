package main

import (
	"database/sql"
	"fmt"
)

const (
	user     = "dbuser"
	password = "secretpassword"
)

func connect() *sql.DB {
	connStr := fmt.Sprintf("postgres://%s:%s@localhost/pqgotest", user, password)
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		return nil
	}
	return db
}
