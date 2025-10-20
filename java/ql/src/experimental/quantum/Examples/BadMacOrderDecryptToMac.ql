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
import experimental.quantum.Language
import ArtifactFlow::PathGraph
import BadMacOrder

from ArtifactFlow::PathNode src, ArtifactFlow::PathNode sink
where isDecryptToMacFlow(src, sink)
select sink, src, sink,
  "MAC order potentially wrong: observed a potential decrypt operation output to MAC implying the MAC is on plaintext, and not a cipher."
