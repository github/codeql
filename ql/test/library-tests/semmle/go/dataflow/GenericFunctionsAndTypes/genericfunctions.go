package main

func genericSource[T any](t T) string {
	x := source()
	return x
}

func genericIdentity[T any](t T) T {
	return t
}

func genericSink1[T any](t T, u string) {
	sink(u) // $ hasValueFlow="u"
}

func genericSink2[T any](t T, u string) {
	sink(u) // $ hasValueFlow="u"
}

func genericSink3[T any](t T, u string) {
	sink(u) // $ hasValueFlow="u"
}

func test() {
	var x struct {
		x1 int
		x2 string
	}
	{
		s := genericSource(x)
		sink(s) // $ hasValueFlow="s"
	}
	{
		s := genericSource[int8](2)
		sink(s) // $ hasValueFlow="s"
	}
	{
		f := genericSource[int8]
		s := f(2)
		sink(s) // $ hasValueFlow="s"
	}
	{
		s := genericIdentity(source())
		sink(s) // $ hasValueFlow="s"
	}
	{
		s := genericIdentity[string](source())
		sink(s) // $ hasValueFlow="s"
	}
	{
		f := genericIdentity[string]
		s := f(source())
		sink(s) // $ hasValueFlow="s"
	}
	{
		s := source()
		genericSink1(x, s)
	}
	{
		s := source()
		genericSink2[uint16](3, s)
	}
	{
		s := source()
		f := genericSink3[uint16]
		f(3, s)
	}
}
