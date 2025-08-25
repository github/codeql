/**
 * @name Small KDF derived key length.
 * @description KDF derived keys should be a minimum of 128 bits (16 bytes).
 * @assumption If the key length is not explicitly provided (e.g., it is None or otherwise not specified) assumes the length is derived from the hash length.
 * @kind problem
 * @id py/kdf-small-key-size
 * @problem.severity error
 * @precision high
 */

import python
import experimental.cryptography.Concepts
private import experimental.cryptography.utils.Utils as Utils

from KeyDerivationOperation op, string msg, DataFlow::Node derivedKeySizeSrc
where
  // NOTE/ASSUMPTION: if the key size is not specified or explicitly None, it is common that the size is derived from the hash used.
  //       The only acceptable hashes are currently "SHA256", "SHA384", "SHA512", which are all large enough.
  //       We will currently rely on other acceptable hash queries therefore to determine if the size is
  //       is sufficient where the key is not specified.
  derivedKeySizeSrc = op.getDerivedKeySizeSrc() and
  not derivedKeySizeSrc.asExpr() instanceof None and
  (
    exists(derivedKeySizeSrc.asExpr().(IntegerLiteral).getValue()) and
    derivedKeySizeSrc.asExpr().(IntegerLiteral).getValue() < 16 and
    msg = "Derived key size is too small. "
    or
    not exists(derivedKeySizeSrc.asExpr().(IntegerLiteral).getValue()) and
    msg = "Derived key size is not a statically verifiable size. "
  )
select op, msg + "Derived key size must be a minimum of 16 (bytes). Derived Key Size Config: $@",
  derivedKeySizeSrc.asExpr(), derivedKeySizeSrc.asExpr().toString()
