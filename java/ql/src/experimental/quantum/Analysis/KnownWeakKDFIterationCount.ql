/**
 * @name Weak known key derivation function iteration count
 * @description Detects key derivation operations with a known weak iteration count.
 * @id java/quantum/weak-kdf-iteration-count
 * @kind problem
 * @precision high
 * @severity problem
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

from Crypto::KeyDerivationOperationNode op, Literal l
where
  op.getIterationCount().asElement() = l and
  l.getValue().toInt() < 100000
select op, "Key derivation operation configures iteration count below 100k: $@", l,
  l.getValue().toString()
