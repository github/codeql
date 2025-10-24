/**
 * @name Bad MAC order: decrypt then mac
 * @description Decryption on cipher text, then MAC on cipher text, is incorrect order
 * @id java/quantum/examples/bad-mac-order-decrypt-then-mac
 * @kind path-problem
 * @problem.severity error
 * @tags quantum
 *       experimental
 */

import java
import BadMacOrder
import DecryptThenMacFlow::PathGraph

from DecryptThenMacFlow::PathNode src, DecryptThenMacFlow::PathNode sink
where isDecryptThenMacFlow(src, sink)
select sink, src, sink,
  "Incorrect decryption and MAC order: " +
    "Decryption of cipher text occurs before validation of MAC on cipher text."
