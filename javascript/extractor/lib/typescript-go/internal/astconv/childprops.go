package astconv

// childProps maps SyntaxKind string names to ordered lists of child property names.
// The order corresponds to the bitmask order in the binary encoder. When a node
// uses the Children data type (top 2 bits = 0b00), the low byte is a bitmask
// indicating which of these properties are present. Children are consumed in order.
//
// These names must match the property names expected by the Java extractor.
// Derived from microsoft/typescript-go/internal/api/encoder/encoder.go.
var childProps = map[string][]string{
	// Multi-child nodes with property mask
	"QualifiedName":              {"left", "right"},
	"TypeParameter":              {"modifiers", "name", "constraint", "default"},
	"IfStatement":                {"expression", "thenStatement", "elseStatement"},
	"DoStatement":                {"statement", "expression"},
	"WhileStatement":             {"expression", "statement"},
	"ForStatement":               {"initializer", "condition", "incrementor", "statement"},
	"ForInStatement":             {"awaitModifier", "initializer", "expression", "statement"},
	"ForOfStatement":             {"awaitModifier", "initializer", "expression", "statement"},
	"WithStatement":              {"expression", "statement"},
	"SwitchStatement":            {"expression", "caseBlock"},
	"CaseClause":                 {"expression", "statements"},
	"DefaultClause":              {"expression", "statements"},
	"TryStatement":               {"tryBlock", "catchClause", "finallyBlock"},
	"CatchClause":                {"variableDeclaration", "block"},
	"LabeledStatement":           {"label", "statement"},
	"VariableStatement":          {"modifiers", "declarationList"},
	"VariableDeclarationList":    {"declarations"},
	"VariableDeclaration":        {"name", "exclamationToken", "type", "initializer"},
	"Parameter":                  {"modifiers", "dotDotDotToken", "name", "questionToken", "type", "initializer"},
	"BindingElement":             {"dotDotDotToken", "propertyName", "name", "initializer"},
	"FunctionDeclaration":        {"modifiers", "asteriskToken", "name", "typeParameters", "parameters", "type", "body"},
	"InterfaceDeclaration":       {"modifiers", "name", "typeParameters", "heritageClauses", "members"},
	"TypeAliasDeclaration":       {"modifiers", "name", "typeParameters", "type"},
	"EnumMember":                 {"name", "initializer"},
	"EnumDeclaration":            {"modifiers", "name", "members"},
	"ModuleDeclaration":          {"modifiers", "name", "body"},
	"ImportEqualsDeclaration":    {"modifiers", "name", "moduleReference"},
	"ImportDeclaration":          {"modifiers", "importClause", "moduleSpecifier", "attributes"},
	"JSImportDeclaration":        {"modifiers", "importClause", "moduleSpecifier", "attributes"},
	"ImportSpecifier":            {"propertyName", "name"},
	"ImportClause":               {"name", "namedBindings"},
	"ExportAssignment":           {"modifiers", "expression"},
	"JSExportAssignment":         {"modifiers", "expression"},
	"NamespaceExportDeclaration": {"modifiers", "name"},
	"ExportDeclaration":          {"modifiers", "exportClause", "moduleSpecifier", "attributes"},
	"ExportSpecifier":            {"propertyName", "name"},
	"CallSignature":              {"typeParameters", "parameters", "type"},
	"ConstructSignature":         {"typeParameters", "parameters", "type"},
	"Constructor":                {"modifiers", "typeParameters", "parameters", "type", "body"},
	"GetAccessor":                {"modifiers", "name", "typeParameters", "parameters", "type", "body"},
	"SetAccessor":                {"modifiers", "name", "typeParameters", "parameters", "type", "body"},
	"IndexSignature":             {"modifiers", "parameters", "type"},
	"MethodSignature":            {"modifiers", "name", "questionToken", "typeParameters", "parameters", "type"},
	"MethodDeclaration":          {"modifiers", "asteriskToken", "name", "questionToken", "typeParameters", "parameters", "type", "body"},
	"PropertySignature":          {"modifiers", "name", "questionToken", "type", "initializer"},
	"PropertyDeclaration":        {"modifiers", "name", "questionToken", "type", "initializer"},
	"BinaryExpression":           {"left", "operatorToken", "right"},
	"YieldExpression":            {"asteriskToken", "expression"},
	"ArrowFunction":              {"modifiers", "typeParameters", "parameters", "type", "equalsGreaterThanToken", "body"},
	"FunctionExpression":         {"modifiers", "asteriskToken", "name", "typeParameters", "parameters", "type", "body"},
	"AsExpression":               {"expression", "type"},
	"SatisfiesExpression":        {"expression", "type"},
	"ConditionalExpression":      {"condition", "questionToken", "whenTrue", "colonToken", "whenFalse"},
	"PropertyAccessExpression":   {"expression", "questionDotToken", "name"},
	"ElementAccessExpression":    {"expression", "questionDotToken", "argumentExpression"},
	"CallExpression":             {"expression", "questionDotToken", "typeArguments", "arguments"},
	"NewExpression":              {"expression", "typeArguments", "arguments"},
	"TemplateExpression":         {"head", "templateSpans"},
	"TemplateSpan":               {"expression", "literal"},
	"TaggedTemplateExpression":   {"tag", "questionDotToken", "typeArguments", "template"},
	"PropertyAssignment":         {"modifiers", "name", "questionToken", "initializer"},
	"ShorthandPropertyAssignment": {"modifiers", "name", "questionToken", "equalsToken", "objectAssignmentInitializer"},
	"TypeAssertionExpression":    {"type", "expression"},
	"ConditionalType":            {"checkType", "extendsType", "trueType", "falseType"},
	"IndexedAccessType":          {"objectType", "indexType"},
	"TypeReference":              {"typeName", "typeArguments"},
	"ExpressionWithTypeArguments": {"expression", "typeArguments"},
	"TypePredicate":              {"assertsModifier", "parameterName", "type"},
	"ImportType":                 {"argument", "attributes", "qualifier", "typeArguments"},
	"ImportAttribute":            {"name", "value"},
	"TypeQuery":                  {"exprName", "typeArguments"},
	"MappedType":                 {"readonlyToken", "typeParameter", "nameType", "questionToken", "type", "members"},
	"NamedTupleMember":           {"dotDotDotToken", "name", "questionToken", "type"},
	"FunctionType":               {"typeParameters", "parameters", "type"},
	"ConstructorType":            {"modifiers", "typeParameters", "parameters", "type"},
	"TemplateLiteralType":        {"head", "templateSpans"},
	"TemplateLiteralTypeSpan":    {"type", "literal"},
	"JsxElement":                 {"openingElement", "children", "closingElement"},
	"JsxNamespacedName":          {"name", "namespace"},
	"JsxOpeningElement":          {"tagName", "typeArguments", "attributes"},
	"JsxSelfClosingElement":      {"tagName", "typeArguments", "attributes"},
	"JsxFragment":                {"openingFragment", "children", "closingFragment"},
	"JsxAttribute":               {"name", "initializer"},
	"JsxExpression":              {"dotDotDotToken", "expression"},
	"JSDoc":                      {"comment", "tags"},
	"JSDocTypeTag":               {"tagName", "typeExpression", "comment"},
	"JSDocTag":                   {"tagName", "comment"},
	"JSDocTemplateTag":           {"tagName", "constraint", "typeParameters", "comment"},
	"JSDocReturnTag":             {"tagName", "typeExpression", "comment"},
	"JSDocPublicTag":             {"tagName", "comment"},
	"JSDocPrivateTag":            {"tagName", "comment"},
	"JSDocProtectedTag":          {"tagName", "comment"},
	"JSDocReadonlyTag":           {"tagName", "comment"},
	"JSDocOverrideTag":           {"tagName", "comment"},
	"JSDocDeprecatedTag":         {"tagName", "comment"},
	"JSDocSeeTag":                {"tagName", "nameExpression", "comment"},
	"JSDocImplementsTag":         {"tagName", "className", "comment"},
	"JSDocAugmentsTag":           {"tagName", "className", "comment"},
	"JSDocSatisfiesTag":          {"tagName", "typeExpression", "comment"},
	"JSDocThrowsTag":             {"tagName", "typeExpression", "comment"},
	"JSDocThisTag":               {"tagName", "typeExpression", "comment"},
	"JSDocImportTag":             {"tagName", "importClause", "moduleSpecifier", "attributes", "comment"},
	"JSDocCallbackTag":           {"tagName", "typeExpression", "fullName", "comment"},
	"JSDocOverloadTag":           {"tagName", "typeExpression", "comment"},
	"JSDocTypedefTag":            {"tagName", "typeExpression", "name", "comment"},
	"JSDocSignature":             {"typeParameters", "parameters", "type"},
	"ClassStaticBlockDeclaration": {"modifiers", "body"},
	"ClassDeclaration":           {"modifiers", "name", "typeParameters", "heritageClauses", "members"},
	"ClassExpression":            {"modifiers", "name", "typeParameters", "heritageClauses", "members"},

	// JSDocParameterTag and JSDocPropertyTag have order-dependent children
	// (handled specially in the converter based on isNameFirst defined bit).
	// Default order (isNameFirst=false):
	"JSDocParameterTag": {"tagName", "typeExpression", "name", "comment"},
	"JSDocPropertyTag":  {"tagName", "typeExpression", "name", "comment"},
}

// singleChildProp maps node kinds that have exactly one Node child to
// the property name for that child.
var singleChildProp = map[string]string{
	"ReturnStatement":        "expression",
	"ThrowStatement":         "expression",
	"ExpressionStatement":    "expression",
	"BreakStatement":         "label",
	"ContinueStatement":      "label",
	"ParenthesizedExpression": "expression",
	"ComputedPropertyName":   "expression",
	"Decorator":              "expression",
	"SpreadElement":          "expression",
	"SpreadAssignment":       "expression",
	"DeleteExpression":       "expression",
	"TypeOfExpression":       "expression",
	"VoidExpression":         "expression",
	"AwaitExpression":        "expression",
	"NonNullExpression":      "expression",
	"ExternalModuleReference": "expression",
	"NamespaceImport":        "name",
	"NamespaceExport":        "name",
	"JsxClosingElement":      "tagName",
	"ArrayType":              "elementType",
	"LiteralType":            "literal",
	"InferType":              "typeParameter",
	"OptionalType":           "type",
	"RestType":               "type",
	"ParenthesizedType":      "type",
	"JSDocTypeExpression":    "type",
	"JSDocNonNullableType":   "type",
	"JSDocNullableType":      "type",
	"JSDocVariadicType":      "type",
	"JSDocOptionalType":      "type",
	"JSDocNameReference":     "name",
}

// singleNodeListProp maps node kinds that have exactly one NodeList child
// to the property name for that child.
var singleNodeListProp = map[string]string{
	"Block":                  "statements",
	"ArrayLiteralExpression": "elements",
	"ObjectLiteralExpression": "properties",
	"UnionType":              "types",
	"IntersectionType":       "types",
	"TupleType":              "elements",
	"NamedImports":           "elements",
	"NamedExports":           "elements",
	"ModuleBlock":            "statements",
	"CaseBlock":              "clauses",
	"TypeLiteral":            "members",
	"JsxAttributes":          "properties",
	"ArrayBindingPattern":    "elements",
	"ObjectBindingPattern":   "elements",
	"HeritageClause":         "types",
	"ImportAttributes":       "elements",
	"JSDocTypeLiteral":       "jsDocPropertyTags",
}

// operandKinds are node kinds where the single child is called "operand"
// and the operator is encoded in the defined bits.
var operandKinds = map[string]bool{
	"PrefixUnaryExpression":  true,
	"PostfixUnaryExpression": true,
}

// GetChildProperties returns the ordered child property names for the given
// SyntaxKind name. Returns nil if the kind has no registered child properties
// (leaf node, single-child, or NodeList-child).
func GetChildProperties(kindName string) []string {
	return childProps[kindName]
}

// GetSingleChildProperty returns the property name for a single-child node.
// Returns "" if the kind is not a single-child node.
func GetSingleChildProperty(kindName string) string {
	return singleChildProp[kindName]
}

// GetSingleNodeListProperty returns the property name for a single-NodeList-child node.
// Returns "" if the kind is not a single-NodeList-child node.
func GetSingleNodeListProperty(kindName string) string {
	return singleNodeListProp[kindName]
}
