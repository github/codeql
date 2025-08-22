package main

import (
	corev1 "k8s.io/api/core/v1"
	"k8s.io/apimachinery/pkg/runtime"
)

//go:generate depstubber -vendor k8s.io/api/core/v1 SecretList
//go:generate depstubber -vendor k8s.io/apimachinery/pkg/runtime ProtobufMarshaller,ProtobufReverseMarshaller

func source() interface{} {
	return make([]byte, 1)
}

func sink(interface{}) {
}

func main() {

	{
		// func (in *Secret) DeepCopy() *Secret
		sink(source().(*corev1.Secret).DeepCopy()) // $ hasTaintFlow="call to DeepCopy"
	}
	{
		// func (in *Secret) DeepCopyInto(out *Secret)
		var out *corev1.Secret
		source().(*corev1.Secret).DeepCopyInto(out)
		sink(out) // $ hasTaintFlow="out"
	}
	{
		// func (in *Secret) DeepCopyObject() runtime.Object
		sink(source().(*corev1.Secret).DeepCopyObject()) // $ hasTaintFlow="call to DeepCopyObject"
	}
	{
		// func (m *Secret) Marshal() (dAtA []byte, err error)
		out, _ := source().(*corev1.Secret).Marshal()
		sink(out) // $ hasTaintFlow="out"
	}
	{
		// func (m *Secret) MarshalTo(dAtA []byte) (int, error)
		var dAtA []byte
		source().(*corev1.Secret).MarshalTo(dAtA)
		sink(dAtA) // $ hasTaintFlow="dAtA"
	}
	{
		// func (m *Secret) MarshalToSizedBuffer(dAtA []byte) (int, error)
		var dAtA []byte
		source().(*corev1.Secret).MarshalToSizedBuffer(dAtA)
		sink(dAtA) // $ hasTaintFlow="dAtA"
	}
	{
		// func (m *Secret) Unmarshal(dAtA []byte) error
		var dAtA []byte
		source().(*corev1.Secret).Unmarshal(dAtA)
		sink(dAtA) // $ hasTaintFlow="dAtA"
	}

	{
		// func (in *SecretList) DeepCopy() *SecretList
		sink(source().(*corev1.SecretList).DeepCopy()) // $ hasTaintFlow="call to DeepCopy"
	}
	{
		// func (in *SecretList) DeepCopyInto(out *SecretList)
		var out *corev1.SecretList
		source().(*corev1.SecretList).DeepCopyInto(out)
		sink(out) // $ hasTaintFlow="out"
	}
	{
		// func (in *SecretList) DeepCopyObject() runtime.Object
		sink(source().(*corev1.SecretList).DeepCopyObject()) // $ hasTaintFlow="call to DeepCopyObject"
	}
	{
		// func (m *SecretList) Marshal() (dAtA []byte, err error)
		out, _ := source().(*corev1.SecretList).Marshal()
		sink(out) // $ hasTaintFlow="out"
	}
	{
		// func (m *SecretList) MarshalTo(dAtA []byte) (int, error)
		var dAtA []byte
		source().(*corev1.SecretList).MarshalTo(dAtA)
		sink(dAtA) // $ hasTaintFlow="dAtA"
	}
	{
		// func (m *SecretList) MarshalToSizedBuffer(dAtA []byte) (int, error)
		var dAtA []byte
		source().(*corev1.SecretList).MarshalToSizedBuffer(dAtA)
		sink(dAtA) // $ hasTaintFlow="dAtA"
	}
	{
		// func (m *SecretList) Unmarshal(dAtA []byte) error
		var dAtA []byte
		source().(*corev1.SecretList).Unmarshal(dAtA)
		sink(dAtA) // $ hasTaintFlow="dAtA"
	}
}

func dummy1(runtime.ProtobufMarshaller)        {}
func dummy2(runtime.ProtobufReverseMarshaller) {}
