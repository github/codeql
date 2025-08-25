package main

import "github.com/anotherpkg"

type T1 map[string][]string
type T2 T1

// A generic function with one type parameter
func GenericFunctionOneTypeParam[T any](t T) T {
	var r T
	return r
}

// A generic function with two type parameter
func GenericFunctionTwoTypeParams[K comparable, V int64 | float64](m map[K]V) V {
	var s V
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

	// Access a map through two type aliases
	aliasedMap := T2{"key": []string{"value"}}
	// Map read
	_ = aliasedMap["key"]
	// Map write
	aliasedMap["key"][0] = "new value"
}

type GenericStruct1[T any] struct {
}

type GenericStruct2[S, T any] struct {
}

func (x GenericStruct1[TF1]) f1() TF1 {
	var r TF1
	return r
}

func (x *GenericStruct1[TG1]) g1() {
}

func (x GenericStruct2[SF2, TF2]) f2() {
}

func (x *GenericStruct2[SG2, TG2]) g2() {
}

func call_methods_with_generic_receiver() {
	x1 := GenericStruct1[int]{}
	x1.f1()
	x1.g1()

	x2 := GenericStruct2[string, int]{}
	x2.f2()
	x2.g2()
}

type Element[S any] struct {
	list *List[S]
}

type List[T any] struct {
	root Element[T]
}

// Len is the number of elements in the list.
func (l *List[U]) MyLen() int {
	return 0
}

type NodeConstraint[Edge any] interface {
	Edges() []Edge
}

type EdgeConstraint[Node any] interface {
	Nodes() (from, to Node)
}

type Graph[Node NodeConstraint[Edge], Edge EdgeConstraint[Node]] struct{}

func New[Node NodeConstraint[Edge], Edge EdgeConstraint[Node]](nodes []Node) *Graph[Node, Edge] {
	return nil
}

func (g *Graph[Node, Edge]) ShortestPath(from, to Node) []Edge { return []Edge{} }

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
