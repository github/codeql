/**
 * Provides classes modeling security-relevant aspects of the `invoke` PyPI package.
 * See https://www.pyinvoke.org/.
 */

private import python
private import experimental.dataflow.DataFlow
private import experimental.dataflow.RemoteFlowSources
private import experimental.dataflow.TaintTracking
private import experimental.semmle.python.Concepts
private import experimental.semmle.python.frameworks.Werkzeug

/**
 * Provides models for the `invoke` PyPI package.
 * See https://www.pyinvoke.org/.
 */
private module Invoke {
  // ---------------------------------------------------------------------------
  // invoke
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `invoke` module. */
  private DataFlow::Node invoke(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importModule("invoke")
    or
    exists(DataFlow::TypeTracker t2 | result = invoke(t2).track(t2, t))
  }

  /** Gets a reference to the `invoke` module. */
  DataFlow::Node invoke() { result = invoke(DataFlow::TypeTracker::end()) }

  /**
   * Gets a reference to the attribute `attr_name` of the `invoke` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private DataFlow::Node invoke_attr(DataFlow::TypeTracker t, string attr_name) {
    attr_name in ["run", "sudo"] and
    (
      t.start() and
      result = DataFlow::importMember("invoke", attr_name)
      or
      t.startInAttr(attr_name) and
      result = DataFlow::importModule("invoke")
    )
    or
    // Due to bad performance when using normal setup with `invoke_attr(t2, attr_name).track(t2, t)`
    // we have inlined that code and forced a join
    exists(DataFlow::TypeTracker t2 |
      exists(DataFlow::StepSummary summary |
        invoke_attr_first_join(t2, attr_name, result, summary) and
        t = t2.append(summary)
      )
    )
  }

  pragma[nomagic]
  private predicate invoke_attr_first_join(
    DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res, DataFlow::StepSummary summary
  ) {
    DataFlow::StepSummary::step(invoke_attr(t2, attr_name), res, summary)
  }

  /**
   * Gets a reference to the attribute `attr_name` of the `invoke` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private DataFlow::Node invoke_attr(string attr_name) {
    result = invoke_attr(DataFlow::TypeTracker::end(), attr_name)
  }

  /** Provides models for the `invoke` module. */
  module invoke { }

  /**
   * A call to either of the `invoke.run` or `invoke.sudo` functions
   * See http://docs.pyinvoke.org/en/stable/api/__init__.html
   */
  private class InvokeRunCommandCall extends SystemCommandExecution::Range {
    InvokeRunCommandCall() {
      this.asCfgNode().(CallNode).getFunction() = invoke_attr(["run", "sudo"]).asCfgNode()
    }

    override DataFlow::Node getCommand() {
      result.asCfgNode() = this.asCfgNode().(CallNode).getArg(0)
      or
      result.asCfgNode() = this.asCfgNode().(CallNode).getArgByName("command")
    }
  }
}
