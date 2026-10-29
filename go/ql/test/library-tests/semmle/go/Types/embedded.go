package main

type Baz struct {
	A string
}

type Qux struct {
	*Baz
}

type EmbedsBaz struct {
	Qux
	Baz string
}
