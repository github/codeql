/**
 * @name Bad MAC order: decrypt to mac
 * @description MAC should be on a cipher, not a raw message
 * @id java/quantum/bad-mac-order-decrypt-to-mac
 * @kind path-problem
 * @problem.severity error
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language
import ArtifactFlow::PathGraph

from ArtifactFlow::PathNode src, ArtifactFlow::PathNode sink
where
  ArtifactFlow::flowPath(src, sink) and
  exists(Crypto::CipherOperationNode cipherOp |
    cipherOp.getKeyOperationSubtype() = Crypto::TDecryptMode() and
    cipherOp.getAnOutputArtifact().asElement() = src.getNode().asExpr()
  ) and
  exists(Crypto::MacOperationNode macOp |
    macOp.getAnInputArtifact().asElement() = sink.getNode().asExpr()
  )
select sink, src, sink,
  "MAC order potentially wrong: observed a potential decrypt operation output to MAC implying the MAC is on plaintext, and not a cipher."
