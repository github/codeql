package main

import (
	corev1 "k8s.io/api/core/v1"
	"k8s.io/apimachinery/pkg/runtime"
)

//go:generate depstubber -vendor k8s.io/api/core/v1 SecretList
//go:generate depstubber -vendor k8s.io/apimachinery/pkg/runtime ProtobufMarshaller,ProtobufReverseMarshaller

func source() interface{} {
	return make([]byte, 1, 1)
}

func sink(...interface{}) {
}

func main() {

	{
		// func (in *Secret) DeepCopy() *Secret
		sink(source().(*corev1.Secret).DeepCopy()) // $ KsIoApiCoreV
	}
	{
		// func (in *Secret) DeepCopyInto(out *Secret)
		var out *corev1.Secret
		source().(*corev1.Secret).DeepCopyInto(out)
		sink(out) // $ KsIoApiCoreV
	}
	{
		// func (in *Secret) DeepCopyObject() runtime.Object
		sink(source().(*corev1.Secret).DeepCopyObject()) // $ KsIoApiCoreV
	}
	{
		// func (m *Secret) Marshal() (dAtA []byte, err error)
		sink(source().(*corev1.Secret).Marshal()) // $ KsIoApiCoreV
	}
	{
		// func (m *Secret) MarshalTo(dAtA []byte) (int, error)
		var dAtA []byte
		source().(*corev1.Secret).MarshalTo(dAtA)
		sink(dAtA) // $ KsIoApiCoreV
	}
	{
		// func (m *Secret) MarshalToSizedBuffer(dAtA []byte) (int, error)
		var dAtA []byte
		source().(*corev1.Secret).MarshalToSizedBuffer(dAtA)
		sink(dAtA) // $ KsIoApiCoreV
	}
	{
		// func (m *Secret) Unmarshal(dAtA []byte) error
		var dAtA []byte
		source().(*corev1.Secret).Unmarshal(dAtA)
		sink(dAtA) // $ KsIoApiCoreV
	}

	{
		// func (in *SecretList) DeepCopy() *SecretList
		sink(source().(*corev1.SecretList).DeepCopy()) // $ KsIoApiCoreV
	}
	{
		// func (in *SecretList) DeepCopyInto(out *SecretList)
		var out *corev1.SecretList
		source().(*corev1.SecretList).DeepCopyInto(out)
		sink(out) // $ KsIoApiCoreV
	}
	{
		// func (in *SecretList) DeepCopyObject() runtime.Object
		sink(source().(*corev1.SecretList).DeepCopyObject()) // $ KsIoApiCoreV
	}
	{
		// func (m *SecretList) Marshal() (dAtA []byte, err error)
		sink(source().(*corev1.SecretList).Marshal()) // $ KsIoApiCoreV
	}
	{
		// func (m *SecretList) MarshalTo(dAtA []byte) (int, error)
		var dAtA []byte
		source().(*corev1.SecretList).MarshalTo(dAtA)
		sink(dAtA) // $ KsIoApiCoreV
	}
	{
		// func (m *SecretList) MarshalToSizedBuffer(dAtA []byte) (int, error)
		var dAtA []byte
		source().(*corev1.SecretList).MarshalToSizedBuffer(dAtA)
		sink(dAtA) // $ KsIoApiCoreV
	}
	{
		// func (m *SecretList) Unmarshal(dAtA []byte) error
		var dAtA []byte
		source().(*corev1.SecretList).Unmarshal(dAtA)
		sink(dAtA) // $ KsIoApiCoreV
	}
}

func dummy1(runtime.ProtobufMarshaller)        {}
func dummy2(runtime.ProtobufReverseMarshaller) {}
