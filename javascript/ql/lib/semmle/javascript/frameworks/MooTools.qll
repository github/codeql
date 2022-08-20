/**
 * Provides classes for working with MooTools code.
 */

import javascript

/**
 * Classes and predicates for working with MooTools code.
 */
module MooTools {
  private class Element extends DataFlow::NewNode {
    Element() {
      this = DataFlow::globalVarRef("Element").getAnInstantiation() and
      // sharpen slightly to avoid spurious matches for the global variable
      this.getNumArgument() = [1, 2]
    }

    DataFlow::Node getAnElementPropertyValue(string name) {
      result = this.getOptionArgument(1, name)
      or
      exists(DataFlow::MethodCallNode mcn |
        mcn = this.getAMethodCall(["set", "setProperty"]) and
        mcn.getArgument(0).mayHaveStringValue(name) and
        result = mcn.getArgument(1)
        or
        mcn = this.getAMethodCall(["set", "setProperties"]) and
        result = mcn.getOptionArgument(0, name)
      )
    }
  }

  /**
   * Holds if MooTools interprets `node` as HTML.
   */
  predicate interpretsNodeAsHtml(DataFlow::Node node) {
    exists(Element e |
      node = e.getAnElementPropertyValue("html") or
      node = e.getAMethodCall("appendHtml").getArgument(0)
    )
  }
}
