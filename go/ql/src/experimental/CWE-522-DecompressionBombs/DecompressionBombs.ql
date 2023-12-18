/**
 * @name Uncontrolled file decompression
 * @description Uncontrolled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id go/uncontrolled-file-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import go
import experimental.frameworks.DecompressionBombs
import DecompressionBomb::Flow::PathGraph

from DecompressionBomb::Flow::PathNode source, DecompressionBomb::Flow::PathNode sink
where DecompressionBomb::Flow::flowPath(source, sink)
select sink.getNode(), source, sink, "This decompression is $@.", source.getNode(),
  "decompressing compressed data without managing output size"
