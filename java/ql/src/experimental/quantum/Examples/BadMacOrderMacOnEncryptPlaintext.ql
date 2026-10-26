/**
 * @name Bad MAC order: Mac and Encryption share the same plaintext
 * @description MAC should be on a cipher, not a raw message
 * @id java/quantum/examples/bad-mac-order-encrypt-plaintext-also-in-mac
 * @kind path-problem
 * @problem.severity error
 * @tags quantum
 *       experimental
 */

import java
import BadMacOrder
import PlaintextUseAsMacAndCipherInputFlow::PathGraph

from
  PlaintextUseAsMacAndCipherInputFlow::PathNode src,
  PlaintextUseAsMacAndCipherInputFlow::PathNode sink, EncryptOrMacCallArg arg
where isPlaintextInEncryptionAndMac(src, sink, arg)
select sink, src, sink,
  "Incorrect MAC usage: Encryption plaintext also used for MAC. Flow shows plaintext to final use through intermediate mac or encryption operation here $@",
  arg.asExpr(), arg.asExpr().toString()
