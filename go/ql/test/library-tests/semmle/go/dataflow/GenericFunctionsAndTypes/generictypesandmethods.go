package main

func source() string {
	return "untrusted data"
}

func sink(string) {
}

type GenericStruct1[T any] struct {
	Field T
}

func (g GenericStruct1[U]) Identity(u U) U { return u }
func (g GenericStruct1[U]) Getter() U      { return g.Field }
func (g GenericStruct1[U]) Setter(u U)     { g.Field = u }

type GenericStruct2[S, T any] struct {
	Field1 S
	Field2 T
}

func (g GenericStruct2[U, _]) Identity1(u U) U { return u }
func (g GenericStruct2[U, _]) Getter1() U      { return g.Field1 }
func (g GenericStruct2[U, _]) Setter1(u U)     { g.Field1 = u }

func (g GenericStruct2[_, V]) Identity2(v V) V { return v }
func (g GenericStruct2[_, V]) Getter2() V      { return g.Field2 }
func (g GenericStruct2[_, V]) Setter2(v V)     { g.Field2 = v }

func main() {
	{
		gs1 := GenericStruct1[string]{source()}
		sink(gs1.Field) // $ hasValueFlow="selection of Field"
	}
	{
		gs1 := GenericStruct1[string]{""}
		sink(gs1.Identity(source())) // $ hasValueFlow="call to Identity"
	}
	{
		gs1 := GenericStruct1[string]{""}
		f := gs1.Identity
		sink(f(source())) // $ hasValueFlow="call to f"
	}
	{
		gs1 := GenericStruct1[string]{""}
		gs1.Field = source()
		sink(gs1.Getter()) // $ hasValueFlow="call to Getter"
	}
	{
		gs1 := GenericStruct1[string]{""}
		gs1.Field = source()
		f := gs1.Getter
		sink(f()) // $ hasValueFlow="call to f"
	}
	{
		gs1 := GenericStruct1[string]{""}
		gs1.Setter(source())
		sink(gs1.Field) // $ hasValueFlow="selection of Field"
	}
	{
		gs1 := GenericStruct1[string]{""}
		f := gs1.Setter
		f(source())
		sink(gs1.Field) // $ hasValueFlow="selection of Field"
	}

	{
		gs2 := GenericStruct2[string, string]{source(), ""}
		sink(gs2.Field1) // $ hasValueFlow="selection of Field1"
	}
	{
		gs2 := GenericStruct2[string, string]{"", ""}
		sink(gs2.Identity1(source())) // $ hasValueFlow="call to Identity1"
	}
	{
		gs2 := GenericStruct2[string, string]{"", ""}
		f := gs2.Identity1
		sink(f(source())) // $ hasValueFlow="call to f"
	}
	{
		gs2 := GenericStruct2[string, string]{"", ""}
		gs2.Field1 = source()
		sink(gs2.Getter1()) // $ hasValueFlow="call to Getter1"
	}
	{
		gs2 := GenericStruct2[string, string]{"", ""}
		gs2.Field1 = source()
		f := gs2.Getter1
		sink(f()) // $ hasValueFlow="call to f"
	}
	{
		gs2 := GenericStruct2[string, string]{"", ""}
		gs2.Setter1(source())
		sink(gs2.Field1) // $ hasValueFlow="selection of Field1"
	}
	{
		gs2 := GenericStruct2[string, string]{"", ""}
		f := gs2.Setter1
		f(source())
		sink(gs2.Field1) // $ hasValueFlow="selection of Field1"
	}

	{
		gs2 := GenericStruct2[string, string]{"", source()}
		sink(gs2.Field2) // $ hasValueFlow="selection of Field2"
	}
	{
		gs2 := GenericStruct2[string, string]{"", ""}
		sink(gs2.Identity2(source())) // $ hasValueFlow="call to Identity2"
	}
	{
		gs2 := GenericStruct2[string, string]{"", ""}
		f := gs2.Identity2
		sink(f(source())) // $ hasValueFlow="call to f"
	}
	{
		gs2 := GenericStruct2[string, string]{"", ""}
		gs2.Field2 = source()
		sink(gs2.Getter2()) // $ hasValueFlow="call to Getter2"
	}
	{
		gs2 := GenericStruct2[string, string]{"", ""}
		gs2.Field2 = source()
		f := gs2.Getter2
		sink(f()) // $ hasValueFlow="call to f"
	}
	{
		gs2 := GenericStruct2[string, string]{"", ""}
		gs2.Setter2(source())
		sink(gs2.Field2) // $ hasValueFlow="selection of Field2"
	}
	{
		gs2 := GenericStruct2[string, string]{"", ""}
		f := gs2.Setter2
		f(source())
		sink(gs2.Field2) // $ hasValueFlow="selection of Field2"
	}
}
