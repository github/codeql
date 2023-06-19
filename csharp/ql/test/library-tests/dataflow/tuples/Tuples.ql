/**
 * @kind path-problem
 */

import csharp
import TestUtilities.InlineFlowTest
import DefaultFlowTest
import PathGraph

from PathNode source, PathNode sink
where flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
