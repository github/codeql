package pkg1

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

type AEmbedded interface {
	A
}

type AC interface {
	A
	C
}

type AExtended interface {
	A
	n()
}

type A2 interface {
	m()
}
