package base

import "strings"

type A struct {
	name string
}

/*
 * A block comment.
 * With multiple lines.
 */
func (a *A) GetNameLength() int {
	// A line comment.
	return len(a.name)
}

/*
 * A block comment.
 * With multiple lines.
 */
func (a *A) GetNameUpper() string {
	// A line comment.
	return strings.ToUpper(a.name)
}

func FuncA(name string) *A {
	return &A{name: name}
}

func Id(name string) string {
	return name
}

type B interface {
	GetName() string
}
