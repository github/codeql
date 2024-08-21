package main

import "github.com/anotherpkg"

type DefinedType1 map[string][]string
type DefinedType2 DefinedType1
type AliasType1 = DefinedType2
type AliasType2 = AliasType1

// A generic function with one type parameter
func GenericFunctionOneTypeParam[TP101 any](t TP101) TP101 {
	var r TP101
	return r
}

// A generic function with two type parameter
func GenericFunctionTwoTypeParams[TP102 comparable, TP103 int64 | float64](m map[TP102]TP103) TP103 {
	var s TP103
	for _, v := range m {
		s += v
	}
	return s
}

func generic_functions() {
	// Call the generic function with one type parameter, specifying the type
	GenericFunctionOneTypeParam[int](1)
	GenericFunctionOneTypeParam[string]("hello")

	// Call the generic function with one type parameter, without specifying the type
	GenericFunctionOneTypeParam(1)
	GenericFunctionOneTypeParam("hello")

	// Initialize a map for the integer values
	ints := map[string]int64{
		"first":  34,
		"second": 12,
	}

	// Initialize a map for the float values
	floats := map[string]float64{
		"first":  35.98,
		"second": 26.99,
	}

	_ = GenericFunctionTwoTypeParams[string, int64](ints)
	_ = GenericFunctionTwoTypeParams[string, float64](floats)

	_ = GenericFunctionTwoTypeParams(ints)
	_ = GenericFunctionTwoTypeParams(floats)

	// Map read
	_ = floats["first"]
	// Map write
	floats["first"] = -1.0

	arrayVar := [5]int{1, 2, 3, 4, 5}
	// Array read
	_ = arrayVar[0]
	// Array write
	arrayVar[0] = -1

	arrayPtr := &arrayVar
	// Array read through pointer
	_ = arrayPtr[0]
	// Array write through pointer
	arrayPtr[0] = -1

	sliceVar := make([]int, 0, 5) // $ isVariadic
	// Slice read
	_ = sliceVar[0]
	// Slice write
	sliceVar[0] = -1

	// Access a map through two named types
	mapThroughNamedTypes := DefinedType2{"key": []string{"value"}}
	// Map read
	_ = mapThroughNamedTypes["key"]
	// Map write
	mapThroughNamedTypes["key"][0] = "new value"
	// Access a map through two type aliases and two named types
	mapThroughAliasedTypes := AliasType2{"key": []string{"value"}}
	// Map read
	_ = mapThroughAliasedTypes["key"]
	// Map write
	mapThroughAliasedTypes["key"][0] = "new value"
}

type GenericStruct1[TP104 interface{}] struct {
}

type GenericStruct2[TP105, TP106 any] struct {
}

func (x GenericStruct1[TP107]) f1() TP107 {
	var r TP107
	return r
}

func (x *GenericStruct1[TP108]) g1() {
}

func (x GenericStruct2[TP109, TP110]) f2() {
}

func (x *GenericStruct2[TP111, TP112]) g2() {
}

func call_methods_with_generic_receiver() {
	x1 := GenericStruct1[int]{}
	x1.f1()
	x1.g1()

	x2 := GenericStruct2[string, int]{}
	x2.f2()
	x2.g2()
}

type Element[TP113 any] struct {
	list *List[TP113]
}

type List[TP114 any] struct {
	root Element[TP114]
}

// Len is the number of elements in the list.
func (l *List[TP115]) MyLen() int {
	return 0
}

type NodeConstraint[TP116 any] interface {
	Edges() []TP116
}

type EdgeConstraint[TP117 any] interface {
	Nodes() (from, to TP117)
}

type Graph[TP118 NodeConstraint[TP119], TP119 EdgeConstraint[TP118]] struct{}

func New[TP120 NodeConstraint[TP121], TP121 EdgeConstraint[TP120]](nodes []TP120) *Graph[TP120, TP121] {
	return nil
}

func (g *Graph[TP122, TP123]) ShortestPath(from, to TP122) []TP123 { return []TP123{} }

func callFunctionsInAnotherFile() {
	_ = GenericFunctionInAnotherFile[string]("world")
	_ = GenericFunctionInAnotherFile("world")
}

func callFunctionsInAnotherPackage() {
	_ = anotherpkg.GenericFunctionInAnotherPackage[string]("world")
	_ = anotherpkg.GenericFunctionInAnotherPackage("world")
}

func multipleAnonymousTypeParamsFunc[_ any, _ string, _ any]() {}

type multipleAnonymousTypeParamsType[_ any, _ string, _ any] struct{}

func (x multipleAnonymousTypeParamsType[_, _, _]) f() {}
