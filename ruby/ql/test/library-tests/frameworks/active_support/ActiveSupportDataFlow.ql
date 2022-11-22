/**
 * @kind path-problem
 */

import codeql.ruby.AST
import TestUtilities.InlineFlowTest
import codeql.ruby.Frameworks
import PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, DefaultValueFlowConf conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
