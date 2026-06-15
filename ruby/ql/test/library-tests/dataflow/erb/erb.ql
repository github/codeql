/**
 * @kind path-problem
 */

import codeql.ruby.AST
import codeql.ruby.CFG
import utils.test.InlineFlowTest
import ValueFlowTest<DefaultFlowConfig>
import ValueFlow::PathGraph

from ValueFlow::PathNode source, ValueFlow::PathNode sink
where ValueFlow::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
