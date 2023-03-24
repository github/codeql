/**
 * @kind path-problem
 */

import codeql.ruby.frameworks.Arel
import codeql.ruby.AST
import TestUtilities.InlineFlowTest

from DataFlow::PathNode source, DataFlow::PathNode sink, DefaultTaintFlowConf conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
