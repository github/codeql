package dom

import (
	"github.com/lestrrat-go/libxml2/clib"
	"github.com/lestrrat-go/libxml2/types"
	"github.com/lestrrat-go/libxml2/xpath"
	"github.com/pkg/errors"
)

// ChildNodes returns the child nodes
func (n *XMLNode) ChildNodes() (types.NodeList, error) {
	list, err := clib.XMLChildNodes(n)
	if err != nil {
		return nil, errors.Wrap(err, "failed to get child node pointers")
	}

	ret := make(types.NodeList, len(list))
	for i, x := range list {
		ret[i], err = WrapNode(x)
		if err != nil {
			return nil, errors.Wrap(err, "failed to wrap node pointer")
		}
	}
	return ret, nil
}

func (n *XMLNode) RemoveChild(t types.Node) error {
	return clib.XMLRemoveChild(n, t)
}

// Pointer returns the pointer to the underlying C struct
func (n *XMLNode) Pointer() uintptr {
	return n.ptr
}

// String returns the string representation
func (n *XMLNode) String() string {
	return n.ToString(0, false)
}

// OwnerDocument returns the Document that this node belongs to
func (n *XMLNode) OwnerDocument() (types.Document, error) {
	ptr, err := clib.XMLOwnerDocument(n)
	if err != nil {
		return nil, errors.Wrap(err, "failed to get valid owner document")
	}

	if ptr == 0 {
		return nil, errors.Wrap(clib.ErrInvalidDocument, "failed to get valid owner document")
	}
	return WrapDocument(ptr), nil
}

// NodeName returns the node name
func (n *XMLNode) NodeName() string {
	s, err := clib.XMLNodeName(n)
	if err != nil {
		return ""
	}
	return s
}

// NodeValue returns the node value
func (n *XMLNode) NodeValue() string {
	s, err := clib.XMLNodeValue(n)
	if err != nil {
		return ""
	}
	return s
}

// Literal returns the literal string value
func (n XMLNode) Literal() (string, error) {
	return n.String(), nil
}

// IsSameNode returns true if two nodes point to the same node
func (n *XMLNode) IsSameNode(other types.Node) bool {
	return n.Pointer() == other.Pointer()
}

// Copy creates a copy of the node
func (n *XMLNode) Copy() (types.Node, error) {
	doc, err := n.OwnerDocument()
	if err != nil {
		return nil, errors.Wrap(err, "failed to get owner document")
	}
	nptr, err := clib.XMLDocCopyNode(n, doc, 1)
	if err != nil {
		return nil, errors.Wrap(err, "failed to copy document nodes")
	}
	return WrapNode(nptr)
}

// SetDocument sets the document of this node and its descendants
func (n *XMLNode) SetDocument(d types.Document) error {
	return clib.XMLSetTreeDoc(n, d)
}

// ParseInContext parses a chunk of XML in the context of the current
// node. This makes it safe to append the resulting node to the current
// node or other nodes in the same document.
func (n *XMLNode) ParseInContext(s string, o int) (types.Node, error) {
	nptr, err := clib.XMLParseInNodeContext(n, s, o)
	if err != nil {
		return nil, errors.Wrap(err, "failed to parse input")
	}
	return WrapNode(nptr)
}

// Find evaluates the xpath expression and returns the matching nodes
func (n *XMLNode) Find(expr string) (types.XPathResult, error) {
	ctx, err := xpath.NewContext(n)
	if err != nil {
		return nil, errors.Wrap(err, "failed to create new XPath context")
	}
	defer ctx.Free()

	return ctx.Find(expr)
}

// FindExpr evalues the pre-compiled xpath expression and returns the matching nodes
func (n *XMLNode) FindExpr(expr *xpath.Expression) (types.XPathResult, error) {
	ctx, err := xpath.NewContext(n)
	if err != nil {
		return nil, errors.Wrap(err, "failed to create new XPath context")
	}
	defer ctx.Free()

	return ctx.FindExpr(expr)
}

// HasChildNodes returns true if the node contains children
func (n *XMLNode) HasChildNodes() bool {
	return clib.XMLHasChildNodes(n)
}

// FirstChild reutrns the first child node
func (n *XMLNode) FirstChild() (types.Node, error) {
	ptr, err := clib.XMLFirstChild(n)
	if err != nil {
		return nil, errors.Wrap(err, "failed to get valid pointer to first child")
	}
	return WrapNode(ptr)
}

// LastChild returns the last child node
func (n *XMLNode) LastChild() (types.Node, error) {
	ptr, err := clib.XMLLastChild(n)
	if err != nil {
		return nil, errors.Wrap(err, "failed to get valid pointer to first child")
	}
	return WrapNode(ptr)
}

// LocalName returns the local name
func (n *XMLNode) LocalName() string {
	return clib.XMLLocalName(n)
}

// NamespaceURI returns the namespace URI associated with this node
func (n *XMLNode) NamespaceURI() string {
	return clib.XMLNamespaceURI(n)
}

// NextSibling returns the next sibling
func (n *XMLNode) NextSibling() (types.Node, error) {
	ptr, err := clib.XMLNextSibling(n)
	if err != nil {
		return nil, errors.Wrap(err, "failed to get valid pointer to next child")
	}
	if ptr == 0 {
		return nil, nil
	}
	return WrapNode(ptr)
}

// ParentNode returns the parent node
func (n *XMLNode) ParentNode() (types.Node, error) {
	ptr, err := clib.XMLParentNode(n)
	if err != nil {
		return nil, errors.Wrap(err, "failed to get valid pointer to parent node")
	}

	return WrapNode(ptr)
}

// Prefix returns the prefix from the node name, if any
func (n *XMLNode) Prefix() string {
	return clib.XMLPrefix(n)
}

// PreviousSibling returns the previous sibling
func (n *XMLNode) PreviousSibling() (types.Node, error) {
	ptr, err := clib.XMLPreviousSibling(n)
	if err != nil {
		return nil, errors.Wrap(err, "failed to get valid pointer to previous child")
	}

	return WrapNode(ptr)
}

// SetNodeName sets the node name
func (n *XMLNode) SetNodeName(name string) {
	_ = clib.XMLSetNodeName(n, name)
}

// SetNodeValue sets the node value
func (n *XMLNode) SetNodeValue(value string) {
	_ = clib.XMLSetNodeValue(n, value)
}

// AddChild appends the node
func (n *XMLNode) AddChild(child types.Node) error {
	return clib.XMLAddChild(n, child)
}

// TextContent returns the text content
func (n *XMLNode) TextContent() string {
	return clib.XMLTextContent(n)
}

// ToString returns the string representation. (But it should probably
// be deprecated)
func (n *XMLNode) ToString(format int, docencoding bool) string {
	return clib.XMLToString(n, format, docencoding)
}

// LookupNamespacePrefix returns the prefix associated with the given URL
func (n *XMLNode) LookupNamespacePrefix(href string) (string, error) {
	return clib.XMLLookupNamespacePrefix(n, href)
}

// LookupNamespaceURI returns the URI associated with the given prefix
func (n *XMLNode) LookupNamespaceURI(prefix string) (string, error) {
	return clib.XMLLookupNamespaceURI(n, prefix)
}

// NodeType returns the XMLNodeType
func (n *XMLNode) NodeType() clib.XMLNodeType {
	return clib.XMLGetNodeType(n)
}

// MakeMortal flags the node so that `AutoFree` calls Free()
// to release the underlying C resources.
func (n *XMLNode) MakeMortal() {
	n.mortal = true
}

// MakePersistent flags the node so that `AutoFree` becomes a no-op.
// Make sure to call this if you used `MakeMortal` and `AutoFree`,
// but you then decided to keep the node around.
func (n *XMLNode) MakePersistent() {
	n.mortal = false
}

// Free releases the underlying C struct
func (n *XMLNode) Free() {
	_ = clib.XMLFreeNode(n)
	n.ptr = 0
}

func walk(n types.Node, fn func(types.Node) error) error {
	if err := fn(n); err != nil {
		return errors.Wrap(err, "failed to call callback")
	}
	children, err := n.ChildNodes()
	if err != nil {
		return errors.Wrap(err, "failed to fetch child nodes")
	}
	for _, c := range children {
		if err := walk(c, fn); err != nil {
			return errors.Wrap(err, "failed to walk to child nodes")
		}
	}
	return nil
}

// Walk traverses through all of the nodes
func (n *XMLNode) Walk(fn func(types.Node) error) error {
	return walk(n, fn)
}

// AutoFree allows you to free the underlying C resources. It is
// meant to be called from defer. If you don't call `MakeMortal()` or
// do call `MakePersistent()`, AutoFree is a no-op.
func (n *XMLNode) AutoFree() {
	if !n.mortal {
		return
	}
	n.Free()
}
