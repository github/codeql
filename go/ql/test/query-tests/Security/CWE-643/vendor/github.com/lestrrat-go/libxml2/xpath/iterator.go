package xpath

import (
	"github.com/lestrrat-go/libxml2/types"
)

// NodeIterator is a way to get at a list of nodes returned
// by XPath et al in a lazy (and possibly more efficient) manner.
type NodeIterator struct {
	cur     int
	curnode types.Node
	nlen    int
	nodes   []uintptr
}

func NewNodeIterator(nodes []uintptr) *NodeIterator {
	return &NodeIterator{
		cur:   -1,
		nlen:  len(nodes),
		nodes: nodes,
	}
}

// Next returns true if there is at least one more node in the
// iterator.
func (n *NodeIterator) Next() bool {
	if n.nlen == 0 || n.cur+1 >= n.nlen {
		return false
	}

	n.cur++
	node, err := WrapNodeFunc(n.nodes[n.cur])
	if err != nil {
		n.nlen = 0
		return false
	}
	n.curnode = node
	return true
}

func (n *NodeIterator) Node() types.Node {
	return n.curnode
}
