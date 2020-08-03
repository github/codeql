import csharp

private newtype TPrintAstConfiguration = MkPrintAstConfiguration()

/**
 * The query can extend this class to control which elements are printed.
 */
class PrintAstConfiguration extends TPrintAstConfiguration {
  string toString() { result = "PrintAstConfiguration" }

  /**
   * Holds if the AST for `elem` should be printed. By default, holds for all
   * elements.
   */
  predicate shouldPrint(Element elem) { any() }

  predicate selectedFile(File f){ any() }
}

private predicate shouldPrint(Element elem) {
  exists(PrintAstConfiguration config | config.shouldPrint(elem))
}

private predicate selectedFile(File f) {
  exists(PrintAstConfiguration config | config.selectedFile(f))
}

private int attributableOffset(Attributable a) {
  if count(a.getAnAttribute()) > 0 then
    result = 1
  else
    result = 0
}

private int unboundGenericOffset(ValueOrRefType t) {
  if t instanceof UnboundGeneric then
    result = 1
  else
    result = 0
}

private int assignableOffset(AssignableMember a) {
  if a.(Property).hasInitializer() then result = 1 else result = 0
}

private newtype TPrintAstNode =
  TAstNode(Element ast) { shouldPrint(ast) } or
  TParametersNode(Callable callable) { shouldPrint(callable) } or
  TAttributesNode(Attributable attributable) { shouldPrint(attributable) } or
  TTypeParametersNode(UnboundGeneric generic) { shouldPrint(generic) }
  // we might have more types.

/**
 * A node in the output tree.
 */
class PrintAstNode extends TPrintAstNode {
  /**
   * Gets a textual representation of this node in the PrintAst output tree.
   */
  abstract string toString();

  /**
   * Gets the child node at index `childIndex`. Child indices must be unique,
   * but need not be contiguous (but see `getChildByRank`).
   */
  abstract PrintAstNode getChild(int childIndex);

  final predicate shouldPrint() { any() }

  /**
   * Gets the children of this node.
   */
  final PrintAstNode getAChild() { result = getChild(_) }

  /**
   * Gets the parent of this node, if any.
   */
  final PrintAstNode getParent() { result.getAChild() = this }

  /**
   * Gets the location of this node in the source code.
   */
  abstract Location getLocation();

  /**
   * Gets the value of the property of this node, where the name of the property
   * is `key`.
   */
  string getProperty(string key) {
    key = "semmle.label" and
    result = toString()
  }

  /**
   * Gets the label for the edge from this node to the specified child. By
   * default, this is just the index of the child, but subclasses can override
   * this.
   */
  string getChildEdgeLabel(int childIndex) {
    exists(getChild(childIndex)) and
    result = childIndex.toString()
  }
}

abstract class AstNode extends PrintAstNode, TAstNode {
  Element ast;

  AstNode() { this = TAstNode(ast) and ast.fromSource() }

  override string toString() { 
    //result = rank[1]("[" + ast.getAQlClass().toString() + "] " + ast.toString()) 
    result = ast.toString()
  }

  final override Location getLocation() { result = getRepresentativeLocation(ast) and selectedFile(result.getFile()) }

  /**
   * Gets the AST represented by this node.
   */
  final Element getAst() { result = ast }
}

class ControlFlowElementNode extends AstNode {
  ControlFlowElement controlFlowElement;

  ControlFlowElementNode() { controlFlowElement = ast }

  override AstNode getChild(int childIndex) {
    result.getAst() = controlFlowElement.getChild(childIndex)
  }
}

final class LocalFunctionStmtNode extends ControlFlowElementNode {
  LocalFunctionStmt stmt;

  LocalFunctionStmtNode() { stmt = ast }

  override CallableAstNode getChild(int childIndex) {
    childIndex = 0 and
    result.getAst() = stmt.getLocalFunction()
  }
}

class CallableAstNode extends AstNode {
  Callable callable;

  CallableAstNode() {
    callable = ast
  }

  override PrintAstNode getChild(int childIndex) {
    childIndex = 0 and
     result.(AttributesNode).getAttributable() = callable
    or
    childIndex = 1 and
     result.(TypeParametersNode).getUnboundGeneric() = callable
    or
     childIndex = 2 and
     result.(ParametersNode).getCallable() = callable
    or
     childIndex = 3 and
     result.(AstNode).getAst() = callable.getBody()
  }
}

class DeclarationWithAccessorsNode extends AstNode {
  DeclarationWithAccessors declaration;

  DeclarationWithAccessorsNode() { declaration = ast }

  override PrintAstNode getChild(int childIndex) {
     childIndex = 0 and
     result.(AttributesNode).getAttributable() = declaration
    or
     childIndex = attributableOffset(declaration) and
     result.(AstNode).getAst() = declaration.(Property).getInitializer().getParent()
    or
     result.(AstNode).getAst() = rank[childIndex - attributableOffset(declaration) - assignableOffset(declaration)](Accessor a, string file, int line, int column
      |
        a = declaration.getAnAccessor() and
        locationSortKeys(a, file, line, column)
      |
        a order by file, line, column)
  }
}

class FieldNode extends AstNode {
  Field field;

  FieldNode() { field = ast }

  override PrintAstNode getChild(int childIndex) {
     childIndex = 0 and
     result.(AttributesNode).getAttributable() = field
    or
     childIndex = 1 and
     //result.(AstNode).getAst() = field.getChild(childIndex - attributableOffset(field))
     result.(AstNode).getAst() = field.getInitializer().getParent()
  }
}

class ParameterNode extends AstNode {
  Parameter param;

  ParameterNode() { param = ast }

  final override PrintAstNode getChild(int childIndex) {
     childIndex = 0 and
     result.(AttributesNode).getAttributable() = param
    or
     childIndex = 1 and
     param.hasDefaultValue() and
     result.(AstNode).getAst() = param.getDefaultValue()
  }
}

class AttributeNode extends AstNode {
  Attribute attr;

  AttributeNode() { attr = ast }

  final override AstNode getChild(int childIndex) {
    result.getAst() = attr.getChild(childIndex)
  }
}

class TypeParameterNode extends AstNode {
  TypeParameter typeParameter;

  TypeParameterNode() { typeParameter = ast }

  final override AstNode getChild(int childIndex) {
    none()
  }
}

private Location getRepresentativeLocation(Element ast) {
  result = rank[1](Location loc | loc = ast.getLocation() | loc order by loc.toString() desc) // todo tv: why do I need desc here?
}

private predicate locationSortKeys(Element ast, string file, int line, int column) {
  if exists(getRepresentativeLocation(ast))
  then
    exists(Location loc |
      loc = getRepresentativeLocation(ast) and
      file = loc.getFile().toString() and
      line = loc.getStartLine() and
      column = loc.getStartColumn()
    )
  else (
    file = "" and
    line = 0 and
    column = 0
  )
}

class TypeNode extends AstNode {
  ValueOrRefType type;

  TypeNode() { type = ast }

  final override PrintAstNode getChild(int childIndex) { 
     childIndex = 0 and
     result.(AttributesNode).getAttributable() = type
    or
     childIndex = attributableOffset(type) and
     result.(TypeParametersNode).getUnboundGeneric() = type
    or
    result.(AstNode).getAst() = rank[childIndex - attributableOffset(type) - unboundGenericOffset(type)](Member m, string file, int line, int column
      |
        m = type.getAMember()  and
        locationSortKeys(m, file, line, column)
      |
        m order by file, line, column)
  }
}

class NamespaceNode extends AstNode {
  NamespaceDeclaration namespace;

  NamespaceNode() { namespace = ast }

  final override PrintAstNode getChild(int childIndex) {
    result.(AstNode).getAst() = rank[childIndex](Element a, string file, int line, int column
      |
        (a = namespace.getAChildNamespaceDeclaration() or a = namespace.getATypeDeclaration()) and
        locationSortKeys(a, file, line, column)
      |
        a order by file, line, column)
 }
}

/**
 * A node representing the parameters of a `Callable`.
 * Only rendered if there's at least one parameter.
 */
final class ParametersNode extends PrintAstNode, TParametersNode {
  Callable callable;

  ParametersNode() {
    this = TParametersNode(callable) and
    // not callable.isCompilerGenerated() and
    callable.getNumberOfParameters() > 0
  }

  override string toString() { result = "Parameters" }

  override Location getLocation() { none() }

  override ParameterNode getChild(int childIndex) { result.getAst() = callable.getParameter(childIndex) }

  Callable getCallable() { result = callable }
}

final class AttributesNode extends PrintAstNode, TAttributesNode {
  Attributable attributable;

  AttributesNode() {
    this = TAttributesNode(attributable) and
    count(attributable.getAnAttribute()) > 0
  }

  override string toString() { result = "Attributes" }

  override Location getLocation() { none() }

  override AttributeNode getChild(int childIndex) {
    result.getAst() = rank[childIndex](Attribute a, string file, int line, int column
      |
        a = attributable.getAnAttribute()  and
        locationSortKeys(a, file, line, column)
      |
        a order by file, line, column)
  }

  Attributable getAttributable() { result = attributable }
}

final class TypeParametersNode extends PrintAstNode, TTypeParametersNode {
  UnboundGeneric unboundGeneric;

  TypeParametersNode() {
    this = TTypeParametersNode(unboundGeneric) and
    unboundGeneric.getNumberOfTypeParameters() > 0
  }

  override string toString() { result = "TypeParameters" }

  override Location getLocation() { none() }

  override TypeParameterNode getChild(int childIndex) { result.getAst() = unboundGeneric.getTypeParameter(childIndex) }

  UnboundGeneric getUnboundGeneric() { result = unboundGeneric }
}

// private predicate foo(Method m, Parameter p, int i){
//   p = m.getParameter(i) and p.getLocation().getStartLine() = 84
// }

/** Holds if `node` belongs to the output tree, and its property `key` has the given `value`. */
query predicate nodes(PrintAstNode node, string key, string value) {
  node.shouldPrint() and
  value = node.getProperty(key)
}

/**
 * Holds if `target` is a child of `source` in the AST, and property `key` of the edge has the
 * given `value`.
 */
query predicate edges(PrintAstNode source, PrintAstNode target, string key, string value) {
  exists(int childIndex |
    source.shouldPrint() and
    target.shouldPrint() and
    target = source.getChild(childIndex) and
    (
      key = "semmle.label" and value = source.getChildEdgeLabel(childIndex)
      or
      key = "semmle.order" and value = childIndex.toString()
    )
  )
}

/** Holds if property `key` of the graph has the given `value`. */
query predicate graphProperties(string key, string value) {
  key = "semmle.graphKind" and value = "tree"
}