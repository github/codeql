/**
 * @name Inventory of cryptographic key sizes
 * @description Lists all detected key creation operations with their algorithm and key size.
 * @id java/quantum/examples/demo/inventory-key-sizes
 * @kind problem
 * @problem.severity recommendation
 * @tags quantum
 *       experimental
 */

import experimental.quantum.Language

from Crypto::KeyCreationOperationNode keygen, Crypto::AlgorithmNode alg, int keySize
where
  alg = keygen.getAKnownAlgorithm() and
  keygen.getAKeySizeSource().asElement().(Literal).getValue().toInt() = keySize
select keygen, "Key creation with algorithm $@ using " + keySize.toString() + "-bit key.", alg,
  alg.getAlgorithmName()
