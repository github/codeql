/**
 * @name Insecure block mode
 * @description Detects use of insecure block cipher modes of operation.
 * @id java/quantum/examples/demo/insecure-block-mode
 * @kind problem
 * @problem.severity error
 * @tags quantum
 *       experimental
 */

import QuantumCryptoClassification

from Crypto::KeyOperationAlgorithmNode alg, Crypto::ModeOfOperationAlgorithmNode mode
where
  mode = alg.getModeOfOperation() and
  isInsecureModeType(mode.getModeType())
select alg, "Insecure block mode $@ detected.", mode, mode.getModeType().toString()
