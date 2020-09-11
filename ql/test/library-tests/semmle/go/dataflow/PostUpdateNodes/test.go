package a

type C struct {
	field int
}

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

}
