/**
 * Helpers.qll
 * Provides helper classes and methods related to LINQ.
 */

import csharp

//#################### PREDICATES ####################
Stmt firstStmt(ForeachStmt fes) {
  if fes.getBody() instanceof BlockStmt
  then result = fes.getBody().(BlockStmt).getStmt(0)
  else result = fes.getBody()
}

predicate isEnumerableType(ValueOrRefType t) { t.hasQualifiedName("System.Linq.Enumerable") }

predicate isIEnumerableType(ValueOrRefType t) {
  t.getQualifiedName().matches("System.Collections.Generic.IEnumerable%")
}

predicate missedAllOpportunity(ForeachStmt fes) {
  exists(IfStmt is |
    // The loop contains an if statement with no else case, and nothing else.
    is = firstStmt(fes) and
    numStmts(fes) = 1 and
    not exists(is.getElse()) and
    // The if statement accesses the loop variable.
    is.getCondition().getAChildExpr*() = fes.getVariable().getAnAccess() and
    // The then case of the if assigns false to something and breaks out of the loop.
    exists(Assignment a, BoolLiteral bl |
      a = is.getThen().getAChild*() and
      bl = a.getRValue() and
      bl.toString() = "false"
    ) and
    exists(BreakStmt bs | bs = is.getThen().getAChild*())
  )
}

predicate missedCastOpportunity(ForeachStmt fes, LocalVariableDeclStmt s) {
  s = firstStmt(fes) and
  forex(VariableAccess va | va = fes.getVariable().getAnAccess() |
    va = s.getAVariableDeclExpr().getAChildExpr*()
  ) and
  exists(CastExpr ce |
    ce = s.getAVariableDeclExpr().getInitializer() and
    ce.getExpr() = fes.getVariable().getAnAccess()
  )
}

predicate missedOfTypeOpportunity(ForeachStmt fes, LocalVariableDeclStmt s) {
  s = firstStmt(fes) and
  forex(VariableAccess va | va = fes.getVariable().getAnAccess() |
    va = s.getAVariableDeclExpr().getAChildExpr*()
  ) and
  exists(AsExpr ae |
    ae = s.getAVariableDeclExpr().getInitializer() and
    ae.getExpr() = fes.getVariable().getAnAccess()
  )
}

predicate missedSelectOpportunity(ForeachStmt fes, LocalVariableDeclStmt s) {
  s = firstStmt(fes) and
  forex(VariableAccess va | va = fes.getVariable().getAnAccess() |
    va = s.getAVariableDeclExpr().getAChildExpr*()
  ) and
  not s.getAVariableDeclExpr().getInitializer() instanceof Cast
}

predicate missedWhereOpportunity(ForeachStmt fes, IfStmt is) {
  // The very first thing the foreach loop does is test its iteration variable.
  is = firstStmt(fes) and
  exists(VariableAccess va |
    va.getTarget() = fes.getVariable() and
    va = is.getCondition().getAChildExpr*()
  ) and
  // It then either (a) continues, or (b) performs the entire body of the loop within the condition.
  (
    is.getThen() instanceof ContinueStmt
    or
    not exists(is.getElse()) and
    numStmts(fes) = 1
  )
}

int numStmts(ForeachStmt fes) {
  if fes.getBody() instanceof BlockStmt
  then result = count(fes.getBody().(BlockStmt).getAStmt())
  else result = 1
}

//#################### CLASSES ####################
/** A LINQ Any(...) call. */
class AnyCall extends MethodCall {
  AnyCall() {
    exists(Method m |
      m = getTarget() and
      isEnumerableType(m.getDeclaringType()) and
      m.hasName("Any")
    )
  }
}

/** A variable of type IEnumerable&lt;T>, for some T. */
class IEnumerableSequence extends Variable {
  IEnumerableSequence() { isIEnumerableType(getType()) }
}

/** A LINQ Select(...) call. */
class SelectCall extends ExtensionMethodCall {
  SelectCall() {
    exists(Method m |
      m = getTarget() and
      isEnumerableType(m.getDeclaringType()) and
      m.hasName("Select")
    )
  }

  /** Gets the anonymous function expression supplied as the argument to the Select (if possible). */
  AnonymousFunctionExpr getFunctionExpr() { result = getArgument(1) }
}
