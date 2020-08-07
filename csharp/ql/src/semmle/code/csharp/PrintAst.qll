/**
 * Provides queries to pretty-print a C# AST as a graph.
 *
 * By default, this will print the AST for all elements in the database. To change this behavior,
 * extend `PrintAstConfiguration` and override `shouldPrint` to hold for only the elements
 * you wish to view the AST for, or override `selectedFile` to hold for only the files you
 * are interested in.
 */

import csharp

private newtype TPrintAstConfiguration = MkPrintAstConfiguration()

/**
 * The query can extend this class to control which elements are printed.
 */
class PrintAstConfiguration extends TPrintAstConfiguration {
  /**
   * Gets a textual representation of this `PrintAstConfiguration`.
   */
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
    elem.fromSource() and
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

private int parameterizableTypeOffset(ValueOrRefType type) {
  if type instanceof Parameterizable and type.(Parameterizable).getNumberOfParameters() > 0
  then result = 1
  else result = 0
}

private int parameterizableDeclarationOffset(DeclarationWithAccessors declaration) {
  if declaration instanceof Indexer and declaration.(Parameterizable).getNumberOfParameters() > 0
  then result = 1
  else result = 0
}

private int unboundGenericOffset(ValueOrRefType type) {
  if type instanceof UnboundGeneric then result = 1 else result = 0
}

private int assignableOffset(AssignableMember assignable) {
  if assignable.(Property).hasInitializer() then result = 1 else result = 0
}

private predicate isInConstructedGenericAttributable(Attributable attributable) {
  isInUnneededType(attributable.(Field).getDeclaringType()) or
  isInConstructedGenericParameterizable(attributable.(Parameter).getDeclaringElement()) or
  isInConstructedGenericCallable(attributable.(Callable)) or
  isInUnneededType(attributable.(DeclarationWithAccessors).getDeclaringType()) or
  isInUnneededType(attributable.(ValueOrRefType))
}

private predicate isInConstructedGenericUnboundGeneric(UnboundGeneric unboundGeneric) {
  isInConstructedGenericAttributable(unboundGeneric) or
  isInConstructedGenericParameterizable(unboundGeneric)
}

private predicate isInConstructedGenericCallable(Callable c) {
  c instanceof ConstructedGeneric or
  isInUnneededType(c.getDeclaringType())
}

private predicate isInUnneededType(Type t) {
  t instanceof ConstructedType or
  t.getDeclaringType*() instanceof ConstructedType or
  t instanceof AnonymousClass or
  t.getDeclaringType*() instanceof AnonymousClass
}

private predicate isInConstructedGenericParameterizable(Parameterizable parameterizable) {
  isInConstructedGenericCallable(parameterizable) or
  isInUnneededType(parameterizable.(Indexer).getDeclaringType()) or
  isInUnneededType(parameterizable.(DelegateType))
}

private predicate isCompilerGeneratedParameterizable(Parameterizable parameterizable) {
  parameterizable.isCompilerGenerated() or
  parameterizable.getDeclaringType*().isCompilerGenerated()
}

/**
 * Default parameter values on delegates are in the tree multiple times,
 * due to the compiler generated `Invoke`.
 */
private predicate isCompilerGeneratedAttributable(Attributable attributable) {
  isCompilerGeneratedParameterizable(attributable.(Parameter).getDeclaringElement())
}

/**
 * Retrieves the canonical QL class(es) for entity `el`
 */
private string getQlClass(Element el) {
  if count(el.getAPrimaryQlClass()) = 1 and not el.getAPrimaryQlClass() = "???"
  then result = "[" + el.getAPrimaryQlClass() + "] "
  else
    if count(el.getAPrimaryQlClass()) > 1
    then result = "[" + concat(el.getAPrimaryQlClass(), ",") + "] "
    else result = "ERR [" + concat(el.getAQlClass(), ",") + "] "
}

/**
 * An `Element`, such as a `namespace` and a `partial class`, might have multiple locations.
 * The locations are ordered by file, line, column, and then the first one is selected.
 */
private Location getRepresentativeLocation(Element ast) {
  result =
    rank[1](Location loc |
      loc = ast.getLocation() and selectedFile(loc.getFile())
    |
      loc order by loc.getStartLine(), loc.getStartColumn(), loc.getEndLine(), loc.getEndColumn()
    )
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
  TParametersNode(Parameterizable parameterizable) { shouldPrint(parameterizable) } or
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

  AstNode() { this = TAstNode(ast) }

  override string toString() { result = getQlClass(ast) + ast.toString() }

  override Location getLocation() { result = getRepresentativeLocation(ast) }

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

  ControlFlowElementNode() {
    controlFlowElement = ast and
    // Removing extra nodes that are generated for an `AssignOperation`
    not exists(AssignOperation ao |
      ao.hasExpandedAssignment() and
      (
        ao.getExpandedAssignment() = controlFlowElement or
        ao.getExpandedAssignment().getRValue() = controlFlowElement or
        ao.getExpandedAssignment().getRValue().(BinaryOperation).getLeftOperand() =
          controlFlowElement.getParent*()
      )
    ) and
    not isCompilerGeneratedAttributable(ast.getParent+().(Attribute).getTarget()) and
    not isCompilerGeneratedParameterizable(ast.getParent+().(Parameter).getDeclaringElement()) and
    not isInConstructedGenericAttributable(ast.getParent+().(Attribute).getTarget()) and
    not isInConstructedGenericParameterizable(ast.getParent+().(Parameter).getDeclaringElement())
  }

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

  CallableAstNode() {
    callable = ast and
    not isInConstructedGenericCallable(callable)
  }

  override PrintAstNode getChild(int childIndex) {
    childIndex = 0 and
    result.(AttributesNode).getAttributable() = callable
    or
    childIndex = 1 and
    result.(TypeParametersNode).getUnboundGeneric() = callable
    or
    childIndex = 2 and
    result.(ParametersNode).getParameterizable() = callable
    or
    childIndex = 3 and
    result.(AstNode).getAst() = callable.(Constructor).getInitializer()
    or
    childIndex = 4 and
    result.(AstNode).getAst() = callable.getBody()
  }
}

/**
 * A node representing a `DeclarationWithAccessors`, such as property declaration.
 * Attributes, the initializer and the accessors are displayed as child nodes.
 */
final class DeclarationWithAccessorsNode extends AstNode {
  DeclarationWithAccessors declaration;

  DeclarationWithAccessorsNode() {
    declaration = ast and
    not isInUnneededType(declaration.getDeclaringType())
  }

  override PrintAstNode getChild(int childIndex) {
    childIndex = 0 and
    result.(AttributesNode).getAttributable() = declaration
    or
    childIndex = attributableOffset(declaration) and
    result.(ParametersNode).getParameterizable() = declaration
    or
    childIndex = attributableOffset(declaration) + parameterizableDeclarationOffset(declaration) and
    result.(AstNode).getAst() = declaration.(Property).getInitializer().getParent()
    or
    result.(AstNode).getAst() =
      rank[childIndex - attributableOffset(declaration) - assignableOffset(declaration) -
          parameterizableDeclarationOffset(declaration)](Element a, string file, int line,
        int column |
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

  FieldNode() {
    field = ast and
    not field.getDeclaringType() instanceof TupleType and
    not isInUnneededType(field.getDeclaringType())
  }

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

  ParameterNode() {
    param = ast and
    not isInConstructedGenericParameterizable(param.getDeclaringElement()) and
    (
      not param.getDeclaringElement().isCompilerGenerated() or
      param.getDeclaringElement() instanceof Accessor
    )
  }

  override Location getLocation() {
    not param.hasExtensionMethodModifier() and result = super.getLocation()
    or
    // for extension method first parameters, we're choosing the shorter location of the two
    param.hasExtensionMethodModifier() and
    result =
      rank[1](Location loc |
        loc = ast.getLocation() and
        selectedFile(loc.getFile()) and
        loc.getStartLine() = loc.getEndLine()
      |
        loc order by loc.getEndColumn() - loc.getStartColumn()
      )
  }

  override PrintAstNode getChild(int childIndex) {
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

  AttributeNode() {
    attr = ast and
    not isCompilerGeneratedAttributable(attr.getTarget()) and
    not isInConstructedGenericAttributable(attr.getTarget())
  }

  override AstNode getChild(int childIndex) { result.getAst() = attr.getChild(childIndex) }
}

/**
 * A node representing a `TypeParameter`.
 */
final class TypeParameterNode extends AstNode {
  TypeParameter typeParameter;

  TypeParameterNode() {
    typeParameter = ast and
    not isInConstructedGenericUnboundGeneric(typeParameter.getDeclaringGeneric())
  }

  override AstNode getChild(int childIndex) { none() }
}

/**
 * A node representing a `ValueOrRefType`.
 * Attributes, type parameters, and members are displayed as child nodes.
 */
final class TypeNode extends AstNode {
  ValueOrRefType type;

  TypeNode() {
    type = ast and
    not type instanceof TupleType and
    not type instanceof ArrayType and
    not type instanceof NullableType and
    not isInUnneededType(type)
  }

  override PrintAstNode getChild(int childIndex) {
    childIndex = 0 and
    result.(AttributesNode).getAttributable() = type
    or
    childIndex = attributableOffset(type) and
    result.(TypeParametersNode).getUnboundGeneric() = type
    or
    childIndex = attributableOffset(type) + unboundGenericOffset(type) and
    result.(ParametersNode).getParameterizable() = type
    or
    result.(AstNode).getAst() =
      rank[childIndex - attributableOffset(type) - unboundGenericOffset(type) -
          parameterizableTypeOffset(type)](Member m, string file, int line, int column |
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

  override PrintAstNode getChild(int childIndex) {
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
 * A node representing the parameters of a `Parameterizable`.
 * Only rendered if there's at least one parameter and if the
 * `Parameterizable` is not compiler generated or is of type
 * `Accessor`.
 */
final class ParametersNode extends PrintAstNode, TParametersNode {
  Parameterizable parameterizable;

  ParametersNode() {
    this = TParametersNode(parameterizable) and
    parameterizable.getNumberOfParameters() > 0 and
    not isInConstructedGenericParameterizable(parameterizable) and
    (
      not parameterizable.isCompilerGenerated() or
      parameterizable instanceof Accessor
    )
  }

  override string toString() { result = "(Parameters)" }

  override Location getLocation() { none() }

  override ParameterNode getChild(int childIndex) {
    result.getAst() = parameterizable.getParameter(childIndex)
  }

  /**
   * Returns the underlying `Parameterizable`
   */
  Parameterizable getParameterizable() { result = parameterizable }
}

/**
 * A node representing the attributes of an `Attributable`.
 * Only rendered if there's at least one attribute.
 */
final class AttributesNode extends PrintAstNode, TAttributesNode {
  Attributable attributable;

  AttributesNode() {
    this = TAttributesNode(attributable) and
    count(attributable.getAnAttribute()) > 0 and
    not isCompilerGeneratedAttributable(attributable) and
    not isInConstructedGenericAttributable(attributable)
  }

  override string toString() { result = "(Attributes)" }

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

  /**
   * Returns the underlying `Attributable`
   */
  Attributable getAttributable() { result = attributable }
}

/**
 * A node representing the type parameters of an `UnboundGeneric`.
 */
final class TypeParametersNode extends PrintAstNode, TTypeParametersNode {
  UnboundGeneric unboundGeneric;

  TypeParametersNode() {
    this = TTypeParametersNode(unboundGeneric) and
    unboundGeneric.getNumberOfTypeParameters() > 0 and
    not isInConstructedGenericUnboundGeneric(unboundGeneric)
  }

  override string toString() { result = "(TypeParameters)" }

  override Location getLocation() { none() }

  override TypeParameterNode getChild(int childIndex) {
    result.getAst() = unboundGeneric.getTypeParameter(childIndex)
  }

  /**
   * Returns the underlying `UnboundGeneric`
   */
  UnboundGeneric getUnboundGeneric() { result = unboundGeneric }
}

/** Holds if `node` belongs to the output tree, and its property `key` has the given `value`. */
query predicate nodes(PrintAstNode node, string key, string value) { value = node.getProperty(key) }

/**
 * Holds if `target` is a child of `source` in the AST, and property `key` of the edge has the
 * given `value`.
 */
query predicate edges(PrintAstNode source, PrintAstNode target, string key, string value) {
  exists(int childIndex |
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
