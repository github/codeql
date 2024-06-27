/**
 * @name Decompression Bomb
 * @description Uncontrolled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id py/decompression-bomb
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import python
import experimental.semmle.python.security.DecompressionBomb
import BombsFlow::PathGraph

from BombsFlow::PathNode source, BombsFlow::PathNode sink
where BombsFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This uncontrolled file extraction is $@.", source.getNode(),
  "depends on this user controlled data"
