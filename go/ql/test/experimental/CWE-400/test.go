package main

import "gorm.io/gorm"

type User struct {
	Id   int64
	Name string
}

func runQuery(db *gorm.DB) {
	db.Take(nil) // $ Alert
}

func runRunQuery(db *gorm.DB) {
	runQuery(db)
}

func main() {
	var db *gorm.DB
	for i := 0; i < 10; i++ { // $ Source
		runQuery(db)
	}

	for i := 10; i > 0; i-- { // $ Source
		runRunQuery(db)
	}
}
