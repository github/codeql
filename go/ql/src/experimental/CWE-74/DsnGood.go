package main

import (
	"database/sql"
	"errors"
	"fmt"
	"os"
	"regexp"
)

func good() (interface{}, error) {
	name := os.Args[1]
	hasBadChar, _ := regexp.MatchString(".*[?].*", name)

	if hasBadChar {
		return nil, errors.New("Bad input")
	}

	dbDSN := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=utf8", "username", "password", "127.0.0.1", 3306, name)
	db, _ := sql.Open("mysql", dbDSN)
	return db, nil
}
