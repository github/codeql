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

	sinkBytes(serialized) // $ hasTaintFlow="serialized"
}

func testCloneThenMarshal() {
	query := &query.Query{}
	query.Description = getUntrustedString()

	queryClone := proto.Clone(query)

	serialized, _ := proto.Marshal(queryClone)

	sinkBytes(serialized) // $ hasTaintFlow="serialized"
}

func testUnmarshalFieldAccess() {
	untrustedSerialized := getUntrustedBytes()
	query := &query.Query{}
	proto.Unmarshal(untrustedSerialized, query)

	sinkString(query.Description) // $ hasTaintFlow="selection of Description"
}

func testUnmarshalGetter() {
	untrustedSerialized := getUntrustedBytes()
	query := &query.Query{}
	proto.Unmarshal(untrustedSerialized, query)

	sinkString(query.GetDescription()) // $ hasTaintFlow="call to GetDescription"
}

func testMergeThenMarshal() {
	query1 := &query.Query{}
	query1.Description = getUntrustedString()

	query2 := &query.Query{}
	proto.Merge(query2, query1)

	serialized, _ := proto.Marshal(query2)

	sinkBytes(serialized) // $ hasTaintFlow="serialized"
}

func testTaintedSubmessage() {
	alert := &query.Query_Alert{}
	alert.Msg = getUntrustedString()

	query := &query.Query{}
	query.Alerts = append(query.Alerts, alert)

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized) // $ hasTaintFlow="serialized"
}

func testTaintedSubmessageInPlace() {
	alert := &query.Query_Alert{}

	query := &query.Query{}
	query.Alerts = append(query.Alerts, alert)
	query.Alerts[0].Msg = getUntrustedString()

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized) // $ hasTaintFlow="serialized"
}

func testUnmarshalTaintedSubmessage() {
	untrustedSerialized := getUntrustedBytes()
	query := &query.Query{}
	proto.Unmarshal(untrustedSerialized, query)

	sinkString(query.Alerts[0].Msg) // $ hasTaintFlow="selection of Msg"
}

// This test should be ok, but is flagged because writing taint to a field of a Message
// taints the entire Message structure in our current implementation.
func testFieldConflationFalsePositive() {
	query := &query.Query{}
	query.Description = getUntrustedString()
	sinkString(query.Id) // $ SPURIOUS: hasTaintFlow="selection of Id"
}

// This test should be ok, but it flagged because our current implementation doesn't notice
// that the taint applied to `query` is overwritten.
func testMessageReuseFalsePositive() {
	query := &query.Query{}
	query.Description = getUntrustedString()
	query.Description = "clean"

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized) // $ SPURIOUS: hasTaintFlow="serialized"
}

// This test should be flagged, but we don't notice tainting via an alias of a field.
func testSubmessageAliasFalseNegative() {
	query := &query.Query{}
	alias := &query.Description
	*alias = getUntrustedString()

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized) // $ MISSING: hasTaintFlow="serialized"
}

func testTaintedMapFieldWrite() {
	query := &query.Query{}
	query.KeyValuePairs[123] = getUntrustedString()

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized) // $ hasTaintFlow="serialized"
}

func testTaintedMapWriteWholeMap() {
	query := &query.Query{}
	taintedMap := map[int32]string{}
	taintedMap[123] = getUntrustedString()
	query.KeyValuePairs = taintedMap

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized) // $ hasTaintFlow="serialized"
}

func testTaintedMapFieldRead() {
	untrustedSerialized := getUntrustedBytes()
	query := &query.Query{}

	proto.Unmarshal(untrustedSerialized, query)

	sinkString(query.KeyValuePairs[123]) // $ hasTaintFlow="index expression"
}

func testTaintedMapFieldReadViaAlias() {
	untrustedSerialized := getUntrustedBytes()
	query := &query.Query{}

	proto.Unmarshal(untrustedSerialized, query)

	alias := &query.KeyValuePairs

	sinkString((*alias)[123]) // $ hasTaintFlow="index expression"
}

func testTaintedSubmessageInPlaceNonPointerBase() {
	alert := query.Query_Alert{}

	query := query.Query{}
	query.Alerts = append(query.Alerts, &alert)
	query.Alerts[0].Msg = getUntrustedString()

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized) // $ hasTaintFlow="serialized"
}
