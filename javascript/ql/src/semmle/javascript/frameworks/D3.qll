/** Provides classes and predicates modelling aspects of the `d3` library. */

private import javascript
private import semmle.javascript.security.dataflow.Xss

/** Provides classes and predicates modelling aspects of the `d3` library. */
module D3 {
  /** Gets an API node referring to the `d3` module. */
  API::Node d3() {
    result = API::moduleImport("d3")
    or
    result = API::moduleImport("d3-node").getInstance().getMember("d3")
  }

  /**
   * Gets an API node referring to the given module, or to `d3`.
   *
   * Useful for accessing modules that are re-exported by `d3`.
   */
  bindingset[name]
  API::Node d3Module(string name) {
    result = d3() // all d3 modules are re-exported as part of 'd3'
    or
    result = API::moduleImport(name)
  }

  /** Gets an API node referring to a `d3` selection object, such as `d3.selection()`. */
  API::Node d3Selection() {
    result = d3Module("d3-selection").getMember(["selection", "select", "selectAll"]).getReturn()
    or
    exists(API::CallNode call, string name |
      call = d3Selection().getMember(name).getACall() and
      result = call.getReturn()
    |
      name =
        [
          "select", "selectAll", "filter", "merge", "selectChild", "selectChildren", "selection",
          "insert", "remove", "clone", "sort", "order", "raise", "lower", "append", "data", "join",
          "enter", "exit", "call"
        ]
      or
      name = ["text", "html", "datum"] and
      call.getNumArgument() > 0 // exclude 0-argument version, which returns the current value
      or
      name = ["attr", "classed", "style", "property", "on"] and
      call.getNumArgument() > 1 // exclude 1-argument version, which returns the current value
    )
    or
    result = d3Selection().getMember("call").getParameter(0).getParameter(0)
  }

  private class D3XssSink extends DomBasedXss::Sink {
    D3XssSink() {
      exists(API::Node htmlArg |
        htmlArg = d3Selection().getMember("html").getParameter(0) and
        this = [htmlArg, htmlArg.getReturn()].getARhs()
      )
    }
  }

  private class D3DomValueSource extends DOM::DomValueSource::Range {
    D3DomValueSource() {
      this = d3Selection().getMember("each").getReceiver().getAnImmediateUse()
      or
      this = d3Selection().getMember("node").getReturn().getAnImmediateUse()
      or
      this = d3Selection().getMember("nodes").getReturn().getUnknownMember().getAnImmediateUse()
    }
  }

  private class D3AttributeDefinition extends DOM::AttributeDefinition {
    DataFlow::CallNode call;

    D3AttributeDefinition() {
      call = d3Selection().getMember("attr").getACall() and
      call.getNumArgument() > 1 and
      this = call.asExpr()
    }

    override string getName() { result = call.getArgument(0).getStringValue() }

    override DataFlow::Node getValueNode() { result = call.getArgument(1) }
  }
}
