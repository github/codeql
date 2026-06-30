package main

type StructForGenericMethod1 struct{}

func (*StructForGenericMethod1) GenericMethod1[P any](x P) {}

type StructForGenericMethod2[P any] struct{}

func (*StructForGenericMethod2[P]) GenericMethod2[Q any](x Q) {}

func generic_methods(s1 StructForGenericMethod1, s2 StructForGenericMethod2[int]) {
	// Call the generic method specifying the type
	s1.GenericMethod1[int](1)
	//s2.GenericMethod2[string]("hello")

	// Call the generic method without specifying the type
	s1.GenericMethod1("hello")
	//s2.GenericMethod2(42)
}
