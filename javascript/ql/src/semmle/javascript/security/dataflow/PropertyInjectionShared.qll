/**
 * Provides predicates for reasoning about flow of user-controlled values that are used
 * as property names.
 */
import javascript

module PropertyInjection {
  /**
   * A data-flow node that sanitizes user-controlled property names that flow through it.
   */
  abstract class Sanitizer extends DataFlow::Node {
  }

  /**
   * Concatenation with a constant, acting as a sanitizer.
   */
  private class ConcatSanitizer extends Sanitizer {
    ConcatSanitizer() {
      StringConcatenation::getAnOperand(this).asExpr() instanceof ConstantString
    }
  }

  /**
   * Holds if the methods of the given value are unsafe, such as `eval`.
   */
  predicate hasUnsafeMethods(DataFlow::SourceNode node) {
    // eval and friends can be accessed from the global object.
    node = DataFlow::globalObjectRef()
    or
    // 'constructor' property leads to the Function constructor.
    node.analyze().getAValue() instanceof AbstractCallable
    or
    // Assume that a value that is invoked can refer to a function.
    exists (node.getAnInvocation())
  }
}
