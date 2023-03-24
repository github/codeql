// This is a simple stub for github.com/golang/protobuf/proto, strictly for use in testing.

// See the LICENSE file for information about the licensing of the original library.
// Source: github.com/golang/protobuf/proto (exports: Message; functions: Marshal,Unmarshal,ProtoPackageIsVersion4)

// Package proto is a stub of github.com/golang/protobuf/proto
package proto

import (
	protoiface "google.golang.org/protobuf/runtime/protoiface"
)

func Marshal(_ interface{}) ([]byte, error) {
	return nil, nil
}

type Message = protoiface.MessageV1

const ProtoPackageIsVersion4 bool = false

func Unmarshal(_ []byte, _ interface{}) error {
	return nil
}

func Clone(_ Message) Message {
	return nil
}

func Merge(_, _ Message) {}
