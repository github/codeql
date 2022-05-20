/**
 * @kind path-problem
 */

import csharp
import DataFlow::PathGraph
import TestUtilities.InlineFlowTest

from DataFlow::PathNode source, DataFlow::PathNode sink, DefaultValueFlowConf conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
