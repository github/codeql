/**
 * In OpenSSL, flow between 'context' parameters is often used to
 * store state/config of how an operation will eventually be performed.
 * Tracing algorithms and configurations to operations therefore
 * requires tracing context parameters for many OpenSSL apis. 
 * 
 * This library provides a dataflow analysis to track context parameters
 * between any two functions accepting openssl context parameters.
 * The dataflow takes into consideration flowing through duplication and copy calls
 * as well as flow through flow killers (free/reset calls).
 *
 * TODO: we may need to revisit 'free' as a dataflow killer, depending on how
 * we want to model use after frees.
 *
 * This library also provides classes to represent context Types and relevant
 * arguments/expressions.
 */

import semmle.code.cpp.dataflow.new.DataFlow

class CTXType extends Type {
  CTXType() {
    // TODO: should we limit this to an openssl path?
    this.getUnspecifiedType().stripType().getName().matches("evp_%ctx_%st")
  }
}

class CTXPointerExpr extends Expr {
  CTXPointerExpr() {
    this.getType() instanceof CTXType and
    this.getType() instanceof PointerType
  }
}

class CTXPointerArgument extends CTXPointerExpr {
  CTXPointerArgument() { exists(Call c | c.getAnArgument() = this) }

  Call getCall() { result.getAnArgument() = this }
}

class CTXClearCall extends Call {
  CTXClearCall() {
    this.getTarget().getName().toLowerCase().matches(["%free%", "%reset%"]) and
    this.getAnArgument() instanceof CTXPointerArgument
  }
}

class CTXCopyOutArgCall extends Call {
  CTXCopyOutArgCall() {
    this.getTarget().getName().toLowerCase().matches(["%copy%"]) and
    this.getAnArgument() instanceof CTXPointerArgument
  }
}

class CTXCopyReturnCall extends Call {
  CTXCopyReturnCall() {
    this.getTarget().getName().toLowerCase().matches(["%dup%"]) and
    this.getAnArgument() instanceof CTXPointerArgument and
    this instanceof CTXPointerExpr
  }
}

module OpenSSLCTXArgumentFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof CTXPointerArgument }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof CTXPointerArgument }

  predicate isBarrier(DataFlow::Node node) {
    exists(CTXClearCall c | c.getAnArgument() = node.asExpr())
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(CTXCopyOutArgCall c |
      c.getAnArgument() = node1.asExpr() and
      c.getAnArgument() = node2.asExpr() and
      node1.asExpr() != node2.asExpr() and
      node2.asExpr().getType() instanceof CTXType
    )
    or
    exists(CTXCopyReturnCall c |
      c.getAnArgument() = node1.asExpr() and
      c = node2.asExpr() and
      node1.asExpr() != node2.asExpr() and
      node2.asExpr().getType() instanceof CTXType
    )
  }
}

module OpenSSLCTXArgumentFlow = DataFlow::Global<OpenSSLCTXArgumentFlowConfig>;

predicate ctxFlowsTo(CTXPointerArgument source, CTXPointerArgument sink) {
  exists(DataFlow::Node a, DataFlow::Node b |
    OpenSSLCTXArgumentFlow::flow(a, b) and
    a.asExpr() = source and
    b.asExpr() = sink
  )
}
