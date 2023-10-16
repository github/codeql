package main

import (
	"database/sql"
	"fmt"
	"os"
)

func bad() interface{} {
	name := os.Args[1:]
	// This is bad. `name` can be something like `test?allowAllFiles=true&` which will allow an attacker to access local files.
	dbDSN := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=utf8", "username", "password", "127.0.0.1", 3306, name)
	db, _ := sql.Open("mysql", dbDSN)
	return db
}
