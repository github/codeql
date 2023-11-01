/**
 * Provides classes and predicates for working with the `webix` library.
 */

private import javascript

/**
 * Provides classes and predicates for working with the `webix` library.
 */
module Webix {
  /** The global variable `webix` as an entry point for API graphs. */
  private class WebixGlobalEntry extends API::EntryPoint {
    WebixGlobalEntry() { this = "WebixGlobalEntry" }

    override DataFlow::SourceNode getASource() { result = DataFlow::globalVarRef("webix") }
  }

  /** Gets a reference to the Webix package. */
  API::Node webix() {
    result = API::moduleImport("webix") or
    result = any(WebixGlobalEntry w).getANode()
  }
}
