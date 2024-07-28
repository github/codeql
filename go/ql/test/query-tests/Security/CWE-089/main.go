package main

import (
	"database/sql"
	"encoding/json"
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

// https://github.com/github/codeql-go/issues/18 and variants
type RequestStruct struct {
	Id       int64    `db:"id"`
	Category []string `db:"category"`
}

func handler2(db *sql.DB, req *http.Request) {
	RequestData := &RequestStruct{
		Id:       1,
		Category: req.URL.Query()["category"],
	}

	q := fmt.Sprintf("SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='%s' ORDER BY PRICE",
		RequestData.Category)
	db.Query(q)
}

func handler3(db *sql.DB, req *http.Request) {
	RequestData := &RequestStruct{}
	RequestData.Category = req.URL.Query()["category"]

	q := fmt.Sprintf("SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='%s' ORDER BY PRICE",
		RequestData.Category)
	db.Query(q)
}

func handler4(db *sql.DB, req *http.Request) {
	RequestData := &RequestStruct{}
	(*RequestData).Category = req.URL.Query()["category"]

	q := fmt.Sprintf("SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='%s' ORDER BY PRICE",
		RequestData.Category)
	db.Query(q)
}

func handler5(db *sql.DB, req *http.Request) {
	RequestData := &RequestStruct{}
	(*RequestData).Category = req.URL.Query()["category"]

	q := fmt.Sprintf("SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='%s' ORDER BY PRICE",
		(*RequestData).Category)
	db.Query(q)
}

// This is an integer, so should not counted as injection
func handlerint(db *sql.DB, req *http.Request) {
	var request RequestStruct
	json.NewDecoder(req.Body).Decode(&request)

	q := fmt.Sprintf("SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='%d' ORDER BY PRICE",
		request.Id)
	db.Query(q)
}
