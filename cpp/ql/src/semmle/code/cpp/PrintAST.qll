/**
 * Provides queries to pretty-print a C++ AST as a graph.
 *
 * By default, this will print the AST for all functions in the database. To change this behavior,
 * extend `PrintASTConfiguration` and override `shouldPrintFunction` to hold for only the functions
 * you wish to view the AST for.
 */

import cpp
private import semmle.code.cpp.Print

private newtype TPrintASTConfiguration = MkPrintASTConfiguration()

/**
 * The query can extend this class to control which functions are printed.
 */
class PrintASTConfiguration extends TPrintASTConfiguration {
  /**
   * Gets a textual representation of this `PrintASTConfiguration`.
   */
  string toString() { result = "PrintASTConfiguration" }

  /**
   * Holds if the AST for `func` should be printed. By default, holds for all
   * functions.
   */
  predicate shouldPrintFunction(Function func) { any() }
}

private predicate shouldPrintFunction(Function func) {
  exists(PrintASTConfiguration config | config.shouldPrintFunction(func))
}

bindingset[s]
private string escapeString(string s) {
  result =
    s
        .replaceAll("\\", "\\\\")
        .replaceAll("\n", "\\n")
        .replaceAll("\r", "\\r")
        .replaceAll("\t", "\\t")
}

/**
 * Due to extractor issues with ODR violations, a given AST may wind up with
 * multiple locations. This predicate returns a single location - the one whose
 * string representation comes first in lexicographical order.
 */
private Location getRepresentativeLocation(Locatable ast) {
  result = rank[1](Location loc | loc = ast.getLocation() | loc order by loc.toString())
}

/**
 * Computes the sort keys to sort the given AST node by location. An AST without
 * a location gets an empty file name and a zero line and column number.
 */
private predicate locationSortKeys(Locatable ast, string file, int line, int column) {
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

private Function getEnclosingFunction(Locatable ast) {
  result = ast.(Expr).getEnclosingFunction()
  or
  result = ast.(Stmt).getEnclosingFunction()
  or
  result = ast.(Initializer).getExpr().getEnclosingFunction()
  or
  result = ast.(Parameter).getFunction()
  or
  result = ast
}

/**
 * Most nodes are just a wrapper around `Locatable`, but we do synthesize new
 * nodes for things like parameter lists and constructor init lists.
 */
private newtype TPrintASTNode =
  TASTNode(Locatable ast) { shouldPrintFunction(getEnclosingFunction(ast)) } or
  TDeclarationEntryNode(DeclStmt stmt, DeclarationEntry entry) {
    // We create a unique node for each pair of (stmt, entry), to avoid having one node with
    // multiple parents due to extractor bug CPP-413.
    stmt.getADeclarationEntry() = entry
  } or
  TParametersNode(Function func) { shouldPrintFunction(func) } or
  TConstructorInitializersNode(Constructor ctor) {
    ctor.hasEntryPoint() and
    shouldPrintFunction(ctor)
  } or
  TDestructorDestructionsNode(Destructor dtor) {
    dtor.hasEntryPoint() and
    shouldPrintFunction(dtor)
  }

/**
 * A node in the output tree.
 */
class PrintASTNode extends TPrintASTNode {
  /**
   * Gets a textual representation of this node in the PrintAST output tree.
   */
  abstract string toString();

  /**
   * Gets the child node at index `childIndex`. Child indices must be unique,
   * but need not be contiguous (but see `getChildByRank`).
   */
  abstract PrintASTNode getChild(int childIndex);

  /**
   * Holds if this node should be printed in the output. By default, all nodes
   * within a function are printed, but the query can override
   * `PrintASTConfiguration.shouldPrintFunction` to filter the output.
   */
  final predicate shouldPrint() { shouldPrintFunction(getEnclosingFunction()) }

  /**
   * Gets the children of this node.
   */
  final PrintASTNode getAChild() { result = getChild(_) }

  /**
   * Gets the parent of this node, if any.
   */
  final PrintASTNode getParent() { result.getAChild() = this }

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

  /**
   * Gets the `Function` that contains this node.
   */
  private Function getEnclosingFunction() { result = getParent*().(FunctionNode).getFunction() }
}

/**
 * Retrieves the canonical QL class(es) for entity `el`
 */
private string qlClass(ElementBase el) {
  result = "[" + concat(el.getAPrimaryQlClass(), ",") + "] "
  // Alternative implementation -- do not delete. It is useful for QL class discovery.
  //result = "["+ concat(el.getAQlClass(), ",") + "] "
}

/**
 * A node representing an AST node.
 */
abstract class BaseASTNode extends PrintASTNode {
  Locatable ast;

  override string toString() { result = qlClass(ast) + ast.toString() }

  final override Location getLocation() { result = getRepresentativeLocation(ast) }

  /**
   * Gets the AST represented by this node.
   */
  final Locatable getAST() { result = ast }
}

/**
 * A node representing an AST node other than a `DeclarationEntry`.
 */
abstract class ASTNode extends BaseASTNode, TASTNode {
  ASTNode() { this = TASTNode(ast) }
}

/**
 * A node representing an `Expr`.
 */
class ExprNode extends ASTNode {
  Expr expr;

  ExprNode() { expr = ast }

  override ASTNode getChild(int childIndex) {
    result.getAST() = expr.getChild(childIndex).getFullyConverted()
  }

  override string getProperty(string key) {
    result = super.getProperty(key)
    or
    key = "Value" and
    result = qlClass(expr) + getValue()
    or
    key = "Type" and
    result = qlClass(expr.getType()) + expr.getType().toString()
    or
    key = "ValueCategory" and
    result = expr.getValueCategoryString()
  }

  /**
   * Gets the value of this expression, if it is a constant.
   */
  string getValue() { result = expr.getValue() }
}

/**
 * A node representing a `StringLiteral`.
 */
class StringLiteralNode extends ExprNode {
  StringLiteralNode() { expr instanceof StringLiteral }

  override string toString() { result = escapeString(expr.getValue()) }

  override string getValue() { result = "\"" + escapeString(expr.getValue()) + "\"" }
}

/**
 * A node representing a `Conversion`.
 */
class ConversionNode extends ExprNode {
  Conversion conv;

  ConversionNode() { conv = expr }

  override ASTNode getChild(int childIndex) {
    childIndex = 0 and
    result.getAST() = conv.getExpr()
  }

  override string getChildEdgeLabel(int childIndex) { childIndex = 0 and result = "expr" }
}

/**
 * A node representing a `Cast`.
 */
class CastNode extends ConversionNode {
  Cast cast;

  CastNode() { cast = conv }

  override string getProperty(string key) {
    result = super.getProperty(key)
    or
    key = "Conversion" and
    result = "[" + qlConversion(cast) + "] " + cast.getSemanticConversionString()
  }
}

/**
 * A node representing a `DeclarationEntry`.
 */
class DeclarationEntryNode extends BaseASTNode, TDeclarationEntryNode {
  override DeclarationEntry ast;
  DeclStmt declStmt;

  DeclarationEntryNode() { this = TDeclarationEntryNode(declStmt, ast) }

  override PrintASTNode getChild(int childIndex) { none() }

  override string getProperty(string key) {
    result = BaseASTNode.super.getProperty(key)
    or
    key = "Type" and
    result = qlClass(ast.getType()) + ast.getType().toString()
  }
}

/**
 * A node representing a `VariableDeclarationEntry`.
 */
class VariableDeclarationEntryNode extends DeclarationEntryNode {
  override VariableDeclarationEntry ast;

  override ASTNode getChild(int childIndex) {
    childIndex = 0 and
    result.getAST() = ast.getVariable().getInitializer()
  }

  override string getChildEdgeLabel(int childIndex) { childIndex = 0 and result = "init" }
}

/**
 * A node representing a `Stmt`.
 */
class StmtNode extends ASTNode {
  Stmt stmt;

  StmtNode() { stmt = ast }

  override BaseASTNode getChild(int childIndex) {
    exists(Locatable child |
      child = stmt.getChild(childIndex) and
      (
        result.getAST() = child.(Expr).getFullyConverted() or
        result.getAST() = child.(Stmt)
      )
    )
  }
}

/**
 * A node representing a `DeclStmt`.
 */
class DeclStmtNode extends StmtNode {
  DeclStmt declStmt;

  DeclStmtNode() { declStmt = stmt }

  override DeclarationEntryNode getChild(int childIndex) {
    exists(DeclarationEntry entry |
      declStmt.getDeclarationEntry(childIndex) = entry and
      result = TDeclarationEntryNode(declStmt, entry)
    )
  }
}

/**
 * A node representing a `Parameter`.
 */
class ParameterNode extends ASTNode {
  Parameter param;

  ParameterNode() { param = ast }

  final override PrintASTNode getChild(int childIndex) { none() }

  final override string getProperty(string key) {
    result = super.getProperty(key)
    or
    key = "Type" and
    result = qlClass(param.getType()) + param.getType().toString()
  }
}

/**
 * A node representing an `Initializer`.
 */
class InitializerNode extends ASTNode {
  Initializer init;

  InitializerNode() { init = ast }

  override ASTNode getChild(int childIndex) {
    childIndex = 0 and
    result.getAST() = init.getExpr().getFullyConverted()
  }

  override string getChildEdgeLabel(int childIndex) {
    childIndex = 0 and
    result = "expr"
  }
}

/**
 * A node representing the parameters of a `Function`.
 */
class ParametersNode extends PrintASTNode, TParametersNode {
  Function func;

  ParametersNode() { this = TParametersNode(func) }

  final override string toString() { result = "" }

  final override Location getLocation() { result = getRepresentativeLocation(func) }

  override ASTNode getChild(int childIndex) { result.getAST() = func.getParameter(childIndex) }

  /**
   * Gets the `Function` for which this node represents the parameters.
   */
  final Function getFunction() { result = func }
}

/**
 * A node representing the initializer list of a `Constructor`.
 */
class ConstructorInitializersNode extends PrintASTNode, TConstructorInitializersNode {
  Constructor ctor;

  ConstructorInitializersNode() { this = TConstructorInitializersNode(ctor) }

  final override string toString() { result = "" }

  final override Location getLocation() { result = getRepresentativeLocation(ctor) }

  final override ASTNode getChild(int childIndex) {
    result.getAST() = ctor.getInitializer(childIndex)
  }

  /**
   * Gets the `Constructor` for which this node represents the initializer list.
   */
  final Constructor getConstructor() { result = ctor }
}

/**
 * A node representing the destruction list of a `Destructor`.
 */
class DestructorDestructionsNode extends PrintASTNode, TDestructorDestructionsNode {
  Destructor dtor;

  DestructorDestructionsNode() { this = TDestructorDestructionsNode(dtor) }

  final override string toString() { result = "" }

  final override Location getLocation() { result = getRepresentativeLocation(dtor) }

  final override ASTNode getChild(int childIndex) {
    result.getAST() = dtor.getDestruction(childIndex)
  }

  /**
   * Gets the `Destructor` for which this node represents the destruction list.
   */
  final Destructor getDestructor() { result = dtor }
}

/**
 * A node representing a `Function`.
 */
class FunctionNode extends ASTNode {
  Function func;

  FunctionNode() { func = ast }

  override string toString() { result = qlClass(func) + getIdentityString(func) }

  override PrintASTNode getChild(int childIndex) {
    childIndex = 0 and
    result.(ParametersNode).getFunction() = func
    or
    childIndex = 1 and
    result.(ConstructorInitializersNode).getConstructor() = func
    or
    childIndex = 2 and
    result.(ASTNode).getAST() = func.getEntryPoint()
    or
    childIndex = 3 and
    result.(DestructorDestructionsNode).getDestructor() = func
  }

  override string getChildEdgeLabel(int childIndex) {
    childIndex = 0 and result = "params"
    or
    childIndex = 1 and result = "initializations"
    or
    childIndex = 2 and result = "body"
    or
    childIndex = 3 and result = "destructions"
  }

  private int getOrder() {
    this =
      rank[result](FunctionNode node, Function function, string file, int line, int column |
        node.getAST() = function and
        locationSortKeys(function, file, line, column)
      |
        node order by file, line, column, getIdentityString(function)
      )
  }

  override string getProperty(string key) {
    result = super.getProperty(key)
    or
    key = "semmle.order" and result = getOrder().toString()
  }

  /**
   * Gets the `Function` this node represents.
   */
  final Function getFunction() { result = func }
}

/**
 * A node representing an `ClassAggregateLiteral`.
 */
class ClassAggregateLiteralNode extends ExprNode {
  ClassAggregateLiteral list;

  ClassAggregateLiteralNode() { list = ast }

  override string getChildEdgeLabel(int childIndex) {
    exists(Field field |
      list.getFieldExpr(field) = list.getChild(childIndex) and
      result = "." + field.getName()
    )
  }
}

/**
 * A node representing an `ArrayAggregateLiteral`.
 */
class ArrayAggregateLiteralNode extends ExprNode {
  ArrayAggregateLiteral list;

  ArrayAggregateLiteralNode() { list = ast }

  override string getChildEdgeLabel(int childIndex) {
    exists(int elementIndex |
      list.getElementExpr(elementIndex) = list.getChild(childIndex) and
      result = "[" + elementIndex.toString() + "]"
    )
  }
}

/** Holds if `node` belongs to the output tree, and its property `key` has the given `value`. */
query predicate nodes(PrintASTNode node, string key, string value) {
  node.shouldPrint() and
  value = node.getProperty(key)
}

/**
 * Holds if `target` is a child of `source` in the AST, and property `key` of the edge has the
 * given `value`.
 */
query predicate edges(PrintASTNode source, PrintASTNode target, string key, string value) {
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
