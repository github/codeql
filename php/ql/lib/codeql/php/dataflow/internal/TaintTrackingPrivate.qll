private import codeql.php.AST
private import DataFlowPrivate
private import codeql.php.DataFlow

/**
 * Holds if `node` should be a sanitizer in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintSanitizer(DataFlow::Node node) { none() }

/**
 * Holds if default taint tracking configurations should allow implicit reads
 * of `c` at sinks and inputs to additional taint steps.
 */
bindingset[node]
predicate defaultImplicitTaintRead(DataFlow::Node node, DataFlow::ContentSet c) { none() }

/**
 * Holds if the additional step from `src` to `sink` should be considered
 * as a taint-propagating step in all global taint flow configurations.
 */
predicate defaultAdditionalTaintStep(DataFlow::Node src, DataFlow::Node sink, string model) {
  model = "" and
  (
    // String concatenation propagates taint
    exists(BinaryExpr binConcat |
      binConcat.getOperator() = "." and
      (src.asExpr() = binConcat.getLeftOperand() or src.asExpr() = binConcat.getRightOperand()) and
      sink.asExpr() = binConcat
    )
    or
    // Augmented string concatenation ($x .= $y) propagates taint
    exists(AugmentedAssignExpr assign |
      assign.getOperator() = ".=" and
      src.asExpr() = assign.getRightOperand() and
      sink.asExpr() = assign
    )
    or
    // Array element access propagates taint
    exists(SubscriptExpr sub |
      src.asExpr() = sub.getObject() and
      sink.asExpr() = sub
    )
    or
    // Include/require propagates taint
    exists(IncludeExpr inc |
      src.asExpr() = inc.getArgument() and
      sink.asExpr() = inc
    )
    or
    // Encapsed (interpolated) strings propagate taint
    exists(EncapsedString es |
      src.asExpr() = es.getAnElement() and
      sink.asExpr() = es
    )
  )
}

/**
 * Holds if taint should propagate from `nodeFrom` to `nodeTo` speculatively.
 */
predicate speculativeTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) { none() }
