// Copyright 2011 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package jade

import (
	"bytes"
	"io"
)

// var textFormat = "%s" // Changed to "%q" in tests for better error messages.

// A Node is an element in the parse tree. The interface is trivial.
// The interface contains an unexported method so that only
// types local to this package can satisfy it.
type node interface {
	Type() nodeType
	String() string
	WriteIn(io.Writer)
	// Copy does a deep copy of the Node and all its components.
	// To avoid type assertions, some XxxNodes also have specialized
	// CopyXxx methods that return *XxxNode.
	Copy() node
	position() pos // byte position of start of node in full original input string
	// tree returns the containing *tree.
	// It is unexported so all implementations of Node are in this package.
	tree() *tree
}

// pos represents a byte position in the original input text from which
// this template was parsed.
type pos int

func (p pos) position() pos {
	return p
}

// Nodes.

// listNode holds a sequence of nodes.
type listNode struct {
	nodeType
	pos
	tr    *tree
	Nodes []node // The element nodes in lexical order.
}

func (t *tree) newList(pos pos) *listNode {
	return &listNode{tr: t, nodeType: nodeList, pos: pos}
}

func (l *listNode) append(n node) {
	l.Nodes = append(l.Nodes, n)
}

func (l *listNode) tree() *tree {
	return l.tr
}

func (l *listNode) String() string {
	b := new(bytes.Buffer)
	l.WriteIn(b)
	return b.String()
}
func (l *listNode) WriteIn(b io.Writer) {
	for _, n := range l.Nodes {
		n.WriteIn(b)
	}
}

func (l *listNode) CopyList() *listNode {
	if l == nil {
		return l
	}
	n := l.tr.newList(l.pos)
	for _, elem := range l.Nodes {
		n.append(elem.Copy())
	}
	return n
}

func (l *listNode) Copy() node {
	return l.CopyList()
}
