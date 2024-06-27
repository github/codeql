/** Provides classes representing various flow sinks for data flow / taint tracking. */

private import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.DataFlow

/**
 * A data flow sink node for an API, which should be considered
 * supported for a modeling perspective.
 */
abstract class ApiSinkNode extends DataFlow::Node { }

/**
 * Add all sink models as data sinks.
 */
private class ApiSinkNodeExternal extends ApiSinkNode {
  ApiSinkNodeExternal() { sinkNode(this, _) }
}
