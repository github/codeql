/**
 * Provides the PHP-specific implementation of the data flow framework.
 * This is a simplified implementation that provides the basic types needed
 * for security queries without full interprocedural analysis.
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import DataFlowPrivate
private import DataFlowPublic

/**
 * Module for data flow configurations.
 */
module DataFlowMake {
  /**
   * A data flow configuration signature.
   */
  signature module ConfigSig {
    predicate isSource(Node source);

    predicate isSink(Node sink);

    default predicate isBarrier(Node node) { none() }

    default predicate isAdditionalFlowStep(Node node1, Node node2) { none() }
  }

  /**
   * A global data flow computation.
   */
  module Global<ConfigSig Config> {
    /**
     * Holds if data can flow from `source` to `sink`.
     */
    predicate flow(Node source, Node sink) {
      Config::isSource(source) and
      Config::isSink(sink) and
      reachable(source, sink)
    }

    /**
     * Holds if there is a path from `source` to `sink`.
     */
    predicate flowPath(Node source, Node sink) {
      Config::isSource(source) and
      Config::isSink(sink) and
      reachable(source, sink)
    }

    /**
     * Holds if data can flow from some source to `sink`.
     */
    predicate flowTo(Node sink) { flow(_, sink) }

    /**
     * Holds if `sink` is reachable from `source`.
     */
    private predicate reachable(Node source, Node sink) {
      source = sink
      or
      exists(Node mid |
        reachable(source, mid) and
        (
          simpleLocalFlowStep(mid, sink, _)
          or
          Config::isAdditionalFlowStep(mid, sink)
        ) and
        not Config::isBarrier(mid)
      )
    }
  }
}

/**
 * Module for taint tracking configurations.
 */
module TaintFlowMake {
  /**
   * A taint tracking configuration signature.
   */
  signature module ConfigSig {
    predicate isSource(Node source);

    predicate isSink(Node sink);

    default predicate isBarrier(Node node) { none() }

    default predicate isSanitizer(Node node) { none() }

    default predicate isAdditionalFlowStep(Node node1, Node node2) { none() }

    default predicate isAdditionalTaintStep(Node node1, Node node2) { none() }
  }

  /**
   * A global taint tracking computation.
   */
  module Global<ConfigSig Config> {
    /**
     * Holds if taint can flow from `source` to `sink`.
     */
    predicate flow(Node source, Node sink) {
      Config::isSource(source) and
      Config::isSink(sink) and
      taintReachable(source, sink)
    }

    /**
     * Holds if there is a taint path from `source` to `sink`.
     */
    predicate flowPath(Node source, Node sink) {
      Config::isSource(source) and
      Config::isSink(sink) and
      taintReachable(source, sink)
    }

    /**
     * Holds if taint can flow from some source to `sink`.
     */
    predicate flowTo(Node sink) { flow(_, sink) }

    /**
     * A taint step (local flow or taint propagation).
     */
    private predicate taintStep(Node n1, Node n2) {
      simpleLocalFlowStep(n1, n2, _)
      or
      Config::isAdditionalFlowStep(n1, n2)
      or
      Config::isAdditionalTaintStep(n1, n2)
      or
      defaultTaintStep(n1, n2)
    }

    /**
     * Default taint propagation steps.
     */
    private predicate defaultTaintStep(Node n1, Node n2) {
      // String concatenation
      exists(TS::PHP::BinaryExpression binop |
        binop.getOperator() = "." and
        (n1.asExpr() = binop.getLeft() or n1.asExpr() = binop.getRight()) and
        n2.asExpr() = binop
      )
      or
      // Array access - taint flows from array to subscript result
      exists(TS::PHP::SubscriptExpression sub |
        n1.asExpr() = sub.getChild(0) and
        n2.asExpr() = sub
      )
    }

    /**
     * Holds if `sink` is reachable from `source` via taint.
     */
    private predicate taintReachable(Node source, Node sink) {
      source = sink
      or
      exists(Node mid |
        taintReachable(source, mid) and
        taintStep(mid, sink) and
        not Config::isBarrier(mid) and
        not Config::isSanitizer(mid)
      )
    }
  }
}
