package types

import "github.com/lestrrat-go/libxml2/clib"

// PtrSource defines the interface for things that is backed by
// a C backend
type PtrSource interface {
	// Pointer returns the underlying C pointer. This is an exported
	// method to allow various internal go-libxml2 packages to interoperate
	// on each other. End users are STRONGLY advised not to touch this
	// method or its return values
	Pointer() uintptr

	// Free releases the underlying resources
	Free()
}

// XPathExpression defines the interface for XPath expression
type XPathExpression interface {
	PtrSource
}

// XPathResult defines the interface for result of calling Find().
type XPathResult interface {
	Bool() bool
	Free()
	NodeList() NodeList
	NodeIter() NodeIter
	Number() float64
	String() string
	Type() clib.XPathObjectType
}

// Document defines the interface for XML document
type Document interface {
	Node
	CreateElement(string) (Element, error)
	CreateElementNS(string, string) (Element, error)
	DocumentElement() (Node, error)
	Dump(bool) string
	Encoding() string
}

// Attribute defines the interface for XML attribute
type Attribute interface {
	Node
	Value() string
}

// Element defines the interface for XML element
//
//nolint:interfacebloat
type Element interface {
	Node
	AppendText(string) error
	Attributes() ([]Attribute, error)
	GetAttribute(string) (Attribute, error)
	GetNamespaces() ([]Namespace, error)
	LocalName() string
	NamespaceURI() string
	Prefix() string
	RemoveAttribute(string) error
	SetAttribute(string, string) error
	SetNamespace(string, string, ...bool) error
}

// Namespace defines the interface for XML namespace
type Namespace interface {
	Node
	Prefix() string
	URI() string
}

// Node defines the basic DOM interface
//
//nolint:interfacebloat
type Node interface {
	PtrSource

	ParseInContext(string, int) (Node, error)

	AddChild(Node) error
	ChildNodes() (NodeList, error)
	Copy() (Node, error)
	OwnerDocument() (Document, error)
	Find(string) (XPathResult, error)
	FirstChild() (Node, error)
	HasChildNodes() bool
	IsSameNode(Node) bool
	LastChild() (Node, error)
	// Literal is almost the same as String(), except for things like Element
	// and Attribute nodes. String() will return the XML stringification of
	// these, but Literal() will return the "value" associated with them.
	Literal() (string, error)
	LookupNamespacePrefix(string) (string, error)
	LookupNamespaceURI(string) (string, error)
	NextSibling() (Node, error)
	NodeName() string
	NodeType() clib.XMLNodeType
	NodeValue() string
	ParentNode() (Node, error)
	PreviousSibling() (Node, error)
	RemoveChild(Node) error
	SetDocument(d Document) error
	SetNodeName(string)
	SetNodeValue(string)
	String() string
	TextContent() string
	ToString(int, bool) string
	Walk(func(Node) error) error

	MakeMortal()
	MakePersistent()
	AutoFree()
}

type NodeIter interface {
	Next() bool
	Node() Node
}

// NodeList is a set of Nodes
type NodeList []Node
