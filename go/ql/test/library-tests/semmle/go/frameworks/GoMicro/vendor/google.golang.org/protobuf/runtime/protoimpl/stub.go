// This is a simple stub for google.golang.org/protobuf/runtime/protoimpl, strictly for use in testing.

// See the LICENSE file for information about the licensing of the original library.
// Source: google.golang.org/protobuf/runtime/protoimpl (exports: MessageState,SizeCache,UnknownFields,Pointer,EnforceVersion; functions: MinVersion,MaxVersion,UnsafeEnabled,X)

// Package protoimpl is a stub of google.golang.org/protobuf/runtime/protoimpl.
package protoimpl

import (
	impl "google.golang.org/protobuf/internal/impl"
)

type EnforceVersion uint

const MaxVersion int = 20

type MessageState = impl.MessageState

const MinVersion int = 20

type Pointer = impl.Pointer

type SizeCache = int32

type UnknownFields = []byte

var UnsafeEnabled bool = false

// Export is a zero-length named type that exists only to export a set of
// functions that we do not want to appear in godoc.
type Export struct{}

var X Export = Export{}

func (Export) NewError(f string, x ...interface{}) error {
	return nil
}

type enum = interface{}

func (Export) EnumOf(e enum) interface{} {
	return nil
}

func (Export) EnumDescriptorOf(e enum) interface{} {
	return nil
}

func (Export) EnumTypeOf(e enum) interface{} {
	return nil
}

func (Export) EnumStringOf(ed interface{}, n interface{}) string {
	return ""
}

type message = interface{}

type legacyMessageWrapper struct{ m interface{} }

func (m legacyMessageWrapper) Reset()         {}
func (m legacyMessageWrapper) String() string { return "" }
func (m legacyMessageWrapper) ProtoMessage()  {}

func (Export) ProtoMessageV1Of(m message) interface{} {
	return nil
}

func (Export) protoMessageV2Of(m message) interface{} {
	return nil
}

func (Export) ProtoMessageV2Of(m message) interface{} {
	return nil
}

func (Export) MessageOf(m message) interface{} {
	return nil
}

func (Export) MessageDescriptorOf(m message) interface{} {
	return nil
}

func (Export) MessageTypeOf(m message) interface{} {
	return nil
}

func (Export) MessageStringOf(m interface{}) string {
	return ""
}

func (Export) MessageStateOf(p Pointer) *MessageState {
	return nil
}

func (Export) CompressGZIP(_ []byte) []byte {
	return nil
}

type EnumInfo = impl.EnumInfo

type MessageInfo = impl.MessageInfo

type TypeBuilder = impl.TypeBuilder

type DescBuilder = impl.DescBuilder
