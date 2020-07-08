import java
import semmle.code.java.dataflow.DataFlow

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
 * Input that is constructed using a `Random` value.
 */
class RandomValueFlowSource extends BoundedFlowSource {
  RandomValueFlowSource() {
    exists(RefType random, MethodAccess nextAccess |
      random.hasQualifiedName("java.util", "Random")
    |
      nextAccess.getCallee().getDeclaringType().getAnAncestor() = random and
      nextAccess.getCallee().getName().matches("next%") and
      nextAccess = this.asExpr()
    )
  }

  override int lowerBound() {
    // If this call is to `nextInt()`, the lower bound is zero.
    this.asExpr().(MethodAccess).getCallee().hasName("nextInt") and
    this.asExpr().(MethodAccess).getNumArgument() = 1 and
    result = 0
  }

  override int upperBound() {
    // If this call specified an argument to `nextInt()`, and that argument is a compile time constant,
    // it forms the upper bound.
    this.asExpr().(MethodAccess).getCallee().hasName("nextInt") and
    this.asExpr().(MethodAccess).getNumArgument() = 1 and
    result = this.asExpr().(MethodAccess).getArgument(0).(CompileTimeConstantExpr).getIntValue()
  }

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
