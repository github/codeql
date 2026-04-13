package astconv

import (
	"encoding/json"
	"fmt"
	"strings"
)

// Converter transforms a BinaryAST into the JSON format expected by the
// Java extractor.
type Converter struct {
	ast          *BinaryAST
	kindNames    map[uint32]string // numeric kind → string name
	sourceText   string            // source file text for $lineStarts / $pos augmentation
	utf16Offsets []int             // maps byte offset → UTF-16 code unit offset
	byteOffsets  []int             // maps UTF-16 code unit offset → byte offset
}

// NewConverter creates a Converter for the given binary AST.
// kindToName maps numeric SyntaxKind values to their string names.
func NewConverter(ast *BinaryAST, kindToName map[uint32]string) *Converter {
	text := ast.SourceText()
	utf16Table, byteTable := buildOffsetTables(text)
	return &Converter{
		ast:          ast,
		kindNames:    kindToName,
		sourceText:   text,
		utf16Offsets: utf16Table,
		byteOffsets:  byteTable,
	}
}

// Convert transforms the binary AST into a JSON-serializable map.
// The root node is at index 1.
func (c *Converter) Convert() (map[string]interface{}, error) {
	if c.ast.NodeCount() < 2 {
		return nil, fmt.Errorf("no nodes to convert")
	}
	return c.convertNode(1)
}

// ConvertJSON is a convenience method that converts to JSON bytes.
func (c *Converter) ConvertJSON() (json.RawMessage, error) {
	obj, err := c.Convert()
	if err != nil {
		return nil, err
	}
	return json.Marshal(obj)
}

func (c *Converter) convertNode(i int) (map[string]interface{}, error) {
	kind := c.ast.Kind(i)
	kindName := c.kindNames[kind]
	if kindName == "" {
		kindName = fmt.Sprintf("Unknown_%d", kind)
	}

	node := map[string]interface{}{
		"kind":  int(kind),
		"flags": int(c.ast.Flags(i)),
		"$pos":  c.augmentPos(int(c.ast.Pos(i)), true),
		"$end":  int(c.ast.End(i)),
	}

	dataType := c.ast.DataType(i)

	switch dataType {
	case nodeDataTypeString:
		c.handleStringNode(i, kindName, node)

	case nodeDataTypeExtended:
		if err := c.handleExtendedNode(i, kindName, node); err != nil {
			return nil, err
		}

	default: // nodeDataTypeChildren
		if err := c.handleChildrenNode(i, kindName, node); err != nil {
			return nil, err
		}
	}

	// Add defined-bits-based properties
	c.addDefinedBitProperties(i, kindName, node)

	if kindName == "ModuleDeclaration" {
		// TS7 doesn't set the NestedNamespace flag in the binary AST, but the Java
		// extractor needs it to wrap inner namespace declarations in ExportNamedDeclaration.
		// Detect nested namespaces (ModuleDeclaration whose body is another ModuleDeclaration)
		// and add the flag to the inner declaration.
		if body, ok := node["body"].(map[string]interface{}); ok {
			if bodyKind, ok := body["kind"].(int); ok && bodyKind == 268 { // 268 = ModuleDeclaration
				if flags, ok := body["flags"].(int); ok {
					body["flags"] = flags | 8 // NestedNamespace = 8
				}
			}
		}

		// TS7 binary AST doesn't have a GlobalAugmentation flag. Detect `declare global {}`
		// by checking if the name is "global" (Identifier), and set a synthetic flag bit
		// so the Java extractor can distinguish it from regular namespace declarations.
		if name, ok := node["name"].(map[string]interface{}); ok {
			if nameKind, ok := name["kind"].(int); ok && nameKind == 79 { // 79 = Identifier
				if text, _ := name["escapedText"].(string); text == "global" {
					if flags, ok := node["flags"].(int); ok {
						node["flags"] = flags | (1 << 30) // synthetic GlobalAugmentation
					}
				}
			}
		}
	}

	return node, nil
}

// handleStringNode handles nodes with a string property (Identifier, StringLiteral, etc.)
func (c *Converter) handleStringNode(i int, kindName string, node map[string]interface{}) {
	strIdx := c.ast.StringIndex(i)
	text := c.ast.GetString(strIdx)

	switch kindName {
	case "Identifier", "PrivateIdentifier":
		node["escapedText"] = text
	default:
		node["text"] = text
	}
}

// handleExtendedNode handles SourceFile and template literal nodes.
func (c *Converter) handleExtendedNode(i int, kindName string, node map[string]interface{}) error {
	extOff := c.ast.ExtOffset(i)

	switch kindName {
	case "SourceFile":
		return c.handleSourceFile(i, extOff, node)
	case "TemplateHead", "TemplateMiddle", "TemplateTail":
		c.handleTemplateLiteral(extOff, node)
		return nil
	default:
		return fmt.Errorf("unknown extended data node kind: %s", kindName)
	}
}

// handleSourceFile extracts SourceFile-specific data from extended data.
func (c *Converter) handleSourceFile(i int, extOff uint32, node map[string]interface{}) error {
	// SourceFile extended data layout:
	// [0-4] textIdx, [4-8] fileNameIdx, [8-12] pathIdx,
	// [12-16] languageVariant, [16-20] scriptKind,
	// [20-24] referencedFiles, [24-28] typeReferenceDirectives, [28-32] libReferenceDirectives
	// [32-36] imports, [36-40] moduleAugmentations, [40-44] ambientModuleNames
	// [44-48] externalModuleIndicator

	fileNameIdx := c.ast.ExtUint32(extOff + 4)
	node["fileName"] = c.ast.GetString(fileNameIdx)

	// Add source text
	if c.sourceText != "" {
		node["text"] = c.sourceText
		node["$lineStarts"] = computeLineStarts(c.sourceText, c.utf16Offsets)
	}

	// Add empty parseDiagnostics array (expected by Java extractor)
	node["parseDiagnostics"] = []interface{}{}

	// Add children (statements + EndOfFile)
	children := c.ast.Children(i)
	statementsFound := false
	for _, ci := range children {
		if c.ast.IsNodeList(ci) {
			arr, err := c.convertNodeList(ci)
			if err != nil {
				return err
			}
			node["statements"] = arr
			statementsFound = true
		}
		// Skip EndOfFile token — the Java extractor doesn't use it
	}
	if !statementsFound {
		node["statements"] = []interface{}{}
	}

	// Generate $tokens by scanning the source text.
	if c.sourceText != "" {
		events := c.collectRescanEvents(i)
		scanner := NewScanner(c.sourceText, events)
		rawTokens := scanner.ScanAll()
		tokenArr := make([]interface{}, len(rawTokens))
		for ti, tok := range rawTokens {
			tokenArr[ti] = map[string]interface{}{
				"kind":     tok.Kind,
				"tokenPos": byteToUTF16(tok.TokenPos, c.utf16Offsets),
				"text":     tok.Text,
			}
		}
		node["$tokens"] = tokenArr
	}

	return nil
}

// handleTemplateLiteral extracts template literal data from extended data.
func (c *Converter) handleTemplateLiteral(extOff uint32, node map[string]interface{}) {
	textIdx := c.ast.ExtUint32(extOff)
	rawTextIdx := c.ast.ExtUint32(extOff + 4)
	node["text"] = c.ast.GetString(textIdx)
	node["rawText"] = c.ast.GetString(rawTextIdx)
}

// handleChildrenNode handles nodes with child properties determined by a bitmask.
func (c *Converter) handleChildrenNode(i int, kindName string, node map[string]interface{}) error {
	children := c.ast.Children(i)

	// Check for single-child nodes
	if prop := GetSingleChildProperty(kindName); prop != "" {
		if len(children) > 0 {
			child, err := c.convertNode(children[0])
			if err != nil {
				return err
			}
			node[prop] = child
		}
		return nil
	}

	// Check for single NodeList child nodes
	if prop := GetSingleNodeListProperty(kindName); prop != "" {
		if len(children) > 0 && c.ast.IsNodeList(children[0]) {
			arr, err := c.convertNodeList(children[0])
			if err != nil {
				return err
			}
			node[prop] = arr
		} else if len(children) > 0 {
			// Some single-NodeList nodes may not have a NodeList child
			// (e.g., JSDocTypeLiteral). Fall through to multi-child handling.
		} else {
			node[prop] = []interface{}{}
			return nil
		}
		return nil
	}

	// Check for operator-in-definedBits nodes (PrefixUnaryExpression, PostfixUnaryExpression)
	if operandKinds[kindName] {
		if len(children) > 0 {
			child, err := c.convertNode(children[0])
			if err != nil {
				return err
			}
			node["operand"] = child
		}
		node["operator"] = int(c.ast.DefinedBits(i))
		return nil
	}

	// Multi-child nodes with property mask
	props := GetChildProperties(kindName)
	if props != nil {
		return c.assignChildProperties(i, kindName, props, children, node)
	}

	// Token/keyword nodes with no children — nothing to add
	if len(children) == 0 {
		return nil
	}

	// MetaProperty: keywordToken + name
	if kindName == "MetaProperty" {
		if len(children) > 0 {
			child, err := c.convertNode(children[0])
			if err != nil {
				return err
			}
			node["name"] = child
		}
		return nil
	}

	// TypeOperator: operator keyword kind inferred from source text + type child
	if kindName == "TypeOperator" {
		// Operator (keyof/unique/readonly) is not in the binary encoding.
		bytePos := utf16ToByte(int(c.ast.Pos(i)), c.byteOffsets)
		if c.sourceText != "" && bytePos < len(c.sourceText) {
			text := c.sourceText[bytePos:]
			// Skip leading trivia
			for len(text) > 0 && (text[0] == ' ' || text[0] == '\t' || text[0] == '\n' || text[0] == '\r') {
				text = text[1:]
			}
			if len(text) >= 5 && text[:5] == "keyof" {
				node["operator"] = int(c.kindForName("KeyOfKeyword"))
			} else if len(text) >= 6 && text[:6] == "unique" {
				node["operator"] = int(c.kindForName("UniqueKeyword"))
			} else if len(text) >= 8 && text[:8] == "readonly" {
				node["operator"] = int(c.kindForName("ReadonlyKeyword"))
			}
		}
		if len(children) > 0 {
			child, err := c.convertNode(children[0])
			if err != nil {
				return err
			}
			node["type"] = child
		}
		return nil
	}

	// MissingDeclaration: optional modifiers child
	if kindName == "MissingDeclaration" {
		if len(children) > 0 && c.ast.IsNodeList(children[0]) {
			arr, err := c.convertNodeList(children[0])
			if err != nil {
				return err
			}
			node["modifiers"] = arr
		}
		return nil
	}

	// Unknown node kind with children — emit them as a generic "children" array
	arr := make([]interface{}, 0, len(children))
	for _, ci := range children {
		if c.ast.IsNodeList(ci) {
			nlArr, err := c.convertNodeList(ci)
			if err != nil {
				return err
			}
			for _, item := range nlArr {
				arr = append(arr, item)
			}
		} else {
			child, err := c.convertNode(ci)
			if err != nil {
				return err
			}
			arr = append(arr, child)
		}
	}
	if len(arr) > 0 {
		node["children"] = arr
	}

	return nil
}

// assignChildProperties distributes children to named properties based on
// the bitmask in the node's data field.
func (c *Converter) assignChildProperties(nodeIdx int, kindName string, props []string, children []int, node map[string]interface{}) error {
	mask := c.ast.ChildMask(nodeIdx)
	definedBits := c.ast.DefinedBits(nodeIdx)

	// Special handling for JSDocParameterTag/JSDocPropertyTag where
	// child order depends on isNameFirst
	if (kindName == "JSDocParameterTag" || kindName == "JSDocPropertyTag") && definedBits&2 != 0 {
		// isNameFirst=true: order is tagName, name, typeExpression, comment
		props = []string{"tagName", "name", "typeExpression", "comment"}
	}

	childIdx := 0
	for bit, prop := range props {
		if bit < 8 && mask != 0 && mask&(1<<uint(bit)) == 0 {
			// Property not present per bitmask. For array properties,
			// emit an empty array (the Java extractor expects them).
			if isArrayProperty(prop) {
				node[prop] = []interface{}{}
			}
			continue
		}
		// If mask is 0 (single-child or no disambiguation needed), consume sequentially
		if childIdx >= len(children) {
			// No more children — emit empty arrays for remaining array properties
			if isArrayProperty(prop) {
				node[prop] = []interface{}{}
			}
			continue
		}

		ci := children[childIdx]
		childIdx++

		if c.ast.IsNodeList(ci) {
			arr, err := c.convertNodeList(ci)
			if err != nil {
				return err
			}
			// Filter out zero-width synthetic modifiers (TS7 adds these for
			// nested namespace bodies, but TS5/Node.js doesn't emit them).
			if prop == "modifiers" {
				filtered := make([]interface{}, 0, len(arr))
				for _, elem := range arr {
					if m, ok := elem.(map[string]interface{}); ok {
						pos, _ := m["$pos"].(int)
						end, _ := m["$end"].(int)
						if pos == end {
							continue // zero-width synthetic node
						}
					}
					filtered = append(filtered, elem)
				}
				if len(filtered) == 0 {
					continue // drop entirely
				}
				arr = filtered
			}
			node[prop] = arr
		} else {
			child, err := c.convertNode(ci)
			if err != nil {
				return err
			}
			// Remap TS7 "postfixToken" (questionToken property) to the correct name
			// based on the actual token kind. TS7 uses a single PostfixToken
			// for what TS5 had as separate questionToken/exclamationToken.
			if prop == "questionToken" {
				childKind := c.ast.Kind(ci)
				exclamationKind := c.kindForName("ExclamationToken")
				if exclamationKind != 0 && childKind == exclamationKind {
					prop = "exclamationToken"
				}
			}
			node[prop] = child
		}
	}

	return nil
}

// isArrayProperty returns true for property names that should be empty arrays
// (not omitted) when absent in the binary AST.
func isArrayProperty(prop string) bool {
	return arrayProperties[prop]
}

var arrayProperties = map[string]bool{
	"arguments":    true,
	"declarations": true,
	"elements":     true,
	"members":      true,
	"parameters":   true,
	"properties":   true,
}

// convertNodeList converts a NodeList into a JSON array.
func (c *Converter) convertNodeList(i int) ([]interface{}, error) {
	children := c.ast.Children(i)
	arr := make([]interface{}, 0, len(children))
	for _, ci := range children {
		child, err := c.convertNode(ci)
		if err != nil {
			return nil, err
		}
		arr = append(arr, child)
	}
	return arr, nil
}

// addDefinedBitProperties adds properties derived from the defined bits
// (bits 24-29 of the data field) that aren't part of the child tree.
func (c *Converter) addDefinedBitProperties(i int, kindName string, node map[string]interface{}) {
	definedBits := c.ast.DefinedBits(i)

	switch kindName {
	case "ImportSpecifier", "ImportEqualsDeclaration", "ExportSpecifier", "ExportDeclaration":
		node["isTypeOnly"] = definedBits&1 != 0
	case "ImportClause":
		node["isTypeOnly"] = definedBits&1 != 0
		if definedBits&2 != 0 {
			node["phaseModifier"] = "defer"
		}
	case "ImportType":
		if definedBits&1 != 0 {
			node["isTypeOf"] = true
		} else {
			node["isTypeOf"] = false
		}
	case "ExportAssignment", "JSExportAssignment":
		if definedBits&1 != 0 {
			node["isExportEquals"] = true
		}
	case "VariableDeclarationList":
		// Determine $declarationKind from defined bits
		if definedBits&2 != 0 {
			node["$declarationKind"] = "const"
		} else if definedBits&1 != 0 {
			node["$declarationKind"] = "let"
		} else {
			node["$declarationKind"] = "var"
		}
	case "ImportAttributes":
		if definedBits&2 != 0 {
			node["token"] = c.kindForName("AssertKeyword")
		} else {
			node["token"] = c.kindForName("WithKeyword")
		}
	case "HeritageClause":
		// Token (extends/implements) is not in the binary encoding.
		// Infer from source text, skipping leading trivia.
		bytePos := utf16ToByte(int(c.ast.Pos(i)), c.byteOffsets)
		if c.sourceText != "" && bytePos < len(c.sourceText) {
			text := c.sourceText[bytePos:]
			// Skip whitespace/newlines
			for len(text) > 0 && (text[0] == ' ' || text[0] == '\t' || text[0] == '\n' || text[0] == '\r') {
				text = text[1:]
			}
			if len(text) >= 10 && text[:10] == "implements" {
				node["token"] = int(c.kindForName("ImplementsKeyword"))
			} else {
				node["token"] = int(c.kindForName("ExtendsKeyword"))
			}
		}
	case "JSDocParameterTag", "JSDocPropertyTag":
		if definedBits&1 != 0 {
			node["isBracketed"] = true
		}
		if definedBits&2 != 0 {
			node["isNameFirst"] = true
		}
	}
}

// augmentPos replicates the Node.js wrapper's $pos augmentation:
// if skip is true, advances past leading whitespace, single-line comments (//),
// and multi-line comments (/* */). This matches the TS5 Node.js wrapper regex:
//   /(?:\s|\/\/.*|\/\*[^]*?\*\/)*/g
// Note: shebangs (#!) are NOT skipped — the TS5 regex does not match them.
// Input pos is a UTF-16 code unit offset; returns a UTF-16 code unit offset.
func (c *Converter) augmentPos(pos int, skip bool) int {
	if !skip || c.sourceText == "" {
		return pos
	}
	return byteToUTF16(c.skipTrivia(utf16ToByte(pos, c.byteOffsets)), c.utf16Offsets)
}

// augmentBytePos converts a UTF-16 offset to byte offset then skips trivia,
// returning the result as a byte offset. Used for scanner rescan events.
func (c *Converter) augmentBytePos(utf16Pos int) int {
	return c.skipTrivia(utf16ToByte(utf16Pos, c.byteOffsets))
}

// skipTrivia advances past whitespace, single-line comments (//), and
// multi-line comments (/* */), starting at byte offset i.
func (c *Converter) skipTrivia(i int) int {
	n := len(c.sourceText)
	for i < n {
		ch := c.sourceText[i]
		if ch == ' ' || ch == '\t' || ch == '\r' || ch == '\n' || ch == '\f' || ch == '\v' {
			i++
			continue
		}
		if ch == '/' && i+1 < n {
			next := c.sourceText[i+1]
			if next == '/' {
				// Single-line comment — skip to end of line
				i += 2
				for i < n && c.sourceText[i] != '\n' {
					i++
				}
				continue
			}
			if next == '*' {
				// Multi-line comment — skip to */
				i += 2
				for i+1 < n {
					if c.sourceText[i] == '*' && c.sourceText[i+1] == '/' {
						i += 2
						break
					}
					i++
				}
				continue
			}
		}
		break
	}
	return i
}

// computeLineStarts returns an array of UTF-16 code unit offsets where each line starts.
func computeLineStarts(text string, utf16Offsets []int) []int {
	starts := []int{0}
	for i := 0; i < len(text); i++ {
		ch := text[i]
		if ch == '\n' {
			starts = append(starts, byteToUTF16(i+1, utf16Offsets))
		} else if ch == '\r' {
			if i+1 < len(text) && text[i+1] == '\n' {
				i++
			}
			starts = append(starts, byteToUTF16(i+1, utf16Offsets))
		}
	}
	return starts
}

// buildOffsetTables builds bidirectional mapping tables between byte offsets
// and UTF-16 code unit offsets.
func buildOffsetTables(text string) (byteToUTF16Table []int, utf16ToByteTable []int) {
	byteToUTF16Table = make([]int, len(text)+1)
	// First pass: compute total UTF-16 length and byte→UTF-16 mapping
	utf16Pos := 0
	i := 0
	for i < len(text) {
		byteToUTF16Table[i] = utf16Pos
		b := text[i]
		if b < 0x80 {
			i++
			utf16Pos++
		} else if b < 0xE0 {
			if i+1 < len(byteToUTF16Table) {
				byteToUTF16Table[i+1] = utf16Pos
			}
			i += 2
			utf16Pos++
		} else if b < 0xF0 {
			if i+1 < len(byteToUTF16Table) {
				byteToUTF16Table[i+1] = utf16Pos
			}
			if i+2 < len(byteToUTF16Table) {
				byteToUTF16Table[i+2] = utf16Pos
			}
			i += 3
			utf16Pos++
		} else {
			// 4-byte UTF-8 = 2 UTF-16 code units (surrogate pair)
			for j := 1; j < 4 && i+j < len(byteToUTF16Table); j++ {
				byteToUTF16Table[i+j] = utf16Pos
			}
			i += 4
			utf16Pos += 2
		}
	}
	byteToUTF16Table[len(text)] = utf16Pos

	// Second pass: build UTF-16→byte mapping
	utf16ToByteTable = make([]int, utf16Pos+1)
	i = 0
	utf16Pos = 0
	for i < len(text) {
		utf16ToByteTable[utf16Pos] = i
		b := text[i]
		if b < 0x80 {
			i++
			utf16Pos++
		} else if b < 0xE0 {
			i += 2
			utf16Pos++
		} else if b < 0xF0 {
			i += 3
			utf16Pos++
		} else {
			utf16ToByteTable[utf16Pos+1] = i
			i += 4
			utf16Pos += 2
		}
	}
	utf16ToByteTable[utf16Pos] = i
	return
}

// byteToUTF16 converts a byte offset to a UTF-16 code unit offset.
func byteToUTF16(byteOff int, table []int) int {
	if len(table) == 0 {
		return byteOff
	}
	if byteOff >= len(table) {
		return table[len(table)-1]
	}
	if byteOff < 0 {
		return 0
	}
	return table[byteOff]
}

// utf16ToByte converts a UTF-16 code unit offset to a byte offset.
func utf16ToByte(utf16Off int, table []int) int {
	if len(table) == 0 {
		return utf16Off
	}
	if utf16Off >= len(table) {
		return table[len(table)-1]
	}
	if utf16Off < 0 {
		return 0
	}
	return table[utf16Off]
}

// kindForName returns the numeric kind for a given string name.
// This is the reverse of kindNames. Returns 0 if not found.
func (c *Converter) kindForName(name string) uint32 {
	for k, v := range c.kindNames {
		if v == name {
			return k
		}
	}
	return 0
}

// collectRescanEvents walks the AST to find positions that need rescanning.
// This matches the Node.js wrapper's rescan logic in ast_extractor.ts.
func (c *Converter) collectRescanEvents(root int) []RescanEvent {
	var events []RescanEvent
	c.walkForRescan(root, &events)
	// Sort by position
	sortRescanEvents(events)
	return events
}

func (c *Converter) walkForRescan(i int, events *[]RescanEvent) {
	if i <= 0 || i >= c.ast.NodeCount() {
		return
	}
	if c.ast.IsNodeList(i) {
		for _, ci := range c.ast.Children(i) {
			c.walkForRescan(ci, events)
		}
		return
	}

	kind := c.ast.Kind(i)
	kindName := c.kindNames[kind]

	// RegularExpressionLiteral needs rescan (scanner sees / as SlashToken)
	if kindName == "RegularExpressionLiteral" {
		pos := c.augmentBytePos(int(c.ast.Pos(i)))
		*events = append(*events, RescanEvent{Pos: pos, Kind: "regex"})
	}

	// TemplateMiddle and TemplateTail need rescan (scanner sees } as CloseBraceToken)
	if kindName == "TemplateMiddle" || kindName == "TemplateTail" {
		pos := c.augmentBytePos(int(c.ast.Pos(i)))
		*events = append(*events, RescanEvent{Pos: pos, Kind: "template"})
	}

	// BinaryExpression with >>= or >>> etc. needs rescan (scanner may see > separately)
	if kindName == "BinaryExpression" {
		children := c.ast.Children(i)
		if len(children) >= 3 {
			// BinaryExpression children: left, operatorToken, right
			opKind := c.kindNames[c.ast.Kind(children[1])]
			switch opKind {
			case "GreaterThanEqualsToken", "GreaterThanGreaterThanEqualsToken",
				"GreaterThanGreaterThanGreaterThanEqualsToken",
				"GreaterThanGreaterThanGreaterThanToken", "GreaterThanGreaterThanToken":
				pos := c.augmentBytePos(int(c.ast.Pos(children[1])))
				*events = append(*events, RescanEvent{Pos: pos, Kind: "greater"})
			}
		}
	}

	// Recurse into children
	for _, ci := range c.ast.Children(i) {
		c.walkForRescan(ci, events)
	}
}

func sortRescanEvents(events []RescanEvent) {
	// Simple insertion sort — events are typically few
	for i := 1; i < len(events); i++ {
		key := events[i]
		j := i - 1
		for j >= 0 && events[j].Pos > key.Pos {
			events[j+1] = events[j]
			j--
		}
		events[j+1] = key
	}
}

// FilterWhitelist removes properties from the converted AST that are not
// in the property whitelist. This is applied recursively.
func FilterWhitelist(obj map[string]interface{}) map[string]interface{} {
	result := make(map[string]interface{}, len(obj))
	for k, v := range obj {
		if !IsAllowedProperty(k) {
			continue
		}
		switch val := v.(type) {
		case map[string]interface{}:
			result[k] = FilterWhitelist(val)
		case []interface{}:
			result[k] = filterWhitelistArray(val)
		default:
			result[k] = v
		}
	}
	return result
}

func filterWhitelistArray(arr []interface{}) []interface{} {
	result := make([]interface{}, len(arr))
	for i, v := range arr {
		if obj, ok := v.(map[string]interface{}); ok {
			result[i] = FilterWhitelist(obj)
		} else {
			result[i] = v
		}
	}
	return result
}

// BuildKindToNameMap builds a reverse mapping from numeric kind to string name
// from a SyntaxKinds metadata map (name → number).
func BuildKindToNameMap(syntaxKinds map[string]int) map[uint32]string {
	result := make(map[uint32]string, len(syntaxKinds))
	for name, num := range syntaxKinds {
		key := uint32(num)
		// In case of collisions, prefer shorter/simpler names
		if existing, ok := result[key]; !ok || len(name) < len(existing) {
			result[key] = name
		}
	}
	return result
}

// StripKindPrefix removes "Kind" prefix from names if present (for TS7 Go-style names).
func StripKindPrefix(name string) string {
	if strings.HasPrefix(name, "Kind") {
		return name[4:]
	}
	return name
}
