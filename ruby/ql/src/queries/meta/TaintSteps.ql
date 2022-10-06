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

from File file, int numSteps
where
  numSteps =
    strictcount(DataFlow::Node pred, DataFlow::Node succ |
      relevantStep(pred, succ) and pred.getLocation().getFile() = file
    )
select file, "File has " + numSteps + " taint steps."
