package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"
)

func test(db *sql.DB, r *http.Request) {
	db.Query(r.Form["query"][0]) // $ Alert[go/sql-injection] // NOT OK
}

func test2(tx *sql.Tx, r *http.Request) {
	tx.Query(fmt.Sprintf("SELECT USER FROM USERS WHERE ID='%s'", r.URL.Query()["uuid"]))  // $ Alert[go/sql-injection] // NOT OK
	tx.Query(fmt.Sprintf("SELECT USER FROM USERS WHERE ID='%s'", r.Header.Get("X-Uuid"))) // $ Alert[go/sql-injection] // NOT OK
}

func main() {}

// https://github.com/github/codeql-go/issues/18 and variants
type RequestStruct struct {
	Id       int64    `db:"id"`
	Category []string `db:"category"`
}

func handler2(db *sql.DB, req *http.Request) {
	RequestData := &RequestStruct{
		Id:       1,
		Category: req.URL.Query()["category"], // $ Source[go/sql-injection]
	}

	q := fmt.Sprintf("SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='%s' ORDER BY PRICE",
		RequestData.Category)
	db.Query(q) // $ Alert[go/sql-injection]
}

func handler3(db *sql.DB, req *http.Request) {
	RequestData := &RequestStruct{}
	RequestData.Category = req.URL.Query()["category"] // $ Source[go/sql-injection]

	q := fmt.Sprintf("SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='%s' ORDER BY PRICE",
		RequestData.Category)
	db.Query(q) // $ Alert[go/sql-injection]
}

func handler4(db *sql.DB, req *http.Request) {
	RequestData := &RequestStruct{}
	(*RequestData).Category = req.URL.Query()["category"] // $ Source[go/sql-injection]

	q := fmt.Sprintf("SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='%s' ORDER BY PRICE",
		RequestData.Category)
	db.Query(q) // $ Alert[go/sql-injection]
}

func handler5(db *sql.DB, req *http.Request) {
	RequestData := &RequestStruct{}
	(*RequestData).Category = req.URL.Query()["category"] // $ Source[go/sql-injection]

	q := fmt.Sprintf("SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='%s' ORDER BY PRICE",
		(*RequestData).Category)
	db.Query(q) // $ Alert[go/sql-injection]
}

// This is an integer, so should not counted as injection
func handlerint(db *sql.DB, req *http.Request) {
	var request RequestStruct
	json.NewDecoder(req.Body).Decode(&request)

	q := fmt.Sprintf("SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='%d' ORDER BY PRICE",
		request.Id)
	db.Query(q)
}
