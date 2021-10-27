/**
 * @name Any File Read
 * @description Accessing files using paths constructed by user-controlled data may allow attackers to access
 *              Unexpected resources, leading to leakage of sensitive information
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/any-file-read
 * @tags security
 *       external/cwe/cwe-073
 */

import python
import DataFlow::PathGraph
import AnyFileReadLib

from AnyFileReadFlowConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Any file read might include code from $@.", source.getNode(),
  "this user input"
