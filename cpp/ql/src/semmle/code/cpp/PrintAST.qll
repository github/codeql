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
    stmt.getADeclarationEntry() = entry and
    shouldPrintFunction(stmt.getEnclosingFunction())
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
   * but need not be contiguous.
   */
  abstract PrintASTNode getChildInternal(int childIndex);

  /**
   * Gets the child node at index `childIndex`.
   * Adds edges to fully converted expressions, that are not part of the
   * regular parent/child relation traversal.
   */
  final PrintASTNode getChild(int childIndex) {
    // The exact value of `childIndex` doesn't matter, as long as we preserve the correct order.
    result =
      rank[childIndex](PrintASTNode child, int nonConvertedIndex, boolean isConverted |
        childAndAccessorPredicate(child, _, nonConvertedIndex, isConverted)
      |
        // Unconverted children come first, then sort by original child index within each group.
        child order by isConverted, nonConvertedIndex
      )
  }

  /**
   * Gets the node for the `.getFullyConverted()` version of the child originally at index
   * `childIndex`, if that node has any conversions.
   */
  private PrintASTNode getConvertedChild(int childIndex) {
    exists(Expr expr |
      expr = getChildInternal(childIndex).(ASTNode).getAST() and
      expr.getFullyConverted() instanceof Conversion and
      result.(ASTNode).getAST() = expr.getFullyConverted() and
      not expr instanceof Conversion
    )
  }

  /**
   * Gets the child access predicate for the `.getFullyConverted()` version of the child originally
   * at index `childIndex`, if that node has any conversions.
   */
  private string getConvertedChildAccessorPredicate(int childIndex) {
    exists(getConvertedChild(childIndex)) and
    result = getChildAccessorPredicateInternal(childIndex) + ".getFullyConverted()"
  }

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
   * Holds if there is a child node `child` for original child index `nonConvertedIndex` with
   * predicate name `childPredicate`. If the original child at that index has any conversions, there
   * will be two result tuples for this predicate: one with the original child and predicate, with
   * `isConverted = false`, and the other with the `.getFullyConverted()` version of the child and
   * predicate, with `isConverted = true`. For a child without any conversions, there will be only
   * one result tuple, with `isConverted = false`.
   */
  private predicate childAndAccessorPredicate(
    PrintASTNode child, string childPredicate, int nonConvertedIndex, boolean isConverted
  ) {
    child = getChildInternal(nonConvertedIndex) and
    childPredicate = getChildAccessorPredicateInternal(nonConvertedIndex) and
    isConverted = false
    or
    child = getConvertedChild(nonConvertedIndex) and
    childPredicate = getConvertedChildAccessorPredicate(nonConvertedIndex) and
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
        childAndAccessorPredicate(_, childPredicate, nonConvertedIndex, isConverted)
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
   * Gets the `Function` that contains this node.
   */
  private Function getEnclosingFunction() { result = getParent*().(FunctionNode).getFunction() }
}

/**
 * Class that restricts the elements that we compute `qlClass` for.
 */
private class PrintableElement extends Element {
  PrintableElement() {
    exists(TASTNode(this))
    or
    exists(TDeclarationEntryNode(_, this))
    or
    this instanceof Type
  }

  pragma[noinline]
  string getAPrimaryQlClass0() { result = getAPrimaryQlClass() }
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

  override ASTNode getChildInternal(int childIndex) { result.getAST() = expr.getChild(childIndex) }

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

  override string getChildAccessorPredicateInternal(int childIndex) {
    result = getChildAccessorWithoutConversions(ast, getChildInternal(childIndex).getAST())
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

  override ASTNode getChildInternal(int childIndex) {
    childIndex = 0 and
    result.getAST() = conv.getExpr() and
    conv.getExpr() instanceof Conversion
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
 * A node representing a `StmtExpr`.
 */
class StmtExprNode extends ExprNode {
  override StmtExpr expr;

  override ASTNode getChildInternal(int childIndex) {
    childIndex = 0 and
    result.getAST() = expr.getStmt()
  }
}

/**
 * A node representing a `DeclarationEntry`.
 */
class DeclarationEntryNode extends BaseASTNode, TDeclarationEntryNode {
  override DeclarationEntry ast;
  DeclStmt declStmt;

  DeclarationEntryNode() { this = TDeclarationEntryNode(declStmt, ast) }

  override PrintASTNode getChildInternal(int childIndex) { none() }

  override string getChildAccessorPredicateInternal(int childIndex) { none() }

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

  override ASTNode getChildInternal(int childIndex) {
    childIndex = 0 and
    result.getAST() = ast.getVariable().getInitializer()
  }

  override string getChildAccessorPredicateInternal(int childIndex) {
    childIndex = 0 and
    result = "getVariable().getInitializer()"
  }
}

/**
 * A node representing a `Stmt`.
 */
class StmtNode extends ASTNode {
  Stmt stmt;

  StmtNode() { stmt = ast }

  override BaseASTNode getChildInternal(int childIndex) {
    exists(Locatable child |
      child = stmt.getChild(childIndex) and
      (
        result.getAST() = child.(Expr) or
        result.getAST() = child.(Stmt)
      )
    )
  }

  override string getChildAccessorPredicateInternal(int childIndex) {
    result = getChildAccessorWithoutConversions(ast, getChildInternal(childIndex).getAST())
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
 * A node representing a `Parameter`.
 */
class ParameterNode extends ASTNode {
  Parameter param;

  ParameterNode() { param = ast }

  final override PrintASTNode getChildInternal(int childIndex) { none() }

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
class InitializerNode extends ASTNode {
  Initializer init;

  InitializerNode() { init = ast }

  override ASTNode getChildInternal(int childIndex) {
    childIndex = 0 and
    result.getAST() = init.getExpr()
  }

  override string getChildAccessorPredicateInternal(int childIndex) {
    childIndex = 0 and
    result = "getExpr()"
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

  override ASTNode getChildInternal(int childIndex) {
    result.getAST() = func.getParameter(childIndex)
  }

  override string getChildAccessorPredicateInternal(int childIndex) {
    exists(getChildInternal(childIndex)) and
    result = "getParameter(" + childIndex.toString() + ")"
  }

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

  final override ASTNode getChildInternal(int childIndex) {
    result.getAST() = ctor.getInitializer(childIndex)
  }

  final override string getChildAccessorPredicateInternal(int childIndex) {
    exists(getChildInternal(childIndex)) and
    result = "getInitializer(" + childIndex.toString() + ")"
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

  final override ASTNode getChildInternal(int childIndex) {
    result.getAST() = dtor.getDestruction(childIndex)
  }

  final override string getChildAccessorPredicateInternal(int childIndex) {
    exists(getChildInternal(childIndex)) and
    result = "getDestruction(" + childIndex.toString() + ")"
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

  override PrintASTNode getChildInternal(int childIndex) {
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

  override string getChildAccessorPredicateInternal(int childIndex) {
    childIndex = 0 and result = "<params>"
    or
    childIndex = 1 and result = "<initializations>"
    or
    childIndex = 2 and result = "getEntryPoint()"
    or
    childIndex = 3 and result = "<destructions>"
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

private string getChildAccessorWithoutConversions(Locatable parent, Element child) {
  shouldPrintFunction(getEnclosingFunction(parent)) and
  (
    exists(Stmt s | s = parent |
      namedStmtChildPredicates(s, child, result)
      or
      not namedStmtChildPredicates(s, child, _) and
      exists(int n | s.getChild(n) = child and result = "getChild(" + n + ")")
    )
    or
    exists(Expr expr | expr = parent |
      namedExprChildPredicates(expr, child, result)
      or
      not namedExprChildPredicates(expr, child, _) and
      exists(int n | expr.getChild(n) = child and result = "getChild(" + n + ")")
    )
  )
}

private predicate namedStmtChildPredicates(Locatable s, Element e, string pred) {
  shouldPrintFunction(getEnclosingFunction(s)) and
  (
    exists(int n | s.(BlockStmt).getStmt(n) = e and pred = "getStmt(" + n + ")")
    or
    s.(ComputedGotoStmt).getExpr() = e and pred = "getExpr()"
    or
    s.(ConstexprIfStmt).getCondition() = e and pred = "getCondition()"
    or
    s.(ConstexprIfStmt).getThen() = e and pred = "getThen()"
    or
    s.(ConstexprIfStmt).getElse() = e and pred = "getElse()"
    or
    s.(IfStmt).getCondition() = e and pred = "getCondition()"
    or
    s.(IfStmt).getThen() = e and pred = "getThen()"
    or
    s.(IfStmt).getElse() = e and pred = "getElse()"
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
    s.(RangeBasedForStmt).getChild(0) = e and pred = "getChild(0)"
    or
    s.(RangeBasedForStmt).getBeginEndDeclaration() = e and pred = "getBeginEndDeclaration()"
    or
    s.(RangeBasedForStmt).getCondition() = e and pred = "getCondition()"
    or
    s.(RangeBasedForStmt).getUpdate() = e and pred = "getUpdate()"
    or
    s.(RangeBasedForStmt).getChild(4) = e and pred = "getChild(4)"
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
  shouldPrintFunction(expr.getEnclosingFunction()) and
  (
    expr.(Access).getTarget() = ele and pred = "getTarget()"
    or
    expr.(VariableAccess).getQualifier() = ele and pred = "getQualifier()"
    or
    exists(Field f |
      expr.(ClassAggregateLiteral).getFieldExpr(f) = ele and
      pred = "getFieldExpr(" + f.toString() + ")"
    )
    or
    exists(int n |
      expr.(ArrayOrVectorAggregateLiteral).getElementExpr(n) = ele and
      pred = "getElementExpr(" + n.toString() + ")"
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
    expr.(Call).getQualifier() = ele and pred = "getQualifier()"
    or
    exists(int n | expr.(Call).getArgument(n) = ele and pred = "getArgument(" + n.toString() + ")")
    or
    expr.(ExprCall).getExpr() = ele and pred = "getExpr()"
    or
    expr.(OverloadedArrayExpr).getArrayBase() = ele and pred = "getArrayBase()"
    or
    expr.(OverloadedArrayExpr).getArrayOffset() = ele and pred = "getArrayOffset()"
    or
    expr.(OverloadedPointerDereferenceExpr).getExpr() = ele and pred = "getExpr()"
    or
    expr.(CommaExpr).getLeftOperand() = ele and pred = "getLeftOperand()"
    or
    expr.(CommaExpr).getRightOperand() = ele and pred = "getRightOperand()"
    or
    expr.(ConditionDeclExpr).getVariableAccess() = ele and pred = "getVariableAccess()"
    or
    expr.(ConstructorFieldInit).getExpr() = ele and pred = "getExpr()"
    or
    expr.(Conversion).getExpr() = ele and pred = "getExpr()"
    or
    expr.(DeleteArrayExpr).getAllocatorCall() = ele and pred = "getAllocatorCall()"
    or
    expr.(DeleteArrayExpr).getDestructorCall() = ele and pred = "getDestructorCall()"
    or
    expr.(DeleteArrayExpr).getExpr() = ele and pred = "getExpr()"
    or
    expr.(DeleteExpr).getAllocatorCall() = ele and pred = "getAllocatorCall()"
    or
    expr.(DeleteExpr).getDestructorCall() = ele and pred = "getDestructorCall()"
    or
    expr.(DeleteExpr).getExpr() = ele and pred = "getExpr()"
    or
    expr.(DestructorFieldDestruction).getExpr() = ele and pred = "getExpr()"
    or
    expr.(FoldExpr).getInitExpr() = ele and pred = "getInitExpr()"
    or
    expr.(FoldExpr).getPackExpr() = ele and pred = "getPackExpr()"
    or
    expr.(LambdaExpression).getInitializer() = ele and pred = "getInitializer()"
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
    expr.(SizeofExprOperator).getExprOperand() = ele and pred = "getExprOperand()"
    or
    expr.(StmtExpr).getStmt() = ele and pred = "getStmt()"
    or
    expr.(ThrowExpr).getExpr() = ele and pred = "getExpr()"
    or
    expr.(TypeidOperator).getExpr() = ele and pred = "getExpr()"
  )
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
