/**
 * @kind path-problem
 */

import codeql.ruby.AST
import codeql.ruby.DataFlow
import TestUtilities.InlineFlowTest
import DefaultFlowTest
import TaintFlow::PathGraph
import codeql.ruby.dataflow.internal.DataFlowDispatch as DataFlowDispatch

query predicate mayBenefitFromCallContext = DataFlowDispatch::mayBenefitFromCallContext/2;

query predicate viableImplInCallContext = DataFlowDispatch::viableImplInCallContext/2;

from TaintFlow::PathNode source, TaintFlow::PathNode sink
where TaintFlow::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
