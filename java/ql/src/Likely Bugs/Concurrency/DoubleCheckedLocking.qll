import java
import semmle.code.java.dataflow.SSA

/**
 * Gets a read of `f`. Gets both direct reads and indirect reads through
 * assignment to a local variable.
 */
private Expr getAFieldRead(Field f) {
  result = f.getAnAccess()
  or
  exists(SsaExplicitUpdate v | v.getSourceVariable().getVariable() instanceof LocalScopeVariable |
    result = v.getAUse() and
    v.getDefiningExpr().(VariableAssign).getSource() = getAFieldRead(f)
  )
  or
  result.(AssignExpr).getSource() = getAFieldRead(f)
}

/**
 * Gets an expression that corresponds to `f == null`, either directly testing
 * `f` or indirectly through a local variable `(x = f) == null`.
 */
private Expr getANullCheck(Field f) {
  exists(EqualityTest eq | eq.polarity() = true |
    eq.hasOperands(any(NullLiteral nl), getAFieldRead(f)) and
    result = eq
  )
}

/**
 * Holds if the sequence `if1`-`sync`-`if2` corresponds to a double-checked
 * locking pattern for the field `f`. Fields with immutable types are excluded,
 * as they are always safe to initialize with double-checked locking.
 */
predicate doubleCheckedLocking(IfStmt if1, IfStmt if2, SynchronizedStmt sync, Field f) {
  if1.getThen() = sync.getEnclosingStmt*() and
  sync.getBlock() = if2.getEnclosingStmt*() and
  if1.getCondition() = getANullCheck(f) and
  if2.getCondition() = getANullCheck(f)
}
