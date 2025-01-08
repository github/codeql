/**
 * Provides classes modeling security-relevant aspects of the `Genshi` PyPI package.
 * See https://genshi.edgewall.org/.
 */

private import python
private import semmle.python.ApiGraphs
private import semmle.python.Concepts

/**
 * INTERNAL: Do not use.
 *
 * Provides classes modeling security-relevant aspects of the `Genshi` PyPI package.
 * See https://genshi.edgewall.org/.
 */
module Genshi {
  /** A call to `genshi.template.text.NewTextTemplate` or `genshi.template.text.OldTextTemplate`. */
  private class GenshiTextTemplateConstruction extends TemplateConstruction::Range, API::CallNode {
    GenshiTextTemplateConstruction() {
      this =
        API::moduleImport("genshi")
            .getMember("template")
            .getMember("text")
            .getMember(["NewTextTemplate", "OldTextTemplate", "TextTemplate"])
            .getACall()
    }

    override DataFlow::Node getSourceArg() { result = this.getArg(0) }
  }

  /** A call to `genshi.template.MarkupTemplate` */
  private class GenshiMarkupTemplateConstruction extends TemplateConstruction::Range, API::CallNode {
    GenshiMarkupTemplateConstruction() {
      this =
        API::moduleImport("genshi")
            .getMember("template")
            .getMember("markup")
            .getMember("MarkupTemplate")
            .getACall()
    }

    override DataFlow::Node getSourceArg() { result = this.getArg(0) }
  }
}
