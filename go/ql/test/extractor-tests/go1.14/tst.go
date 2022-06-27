package main

type A interface {
	m()
}

type B interface {
	m()
	n()
}

type C interface {
	n()
	o()
}

type AA interface {
	A
	A
}

type AB interface {
	A
	B
}

type BC interface {
	B
	C
}

type AC interface {
	A
	C
}

type ABC interface {
	A
	B
	C
}

func main() {
}
