package main

type GenericStruct1[T any] struct {
	valueField   T
	pointerField *T
	arrayField   [10]T
	sliceField   []T
	mapField     map[string]T
}

type CircularGenericStruct1[T error] struct {
	pointerField *CircularGenericStruct1[T]
}

type UsesCircularGenericStruct1[T error] struct {
	root CircularGenericStruct1[T]
}

type GenericStruct2[S comparable, T int] struct {
	structField GenericStruct1[S]
	mapField    map[S]T
}

type GenericStruct2b[S string, T int] struct {
	structField GenericStruct2[S, T]
}

type CircularGenericStruct2[S, T any] struct {
	pointerField *CircularGenericStruct2[S, T]
}

type GenericInterface[T ~int32 | ~int64] interface {
	GetT() T
}

type GenericArray[T comparable] [10]T
type GenericPointer[T any] *T
type GenericSlice[T any] []T
type GenericMap1[V any] map[string]V
type GenericMap2[K comparable, V any] map[K]V
type GenericChannel[T comparable] chan<- T
type MyMapType map[string]int
type GenericDefined[T comparable] MyMapType
type MyFuncType1[T any] func(T)
type MyFuncType2[T1 any, T2 any] func(T1) T2

type MyInterface[U comparable] interface {
	clone() MyInterface[U]
	dummy1() [10]U
	dummy2() *U
	dummy3() []U
	dummy4() map[U]U
	dummy5() chan<- U
	dummy6() MyMapType
	dummy7() MyFuncType2[int, bool]
	dummy11() GenericArray[U]
	dummy12() GenericPointer[U]
	dummy13() GenericSlice[U]
	dummy14() GenericMap1[U]
	dummy15() GenericMap2[U, U]
	dummy17() GenericChannel[U]
	dummy18() GenericDefined[U]
	dummy19() MyFuncType1[U]
	dummy20() MyFuncType2[U, U]
}

type HasBlankTypeParam[_ any] struct{}
type HasBlankTypeParams[_ any, _ comparable, T ~string] struct{}

func callMethodOnInstantiatedInterface(x GenericInterface[int32]) int32 {
	return x.GetT()
}

func accessFieldsOfInstantiatedStruct(x GenericStruct1[string]) {
	_ = x.valueField
	_ = x.pointerField
	_ = x.arrayField
	_ = x.sliceField
	_ = x.mapField
}

type TypeAlias = GenericArray[int]

type GenericSignature[T any] func(t T) T
type GenericSignatureAlias = GenericSignature[string]
