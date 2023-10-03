/**
 * @name Weak KDF Modee
 * @description KDF mode, if specified, must be CounterMode
 * @kind problem
 * @id py/kdf-weak-mode
 * @problem.severity error
 * @precision high
 */

import python
import experimental.cryptography.Concepts
private import experimental.cryptography.utils.Utils as Utils

from KeyDerivationOperation op, DataFlow::Node modeConfSrc
where
  op.requiresMode() and
  modeConfSrc = op.getModeSrc() and
  not modeConfSrc =
    API::moduleImport("cryptography")
        .getMember("hazmat")
        .getMember("primitives")
        .getMember("kdf")
        .getMember("kbkdf")
        .getMember("Mode")
        .getMember("CounterMode")
        .asSource()
select op, "Key derivation mode is not set to CounterMode. Mode Config: $@", modeConfSrc,
  modeConfSrc.toString()
