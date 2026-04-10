// Package astconv handles conversion between TypeScript 7's AST representation
// and the JSON format expected by the Java extractor.
//
// The Java extractor expects AST nodes to have:
//   - "kind" as a symbolic string name (e.g., "SourceFile"), not a numeric value
//   - "$pos" and "$end" as character offsets
//   - "$lineStarts" on the root SourceFile node
//   - "$tokens" array on the root node
//   - "$declarationKind" on VariableDeclarationList nodes ("var", "let", "const")
//   - Only whitelisted property names (see propertyWhitelist)
package astconv

// PropertyWhitelist is the set of property names that should be included
// in the serialized AST JSON. This must match the whitelist in the Node.js
// wrapper (main.ts).
var PropertyWhitelist = map[string]bool{
	"$declarationKind": true,
	"$end":             true,
	"$lineStarts":      true,
	"$overloadIndex":   true,
	"$pos":             true,
	"$tokens":          true,
	"argument":         true,
	"argumentExpression": true,
	"arguments":        true,
	"assertsModifier":  true,
	"asteriskToken":    true,
	"attributes":       true,
	"block":            true,
	"body":             true,
	"caseBlock":        true,
	"catchClause":      true,
	"checkType":        true,
	"children":         true,
	"clauses":          true,
	"closingElement":   true,
	"closingFragment":  true,
	"condition":        true,
	"constraint":       true,
	"constructor":      true,
	"declarationList":  true,
	"declarations":     true,
	"default":          true,
	"delete":           true,
	"dotDotDotToken":   true,
	"elements":         true,
	"elementType":      true,
	"elementTypes":     true,
	"elseStatement":    true,
	"escapedText":      true,
	"exclamationToken": true,
	"exportClause":     true,
	"expression":       true,
	"exprName":         true,
	"extendsType":      true,
	"falseType":        true,
	"finallyBlock":     true,
	"flags":            true,
	"head":             true,
	"heritageClauses":  true,
	"importClause":     true,
	"incrementor":      true,
	"indexType":        true,
	"init":             true,
	"initializer":      true,
	"isExportEquals":   true,
	"isTypeOf":         true,
	"isTypeOnly":       true,
	"keywordToken":     true,
	"kind":             true,
	"label":            true,
	"left":             true,
	"literal":          true,
	"members":          true,
	"messageText":      true,
	"modifiers":        true,
	"moduleReference":  true,
	"moduleSpecifier":  true,
	"name":             true,
	"namedBindings":    true,
	"objectType":       true,
	"openingElement":   true,
	"openingFragment":  true,
	"operand":          true,
	"operator":         true,
	"operatorToken":    true,
	"parameterName":    true,
	"parameters":       true,
	"parseDiagnostics": true,
	"phaseModifier":    true,
	"properties":       true,
	"propertyName":     true,
	"qualifier":        true,
	"questionDotToken": true,
	"questionToken":    true,
	"right":            true,
	"selfClosing":      true,
	"statement":        true,
	"statements":       true,
	"tag":              true,
	"tagName":          true,
	"template":         true,
	"templateSpans":    true,
	"text":             true,
	"thenStatement":    true,
	"token":            true,
	"tokenPos":         true,
	"trueType":         true,
	"tryBlock":         true,
	"type":             true,
	"typeArguments":    true,
	"typeName":         true,
	"typeParameter":    true,
	"typeParameters":   true,
	"types":            true,
	"variableDeclaration": true,
	"whenFalse":        true,
	"whenTrue":         true,
}

// MetaProperties are property names used in the parse response wrapper
// (not part of the AST itself but part of the response envelope).
var MetaProperties = map[string]bool{
	"ast":  true,
	"type": true,
}

// IsAllowedProperty returns true if the property name should be included
// in the serialized AST JSON.
func IsAllowedProperty(name string) bool {
	if PropertyWhitelist[name] {
		return true
	}
	if MetaProperties[name] {
		return true
	}
	// Numeric keys (array indices) are always allowed
	if len(name) > 0 && name[0] >= '0' && name[0] <= '9' {
		return true
	}
	return false
}
