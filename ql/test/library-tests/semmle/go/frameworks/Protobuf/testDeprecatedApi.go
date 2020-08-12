package main

import (
	"codeql-go-tests/protobuf/protos/query"
	"github.com/golang/protobuf/proto"
)

func getUntrustedString() string {
	return "trouble"
}

func getUntrustedBytes() []byte {
	return []byte{}
}

func sinkString(_ string) {}

func sinkBytes(_ []byte) {}

func testMarshal() {
	query := &query.Query{}
	query.Description = getUntrustedString()

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized) // BAD
}

func testCloneThenMarshal() {
	query := &query.Query{}
	query.Description = getUntrustedString()

	queryClone := proto.Clone(query)

	serialized, _ := proto.Marshal(queryClone)

	sinkBytes(serialized) // BAD
}

func testUnmarshalFieldAccess() {
	untrustedSerialized := getUntrustedBytes()
	query := &query.Query{}
	proto.Unmarshal(untrustedSerialized, query)

	sinkString(query.Description) // BAD
}

func testUnmarshalGetter() {
	untrustedSerialized := getUntrustedBytes()
	query := &query.Query{}
	proto.Unmarshal(untrustedSerialized, query)

	sinkString(query.GetDescription()) // BAD
}

func testMergeThenMarshal() {
	query1 := &query.Query{}
	query1.Description = getUntrustedString()

	query2 := &query.Query{}
	proto.Merge(query2, query1)

	serialized, _ := proto.Marshal(query2)

	sinkBytes(serialized) // BAD
}

func testTaintedSubmessage() {
	alert := &query.Query_Alert{}
	alert.Msg = getUntrustedString()

	query := &query.Query{}
	query.Alerts = append(query.Alerts, alert)

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized) // BAD
}

func testTaintedSubmessageInPlace() {
	alert := &query.Query_Alert{}

	query := &query.Query{}
	query.Alerts = append(query.Alerts, alert)
	query.Alerts[0].Msg = getUntrustedString()

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized) // BAD
}

func testUnmarshalTaintedSubmessage() {
	untrustedSerialized := getUntrustedBytes()
	query := &query.Query{}
	proto.Unmarshal(untrustedSerialized, query)

	sinkString(query.Alerts[0].Msg) // BAD
}
