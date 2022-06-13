package main

type myint struct {
	val int
}

func (me myint) bump(other int) {
	me.val += other
}

func (myint) foo() {
}
