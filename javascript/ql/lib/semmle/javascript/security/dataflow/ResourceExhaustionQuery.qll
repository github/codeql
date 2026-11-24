/**
 * Provides a taint tracking configuration for reasoning about
 * resource exhaustion vulnerabilities (CWE-770).
 *
 * Note, for performance reasons: only import this file if
 * `ResourceExhaustion::Configuration` is needed, otherwise
 * `ResourceExhaustionCustomizations` should be imported instead.
 */

import javascript
import ResourceExhaustionCustomizations::ResourceExhaustion

/**
 * A data flow configuration for resource exhaustion vulnerabilities.
 */
module ResourceExhaustionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer or
    node = any(DataFlow::PropRead read | read.getPropertyName() = "length") or
    node = DataFlow::MakeBarrierGuard<BarrierGuard>::getABarrierNode()
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    isNumericFlowStep(node1, node2)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Data flow for resource exhaustion vulnerabilities.
 */
module ResourceExhaustionFlow = TaintTracking::Global<ResourceExhaustionConfig>;

/**
 * DEPRECATED. Use the `ResourceExhaustionFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ResourceExhaustion" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer or
    node = any(DataFlow::PropRead read | read.getPropertyName() = "length")
  }

  override predicate isAdditionalTaintStep(DataFlow::Node src, DataFlow::Node dst) {
    isNumericFlowStep(src, dst)
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof UpperBoundsCheckSanitizerGuard
  }
}

/** Holds if data is converted to a number from `src` to `dst`. */
predicate isNumericFlowStep(DataFlow::Node src, DataFlow::Node dst) {
  exists(DataFlow::CallNode c |
    c = dst and
    src = c.getAnArgument()
  |
    c = DataFlow::globalVarRef("Math").getAMemberCall(_) and
    not (
      c = DataFlow::globalVarRef("Math").getAMemberCall("min") and
      isConstantNumber(c.getAnArgument().asExpr())
    )
    or
    c = DataFlow::globalVarRef(["Number", "parseInt", "parseFloat"]).getACall()
  )
}

/** Holds if `e` evaluates to a finite constant value. */
private predicate isConstantNumber(Expr e) {
  e =
    any(NumberLiteral literal |
      exists(literal.getIntValue())
      or
      // Subtracting an infinite floating-point value from itself does not yield zero.
      exists(float value | value = literal.getFloatValue() and value - value = 0.0)
    )
  or
  e =
    any(UnaryExpr sign |
      isConstantNumber(sign.getOperand()) and
      (sign instanceof NegExpr or sign instanceof PlusExpr)
    )
  or
  isConstantNumber(e.stripParens())
  or
  exists(Variable v, VariableDeclarator decl |
    v.isLocal() or decl.getDeclStmt() instanceof ConstDeclStmt
  |
    e = v.getAnAccess() and
    decl.getBindingPattern() = unique(VarDecl varDecl | varDecl = v.getADeclaration()) and
    not v.isParameter() and
    not v.isNamespaceExport() and
    not v = any(EnhancedForLoop loop).getAnIterationVariable() and
    not exists(EnhancedForLoop loop | loop.getIteratorExpr().stripParens() = v.getAnAccess()) and
    forex(Expr assigned | assigned = v.getAnAssignedExpr() | isConstantNumber(assigned)) and
    forall(VarAccess write |
      write = v.getAnAccess() and
      write.isLValue()
    |
      exists(AssignExpr assignment |
        write = assignment.getTarget().stripParens() and
        isConstantNumber(assignment.getRhs())
      )
    )
  )
}

/**
 * A sanitizer that blocks taint flow if the size of a number is limited.
 */
class UpperBoundsCheckSanitizerGuard extends BarrierGuard, DataFlow::ValueNode {
  override RelationalComparison astNode;

  override predicate blocksExpr(boolean outcome, Expr e) {
    true = outcome and
    e = astNode.getLesserOperand()
    or
    false = outcome and
    e = astNode.getGreaterOperand()
  }
}
