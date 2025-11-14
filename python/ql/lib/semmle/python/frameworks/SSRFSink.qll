/**
 * Provides classes for SSRF sinks modeled using Models as Data (MaD).
 */

private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.data.ModelsAsData

/**
 * INTERNAL: Do not use.
 *
 * Sets up SSRF sinks as Http::Client::Request
 */
module SsrfMaDModel {
  /**
   * An HTTP request modeled from `ssrf` sinks, modeled using MaD.
   */
  class SsrfSink extends Http::Client::Request::Range instanceof API::CallNode {
    DataFlow::Node urlArg;

    SsrfSink() {
      (
        this.getArg(_) = urlArg
        or
        this.getArgByName(_) = urlArg
      ) and
      urlArg = ModelOutput::getASinkNode("ssrf").asSink()
    }

    override DataFlow::Node getAUrlPart() { result = urlArg }

    override string getFramework() { result = "MaD" }

    override predicate disablesCertificateValidation(
      DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
    ) {
      // NOTE: if you need to define this, you have to special case it for every possible API in MaD
      none()
    }
  }
}
