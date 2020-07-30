// This is a simple stub for github.com/golang/protobuf/proto, strictly for use in testing.

// See the LICENSE file for information about the licensing of the original library.
// Source: github.com/golang/protobuf/proto (exports: Message; functions: Marshal,Unmarshal,ProtoPackageIsVersion4)

// Package proto is a stub of github.com/golang/protobuf/proto.
package proto

import (
	protoreflect "google.golang.org/protobuf/reflect/protoreflect"
	protoiface "google.golang.org/protobuf/runtime/protoiface"
)

func Marshal(_ interface{}) ([]byte, error) {
	return nil, nil
}

type Message = protoreflect.ProtoMessage

var ProtoPackageIsVersion4 bool = false

func Unmarshal(_ []byte, _ interface{}) error {
	return nil
}

type MarshalOptions struct {
	AllowPartial  bool
	Deterministic bool
	UseCachedSize bool
}

func (_ MarshalOptions) Marshal(_ Message) ([]byte, error)                 { return nil, nil }
func (_ MarshalOptions) MarshalAppend(b []byte, m Message) ([]byte, error) { return nil, nil }
func (_ MarshalOptions) MarshalState(in protoiface.MarshalInput) (protoiface.MarshalOutput, error) {
	return protoiface.MarshalOutput{nil}, nil
}

func Clone(_ Message) Message {
	return nil
}

func Merge(_, _ Message) {}
