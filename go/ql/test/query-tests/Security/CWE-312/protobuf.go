package main

import (
	"log"
	"main/protos/query"
)

func testProtobuf() {
	password := "P@ssw0rd" // $ Source

	query := &query.Query{}
	query.Description = password

	log.Println(query.GetDescription()) // $ Alert
	log.Println(query.GetId())          // OK
}
