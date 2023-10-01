package xml

//#include "helper.h"
import "C"
import (
	"errors"
	. "github.com/jbowtie/gokogiri/util"
	"unsafe"
)

type DocumentFragment struct {
	Node
	InEncoding  []byte
	OutEncoding []byte
}

var (
	fragmentWrapperStart = []byte("<root>")
	fragmentWrapperEnd   = []byte("</root>")
)

var ErrFailParseFragment = errors.New("failed to parse xml fragment")
var ErrEmptyFragment = errors.New("empty xml fragment")

const initChildrenNumber = 4

func parsefragment(document Document, node *XmlNode, content, url []byte, options ParseOption) (fragment *DocumentFragment, err error) {
	//wrap the content before parsing
	content = append(fragmentWrapperStart, content...)
	content = append(content, fragmentWrapperEnd...)

	//set up pointers before calling the C function
	var contentPtr, urlPtr unsafe.Pointer
	contentPtr = unsafe.Pointer(&content[0])
	contentLen := len(content)
	if len(url) > 0 {
		url = AppendCStringTerminator(url)
		urlPtr = unsafe.Pointer(&url[0])
	}

	var rootElementPtr *C.xmlNode

	if node == nil {
		inEncoding := document.InputEncoding()
		var encodingPtr unsafe.Pointer
		if len(inEncoding) > 0 {
			encodingPtr = unsafe.Pointer(&inEncoding[0])
		}
		rootElementPtr = C.xmlParseFragmentAsDoc(document.DocPtr(), contentPtr, C.int(contentLen), urlPtr, encodingPtr, C.int(options), nil, 0)

	} else {
		rootElementPtr = C.xmlParseFragment(node.NodePtr(), contentPtr, C.int(contentLen), urlPtr, C.int(options), nil, 0)
	}

	//Note we've parsed the fragment within the given document
	//the root is not the root of the document; rather it's the root of the subtree from the fragment
	root := NewNode(unsafe.Pointer(rootElementPtr), document)

	//the fragment was in invalid
	if root == nil {
		err = ErrFailParseFragment
		return
	}

	fragment = &DocumentFragment{}
	fragment.Node = root
	fragment.InEncoding = document.InputEncoding()
	fragment.OutEncoding = document.OutputEncoding()

	document.BookkeepFragment(fragment)
	return
}

func ParseFragment(content, inEncoding, url []byte, options ParseOption, outEncoding []byte) (fragment *DocumentFragment, err error) {
	inEncoding = AppendCStringTerminator(inEncoding)
	outEncoding = AppendCStringTerminator(outEncoding)
	document := CreateEmptyDocument(inEncoding, outEncoding)
	fragment, err = parsefragment(document, nil, content, url, options)
	return
}

func (fragment *DocumentFragment) Remove() {
	fragment.Node.Remove()
}

func (fragment *DocumentFragment) Children() []Node {
	nodes := make([]Node, 0, initChildrenNumber)
	child := fragment.FirstChild()
	for ; child != nil; child = child.NextSibling() {
		nodes = append(nodes, child)
	}
	return nodes
}

func (fragment *DocumentFragment) ToBuffer(outputBuffer []byte) []byte {
	var b []byte
	var size int
	for _, node := range fragment.Children() {
		if docType := node.MyDocument().DocType(); docType == XML_HTML_DOCUMENT_NODE {
			b, size = node.ToHtml(fragment.OutEncoding, nil)
		} else {
			b, size = node.ToXml(fragment.OutEncoding, nil)
		}
		outputBuffer = append(outputBuffer, b[:size]...)
	}
	return outputBuffer
}

func (fragment *DocumentFragment) String() string {
	b := fragment.ToBuffer(nil)
	if b == nil {
		return ""
	}
	return string(b)
}
