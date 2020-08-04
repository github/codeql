import csharp

private newtype TPrintAstConfiguration = MkPrintAstConfiguration()

/**
 * The query can extend this class to control which elements are printed.
 */
class PrintAstConfiguration extends TPrintAstConfiguration {
  string toString() { result = "PrintAstConfiguration" }

  /**
   * Controls whether the `File` should be considered for AST printing.
   */
  predicate selectedFile(File file) { any() }

  /**
   * Controls whether the `Element` should be considered for AST printing.
   * By default it checks the which file the `elem` belongs to.
   */
  predicate shouldPrint(Element elem) {
    this.selectedFile(getRepresentativeLocation(elem).getFile())
  }
}

private predicate shouldPrint(Element elem) {
  exists(PrintAstConfiguration config | config.shouldPrint(elem))
}

private predicate selectedFile(File file) {
  exists(PrintAstConfiguration config | config.selectedFile(file))
}

private int attributableOffset(Attributable attributable) {
  if count(attributable.getAnAttribute()) > 0 then result = 1 else result = 0
}

private int unboundGenericOffset(ValueOrRefType type) {
  if type instanceof UnboundGeneric then result = 1 else result = 0
}

private int assignableOffset(AssignableMember assignable) {
  if assignable.(Property).hasInitializer() then result = 1 else result = 0
}

/**
 * An `Element`, such as a `namespace` and a `partial class`, might have multiple locations.
 * The locations are ordered by file, line, column, and then the first one is selected.
 */
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

/**
 * Printed AST nodes are mostly `Element`s of the underlying AST.
 * There are extra AST nodes generated for parameters of `Callable`s,
 * attributes of `Attributable`s, and type parameters of `UnboundGeneric`
 * types. These extra node are used as containers to organize the tree a
 * bit better.
 */
private newtype TPrintAstNode =
  TAstNode(Element ast) { shouldPrint(ast) } or
  TParametersNode(Callable callable) { shouldPrint(callable) } or
  TAttributesNode(Attributable attributable) { shouldPrint(attributable) } or
  TTypeParametersNode(UnboundGeneric generic) { shouldPrint(generic) }

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
   * but need not be contiguous.
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

/**
 * A node representing an AST node with an underlying `Element`.
 */
abstract class AstNode extends PrintAstNode, TAstNode {
  Element ast;

  AstNode() {
    this = TAstNode(ast) and
    // some elements might not be in the source code, such as default constructors.
    // But we can't filter out compiler generated Callables, because we do want to see autoproperty get, set.
    // So `fromSource` seems to be a good option.
    ast.fromSource()
  }

  override string toString() {
    //result = rank[1]("[" + ast.getAQlClass().toString() + "] " + ast.toString())
    result = ast.toString()
  }

  final override Location getLocation() {
    result = getRepresentativeLocation(ast) and selectedFile(result.getFile())
  }

  /**
   * Gets the AST represented by this node.
   */
  final Element getAst() { result = ast }
}

/**
 * A node representing a `ControlFlowElement` (`Expr` or `Stmt`).
 */
class ControlFlowElementNode extends AstNode {
  ControlFlowElement controlFlowElement;

  ControlFlowElementNode() { controlFlowElement = ast }

  override AstNode getChild(int childIndex) {
    result.getAst() = controlFlowElement.getChild(childIndex)
  }
}

/**
 * A node representing a `LocalFunctionStmt`.
 * Each `LocalFunction` is displayed below its corresponding `LocalFunctionStmt`.
 */
final class LocalFunctionStmtNode extends ControlFlowElementNode {
  LocalFunctionStmt stmt;

  LocalFunctionStmtNode() { stmt = ast }

  override CallableAstNode getChild(int childIndex) {
    childIndex = 0 and
    result.getAst() = stmt.getLocalFunction()
  }
}

/**
 * A node representing a `Callable`, such as method declaration.
 * Attributes, type parameters, parameters and the body are displayed as child nodes.
 */
final class CallableAstNode extends AstNode {
  Callable callable;

  CallableAstNode() { callable = ast }

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

/**
 * A node representing a `DeclarationWithAccessors`, such as property declaration.
 * Attributes, the initializer and the accessors are displayed as child nodes.
 */
final class DeclarationWithAccessorsNode extends AstNode {
  DeclarationWithAccessors declaration;

  DeclarationWithAccessorsNode() { declaration = ast }

  override PrintAstNode getChild(int childIndex) {
    childIndex = 0 and
    result.(AttributesNode).getAttributable() = declaration
    or
    childIndex = attributableOffset(declaration) and
    result.(AstNode).getAst() = declaration.(Property).getInitializer().getParent()
    or
    result.(AstNode).getAst() =
      rank[childIndex - attributableOffset(declaration) - assignableOffset(declaration)](Element a,
        string file, int line, int column |
        a = declaration.getAnAccessor() and
        locationSortKeys(a, file, line, column)
      |
        a order by file, line, column
      )
  }
}

/**
 * A node representing a `Field` declaration.
 * Attributes and the initializer are displayed as child nodes.
 */
final class FieldNode extends AstNode {
  Field field;

  FieldNode() { field = ast }

  override PrintAstNode getChild(int childIndex) {
    childIndex = 0 and
    result.(AttributesNode).getAttributable() = field
    or
    childIndex = 1 and
    result.(AstNode).getAst() = field.getInitializer().getParent()
  }
}

/**
 * A node representing a `Parameter` declaration.
 * Attributes and the default value are displayed as child nodes.
 */
final class ParameterNode extends AstNode {
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

/**
 * A node representing an `Attribute`.
 */
final class AttributeNode extends AstNode {
  Attribute attr;

  AttributeNode() { attr = ast }

  final override AstNode getChild(int childIndex) { result.getAst() = attr.getChild(childIndex) }
}

/**
 * A node representing a `TypeParameter`.
 */
final class TypeParameterNode extends AstNode {
  TypeParameter typeParameter;

  TypeParameterNode() { typeParameter = ast }

  final override AstNode getChild(int childIndex) { none() }
}

/**
 * A node representing a `ValueOrRefType`.
 * Attributes, type parameters, and members are displayed as child nodes.
 */
final class TypeNode extends AstNode {
  ValueOrRefType type;

  TypeNode() { type = ast }

  final override PrintAstNode getChild(int childIndex) {
    childIndex = 0 and
    result.(AttributesNode).getAttributable() = type
    or
    childIndex = attributableOffset(type) and
    result.(TypeParametersNode).getUnboundGeneric() = type
    or
    result.(AstNode).getAst() =
      rank[childIndex - attributableOffset(type) - unboundGenericOffset(type)](Member m,
        string file, int line, int column |
        m = type.getAMember() and
        locationSortKeys(m, file, line, column)
      |
        m order by file, line, column
      )
  }
}

/**
 * A node representing a `NamespaceDeclaration`.
 * Child namespaces and type declarations are displayed as child nodes.
 */
final class NamespaceNode extends AstNode {
  NamespaceDeclaration namespace;

  NamespaceNode() { namespace = ast }

  final override PrintAstNode getChild(int childIndex) {
    result.(AstNode).getAst() =
      rank[childIndex](Element a, string file, int line, int column |
        (a = namespace.getAChildNamespaceDeclaration() or a = namespace.getATypeDeclaration()) and
        locationSortKeys(a, file, line, column)
      |
        a order by file, line, column
      )
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
    callable.getNumberOfParameters() > 0
  }

  override string toString() { result = "Parameters" }

  override Location getLocation() { none() }

  override ParameterNode getChild(int childIndex) {
    result.getAst() = callable.getParameter(childIndex)
  }

  Callable getCallable() { result = callable }
}

/**
 * A node representing the attributes of an `Attributable`.
 * Only rendered if there's at least one attribute.
 */
final class AttributesNode extends PrintAstNode, TAttributesNode {
  Attributable attributable;

  AttributesNode() {
    this = TAttributesNode(attributable) and
    count(attributable.getAnAttribute()) > 0
  }

  override string toString() { result = "Attributes" }

  override Location getLocation() { none() }

  override AttributeNode getChild(int childIndex) {
    result.getAst() =
      rank[childIndex](Attribute a, string file, int line, int column |
        a = attributable.getAnAttribute() and
        locationSortKeys(a, file, line, column)
      |
        a order by file, line, column
      )
  }

  Attributable getAttributable() { result = attributable }
}

/**
 * A node representing the type parameters of an `UnboundGeneric`.
 */
final class TypeParametersNode extends PrintAstNode, TTypeParametersNode {
  UnboundGeneric unboundGeneric;

  TypeParametersNode() {
    this = TTypeParametersNode(unboundGeneric) and
    unboundGeneric.getNumberOfTypeParameters() > 0 // this might always be true
  }

  override string toString() { result = "TypeParameters" }

  override Location getLocation() { none() }

  override TypeParameterNode getChild(int childIndex) {
    result.getAst() = unboundGeneric.getTypeParameter(childIndex)
  }

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
