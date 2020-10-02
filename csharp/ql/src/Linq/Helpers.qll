/**
 * Helpers.qll
 * Provides helper classes and methods related to LINQ.
 */

import csharp

//#################### PREDICATES ####################
private Stmt firstStmt(ForeachStmt fes) {
  if fes.getBody() instanceof BlockStmt
  then result = fes.getBody().(BlockStmt).getStmt(0)
  else result = fes.getBody()
}

private int numStmts(ForeachStmt fes) {
  if fes.getBody() instanceof BlockStmt
  then result = count(fes.getBody().(BlockStmt).getAStmt())
  else result = 1
}

/** Holds if the type's qualified name is "System.Linq.Enumerable" */
predicate isEnumerableType(ValueOrRefType t) { t.hasQualifiedName("System.Linq.Enumerable") }

/** Holds if the type's qualified name starts with "System.Collections.Generic.IEnumerable" */
predicate isIEnumerableType(ValueOrRefType t) {
  t.getQualifiedName().matches("System.Collections.Generic.IEnumerable%")
}

/**
 * Holds if `foreach` statement `fes` could be converted to a `.All()` call.
 * That is, the `ForeachStmt` contains a single `if` with a condition that
 * accesses the loop variable and with a body that assigns `false` to a variable
 * and `break`s out of the `foreach`.
 */
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

/**
 * Holds if `foreach` statement `fes` could be converted to a `.Cast()` call.
 * That is, the loop variable is accessed only in the first statement of the
 * block, and the access is a cast. The first statement needs to be a
 * `LocalVariableDeclStmt`.
 */
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

/**
 * Holds if `foreach` statement `fes` could be converted to an `.OfType()` call.
 * That is, the loop variable is accessed only in the first statement of the
 * block, and the access is a cast with the `as` operator. The first statement
 * needs to be a `LocalVariableDeclStmt`.
 */
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

/**
 * Holds if `foreach` statement `fes` could be converted to a `.Select()` call.
 * That is, the loop variable is accessed only in the first statement of the
 * block, and the access is not a cast. The first statement needs to be a
 * `LocalVariableDeclStmt`.
 */
predicate missedSelectOpportunity(ForeachStmt fes, LocalVariableDeclStmt s) {
  s = firstStmt(fes) and
  forex(VariableAccess va | va = fes.getVariable().getAnAccess() |
    va = s.getAVariableDeclExpr().getAChildExpr*()
  ) and
  not s.getAVariableDeclExpr().getInitializer() instanceof Cast
}

/**
 * Holds if `foreach` statement `fes` could be converted to a `.Where()` call.
 * That is, first statement of the loop is an `if`, which accesses the loop
 * variable, and the body of the `if` is either a `continue` or there's nothing
 * else in the loop than the `if`.
 */
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

/** A LINQ Count(...) call. */
class CountCall extends MethodCall {
  CountCall() {
    exists(Method m |
      m = getTarget() and
      isEnumerableType(m.getDeclaringType()) and
      m.hasName("Count")
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
