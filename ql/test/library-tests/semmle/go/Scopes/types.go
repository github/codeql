package main

type iHaveAMethod interface {
	meth() int
}

type twoMethods interface {
	meth1() bool
	meth2() int
}

type starImpl struct{}

func (*starImpl) meth1() bool {
	return false
}

func (starImpl) meth2() int {
	return 42
}

type notImpl struct{}

func (notImpl) meth1(a int) bool {
	return a == 42
}

func (notImpl) meth2() int {
	return -42
}
