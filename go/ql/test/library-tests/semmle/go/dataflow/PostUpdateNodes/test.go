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
