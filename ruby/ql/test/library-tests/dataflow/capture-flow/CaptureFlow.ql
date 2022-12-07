/**
 * @kind path-problem
 */

import codeql.ruby.AST
import codeql.ruby.DataFlow
private import TestUtilities.InlineFlowTest
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, DefaultTaintFlowConf conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
