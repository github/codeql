package main

import (
	"database/sql"
	"fmt"
	"net/http"
)

func handler(db *sql.DB, req *http.Request) {
	q := fmt.Sprintf("SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='%s' ORDER BY PRICE", // $ Source[go/sql-injection]
		req.URL.Query()["category"])
	db.Query(q) // $ Alert[go/sql-injection]
}
