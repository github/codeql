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
