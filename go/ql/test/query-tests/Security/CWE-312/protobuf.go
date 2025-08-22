package main

import (
	"log"
	"main/protos/query"
)

func testProtobuf() {
	password := "P@ssw0rd"

	query := &query.Query{}
	query.Description = password // $ Source

	log.Println(query.GetDescription()) // $ Alert
	log.Println(query.GetId())          // OK
}
