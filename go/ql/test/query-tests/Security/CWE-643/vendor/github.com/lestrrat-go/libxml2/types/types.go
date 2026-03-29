/*
Package types exist to provide with common types that are used
through out in go-libxml2. This package contains mainly interfaces
to things that are implemented else. It is in its own package
so that any package can refer to these interfaces without introducing
circular dependecy
*/
package types

import "bytes"

// String returns the string representation of the NodeList
func (n NodeList) String() string {
	buf := bytes.Buffer{}
	for _, x := range n {
		buf.WriteString(x.String())
	}
	return buf.String()
}

// NodeValue returns the concatenation of NodeValue within the nodes in NodeList
func (n NodeList) NodeValue() string {
	buf := bytes.Buffer{}
	for _, x := range n {
		buf.WriteString(x.NodeValue())
	}
	return buf.String()
}

// Literal returns the string representation of the NodeList (using Literal())
func (n NodeList) Literal() (string, error) {
	buf := bytes.Buffer{}
	for _, x := range n {
		l, err := x.Literal()
		if err != nil {
			return "", err
		}
		buf.WriteString(l)
	}
	return buf.String(), nil
}

// First returns the first node in the list, or nil otherwise.
func (n NodeList) First() Node {
	if n == nil {
		return nil
	}

	if len(n) > 0 {
		return n[0]
	}

	return nil
}
