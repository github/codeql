package main

type Baz struct {
	A string
}

type Qux struct {
	*Baz
}

// EmbedsBaz should have a field A but does not
type EmbedsBaz struct {
	Qux
	Baz string
}
