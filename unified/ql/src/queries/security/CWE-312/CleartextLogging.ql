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

//
// FIXME: This is a deliberately dumb and noisy version of the query used to exercise data flow early on.
//
import unified
import codeql.concepts.internal.SensitiveDataHeuristics

private string getNameFromExpr(Expr e) {
  result = e.(IdentifierExpr).getValue()
  or
  result = e.(MemberAccessExpr).getMemberName()
}

/**
 * A taint-tracking configuration for cleartext logging vulnerabilities.
 */
module CleartextLoggingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    exists(string name |
      name = getNameFromExpr(node.asExpr()) and
      HeuristicNames::nameIndicatesSensitiveData(name)
    )
  }

  predicate isSink(DataFlow::Node node) {
    exists(CallExpr call |
      getNameFromExpr(call.getCallee()).regexpMatch("(?i)(ns)?(log|warn(ing)?|error|print).*") and
      node.asExpr() = call.getAnArgument().getValue()
    )
  }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

module CleartextLoggingFlow = TaintTracking::Global<CleartextLoggingConfig>;

import CleartextLoggingFlow::PathGraph

from CleartextLoggingFlow::PathNode source, CleartextLoggingFlow::PathNode sink
where CleartextLoggingFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Logging of $@", source.getNode(), "sensitive data"
