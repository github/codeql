/**
 * Provides a dataflow-step for the `clone` package.
 */

import javascript
private import semmle.javascript.dataflow.internal.PreCallGraphStep

private class CloneStep extends PreCallGraphStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::CallNode call | call = DataFlow::moduleImport("clone").getACall() |
      pred = call.getArgument(0) and
      succ = call
    )
  }
}
