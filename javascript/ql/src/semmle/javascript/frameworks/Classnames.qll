/**
 * Provides taint steps modeling flow through the `classnames` and `clsx` libraries.
 */

import javascript

private DataFlow::SourceNode classnames() {
  result = DataFlow::moduleImport(["classnames", "classnames/dedupe", "classnames/bind"])
}

private class PlainStep extends TaintTracking::SharedTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::CallNode call |
      call = [classnames().getACall(), DataFlow::moduleImport("clsx").getACall()] and
      pred = call.getAnArgument() and
      succ = call
    )
  }
}

/**
 * Step from `x` or `y` to the result of `classnames.bind(x)(y)`.
 */
private class BindStep extends TaintTracking::SharedTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::CallNode bind | bind = classnames().getAMemberCall("bind") |
      pred =
        [
          succ.(DataFlow::CallNode).getAnArgument(), bind.getAnArgument(),
          bind.getOptionArgument(_, _)
        ] and
      succ = bind.getACall()
    )
  }
}
