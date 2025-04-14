/**
 * Test that fails with a compilation error if `getACallSimple` depends on the call graph.
 * To do this, we add a negative dependency from the call graph to `getACallSimple`.
 */

import javascript
import semmle.javascript.dataflow.internal.StepSummary
import semmle.javascript.dataflow.FlowSummary

class NegativeDependency extends DataFlow::SharedTypeTrackingStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(SummarizedCallable callable |
      not exists(callable.getACallSimple()) and
      node1 = node2
    )
  }
}

select "pass"
