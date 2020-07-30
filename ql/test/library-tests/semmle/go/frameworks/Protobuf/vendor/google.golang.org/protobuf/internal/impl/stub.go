// This is a simple stub for google.golang.org/protobuf/internal/impl, strictly for use in testing.

// See the LICENSE file for information about the licensing of the original library.
// Source: google.golang.org/protobuf/internal/impl (exports: MessageState,Pointer; functions: )

// Package impl is a stub of google.golang.org/protobuf/internal/impl.
package impl

import (
	"google.golang.org/protobuf/reflect/protoreflect"
)

type MessageState struct {
	NoUnkeyedLiterals interface{}
	DoNotCompare      interface{}
	DoNotCopy         interface{}
}

type Pointer interface{}

type MessageInfo struct {
	Exporter interface{}
}

func (*MessageInfo) MessageOf(_ interface{}) protoreflect.Message { return nil }

type EnumInfo struct{}

func (_ *EnumInfo) Descriptor() protoreflect.EnumDescriptor         { return nil }
func (_ *EnumInfo) New(_ protoreflect.EnumNumber) protoreflect.Enum { return nil }

type DescBuilder struct {
	GoPackagePath string
	RawDescriptor []byte
	NumEnums      int
	NumMessages   int
	NumExtensions int
	NumServices   int
}

type TypeBuilder struct {
	File              DescBuilder
	GoTypes           []interface{}
	DependencyIndexes []int32
	EnumInfos         []EnumInfo
	MessageInfos      []MessageInfo
}

type BuilderOut struct {
	File protoreflect.FileDescriptor
}

func (tb TypeBuilder) Build() BuilderOut {
	return BuilderOut{nil}
}

func (ms *MessageState) LoadMessageInfo() *MessageInfo    { return nil }
func (ms *MessageState) StoreMessageInfo(mi *MessageInfo) {}

func (ms *MessageState) Clear(_ protoreflect.FieldDescriptor)       {}
func (ms *MessageState) Descriptor() protoreflect.MessageDescriptor { return nil }
func (ms *MessageState) Get(_ protoreflect.FieldDescriptor) protoreflect.Value {
	return protoreflect.Value{}
}
func (ms *MessageState) GetUnknown() protoreflect.RawFields      { return nil }
func (ms *MessageState) Has(_ protoreflect.FieldDescriptor) bool { return false }
func (ms *MessageState) Interface() protoreflect.ProtoMessage    { return nil }
func (ms *MessageState) IsValid() bool                           { return false }
func (ms *MessageState) Mutable(_ protoreflect.FieldDescriptor) protoreflect.Value {
	return protoreflect.Value{}
}
func (ms *MessageState) New() protoreflect.Message { return nil }
func (ms *MessageState) NewField(_ protoreflect.FieldDescriptor) protoreflect.Value {
	return protoreflect.Value{}
}
func (ms *MessageState) ProtoMethods() *struct {
	NoUnkeyedLiterals interface{}
	Flags             uint64
	Size              func(struct {
		NoUnkeyedLiterals interface{}
		Message           protoreflect.Message
		Flags             byte
	}) struct {
		NoUnkeyedLiterals interface{}
		Size              int
	}
	Marshal func(struct {
		NoUnkeyedLiterals interface{}
		Message           protoreflect.Message
		Buf               []byte
		Flags             byte
	}) (struct {
		NoUnkeyedLiterals interface{}
		Buf               []byte
	}, error)
	Unmarshal func(struct {
		NoUnkeyedLiterals interface{}
		Message           protoreflect.Message
		Buf               []byte
		Flags             byte
		Resolver          interface {
			FindExtensionByName(_ protoreflect.FullName) (protoreflect.ExtensionType, error)
			FindExtensionByNumber(_ protoreflect.FullName, _ interface{}) (protoreflect.ExtensionType, error)
		}
	}) (struct {
		NoUnkeyedLiterals interface{}
		Flags             byte
	}, error)
	Merge func(struct {
		NoUnkeyedLiterals interface{}
		Source            protoreflect.Message
		Destination       protoreflect.Message
	}) struct {
		NoUnkeyedLiterals interface{}
		Flags             byte
	}
	CheckInitialized func(struct {
		NoUnkeyedLiterals interface{}
		Message           protoreflect.Message
	}) (struct {
		NoUnkeyedLiterals interface{}
	}, error)
} {
	return nil
}
func (ms *MessageState) Range(_ func(protoreflect.FieldDescriptor, protoreflect.Value) bool) {}
func (ms *MessageState) Set(_ protoreflect.FieldDescriptor, _ protoreflect.Value)            {}
func (ms *MessageState) SetUnknown(_ protoreflect.RawFields)                                 {}
func (ms *MessageState) Type() protoreflect.MessageType                                      { return nil }
func (ms *MessageState) WhichOneof(_ protoreflect.OneofDescriptor) protoreflect.FieldDescriptor {
	return nil
}
