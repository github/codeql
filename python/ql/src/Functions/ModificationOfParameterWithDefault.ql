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
import ModificationOfParameterWithDefault::Flow::PathGraph

from
  ModificationOfParameterWithDefault::Flow::PathNode source,
  ModificationOfParameterWithDefault::Flow::PathNode sink
where ModificationOfParameterWithDefault::Flow::flowPath(source, sink)
select sink.getNode(), source, sink, "This expression mutates a $@.", source.getNode(),
  "default value"
