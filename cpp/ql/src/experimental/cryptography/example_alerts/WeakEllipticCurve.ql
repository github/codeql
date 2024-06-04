/**
 * @name Weak elliptic curve
 * @description Finds uses of weak, unknown, or otherwise unaccepted elliptic curve algorithms.
 * @id cpp/weak-elliptic-curve
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags external/cwe/cwe-327
 */

import cpp
import experimental.cryptography.Concepts

from EllipticCurveAlgorithm alg, string name, string msg, Expr confSink
where
  exists(string tmpMsg |
    (
      name = alg.getCurveName() and
      name = unknownAlgorithm() and
      tmpMsg = "Use of unrecognized curve algorithm."
      or
      name != unknownAlgorithm() and
      name = alg.getCurveName() and
      not name =
        [
          "SECP256R1", "PRIME256V1", //P-256
          "SECP384R1", //P-384
          "SECP521R1", //P-521
          "ED25519", "X25519"
        ] and
      tmpMsg = "Use of weak curve algorithm " + name + "."
    ) and
    if alg.hasConfigurationSink() and alg.configurationSink() != alg
    then (
      confSink = alg.configurationSink() and msg = tmpMsg + " Algorithm used at sink: $@."
    ) else (
      confSink = alg and msg = tmpMsg
    )
  )
select alg, msg, confSink, confSink.toString()
