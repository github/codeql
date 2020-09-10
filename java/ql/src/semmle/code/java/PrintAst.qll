/**
 * Provides queries to pretty-print a Java AST as a graph.
 *
 * By default, this will print the AST for all elements in the database. To change this behavior,
 * extend `PrintAstConfiguration` and override `shouldPrint` to hold for only the elements
 * you wish to view the AST for.
 */

import java

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

private class ExprOrStmt extends Element {
  ExprOrStmt() { this instanceof Expr or this instanceof Stmt }

  ExprOrStmt getParent() {
    result = this.(Expr).getParent()
    or
    result = this.(Stmt).getParent()
  }

  Callable getEnclosingCallable() {
    result = this.(Expr).getEnclosingCallable()
    or
    result = this.(Stmt).getEnclosingCallable()
  }
}

/** Holds if the given element does not need to be rendered in the AST, due to being  compiler-generated. */
private predicate isNotNeeded(Element el) {
  exists(InitializerMethod im |
    el = im
    or
    exists(ExprOrStmt e | e = el |
      e.getEnclosingCallable() = im and
      not e.getParent*() = any(Field f).getInitializer() and
      not isInitBlock(im.getDeclaringType(), e.getParent*())
    )
  )
}

/**
 * Retrieves the canonical QL class(es) for entity `el`
 */
private string getQlClass(Element el) {
  result = "[" + concat(el.getAPrimaryQlClass(), ",") + "] "
  // Alternative implementation -- do not delete. It is useful for QL class discovery.
  // result = "[" + concat(el.getAQlClass(), ",") + "] "
}

private predicate locationSortKeys(Element ast, string file, int line, int column) {
  exists(Location loc |
    loc = ast.getLocation() and
    file = loc.getFile().toString() and
    line = loc.getStartLine() and
    column = loc.getStartColumn()
  )
  or
  not exists(ast.getLocation()) and
  file = "" and
  line = 0 and
  column = 0
}

/**
 * Printed AST nodes are mostly `Element`s of the underlying AST.
 */
private newtype TPrintAstNode =
  TElementNode(Element el) { shouldPrint(el, _) } or
  TAnnotationsNode(Annotatable ann) { shouldPrint(ann, _) and ann.hasAnnotation() } or
  TParametersNode(Callable c) { shouldPrint(c, _) and not c.hasNoParameters() } or
  TBaseTypesNode(ClassOrInterface ty) { shouldPrint(ty, _) } or
  TGenericTypeNode(GenericType ty) { shouldPrint(ty, _) } or 
  TGenericCallableNode(GenericCallable c) { shouldPrint(c, _) }

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
  final PrintAstNode getAChild() { result = getChild(_) }

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

  ElementNode() { this = TElementNode(element) and not isNotNeeded(element) }

  override string toString() { result = getQlClass(element) + element.toString() }

  override Location getLocation() { result = element.getLocation() }

  /**
   * Gets the `Element` represented by this node.
   */
  final Element getElement() { result = element }
}

/**
 * An node representing an `Expr` or a `Stmt`.
 */
final class ExprStmtNode extends ElementNode {
  ExprStmtNode() { element instanceof ExprOrStmt }

  override PrintAstNode getChild(int childIndex) {
    exists(Element el | result.(ElementNode).getElement() = el |
      el.(Expr).isNthChildOf(element, childIndex)
      or
      el.(Stmt).isNthChildOf(element, childIndex)
      or
      childIndex = -4 and
      el = element.(ClassInstanceExpr).getAnonymousClass()
      or
      childIndex = 0 and
      el = element.(LocalClassDeclStmt).getLocalClass()
    )
    or
    childIndex = -2 and
    result.(AnnotationsNode).getAnnotated() = element.(LocalVariableDeclExpr).getVariable()
  }
}

/**
 * A node representing a `Callable`, such as method declaration.
 */
final class CallableNode extends ElementNode {
  Callable callable;

  CallableNode() { callable = element }

  override PrintAstNode getChild(int childIndex) {
    // TODO: javadoc
    childIndex = 0 and
    result.(AnnotationsNode).getAnnotated() = callable
    or
    childIndex = 1 and
    result.(GenericCallableNode).getCallable() = callable
    or
    childIndex = 2 and
    result.(ElementNode).getElement().(Expr).isNthChildOf(callable, -1) // return type
    or
    childIndex = 3 and
    result.(ParametersNode).getCallable() = callable
    or
    childIndex = 4 and
    result.(ElementNode).getElement() = callable.getBody()
  }
}

/**
 * A node representing a `Parameter` of a `Callable`.
 */
final class ParameterNode extends ElementNode {
  Parameter p;

  ParameterNode() { p = element }

  override PrintAstNode getChild(int childIndex) {
    childIndex = -1 and
    result.(AnnotationsNode).getAnnotated() = p
    or
    childIndex = 0 and
    result.(ElementNode).getElement().(Expr).getParent() = p
  }
}

private predicate isInitBlock(Class c, Block b) {
  exists(InitializerMethod m | b.getParent() = m.getBody() and m.getDeclaringType() = c)
}

/**
 * A node representing a `Class` or an `Interface`.
 */
final class ClassInterfaceNode extends ElementNode {
  ClassOrInterface ty;

  ClassInterfaceNode() { ty = element }

  private Element getADeclaration() {
    result.(Callable).getDeclaringType() = ty
    or
    result.(FieldDeclaration).getAField().getDeclaringType() = ty
    or
    result.(NestedType).getEnclosingType().getSourceDeclaration() = ty and
    not result instanceof AnonymousClass and
    not result instanceof LocalClass
    or
    isInitBlock(ty, result)
  }

  override PrintAstNode getChild(int childIndex) {
    // TODO: javadoc
    childIndex = -3 and
    result.(AnnotationsNode).getAnnotated() = ty
    or
    childIndex = -2 and
    result.(GenericTypeNode).getType() = ty
    or
    childIndex = -1 and
    result.(BaseTypesNode).getClassOrInterface() = ty
    or
    childIndex >= 0 and
    result.(ElementNode).getElement() =
      rank[childIndex](Element e, string file, int line, int column |
        e = getADeclaration() and locationSortKeys(e, file, line, column)
      |
        e order by file, line, column
      )
  }
}

/**
 * A node representing a `FieldDeclaration`.
 */
final class FieldDeclNode extends ElementNode {
  FieldDeclaration decl;

  FieldDeclNode() { decl = element }

  override PrintAstNode getChild(int childIndex) {
    childIndex = -2 and
    result.(AnnotationsNode).getAnnotated() = decl.getAField()
    or
    childIndex = -1 and
    result.(ElementNode).getElement() = decl.getTypeAccess()
    or
    childIndex >= 0 and
    result.(ElementNode).getElement() = decl.getField(childIndex).getInitializer()
  }
}

/**
 * A node representing a `CompilationUnit`.
 */
final class CompilationUnitNode extends ElementNode {
  CompilationUnit cu;

  CompilationUnitNode() { cu = element }

  private Element getADeclaration() {
    cu.hasChildElement(result)
    or
    result.(Import).getCompilationUnit() = cu
  }

  override PrintAstNode getChild(int childIndex) {
    result.(ElementNode).getElement() =
      rank[childIndex](Element e, string file, int line, int column |
        e = getADeclaration() and locationSortKeys(e, file, line, column)
      |
        e order by file, line, column
      )
  }
}

/**
 * A node representing an `Import`.
 */
final class ImportNode extends ElementNode {
  ImportNode() { element instanceof Import }
}

/** 
 * A node representing a `TypeVariable`.
 */
final class TypeVariableNode extends ElementNode {
  TypeVariableNode() { element instanceof TypeVariable }

  override ElementNode getChild(int childIndex) {
    result.getElement().(Expr).isNthChildOf(element, childIndex)
  }
}

/**
 * A node representing the annotations of an `Annotatable`.
 * Only rendered if there is at least one annotation.
 */
final class AnnotationsNode extends PrintAstNode, TAnnotationsNode {
  Annotatable ann;

  AnnotationsNode() { this = TAnnotationsNode(ann) }

  override string toString() { result = "(Annotations)" }

  override Location getLocation() { result = ann.getLocation() }

  override ElementNode getChild(int childIndex) {
    result.getElement() =
      rank[childIndex](Element e, string file, int line, int column |
        e = ann.getAnAnnotation() and locationSortKeys(e, file, line, column)
      |
        e order by file, line, column
      )
  }

  /**
   * Gets the underlying `Annotatable`.
   */
  Annotatable getAnnotated() { result = ann }
}

/**
 * A node representing the parameters of a `Callable`.
 * Only rendered if there is at least one parameter.
 */
final class ParametersNode extends PrintAstNode, TParametersNode {
  Callable c;

  ParametersNode() { this = TParametersNode(c) }

  override string toString() { result = "(Parameters)" }

  override Location getLocation() { result = c.getLocation() }

  override ElementNode getChild(int childIndex) { result.getElement() = c.getParameter(childIndex) }

  /**
   * Gets the underlying `Callable`.
   */
  Callable getCallable() { result = c }
}

/**
 * A node representing the base types of a `Class` or `Interface` that it extends or implements.
 * Only redered if there is at least one such type.
 */
final class BaseTypesNode extends PrintAstNode, TBaseTypesNode {
  ClassOrInterface ty;

  BaseTypesNode() { this = TBaseTypesNode(ty) and exists(TypeAccess ta | ta.getParent() = ty) }

  override string toString() { result = "(Base Types)" }

  override ElementNode getChild(int childIndex) {
    result.getElement().(TypeAccess).isNthChildOf(ty, -2 - childIndex)
  }

  ClassOrInterface getClassOrInterface() { result = ty }
}

/**
 * A node representing the type parameters of a `Class` or `Interface`.
 * Only rendered when the type in question is indeed generic.
 */
final class GenericTypeNode extends PrintAstNode, TGenericTypeNode {
  GenericType ty;

  GenericTypeNode() { this = TGenericTypeNode(ty) }

  override string toString() { result = "(Generic Parameters)" }

  override ElementNode getChild(int childIndex) {
    result.getElement().(TypeVariable) = ty.getTypeParameter(childIndex)
  }

  GenericType getType() { result = ty }
}

/**
 * A node representing the type parameters of a `Callable`.
 * Only rendered when the callable in question is indeed generic.
 */
final class GenericCallableNode extends PrintAstNode, TGenericCallableNode {
  GenericCallable c;

  GenericCallableNode() { this = TGenericCallableNode(c) }

  override string toString() { result = "(Generic Parameters)" }

  override ElementNode getChild(int childIndex) {
    result.getElement().(TypeVariable) = c.getTypeParameter(childIndex)
  }

  GenericCallable getCallable() { result = c }
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
