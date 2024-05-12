// This is a simple stub for google.golang.org/protobuf/runtime/protoiface, strictly for use in testing.

// See the LICENSE file for information about the licensing of the original library.
// Source: google.golang.org/protobuf/runtime/protoiface (exports: MessageV1; functions: )

// Package protoiface is a stub of google.golang.org/protobuf/runtime/protoiface.
package protoiface

import (
	"google.golang.org/protobuf/reflect/protoreflect"
)

type MessageV1 interface {
	ProtoMessage()
	Reset()
	String() string
}

type MarshalInputFlags = uint8

type MarshalInput struct {
	Message protoreflect.Message
	Buf     []byte // output is appended to this buffer
	Flags   MarshalInputFlags
}

type MarshalOutput struct {
	Buf []byte // contains marshaled message
}
