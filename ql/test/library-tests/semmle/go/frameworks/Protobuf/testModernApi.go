package main

import (
	"codeql-go-tests/protobuf/protos/query"
	"google.golang.org/protobuf/proto"
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

	sinkBytes(serialized)
}

func testCloneThenMarshal() {
	query := &query.Query{}
	query.Description = getUntrustedString()

	queryClone := proto.Clone(query)

	serialized, _ := proto.Marshal(queryClone)

	sinkBytes(serialized)
}

func testUnmarshalFieldAccess() {
	untrustedSerialized := getUntrustedBytes()
	query := &query.Query{}
	proto.Unmarshal(untrustedSerialized, query)

	sinkString(query.Description)
}

func testUnmarshalGetter() {
	untrustedSerialized := getUntrustedBytes()
	query := &query.Query{}
	proto.Unmarshal(untrustedSerialized, query)

	sinkString(query.GetDescription())
}

func testMergeThenMarshal() {
	query1 := &query.Query{}
	query1.Description = getUntrustedString()

	query2 := &query.Query{}
	proto.Merge(query2, query1)

	serialized, _ := proto.Marshal(query2)

	sinkBytes(serialized)
}
