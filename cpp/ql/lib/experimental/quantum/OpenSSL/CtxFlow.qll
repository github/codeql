//TODO: model as data on open APIs should be able to get common flows, and obviate some of this
// e.g., copy/dup calls, need to ingest those models for openSSL and refactor.
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

/**
 * An openSSL CTX type, which is type for which the stripped underlying type
 * matches the pattern 'evp_%ctx_%st'.
 * This includes types like:
 * - EVP_CIPHER_CTX
 * - EVP_MD_CTX
 * - EVP_PKEY_CTX
 */
private class CtxType extends Type {
  CtxType() { this.getUnspecifiedType().stripType().getName().matches("evp_%ctx_%st") }
}

/**
 * A pointer to a CtxType
 */
private class CtxPointerExpr extends Expr {
  CtxPointerExpr() {
    this.getType() instanceof CtxType and
    this.getType() instanceof PointerType
  }
}

/**
 * A call argument of type CtxPointerExpr.
 */
private class CtxPointerArgument extends CtxPointerExpr {
  CtxPointerArgument() { exists(Call c | c.getAnArgument() = this) }

  Call getCall() { result.getAnArgument() = this }
}

/**
 * A call whose target contains 'free' or 'reset' and has an argument of type
 * CtxPointerArgument.
 */
private class CtxClearCall extends Call {
  CtxClearCall() {
    this.getTarget().getName().toLowerCase().matches(["%free%", "%reset%"]) and
    this.getAnArgument() instanceof CtxPointerArgument
  }
}

/**
 * A call whose target contains 'copy' and has an argument of type
 * CtxPointerArgument.
 */
private class CtxCopyOutArgCall extends Call {
  CtxCopyOutArgCall() {
    this.getTarget().getName().toLowerCase().matches("%copy%") and
    this.getAnArgument() instanceof CtxPointerArgument
  }
}

/**
 * A call whose target contains 'dup' and has an argument of type
 * CtxPointerArgument.
 */
private class CtxCopyReturnCall extends Call, CtxPointerExpr {
  CtxCopyReturnCall() {
    this.getTarget().getName().toLowerCase().matches("%dup%") and
    this.getAnArgument() instanceof CtxPointerArgument
  }
}

/**
 * Flow from any CtxPointerArgument to any other CtxPointerArgument
 */
module OpenSSLCtxArgumentFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof CtxPointerArgument }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof CtxPointerArgument }

  predicate isBarrier(DataFlow::Node node) {
    exists(CtxClearCall c | c.getAnArgument() = node.asExpr())
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(CtxCopyOutArgCall c |
      c.getAnArgument() = node1.asExpr() and
      c.getAnArgument() = node2.asExpr() and
      node1.asExpr() != node2.asExpr() and
      node2.asExpr().getType() instanceof CtxType
    )
    or
    exists(CtxCopyReturnCall c |
      c.getAnArgument() = node1.asExpr() and
      c = node2.asExpr() and
      node1.asExpr() != node2.asExpr() and
      node2.asExpr().getType() instanceof CtxType
    )
  }
}

module OpenSSLCtxArgumentFlow = DataFlow::Global<OpenSSLCtxArgumentFlowConfig>;

/**
 * Holds if there is a context flow from the source to the sink.
 */
predicate ctxArgFlowsToCtxArg(CtxPointerArgument source, CtxPointerArgument sink) {
  exists(DataFlow::Node a, DataFlow::Node b |
    OpenSSLCtxArgumentFlow::flow(a, b) and
    a.asExpr() = source and
    b.asExpr() = sink
  )
}
