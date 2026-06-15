/**
 * Provides classes modeling security-relevant aspects of the `Mako` PyPI package.
 * See https://www.makotemplates.org/.
 */

private import python
private import semmle.python.ApiGraphs
private import semmle.python.Concepts

/**
 * INTERNAL: Do not use.
 *
 * Provides classes modeling security-relevant aspects of the `Mako` PyPI package.
 * See https://www.makotemplates.org/.
 */
module Mako {
  /** A call to `mako.template.Template`. */
  private class MakoTemplateConstruction extends TemplateConstruction::Range, API::CallNode {
    MakoTemplateConstruction() {
      this = API::moduleImport("mako").getMember("template").getMember("Template").getACall()
    }

    override DataFlow::Node getSourceArg() { result = this.getArg(0) }
  }
}
