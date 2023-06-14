/**
 * @kind path-problem
 */

import codeql.ruby.frameworks.Arel
import codeql.ruby.AST
import TestUtilities.InlineFlowTest
import DefaultFlowTest

from TaintFlow::PathNode source, TaintFlow::PathNode sink
where TaintFlow::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
