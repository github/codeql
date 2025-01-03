/**
 * @kind path-problem
 */

import codeql.ruby.AST
import utils.test.InlineFlowTest
import DefaultFlowTest
import TaintFlow::PathGraph

from TaintFlow::PathNode source, TaintFlow::PathNode sink
where TaintFlow::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
