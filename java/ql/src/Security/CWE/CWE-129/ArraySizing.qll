import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.DefUse
import semmle.code.java.security.RandomDataSource
private import BoundingChecks

/**
 * If the `Array` accessed by the `ArrayAccess` is a fixed size, return the array size.
 */
int fixedArraySize(ArrayAccess arrayAccess) {
  exists(Variable v |
    v.getAnAccess() = arrayAccess.getArray() and
    result = v.getAnAssignedValue().(ArrayCreationExpr).getFirstDimensionSize()
  )
}

/**
 * Holds if an `ArrayIndexOutOfBoundsException` is ever caught.
 */
private predicate arrayIndexOutOfBoundExceptionCaught(ArrayAccess arrayAccess) {
  exists(TryStmt ts, CatchClause cc, RefType exc |
    (
      ts.getBlock().getAChild*() = arrayAccess.getEnclosingStmt() or
      ts.getAResourceDecl().getAChild*() = arrayAccess.getEnclosingStmt() or
      ts.getAResourceExpr().getAChildExpr*() = arrayAccess
    ) and
    cc = ts.getACatchClause() and
    exc = cc.getVariable().getType() and
    exc.hasQualifiedName("java.lang", "ArrayIndexOutOfBoundsException")
  )
}

/**
 * A pointless loop, of the type seen frequently in Juliet tests, of the form:
 *
 * ```
 *   while(true) {
 *     ...
 *     break;
 *   }
 * ```
 */
class PointlessLoop extends WhileStmt {
  PointlessLoop() {
    this.getCondition().(BooleanLiteral).getBooleanValue() = true and
    // The only `break` must be the last statement.
    forall(BreakStmt break | break.getTarget() = this |
      this.getStmt().(BlockStmt).getLastStmt() = break
    ) and
    // No `continue` statements.
    not exists(ContinueStmt continue | continue.getTarget() = this)
  }
}

/**
 * An `ArrayAccess` for which we can determine whether the index is appropriately bound checked.
 *
 * We only consider first dimension array accesses, and we only consider indices in loops, if it's
 * obvious that the loop only executes once.
 */
class CheckableArrayAccess extends ArrayAccess {
  CheckableArrayAccess() {
    // We are not interested in array accesses that don't access the first dimension.
    not this.getArray() instanceof ArrayAccess and
    // Array accesses within loops can make it difficult to verify whether the index is checked
    // prior to access. Ignore "pointless" loops of the sort found in Juliet test cases.
    not exists(LoopStmt loop |
      loop.getBody().getAChild*() = this.getEnclosingStmt() and
      not loop instanceof PointlessLoop
    ) and
    // The possible exception is not caught
    not arrayIndexOutOfBoundExceptionCaught(this)
  }

  /**
   * Holds if we believe this indexing expression can throw an `ArrayIndexOutOfBoundsException`.
   */
  predicate canThrowOutOfBounds(Expr index) {
    index = this.getIndexExpr() and
    not (
      // There is a condition dominating this expression ensuring that the index is >= 0.
      lowerBound(index) >= 0 and
      // There is a condition dominating this expression that ensures the index is less than the length.
      lessthanLength(this)
    )
  }

  /**
   * Holds if we believe this indexing expression can throw an `ArrayIndexOutOfBoundsException` due
   * to the array being initialized with `sizeExpr`, which may be zero.
   */
  predicate canThrowOutOfBoundsDueToEmptyArray(Expr sizeExpr, ArrayCreationExpr arrayCreation) {
    // Find an `ArrayCreationExpr` for the array used in this indexing operation.
    exists(VariableAssign assign |
      assign.getSource() = arrayCreation and
      defUsePair(assign, this.getArray())
    ) and
    // If the array access is protected by a conditional that verifies the index is less than the array
    // length, then the array will never be accessed if the size is zero.
    not lessthanLength(this) and
    // Verify that the size expression is never checked to be greater than 0.
    sizeExpr = arrayCreation.getDimension(0) and
    not lowerBound(sizeExpr) > 0
  }
}

/**
 * A source of "flow" which has an upper or lower bound.
 */
abstract class BoundedFlowSource extends DataFlow::Node {
  /**
   * Return a lower bound for the input, if possible.
   */
  abstract int lowerBound();

  /**
   * Return an upper bound for the input, if possible.
   */
  abstract int upperBound();

  /**
   * Return a description for this flow source, suitable for putting in an alert message.
   */
  abstract string getDescription();
}

/**
 * Input that is constructed using a random value.
 */
class RandomValueFlowSource extends BoundedFlowSource {
  RandomDataSource nextAccess;

  RandomValueFlowSource() { this.asExpr() = nextAccess }

  override int lowerBound() { result = nextAccess.getLowerBound() }

  override int upperBound() { result = nextAccess.getUpperBound() }

  override string getDescription() { result = "Random value" }
}

/**
 * A compile time constant expression that evaluates to a numeric type.
 */
class NumericLiteralFlowSource extends BoundedFlowSource {
  NumericLiteralFlowSource() { exists(this.asExpr().(CompileTimeConstantExpr).getIntValue()) }

  override int lowerBound() { result = this.asExpr().(CompileTimeConstantExpr).getIntValue() }

  override int upperBound() { result = this.asExpr().(CompileTimeConstantExpr).getIntValue() }

  override string getDescription() {
    result = "Literal value " + this.asExpr().(CompileTimeConstantExpr).getIntValue()
  }
}
