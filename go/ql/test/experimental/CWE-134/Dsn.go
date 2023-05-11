package main

import (
	"database/sql"
	"errors"
	"fmt"
	"net/http"
	"os"
	"regexp"
)

func good() (interface{}, error) {
	name := os.Args[1]
	hasBadChar, _ := regexp.MatchString(".*[?].*", name)

	if hasBadChar {
		return nil, errors.New("bad input")
	}

	dbDSN := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=utf8", "username", "password", "127.0.0.1", 3306, name)
	db, _ := sql.Open("mysql", dbDSN)
	return db, nil
}

func bad() interface{} {
	name2 := os.Args[1:]
	// This is bad. `name` can be something like `test?allowAllFiles=true&` which will allow an attacker to access local files.
	dbDSN := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=utf8", "username", "password", "127.0.0.1", 3306, name2[0])
	db, _ := sql.Open("mysql", dbDSN)
	return db
}

func good2(w http.ResponseWriter, req *http.Request) (interface{}, error) {
	name := req.FormValue("name")
	hasBadChar, _ := regexp.MatchString(".*[?].*", name)

	if hasBadChar {
		return nil, errors.New("bad input")
	}

	dbDSN := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=utf8", "username", "password", "127.0.0.1", 3306, name)
	db, _ := sql.Open("mysql", dbDSN)
	return db, nil
}

func bad2(w http.ResponseWriter, req *http.Request) interface{} {
	name := req.FormValue("name")
	// This is bad. `name` can be something like `test?allowAllFiles=true&` which will allow an attacker to access local files.
	dbDSN := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=utf8", "username", "password", "127.0.0.1", 3306, name)
	db, _ := sql.Open("mysql", dbDSN)
	return db
}

type Config struct {
	dsn string
}

func NewConfig() *Config            { return &Config{dsn: ""} }
func (Config) Parse([]string) error { return nil }

func RegexFuncModelTest(w http.ResponseWriter, req *http.Request) (interface{}, error) {
	cfg := NewConfig()
	err := cfg.Parse(os.Args[1:]) // This is bad. `name` can be something like `test?allowAllFiles=true&` which will allow an attacker to access local files.
	if err != nil {
		return nil, err
	}
	dbDSN := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=utf8", "username", "password", "127.0.0.1", 3306, cfg.dsn)
	db, _ := sql.Open("mysql", dbDSN)
	return db, nil
}

func main() {
	bad2(nil, nil)
	good()
	bad()
	good2(nil, nil)
}
