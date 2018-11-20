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
}
