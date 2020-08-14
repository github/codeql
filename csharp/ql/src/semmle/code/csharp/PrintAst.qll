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
   * By default it checks which file the `elem` belongs to.
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

private predicate isInsideUnneededAttributable(Attributable attributable) {
  isInsideUnneededType(attributable.(Field).getDeclaringType()) or
  isInsideUnneededParameterizable(attributable.(Parameter).getDeclaringElement()) or
  isInsideUnneededCallable(attributable.(Callable)) or
  isInsideUnneededType(attributable.(DeclarationWithAccessors).getDeclaringType()) or
  isInsideUnneededType(attributable.(ValueOrRefType))
}

private predicate isInsideUnneededUnboundGeneric(UnboundGeneric unboundGeneric) {
  isInsideUnneededAttributable(unboundGeneric) or
  isInsideUnneededParameterizable(unboundGeneric)
}

private predicate isInsideUnneededCallable(Callable callable) {
  callable instanceof ConstructedGeneric or
  isInsideUnneededType(callable.getDeclaringType())
}

private predicate isInsideUnneededType(Type type) {
  type instanceof ConstructedType or
  type.getDeclaringType*() instanceof ConstructedType or
  type instanceof AnonymousClass or
  type.getDeclaringType*() instanceof AnonymousClass
}

private predicate isInsideUnneededParameterizable(Parameterizable parameterizable) {
  isInsideUnneededCallable(parameterizable) or
  isInsideUnneededType(parameterizable.(Indexer).getDeclaringType()) or
  isInsideUnneededType(parameterizable.(DelegateType))
}

private predicate isCompilerGeneratedParameterizable(Parameterizable parameterizable) {
  parameterizable.isCompilerGenerated() or
  parameterizable.getDeclaringType*().isCompilerGenerated()
}

private predicate isCompilerGeneratedAttributable(Attributable attributable) {
  // Default parameter values on delegates are in the tree multiple times
  // due to the compiler generated `Invoke`.
  isCompilerGeneratedParameterizable(attributable.(Parameter).getDeclaringElement())
}

/**
 * Retrieves the canonical QL class(es) for entity `el`
 */
private string getQlClass(Element el) {
  result = "[" + concat(el.getAPrimaryQlClass(), ",") + "] "
  // Alternative implementation -- do not delete. It is useful for QL class discovery.
  // result = "["+ concat(el.getAQlClass(), ",") + "] "
}

/**
 * An `Element`, such as a `namespace` and a `partial class`, might have multiple locations.
 * The locations are ordered by line, column, and then the first one is selected.
 */
private Location getRepresentativeLocation(Element ast) {
  result =
    min(Location loc |
      loc = ast.getLocation() and selectedFile(loc.getFile())
    |
      loc order by loc.getStartLine(), loc.getStartColumn(), loc.getEndLine(), loc.getEndColumn()
    )
}

private predicate locationSortKeys(Element ast, string file, int line, int column) {
  exists(Location loc |
    loc = getRepresentativeLocation(ast) and
    file = loc.getFile().toString() and
    line = loc.getStartLine() and
    column = loc.getStartColumn()
  )
  or
  not exists(getRepresentativeLocation(ast)) and
  file = "" and
  line = 0 and
  column = 0
}

/**
 * Printed AST nodes are mostly `Element`s of the underlying AST.
 * There are extra AST nodes generated for parameters of `Parameterizable`s,
 * attributes of `Attributable`s, and type parameters of `UnboundGeneric`
 * declarations. These extra nodes are used as containers to organize the
 * tree a bit better.
 */
private newtype TPrintAstNode =
  TElementNode(Element element) { shouldPrint(element) } or
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
   * Gets a child of this node.
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
abstract class ElementNode extends PrintAstNode, TElementNode {
  Element element;

  ElementNode() { this = TElementNode(element) }

  override string toString() { result = getQlClass(element) + element.toString() }

  override Location getLocation() { result = getRepresentativeLocation(element) }

  /**
   * Gets the `Element` represented by this node.
   */
  final Element getElement() { result = element }
}

/**
 * A node representing a `ControlFlowElement` (`Expr` or `Stmt`).
 */
class ControlFlowElementNode extends ElementNode {
  ControlFlowElement controlFlowElement;

  ControlFlowElementNode() {
    controlFlowElement = element and
    // Removing extra nodes that are generated for an `AssignOperation`
    not exists(AssignOperation ao |
      ao.hasExpandedAssignment() and
      (
        ao.getExpandedAssignment() = controlFlowElement or
        ao.getExpandedAssignment().getRValue() = controlFlowElement or
        ao.getExpandedAssignment().getRValue().(BinaryOperation).getLeftOperand() =
          controlFlowElement.getParent*() or
        ao.getExpandedAssignment().getRValue().(OperatorCall).getChild(0) =
          controlFlowElement.getParent*()
      )
    ) and
    not isCompilerGeneratedAttributable(element.getParent+().(Attribute).getTarget()) and
    not isCompilerGeneratedParameterizable(element.getParent+().(Parameter).getDeclaringElement()) and
    not isInsideUnneededAttributable(element.getParent+().(Attribute).getTarget()) and
    not isInsideUnneededParameterizable(element.getParent+().(Parameter).getDeclaringElement())
  }

  override ElementNode getChild(int childIndex) {
    result.getElement() = controlFlowElement.getChild(childIndex)
  }
}

/**
 * A node representing a `LocalFunctionStmt`.
 * Each `LocalFunction` is displayed below its corresponding `LocalFunctionStmt`.
 */
final class LocalFunctionStmtNode extends ControlFlowElementNode {
  LocalFunctionStmt stmt;

  LocalFunctionStmtNode() { stmt = element }

  override CallableNode getChild(int childIndex) {
    childIndex = 0 and
    result.getElement() = stmt.getLocalFunction()
  }
}

/**
 * A node representing a `Callable`, such as method declaration.
 */
final class CallableNode extends ElementNode {
  Callable callable;

  CallableNode() {
    callable = element and
    not isInsideUnneededCallable(callable)
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
    result.(ElementNode).getElement() = callable.(Constructor).getInitializer()
    or
    childIndex = 4 and
    result.(ElementNode).getElement() = callable.getBody()
  }
}

/**
 * A node representing a `DeclarationWithAccessors`, such as property declaration.
 */
final class DeclarationWithAccessorsNode extends ElementNode {
  DeclarationWithAccessors declaration;

  DeclarationWithAccessorsNode() {
    declaration = element and
    not isInsideUnneededType(declaration.getDeclaringType())
  }

  override PrintAstNode getChild(int childIndex) {
    childIndex = 0 and
    result.(AttributesNode).getAttributable() = declaration
    or
    childIndex = 1 and
    result.(ParametersNode).getParameterizable() = declaration
    or
    childIndex = 2 and
    result.(ElementNode).getElement() = declaration.(Property).getInitializer().getParent()
    or
    result.(ElementNode).getElement() =
      rank[childIndex - 2](Element a, string file, int line, int column |
        a = declaration.getAnAccessor() and
        locationSortKeys(a, file, line, column)
      |
        a order by file, line, column
      )
  }
}

/**
 * A node representing a `Field` declaration.
 */
final class FieldNode extends ElementNode {
  Field field;

  FieldNode() {
    field = element and
    not field.getDeclaringType() instanceof TupleType and
    not isInsideUnneededType(field.getDeclaringType())
  }

  override PrintAstNode getChild(int childIndex) {
    childIndex = 0 and
    result.(AttributesNode).getAttributable() = field
    or
    childIndex = 1 and
    field.hasInitializer() and
    (
      if field.getDeclaringType() instanceof Enum
      then result.(ElementNode).getElement() = field.getInitializer()
      else result.(ElementNode).getElement() = field.getInitializer().getParent()
    )
  }
}

/**
 * A node representing a `Parameter` declaration.
 */
final class ParameterNode extends ElementNode {
  Parameter param;

  ParameterNode() {
    param = element and
    not isInsideUnneededParameterizable(param.getDeclaringElement()) and
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
      min(Location loc |
        loc = element.getLocation() and
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
    result.(ElementNode).getElement() = param.getDefaultValue()
  }
}

/**
 * A node representing an `Attribute`.
 */
final class AttributeNode extends ElementNode {
  Attribute attr;

  AttributeNode() {
    attr = element and
    not isCompilerGeneratedAttributable(attr.getTarget()) and
    not isInsideUnneededAttributable(attr.getTarget())
  }

  override ElementNode getChild(int childIndex) { result.getElement() = attr.getChild(childIndex) }
}

/**
 * A node representing a `TypeParameter`.
 */
final class TypeParameterNode extends ElementNode {
  TypeParameter typeParameter;

  TypeParameterNode() {
    typeParameter = element and
    not isInsideUnneededUnboundGeneric(typeParameter.getDeclaringGeneric())
  }

  override ElementNode getChild(int childIndex) { none() }
}

/**
 * A node representing a `ValueOrRefType`.
 */
final class TypeNode extends ElementNode {
  ValueOrRefType type;

  TypeNode() {
    type = element and
    not type instanceof TupleType and
    not type instanceof ArrayType and
    not type instanceof NullableType and
    not isInsideUnneededType(type)
  }

  override PrintAstNode getChild(int childIndex) {
    childIndex = 0 and
    result.(AttributesNode).getAttributable() = type
    or
    childIndex = 1 and
    result.(TypeParametersNode).getUnboundGeneric() = type
    or
    childIndex = 2 and
    result.(ParametersNode).getParameterizable() = type
    or
    result.(ElementNode).getElement() =
      rank[childIndex - 2](Member m, string file, int line, int column |
        m = type.getAMember() and
        locationSortKeys(m, file, line, column)
      |
        m order by file, line, column
      )
  }
}

/**
 * A node representing a `NamespaceDeclaration`.
 */
final class NamespaceNode extends ElementNode {
  NamespaceDeclaration namespace;

  NamespaceNode() { namespace = element }

  override PrintAstNode getChild(int childIndex) {
    result.(ElementNode).getElement() =
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
    not isInsideUnneededParameterizable(parameterizable) and
    (
      not parameterizable.isCompilerGenerated() or
      parameterizable instanceof Accessor
    )
  }

  override string toString() { result = "(Parameters)" }

  override Location getLocation() { none() }

  override ParameterNode getChild(int childIndex) {
    result.getElement() = parameterizable.getParameter(childIndex)
  }

  /**
   * Gets the underlying `Parameterizable`
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
    exists(attributable.getAnAttribute()) and
    not isCompilerGeneratedAttributable(attributable) and
    not isInsideUnneededAttributable(attributable)
  }

  override string toString() { result = "(Attributes)" }

  override Location getLocation() { none() }

  override AttributeNode getChild(int childIndex) {
    result.getElement() =
      rank[childIndex](Attribute a, string file, int line, int column |
        a = attributable.getAnAttribute() and
        locationSortKeys(a, file, line, column)
      |
        a order by file, line, column
      )
  }

  /**
   * Gets the underlying `Attributable`
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
    not isInsideUnneededUnboundGeneric(unboundGeneric)
  }

  override string toString() { result = "(TypeParameters)" }

  override Location getLocation() { none() }

  override TypeParameterNode getChild(int childIndex) {
    result.getElement() = unboundGeneric.getTypeParameter(childIndex)
  }

  /**
   * Gets the underlying `UnboundGeneric`
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
