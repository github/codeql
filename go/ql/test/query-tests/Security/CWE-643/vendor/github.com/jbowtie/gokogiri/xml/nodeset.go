package xml

/*
#cgo pkg-config: libxml-2.0

#include <libxml/xpath.h>
#include <libxml/xpathInternals.h>

*/
import "C"

import "unsafe"

type Nodeset []Node

// Produce a slice of unsafe.Pointer objects, suitable for passing to a C function
func (n Nodeset) ToPointers() (pointers []unsafe.Pointer) {
	for _, node := range n {
		pointers = append(pointers, node.NodePtr())
	}
	return
}

// Produce a C.xmlXPathObjectPtr suitable for passing to libxml2
func (n Nodeset) ToXPathNodeset() (ret C.xmlXPathObjectPtr) {
	ret = C.xmlXPathNewNodeSet(nil)
	for _, node := range n {
		C.xmlXPathNodeSetAdd(ret.nodesetval, (*C.xmlNode)(node.NodePtr()))
	}
	return
}

// Produce a C.xmlXPathObjectPtr marked as a ResultValueTree, suitable for passing to libxml2
func (n Nodeset) ToXPathValueTree() (ret C.xmlXPathObjectPtr) {
	if len(n) == 0 {
		ret = C.xmlXPathNewValueTree(nil)
		return
	}

	ret = C.xmlXPathNewValueTree(nil)
	for _, node := range n {
		C.xmlXPathNodeSetAdd(ret.nodesetval, (*C.xmlNode)(node.NodePtr()))
	}
	//this hack-ish looking line tells libxml2 not to free the RVT
	//if we don't do this we get horrible double-free crashes everywhere
	ret.boolval = 0
	return
}
