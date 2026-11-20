/**
 * @name Cleartext logging of sensitive information
 * @description Logging sensitive information in plaintext can
 *              expose it to an attacker.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id unified/swift/cleartext-logging
 * @tags security
 *       external/cwe/cwe-312
 *       external/cwe/cwe-359
 *       external/cwe/cwe-532
 */

import unified
import codeql.unified.security.SensitiveData
import codeql.unified.internal.typeinference.TypeInference as TypeInference

private string getNameFromExpr(Expr e) {
  result = e.(IdentifierExpr).getValue()
  or
  result = e.(MemberAccessExpr).getMemberName()
}

/**
 * Holds if `label` looks like the name of a logging function.
 */
bindingset[label]
private predicate logLikeHeuristic(string label) {
  label.regexpMatch("(l|.*L)og([A-Z0-9].*)?") // e.g. "logMessage", "debugLog"
}

predicate heuristicSink(DataFlow::Node node) {
  exists(CallExpr call, FunctionDeclaration f, Expr e |
    f = TypeInference::resolveCallTarget(call) and
    (
      logLikeHeuristic(f.getName())
      or
      exists(ClassLikeDeclaration type |
        f = type.getAMemberIncludingExtensions() and
        logLikeHeuristic(type.getName())
      )
    ) and
    e = call.getAnArgument().getValue() and
    TypeInference::inferType(e).asClass().getName() = ["String", "NSString"] and
    node.asExpr() = e
  )
}

/**
 * A taint-tracking configuration for cleartext logging vulnerabilities.
 */
module CleartextLoggingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof SensitiveData }

  predicate isSink(DataFlow::Node node) {
    Models::isSink(node, "log-injection")
    or
    heuristicSink(node)
    or
    // TODO: port StringFormat.qll and use it, as in `PrintfCleartextLoggingSink` in the original Swift query
    // TODO: then we shouldn't need this:
    exists(CallExpr call |
      getNameFromExpr(call.getCallee()).regexpMatch("(?i)(ns)?(log|warn(ing)?|error|print).*") and
      node.asExpr() = call.getAnArgument().getValue()
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    none() // TODO: barriers for booleans, encrypted data, and MaD defined barriers as in original Swift
  }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // if `a` is sensitive, then `a.b` is also sensitive.
    nodeTo.asExpr().(MemberAccessExpr).getBase() = nodeFrom.asExpr()
    or
    // if `a` is sensitive, then `a()` is also sensitive.
    nodeTo.asExpr().(CallExpr).getCallee() = nodeFrom.asExpr()
  }
}

module CleartextLoggingFlow = TaintTracking::Global<CleartextLoggingConfig>;

import CleartextLoggingFlow::PathGraph

from CleartextLoggingFlow::PathNode source, CleartextLoggingFlow::PathNode sink
where CleartextLoggingFlow::flowPath(source, sink)
select source.getNode(), source, sink, "This sensitive information is to $@ to a log file.", sink,
  "written"
