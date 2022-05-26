import javascript
import semmle.javascript.security.dataflow.RequestForgeryCustomizations
import semmle.javascript.security.dataflow.UrlConcatenation

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "SSRF" }

  override predicate isSource(DataFlow::Node source) { source instanceof RequestForgery::Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof RequestForgery::Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof RequestForgery::Sanitizer
  }

  private predicate hasSanitizingSubstring(DataFlow::Node nd) {
    nd.getStringValue().regexpMatch(".*[?#].*")
    or
    this.hasSanitizingSubstring(StringConcatenation::getAnOperand(nd))
    or
    this.hasSanitizingSubstring(nd.getAPredecessor())
  }

  private predicate strictSanitizingPrefixEdge(DataFlow::Node source, DataFlow::Node sink) {
    exists(DataFlow::Node operator, int n |
      StringConcatenation::taintStep(source, sink, operator, n) and
      this.hasSanitizingSubstring(StringConcatenation::getOperand(operator, [0 .. n - 1]))
    )
  }

  override predicate isSanitizerEdge(DataFlow::Node source, DataFlow::Node sink) {
    this.strictSanitizingPrefixEdge(source, sink)
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode nd) {
    nd instanceof IntegerCheck or
    nd instanceof ValidatorCheck or
    nd instanceof TernaryOperatorSanitizerGuard
  }
}

/**
 * A sanitizer for ternary operators.
 *
 * This sanitizers models the next example:
 * let valid = req.params.id ? Number.isInteger(req.params.id) : false
 * if (valid) { sink(req.params.id) }
 *
 * This sanitizer models this way of using ternary operators,
 * when the sanitizer guard is used as any of the branches
 * instead of being used as the condition.
 *
 * This sanitizer sanitize the corresponding if statement branch.
 */
class TernaryOperatorSanitizer extends RequestForgery::Sanitizer {
  TernaryOperatorSanitizer() {
    exists(
      TaintTracking::SanitizerGuardNode guard, IfStmt ifStmt, DataFlow::Node taintedInput,
      boolean outcome, Stmt r, DataFlow::Node falseNode
    |
      ifStmt.getCondition().flow().getAPredecessor+() = guard and
      ifStmt.getCondition().flow().getAPredecessor+() = falseNode and
      falseNode.asExpr().(BooleanLiteral).mayHaveBooleanValue(false) and
      not ifStmt.getCondition() instanceof LogicalBinaryExpr and
      guard.sanitizes(outcome, taintedInput.asExpr()) and
      (
        outcome = true and r = ifStmt.getThen() and not ifStmt.getCondition() instanceof LogNotExpr
        or
        outcome = false and r = ifStmt.getElse() and not ifStmt.getCondition() instanceof LogNotExpr
        or
        outcome = false and r = ifStmt.getThen() and ifStmt.getCondition() instanceof LogNotExpr
        or
        outcome = true and r = ifStmt.getElse() and ifStmt.getCondition() instanceof LogNotExpr
      ) and
      r.getFirstControlFlowNode()
          .getBasicBlock()
          .(ReachableBasicBlock)
          .dominates(this.getBasicBlock())
    )
  }
}

/**
 * This sanitizer guard is another way of modeling the example from above
 * In this case:
 * let valid = req.params.id ? Number.isInteger(req.params.id) : false
 * if (!valid) { return }
 * sink(req.params.id)
 *
 * The previous sanitizer is not enough,
 * because we are sanitizing the entire if statement branch
 * but we need to sanitize the use of this variable from now on.
 *
 * Thats why we model this sanitizer guard which says that
 * the result of the ternary operator execution is a sanitizer guard.
 */
class TernaryOperatorSanitizerGuard extends TaintTracking::SanitizerGuardNode {
  TaintTracking::SanitizerGuardNode originalGuard;

  TernaryOperatorSanitizerGuard() {
    this.getAPredecessor+().asExpr().(BooleanLiteral).mayHaveBooleanValue(false) and
    this.getAPredecessor+() = originalGuard and
    not this.asExpr() instanceof LogicalBinaryExpr
  }

  override predicate sanitizes(boolean outcome, Expr e) {
    not this.asExpr() instanceof LogNotExpr and
    originalGuard.sanitizes(outcome, e)
    or
    exists(boolean originalOutcome |
      this.asExpr() instanceof LogNotExpr and
      originalGuard.sanitizes(originalOutcome, e) and
      (
        originalOutcome = true and outcome = false
        or
        originalOutcome = false and outcome = true
      )
    )
  }
}

/**
 * A call to Number.isInteger seen as a sanitizer guard because a number can't be used to exploit a SSRF.
 */
class IntegerCheck extends TaintTracking::SanitizerGuardNode, DataFlow::CallNode {
  IntegerCheck() { this = DataFlow::globalVarRef("Number").getAMemberCall("isInteger") }

  override predicate sanitizes(boolean outcome, Expr e) {
    outcome = true and
    e = this.getArgument(0).asExpr()
  }
}

/**
 * A call to validator's library methods.
 * validator is a library which has a variety of input-validation functions. We are interesed in
 * checking that source is a number (any type of number) or an alphanumeric value.
 */
class ValidatorCheck extends TaintTracking::SanitizerGuardNode, DataFlow::CallNode {
  ValidatorCheck() {
    exists(DataFlow::SourceNode mod, string method |
      mod = DataFlow::moduleImport("validator") and
      this = mod.getAChainedMethodCall(method) and
      method in [
          "isAlphanumeric", "isAlpha", "isDecimal", "isFloat", "isHexadecimal", "isHexColor",
          "isInt", "isNumeric", "isOctal", "isUUID"
        ]
    )
  }

  override predicate sanitizes(boolean outcome, Expr e) {
    outcome = true and
    e = this.getArgument(0).asExpr()
  }
}
