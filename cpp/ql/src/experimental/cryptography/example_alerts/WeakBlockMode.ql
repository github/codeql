/**
 * @name Weak block mode
 * @description Finds uses of symmetric encryption block modes that are weak, obsolete, or otherwise unaccepted.
 * @id cpp/weak-block-mode
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags external/cwe/cwe-327
 */

import cpp
import experimental.cryptography.Concepts

from BlockModeAlgorithm alg, string name, string msg, Expr confSink
where
  exists(string tmpMsg |
    (
      name = alg.getBlockModeName() and
      name = unknownAlgorithm() and
      tmpMsg = "Use of unrecognized block mode algorithm."
      or
      name != unknownAlgorithm() and
      name = alg.getBlockModeName() and
      not name = ["CBC", "CTS", "XTS"] and
      tmpMsg = "Use of weak block mode algorithm " + name + "."
    ) and
    if alg.hasConfigurationSink() and alg.configurationSink() != alg
    then (
      confSink = alg.configurationSink() and msg = tmpMsg + " Algorithm used at sink: $@."
    ) else (
      confSink = alg and msg = tmpMsg
    )
  )
select alg, msg, confSink, confSink.toString()
