package jsonquery

import (
	"fmt"

	"github.com/antchfx/xpath"
)

var _ xpath.NodeNavigator = &NodeNavigator{}

// CreateXPathNavigator creates a new xpath.NodeNavigator for the specified html.Node.
func CreateXPathNavigator(top *Node) *NodeNavigator {
	return &NodeNavigator{cur: top, root: top}
}

// Find is like QueryAll but will panics if `expr` cannot be parsed.
func Find(top *Node, expr string) []*Node {
	nodes, err := QueryAll(top, expr)
	if err != nil {
		panic(err)
	}
	return nodes
}

// FindOne is like Query but will panics if `expr` cannot be parsed.
func FindOne(top *Node, expr string) *Node {
	node, err := Query(top, expr)
	if err != nil {
		panic(err)
	}
	return node
}

// QueryAll searches the Node that matches by the specified XPath expr.
// Return an error if the expression `expr` cannot be parsed.
func QueryAll(top *Node, expr string) ([]*Node, error) {
	exp, err := getQuery(expr)
	if err != nil {
		return nil, err
	}
	return QuerySelectorAll(top, exp), nil
}

// Query searches the Node that matches by the specified XPath expr,
// and returns first element of matched.
func Query(top *Node, expr string) (*Node, error) {
	exp, err := getQuery(expr)
	if err != nil {
		return nil, err
	}
	return QuerySelector(top, exp), nil
}

// QuerySelectorAll searches all of the Node that matches the specified XPath selectors.
func QuerySelectorAll(top *Node, selector *xpath.Expr) []*Node {
	t := selector.Select(CreateXPathNavigator(top))
	var elems []*Node
	for t.MoveNext() {
		elems = append(elems, (t.Current().(*NodeNavigator)).cur)
	}
	return elems
}

// QuerySelector returns the first matched XML Node by the specified XPath selector.
func QuerySelector(top *Node, selector *xpath.Expr) *Node {
	t := selector.Select(CreateXPathNavigator(top))
	if t.MoveNext() {
		return (t.Current().(*NodeNavigator)).cur
	}
	return nil
}

// NodeNavigator is for navigating JSON document.
type NodeNavigator struct {
	root, cur *Node
}

func (a *NodeNavigator) Current() *Node {
	return a.cur
}

func (a *NodeNavigator) NodeType() xpath.NodeType {
	switch a.cur.Type {
	case TextNode:
		return xpath.TextNode
	case DocumentNode:
		return xpath.RootNode
	case ElementNode:
		return xpath.ElementNode
	default:
		panic(fmt.Sprintf("unknown node type %v", a.cur.Type))
	}
}

func (a *NodeNavigator) LocalName() string {
	return a.cur.Data

}

func (a *NodeNavigator) Prefix() string {
	return ""
}

func (a *NodeNavigator) Value() string {
	switch a.cur.Type {
	case ElementNode:
		return a.cur.InnerText()
	case TextNode:
		return a.cur.Data
	}
	return ""
}

func (a *NodeNavigator) Copy() xpath.NodeNavigator {
	n := *a
	return &n
}

func (a *NodeNavigator) MoveToRoot() {
	a.cur = a.root
}

func (a *NodeNavigator) MoveToParent() bool {
	if n := a.cur.Parent; n != nil {
		a.cur = n
		return true
	}
	return false
}

func (x *NodeNavigator) MoveToNextAttribute() bool {
	return false
}

func (a *NodeNavigator) MoveToChild() bool {
	if n := a.cur.FirstChild; n != nil {
		a.cur = n
		return true
	}
	return false
}

func (a *NodeNavigator) MoveToFirst() bool {
	for n := a.cur.PrevSibling; n != nil; n = n.PrevSibling {
		a.cur = n
	}
	return true
}

func (a *NodeNavigator) String() string {
	return a.Value()
}

func (a *NodeNavigator) MoveToNext() bool {
	if n := a.cur.NextSibling; n != nil {
		a.cur = n
		return true
	}
	return false
}

func (a *NodeNavigator) MoveToPrevious() bool {
	if n := a.cur.PrevSibling; n != nil {
		a.cur = n
		return true
	}
	return false
}

func (a *NodeNavigator) MoveTo(other xpath.NodeNavigator) bool {
	node, ok := other.(*NodeNavigator)
	if !ok || node.root != a.root {
		return false
	}
	a.cur = node.cur
	return true
}
