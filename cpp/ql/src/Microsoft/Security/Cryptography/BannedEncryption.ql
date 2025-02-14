/**
 * @name Weak cryptography
 * @description Finds explicit uses of symmetric encryption algorithms that are weak, obsolete, or otherwise unapproved.
 * @kind problem
 * @id cpp/microsoft/public/weak-crypto/banned-encryption-algorithms
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-327
 */

import cpp
import CryptoFilters
import CryptoDataflowCapi
import CryptoDataflowCng
import experimental.cryptography.Concepts

predicate isCapiOrCNGBannedAlg(Expr e, string msg) {
  exists(FunctionCall fc |
    CapiCryptCreateEncryptionBanned::flow(DataFlow::exprNode(e),
      DataFlow::exprNode(fc.getArgument(1)))
    or
    BCryptOpenAlgorithmProviderBannedEncryption::flow(DataFlow::exprNode(e),
      DataFlow::exprNode(fc.getArgument(1)))
  ) and
  msg =
    "Call to a cryptographic function with a banned symmetric encryption algorithm: " +
      e.getValueText()
}

predicate isGeneralBannedAlg(SymmetricEncryptionAlgorithm alg, Expr confSink, string msg) {
  // Handle unknown cases in a separate query
  not alg.getEncryptionName() = unknownAlgorithm() and
  exists(string resMsg |
    (
      not alg.getEncryptionName().matches("AES%") and
      resMsg = "Use of banned symmetric encryption algorithm: " + alg.getEncryptionName() + "."
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
}

from Expr sink, Expr confSink, string msg
where
  (
    isCapiOrCNGBannedAlg(sink, msg) and confSink = sink
    or
    isGeneralBannedAlg(sink, confSink, msg)
  ) and
  not isSrcSinkFiltered(sink, confSink)
select sink, msg, confSink, confSink.toString()
