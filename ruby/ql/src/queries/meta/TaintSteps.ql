/**
 * @name Taint steps
 * @description All taint steps.
 * @kind problem
 * @problem.severity recommendation
 * @id rb/meta/taint-steps
 * @tags meta
 * @precision very-low
 */

import ruby
import internal.TaintMetrics
import codeql.ruby.dataflow.internal.TaintTrackingPublic

predicate relevantStep(DataFlow::Node pred, DataFlow::Node succ) { localTaintStep(pred, succ) }

from DataFlow::Node pred, int numOfSuccessors
where
  relevantStep(pred, _) and
  numOfSuccessors = count(DataFlow::Node succ | relevantStep(pred, succ))
select pred, "Step to " + numOfSuccessors + " other nodes."
