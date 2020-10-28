/**
 * Provides taint steps modeling flow through the `classnames` and `clsx` libraries.
 */

import javascript

private DataFlow::SourceNode classnames() {
  result = DataFlow::moduleImport(["classnames", "classnames/dedupe", "classnames/bind"])
}

private class PlainStep extends TaintTracking::AdditionalTaintStep, DataFlow::CallNode {
  PlainStep() {
    this = classnames().getACall()
    or
    this = DataFlow::moduleImport("clsx").getACall()
  }

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    pred = getAnArgument() and
    succ = this
  }
}

/**
 * Step from `x` or `y` to the result of `classnames.bind(x)(y)`.
 */
private class BindStep extends TaintTracking::AdditionalTaintStep, DataFlow::CallNode {
  DataFlow::CallNode bind;

  BindStep() {
    bind = classnames().getAMemberCall("bind") and
    this = bind.getACall()
  }

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    pred = [getAnArgument(), bind.getAnArgument(), bind.getOptionArgument(_, _)] and
    succ = this
  }
}
