/**
 * Provides pretty-printed representations of the AST, in particular top-level
 * classes and interfaces.
 */

import java

/**
 * Holds if the pretty-printed representation of `c` has the line `s` at line
 * number `line`.
 */
predicate pp(ClassOrInterface c, string s, int line) {
  not c instanceof NestedType and
  s =
    strictconcat(string part, int i |
      exists(PpAst e | getEnclosingAst*(e) = c | ppPart(e, part, line, i))
    |
      part order by i
    )
}

private PpAst getEnclosingAst(PpAst e) {
  e.(Expr).getEnclosingCallable() = result or
  e.(Stmt).getEnclosingCallable() = result or
  e.(Member).getDeclaringType() = result or
  e.(NestedType).getEnclosingType() = result
}

/**
 * An AST element to pretty-print. This is either an `Expr`, `Stmt`, `Class`,
 * `Interface`, or `Member`.
 *
 * Subclasses specify how they are printed by giving a sequence of printable
 * items. Each item in the sequence is either a string given by `getPart`, a
 * line break given by `newline`, or another AST element given by `getChild`.
 * The ordering of the sequence is given by the indices `i` in each of the
 * three predicates.
 */
private class PpAst extends Top {
  /** Gets the `i`th item to print. */
  string getPart(int i) { none() }

  /** Holds if the `i`th item to print is a line break. */
  predicate newline(int i) { none() }

  /** Gets the `i`th item to print. */
  PpAst getChild(int i) { none() }

  /**
   * Holds if the `i`th item to print is a `PpAst` given by `getChild(i)` and
   * that this should be indented.
   */
  predicate indents(int i) { none() }
}

/** Gets the indentation level of the AST element `e`. */
private int indentLevel(PpAst e) {
  exists(ClassOrInterface c | c = e and not c instanceof NestedType and result = 0)
  or
  exists(PpAst parent, int i, int lev |
    e = parent.getChild(i) and
    lev = indentLevel(parent) and
    if parent.indents(i) then result = lev + 1 else result = lev
  )
}

/**
 * Gets the `i`th item to print belonging to `e`. This is similar to
 * `e.getPart(i)`, but also include parentheses.
 */
private string getPart(PpAst e, int i) {
  result = e.getPart(i)
  or
  e.(Expr).isParenthesized() and
  (
    i = -1 + min(int j | exists(e.getPart(j)) or e.newline(j) or exists(e.getChild(j))) and
    result = "("
    or
    i = 1 + max(int j | exists(e.getPart(j)) or e.newline(j) or exists(e.getChild(j))) and
    result = ")"
  )
}

/**
 * Gets the number of string parts contained in `e` and recursively in its
 * children.
 */
language[monotonicAggregates]
private int numParts(PpAst e) {
  result =
    count(int i | exists(getPart(e, i))) +
      sum(PpAst child | child = e.getChild(_) | numParts(child))
}

/**
 * Gets the number of line breaks contained in `e` and recursively in its
 * children.
 */
language[monotonicAggregates]
private int numLines(PpAst e) {
  result = count(int i | e.newline(i)) + sum(PpAst child | child = e.getChild(_) | numLines(child))
}

/**
 * Gets an index to a string part, line break, or child in `e` with rank `r`.
 */
private int getIndex(PpAst e, int r) {
  result = rank[r](int i | exists(getPart(e, i)) or e.newline(i) or exists(e.getChild(i)))
}

/** Holds if the `ix`th item of `e` should be printed at `(line, pos)`. */
private predicate startPos(PpAst e, int ix, int line, int pos) {
  exists(ClassOrInterface c |
    c = e and not c instanceof NestedType and ix = getIndex(e, 1) and line = 0 and pos = 0
  )
  or
  exists(PpAst parent, int parix |
    startPos(parent, parix, line, pos) and e = parent.getChild(parix) and ix = getIndex(e, 1)
  )
  or
  exists(int prevIx, int r | prevIx = getIndex(e, r - 1) and ix = getIndex(e, r) |
    exists(getPart(e, prevIx)) and startPos(e, prevIx, line, pos - 1)
    or
    e.newline(prevIx) and startPos(e, prevIx, line - 1, _) and pos = 0
    or
    exists(PpAst child, int l, int p |
      child = e.getChild(prevIx) and
      startPos(e, prevIx, l, p) and
      line = l + numLines(child) and
      pos = p + numParts(child)
    )
  )
}

/**
 * Holds if the pretty-printed representation of `e` contributes `part` to occur
 * on `(line, pos)`. This does not include string parts belonging to children of
 * `e`.
 */
private predicate ppPart(PpAst e, string part, int line, int pos) {
  exists(int i | part = getPart(e, i) and startPos(e, i, line, pos))
  or
  exists(int i | exists(getPart(e, i)) or e.newline(i) |
    startPos(e, i, line, 0) and
    pos = -1 and
    part = concat(int ind | ind in [1 .. indentLevel(e)] | "  ")
  )
}

/*
 * Expressions
 */

private class PpArrayAccess extends PpAst, ArrayAccess {
  override string getPart(int i) {
    i = 1 and result = "["
    or
    i = 3 and result = "]"
  }

  override PpAst getChild(int i) {
    i = 0 and result = this.getArray()
    or
    i = 2 and result = this.getIndexExpr()
  }
}

private class PpArrayCreationExpr extends PpAst, ArrayCreationExpr {
  override string getPart(int i) {
    i = 0 and result = "new "
    or
    i = 1 and result = this.baseType()
    or
    i = 2 + 3 * this.dimensionIndex() and result = "["
    or
    i = 4 + 3 * this.dimensionIndex() and result = "]"
    or
    i = 4 + 3 * this.exprDims() + [1 .. this.nonExprDims()] and result = "[]"
  }

  private string baseType() { result = this.getType().(Array).getElementType().toString() }

  private int dimensionIndex() { exists(this.getDimension(result)) }

  private int exprDims() { result = max(int j | j = 0 or j = 1 + this.dimensionIndex()) }

  private int nonExprDims() { result = this.getType().(Array).getDimension() - this.exprDims() }

  override PpAst getChild(int i) {
    exists(int j | result = this.getDimension(j) and i = 3 + 3 * j)
    or
    i = 5 + 3 * this.exprDims() + this.nonExprDims() and result = this.getInit()
  }
}

private class PpArrayInit extends PpAst, ArrayInit {
  override string getPart(int i) {
    i = 0 and result = "{ "
    or
    exists(int j | exists(this.getInit(j)) and j != 0 and i = 2 * j and result = ", ")
    or
    i = 2 + 2 * max(int j | exists(this.getInit(j)) or j = 0) and result = " }"
  }

  override PpAst getChild(int i) { exists(int j | result = this.getInit(j) and i = 1 + 2 * j) }
}

private class PpAssignment extends PpAst, Assignment {
  override string getPart(int i) {
    i = 1 and
    this instanceof AssignExpr and
    result = " = "
    or
    i = 1 and
    result = " " + this.(AssignOp).getOp() + " "
  }

  override PpAst getChild(int i) {
    i = 0 and result = this.getDest()
    or
    i = 2 and result = this.getRhs()
  }
}

private class PpLiteral extends PpAst, Literal {
  override string getPart(int i) { i = 0 and result = this.getLiteral() }
}

private class PpBinaryExpr extends PpAst, BinaryExpr {
  override string getPart(int i) { i = 1 and result = this.getOp() }

  override PpAst getChild(int i) {
    i = 0 and result = this.getLeftOperand()
    or
    i = 2 and result = this.getRightOperand()
  }
}

private class PpUnaryExpr extends PpAst, UnaryExpr {
  override string getPart(int i) {
    i = 0 and result = "++" and this instanceof PreIncExpr
    or
    i = 0 and result = "--" and this instanceof PreDecExpr
    or
    i = 0 and result = "-" and this instanceof MinusExpr
    or
    i = 0 and result = "+" and this instanceof PlusExpr
    or
    i = 0 and result = "~" and this instanceof BitNotExpr
    or
    i = 0 and result = "!" and this instanceof LogNotExpr
    or
    i = 2 and result = "++" and this instanceof PostIncExpr
    or
    i = 2 and result = "--" and this instanceof PostDecExpr
  }

  override PpAst getChild(int i) { i = 1 and result = this.getExpr() }
}

private class PpCastExpr extends PpAst, CastExpr {
  override string getPart(int i) {
    i = 0 and result = "("
    or
    i = 2 and result = ")"
  }

  override PpAst getChild(int i) {
    i = 1 and result = this.getTypeExpr()
    or
    i = 3 and result = this.getExpr()
  }
}

private class PpCall extends PpAst, Call {
  override string getPart(int i) {
    i = 1 and exists(this.getQualifier()) and result = "."
    or
    i = 2 and
    (
      result = this.(MethodAccess).getMethod().getName()
      or
      result = "this" and this instanceof ThisConstructorInvocationStmt
      or
      result = "super" and this instanceof SuperConstructorInvocationStmt
      or
      result = "new " and this instanceof ClassInstanceExpr and not this instanceof FunctionalExpr
      or
      result = "new /* -> */ " and this instanceof LambdaExpr
      or
      result = "new /* :: */ " and this instanceof MemberRefExpr
    )
    or
    i = 4 and result = "("
    or
    exists(int argi |
      exists(this.getArgument(argi)) and argi != 0 and i = 4 + 2 * argi and result = ", "
    )
    or
    i = 5 + 2 * this.getNumArgument() and result = ")"
    or
    i = 6 + 2 * this.getNumArgument() and result = ";" and this instanceof Stmt
    or
    i = 6 + 2 * this.getNumArgument() and
    result = " " and
    exists(this.(ClassInstanceExpr).getAnonymousClass())
  }

  override PpAst getChild(int i) {
    i = 0 and result = this.getQualifier()
    or
    i = 3 and result = this.(ClassInstanceExpr).getTypeName()
    or
    exists(int argi | i = 5 + 2 * argi and result = this.getArgument(argi))
    or
    i = 7 + 2 * this.getNumArgument() and result = this.(ClassInstanceExpr).getAnonymousClass()
  }
}

private class PpConditionalExpr extends PpAst, ConditionalExpr {
  override string getPart(int i) {
    i = 1 and result = " ? "
    or
    i = 3 and result = " : "
  }

  override PpAst getChild(int i) {
    i = 0 and result = this.getCondition()
    or
    i = 2 and result = this.getTrueExpr()
    or
    i = 4 and result = this.getFalseExpr()
  }
}

private class PpSwitchExpr extends PpAst, SwitchExpr {
  override string getPart(int i) {
    i = 0 and result = "switch ("
    or
    i = 2 and result = ") {"
    or
    i = 4 + 2 * count(this.getAStmt()) and result = "}"
  }

  override predicate newline(int i) { i = 3 or this.hasChildAt(_, i - 1) }

  override PpAst getChild(int i) {
    i = 1 and result = this.getExpr()
    or
    this.hasChildAt(result, i)
  }

  override predicate indents(int i) { this.hasChildAt(_, i) }

  private predicate hasChildAt(PpAst c, int i) {
    exists(int index | c = this.getStmt(index) and i = 4 + 2 * index)
  }
}

private class PpInstanceOfExpr extends PpAst, InstanceOfExpr {
  override string getPart(int i) {
    i = 1 and result = " instanceof "
    or
    i = 3 and result = " " and this.isPattern()
    or
    i = 4 and result = this.getLocalVariableDeclExpr().getName()
  }

  override PpAst getChild(int i) {
    i = 0 and result = this.getExpr()
    or
    i = 2 and result = this.getTypeName()
  }
}

private class PpLocalVariableDeclExpr extends PpAst, LocalVariableDeclExpr {
  override string getPart(int i) {
    i = 0 and result = this.getName()
    or
    i = 1 and result = " = " and exists(this.getInit())
  }

  override PpAst getChild(int i) { i = 2 and result = this.getInit() }
}

private class PpTypeLiteral extends PpAst, TypeLiteral {
  override string getPart(int i) { i = 1 and result = ".class" }

  override PpAst getChild(int i) { i = 0 and result = this.getTypeName() }
}

private class PpThisAccess extends PpAst, ThisAccess {
  override string getPart(int i) {
    i = 1 and
    if exists(this.getQualifier()) then result = ".this" else result = "this"
  }

  override PpAst getChild(int i) { i = 0 and result = this.getQualifier() }
}

private class PpSuperAccess extends PpAst, SuperAccess {
  override string getPart(int i) {
    i = 1 and
    if exists(this.getQualifier()) then result = ".super" else result = "super"
  }

  override PpAst getChild(int i) { i = 0 and result = this.getQualifier() }
}

private class PpVarAccess extends PpAst, VarAccess {
  override string getPart(int i) {
    exists(string name | name = this.(VarAccess).getVariable().getName() and i = 1 |
      if exists(this.getQualifier()) then result = "." + name else result = name
    )
  }

  override PpAst getChild(int i) { i = 0 and result = this.getQualifier() }
}

private class PpTypeAccess extends PpAst, TypeAccess {
  override string getPart(int i) { i = 0 and result = this.toString() }
}

private class PpArrayTypeAccess extends PpAst, ArrayTypeAccess {
  override string getPart(int i) { i = 1 and result = "[]" }

  override PpAst getChild(int i) { i = 0 and result = this.getComponentName() }
}

private class PpUnionTypeAccess extends PpAst, UnionTypeAccess {
  override string getPart(int i) {
    exists(int j | i = 2 * j - 1 and j != 0 and result = " | " and exists(this.getAlternative(j)))
  }

  private Expr getAlternative(int j) { result = this.getAnAlternative() and j = result.getIndex() }

  override PpAst getChild(int i) { exists(int j | i = 2 * j and result = this.getAlternative(j)) }
}

private class PpIntersectionTypeAccess extends PpAst, IntersectionTypeAccess {
  override string getPart(int i) {
    exists(int j | i = 2 * j - 1 and j != 0 and result = " & " and exists(this.getBound(j)))
  }

  override PpAst getChild(int i) { exists(int j | i = 2 * j and result = this.getBound(j)) }
}

private class PpPackageAccess extends PpAst, PackageAccess {
  override string getPart(int i) { i = 0 and result = "package" }
}

private class PpWildcardTypeAccess extends PpAst, WildcardTypeAccess {
  override string getPart(int i) {
    i = 0 and result = "?"
    or
    i = 1 and result = " extends " and exists(this.getUpperBound())
    or
    i = 1 and result = " super " and exists(this.getLowerBound())
  }

  override PpAst getChild(int i) {
    i = 2 and result = this.getUpperBound()
    or
    i = 2 and result = this.getLowerBound()
  }
}

/*
 * Statements
 */

private class PpBlock extends PpAst, BlockStmt {
  override string getPart(int i) {
    i = 0 and result = "{"
    or
    i = 2 + 2 * this.getNumStmt() and result = "}"
  }

  override predicate newline(int i) { i = 1 or this.hasChildAt(_, i - 1) }

  override PpAst getChild(int i) { this.hasChildAt(result, i) }

  override predicate indents(int i) { this.hasChildAt(_, i) }

  private predicate hasChildAt(PpAst c, int i) {
    exists(int index | c = this.getStmt(index) and i = 2 + 2 * index)
  }
}

private class PpIfStmt extends PpAst, IfStmt {
  override string getPart(int i) {
    i = 0 and result = "if ("
    or
    i = 2 and result = ")"
    or
    i = 3 and result = " " and this.getThen() instanceof BlockStmt
    or
    exists(this.getElse()) and
    (
      i = 5 and result = " " and this.getThen() instanceof BlockStmt
      or
      i = 6 and result = "else"
      or
      i = 7 and result = " " and this.getElse() instanceof BlockStmt
    )
  }

  override predicate newline(int i) {
    i = 3 and not this.getThen() instanceof BlockStmt
    or
    exists(this.getElse()) and
    (
      i = 5 and not this.getThen() instanceof BlockStmt
      or
      i = 7 and not this.getElse() instanceof BlockStmt
    )
  }

  override PpAst getChild(int i) {
    i = 1 and result = this.getCondition()
    or
    i = 4 and result = this.getThen()
    or
    i = 8 and result = this.getElse()
  }

  override predicate indents(int i) {
    i = 4 and not this.getThen() instanceof BlockStmt
    or
    i = 8 and not this.getElse() instanceof BlockStmt
  }
}

private class PpForStmt extends PpAst, ForStmt {
  override string getPart(int i) {
    i = 0 and result = "for ("
    or
    i = 2 and result = " " and this.getInit(0) instanceof LocalVariableDeclExpr
    or
    exists(int j | j > 0 and exists(this.getInit(j)) and i = 2 + 2 * j and result = ", ")
    or
    i = 1 + this.lastInitIndex() and result = "; "
    or
    i = 3 + this.lastInitIndex() and result = "; "
    or
    exists(int j |
      j > 0 and exists(this.getUpdate(j)) and i = 3 + this.lastInitIndex() + 2 * j and result = ", "
    )
    or
    i = 1 + this.lastUpdateIndex() and result = ")"
    or
    i = 2 + this.lastUpdateIndex() and result = " " and this.getStmt() instanceof BlockStmt
  }

  private int lastInitIndex() { result = 3 + 2 * max(int j | exists(this.getInit(j))) }

  private int lastUpdateIndex() {
    result = 4 + this.lastInitIndex() + 2 * max(int j | exists(this.getUpdate(j)))
  }

  override predicate newline(int i) {
    i = 2 + this.lastUpdateIndex() and not this.getStmt() instanceof BlockStmt
  }

  override PpAst getChild(int i) {
    i = 1 and result = this.getInit(0).(LocalVariableDeclExpr).getTypeAccess()
    or
    exists(int j | result = this.getInit(j) and i = 3 + 2 * j)
    or
    i = 2 + this.lastInitIndex() and result = this.getCondition()
    or
    exists(int j | result = this.getUpdate(j) and i = 4 + this.lastInitIndex() + 2 * j)
    or
    i = 3 + this.lastUpdateIndex() and result = this.getStmt()
  }

  override predicate indents(int i) {
    i = 3 + this.lastUpdateIndex() and not this.getStmt() instanceof BlockStmt
  }
}

private class PpEnhancedForStmt extends PpAst, EnhancedForStmt {
  override string getPart(int i) {
    i = 0 and result = "for ("
    or
    i = 2 and result = " "
    or
    i = 4 and result = " : "
    or
    i = 6 and
    if this.getStmt() instanceof BlockStmt then result = ") " else result = ")"
  }

  override PpAst getChild(int i) {
    i = 1 and result = this.getVariable().getTypeAccess()
    or
    i = 3 and result = this.getVariable()
    or
    i = 5 and result = this.getExpr()
    or
    i = 7 and result = this.getStmt()
  }

  override predicate indents(int i) { i = 7 and not this.getStmt() instanceof BlockStmt }
}

private class PpWhileStmt extends PpAst, WhileStmt {
  override string getPart(int i) {
    i = 0 and result = "while ("
    or
    i = 2 and result = ")"
    or
    i = 3 and result = " " and this.getStmt() instanceof BlockStmt
  }

  override predicate newline(int i) { i = 3 and not this.getStmt() instanceof BlockStmt }

  override PpAst getChild(int i) {
    i = 1 and result = this.getCondition()
    or
    i = 4 and result = this.getStmt()
  }

  override predicate indents(int i) { i = 4 and not this.getStmt() instanceof BlockStmt }
}

private class PpDoStmt extends PpAst, DoStmt {
  override string getPart(int i) {
    i = 0 and result = "do"
    or
    i in [1, 3] and result = " " and this.getStmt() instanceof BlockStmt
    or
    i = 4 and result = "while ("
    or
    i = 6 and result = ");"
  }

  override predicate newline(int i) { i in [1, 3] and not this.getStmt() instanceof BlockStmt }

  override PpAst getChild(int i) {
    i = 2 and result = this.getStmt()
    or
    i = 5 and result = this.getCondition()
  }

  override predicate indents(int i) { i = 2 and not this.getStmt() instanceof BlockStmt }
}

private class PpTryStmt extends PpAst, TryStmt {
  override string getPart(int i) {
    i = 0 and result = "try "
    or
    i = 1 and result = "(" and exists(this.getAResource())
    or
    exists(int j | exists(this.getResourceExpr(j)) and i = 3 + 2 * j and result = ";")
    or
    i = 2 + this.lastResourceIndex() and result = ") " and exists(this.getAResource())
    or
    i = 1 + this.lastCatchIndex() and result = " finally " and exists(this.getFinally())
  }

  private int lastResourceIndex() {
    result = 2 + 2 * max(int j | exists(this.getResource(j)) or j = 0)
  }

  private int lastCatchIndex() {
    result = 4 + this.lastResourceIndex() + max(int j | exists(this.getCatchClause(j)) or j = 0)
  }

  override PpAst getChild(int i) {
    exists(int j | i = 2 + 2 * j and result = this.getResource(j))
    or
    i = 3 + this.lastResourceIndex() and result = this.getBlock()
    or
    exists(int j | i = 4 + this.lastResourceIndex() + j and result = this.getCatchClause(j))
    or
    i = 2 + this.lastCatchIndex() and result = this.getFinally()
  }
}

private class PpCatchClause extends PpAst, CatchClause {
  override string getPart(int i) {
    i = 0 and result = " catch ("
    or
    i = 2 and result = " "
    or
    i = 4 and result = ") "
  }

  override PpAst getChild(int i) {
    i = 1 and result = this.getVariable().getTypeAccess()
    or
    i = 3 and result = this.getVariable()
    or
    i = 5 and result = this.getBlock()
  }
}

private class PpSwitchStmt extends PpAst, SwitchStmt {
  override string getPart(int i) {
    i = 0 and result = "switch ("
    or
    i = 2 and result = ") {"
    or
    i = 4 + 2 * count(this.getAStmt()) and result = "}"
  }

  override predicate newline(int i) { i = 3 or this.hasChildAt(_, i - 1) }

  override PpAst getChild(int i) {
    i = 1 and result = this.getExpr()
    or
    this.hasChildAt(result, i)
  }

  override predicate indents(int i) { this.hasChildAt(_, i) }

  private predicate hasChildAt(PpAst c, int i) {
    exists(int index | c = this.getStmt(index) and i = 4 + 2 * index)
  }
}

private class PpSwitchCase extends PpAst, SwitchCase {
  override string getPart(int i) {
    i = 0 and result = "default" and this instanceof DefaultCase
    or
    i = 0 and result = "case " and this instanceof ConstCase
    or
    exists(int j | i = 2 * j and j != 0 and result = ", " and exists(this.(ConstCase).getValue(j)))
    or
    i = 1 + this.lastConstCaseValueIndex() and result = ":" and not this.isRule()
    or
    i = 1 + this.lastConstCaseValueIndex() and result = " -> " and this.isRule()
    or
    i = 3 + this.lastConstCaseValueIndex() and result = ";" and exists(this.getRuleExpression())
  }

  private int lastConstCaseValueIndex() {
    result = 1 + 2 * max(int j | j = 0 or exists(this.(ConstCase).getValue(j)))
  }

  override PpAst getChild(int i) {
    exists(int j | i = 1 + 2 * j and result = this.(ConstCase).getValue(j))
    or
    i = 2 + this.lastConstCaseValueIndex() and result = this.getRuleExpression()
    or
    i = 2 + this.lastConstCaseValueIndex() and result = this.getRuleStatement()
  }
}

private class PpSynchronizedStmt extends PpAst, SynchronizedStmt {
  override string getPart(int i) {
    i = 0 and result = "synchronized ("
    or
    i = 2 and result = ")"
    or
    i = 3 and result = " "
  }

  override PpAst getChild(int i) {
    i = 1 and result = this.getExpr()
    or
    i = 4 and result = this.getBlock()
  }
}

private class PpReturnStmt extends PpAst, ReturnStmt {
  override string getPart(int i) {
    if exists(this.getResult())
    then
      i = 0 and result = "return "
      or
      i = 2 and result = ";"
    else (
      i = 0 and result = "return;"
    )
  }

  override PpAst getChild(int i) { i = 1 and result = this.getResult() }
}

private class PpThrowStmt extends PpAst, ThrowStmt {
  override string getPart(int i) {
    i = 0 and result = "throw "
    or
    i = 2 and result = ";"
  }

  override PpAst getChild(int i) { i = 1 and result = this.getExpr() }
}

private class PpBreakStmt extends PpAst, BreakStmt {
  override string getPart(int i) {
    i = 0 and result = "break"
    or
    i = 1 and result = " " and exists(this.getLabel())
    or
    i = 2 and result = this.getLabel()
    or
    i = 3 and result = ";"
  }
}

private class PpYieldStmt extends PpAst, YieldStmt {
  override string getPart(int i) {
    i = 0 and result = "yield "
    or
    i = 2 and result = ";"
  }

  override PpAst getChild(int i) { i = 1 and result = this.getValue() }
}

private class PpContinueStmt extends PpAst, ContinueStmt {
  override string getPart(int i) {
    i = 0 and result = "continue"
    or
    i = 1 and result = " " and exists(this.getLabel())
    or
    i = 2 and result = this.getLabel()
    or
    i = 3 and result = ";"
  }
}

private class PpEmptyStmt extends PpAst, EmptyStmt {
  override string getPart(int i) { i = 0 and result = ";" }
}

private class PpExprStmt extends PpAst, ExprStmt {
  override string getPart(int i) { i = 1 and result = ";" }

  override PpAst getChild(int i) { i = 0 and result = this.getExpr() }
}

private class PpLabeledStmt extends PpAst, LabeledStmt {
  override string getPart(int i) {
    i = 0 and result = this.getLabel()
    or
    i = 1 and result = ":"
  }

  override predicate newline(int i) { i = 2 }

  override PpAst getChild(int i) { i = 3 and result = this.getStmt() }
}

private class PpAssertStmt extends PpAst, AssertStmt {
  override string getPart(int i) {
    i = 0 and result = "assert "
    or
    i = 2 and result = " : " and exists(this.getMessage())
    or
    i = 4 and result = ";"
  }

  override PpAst getChild(int i) {
    i = 1 and result = this.getExpr()
    or
    i = 3 and result = this.getMessage()
  }
}

private class PpLocalVariableDeclStmt extends PpAst, LocalVariableDeclStmt {
  override string getPart(int i) {
    i = 1 and result = " "
    or
    exists(int v | v > 1 and i = 2 * v - 1 and result = ", " and v = this.getAVariableIndex())
    or
    i = 2 * max(this.getAVariableIndex()) + 1 and result = ";"
  }

  override PpAst getChild(int i) {
    i = 0 and result = this.getAVariable().getTypeAccess()
    or
    exists(int v | i = 2 * v and result = this.getVariable(v))
  }
}

private class PpLocalTypeDeclStmt extends PpAst, LocalTypeDeclStmt {
  override PpAst getChild(int i) { i = 0 and result = this.getLocalType() }
}

/*
 * Classes, interfaces, and members
 */

private string getMemberId(Member m) {
  result = m.(Callable).getSignature()
  or
  result = m.getName() and not m instanceof Callable
}

private class PpClassOrInterface extends PpAst, ClassOrInterface {
  override string getPart(int i) {
    not this instanceof AnonymousClass and
    (
      result = getModifierPart(this, i)
      or
      i = 0 and result = "class " and this instanceof Class
      or
      i = 0 and result = "interface " and this instanceof Interface
      or
      i = 1 and result = this.getName()
      or
      i = 2 and result = " "
    )
    or
    i = 3 and result = "{"
    or
    i = 5 + 3 * max(this.memberRank(_)) and result = "}"
  }

  override predicate newline(int i) {
    exists(int ci | ci = 3 + 3 * this.memberRank(_) | i = ci - 1 or i = ci + 1)
  }

  private int memberRank(Member member) {
    member =
      rank[result](Member m |
        m = this.getAMember()
      |
        m order by m.getLocation().getStartLine(), m.getLocation().getStartColumn(), getMemberId(m)
      )
  }

  override PpAst getChild(int i) { this.memberRank(result) * 3 + 3 = i }

  override predicate indents(int i) { this.memberRank(_) * 3 + 3 = i }
}

private string getModifierPart(Modifiable m, int i) {
  m.isAbstract() and result = "abstract " and i = -12
  or
  m.isPublic() and result = "public " and i = -11
  or
  m.isProtected() and result = "protected " and i = -10
  or
  m.isPrivate() and result = "private " and i = -9
  or
  m.isStatic() and result = "static " and i = -8
  or
  m.isFinal() and result = "final " and i = -7
  or
  m.isVolatile() and result = "volatile " and i = -6
  or
  m.isSynchronized() and result = "synchronized " and i = -5
  or
  m.isNative() and result = "native " and i = -4
  or
  m.isDefault() and result = "default " and i = -3
  or
  m.isTransient() and result = "transient " and i = -2
  or
  m.isStrictfp() and result = "strictfp " and i = -1
}

private class PpField extends PpAst, Field {
  override string getPart(int i) {
    result = getModifierPart(this, i)
    or
    i = 0 and result = this.getType().toString()
    or
    i = 1 and result = " "
    or
    i = 2 and result = this.getName()
    or
    i = 3 and result = ";"
  }
}

private class PpCallable extends PpAst, Callable {
  override string getPart(int i) {
    result = getModifierPart(this, i)
    or
    i = 0 and result = this.getReturnType().toString() and this instanceof Method
    or
    i = 1 and result = " " and this instanceof Method
    or
    i = 2 and
    (if this.getName() = "" then result = "<no name>" else result = this.getName())
    or
    i = 3 and result = "("
    or
    exists(Parameter p, int n | this.getParameter(n) = p |
      i = 4 + 4 * n and result = p.getType().toString()
      or
      i = 5 + 4 * n and result = " "
      or
      i = 6 + 4 * n and result = p.getName()
      or
      i = 7 + 4 * n and result = ", " and n < this.getNumberOfParameters() - 1
    )
    or
    i = 4 + 4 * this.getNumberOfParameters() and result = ") "
    or
    i = 5 + 4 * this.getNumberOfParameters() and
    not exists(this.getBody()) and
    result = "{ <missing body> }"
  }

  override PpAst getChild(int i) {
    i = 5 + 4 * this.getNumberOfParameters() and result = this.getBody()
  }
}
