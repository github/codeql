/**
 * Provides a taint tracking configuration for reasoning about NoSQL injection
 * vulnerabilities.
 */

import javascript
import semmle.javascript.security.TaintedObject

module NosqlInjection {
  /**
   * A data flow source for NoSQL-injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for SQL-injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets a flow label relevant for this sink.
     *
     * Defaults to deeply tainted objects only.
     */
    DataFlow::FlowLabel getAFlowLabel() { result = TaintedObject::label() }
  }

  /**
   * A sanitizer for SQL-injection vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A taint-tracking configuration for reasoning about SQL-injection vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "NosqlInjection" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
      TaintedObject::isSource(source, label)
    }

    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
      sink.(Sink).getAFlowLabel() = label
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }

    override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
      guard instanceof TaintedObject::SanitizerGuard
    }

    override predicate isAdditionalFlowStep(
      DataFlow::Node src, DataFlow::Node trg, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
    ) {
      TaintedObject::step(src, trg, inlbl, outlbl)
      or
      // additional flow step to track taint through NoSQL query objects
      inlbl = TaintedObject::label() and
      outlbl = TaintedObject::label() and
      exists(NoSQL::Query query, DataFlow::SourceNode queryObj |
        queryObj.flowsToExpr(query) and
        queryObj.flowsTo(trg) and
        src = queryObj.getAPropertyWrite().getRhs()
      )
    }
  }

  /** A source of remote user input, considered as a flow source for NoSQL injection. */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /** An expression interpreted as a NoSQL query, viewed as a sink. */
  class NosqlQuerySink extends Sink, DataFlow::ValueNode { override NoSQL::Query astNode; }
}
