/**
 * Provides predicates for measuring the quality of the call graph, that is,
 * the number of calls that could be resolved to a callee.
 */

import javascript
private import semmle.javascript.dataflow.internal.FlowSteps as FlowSteps
private import semmle.javascript.dependencies.Dependencies
private import semmle.javascript.dependencies.FrameworkLibraries
private import semmle.javascript.frameworks.Testing
private import DataFlow
import meta.MetaMetrics

/** An call site that is relevant for analysis quality. */
class RelevantInvoke extends InvokeNode {
  RelevantInvoke() { not this.getFile() instanceof IgnoredFile }
}

/** An call site that is relevant for analysis quality. */
class RelevantFunction extends Function {
  RelevantFunction() {
    not this.getFile() instanceof IgnoredFile and
    this.hasBody() // ignore abstract or ambient functions
  }
}

/**
 * Gets a data flow node that can be resolved to a function, usually a callback.
 *
 * These are not part of the static call graph, but the data flow analysis can
 * track them, so we consider them resolved.
 */
SourceNode resolvableCallback() {
  result instanceof FunctionNode
  or
  exists(Node arg |
    FlowSteps::argumentPassing(_, arg, _, result) and
    resolvableCallback().flowsTo(arg)
  )
}

/**
 * Gets a data flow node that can be resolved to an invocation of a callback.
 *
 * These are not part of the static call graph, but the data flow analysis can
 * track them, so we consider them resolved.
 */
SourceNode nodeLeadingToInvocation() {
  exists(result.getAnInvocation())
  or
  exists(Node arg |
    FlowSteps::argumentPassing(_, arg, _, nodeLeadingToInvocation()) and
    result.flowsTo(arg)
  )
  or
  exists(PartialInvokeNode invoke, Node arg |
    invoke.isPartialArgument(arg, _, _) and
    result.flowsTo(arg)
  )
}

/**
 * Holds if there is a call edge `invoke -> f` between a relevant invocation
 * and a relevant function.
 */
predicate relevantCall(RelevantInvoke invoke, RelevantFunction f) { FlowSteps::calls(invoke, f) }

/**
 * A call site that can be resolved to a function in the same project.
 */
class ResolvableCall extends RelevantInvoke {
  ResolvableCall() {
    relevantCall(this, _)
    or
    this = resolvableCallback().getAnInvocation()
  }
}

/**
 * A call site that could not be resolved.
 */
class UnresolvableCall extends RelevantInvoke {
  UnresolvableCall() { not this instanceof ResolvableCall }
}

/**
 * A function with at least one call site.
 */
class FunctionWithCallers extends RelevantFunction {
  FunctionWithCallers() {
    FlowSteps::calls(_, this)
    or
    this = nodeLeadingToInvocation().getAstNode()
  }
}

/**
 * A function without any call sites.
 */
class FunctionWithoutCallers extends RelevantFunction {
  FunctionWithoutCallers() { not this instanceof FunctionWithCallers }
}
