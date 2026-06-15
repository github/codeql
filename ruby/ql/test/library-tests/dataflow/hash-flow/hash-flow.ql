/**
 * @kind path-problem
 */

import codeql.ruby.AST
import codeql.ruby.CFG
import utils.test.InlineFlowTest
import DefaultFlowTest
import ValueFlow::PathGraph

query predicate hashLiteral(CfgNodes::ExprNodes::HashLiteralCfgNode n) { any() }

from ValueFlow::PathNode source, ValueFlow::PathNode sink
where ValueFlow::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
