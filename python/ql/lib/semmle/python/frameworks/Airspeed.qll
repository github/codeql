/**
 * Provides classes modeling security-relevant aspects of the `airspeed` library.
 * See https://github.com/purcell/airspeed.
 */

private import python
private import semmle.python.ApiGraphs
private import semmle.python.Concepts

/**
 * INTERNAL: Do not use.
 *
 * Provides classes modeling security-relevant aspects of the `airspeed` library.
 * See https://github.com/purcell/airspeed.
 */
module Airspeed {
  /** A call to `airspeed.Template`. */
  private class AirspeedTemplateConstruction extends TemplateConstruction::Range, API::CallNode {
    AirspeedTemplateConstruction() {
      this = API::moduleImport("airspeed").getMember("Template").getACall()
    }

    override DataFlow::Node getSourceArg() { result = this.getArg(0) }
  }
}
