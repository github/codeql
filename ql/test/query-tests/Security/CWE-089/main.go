package main

import (
	"database/sql"
	"fmt"
	"net/http"
)

func test(db *sql.DB, r *http.Request) {
	db.Query(r.Form["query"][0]) // NOT OK
}

func test2(tx *sql.Tx, r *http.Request) {
	tx.Query(fmt.Sprintf("SELECT USER FROM USERS WHERE ID='%s'", r.URL.Query()["uuid"]))  // NOT OK
	tx.Query(fmt.Sprintf("SELECT USER FROM USERS WHERE ID='%s'", r.Header.Get("X-Uuid"))) // NOT OK
}

func main() {}
