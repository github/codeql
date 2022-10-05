/**
 * @kind path-problem
 */

import codeql.ruby.AST
import codeql.ruby.DataFlow
import TestUtilities.InlineFlowTest
import DataFlow::PathGraph
import codeql.ruby.dataflow.internal.DataFlowDispatch as DataFlowDispatch

query predicate mayBenefitFromCallContext = DataFlowDispatch::mayBenefitFromCallContext/2;

query predicate viableImplInCallContext = DataFlowDispatch::viableImplInCallContext/2;

from DataFlow::PathNode source, DataFlow::PathNode sink, DefaultTaintFlowConf conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
