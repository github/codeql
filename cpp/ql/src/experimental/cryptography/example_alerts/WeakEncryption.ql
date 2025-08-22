/**
 * @name Weak cryptography
 * @description Finds explicit uses of symmetric encryption algorithms that are weak, unknown, or otherwise unaccepted.
 * @kind problem
 * @id cpp/weak-crypto/banned-encryption-algorithms
 * @problem.severity error
 * @precision high
 * @tags external/cwe/cwe-327
 */

import cpp
import experimental.cryptography.Concepts

from SymmetricEncryptionAlgorithm alg, Expr confSink, string msg
where
  exists(string resMsg |
    (
      if alg.getEncryptionName() = unknownAlgorithm()
      then (
        alg instanceof Literal and
        resMsg =
          "Use of unrecognized symmetric encryption algorithm: " +
            alg.(Literal).getValueText().toString() + "."
        or
        not alg instanceof Literal and
        resMsg = "Use of unrecognized symmetric encryption algorithm."
      ) else (
        not alg.getEncryptionName().matches("AES%") and
        resMsg = "Use of banned symmetric encryption algorithm: " + alg.getEncryptionName() + "."
      )
    ) and
    (
      if alg.hasConfigurationSink() and alg.configurationSink() != alg
      then (
        confSink = alg.configurationSink() and msg = resMsg + " Algorithm used at sink: $@."
      ) else (
        confSink = alg and msg = resMsg
      )
    )
  )
select alg, msg, confSink, confSink.toString()
