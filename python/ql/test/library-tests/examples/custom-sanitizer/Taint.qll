import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Untrusted

class SimpleSource extends TaintSource {
  SimpleSource() { this.(NameNode).getId() = "TAINTED_STRING" }

  override predicate isSourceOf(TaintKind kind) { kind instanceof ExternalStringKind }

  override string toString() { result = "taint source" }
}

class MySimpleSanitizer extends Sanitizer {
  MySimpleSanitizer() { this = "MySimpleSanitizer" }

  /*
   * The test `if is_safe(arg):` sanitizes `arg` on its `true` edge.
   *
   * Can't handle `if not is_safe(arg):` :\ that's why it's called MySimpleSanitizer
   */

  override predicate sanitizingEdge(TaintKind taint, PyEdgeRefinement test) {
    taint instanceof ExternalStringKind and
    exists(CallNode call | test.getTest() = call and test.getSense() = true |
      call = Value::named("test.is_safe").getACall() and
      test.getInput().getAUse() = call.getAnArg()
    )
  }
}

class MySanitizerHandlingNot extends Sanitizer {
  MySanitizerHandlingNot() { this = "MySanitizerHandlingNot" }

  /** Holds if the test `if is_safe(arg):` sanitizes `arg` on its `true` edge. */
  override predicate sanitizingEdge(TaintKind taint, PyEdgeRefinement test) {
    taint instanceof ExternalStringKind and
    clears_taint_on_true(test.getTest(), test.getSense(), test)
  }
}

/**
 * Helper predicate that recurses into any nesting of `not`
 *
 * To reduce the number of tuples this predicate holds for, we include the `PyEdgeRefinement` and
 * ensure that `test` is a part of this `PyEdgeRefinement` (instead of just taking the
 * `edge_refinement.getInput().getAUse()` part as a part of the predicate). Without including
 * `PyEdgeRefinement` as an argument *any* `CallNode c` to `test.is_safe` would be a result of
 * this predicate, since the tuple where `test = c` and `sense = true` would hold.
 */
private predicate clears_taint_on_true(
  ControlFlowNode test, boolean sense, PyEdgeRefinement edge_refinement
) {
  edge_refinement.getTest().getNode().(Expr).getASubExpression*() = test.getNode() and
  (
    test = Value::named("test.is_safe").getACall() and
    edge_refinement.getInput().getAUse() = test.(CallNode).getAnArg() and
    sense = true
    or
    test.(UnaryExprNode).getNode().getOp() instanceof Not and
    exists(ControlFlowNode nested_test |
      nested_test = test.(UnaryExprNode).getOperand() and
      clears_taint_on_true(nested_test, sense.booleanNot(), edge_refinement)
    )
  )
}

class TestConfig extends TaintTracking::Configuration {
  TestConfig() { this = "TestConfig" }

  override predicate isSanitizer(Sanitizer sanitizer) {
    sanitizer instanceof MySanitizerHandlingNot
  }

  override predicate isSource(TaintTracking::Source source) { source instanceof SimpleSource }

  override predicate isSink(TaintTracking::Sink sink) { none() }
}
