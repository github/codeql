import cpp
private import experimental.quantum.Language
private import semmle.code.cpp.dataflow.new.DataFlow
private import experimental.quantum.OpenSSL.AlgorithmInstances.KnownAlgorithmConstants
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers
private import PaddingAlgorithmInstance

/**
 * Traces 'known algorithms' to AVCs, specifically
 * algorithms that are in the set of known algorithm constants.
 * Padding-specific consumers exist that have their own values that
 * overlap with the known algorithm constants.
 * Padding consumers (specific padding consumers) are excluded from the set of sinks.
 */
module KnownOpenSslAlgorithmToAlgorithmValueConsumerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof KnownOpenSslAlgorithmExpr and
    // No need to flow direct operations to AVCs
    not source.asExpr() instanceof OpenSslDirectAlgorithmOperationCall
  }

  predicate isSink(DataFlow::Node sink) {
    exists(OpenSslAlgorithmValueConsumer c |
      c.getInputNode() = sink and
      // exclude padding algorithm consumers, since
      // these consumers take in different constant values
      // not in the typical "known algorithm" set
      not c instanceof PaddingAlgorithmValueConsumer
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    // False positive reducer, don't flow out through argv
    exists(VariableAccess va, Variable v |
      v.getAnAccess() = va and va = node.asExpr()
      or
      va = node.asIndirectExpr()
    |
      v.getName().matches("%argv")
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    knownPassThroughStep(node1, node2)
  }
}

module KnownOpenSslAlgorithmToAlgorithmValueConsumerFlow =
  DataFlow::Global<KnownOpenSslAlgorithmToAlgorithmValueConsumerConfig>;

module RSAPaddingAlgorithmToPaddingAlgorithmValueConsumerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof OpenSslPaddingLiteral }

  predicate isSink(DataFlow::Node sink) {
    exists(PaddingAlgorithmValueConsumer c | c.getInputNode() = sink)
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    knownPassThroughStep(node1, node2)
  }
}

module RSAPaddingAlgorithmToPaddingAlgorithmValueConsumerFlow =
  DataFlow::Global<RSAPaddingAlgorithmToPaddingAlgorithmValueConsumerConfig>;

class OpenSslAlgorithmAdditionalFlowStep extends AdditionalFlowInputStep {
  OpenSslAlgorithmAdditionalFlowStep() { exists(AlgorithmPassthroughCall c | c.getInNode() = this) }

  override DataFlow::Node getOutput() {
    exists(AlgorithmPassthroughCall c | c.getInNode() = this and c.getOutNode() = result)
  }
}

abstract class AlgorithmPassthroughCall extends Call {
  abstract DataFlow::Node getInNode();

  abstract DataFlow::Node getOutNode();
}

class CopyAndDupAlgorithmPassthroughCall extends AlgorithmPassthroughCall {
  DataFlow::Node inNode;
  DataFlow::Node outNode;

  CopyAndDupAlgorithmPassthroughCall() {
    // Flow out through any return or other argument of the same type
    // Assume flow in and out is asIndirectExpr or asDefinitingArgument since a pointer is assumed
    // to be involved
    // NOTE: not attempting to detect openssl specific copy/dup functions, but anything suspected to be copy/dup
    this.getTarget().getName().toLowerCase().matches(["%_dup%", "%_copy%"]) and
    exists(Expr inArg, Type t |
      inArg = this.getAnArgument() and t = inArg.getUnspecifiedType().stripType()
    |
      inNode.asIndirectExpr() = inArg and
      (
        // Case 1: flow through another argument as an out arg of the same type
        exists(Expr outArg |
          outArg = this.getAnArgument() and
          outArg != inArg and
          outArg.getUnspecifiedType().stripType() = t
        |
          outNode.asDefiningArgument() = outArg
        )
        or
        // Case 2: flow through the return value if the result is the same as the intput type
        exists(Expr outArg | outArg = this and outArg.getUnspecifiedType().stripType() = t |
          outNode.asIndirectExpr() = outArg
        )
      )
    )
  }

  override DataFlow::Node getInNode() { result = inNode }

  override DataFlow::Node getOutNode() { result = outNode }
}

class NIDToPointerPassthroughCall extends AlgorithmPassthroughCall {
  DataFlow::Node inNode;
  DataFlow::Node outNode;

  NIDToPointerPassthroughCall() {
    this.getTarget().getName() in ["OBJ_nid2obj", "OBJ_nid2ln", "OBJ_nid2sn"] and
    inNode.asExpr() = this.getArgument(0) and
    outNode.asExpr() = this
    //outNode.asIndirectExpr() = this
  }

  override DataFlow::Node getInNode() { result = inNode }

  override DataFlow::Node getOutNode() { result = outNode }
}

class PointerToPointerPassthroughCall extends AlgorithmPassthroughCall {
  DataFlow::Node inNode;
  DataFlow::Node outNode;

  PointerToPointerPassthroughCall() {
    this.getTarget().getName() = "OBJ_txt2obj" and
    inNode.asIndirectExpr() = this.getArgument(0) and
    outNode.asIndirectExpr() = this
    or
    //outNode.asExpr() = this
    this.getTarget().getName() in ["OBJ_obj2txt", "i2t_ASN1_OBJECT"] and
    inNode.asIndirectExpr() = this.getArgument(2) and
    outNode.asDefiningArgument() = this.getArgument(0)
  }

  override DataFlow::Node getInNode() { result = inNode }

  override DataFlow::Node getOutNode() { result = outNode }
}

class PointerToNIDPassthroughCall extends AlgorithmPassthroughCall {
  DataFlow::Node inNode;
  DataFlow::Node outNode;

  PointerToNIDPassthroughCall() {
    this.getTarget().getName() in ["OBJ_obj2nid", "OBJ_ln2nid", "OBJ_sn2nid", "OBJ_txt2nid"] and
    (
      inNode.asIndirectExpr() = this.getArgument(0)
      or
      inNode.asExpr() = this.getArgument(0)
    ) and
    outNode.asExpr() = this
  }

  override DataFlow::Node getInNode() { result = inNode }

  override DataFlow::Node getOutNode() { result = outNode }
}

// TODO: pkeys pass through EVP_PKEY_CTX_new and any similar variant
predicate knownPassThroughStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(AlgorithmPassthroughCall c | c.getInNode() = node1 and c.getOutNode() = node2)
}
