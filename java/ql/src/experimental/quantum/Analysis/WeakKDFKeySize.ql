/**
 * @name Weak known key derivation function output length
 * @description Detects key derivation operations with a known weak output length
 * @id java/quantum/weak-kdf-iteration-count
 * @kind problem
 * @problem.severity error
 * @security.severity low
 * @precision high
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

from Crypto::KeyDerivationOperationNode op, Literal l
where
  op.getOutputKeySize().asElement() = l and
  l.getValue().toInt() < 256
select op, "Key derivation operation configures output key length below 256: $@", l,
  l.getValue().toString()