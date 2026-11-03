/**
 * @name Call graph
 * @description Calls that could be resolved to a target callable
 * @kind problem
 * @problem.severity recommendation
 * @id unified/diagnostic/call-graph
 * @tags meta
 * @precision very-low
 */

import unified
import codeql.unified.internal.dataflow.DataFlowCallable
import codeql.unified.internal.AnalysisQuality

from CallGraphStats::Candidate c, DataFlowCallable target
where target = c.getTarget()
select c, "Call to $@.", target, target.toString()
