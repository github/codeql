/**
 * @name Bad MAC order: decrypt to mac
 * @description MAC should be on a cipher, not a raw message
 * @id java/quantum/examples/bad-mac-order-decrypt-to-mac
 * @kind path-problem
 * @problem.severity error
 * @tags quantum
 *       experimental
 */

import java
import ArtifactFlow::PathGraph
import BadMacOrder

from ArtifactFlow::PathNode src, ArtifactFlow::PathNode sink
where isDecryptToMacFlow(src, sink)
select sink, src, sink,
  "Incorrect decryption and MAC order: decryption output plaintext flows to MAC message input."
