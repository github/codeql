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

/** Holds if the given element does not need to be rendered in the AST, due to being compiler-generated. */
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
  or
  exists(Constructor c | c.isDefaultConstructor() |
    el = c
    or
    el.(ExprOrStmt).getEnclosingCallable() = c
  )
  or
  exists(Constructor c, int sline, int eline, int scol, int ecol |
    el.(ExprOrStmt).getEnclosingCallable() = c
  |
    el.getLocation().hasLocationInfo(_, sline, eline, scol, ecol) and
    c.getLocation().hasLocationInfo(_, sline, eline, scol, ecol)
    // simply comparing their getLocation() doesn't work as they have distinct but equivalent locations
  )
  or
  isNotNeeded(el.(Expr).getParent*().(Annotation).getAnnotatedElement())
  or
  isNotNeeded(el.(Parameter).getCallable())
}

/** Holds if the given field would have the same javadoc and annotations as another field declared in the same declaration */
private predicate duplicateMetadata(Field f) {
  exists(FieldDeclaration fd |
    f = fd.getAField() and
    not f = fd.getField(0)
  )
}

/**
 * Retrieves the canonical QL class(es) for entity `el`
 */
private string getQlClass(Top el) {
  result = "[" + el.getPrimaryQlClasses() + "] "
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
  TForInitNode(ForStmt fs) { shouldPrint(fs, _) and exists(fs.getAnInit()) } or
  TLocalVarDeclNode(LocalVariableDeclExpr lvde) {
    shouldPrint(lvde, _) and lvde.getParent() instanceof SingleLocalVarDeclParent
  } or
  TAnnotationsNode(Annotatable ann) {
    shouldPrint(ann, _) and ann.hasAnnotation() and not partOfAnnotation(ann)
  } or
  TParametersNode(Callable c) { shouldPrint(c, _) and not c.hasNoParameters() } or
  TBaseTypesNode(ClassOrInterface ty) { shouldPrint(ty, _) } or
  TGenericTypeNode(GenericType ty) { shouldPrint(ty, _) } or
  TGenericCallableNode(GenericCallable c) { shouldPrint(c, _) } or
  TDocumentableNode(Documentable d) { shouldPrint(d, _) and exists(d.getJavadoc()) } or
  TJavadocNode(Javadoc jd) { exists(Documentable d | d.getJavadoc() = jd | shouldPrint(d, _)) } or
  TJavadocElementNode(JavadocElement jd) {
    exists(Documentable d | d.getJavadoc() = jd.getParent*() | shouldPrint(d, _))
  } or
  TImportsNode(CompilationUnit cu) {
    shouldPrint(cu, _) and exists(Import i | i.getCompilationUnit() = cu)
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

  ElementNode() { this = TElementNode(element) and not isNotNeeded(element) }

  override string toString() { result = getQlClass(element) + element.toString() }

  override Location getLocation() { result = element.getLocation() }

  /**
   * Gets the `Element` represented by this node.
   */
  final Element getElement() { result = element }
}

/**
 * A node representing an `Expr` or a `Stmt`.
 */
class ExprStmtNode extends ElementNode {
  ExprStmtNode() { element instanceof ExprOrStmt }

  override PrintAstNode getChild(int childIndex) {
    exists(Element el | result.(ElementNode).getElement() = el |
      el.(Expr).isNthChildOf(element, childIndex)
      or
      el.(Stmt).isNthChildOf(element, childIndex)
    )
  }
}

/**
 * Holds if the given expression is part of an annotation.
 */
private predicate partOfAnnotation(Expr e) {
  e instanceof Annotation
  or
  e instanceof ArrayInit and
  partOfAnnotation(e.getParent())
}

/**
 * A node representing an `Expr` that is part of an annotation.
 */
final class AnnotationPartNode extends ExprStmtNode {
  AnnotationPartNode() { partOfAnnotation(element) }

  override ElementNode getChild(int childIndex) {
    result.getElement() =
      rank[childIndex](Element ch, string file, int line, int column |
        ch = this.getAnAnnotationChild() and locationSortKeys(ch, file, line, column)
      |
        ch order by file, line, column
      )
  }

  private Expr getAnAnnotationChild() {
    result = element.(Annotation).getValue(_)
    or
    result = element.(ArrayInit).getAnInit()
    or
    result = element.(ArrayInit).(Annotatable).getAnAnnotation()
  }
}

/**
 * A node representing a `LocalVariableDeclExpr`.
 */
final class LocalVarDeclExprNode extends ExprStmtNode {
  LocalVarDeclExprNode() { element instanceof LocalVariableDeclExpr }

  override PrintAstNode getChild(int childIndex) {
    result = super.getChild(childIndex)
    or
    childIndex = -2 and
    result.(AnnotationsNode).getAnnotated() = element.(LocalVariableDeclExpr).getVariable()
  }
}

/**
 * A node representing a `ClassInstanceExpr`.
 */
final class ClassInstanceExprNode extends ExprStmtNode {
  ClassInstanceExprNode() { element instanceof ClassInstanceExpr }

  override ElementNode getChild(int childIndex) {
    result = super.getChild(childIndex)
    or
    childIndex = -4 and
    result.getElement() = element.(ClassInstanceExpr).getAnonymousClass()
  }
}

/**
 * A node representing a `LocalTypeDeclStmt`.
 */
final class LocalTypeDeclStmtNode extends ExprStmtNode {
  LocalTypeDeclStmtNode() { element instanceof LocalTypeDeclStmt }

  override ElementNode getChild(int childIndex) {
    result = super.getChild(childIndex)
    or
    childIndex = 0 and
    result.getElement() = element.(LocalTypeDeclStmt).getLocalType()
  }
}

/**
 * DEPRECATED: Renamed `LocalTypeDeclStmtNode` to reflect the fact that
 * as of Java 16 interfaces can also be declared locally, not just classes.
 */
deprecated class LocalClassDeclStmtNode = LocalTypeDeclStmtNode;

/**
 * A node representing a `ForStmt`.
 */
final class ForStmtNode extends ExprStmtNode {
  ForStmtNode() { element instanceof ForStmt }

  override PrintAstNode getChild(int childIndex) {
    childIndex >= 1 and
    result = super.getChild(childIndex)
    or
    childIndex = 0 and
    result.(ForInitNode).getForStmt() = element
  }
}

/**
 * An element that can be the parent of up to one `LocalVariableDeclExpr` for which we want
 * to use a synthetic node to hold the variable declaration and its `TypeAccess`.
 */
private class SingleLocalVarDeclParent extends ExprOrStmt {
  SingleLocalVarDeclParent() {
    this instanceof EnhancedForStmt or
    this instanceof CatchClause or
    this.(InstanceOfExpr).isPattern()
  }

  /** Gets the variable declaration that this element contains */
  LocalVariableDeclExpr getVariable() { result.getParent() = this }

  /** Gets the type access of the variable */
  Expr getTypeAccess() { result = this.getVariable().getTypeAccess() }
}

/**
 * A node representing an element that can be the parent of up to one `LocalVariableDeclExpr` for which we
 * want to use a synthetic node to variable declaration and its type access.
 *
 * Excludes `LocalVariableDeclStmt` and `ForStmt`, as they can hold multiple declarations.
 * For these cases, either a synthetic node is not necassary or a different synthetic node is used.
 */
final class SingleLocalVarDeclParentNode extends ExprStmtNode {
  SingleLocalVarDeclParent lvdp;

  SingleLocalVarDeclParentNode() { lvdp = element }

  override PrintAstNode getChild(int childIndex) {
    result = super.getChild(childIndex) and
    not result.(ElementNode).getElement() = [lvdp.getVariable(), lvdp.getTypeAccess()]
    or
    childIndex = lvdp.getVariable().getIndex() and
    result.(LocalVarDeclSynthNode).getVariable() = lvdp.getVariable()
  }
}

/**
 * A node representing a `Callable`, such as method declaration.
 */
final class CallableNode extends ElementNode {
  Callable callable;

  CallableNode() { callable = element }

  override PrintAstNode getChild(int childIndex) {
    childIndex = 0 and
    result.(DocumentableNode).getDocumentable() = callable
    or
    childIndex = 1 and
    result.(AnnotationsNode).getAnnotated() = callable
    or
    childIndex = 2 and
    result.(GenericCallableNode).getCallable() = callable
    or
    childIndex = 3 and
    result.(ElementNode).getElement().(Expr).isNthChildOf(callable, -1) // return type
    or
    childIndex = 4 and
    result.(ParametersNode).getCallable() = callable
    or
    childIndex = 5 and
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
    result.(ElementNode).getElement().(Expr).isNthChildOf(p, -1) // type
  }
}

private predicate isInitBlock(Class c, BlockStmt b) {
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
    result.(MemberType).getEnclosingType().getSourceDeclaration() = ty
    or
    isInitBlock(ty, result)
  }

  override PrintAstNode getChild(int childIndex) {
    childIndex = -4 and
    result.(DocumentableNode).getDocumentable() = ty
    or
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
        e = this.getADeclaration() and locationSortKeys(e, file, line, column)
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
    childIndex = -3 and
    result.(DocumentableNode).getDocumentable() = decl.getField(0)
    or
    childIndex = -2 and
    result.(AnnotationsNode).getAnnotated() = decl.getField(0)
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

  private Element getADeclaration() { cu.hasChildElement(result) }

  override PrintAstNode getChild(int childIndex) {
    childIndex = -1 and
    result.(ImportsNode).getCompilationUnit() = cu
    or
    childIndex >= 0 and
    result.(ElementNode).getElement() =
      rank[childIndex](Element e, string file, int line, int column |
        e = this.getADeclaration() and locationSortKeys(e, file, line, column)
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
 * A node representing the initializers of a `ForStmt`.
 */
final class ForInitNode extends PrintAstNode, TForInitNode {
  ForStmt fs;

  ForInitNode() { this = TForInitNode(fs) }

  override string toString() { result = "(For Initializers) " }

  override ElementNode getChild(int childIndex) {
    childIndex >= 0 and
    result.getElement().(Expr).isNthChildOf(fs, -childIndex)
  }

  /**
   * Gets the underlying `ForStmt`.
   */
  ForStmt getForStmt() { result = fs }
}

/**
 * A synthetic node holding a `LocalVariableDeclExpr` and its type access.
 */
final class LocalVarDeclSynthNode extends PrintAstNode, TLocalVarDeclNode {
  LocalVariableDeclExpr lvde;

  LocalVarDeclSynthNode() { this = TLocalVarDeclNode(lvde) }

  override string toString() { result = "(Single Local Variable Declaration)" }

  override ElementNode getChild(int childIndex) {
    childIndex = 0 and
    result.getElement() = lvde.getTypeAccess()
    or
    childIndex = 1 and
    result.getElement() = lvde
  }

  /**
   * Gets the underlying `LocalVariableDeclExpr`
   */
  LocalVariableDeclExpr getVariable() { result = lvde }
}

/**
 * A node representing the annotations of an `Annotatable`.
 * Only rendered if there is at least one annotation.
 */
final class AnnotationsNode extends PrintAstNode, TAnnotationsNode {
  Annotatable ann;

  AnnotationsNode() {
    this = TAnnotationsNode(ann) and not isNotNeeded(ann) and not duplicateMetadata(ann)
  }

  override string toString() { result = "(Annotations)" }

  override Location getLocation() { none() }

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

  ParametersNode() { this = TParametersNode(c) and not isNotNeeded(c) }

  override string toString() { result = "(Parameters)" }

  override Location getLocation() { none() }

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

  override Location getLocation() { none() }

  override ElementNode getChild(int childIndex) {
    result.getElement().(TypeAccess).isNthChildOf(ty, -2 - childIndex)
  }

  /**
   * Gets the underlying `Class` or `Interface`.
   */
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

  override Location getLocation() { none() }

  override ElementNode getChild(int childIndex) {
    result.getElement() = ty.getTypeParameter(childIndex)
  }

  /**
   * Gets the underlying `GenericType`.
   */
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
    result.getElement() = c.getTypeParameter(childIndex)
  }

  /**
   * Gets the underlying `GenericCallable`.
   */
  GenericCallable getCallable() { result = c }
}

/**
 * A node representing the documentation of a `Documentable`.
 * Only rendered if there is at least one `Javadoc` attatched to it.
 */
final class DocumentableNode extends PrintAstNode, TDocumentableNode {
  Documentable d;

  DocumentableNode() { this = TDocumentableNode(d) and not duplicateMetadata(d) }

  override string toString() { result = "(Javadoc)" }

  override Location getLocation() { none() }

  override JavadocNode getChild(int childIndex) {
    result.getJavadoc() =
      rank[childIndex](Javadoc jd, string file, int line, int column |
        jd.getCommentedElement() = d and jd.getLocation().hasLocationInfo(file, line, column, _, _)
      |
        jd order by file, line, column
      )
  }

  /**
   * Gets the underlying `Documentable`.
   */
  Documentable getDocumentable() { result = d }
}

/**
 * A node representing a `Javadoc`.
 * Only rendered if it is the javadoc of some `Documentable`.
 */
final class JavadocNode extends PrintAstNode, TJavadocNode {
  Javadoc jd;

  JavadocNode() { this = TJavadocNode(jd) }

  override string toString() { result = getQlClass(jd) + jd.toString() }

  override Location getLocation() { result = jd.getLocation() }

  override JavadocElementNode getChild(int childIndex) {
    result.getJavadocElement() = jd.getChild(childIndex)
  }

  /**
   * Gets the `Javadoc` represented by this node.
   */
  Javadoc getJavadoc() { result = jd }
}

/**
 * A node representing a `JavadocElement`.
 * Only rendered if it is part of the javadoc of some `Documentable`.
 */
final class JavadocElementNode extends PrintAstNode, TJavadocElementNode {
  JavadocElement jd;

  JavadocElementNode() { this = TJavadocElementNode(jd) }

  override string toString() { result = getQlClass(jd) + jd.toString() }

  override Location getLocation() { result = jd.getLocation() }

  override JavadocElementNode getChild(int childIndex) {
    result.getJavadocElement() = jd.(JavadocParent).getChild(childIndex)
  }

  /**
   * Gets the `JavadocElement` represented by this node.
   */
  JavadocElement getJavadocElement() { result = jd }
}

/**
 * A node representing the `Import`s of a `CompilationUnit`.
 * Only rendered if there is at least one import.
 */
final class ImportsNode extends PrintAstNode, TImportsNode {
  CompilationUnit cu;

  ImportsNode() { this = TImportsNode(cu) }

  override string toString() { result = "(Imports)" }

  override ElementNode getChild(int childIndex) {
    result.getElement() =
      rank[childIndex](Import im, string file, int line, int column |
        im.getCompilationUnit() = cu and locationSortKeys(im, file, line, column)
      |
        im order by file, line, column
      )
  }

  /**
   * Gets the underlying CompilationUnit.
   */
  CompilationUnit getCompilationUnit() { result = cu }
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
