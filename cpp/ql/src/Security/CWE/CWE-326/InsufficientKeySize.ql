/**
 * @name Use of a cryptographic algorithm with insufficient key size
 * @description Using cryptographic algorithms with too small a key size can
 *              allow an attacker to compromise security.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id cpp/insufficient-key-size
 * @tags security
 *       external/cwe/cwe-326
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
import semmle.code.cpp.ir.IR
import KeyStrengthFlow::PathGraph

// Gets the recommended minimum key size (in bits) of `func`, the name of an encryption function that accepts a key size as parameter `paramIndex`
int getMinimumKeyStrength(string func, int paramIndex) {
  func =
    [
      "EVP_PKEY_CTX_set_dsa_paramgen_bits", "DSA_generate_parameters_ex",
      "EVP_PKEY_CTX_set_rsa_keygen_bits", "RSA_generate_key_ex", "RSA_generate_key_fips",
      "EVP_PKEY_CTX_set_dh_paramgen_prime_len", "DH_generate_parameters_ex"
    ] and
  paramIndex = 1 and
  result = 2048
}

module KeyStrengthFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    exists(int bits |
      node.asInstruction().(IntegerConstantInstruction).getValue().toInt() = bits and
      bits < getMinimumKeyStrength(_, _) and
      bits > 0 // exclude sentinel values
    )
  }

  predicate isSink(DataFlow::Node node) {
    exists(FunctionCall fc, string name, int param |
      node.asExpr() = fc.getArgument(param) and
      fc.getTarget().hasGlobalName(name) and
      exists(getMinimumKeyStrength(name, param))
    )
  }
}

module KeyStrengthFlow = DataFlow::Global<KeyStrengthFlowConfig>;

from
  KeyStrengthFlow::PathNode source, KeyStrengthFlow::PathNode sink, FunctionCall fc, int param,
  string name, int minimumBits, int bits
where
  KeyStrengthFlow::flowPath(source, sink) and
  sink.getNode().asExpr() = fc.getArgument(param) and
  fc.getTarget().hasGlobalName(name) and
  minimumBits = getMinimumKeyStrength(name, param) and
  bits = source.getNode().asInstruction().(ConstantValueInstruction).getValue().toInt() and
  bits < minimumBits and
  bits != 0
select fc, source, sink,
  "The key size $@ is less than the recommended key size of " + minimumBits.toString() + " bits.",
  source, bits.toString()
