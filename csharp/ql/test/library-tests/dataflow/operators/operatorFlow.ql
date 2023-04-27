/**
 * @kind path-problem
 */

import csharp
import DefaultValueFlow::PathGraph
import TestUtilities.InlineFlowTest

from DefaultValueFlow::PathNode source, DefaultValueFlow::PathNode sink
where DefaultValueFlow::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
