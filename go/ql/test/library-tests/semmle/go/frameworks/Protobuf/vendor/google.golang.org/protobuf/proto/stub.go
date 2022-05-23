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

type UnmarshalOptions struct {
	// Merge merges the input into the destination message.
	// The default behavior is to always reset the message before unmarshaling,
	// unless Merge is specified.
	Merge bool

	// AllowPartial accepts input for messages that will result in missing
	// required fields. If AllowPartial is false (the default), Unmarshal will
	// return an error if there are any missing required fields.
	AllowPartial bool

	// If DiscardUnknown is set, unknown fields are ignored.
	DiscardUnknown bool

	// Resolver is used for looking up types when unmarshaling extension fields.
	// If nil, this defaults to using protoregistry.GlobalTypes.
	Resolver interface {
		FindExtensionByName(field protoreflect.FullName) (protoreflect.ExtensionType, error)
		FindExtensionByNumber(message protoreflect.FullName, field protoreflect.FieldNumber) (protoreflect.ExtensionType, error)
	}
}

func (o UnmarshalOptions) Unmarshal(b []byte, m Message) error {
	return nil
}

func Clone(_ Message) Message {
	return nil
}

func Merge(_, _ Message) {}
