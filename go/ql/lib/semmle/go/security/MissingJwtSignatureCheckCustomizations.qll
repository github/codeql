/**
 * Provides default sources, sinks, and sanitizers for reasoning about
 * JWT vulnerabilities, as well as extension points for adding your own.
 */

import go
private import semmle.go.dataflow.ExternalFlow
private import codeql.util.Unit

/**
 * Provides extension points for customizing the data-flow tracking configuration for reasoning
 * about JWT vulnerabilities.
 */
module MissingJwtSignatureCheck {
  /**
   * A data flow source for JWT vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for JWT vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for JWT vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** An additional flow step for JWT vulnerabilities. */
  class AdditionalFlowStep extends Unit {
    /**
     * Holds if the step from `node1` to `node2` should be considered a flow
     * step for configurations related to JWT vulnerabilities.
     */
    abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
  }

  /** A function that parses and correctly validates a JWT token. */
  abstract class JwtSafeParse extends Function {
    /** Gets the position of the JWT argument in a call to this function. */
    abstract int getTokenArgNum();

    /** Gets the JWT argument of a call to this function. */
    DataFlow::Node getTokenArg() {
      this.getTokenArgNum() != -1 and result = this.getACall().getArgument(this.getTokenArgNum())
      or
      this.getTokenArgNum() = -1 and result = this.getACall().getReceiver()
    }
  }

  private class DefaultSource extends Source instanceof ActiveThreatModelSource { }

  private class DefaultSink extends Sink {
    DefaultSink() { sinkNode(this, "jwt") }
  }
}
