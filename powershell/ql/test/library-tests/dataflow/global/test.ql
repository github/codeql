/**
 * @kind path-problem
 */

import powershell
import semmle.code.powershell.dataflow.DataFlow
private import TestUtilities.InlineFlowTest
import DefaultFlowTest
import ValueFlow::PathGraph

from ValueFlow::PathNode source, ValueFlow::PathNode sink
where ValueFlow::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
