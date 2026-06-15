/**
 * Provides classes modeling security-relevant aspects of the `chameleon` PyPI package.
 * See https://chameleon.readthedocs.io/en/latest/.
 */

private import python
private import semmle.python.ApiGraphs
private import semmle.python.Concepts

/**
 * INTERNAL: Do not use.
 *
 * Provides classes modeling security-relevant aspects of the `chameleon` PyPI package.
 * See https://chameleon.readthedocs.io/en/latest/.
 */
module Chameleon {
  /** A call to `chameleon.PageTemplate`. */
  private class ChameleonTemplateConstruction extends TemplateConstruction::Range, API::CallNode {
    ChameleonTemplateConstruction() {
      this = API::moduleImport("chameleon").getMember("PageTemplate").getACall()
    }

    override DataFlow::Node getSourceArg() { result = this.getArg(0) }
  }
}
