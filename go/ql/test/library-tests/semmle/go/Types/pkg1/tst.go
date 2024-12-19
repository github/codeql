package pkg1

import "github.com/github/codeql-go/ql/test/library-tests/semmle/go/Types/pkg2"

type T struct {
	f int
	Foo
	Bar
}

type T2 struct {
	Foo Foo
	Bar
}

type T3 struct {
	*Foo
	*Bar
}

type T4 struct {
	*Foo
	Bar Bar
}

type Foo struct {
	val  int
	flag bool
}

type Bar struct {
	flag bool
}

func (foo Foo) half() Foo {
	return Foo{foo.val / 2, true}
}

func use(x interface{}) {}

func test(t T, t2 T2) {
	// fields of T
	use(t.Bar)
	use(t.f)
	// illegal: use(t.flag)
	use(t.Foo)
	use(t.val)

	// methods of T
	t.half()

	// fields of T2
	use(t2.Bar)
	use(t2.flag)
	use(t2.Foo)

	// methods of T2
	// illegal: t2.half()
}

type NameClash struct {
	pkg2.NameClash
}
