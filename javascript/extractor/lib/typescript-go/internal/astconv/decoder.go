// Package astconv decodes the binary AST format produced by the tsgo API
// and converts it to the JSON format expected by the Java extractor.
//
// The binary format is documented in microsoft/typescript-go/internal/api/encoder/encoder.go.
// Each source file is encoded as:
//
//	Header (44 bytes) | String offsets | String data | Extended data | Structured data | Nodes (28 bytes each)
//
// Nodes are in a flat array with parent/next-sibling indices. The first node (index 0)
// is a nil sentinel. The root node is at index 1.
package astconv

import (
	"encoding/base64"
	"encoding/binary"
	"fmt"
)

// Binary format constants matching microsoft/typescript-go/internal/api/encoder.
const (
	nodeSize = 28 // 7 × uint32

	nodeOffsetKind   = 0
	nodeOffsetPos    = 4
	nodeOffsetEnd    = 8
	nodeOffsetNext   = 12
	nodeOffsetParent = 16
	nodeOffsetData   = 20
	nodeOffsetFlags  = 24

	headerSize               = 44
	headerOffsetMetadata     = 0
	headerOffsetStringOff    = 24
	headerOffsetStringData   = 28
	headerOffsetExtData      = 32
	headerOffsetStructData   = 36
	headerOffsetNodes        = 40

	protocolVersion uint8 = 5

	nodeDataTypeChildren uint32 = 0x00_00_00_00
	nodeDataTypeString   uint32 = 0x40_00_00_00
	nodeDataTypeExtended uint32 = 0x80_00_00_00

	nodeDataTypeMask    uint32 = 0xC0_00_00_00
	nodeDataChildMask   uint32 = 0x00_00_00_FF
	nodeDataStringMask  uint32 = 0x00_FF_FF_FF

	// SyntaxKindNodeList is the special kind value used for NodeList nodes.
	SyntaxKindNodeList uint32 = 0xFF_FF_FF_FF
)

// BinaryAST provides random access to nodes in a binary-encoded TypeScript AST.
type BinaryAST struct {
	raw       []byte
	strOff    uint32 // byte offset to string offset pairs
	strData   uint32 // byte offset to string data
	extData   uint32 // byte offset to extended node data
	structOff uint32 // byte offset to structured data
	nodeOff   uint32 // byte offset to nodes section
	nodeCount int
	// Single Go string covering all data from strData onward.
	// String offsets index into this, so substrings are zero-alloc.
	allStrData string
}

// DecodeBinaryAST parses the binary header and returns a BinaryAST for
// random-access to nodes and strings.
func DecodeBinaryAST(data []byte) (*BinaryAST, error) {
	if len(data) < headerSize {
		return nil, fmt.Errorf("data too short: %d bytes (need %d)", len(data), headerSize)
	}

	version := data[headerOffsetMetadata+3]
	if version != protocolVersion {
		return nil, fmt.Errorf("unsupported protocol version %d (expected %d)", version, protocolVersion)
	}

	b := &BinaryAST{
		raw:       data,
		strOff:    le32(data, headerOffsetStringOff),
		strData:   le32(data, headerOffsetStringData),
		extData:   le32(data, headerOffsetExtData),
		structOff: le32(data, headerOffsetStructData),
		nodeOff:   le32(data, headerOffsetNodes),
	}

	dataLen := uint32(len(data))
	if b.strOff > dataLen || b.strData > dataLen || b.extData > dataLen || b.nodeOff > dataLen {
		return nil, fmt.Errorf("invalid header offsets exceed data length %d", dataLen)
	}

	b.nodeCount = (len(data) - int(b.nodeOff)) / nodeSize
	if b.nodeCount < 2 {
		return nil, fmt.Errorf("no nodes in AST (count=%d, need at least 2)", b.nodeCount)
	}

	// The official decoder uses data[strData:] for zero-alloc substring slicing.
	b.allStrData = string(data[b.strData:])

	return b, nil
}

// DecodeBinaryASTFromBase64 decodes a base64-encoded binary AST, as returned
// by tsgo's getSourceFile API in JSON ({"data":"<base64>"}).
func DecodeBinaryASTFromBase64(b64 string) (*BinaryAST, error) {
	data, err := base64.StdEncoding.DecodeString(b64)
	if err != nil {
		return nil, fmt.Errorf("base64 decode failed: %w", err)
	}
	return DecodeBinaryAST(data)
}

// NodeCount returns the total number of nodes (including the nil sentinel at index 0).
func (b *BinaryAST) NodeCount() int { return b.nodeCount }

// Node field accessors — all read uint32 from the nodes section.

func (b *BinaryAST) nf(i, offset int) uint32 {
	return le32(b.raw, int(b.nodeOff)+i*nodeSize+offset)
}

// Kind returns the SyntaxKind of node i.
func (b *BinaryAST) Kind(i int) uint32 { return b.nf(i, nodeOffsetKind) }

// Pos returns the start position (UTF-16 offset) of node i.
func (b *BinaryAST) Pos(i int) uint32 { return b.nf(i, nodeOffsetPos) }

// End returns the end position (UTF-16 offset) of node i.
func (b *BinaryAST) End(i int) uint32 { return b.nf(i, nodeOffsetEnd) }

// Next returns the index of the next sibling of node i, or 0 if none.
func (b *BinaryAST) Next(i int) uint32 { return b.nf(i, nodeOffsetNext) }

// Parent returns the index of the parent of node i, or 0 if none.
func (b *BinaryAST) Parent(i int) uint32 { return b.nf(i, nodeOffsetParent) }

// Data returns the raw 32-bit data field of node i.
func (b *BinaryAST) Data(i int) uint32 { return b.nf(i, nodeOffsetData) }

// Flags returns the NodeFlags of node i.
func (b *BinaryAST) Flags(i int) uint32 { return b.nf(i, nodeOffsetFlags) }

// DataType returns the top 2 bits of the data field (Children, String, or Extended).
func (b *BinaryAST) DataType(i int) uint32 { return b.Data(i) & nodeDataTypeMask }

// DefinedBits returns bits 24-29 of the data field (6 bits of per-node-type flags).
func (b *BinaryAST) DefinedBits(i int) uint8 { return uint8((b.Data(i) >> 24) & 0x3F) }

// ChildMask returns the low byte of the data field (child property bitmask).
func (b *BinaryAST) ChildMask(i int) uint8 { return uint8(b.Data(i) & nodeDataChildMask) }

// StringIndex returns the 24-bit string table index from the data field.
func (b *BinaryAST) StringIndex(i int) uint32 { return b.Data(i) & nodeDataStringMask }

// ExtOffset returns the 24-bit offset into the extended data section from the data field.
func (b *BinaryAST) ExtOffset(i int) uint32 { return b.Data(i) & nodeDataStringMask }

// NodeListLen returns the number of children for a NodeList node (stored in data field).
func (b *BinaryAST) NodeListLen(i int) uint32 { return b.Data(i) }

// IsNodeList returns true if node i is a NodeList.
func (b *BinaryAST) IsNodeList(i int) bool { return b.Kind(i) == SyntaxKindNodeList }

// GetString reads a string from the string table at the given offset index.
// The index comes from a String-type node's data field (24-bit value).
func (b *BinaryAST) GetString(idx uint32) string {
	// Each string entry is two uint32 values (start, end) in the string offsets section.
	offBase := int(b.strOff) + int(idx)*4
	start := le32(b.raw, offBase)
	end := le32(b.raw, offBase+4)
	return b.allStrData[start:end]
}

// ExtUint32 reads a uint32 from the extended data section at the given byte offset.
func (b *BinaryAST) ExtUint32(off uint32) uint32 {
	return le32(b.raw, int(b.extData)+int(off))
}

// Children returns the indices of all direct children of node i.
// Children are identified by having parent == i. The first child is at i+1
// (if its parent is i), and subsequent children are found via Next pointers.
func (b *BinaryAST) Children(i int) []int {
	if i+1 >= b.nodeCount {
		return nil
	}
	firstChild := i + 1
	if b.Parent(firstChild) != uint32(i) {
		return nil
	}
	children := []int{firstChild}
	next := int(b.Next(firstChild))
	for next != 0 {
		children = append(children, next)
		next = int(b.Next(next))
	}
	return children
}

// SourceText returns the source file text, extracted from the SourceFile's
// extended data. Returns "" if the root node is not a SourceFile or if
// the extended data is missing.
func (b *BinaryAST) SourceText() string {
	if b.nodeCount < 2 {
		return ""
	}
	// Root is at index 1. Check if it has extended data type.
	if b.DataType(1)&nodeDataTypeMask != nodeDataTypeExtended {
		return ""
	}
	extOff := b.ExtOffset(1)
	textIdx := b.ExtUint32(extOff)
	return b.GetString(textIdx)
}

func le32(data []byte, offset int) uint32 {
	if offset < 0 || offset+4 > len(data) {
		return 0
	}
	return binary.LittleEndian.Uint32(data[offset : offset+4])
}
