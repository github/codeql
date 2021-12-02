/**
 * @name Arbitrary File Read and Delete
 * @description Accessing files using paths constructed by user-controlled data may allow attackers 
 *              to access unexpected resources, leading to the disclosure of sensitive information or file deletion
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/any-file-read-and-delete
 * @tags security
 *       external/cwe/cwe-073
 */

import python
import DataFlow::PathGraph
import ArbitraryFileReadAndDeleteLib

from ArbitraryFileReadAndDeleteFlowConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Arbitrary file read and delete might include code from $@.",
  source.getNode(), "this user input"
