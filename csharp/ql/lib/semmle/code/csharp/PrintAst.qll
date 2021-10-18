/**
 * Provides queries to pretty-print a C# AST as a graph.
 *
 * By default, this will print the AST for all elements in the database. To change this behavior,
 * extend `PrintAstConfiguration` and override `shouldPrint` to hold for only the elements
 * you wish to view the AST for.
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
   * Controls whether the `Element` should be considered for AST printing.
   * By default it checks whether the `Element` `e` belongs to `Location` `l`.
   */
  predicate shouldPrint(Element e, Location l) { e.fromSource() and l = e.getLocation() }
}

private predicate shouldPrint(Element e, Location l) {
  exists(PrintAstConfiguration config | config.shouldPrint(e, l))
}

private predicate isImplicitExpression(ControlFlowElement element) {
  element.(Expr).isImplicit() and not exists(element.getAChild())
}

private predicate isFilteredCompilerGenerated(Declaration d) {
  d.isCompilerGenerated() and
  not d instanceof Accessor
}

private predicate isNotNeeded(Element e) {
  isFilteredCompilerGenerated(e)
  or
  e instanceof ConstructedGeneric
  or
  e instanceof AnonymousClass
  or
  e instanceof TupleType
  or
  e instanceof ConditionalDirective
  or
  isNotNeeded(e.(Declaration).getDeclaringType())
  or
  isNotNeeded(e.(Parameter).getDeclaringElement())
  or
  isNotNeeded(e.(Attribute).getTarget())
}

/**
 * Retrieves the canonical QL class(es) for entity `el`
 */
private string getQlClass(Element el) {
  result = "[" + el.getPrimaryQlClasses() + "] "
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
      shouldPrint(ast, loc)
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

private predicate hasInterestingBaseTypes(ValueOrRefType type) {
  exists(getAnInterestingBaseType(type))
}

private ValueOrRefType getAnInterestingBaseType(ValueOrRefType type) {
  not type instanceof TupleType and
  not type instanceof ArrayType and
  not type instanceof NullableType and
  result = type.getABaseType() and
  isInterestingBaseType(type, result)
}

private predicate isInterestingBaseType(ValueOrRefType type, ValueOrRefType base) {
  not base instanceof ObjectType and
  not base.getQualifiedName() = "System.ValueType" and
  not base.getQualifiedName() = "System.Delegate" and
  not base.getQualifiedName() = "System.MulticastDelegate" and
  not base.getQualifiedName() = "System.Enum" and
  exists(TypeMention tm | tm.getTarget() = type and tm.getType() = base)
}

/**
 * Printed AST nodes are mostly `Element`s of the underlying AST.
 * There are extra AST nodes generated for parameters of `Parameterizable`s,
 * attributes of `Attributable`s, type parameters of `UnboundGeneric` and
 * base types of `ValueOrRefType` declarations. These extra nodes are used
 * as containers to organize the tree a bit better.
 */
private newtype TPrintAstNode =
  TElementNode(Element element) { shouldPrint(element, _) } or
  TTypeMentionNode(TypeMention typeMention) {
    exists(Element target |
      target = typeMention.getParent*().getTarget() and
      shouldPrint(target, _) and
      not isNotNeeded(target.getParent*()) and
      not target.getParent*() instanceof TypeParameter
    )
  } or
  TParametersNode(Parameterizable parameterizable) {
    shouldPrint(parameterizable, _) and
    parameterizable.getNumberOfParameters() > 0 and
    not isNotNeeded(parameterizable) and
    exists(Parameter p | p.getDeclaringElement() = parameterizable and shouldPrint(p, _))
  } or
  TAttributesNode(Attributable attributable) {
    shouldPrint(attributable, _) and
    exists(Attribute a | a = attributable.getAnAttribute() | shouldPrint(a, _)) and
    not isNotNeeded(attributable)
  } or
  TTypeParametersNode(UnboundGeneric unboundGeneric) {
    shouldPrint(unboundGeneric, _) and
    unboundGeneric.getNumberOfTypeParameters() > 0 and
    not isNotNeeded(unboundGeneric)
  } or
  TBaseTypesNode(ValueOrRefType type) {
    shouldPrint(type, _) and
    hasInterestingBaseTypes(type) and
    not isNotNeeded(type)
  }

/**
 * A node in the output tree.
 */
class PrintAstNode extends TPrintAstNode {
  /**
   * Gets a textual representation of this node in the PrintAst output tree.
   */
  string toString() { none() }

  /**
   * Gets the child node at index `childIndex`. Child indices must be unique,
   * but need not be contiguous.
   */
  PrintAstNode getChild(int childIndex) { none() }

  /**
   * Gets a child of this node.
   */
  final PrintAstNode getAChild() { result = this.getChild(_) }

  /**
   * Gets the parent of this node, if any.
   */
  final PrintAstNode getParent() { result.getAChild() = this }

  /**
   * Gets the location of this node in the source code.
   */
  Location getLocation() { none() }

  /**
   * Gets the value of the property of this node, where the name of the property
   * is `key`.
   */
  string getProperty(string key) {
    key = "semmle.label" and
    result = this.toString()
  }

  /**
   * Gets the label for the edge from this node to the specified child. By
   * default, this is just the index of the child, but subclasses can override
   * this.
   */
  string getChildEdgeLabel(int childIndex) {
    exists(this.getChild(childIndex)) and
    result = childIndex.toString()
  }
}

/** A top-level AST node. */
class TopLevelPrintAstNode extends PrintAstNode {
  TopLevelPrintAstNode() { not exists(this.getParent()) }

  private int getOrder() {
    this =
      rank[result](TopLevelPrintAstNode n, Location l |
        l = n.getLocation()
      |
        n
        order by
          l.getFile().getRelativePath(), l.getStartLine(), l.getStartColumn(), l.getEndLine(),
          l.getEndColumn()
      )
  }

  override string getProperty(string key) {
    result = super.getProperty(key)
    or
    key = "semmle.order" and
    result = this.getOrder().toString()
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
 * A node representing an AST node with an underlying `TypeMention`.
 */
class TypeMentionNode extends PrintAstNode, TTypeMentionNode {
  TypeMention typeMention;

  TypeMentionNode() { this = TTypeMentionNode(typeMention) }

  override string toString() {
    result = "[TypeMention] " + typeMention.getType().toStringWithTypes()
  }

  override Location getLocation() { result = typeMention.getLocation() }

  /**
   * Gets the `TypeMention` represented by this node.
   */
  final TypeMention getTypeMention() { result = typeMention }

  /**
   * Gets the `Element` targetted by the `TypeMention`.
   */
  final Element getTarget() { result = typeMention.getTarget() }

  override TypeMentionNode getChild(int childIndex) {
    result.getTypeMention() =
      rank[childIndex](TypeMention t, Location l |
        t.getParent() = typeMention and
        l = t.getLocation()
      |
        t order by l.getFile().toString(), l.getStartLine(), l.getStartColumn()
      )
  }
}

/**
 * A node representing a `ControlFlowElement` (`Expr` or `Stmt`).
 */
class ControlFlowElementNode extends ElementNode {
  ControlFlowElement controlFlowElement;

  ControlFlowElementNode() {
    controlFlowElement = element and
    // Removing implicit expressions
    not isImplicitExpression(element) and
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
    not isNotNeeded(element.getParent+()) and
    // LambdaExpr is both a Callable and a ControlFlowElement,
    // print it with the more specific CallableNode
    not element instanceof Callable
  }

  override PrintAstNode getChild(int childIndex) {
    (
      childIndex = min(int i | exists(controlFlowElement.getChild(i))) - 1
      or
      not exists(controlFlowElement.getAChild()) and childIndex = 0
    ) and
    result.(TypeMentionNode).getTarget() = controlFlowElement
    or
    result.(ElementNode).getElement() = controlFlowElement.getChild(childIndex)
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
 * A node representing an `Assignment`.
 * Left and right children are shown in this order.
 */
final class AssignmentNode extends ControlFlowElementNode {
  Assignment assignment;

  AssignmentNode() { assignment = element }

  override PrintAstNode getChild(int childIndex) {
    childIndex = -1 and
    result.(TypeMentionNode).getTarget() = controlFlowElement
    or
    childIndex = 0 and
    result.(ElementNode).getElement() = assignment.getLValue()
    or
    childIndex = 1 and
    result.(ElementNode).getElement() = assignment.getRValue()
  }
}

/**
 * A node representing a `CastExpr`.
 * Type access and casted expression children are shown in this order.
 */
final class CastExprNode extends ControlFlowElementNode {
  CastExpr cast;

  CastExprNode() { cast = element }

  override ElementNode getChild(int childIndex) {
    childIndex = 0 and
    result.getElement() = cast.getTypeAccess()
    or
    childIndex = 1 and
    result.getElement() = cast.getExpr()
  }
}

/**
 * A node representing a `Callable`, such as method declaration.
 */
final class CallableNode extends ElementNode {
  Callable callable;

  CallableNode() {
    callable = element and
    not isNotNeeded(callable)
  }

  override PrintAstNode getChild(int childIndex) {
    childIndex = -1 and
    result.(TypeMentionNode).getTarget() = callable
    or
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
    not isNotNeeded(declaration.getDeclaringType())
  }

  override PrintAstNode getChild(int childIndex) {
    childIndex = -1 and
    result.(TypeMentionNode).getTarget() = declaration
    or
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
      rank[childIndex - 2](Element a, string file, int line, int column, string name |
        a = declaration.getAnAccessor() and
        locationSortKeys(a, file, line, column) and
        name = a.toString()
      |
        a order by file, line, column, name
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
    not isNotNeeded(field.getDeclaringType())
  }

  override PrintAstNode getChild(int childIndex) {
    childIndex = -1 and
    result.(TypeMentionNode).getTarget() = field
    or
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
    not isNotNeeded(param.getDeclaringElement())
  }

  override Location getLocation() {
    not param.hasExtensionMethodModifier() and result = super.getLocation()
    or
    // for extension method first parameters, we're choosing the shorter location of the two
    param.hasExtensionMethodModifier() and
    result =
      min(Location loc |
        shouldPrint(param, loc) and
        loc.getStartLine() = loc.getEndLine()
      |
        loc order by loc.getEndColumn() - loc.getStartColumn()
      )
  }

  override PrintAstNode getChild(int childIndex) {
    childIndex = -1 and
    result.(TypeMentionNode).getTarget() = param
    or
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
    not isNotNeeded(attr.getTarget())
  }

  override PrintAstNode getChild(int childIndex) {
    (
      childIndex = min(int i | exists(attr.getChild(i))) - 1
      or
      not exists(attr.getAChild()) and childIndex = 0
    ) and
    result.(TypeMentionNode).getTarget() = attr
    or
    result.(ElementNode).getElement() = attr.getChild(childIndex)
  }
}

/**
 * A node representing a `TypeParameter`.
 */
final class TypeParameterNode extends ElementNode {
  TypeParameter typeParameter;

  TypeParameterNode() {
    typeParameter = element and
    not isNotNeeded(typeParameter.getDeclaringGeneric())
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
    not isNotNeeded(type)
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
    childIndex = 3 and
    result.(BaseTypesNode).getValueOrRefType() = type
    or
    result.(ElementNode).getElement() =
      rank[childIndex - 3](Member m, string file, int line, int column, string name |
        m = type.getAMember() and
        name = m.getName() and
        locationSortKeys(m, file, line, column)
      |
        m order by file, line, column, name
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

  ParametersNode() { this = TParametersNode(parameterizable) }

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

  AttributesNode() { this = TAttributesNode(attributable) }

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

  TypeParametersNode() { this = TTypeParametersNode(unboundGeneric) }

  override string toString() { result = "(Type parameters)" }

  override Location getLocation() { none() }

  override TypeParameterNode getChild(int childIndex) {
    result.getElement() = unboundGeneric.getTypeParameter(childIndex)
  }

  /**
   * Gets the underlying `UnboundGeneric`
   */
  UnboundGeneric getUnboundGeneric() { result = unboundGeneric }
}

/**
 * A node representing the base types of a `ValueOrRefType`.
 */
final class BaseTypesNode extends PrintAstNode, TBaseTypesNode {
  ValueOrRefType valueOrRefType;

  BaseTypesNode() { this = TBaseTypesNode(valueOrRefType) }

  override string toString() { result = "(Base types)" }

  override Location getLocation() { none() }

  override TypeMentionNode getChild(int childIndex) {
    childIndex = 0 and
    result.getTypeMention().getType() = valueOrRefType.getBaseClass() and
    result.getTarget() = valueOrRefType
    or
    result.getTypeMention() =
      rank[childIndex](TypeMention t, Location l |
        t.getType() = valueOrRefType.getABaseInterface() and
        t.getTarget() = valueOrRefType and
        l = t.getLocation()
      |
        t order by l.getFile().toString(), l.getStartLine(), l.getStartColumn()
      )
  }

  /**
   * Gets the underlying `ValueOrRefType`
   */
  ValueOrRefType getValueOrRefType() { result = valueOrRefType }
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
