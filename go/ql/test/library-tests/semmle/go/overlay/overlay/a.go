package base

import "strings"

type C struct{}

type A struct {
	name string
}

func (a *A) GetNameUpper() string {
	return strings.ToUpper(a.name)
}

/*
 * A block comment.
 * With multiple lines.
 */
func (a *A) GetName() string {
	// A line comment.
	return a.name
}

func Id(name string) string {
	return name
}

/*
 * A block comment.
 * With multiple lines.
 */
func FuncC() *C {
	// A line comment.
	return &C{}
}
