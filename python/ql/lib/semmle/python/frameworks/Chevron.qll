/**
 * Provides classes modeling security-relevant aspects of the `chevron` PyPI package.
 * See https://pypi.org/project/chevron.
 */

private import python
private import semmle.python.ApiGraphs
private import semmle.python.Concepts

/**
 * INTERNAL: Do not use.
 *
 * Provides classes modeling security-relevant aspects of the `chevron` PyPI package.
 * See https://pypi.org/project/chevron.
 */
module Chevron {
  /** A call to `chevron.render`. */
  private class ChevronRenderConstruction extends TemplateConstruction::Range, API::CallNode {
    ChevronRenderConstruction() {
      this = API::moduleImport("chevron").getMember("render").getACall()
    }

    override DataFlow::Node getSourceArg() { result = this.getArg(0) }
  }
}
