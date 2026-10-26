/**
 * @name Unknown nonce/iv source
 * @id java/quantum/examples/unknown-iv-or-nonce-source
 * @description A nonce/iv is generated from a source that is not secure. Failure to initialize
 *              an IV or nonce properly can lead to vulnerabilities such as replay attacks or key recovery.
 *              IV may be unknown at a decryption operation (IV would be provided alongside the ciphertext).
 *              These cases are ignored.
 * @kind problem
 * @problem.severity error
 * @tags quantum
 *       experimental
 */

import experimental.quantum.Language

from Crypto::NonceArtifactNode nonce, Crypto::NodeBase op, string msg
where
  not exists(nonce.getSourceNode()) and
  (
    // Nonce not associated with any known cipher operation, assume unknown as insecure
    not exists(Crypto::CipherOperationNode o | o.getANonce() = nonce) and
    op = nonce and
    msg =
      "Unknown IV/Nonce initialization source with no observed nonce usage (assuming could be for encryption)."
    or
    // Nonce associated cipher operation where the mode is not explicitly encryption
    op.(Crypto::CipherOperationNode).getANonce() = nonce and
    (
      op.(Crypto::CipherOperationNode).getKeyOperationSubtype() instanceof Crypto::TEncryptMode
      or
      op.(Crypto::CipherOperationNode).getKeyOperationSubtype() instanceof Crypto::TWrapMode
    ) and
    msg = "Unknown IV/Nonce initialization source at encryption operation $@"
  )
select nonce, msg, op, op.toString()
