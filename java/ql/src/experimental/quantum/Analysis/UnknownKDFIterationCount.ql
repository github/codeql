/**
 * @name Unknown key derivation function iteration count
 * @description Detects key derivation operations with an unknown iteration count.
 * @id java/quantum/unknown-kdf-iteration-count
 * @kind problem
 * @precision medium
 * @severity warning
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

from Crypto::KeyDerivationOperationNode op, Element e, string msg
where
  e = op.getIterationCount().asElement() and
  not e instanceof Literal and
  msg = "Key derivation operation with unknown iteration: $@"
  or
  not exists(op.getIterationCount()) and
  e = op.asElement() and
  msg = "Key derivation operation with no iteration configuration."
select op, msg, e, e.toString()
