package main

import (
	"codeql-go-tests/protobuf/protos/query"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/runtime/protoiface"
)

func testMarshalModern() {
	query := &query.Query{}
	query.Description = getUntrustedString()

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized)
}

func testCloneThenMarshalModern() {
	query := &query.Query{}
	query.Description = getUntrustedString()

	queryClone := proto.Clone(query)

	serialized, _ := proto.Marshal(queryClone)

	sinkBytes(serialized)
}

func testUnmarshalFieldAccessModern() {
	untrustedSerialized := getUntrustedBytes()
	query := &query.Query{}
	proto.Unmarshal(untrustedSerialized, query)

	sinkString(query.Description)
}

func testUnmarshalGetterModern() {
	untrustedSerialized := getUntrustedBytes()
	query := &query.Query{}
	proto.Unmarshal(untrustedSerialized, query)

	sinkString(query.GetDescription())
}

func testMergeThenMarshalModern() {
	query1 := &query.Query{}
	query1.Description = getUntrustedString()

	query2 := &query.Query{}
	proto.Merge(query2, query1)

	serialized, _ := proto.Marshal(query2)

	sinkBytes(serialized)
}

func testMarshalWithOptionsModern() {
	query := &query.Query{}
	query.Description = getUntrustedString()

	options := proto.MarshalOptions{}
	serialized, _ := options.Marshal(query)

	sinkBytes(serialized)
}

// Tests only applicable to the modern API:

func testMarshalAppend() {
	query := &query.Query{}
	query.Description = getUntrustedString()

	options := proto.MarshalOptions{}
	emptyArray := []byte{}
	serialized, _ := options.MarshalAppend(emptyArray, query)

	sinkBytes(serialized)
}

func testMarshalState() {
	query := &query.Query{}
	query.Description = getUntrustedString()

	options := proto.MarshalOptions{}
	emptyArray := []byte{}
	marshalState := protoiface.MarshalInput{
		Message: query.ProtoReflect(),
		Buf:     emptyArray,
		Flags:   0,
	}
	serialized, _ := options.MarshalState(marshalState)

	sinkBytes(serialized.Buf)
}

func testTaintedSubmessageModern() {
	alert := &query.Query_Alert{}
	alert.Msg = getUntrustedString()

	query := &query.Query{}
	query.Alerts = append(query.Alerts, alert)

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized) // BAD
}

func testTaintedSubmessageInPlaceModern() {
	alert := &query.Query_Alert{}

	query := &query.Query{}
	query.Alerts = append(query.Alerts, alert)
	query.Alerts[0].Msg = getUntrustedString()

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized) // BAD
}

func testUnmarshalTaintedSubmessageModern() {
	untrustedSerialized := getUntrustedBytes()
	query := &query.Query{}
	proto.Unmarshal(untrustedSerialized, query)

	sinkString(query.Alerts[0].Msg) // BAD
}

func testUnmarshalOptions() {
	options := proto.UnmarshalOptions{}

	untrustedSerialized := getUntrustedBytes()
	query := &query.Query{}
	options.Unmarshal(untrustedSerialized, query)

	sinkString(query.Description) // BAD
}

// This test should be ok, but is flagged because writing taint to a field of a Message
// taints the entire Message structure in our current implementation.
func testFieldConflationFalsePositiveModern() {
	query := &query.Query{}
	query.Description = getUntrustedString()
	sinkString(query.Id) // OK (but incorrectly tainted)
}

// This test should be ok, but it flagged because our current implementation doesn't notice
// that the taint applied to `query` is overwritten.
func testMessageReuseFalsePositiveModern() {
	query := &query.Query{}
	query.Description = getUntrustedString()
	query.Description = "clean"

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized) // OK (but incorrectly tainted)
}

// This test should be flagged, but we don't notice tainting via an alias of a field.
func testSubmessageAliasFalseNegativeModern() {
	query := &query.Query{}
	alias := &query.Description
	*alias = getUntrustedString()

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized) // BAD (but not noticed by our current implementation)
}

// This test should be flagged, but we don't notice that marshalState2.Message is the
// same as marshalState.Message.
func testMarshalStateFalseNegative() {
	query := &query.Query{}
	query.Description = getUntrustedString()

	options := proto.MarshalOptions{}
	emptyArray := []byte{}
	marshalState := protoiface.MarshalInput{
		Message: query.ProtoReflect(),
		Buf:     emptyArray,
		Flags:   0,
	}
	marshalState2 := marshalState
	serialized, _ := options.MarshalState(marshalState2)

	sinkBytes(serialized.Buf) // BAD (but not noticed by our current implementation)
}

func testTaintedMapFieldWriteModern() {
	query := &query.Query{}
	query.KeyValuePairs[123] = getUntrustedString()

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized) // BAD
}

func testTaintedMapWriteWholeMapModern() {
	query := &query.Query{}
	taintedMap := map[int32]string{}
	taintedMap[123] = getUntrustedString()
	query.KeyValuePairs = taintedMap

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized) // BAD
}

func testTaintedMapFieldReadModern() {
	untrustedSerialized := getUntrustedBytes()
	query := &query.Query{}

	proto.Unmarshal(untrustedSerialized, query)

	sinkString(query.KeyValuePairs[123]) // BAD
}

func testTaintedMapFieldReadViaAliasModern() {
	untrustedSerialized := getUntrustedBytes()
	query := &query.Query{}

	proto.Unmarshal(untrustedSerialized, query)

	alias := &query.KeyValuePairs

	sinkString((*alias)[123]) // BAD
}

func testTaintedSubmessageInPlaceNonPointerBaseModern() {
	alert := query.Query_Alert{}

	query := query.Query{}
	query.Alerts = append(query.Alerts, &alert)
	query.Alerts[0].Msg = getUntrustedString()

	serialized, _ := proto.Marshal(query)

	sinkBytes(serialized) // BAD (but not detected by our current implementation)
}
