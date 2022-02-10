/**
 * @name Use of a cryptographic algorithm with insufficient key size
 * @description Using cryptographic algorithms with too small a key size can
 *              allow an attacker to compromise security.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/insufficient-key-size
 * @tags security
 *       external/cwe/cwe-326
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
import semmle.code.cpp.ir.IR

int getMinimumKeyStrength(string func) {
  func = "EVP_PKEY_CTX_set_dsa_paramgen_bits" and result = 2048
  or
  func = "EVP_PKEY_CTX_set_dh_paramgen_prime_len" and result = 2048
  or
  func = "EVP_PKEY_CTX_set_rsa_keygen_bits" and result = 2048
}

class KeyStrengthFlow extends DataFlow::Configuration {
  KeyStrengthFlow() {
    this = "KeyStrengthFlow"
  }

  override predicate isSource(DataFlow::Node node) {
    node.asInstruction() instanceof IntegerConstantInstruction
  }

  override predicate isSink(DataFlow::Node node) {
    exists(FunctionCall fc, string name|
      node.asExpr() = fc.getArgument(1) and
      fc.getTarget().hasGlobalName(name) and
      exists(getMinimumKeyStrength(name))
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, KeyStrengthFlow conf, FunctionCall fc, string name, int bits
where
  conf.hasFlowPath(source, sink) and
  sink.getNode().asExpr() = fc.getArgument(1) and
  fc.getTarget().hasGlobalName(name) and
  bits = getMinimumKeyStrength(name) and
  source.getNode().asInstruction().(ConstantValueInstruction).getValue().toInt() <  bits
select fc, source, sink, "The key size $@ is insufficient for security", source, source.toString()
