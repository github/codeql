/** Provides classes representing various flow sinks for data flow / taint tracking. */

private import csharp
private import semmle.code.csharp.dataflow.internal.ExternalFlow

/**
 * A data flow sink node for an API, which should be considered
 * supported from a modeling perspective.
 */
abstract class ApiSinkNode extends DataFlow::Node { }

/**
 * A data flow sink expression node for an API, which should be considered
 * supported from a modeling perspective.
 */
abstract class ApiSinkExprNode extends ApiSinkNode, DataFlow::ExprNode { }

/**
 * Add all sink models as data sinks.
 */
private class ApiSinkNodeExternal extends ApiSinkNode {
  ApiSinkNodeExternal() { sinkNode(this, _) }
}
