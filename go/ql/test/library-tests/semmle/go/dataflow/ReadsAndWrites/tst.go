package main

type t struct {
	f int
}

func (t *t) bump() int {
	t.f = t.f + 1
	return t.get()
}

func (t t) get() int {
	return t.f
}

func test(x t, xs [10]int, ps *[10]int) {
	x.f = x.f + 1
	x.bump()
	xs[0] = xs[1]
	ps[0] = ps[1]
}
