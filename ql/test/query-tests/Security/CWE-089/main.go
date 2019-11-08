package main

import (
	"database/sql"
	"net/http"
)

func test(db *sql.DB, r *http.Request) {
	db.Query(r.Form["query"][0]) // NOT OK
}

func main() {}
