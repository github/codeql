package main

import (
	"io"
	"net/url"
	"reflect"

	"k8s.io/apimachinery/pkg/conversion"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/runtime/schema"
)

//go:generate depstubber -vendor k8s.io/apimachinery/pkg/conversion Scope
//go:generate depstubber -vendor k8s.io/apimachinery/pkg/runtime/schema GroupVersionKind,ObjectKind
//go:generate depstubber -vendor k8s.io/apimachinery/pkg/runtime CacheableObject,Decoder,Encoder,Framer,WithVersionEncoder,WithoutVersionDecoder,ObjectConvertor,ObjectVersioner,ParameterCodec,ProtobufMarshaller,ProtobufReverseMarshaller,Unknown,Unstructured Convert_Slice_string_To_Pointer_int64,Convert_Slice_string_To_int,Convert_Slice_string_To_int64,Convert_Slice_string_To_string,Convert_runtime_Object_To_runtime_RawExtension,Convert_runtime_RawExtension_To_runtime_Object,Convert_string_To_Pointer_int64,Convert_string_To_int64,DecodeInto,DeepCopyJSON,DeepCopyJSONValue,Encode,EncodeOrDie,Field,FieldPtr,SetField,Decode,NewEncodable,NewEncodableList,UseOrCreateObject

func source() interface{} {
	return make([]byte, 1, 1)
}

func sink(interface{}) {
}

func main() {
	var decoder myDecoder
	var s conversion.Scope

	var encoder myEncoder

	{
		// func Convert_Slice_string_To_Pointer_int64(in *[]string, out **int64, s conversion.Scope) error
		var out **int64
		runtime.Convert_Slice_string_To_Pointer_int64(source().(*[]string), out, s)
		sink(out) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func Convert_Slice_string_To_int(in *[]string, out *int, s conversion.Scope) error
		var out *int
		runtime.Convert_Slice_string_To_int(source().(*[]string), out, s)
		sink(out) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func Convert_Slice_string_To_int64(in *[]string, out *int64, s conversion.Scope) error
		var out *int64
		runtime.Convert_Slice_string_To_int64(source().(*[]string), out, s)
		sink(out) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func Convert_Slice_string_To_string(in *[]string, out *string, s conversion.Scope) error
		var out *string
		runtime.Convert_Slice_string_To_string(source().(*[]string), out, s)
		sink(out) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func Convert_runtime_Object_To_runtime_RawExtension(in *Object, out *RawExtension, s conversion.Scope) error
		var out *runtime.RawExtension
		runtime.Convert_runtime_Object_To_runtime_RawExtension(source().(*runtime.Object), out, s)
		sink(out) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func Convert_runtime_RawExtension_To_runtime_Object(in *RawExtension, out *Object, s conversion.Scope) error
		var out *runtime.Object
		runtime.Convert_runtime_RawExtension_To_runtime_Object(source().(*runtime.RawExtension), out, s)
		sink(out) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func Convert_string_To_Pointer_int64(in *string, out **int64, s conversion.Scope) error
		var out **int64
		runtime.Convert_string_To_Pointer_int64(source().(*string), out, s)
		sink(out) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func Convert_string_To_int64(in *string, out *int64, s conversion.Scope) error
		var out *int64
		runtime.Convert_string_To_int64(source().(*string), out, s)
		sink(out) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func DecodeInto(d Decoder, data []byte, into Object) error
		var o runtime.Object
		runtime.DecodeInto(decoder, source().([]byte), o)
		sink(o) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func DeepCopyJSON(x map[string]interface{}) map[string]interface{}
		sink(runtime.DeepCopyJSON(source().(map[string]interface{}))) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func DeepCopyJSONValue(x interface{}) interface{}
		sink(runtime.DeepCopyJSONValue(source().(map[string]interface{}))) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func Encode(e Encoder, obj Object) ([]byte, error)
		x, _ := runtime.Encode(encoder, source().(runtime.Object))
		sink(x) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func EncodeOrDie(e Encoder, obj Object) string
		sink(runtime.EncodeOrDie(encoder, source().(runtime.Object))) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func Field(v reflect.Value, fieldName string, dest interface{}) error
		var fieldName string
		var dest interface{}
		runtime.Field(source().(reflect.Value), fieldName, dest)
		sink(dest) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func FieldPtr(v reflect.Value, fieldName string, dest interface{}) error
		var fieldName string
		var dest interface{}
		runtime.FieldPtr(source().(reflect.Value), fieldName, dest)
		sink(dest) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func SetField(src interface{}, v reflect.Value, fieldName string) error
		var v reflect.Value
		var fieldName string
		runtime.SetField(source(), v, fieldName)
		sink(v) // $ KsIoApimachineryPkgRuntime
	}
	{
		//    CacheEncode(id Identifier, encode func(Object, io.Writer) error, w io.Writer) error
		var id runtime.Identifier
		var encode func(runtime.Object, io.Writer) error
		var w io.Writer
		source().(myCacheableObject).CacheEncode(id, encode, w)
		sink(w) // $ KsIoApimachineryPkgRuntime
	}
	{
		//    GetObject() Object
		sink(source().(myCacheableObject).GetObject()) // $ KsIoApimachineryPkgRuntime
	}
	{
		// Decode(data []byte, defaults *schema.GroupVersionKind, into Object) (Object, *schema.GroupVersionKind, error)
		var defaults *schema.GroupVersionKind
		var into runtime.Object
		x, _, _ := decoder.Decode(source().([]byte), defaults, into)
		sink(x)    // $ KsIoApimachineryPkgRuntime
		sink(into) // $ KsIoApimachineryPkgRuntime
	}
	{
		// Decode(data []byte, defaults *schema.GroupVersionKind, into Object) (Object, *schema.GroupVersionKind, error)
		var defaults *schema.GroupVersionKind
		var into runtime.Object
		var withoutVersionDecoder runtime.WithoutVersionDecoder
		x, _, _ := withoutVersionDecoder.Decode(source().([]byte), defaults, into)
		sink(x)    // $ KsIoApimachineryPkgRuntime
		sink(into) // $ KsIoApimachineryPkgRuntime
	}
	{
		// Encode(obj Object, w io.Writer) error
		var w io.Writer
		encoder.Encode(source().(runtime.Object), w)
		sink(w) // $ KsIoApimachineryPkgRuntime
	}
	{
		// Encode(obj Object, w io.Writer) error
		var w io.Writer
		var withVersionEncoder runtime.WithVersionEncoder
		withVersionEncoder.Encode(source().(runtime.Object), w)
		sink(w) // $ KsIoApimachineryPkgRuntime
	}
	{
		var framer myFramer

		// NewFrameReader(r io.ReadCloser) io.ReadCloser
		sink(framer.NewFrameReader(source().(io.ReadCloser))) // $ KsIoApimachineryPkgRuntime

		// NewFrameWriter(w io.Writer) io.Writer
		sink(framer.NewFrameWriter(source().(io.Writer))) // $ KsIoApimachineryPkgRuntime
	}
	{
		// DeepCopyObject() Object
		sink(source().(runtime.Object).DeepCopyObject()) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func Decode(d Decoder, data []byte) (Object, error)
		o, _ := runtime.Decode(decoder, source().([]byte))
		sink(o) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func NewEncodable(e Encoder, obj Object, versions ...schema.GroupVersion) Object
		sink(runtime.NewEncodable(encoder, source().(runtime.Object))) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func NewEncodableList(e Encoder, objects []Object, versions ...schema.GroupVersion) []Object
		sink(runtime.NewEncodableList(encoder, source().([]runtime.Object))) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func UseOrCreateObject(t ObjectTyper, c ObjectCreater, gvk schema.GroupVersionKind, obj Object) (Object, error)
		var t runtime.ObjectTyper
		var c runtime.ObjectCreater
		var gvk schema.GroupVersionKind
		o, _ := runtime.UseOrCreateObject(t, c, gvk, source().(runtime.Object))
		sink(o) // $ KsIoApimachineryPkgRuntime
	}
	{
		var objectConverter myObjectConverter

		//    Convert(in, out, context interface{}) error
		var out, context interface{}
		objectConverter.Convert(source(), out, context)
		sink(out) // $ KsIoApimachineryPkgRuntime

		//    ConvertToVersion(in Object, gv GroupVersioner) (out Object, err error)
		var gv runtime.GroupVersioner
		o, _ := objectConverter.ConvertToVersion(source().(runtime.Object), gv)
		sink(o) // $ KsIoApimachineryPkgRuntime
	}
	{
		var parameterCodec myParameterCodec

		//    DecodeParameters(parameters url.Values, from schema.GroupVersion, into Object) error
		var gv schema.GroupVersion
		var into runtime.Object
		parameterCodec.DecodeParameters(source().(url.Values), gv, into)
		sink(into) // $ KsIoApimachineryPkgRuntime

		//    EncodeParameters(obj Object, to schema.GroupVersion) (url.Values, error)
		urlValues, _ := parameterCodec.EncodeParameters(source().(runtime.Object), gv)
		sink(urlValues) // $ KsIoApimachineryPkgRuntime
	}
	{
		//    MarshalTo(data []byte) (int, error)
		var data []byte
		source().(myProtobufMarshaller).MarshalTo(data)
		sink(data) // $ KsIoApimachineryPkgRuntime
	}
	{
		//    MarshalToSizedBuffer(data []byte) (int, error)
		var data []byte
		source().(myProtobufReverseMarshaller).MarshalToSizedBuffer(data)
		sink(data) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func (in *RawExtension) DeepCopy() *RawExtension
		sink(source().(*runtime.RawExtension).DeepCopy()) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func (in *RawExtension) DeepCopyInto(out *RawExtension)
		var out *runtime.RawExtension
		source().(*runtime.RawExtension).DeepCopyInto(out)
		sink(out) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func (m *RawExtension) Marshal() (dAtA []byte, err error)
		dAtA, _ := source().(*runtime.RawExtension).Marshal()
		sink(dAtA) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func (m *RawExtension) MarshalTo(dAtA []byte) (int, error)
		var dAtA []byte
		source().(*runtime.RawExtension).MarshalTo(dAtA)
		sink(dAtA) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func (m *RawExtension) MarshalToSizedBuffer(dAtA []byte) (int, error)
		var dAtA []byte
		source().(*runtime.RawExtension).MarshalToSizedBuffer(dAtA)
		sink(dAtA) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func (m *RawExtension) Unmarshal(dAtA []byte) error
		var dAtA []byte
		source().(*runtime.RawExtension).Unmarshal(dAtA)
		sink(dAtA) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func (in *Unknown) DeepCopy() *Unknown
		sink(source().(*runtime.Unknown).DeepCopy()) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func (in *Unknown) DeepCopyObject() Object
		sink(source().(*runtime.Unknown).DeepCopyObject()) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func (in *Unknown) DeepCopyInto(out *Unknown)
		var out *runtime.Unknown
		source().(*runtime.Unknown).DeepCopyInto(out)
		sink(out) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func (m *Unknown) Marshal() (dAtA []byte, err error)
		dAtA, _ := source().(*runtime.Unknown).Marshal()
		sink(dAtA) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func (m *Unknown) MarshalTo(dAtA []byte) (int, error)
		var dAtA []byte
		source().(*runtime.Unknown).MarshalTo(dAtA)
		sink(dAtA) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func (m *Unknown) MarshalToSizedBuffer(dAtA []byte) (int, error)
		var dAtA []byte
		source().(*runtime.Unknown).MarshalToSizedBuffer(dAtA)
		sink(dAtA) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func (m *Unknown) NestedMarshalTo(data []byte, b ProtobufMarshaller, size uint64) (int, error)
		var dAtA []byte
		var b myProtobufMarshaller
		source().(*runtime.Unknown).NestedMarshalTo(dAtA, b, 1)
		sink(dAtA) // $ KsIoApimachineryPkgRuntime
	}
	{
		// func (m *Unknown) Unmarshal(dAtA []byte) error
		var dAtA []byte
		source().(*runtime.Unknown).Unmarshal(dAtA)
		sink(dAtA) // $ KsIoApimachineryPkgRuntime
	}
	{
		//    UnstructuredContent() map[string]interface{}
		sink(source().(myUnstructured).UnstructuredContent()) // $ KsIoApimachineryPkgRuntime
	}
	{
		//    SetUnstructuredContent(map[string]interface{})
		var unstructured myUnstructured
		unstructured.SetUnstructuredContent(source().(map[string]interface{}))
		sink(unstructured) // $ KsIoApimachineryPkgRuntime
	}
}

type myCacheableObject struct{}

func (m myCacheableObject) CacheEncode(id runtime.Identifier, encode func(runtime.Object, io.Writer) error, w io.Writer) error {
	return nil
}

func (m myCacheableObject) GetObject() runtime.Object {
	return nil
}

type myDecoder struct{}

func (m myDecoder) Decode(data []byte, defaults *schema.GroupVersionKind, into runtime.Object) (runtime.Object, *schema.GroupVersionKind, error) {
	return nil, nil, nil
}

type myEncoder struct{}

func (m myEncoder) Encode(obj runtime.Object, w io.Writer) error { return nil }
func (m myEncoder) Identifier() runtime.Identifier               { return "" }

type myFramer struct{}

func (m myFramer) NewFrameReader(r io.ReadCloser) io.ReadCloser { return nil }
func (m myFramer) NewFrameWriter(w io.Writer) io.Writer         { return nil }

type myObjectConverter struct{}

func (m myObjectConverter) Convert(in, out, context interface{}) error { return nil }
func (m myObjectConverter) ConvertToVersion(in runtime.Object, gv runtime.GroupVersioner) (out runtime.Object, err error) {
	return nil, nil
}

func (m myObjectConverter) ConvertFieldLabel(gvk schema.GroupVersionKind, label, value string) (string, string, error) {
	return "", "", nil
}

type myParameterCodec struct{}

func (m myParameterCodec) DecodeParameters(parameters url.Values, from schema.GroupVersion, into runtime.Object) error {
	return nil
}

func (m myParameterCodec) EncodeParameters(obj runtime.Object, to schema.GroupVersion) (url.Values, error) {
	return nil, nil
}

type myProtobufMarshaller struct{}

func (m myProtobufMarshaller) MarshalTo(data []byte) (int, error) { return 0, nil }

type myProtobufReverseMarshaller struct{}

func (m myProtobufReverseMarshaller) MarshalToSizedBuffer(data []byte) (int, error) { return 0, nil }

type myUnstructured struct {
	runtime.Object
}

var objectForUnstructured runtime.Object

func (m myUnstructured) NewEmptyInstance() runtime.Unstructured {
	return myUnstructured{objectForUnstructured}
}

func (m myUnstructured) UnstructuredContent() map[string]interface{} { return nil }

func (m myUnstructured) SetUnstructuredContent(map[string]interface{}) {}

func (m myUnstructured) IsList() bool { return false }

func (m myUnstructured) EachListItem(func(runtime.Object) error) error { return nil }
