package a

type C struct {
	field int
}

func (c C) m(a A)   {}
func (c *C) mp(a A) {}

type B struct {
	cptr *C
}

type A struct {
	b    B
	bptr *B
	bs   [5]B
}

func f() {

	a := A{}
	a.bptr = &a.b
	a.bs[3].cptr = &C{}
	a.bs[3].cptr.field = 100
	a.bptr.cptr.field = 101

	c := C{0}
	c.m(a)
	c.mp(a)

	// Indirect method calls - missing post-update nodes for the receivers
	f := c.m
	fp := c.mp
	f(a)
	fp(a)
}

func mutateC(c *C) {
	c.field = 200
}

func g(ch chan *C) {
	a := A{}

	// Read-only pointer dereference chain: no post-update nodes
	_ = a.bptr.cptr.field

	// Nested method call receiver: post-update nodes propagate along the chain
	a.bptr.cptr.mp(a)

	// Nested call argument: post-update nodes propagate along the chain
	mutateC(a.bptr.cptr)

	// Method call on channel receive: post-update nodes on `<-ch` and `ch`
	(<-ch).mp(a)
}
