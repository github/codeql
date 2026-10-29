/**
 * @kind path-problem
 */

import codeql.ruby.AST
import codeql.ruby.DataFlow
import utils.test.InlineFlowTest
import DefaultFlowTest
import TaintFlow::PathGraph
import codeql.ruby.dataflow.internal.DataFlowDispatch as DataFlowDispatch

query predicate mayBenefitFromCallContext = DataFlowDispatch::mayBenefitFromCallContext/1;

query predicate viableImplInCallContext = DataFlowDispatch::viableImplInCallContext/2;

from TaintFlow::PathNode source, TaintFlow::PathNode sink
where TaintFlow::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
