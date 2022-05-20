package main

type GenericStruct1[T any] struct {
	Field T
}

func (g GenericStruct1[U]) Identity(u U) U { return u }

type GenericStruct2[S, T any] struct {
	Field1 S
	Field2 T
}

func (g GenericStruct2[U, _]) Identity1(u U) U { return u }

func genericIdentity1[T any](t T) T {
	return t
}

func genericIdentity2[S, T any](s S, t T) (S, T) {
	return s, t
}

func generic() {
	gs1 := GenericStruct1[string]{"x"}
	a := gs1.Identity("hello")
	gs2 := GenericStruct2[string, string]{"y", "z"}
	b := gs2.Identity1(a)
	c := genericIdentity1[string](b)
	d := genericIdentity1(c)
	e, f := genericIdentity2[string, string](d, "hello")
	g, h := genericIdentity2(e, f)
	_ = g
	_ = h
}
