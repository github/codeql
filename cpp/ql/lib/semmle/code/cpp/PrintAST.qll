/**
 * Provides queries to pretty-print a C++ AST as a graph.
 *
 * By default, this will print the AST for all functions and global and namespace variables in
 * the database. To change this behavior, extend `PrintASTConfiguration` and override
 * `shouldPrintDeclaration` to hold for only the declarations you wish to view the AST for.
 */

import cpp
private import semmle.code.cpp.Print

private newtype TPrintAstConfiguration = MkPrintAstConfiguration()

/**
 * The query can extend this class to control which declarations are printed.
 */
class PrintAstConfiguration extends TPrintAstConfiguration {
  /**
   * Gets a textual representation of this `PrintASTConfiguration`.
   */
  string toString() { result = "PrintASTConfiguration" }

  /**
   * Holds if the AST for `decl` should be printed. By default, holds for all
   * functions and global and namespace variables. Currently, does not support any
   * other declaration types.
   */
  predicate shouldPrintDeclaration(Declaration decl) { any() }
}

private predicate shouldPrintDeclaration(Declaration decl) {
  exists(PrintAstConfiguration config | config.shouldPrintDeclaration(decl)) and
  (decl instanceof Function or decl instanceof GlobalOrNamespaceVariable)
}

bindingset[s]
private string escapeString(string s) {
  result =
    s.replaceAll("\\", "\\\\")
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
  result = min(Location loc | loc = ast.getLocation() | loc order by loc.toString())
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

private Declaration getAnEnclosingDeclaration(Locatable ast) {
  result = ast.(Expr).getEnclosingFunction()
  or
  result = ast.(Stmt).getEnclosingFunction()
  or
  result = ast.(Initializer).getExpr().getEnclosingFunction()
  or
  result = ast.(Parameter).getFunction()
  or
  result = ast.(Parameter).getCatchBlock().getEnclosingFunction()
  or
  result = ast.(Parameter).getRequiresExpr().getEnclosingFunction()
  or
  result = ast.(Expr).getEnclosingDeclaration()
  or
  result = ast.(Initializer).getDeclaration()
  or
  exists(ConceptIdExpr concept | ast = concept.getATemplateArgument() |
    result = concept.getEnclosingFunction()
  )
  or
  result = ast
}

/**
 * Most nodes are just a wrapper around `Locatable`, but we do synthesize new
 * nodes for things like parameter lists and constructor init lists.
 */
private newtype TPrintAstNode =
  TAstNode(Locatable ast) { shouldPrintDeclaration(getAnEnclosingDeclaration(ast)) } or
  TDeclarationEntryNode(DeclStmt stmt, DeclarationEntry entry) {
    // We create a unique node for each pair of (stmt, entry), to avoid having one node with
    // multiple parents due to extractor bug CPP-413.
    stmt.getADeclarationEntry() = entry and
    shouldPrintDeclaration(stmt.getEnclosingFunction())
  } or
  TFunctionParametersNode(Function func) { shouldPrintDeclaration(func) } or
  TRequiresExprParametersNode(RequiresExpr req) {
    shouldPrintDeclaration(getAnEnclosingDeclaration(req))
  } or
  TConceptIdExprArgumentsNode(ConceptIdExpr concept) {
    shouldPrintDeclaration(getAnEnclosingDeclaration(concept))
  } or
  TConceptIdExprTypeArgumentNode(Type type, ConceptIdExpr concept, int childIndex) {
    type = concept.getTemplateArgument(childIndex)
  } or
  TConstructorInitializersNode(Constructor ctor) {
    ctor.hasEntryPoint() and
    shouldPrintDeclaration(ctor)
  } or
  TDestructorDestructionsNode(Destructor dtor) {
    dtor.hasEntryPoint() and
    shouldPrintDeclaration(dtor)
  }

/**
 * A node in the output tree.
 */
class PrintAstNode extends TPrintAstNode {
  /**
   * Gets a textual representation of this node in the PrintAST output tree.
   */
  abstract string toString();

  /**
   * Gets the child node at index `childIndex`. Child indices must be unique,
   * but need not be contiguous.
   */
  abstract PrintAstNode getChildInternal(int childIndex);

  /**
   * Gets the child node at index `childIndex`.
   * Adds edges to fully converted expressions, that are not part of the
   * regular parent/child relation traversal.
   */
  final PrintAstNode getChild(int childIndex) {
    // The exact value of `childIndex` doesn't matter, as long as we preserve the correct order.
    result =
      rank[childIndex](PrintAstNode child, int nonConvertedIndex, boolean isConverted |
        this.childAndAccessorPredicate(child, _, nonConvertedIndex, isConverted)
      |
        // Unconverted children come first, then sort by original child index within each group.
        child order by isConverted, nonConvertedIndex
      )
  }

  /**
   * Gets the node for the `.getFullyConverted()` version of the child originally at index
   * `childIndex`, if that node has any conversions.
   */
  private PrintAstNode getConvertedChild(int childIndex) {
    exists(Expr expr |
      expr = this.getChildInternal(childIndex).(AstNode).getAst() and
      expr.getFullyConverted() instanceof Conversion and
      result.(AstNode).getAst() = expr.getFullyConverted() and
      not expr instanceof Conversion
    )
  }

  /**
   * Gets the child access predicate for the `.getFullyConverted()` version of the child originally
   * at index `childIndex`, if that node has any conversions.
   */
  private string getConvertedChildAccessorPredicate(int childIndex) {
    exists(this.getConvertedChild(childIndex)) and
    result = this.getChildAccessorPredicateInternal(childIndex) + ".getFullyConverted()"
  }

  /**
   * Holds if this node should be printed in the output. By default, all nodes
   * within functions and global and namespace variables are printed, but the query
   * can override `PrintASTConfiguration.shouldPrintDeclaration` to filter the output.
   */
  final predicate shouldPrint() { shouldPrintDeclaration(this.getEnclosingDeclaration()) }

  /**
   * Gets the children of this node.
   */
  final PrintAstNode getAChild() { result = this.getChild(_) }

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
    result = this.toString()
  }

  /**
   * Holds if there is a child node `child` for original child index `nonConvertedIndex` with
   * predicate name `childPredicate`. If the original child at that index has any conversions, there
   * will be two result tuples for this predicate: one with the original child and predicate, with
   * `isConverted = false`, and the other with the `.getFullyConverted()` version of the child and
   * predicate, with `isConverted = true`. For a child without any conversions, there will be only
   * one result tuple, with `isConverted = false`.
   */
  private predicate childAndAccessorPredicate(
    PrintAstNode child, string childPredicate, int nonConvertedIndex, boolean isConverted
  ) {
    child = this.getChildInternal(nonConvertedIndex) and
    childPredicate = this.getChildAccessorPredicateInternal(nonConvertedIndex) and
    isConverted = false
    or
    child = this.getConvertedChild(nonConvertedIndex) and
    childPredicate = this.getConvertedChildAccessorPredicate(nonConvertedIndex) and
    isConverted = true
  }

  /**
   * Gets the QL predicate that can be used to access the child at `childIndex`.
   * May not always return a QL predicate, see for example `FunctionNode`.
   */
  final string getChildAccessorPredicate(int childIndex) {
    // The exact value of `childIndex` doesn't matter, as long as we preserve the correct order.
    result =
      rank[childIndex](string childPredicate, int nonConvertedIndex, boolean isConverted |
        this.childAndAccessorPredicate(_, childPredicate, nonConvertedIndex, isConverted)
      |
        // Unconverted children come first, then sort by original child index within each group.
        childPredicate order by isConverted, nonConvertedIndex
      )
  }

  /**
   * Gets the QL predicate that can be used to access the child at `childIndex`.
   * INTERNAL DO NOT USE: Does not contain accessors for the synthesized nodes for conversions.
   */
  abstract string getChildAccessorPredicateInternal(int childIndex);

  /**
   * Gets the `Declaration` that contains this node.
   */
  private Declaration getEnclosingDeclaration() { result = this.getParent*().getDeclaration() }

  /**
   * Gets the `Declaration` this node represents.
   */
  private Declaration getDeclaration() {
    result = this.(AstNode).getAst() and shouldPrintDeclaration(result)
  }
}

/**
 * Class that restricts the elements that we compute `qlClass` for.
 */
private class PrintableElement extends Element {
  PrintableElement() {
    exists(TAstNode(this))
    or
    exists(TDeclarationEntryNode(_, this))
    or
    this instanceof Type
  }

  pragma[noinline]
  string getAPrimaryQlClass0() { result = this.getAPrimaryQlClass() }
}

/**
 * Retrieves the canonical QL class(es) for entity `el`
 */
private string qlClass(PrintableElement el) {
  result = "[" + concat(el.getAPrimaryQlClass0(), ",") + "] "
  // Alternative implementation -- do not delete. It is useful for QL class discovery.
  //result = "["+ concat(el.getAQlClass(), ",") + "] "
}

/**
 * A node representing an AST node.
 */
abstract class BaseAstNode extends PrintAstNode {
  Locatable ast;

  override string toString() { result = qlClass(ast) + ast.toString() }

  final override Location getLocation() { result = getRepresentativeLocation(ast) }

  /**
   * Gets the AST represented by this node.
   */
  final Locatable getAst() { result = ast }
}

/**
 * A node representing an AST node other than a `DeclarationEntry`.
 */
abstract class AstNode extends BaseAstNode, TAstNode {
  AstNode() { this = TAstNode(ast) }
}

/**
 * A node representing an `Expr`.
 */
class ExprNode extends AstNode {
  Expr expr;

  ExprNode() { expr = ast }

  override PrintAstNode getChildInternal(int childIndex) {
    result.(AstNode).getAst() = expr.getChild(childIndex)
    or
    childIndex = max(int index | exists(expr.getChild(index)) or index = 0) + 1 and
    result.(AstNode).getAst() = expr.(ConditionDeclExpr).getInitializingExpr()
    or
    exists(int destructorIndex |
      result.(AstNode).getAst() = expr.getImplicitDestructorCall(destructorIndex) and
      childIndex = destructorIndex + max(int index | exists(expr.getChild(index)) or index = 0) + 2
    )
  }

  override string getProperty(string key) {
    result = super.getProperty(key)
    or
    key = "Value" and
    result = qlClass(expr) + this.getValue()
    or
    key = "Type" and
    result = qlClass(expr.getType()) + expr.getType().toString()
    or
    key = "ValueCategory" and
    result = expr.getValueCategoryString()
  }

  override string getChildAccessorPredicateInternal(int childIndex) {
    result =
      getChildAccessorWithoutConversions(ast, this.getChildInternal(childIndex).(AstNode).getAst())
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
 * A node representing a `ConceptIdExpr`.
 */
class ConceptIdExprNode extends ExprNode {
  override ConceptIdExpr expr;

  override PrintAstNode getChildInternal(int childIndex) {
    result = super.getChildInternal(childIndex)
    or
    childIndex = -1 and
    result.(ConceptIdExprArgumentsNode).getConceptIdExpr() = expr
  }

  override string getChildAccessorPredicateInternal(int childIndex) {
    result = super.getChildAccessorPredicateInternal(childIndex)
    or
    childIndex = -1 and result = "<args>"
  }
}

/**
 * A node representing a `Conversion`.
 */
class ConversionNode extends ExprNode {
  Conversion conv;

  ConversionNode() { conv = expr }

  override AstNode getChildInternal(int childIndex) {
    childIndex = 0 and
    result.getAst() = conv.getExpr() and
    conv.getExpr() instanceof Conversion
    or
    result.getAst() = expr.getImplicitDestructorCall(childIndex - 1)
  }
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
 * A node representing a `C11GenericExpr`.
 */
class C11GenericNode extends ConversionNode {
  C11GenericExpr generic;

  C11GenericNode() { generic = conv }

  override AstNode getChildInternal(int childIndex) {
    result = super.getChildInternal(childIndex - count(generic.getAChild()))
    or
    result.getAst() = generic.getChild(childIndex)
  }
}

/**
 * A node representing a `StmtExpr`.
 */
class StmtExprNode extends ExprNode {
  override StmtExpr expr;

  override AstNode getChildInternal(int childIndex) {
    childIndex = 0 and
    result.getAst() = expr.getStmt()
  }
}

/**
 * A node representing a `RequiresExpr`
 */
class RequiresExprNode extends ExprNode {
  override RequiresExpr expr;

  override PrintAstNode getChildInternal(int childIndex) {
    result = super.getChildInternal(childIndex)
    or
    childIndex = -1 and
    result.(RequiresExprParametersNode).getRequiresExpr() = expr
  }

  override string getChildAccessorPredicateInternal(int childIndex) {
    result = super.getChildAccessorPredicateInternal(childIndex)
    or
    childIndex = -1 and result = "<params>"
  }
}

/**
 * A node representing a `DeclarationEntry`.
 */
class DeclarationEntryNode extends BaseAstNode, TDeclarationEntryNode {
  override DeclarationEntry ast;
  DeclStmt declStmt;

  DeclarationEntryNode() { this = TDeclarationEntryNode(declStmt, ast) }

  override PrintAstNode getChildInternal(int childIndex) { none() }

  override string getChildAccessorPredicateInternal(int childIndex) { none() }

  override string getProperty(string key) {
    result = BaseAstNode.super.getProperty(key)
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

  override AstNode getChildInternal(int childIndex) {
    childIndex = 0 and
    result.getAst() = ast.getVariable().getInitializer()
  }

  override string getChildAccessorPredicateInternal(int childIndex) {
    childIndex = 0 and
    result = "getVariable().getInitializer()"
  }
}

/**
 * A node representing a `Stmt`.
 */
class StmtNode extends AstNode {
  Stmt stmt;

  StmtNode() { stmt = ast }

  override BaseAstNode getChildInternal(int childIndex) {
    exists(Locatable child |
      child = stmt.getChild(childIndex) and
      (
        result.getAst() = child.(Expr) or
        result.getAst() = child.(Stmt)
      )
    )
    or
    exists(int destructorIndex |
      result.getAst() = stmt.getImplicitDestructorCall(destructorIndex) and
      childIndex = destructorIndex + max(int index | exists(stmt.getChild(index)) or index = 0) + 1
    )
  }

  override string getChildAccessorPredicateInternal(int childIndex) {
    result = getChildAccessorWithoutConversions(ast, this.getChildInternal(childIndex).getAst())
  }
}

/**
 * A node representing a child of a `Stmt` that is itself a `Stmt`.
 */
class ChildStmtNode extends StmtNode {
  Stmt childStmt;

  ChildStmtNode() { exists(Stmt parent | parent.getAChild() = childStmt and childStmt = ast) }

  override BaseAstNode getChildInternal(int childIndex) {
    result = super.getChildInternal(childIndex)
    or
    exists(int destructorIndex |
      result.getAst() = childStmt.getImplicitDestructorCall(destructorIndex) and
      childIndex =
        destructorIndex + max(int index | exists(childStmt.getChild(index)) or index = 0) + 1
    )
  }
}

/**
 * A node representing a `DeclStmt`.
 */
class DeclStmtNode extends StmtNode {
  DeclStmt declStmt;

  DeclStmtNode() { declStmt = stmt }

  override DeclarationEntryNode getChildInternal(int childIndex) {
    exists(DeclarationEntry entry |
      declStmt.getDeclarationEntry(childIndex) = entry and
      result = TDeclarationEntryNode(declStmt, entry)
    )
  }
}

/**
 * A node representing a `Handler`.
 */
class HandlerNode extends ChildStmtNode {
  Handler handler;

  HandlerNode() { handler = stmt }

  override BaseAstNode getChildInternal(int childIndex) {
    result = super.getChildInternal(childIndex)
    or
    childIndex = -1 and
    result.getAst() = handler.getParameter()
  }
}

/**
 * A node representing a `Parameter`.
 */
class ParameterNode extends AstNode {
  Parameter param;

  ParameterNode() { param = ast }

  final override PrintAstNode getChildInternal(int childIndex) { none() }

  final override string getChildAccessorPredicateInternal(int childIndex) { none() }

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
class InitializerNode extends AstNode {
  Initializer init;

  InitializerNode() { init = ast }

  override AstNode getChildInternal(int childIndex) {
    childIndex = 0 and
    result.getAst() = init.getExpr()
  }

  override string getChildAccessorPredicateInternal(int childIndex) {
    childIndex = 0 and
    result = "getExpr()"
  }
}

/**
 * A node representing the arguments of a `ConceptIdExpr`.
 */
class ConceptIdExprArgumentsNode extends PrintAstNode, TConceptIdExprArgumentsNode {
  ConceptIdExpr concept;

  ConceptIdExprArgumentsNode() { this = TConceptIdExprArgumentsNode(concept) }

  final override string toString() { result = "" }

  final override Location getLocation() { result = getRepresentativeLocation(concept) }

  override PrintAstNode getChildInternal(int childIndex) {
    exists(Locatable arg | arg = concept.getTemplateArgument(childIndex) |
      result.(ConceptIdExprTypeArgumentNode).isArgumentNode(arg, concept, childIndex)
      or
      result.(ExprNode).getAst() = arg
    )
  }

  override string getChildAccessorPredicateInternal(int childIndex) {
    exists(this.getChildInternal(childIndex)) and
    result = "getTemplateArgument(" + childIndex + ")"
  }

  /**
   * Gets the `ConceptIdExpr` for which this node represents the parameters.
   */
  final ConceptIdExpr getConceptIdExpr() { result = concept }
}

/**
 * A node representing a type argument of a `ConceptIdExpr`.
 */
class ConceptIdExprTypeArgumentNode extends PrintAstNode, TConceptIdExprTypeArgumentNode {
  Type type;
  ConceptIdExpr concept;
  int index;

  ConceptIdExprTypeArgumentNode() { this = TConceptIdExprTypeArgumentNode(type, concept, index) }

  final override string toString() { result = qlClass(type) + type.toString() }

  final override Location getLocation() { result = getRepresentativeLocation(type) }

  override AstNode getChildInternal(int childIndex) { none() }

  override string getChildAccessorPredicateInternal(int childIndex) { none() }

  /**
   * Holds if `t` is the `i`th template argument of `c`.
   */
  predicate isArgumentNode(Type t, ConceptIdExpr c, int i) {
    type = t and concept = c and index = i
  }
}

/**
 * A node representing the parameters of a `Function`.
 */
class FunctionParametersNode extends PrintAstNode, TFunctionParametersNode {
  Function func;

  FunctionParametersNode() { this = TFunctionParametersNode(func) }

  final override string toString() { result = "" }

  final override Location getLocation() { result = getRepresentativeLocation(func) }

  override AstNode getChildInternal(int childIndex) {
    result.getAst() = func.getParameter(childIndex)
  }

  override string getChildAccessorPredicateInternal(int childIndex) {
    exists(this.getChildInternal(childIndex)) and
    result = "getParameter(" + childIndex + ")"
  }

  /**
   * Gets the `Function` for which this node represents the parameters.
   */
  final Function getFunction() { result = func }
}

/**
 * A node representing the parameters of a `RequiresExpr`.
 */
class RequiresExprParametersNode extends PrintAstNode, TRequiresExprParametersNode {
  RequiresExpr req;

  RequiresExprParametersNode() { this = TRequiresExprParametersNode(req) }

  final override string toString() { result = "" }

  final override Location getLocation() { result = getRepresentativeLocation(req) }

  override AstNode getChildInternal(int childIndex) {
    result.getAst() = req.getParameter(childIndex)
  }

  override string getChildAccessorPredicateInternal(int childIndex) {
    exists(this.getChildInternal(childIndex)) and
    result = "getParameter(" + childIndex + ")"
  }

  /**
   * Gets the `RequiresExpr` for which this node represents the parameters.
   */
  final RequiresExpr getRequiresExpr() { result = req }
}

/**
 * A node representing the initializer list of a `Constructor`.
 */
class ConstructorInitializersNode extends PrintAstNode, TConstructorInitializersNode {
  Constructor ctor;

  ConstructorInitializersNode() { this = TConstructorInitializersNode(ctor) }

  final override string toString() { result = "" }

  final override Location getLocation() { result = getRepresentativeLocation(ctor) }

  final override AstNode getChildInternal(int childIndex) {
    result.getAst() = ctor.getInitializer(childIndex)
  }

  final override string getChildAccessorPredicateInternal(int childIndex) {
    exists(this.getChildInternal(childIndex)) and
    result = "getInitializer(" + childIndex + ")"
  }

  /**
   * Gets the `Constructor` for which this node represents the initializer list.
   */
  final Constructor getConstructor() { result = ctor }
}

/**
 * A node representing the destruction list of a `Destructor`.
 */
class DestructorDestructionsNode extends PrintAstNode, TDestructorDestructionsNode {
  Destructor dtor;

  DestructorDestructionsNode() { this = TDestructorDestructionsNode(dtor) }

  final override string toString() { result = "" }

  final override Location getLocation() { result = getRepresentativeLocation(dtor) }

  final override AstNode getChildInternal(int childIndex) {
    result.getAst() = dtor.getDestruction(childIndex)
  }

  final override string getChildAccessorPredicateInternal(int childIndex) {
    exists(this.getChildInternal(childIndex)) and
    result = "getDestruction(" + childIndex + ")"
  }

  /**
   * Gets the `Destructor` for which this node represents the destruction list.
   */
  final Destructor getDestructor() { result = dtor }
}

abstract private class FunctionOrGlobalOrNamespaceVariableNode extends AstNode {
  override string toString() { result = qlClass(ast) + getIdentityString(ast) }

  private int getOrder() {
    this =
      rank[result](FunctionOrGlobalOrNamespaceVariableNode node, Declaration decl, string file,
        int line, int column |
        node.getAst() = decl and
        locationSortKeys(decl, file, line, column)
      |
        node order by file, line, column, getIdentityString(decl)
      )
  }

  override string getProperty(string key) {
    result = super.getProperty(key)
    or
    key = "semmle.order" and result = this.getOrder().toString()
  }
}

/**
 * A node representing a `GlobalOrNamespaceVariable`.
 */
class GlobalOrNamespaceVariableNode extends FunctionOrGlobalOrNamespaceVariableNode {
  GlobalOrNamespaceVariable var;

  GlobalOrNamespaceVariableNode() { var = ast }

  override PrintAstNode getChildInternal(int childIndex) {
    childIndex = 0 and
    result.(AstNode).getAst() = var.getInitializer()
  }

  override string getChildAccessorPredicateInternal(int childIndex) {
    childIndex = 0 and result = "getInitializer()"
  }
}

/**
 * A node representing a `Function`.
 */
class FunctionNode extends FunctionOrGlobalOrNamespaceVariableNode {
  Function func;

  FunctionNode() { func = ast }

  override PrintAstNode getChildInternal(int childIndex) {
    childIndex = 0 and
    result.(FunctionParametersNode).getFunction() = func
    or
    childIndex = 1 and
    result.(ConstructorInitializersNode).getConstructor() = func
    or
    childIndex = 2 and
    result.(AstNode).getAst() = func.getEntryPoint()
    or
    childIndex = 3 and
    result.(DestructorDestructionsNode).getDestructor() = func
  }

  override string getChildAccessorPredicateInternal(int childIndex) {
    childIndex = 0 and result = "<params>"
    or
    childIndex = 1 and result = "<initializations>"
    or
    childIndex = 2 and result = "getEntryPoint()"
    or
    childIndex = 3 and result = "<destructions>"
  }
}

private string getChildAccessorWithoutConversions(Locatable parent, Element child) {
  shouldPrintDeclaration(getAnEnclosingDeclaration(parent)) and
  (
    exists(Stmt s, int i | s.getChild(i) = parent |
      exists(int n |
        s.getChild(i).(Stmt).getImplicitDestructorCall(n) = child and
        result = "getImplicitDestructorCall(" + n + ")"
      )
    )
    or
    exists(Stmt s | s = parent |
      namedStmtChildPredicates(s, child, result)
      or
      not namedStmtChildPredicates(s, child, _) and
      exists(int n | s.getChild(n) = child and result = "getChild(" + n + ")")
      or
      exists(int n |
        s.getImplicitDestructorCall(n) = child and result = "getImplicitDestructorCall(" + n + ")"
      )
    )
    or
    exists(Expr expr | expr = parent |
      namedExprChildPredicates(expr, child, result)
      or
      not namedExprChildPredicates(expr, child, _) and
      exists(int n | expr.getChild(n) = child and result = "getChild(" + n + ")")
      or
      expr.(ConditionDeclExpr).getInitializingExpr() = child and result = "getInitializingExpr()"
      or
      exists(int n |
        expr.getImplicitDestructorCall(n) = child and
        result = "getImplicitDestructorCall(" + n + ")"
      )
    )
  )
}

private predicate namedStmtChildPredicates(Locatable s, Element e, string pred) {
  shouldPrintDeclaration(getAnEnclosingDeclaration(s)) and
  (
    exists(int n | s.(BlockStmt).getStmt(n) = e and pred = "getStmt(" + n + ")")
    or
    s.(ComputedGotoStmt).getExpr() = e and pred = "getExpr()"
    or
    s.(ConstexprIfStmt).getInitialization() = e and pred = "getInitialization()"
    or
    s.(ConstexprIfStmt).getCondition() = e and pred = "getCondition()"
    or
    s.(ConstexprIfStmt).getThen() = e and pred = "getThen()"
    or
    s.(ConstexprIfStmt).getElse() = e and pred = "getElse()"
    or
    s.(ConstevalIfStmt).getThen() = e and pred = "getThen()"
    or
    s.(ConstevalIfStmt).getElse() = e and pred = "getElse()"
    or
    s.(Handler).getParameter() = e and pred = "getParameter()"
    or
    s.(IfStmt).getInitialization() = e and pred = "getInitialization()"
    or
    s.(IfStmt).getCondition() = e and pred = "getCondition()"
    or
    s.(IfStmt).getThen() = e and pred = "getThen()"
    or
    s.(IfStmt).getElse() = e and pred = "getElse()"
    or
    s.(SwitchStmt).getInitialization() = e and pred = "getInitialization()"
    or
    s.(SwitchStmt).getExpr() = e and pred = "getExpr()"
    or
    s.(SwitchStmt).getStmt() = e and pred = "getStmt()"
    or
    s.(DoStmt).getCondition() = e and pred = "getCondition()"
    or
    s.(DoStmt).getStmt() = e and pred = "getStmt()"
    or
    s.(ForStmt).getInitialization() = e and pred = "getInitialization()"
    or
    s.(ForStmt).getCondition() = e and pred = "getCondition()"
    or
    s.(ForStmt).getUpdate() = e and pred = "getUpdate()"
    or
    s.(ForStmt).getStmt() = e and pred = "getStmt()"
    or
    s.(RangeBasedForStmt).getInitialization() = e and pred = "getInitialization()"
    or
    s.(RangeBasedForStmt).getChild(1) = e and pred = "getChild(1)"
    or
    s.(RangeBasedForStmt).getBeginEndDeclaration() = e and pred = "getBeginEndDeclaration()"
    or
    s.(RangeBasedForStmt).getCondition() = e and pred = "getCondition()"
    or
    s.(RangeBasedForStmt).getUpdate() = e and pred = "getUpdate()"
    or
    s.(RangeBasedForStmt).getChild(5) = e and pred = "getChild(5)"
    or
    s.(RangeBasedForStmt).getStmt() = e and pred = "getStmt()"
    or
    s.(WhileStmt).getCondition() = e and pred = "getCondition()"
    or
    s.(WhileStmt).getStmt() = e and pred = "getStmt()"
    or
    exists(int n |
      s.(DeclStmt).getDeclarationEntry(n) = e and pred = "getDeclarationEntry(" + n.toString() + ")"
    )
    or
    // EmptyStmt does not have children
    s.(ExprStmt).getExpr() = e and pred = "getExpr()"
    or
    s.(Handler).getBlock() = e and pred = "getBlock()"
    or
    s.(JumpStmt).getTarget() = e and pred = "getTarget()"
    or
    s.(MicrosoftTryStmt).getStmt() = e and pred = "getStmt()"
    or
    s.(MicrosoftTryExceptStmt).getCondition() = e and pred = "getCondition()"
    or
    s.(MicrosoftTryExceptStmt).getExcept() = e and pred = "getExcept()"
    or
    s.(MicrosoftTryFinallyStmt).getFinally() = e and pred = "getFinally()"
    or
    s.(ReturnStmt).getExpr() = e and pred = "getExpr()"
    or
    s.(SwitchCase).getExpr() = e and pred = "getExpr()"
    or
    s.(SwitchCase).getEndExpr() = e and pred = "getEndExpr()"
    or
    s.(TryStmt).getStmt() = e and pred = "getStmt()"
    or
    s.(VlaDimensionStmt).getDimensionExpr() = e and pred = "getDimensionExpr()"
  )
}

private predicate namedExprChildPredicates(Expr expr, Element ele, string pred) {
  shouldPrintDeclaration(expr.getEnclosingDeclaration()) and
  (
    expr.(Access).getTarget() = ele and pred = "getTarget()"
    or
    expr.(VariableAccess).getQualifier() = ele and pred = "getQualifier()"
    or
    expr.(FunctionAccess).getQualifier() = ele and pred = "getQualifier()"
    or
    exists(Field f |
      expr.(ClassAggregateLiteral).getAFieldExpr(f) = ele and
      pred = "getAFieldExpr(" + f.toString() + ")"
    )
    or
    exists(int n |
      expr.(ArrayOrVectorAggregateLiteral).getAnElementExpr(n) = ele and
      pred = "getAnElementExpr(" + n.toString() + ")"
    )
    or
    expr.(AlignofExprOperator).getExprOperand() = ele and pred = "getExprOperand()"
    or
    expr.(ArrayExpr).getArrayBase() = ele and pred = "getArrayBase()"
    or
    expr.(ArrayExpr).getArrayOffset() = ele and pred = "getArrayOffset()"
    or
    expr.(AssumeExpr).getOperand() = ele and pred = "getOperand()"
    or
    expr.(BuiltInComplexOperation).getRealOperand() = ele and pred = "getRealOperand()"
    or
    expr.(BuiltInComplexOperation).getImaginaryOperand() = ele and pred = "getImaginaryOperand()"
    or
    expr.(BuiltInVarArg).getVAList() = ele and pred = "getVAList()"
    or
    expr.(BuiltInVarArgCopy).getDestinationVAList() = ele and pred = "getDestinationVAList()"
    or
    expr.(BuiltInVarArgCopy).getSourceVAList() = ele and pred = "getSourceVAList()"
    or
    expr.(BuiltInVarArgsEnd).getVAList() = ele and pred = "getVAList()"
    or
    expr.(BuiltInVarArgsStart).getVAList() = ele and pred = "getVAList()"
    or
    expr.(BuiltInVarArgsStart).getLastNamedParameter() = ele and pred = "getLastNamedParameter()"
    or
    expr.(C11GenericExpr).getControllingExpr() = ele and pred = "getControllingExpr()"
    or
    exists(int n |
      expr.(C11GenericExpr).getAssociationType(n) = ele.(TypeName).getType() and
      pred = "getAssociationType(" + n + ")"
      or
      expr.(C11GenericExpr).getAssociationExpr(n) = ele and pred = "getAssociationExpr(" + n + ")"
    )
    or
    // OverloadedArrayExpr::getArrayBase/0 also considers qualifiers, and is already handled below.
    not expr.(OverloadedArrayExpr).getArrayBase() = expr.(Call).getQualifier() and
    expr.(Call).getQualifier() = ele and
    pred = "getQualifier()"
    or
    // OverloadedArrayExpr::getArrayBase/0 and OverloadedArrayExpr::getArrayOffset/0 also consider arguments, and are already handled below.
    exists(int n, Expr arg | expr.(Call).getArgument(n) = arg |
      not expr.(OverloadedArrayExpr).getArrayBase() = arg and
      not expr.(OverloadedArrayExpr).getArrayOffset() = arg and
      arg = ele and
      pred = "getArgument(" + n.toString() + ")"
    )
    or
    expr.(ExprCall).getExpr() = ele and pred = "getExpr()"
    or
    expr.(OverloadedArrayExpr).getArrayBase() = ele and pred = "getArrayBase()"
    or
    expr.(OverloadedArrayExpr).getArrayOffset() = ele and pred = "getArrayOffset()"
    or
    // OverloadedPointerDereferenceExpr::getExpr/0 also considers qualifiers, and is already handled above for all Call classes.
    not expr.(OverloadedPointerDereferenceExpr).getQualifier() =
      expr.(OverloadedPointerDereferenceExpr).getExpr() and
    expr.(OverloadedPointerDereferenceExpr).getExpr() = ele and
    pred = "getExpr()"
    or
    expr.(CommaExpr).getLeftOperand() = ele and pred = "getLeftOperand()"
    or
    expr.(CommaExpr).getRightOperand() = ele and pred = "getRightOperand()"
    or
    expr.(CompoundRequirementExpr).getExpr() = ele and pred = "getExpr()"
    or
    expr.(CompoundRequirementExpr).getReturnTypeRequirement() = ele and
    pred = "getReturnTypeRequirement()"
    or
    expr.(ConditionDeclExpr).getVariableAccess() = ele and pred = "getVariableAccess()"
    or
    expr.(ConstructorFieldInit).getExpr() = ele and pred = "getExpr()"
    or
    expr.(Conversion).getExpr() = ele and pred = "getExpr()"
    or
    expr.(DeleteOrDeleteArrayExpr).getDeallocatorCall() = ele and pred = "getDeallocatorCall()"
    or
    expr.(DeleteOrDeleteArrayExpr).getDestructorCall() = ele and pred = "getDestructorCall()"
    or
    expr.(DeleteOrDeleteArrayExpr).getExprWithReuse() = ele and pred = "getExprWithReuse()"
    or
    expr.(DestructorFieldDestruction).getExpr() = ele and pred = "getExpr()"
    or
    expr.(FoldExpr).getInitExpr() = ele and pred = "getInitExpr()"
    or
    expr.(FoldExpr).getPackExpr() = ele and pred = "getPackExpr()"
    or
    expr.(LambdaExpression).getInitializer() = ele and pred = "getInitializer()"
    or
    expr.(NestedRequirementExpr).getConstraint() = ele and pred = "getConstraint()"
    or
    expr.(NewOrNewArrayExpr).getAllocatorCall() = ele and pred = "getAllocatorCall()"
    or
    expr.(NewOrNewArrayExpr).getAlignmentArgument() = ele and pred = "getAlignmentArgument()"
    or
    expr.(NewArrayExpr).getInitializer() = ele and pred = "getInitializer()"
    or
    expr.(NewArrayExpr).getExtent() = ele and pred = "getExtent()"
    or
    expr.(NewExpr).getInitializer() = ele and pred = "getInitializer()"
    or
    expr.(NoExceptExpr).getExpr() = ele and pred = "getExpr()"
    or
    expr.(Assignment).getLValue() = ele and pred = "getLValue()"
    or
    expr.(Assignment).getRValue() = ele and pred = "getRValue()"
    or
    not expr instanceof RelationalOperation and
    expr.(BinaryOperation).getLeftOperand() = ele and
    pred = "getLeftOperand()"
    or
    not expr instanceof RelationalOperation and
    expr.(BinaryOperation).getRightOperand() = ele and
    pred = "getRightOperand()"
    or
    expr.(RelationalOperation).getGreaterOperand() = ele and pred = "getGreaterOperand()"
    or
    expr.(RelationalOperation).getLesserOperand() = ele and pred = "getLesserOperand()"
    or
    expr.(ConditionalExpr).getCondition() = ele and pred = "getCondition()"
    or
    // If ConditionalExpr is in two-operand form, getThen() = getCondition() holds
    not expr.(ConditionalExpr).isTwoOperand() and
    expr.(ConditionalExpr).getThen() = ele and
    pred = "getThen()"
    or
    expr.(ConditionalExpr).getElse() = ele and pred = "getElse()"
    or
    expr.(UnaryOperation).getOperand() = ele and pred = "getOperand()"
    or
    exists(int n |
      expr.(RequiresExpr).getRequirement(n) = ele and
      pred = "getRequirement(" + n + ")"
    )
    or
    expr.(SizeofExprOperator).getExprOperand() = ele and pred = "getExprOperand()"
    or
    expr.(SizeofPackExprOperator).getExprOperand() = ele and pred = "getExprOperand()"
    or
    expr.(StmtExpr).getStmt() = ele and pred = "getStmt()"
    or
    expr.(ThrowExpr).getExpr() = ele and pred = "getExpr()"
    or
    expr.(TypeidOperator).getExpr() = ele and pred = "getExpr()"
  )
}

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
      key = "semmle.label" and value = source.getChildAccessorPredicate(childIndex)
      or
      key = "semmle.order" and value = childIndex.toString()
    )
  )
}

/** Holds if property `key` of the graph has the given `value`. */
query predicate graphProperties(string key, string value) {
  key = "semmle.graphKind" and value = "tree"
}
