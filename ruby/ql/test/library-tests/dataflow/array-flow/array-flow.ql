/**
 * @kind path-problem
 */

import codeql.ruby.AST
import codeql.ruby.CFG
import utils.test.InlineFlowTest
import DefaultFlowTest
import ValueFlow::PathGraph

query predicate arrayLiteral(CfgNodes::ExprNodes::ArrayLiteralCfgNode n) { any() }

from ValueFlow::PathNode source, ValueFlow::PathNode sink
where ValueFlow::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
