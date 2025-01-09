/**
 * Provides classes modeling security-relevant aspects of the `trender` PyPI package.
 * See https://github.com/cesbit/trender.
 */

private import python
private import semmle.python.ApiGraphs
private import semmle.python.Concepts

/**
 * INTERNAL: Do not use.
 *
 * Provides classes modeling security-relevant aspects of the `trender` PyPI package.
 * See https://github.com/cesbit/trender.
 */
module TRender {
  /** A call to `trender.TRender`. */
  private class TRenderTemplateConstruction extends TemplateConstruction::Range, API::CallNode {
    TRenderTemplateConstruction() {
      this = API::moduleImport("trender").getMember("TRender").getACall()
    }

    override DataFlow::Node getSourceArg() { result = this.getArg(0) }
  }
}
