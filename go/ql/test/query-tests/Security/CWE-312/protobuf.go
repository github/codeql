package main

import (
	"log"
	"main/protos/query"
)

func testProtobuf() {
	password := "P@ssw0rd"

	query := &query.Query{}
	query.Description = password

	log.Println(query.GetDescription()) // NOT OK
	log.Println(query.GetId())          // OK
}
