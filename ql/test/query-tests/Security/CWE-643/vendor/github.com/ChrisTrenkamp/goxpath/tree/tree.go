package tree

import "fmt"

type Node interface {
}

type Result interface {
	fmt.Stringer
}

type String string

func (s String) String() string {
	return ""
}
