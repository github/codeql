/**
 * @name Uncontrolled file decompression
 * @description Decompressing user-controlled files without checking the compression ratio may allow attackers to perform denial-of-service attacks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id java/uncontrolled-file-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import java
import experimental.semmle.code.java.security.DecompressionBombQuery
import DecompressionBombsFlow::PathGraph

from DecompressionBombsFlow::PathNode source, DecompressionBombsFlow::PathNode sink
where DecompressionBombsFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This file extraction depends on a $@.", source.getNode(),
  "potentially untrusted source"
