/**
 * @name Weak cryptography
 * @description Finds explicit uses of cryptographic hash algorithms that are weak and obsolete.
 * @kind problem
 * @id cpp/weak-crypto/banned-hash-algorithms
 * @problem.severity error
 * @precision high
 * @tags external/cwe/cwe-327
 */

import cpp
import experimental.cryptography.Concepts

from HashAlgorithm alg, Expr confSink, string msg
where
  exists(string name, string msgTmp | name = alg.getHashName() |
    not name = ["SHA256", "SHA384", "SHA512"] and
    (
      if name = unknownAlgorithm()
      then
        not alg instanceof Literal and msgTmp = "Use of unrecognized hash algorithm."
        or
        alg instanceof Literal and
        msgTmp =
          "Use of unrecognized hash algorithm: " + alg.(Literal).getValueText().toString() + "."
      else msgTmp = "Use of banned hash algorithm " + name + "."
    ) and
    if alg.hasConfigurationSink() and alg.configurationSink() != alg
    then (
      confSink = alg.configurationSink() and msg = msgTmp + " Algorithm used at sink: $@."
    ) else (
      confSink = alg and msg = msgTmp
    )
  )
select alg, msg, confSink, confSink.toString()
