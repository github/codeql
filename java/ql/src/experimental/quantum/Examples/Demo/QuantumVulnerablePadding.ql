/**
 * @name Quantum-vulnerable padding scheme
 * @description Detects use of padding schemes associated with quantum-vulnerable asymmetric algorithms.
 * @id java/quantum/examples/demo/quantum-vulnerable-padding
 * @kind problem
 * @problem.severity warning
 * @tags quantum
 *       experimental
 */

import QuantumCryptoClassification

from Crypto::PaddingAlgorithmNode pad, string msg
where
  isQuantumVulnerablePaddingType(pad.getPaddingType()) and
  (
    pad instanceof Crypto::PSSPaddingAlgorithmNode and
    msg = "Quantum-vulnerable PSS padding scheme detected."
    or
    pad instanceof Crypto::OAEPPaddingAlgorithmNode and
    msg = "Quantum-vulnerable OAEP padding scheme detected."
    or
    not pad instanceof Crypto::PSSPaddingAlgorithmNode and
    not pad instanceof Crypto::OAEPPaddingAlgorithmNode and
    msg = "Quantum-vulnerable padding scheme: " + pad.getPaddingType().toString() + "."
  )
select pad, msg
