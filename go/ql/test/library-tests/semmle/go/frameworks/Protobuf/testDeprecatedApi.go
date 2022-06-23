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

// This test should be ok, but is flagged because writing taint to a field of a Message
// taints the entire Message structure in our current implementation.
func testFieldConflationFalsePositive() {
	query := &query.Query{}
	query.Description = getUntrustedString()
	sinkString(query.Id) // OK (but incorrectly tainted)
}

// This test should be ok, but it flagged because our current implementation doesn't notice
// that the taint applied to `query` is overwritten.
func testMessageReuseFalsePositive() {
	query := &query.Query{}
	query.Description = getUntrustedString()
	query.Description = "clean"

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized) // OK (but incorrectly tainted)
}

// This test should be flagged, but we don't notice tainting via an alias of a field.
func testSubmessageAliasFalseNegative() {
	query := &query.Query{}
	alias := &query.Description
	*alias = getUntrustedString()

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized) // BAD (but not noticed by our current implementation)
}

func testTaintedMapFieldWrite() {
	query := &query.Query{}
	query.KeyValuePairs[123] = getUntrustedString()

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized) // BAD
}

func testTaintedMapWriteWholeMap() {
	query := &query.Query{}
	taintedMap := map[int32]string{}
	taintedMap[123] = getUntrustedString()
	query.KeyValuePairs = taintedMap

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized) // BAD
}

func testTaintedMapFieldRead() {
	untrustedSerialized := getUntrustedBytes()
	query := &query.Query{}

	proto.Unmarshal(untrustedSerialized, query)

	sinkString(query.KeyValuePairs[123]) // BAD
}

func testTaintedMapFieldReadViaAlias() {
	untrustedSerialized := getUntrustedBytes()
	query := &query.Query{}

	proto.Unmarshal(untrustedSerialized, query)

	alias := &query.KeyValuePairs

	sinkString((*alias)[123]) // BAD
}

func testTaintedSubmessageInPlaceNonPointerBase() {
	alert := query.Query_Alert{}

	query := query.Query{}
	query.Alerts = append(query.Alerts, &alert)
	query.Alerts[0].Msg = getUntrustedString()

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized) // BAD (but not detected by our current analysis)
}
