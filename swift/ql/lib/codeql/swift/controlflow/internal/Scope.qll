private import swift

module CallableBase {
  class TypeRange = @abstract_function_decl;

  class Range extends Scope::Range, TypeRange { }
}

module Callable {
  class TypeRange = CallableBase::TypeRange;

  class Range extends Scope::Range, TypeRange { }
}

private module Scope {
  class TypeRange = Callable::TypeRange;

  class Range extends AstNode, TypeRange {
    Range getOuterScope() { result = scopeOfAst(this) }
  }
}

class Scope extends AstNode instanceof Scope::Range {
  /** Gets the scope in which this scope is nested, if any. */
  Scope getOuterScope() { result = super.getOuterScope() }
}

cached
private module Cached {
  private AstNode getChild(AstNode ast) {
    result = ast.(TopLevelCodeDecl).getBody()
    or
    result = ast.(AnyTryExpr).getSubExpr()
    or
    result = ast.(ClosureExpr).getBody()
    or
    result = ast.(ExplicitCastExpr).getSubExpr()
    or
    result = ast.(ForceValueExpr).getSubExpr()
    or
    result = ast.(IdentityExpr).getSubExpr()
    or
    result = ast.(ImplicitConversionExpr).getSubExpr()
    or
    result = ast.(InOutExpr).getSubExpr()
    or
    result = ast.(MemberRefExpr).getBaseExpr()
    or
    result = ast.(SelfApplyExpr).getBaseExpr()
    or
    result = ast.(VarargExpansionExpr).getSubExpr()
    or
    result = ast.(BindingPattern).getSubPattern()
    or
    result = ast.(EnumElementPattern).getSubPattern()
    or
    result = ast.(ExprPattern).getSubExpr()
    or
    result = ast.(IsPattern).getSubPattern()
    or
    result = ast.(OptionalSomePattern).getSubPattern()
    or
    result = ast.(ParenPattern).getSubPattern()
    or
    result = ast.(TypedPattern).getSubPattern()
    or
    result = ast.(DeferStmt).getBody()
    or
    result = ast.(DoStmt).getBody()
    or
    result = ast.(ReturnStmt).getResult()
    or
    result = ast.(ThrowStmt).getSubExpr()
  }

  cached
  AstNode getChild(AstNode ast, int index) {
    exists(AbstractFunctionDecl afd | afd = ast |
      index = -1 and
      result = afd.getBody()
      or
      result = afd.getParam(index)
    )
    or
    result = ast.(EnumCaseDecl).getElement(index)
    or
    result = ast.(EnumElementDecl).getParam(index)
    or
    exists(PatternBindingDecl pbd, int i | pbd = ast |
      index = 2 * i and
      result = pbd.getPattern(i)
      or
      index = 2 * i + 1 and
      result = pbd.getInit(i)
    )
    or
    exists(ApplyExpr apply | apply = ast |
      index = -1 and
      result = apply.getFunction()
      or
      result = apply.getArgument(index).getExpr()
    )
    or
    result = ast.(ArrayExpr).getElement(index)
    or
    // `x` is evaluated before `y` in `x = y`.
    exists(AssignExpr assign | assign = ast |
      index = 0 and
      result = assign.getDest()
      or
      index = 1 and
      result = assign.getSource()
    )
    or
    exists(BinaryExpr binary | binary = ast |
      index = 0 and
      result = binary.getLeftOperand()
      or
      index = 1 and
      result = binary.getRightOperand()
    )
    or
    // TODO: There are two other getters. Should they be included?
    exists(InterpolatedStringLiteralExpr interpolated | interpolated = ast |
      index = 0 and
      result = interpolated.getInterpolationExpr()
      or
      index = 1 and
      result = interpolated.getAppendingExpr()
    )
    or
    exists(KeyPathExpr kp | kp = ast |
      index = 0 and
      result = kp.getParsedRoot()
      or
      index = 1 and
      result = kp.getParsedPath()
    )
    or
    exists(SubscriptExpr sub | sub = ast |
      index = -1 and
      result = sub.getBaseExpr()
      or
      result = sub.getArgument(index).getExpr()
    )
    or
    exists(TapExpr tap | tap = ast |
      index = 0 and
      result = tap.getVar()
      or
      index = 1 and
      result = tap.getSubExpr()
      or
      index = 2 and
      result = tap.getBody()
    )
    or
    result = ast.(TupleExpr).getElement(index)
    or
    result = ast.(TuplePattern).getElement(index)
    or
    result = ast.(BraceStmt).getElement(index)
    or
    exists(CaseStmt case | case = ast |
      index = -1 and
      result = case.getBody()
      or
      result = case.getLabel(index)
      or
      index >= case.getNumberOfLabels() and
      result = case.getVariable(case.getNumberOfLabels() - index)
    )
    or
    exists(DoCatchStmt catch | catch = ast |
      index = -1 and
      result = catch.getBody()
      or
      result = catch.getCatch(index)
    )
    or
    exists(ForEachStmt forEach | forEach = ast |
      index = 0 and
      result = forEach.getWhere()
      or
      index = 1 and
      result = forEach.getBody()
    )
    or
    exists(GuardStmt guard | guard = ast |
      index = 0 and
      result = guard.getBody()
      or
      index = 1 and
      result = guard.getCondition()
    )
    or
    exists(StmtCondition stmtCond | stmtCond = ast |
      index = 0 and
      result = stmtCond.getElement(index).getPattern()
      or
      index = 1 and
      result = stmtCond.getElement(index).getInitializer()
      or
      index = 2 and
      result = stmtCond.getElement(index).getBoolean()
    )
    or
    exists(IfStmt ifStmt | ifStmt = ast |
      index = 0 and
      result = ifStmt.getCondition().getFullyUnresolved()
      or
      index = 1 and
      result = ifStmt.getThen()
      or
      index = 2 and
      result = ifStmt.getElse()
    )
    or
    exists(RepeatWhileStmt repeat | repeat = ast |
      index = 0 and
      result = repeat.getCondition()
      or
      index = 1 and
      result = repeat.getBody()
    )
    or
    exists(SwitchStmt switch | switch = ast |
      index = -1 and
      result = switch.getExpr()
      or
      result = switch.getCase(index)
    )
    or
    exists(WhileStmt while | while = ast |
      index = 0 and
      result = while.getCondition().getFullyUnresolved()
      or
      index = 1 and
      result = while.getBody()
    )
    or
    index = 0 and
    result = getChild(ast)
  }

  cached
  AstNode getParentOfAst(AstNode ast) { getChild(result, _) = ast }
}

/** Gets the enclosing scope of a node */
cached
AstNode scopeOfAst(AstNode n) {
  exists(AstNode p | p = getParentOfAst(n) |
    if p instanceof Scope then p = result else result = scopeOfAst(p)
  )
}

import Cached
