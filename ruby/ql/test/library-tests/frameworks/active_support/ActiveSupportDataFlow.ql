/**
 * @kind path-problem
 */

import codeql.ruby.AST
import utils.test.InlineFlowTest
import codeql.ruby.Frameworks
import DefaultFlowTest
import ValueFlow::PathGraph

from ValueFlow::PathNode source, ValueFlow::PathNode sink
where ValueFlow::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
