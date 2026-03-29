package dom

import (
	"github.com/lestrrat-go/libxml2/clib"
)

// Free releases the underlying C struct
func (n *Attribute) Free() {
	_ = clib.XMLFreeProp(n)
}

// HasChildNodes returns true if the node contains any child nodes.
// By definition attributes cannot have children, so this always
// returns false
func (n *Attribute) HasChildNodes() bool {
	return false
}

// Value returns the value of the attribute.
func (n *Attribute) Value() string {
	v, err := clib.XMLNodeValue(n)
	if err != nil {
		return ""
	}
	return v
}
