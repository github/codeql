/**
 * @name Modification of parameter with default
 * @description Modifying the default value of a parameter can lead to unexpected
 *              results.
 * @kind path-problem
 * @tags reliability
 *       maintainability
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/modification-of-default-value
 */

import python
import semmle.python.functions.ModificationOfParameterWithDefault
import DataFlow::PathGraph

from
  ModificationOfParameterWithDefault::Configuration config, DataFlow::PathNode source,
  DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to here and is mutated.", source.getNode(),
  "Default value"
