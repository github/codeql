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
class CtxType extends Type {
  CtxType() {
    // It is possible for users to use the underlying type of the CTX variables
    // these have a name matching 'evp_%ctx_%st
    this.getUnspecifiedType().stripType().getName().matches("evp_%ctx_%st")
    or
    // In principal the above check should be sufficient, but in case of build mode none issues
    // i.e., if a typedef cannot be resolved,
    // or issues with properly stubbing test cases, we also explicitly check for the wrapping type defs
    // i.e., patterns matching 'EVP_%_CTX'
    exists(Type base | base = this or base = this.(DerivedType).getBaseType() |
      base.getName().matches("EVP_%_CTX")
    )
  }
}

/**
 * A pointer to a CtxType
 */
class CtxPointerExpr extends Expr {
  CtxPointerExpr() {
    this.getType() instanceof CtxType and
    this.getType() instanceof PointerType
  }
}

/**
 * A call argument of type CtxPointerExpr.
 */
class CtxPointerArgument extends CtxPointerExpr {
  CtxPointerArgument() { exists(Call c | c.getAnArgument() = this) }

  Call getCall() { result.getAnArgument() = this }
}

/**
 * A call returning a CtxPointerExpr.
 */
private class CtxPointerReturn extends CtxPointerExpr instanceof Call {
  Call getCall() { result = this }
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

abstract private class CtxPassThroughCall extends Call {
  abstract DataFlow::Node getNode1();

  abstract DataFlow::Node getNode2();
}

/**
 * A call whose target contains 'copy' and has an argument of type
 * CtxPointerArgument.
 */
private class CtxCopyOutArgCall extends CtxPassThroughCall {
  DataFlow::Node n1;
  DataFlow::Node n2;

  CtxCopyOutArgCall() {
    this.getTarget().getName().toLowerCase().matches("%copy%") and
    n1.asExpr() = this.getAnArgument() and
    n1.getType() instanceof CtxType and
    n2.asDefiningArgument() = this.getAnArgument() and
    n2.getType() instanceof CtxType and
    n1.asDefiningArgument() != n2.asExpr()
  }

  override DataFlow::Node getNode1() { result = n1 }

  override DataFlow::Node getNode2() { result = n2 }
}

/**
 * A call whose target contains 'dup' and has an argument of type
 * CtxPointerArgument.
 */
private class CtxCopyReturnCall extends CtxPassThroughCall, CtxPointerExpr {
  DataFlow::Node n1;

  CtxCopyReturnCall() {
    this.getTarget().getName().toLowerCase().matches("%dup%") and
    n1.asExpr() = this.getAnArgument() and
    n1.getType() instanceof CtxType
  }

  override DataFlow::Node getNode1() { result = n1 }

  override DataFlow::Node getNode2() { result.asExpr() = this }
}

/**
 * A call to `EVP_PKEY_paramgen` acts as a kind of pass through.
 * It's output pkey is eventually used in a new operation generating
 * a fresh context pointer (e.g., `EVP_PKEY_CTX_new`).
 * It is easier to model this as a pass through
 * than to model the flow from the paramgen to the new key generation.
 */
private class CtxParamGenCall extends CtxPassThroughCall {
  DataFlow::Node n1;
  DataFlow::Node n2;

  CtxParamGenCall() {
    this.getTarget().getName() = "EVP_PKEY_paramgen" and
    n1.asExpr() = this.getArgument(0) and
    (
      n2.asExpr() = this.getArgument(1)
      or
      n2.asDefiningArgument() = this.getArgument(1)
    )
  }

  override DataFlow::Node getNode1() { result = n1 }

  override DataFlow::Node getNode2() { result = n2 }
}

/**
 * If the current node gets is an argument to a function
 * that returns a pointer type, immediately flow through.
 * NOTE: this passthrough is required if we allow
 * intermediate steps to go into variables that are not a CTX type.
 * See for example `CtxParamGenCall`.
 */
private class CallArgToCtxRet extends CtxPassThroughCall, CtxPointerExpr {
  DataFlow::Node n1;
  DataFlow::Node n2;

  CallArgToCtxRet() {
    this.getAnArgument() = n1.asExpr() and
    n2.asExpr() = this
  }

  override DataFlow::Node getNode1() { result = n1 }

  override DataFlow::Node getNode2() { result = n2 }
}

/**
 * A source Ctx of interest is any argument or return of type CtxPointerExpr.
 */
class CtxPointerSource extends CtxPointerExpr {
  CtxPointerSource() {
    this instanceof CtxPointerReturn or
    this instanceof CtxPointerArgument
  }

  DataFlow::Node asNode() {
    result.asExpr() = this
    or
    result.asDefiningArgument() = this
  }
}

/**
 * Flow from any CtxPointerSource to other CtxPointerSource.
 */
module OpenSSLCtxSourceToSourceFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { exists(CtxPointerSource s | s.asNode() = source) }

  predicate isSink(DataFlow::Node sink) { exists(CtxPointerSource s | s.asNode() = sink) }

  predicate isBarrier(DataFlow::Node node) {
    exists(CtxClearCall c | c.getAnArgument() = node.asExpr())
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(CtxPassThroughCall c | c.getNode1() = node1 and c.getNode2() = node2)
  }
}

module OpenSSLCtxSourceToArgumentFlow = DataFlow::Global<OpenSSLCtxSourceToSourceFlowConfig>;

/**
 * Holds if there is a context flow from the source to the sink.
 */
predicate ctxSrcToSrcFlow(CtxPointerSource source, CtxPointerSource sink) {
  exists(DataFlow::Node a, DataFlow::Node b |
    OpenSSLCtxSourceToArgumentFlow::flow(a, b) and
    a = source.asNode() and
    b = sink.asNode()
  )
}
