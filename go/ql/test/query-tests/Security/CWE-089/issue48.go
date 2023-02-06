package main

// see https://github.com/github/codeql-go/issues/48

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
)

func handler1(db *sql.DB, req *http.Request) {
	// read data from request body and unmarshal to a indeterminacy struct
	// POST: {"a": "b", "category": "test"}
	var RequestDataFromJson map[string]interface{}
	b, _ := ioutil.ReadAll(req.Body)
	json.Unmarshal(b, &RequestDataFromJson)

	q3 := fmt.Sprintf("SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='%s' ORDER BY PRICE",
		RequestDataFromJson["category"])
	db.Query(q3) // NOT OK

	// read data from request body and unmarshal to a determined struct
	// POST: {"id": "1", "category": "test"}
	var RequestDataFromJson2 RequestStruct
	b2, _ := ioutil.ReadAll(req.Body)
	json.Unmarshal(b2, &RequestDataFromJson2)

	q4 := fmt.Sprintf("SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='%s' ORDER BY PRICE",
		RequestDataFromJson2.Category)
	db.Query(q4) // NOT OK

	// read json data from a url parameter
	// GET: ?json={"id": 1, "category": "test"}
	var RequestDataFromJson3 RequestStruct
	json.Unmarshal([]byte(req.URL.Query()["json"][0]), &RequestDataFromJson3)

	q5 := fmt.Sprintf("SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='%s' ORDER BY PRICE",
		RequestDataFromJson3.Category)
	db.Query(q5) // NOT OK
}
