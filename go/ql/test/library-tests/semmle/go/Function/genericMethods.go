package main

type StructForGenericMethod1 struct{}

func (*StructForGenericMethod1) GenericMethod1[P1 any](x P1) {}

type StructForGenericMethod2[P2 any] struct{}

func (*StructForGenericMethod2[P3]) GenericMethod2[P4 any](x P4) {}

func generic_methods(s1 StructForGenericMethod1, s2 StructForGenericMethod2[int]) {
	// Call the generic method specifying the type
	s1.GenericMethod1[int](1)
	s2.GenericMethod2[string]("hello")

	// Call the generic method without specifying the type
	s1.GenericMethod1("hello")
	s2.GenericMethod2(42)
}

type StructWithDependentBound[P5 any] struct{}

func (*StructWithDependentBound[P6]) GenericMethodWithDependentBound[P7 ~[]P6](x P7) {}

func genericMethodDependentBounds(t1 StructWithDependentBound[int], t2 StructWithDependentBound[string]) {
	t1.GenericMethodWithDependentBound([]int{})
	t2.GenericMethodWithDependentBound([]string{})
}
