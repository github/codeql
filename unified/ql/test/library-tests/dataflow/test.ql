/**
 * @kind path-problem
 * @id unified/test/library-tests/dataflow
 * @severity info
 * @precision low
 */

private import unified
private import utils.test.InlineFlowTest
import DefaultFlowTest
import TaintFlow::PathGraph

from TaintFlow::PathNode source, TaintFlow::PathNode sink
where TaintFlow::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
