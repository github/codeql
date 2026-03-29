package clib

import "errors"

const (
	MaxEncodingLength        = 256
	MaxAttributeNameLength   = 1024
	MaxElementNameLength     = 1024
	MaxNamespaceURILength    = 4096
	MaxValueBufferSize       = 4096
	MaxXPathExpressionLength = 4096
)

// C14NMode represents the C14N mode supported by libxml2
type C14NMode int

// PtrSource is the single interface that connects the rest of
// libxml2 package with this package. The clib packages does not
// really care what sort of object you pass to these low-level
// functions, as long as the arguments fulfill this interface.
//
// Obviously this causes problems if you pass the an Element node
// where a Document node is expected, but it is the caller's
// responsibility to align the argument list.
type PtrSource interface {
	Pointer() uintptr
}

// XMLNodeType identifies the type of the underlying C struct
type XMLNodeType int

const (
	ElementNode XMLNodeType = iota + 1
	AttributeNode
	TextNode
	CDataSectionNode
	EntityRefNode
	EntityNode
	PiNode
	CommentNode
	DocumentNode
	DocumentTypeNode
	DocumentFragNode
	NotationNode
	HTMLDocumentNode
	DTDNode
	ElementDecl
	AttributeDecl
	EntityDecl
	NamespaceDecl
	XIncludeStart
	XIncludeEnd
	DocbDocumentNode
)

var (
	ErrAttributeNotFound      = errors.New("attribute not found")
	ErrAttributeNameTooLong   = errors.New("attribute name too long")
	ErrElementNameTooLong     = errors.New("element name too long")
	ErrNamespaceURITooLong    = errors.New("namespace uri too long")
	ErrValueTooLong           = errors.New("value too long")
	ErrXPathExpressionTooLong = errors.New("xpath expression too long")
	// ErrInvalidAttribute is returned when the Attribute struct (probably
	// the pointer to the underlying C struct is not valid)
	ErrInvalidAttribute = errors.New("invalid attribute")
	ErrInvalidArgument  = errors.New("invalid argument")
	// ErrInvalidDocument is returned when the Document struct (probably
	// the pointer to the underlying C struct is not valid)
	ErrInvalidDocument = errors.New("invalid document")
	// ErrInvalidParser is returned when the Parser struct (probably
	// the pointer to the underlying C struct is not valid)
	ErrInvalidParser = errors.New("invalid parser")
	// ErrInvalidNamespace is returned when the Namespace struct (probably
	// the pointer to the underlying C struct is not valid)
	ErrInvalidNamespace = errors.New("invalid namespace")
	// ErrInvalidNode is returned when the Node struct (probably
	// the pointer to the underlying C struct is not valid)
	ErrInvalidNode     = errors.New("invalid node")
	ErrInvalidNodeName = errors.New("invalid node name")
	// ErrInvalidXPathContext is returned when the XPathContext struct (probably
	// the pointer to the underlying C struct is not valid)
	ErrInvalidXPathContext = errors.New("invalid xpath context")
	// ErrInvalidXPathExpression is returned when the XPathExpression struct (probably
	// the pointer to the underlying C struct is not valid)
	ErrInvalidXPathExpression = errors.New("invalid xpath expression")
	// ErrInvalidXPathObject is returned when the XPathObject struct (probably
	// the pointer to the underlying C struct is not valid)
	ErrInvalidXPathObject = errors.New("invalid xpath object")
	// ErrInvalidSchema is returned when the Schema struct (probably
	// the pointer to the underlying C struct is not valid)
	ErrInvalidSchema                 = errors.New("invalid schema")
	ErrNodeNotFound                  = errors.New("node not found")
	ErrXPathEmptyResult              = errors.New("empty xpath result")
	ErrXPathCompileFailure           = errors.New("xpath compilation failed")
	ErrXPathNamespaceRegisterFailure = errors.New("cannot register namespace")
)

//nolint:errname
type ErrNamespaceNotFound struct {
	Target string
}

func (e ErrNamespaceNotFound) Error() string {
	return "namespace not found: " + e.Target
}

type XPathObjectType int

const (
	XPathUndefinedType XPathObjectType = iota
	XPathNodeSetType
	XPathBooleanType
	XPathNumberType
	XPathStringType
	XPathPointType
	XPathRangeType
	XPathLocationSetType
	XPathUsersType
	XPathXSLTTreeType
)
