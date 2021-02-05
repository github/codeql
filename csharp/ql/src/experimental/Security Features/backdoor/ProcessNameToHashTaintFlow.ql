/**
 * @name ProcessName to hash function flow
 * @description Flow from a function retrieving process name to a hash function
 *              NOTE: This query is an example of a query that may be useful for detecting potential backdoors, and Solorigate is just one such example that uses this mechanism.
 * @kind path-problem
 * @tags security
 *       solorigate
 * @problem.severity warning
 * @precision medium
 * @id cs/backdoor/process-name-to-hash-function
 */

import csharp
import DataFlow::PathGraph
import experimental.code.csharp.Cryptography.NonCryptographicHashes

class DataFlowFromMethodToHash extends TaintTracking::Configuration {
  DataFlowFromMethodToHash() { this = "DataFlowFromMethodNameToHashFunction" }

  /**
   * Holds if `source` is a relevant data flow source.
   */
  override predicate isSource(Node source) { isSuspiciousPropertyName(source.asExpr()) }

  /**
   * Holds if `sink` is a relevant data flow sink.
   */
  override predicate isSink(Node sink) { isGetHash(sink.asExpr()) }
}

predicate isGetHash(Expr arg) {
  exists(MethodCall mc |
    (
      mc.getTarget().getName().matches("%Hash%") or
      mc.getTarget().getName().regexpMatch("Md[4-5]|Sha[1-9]{1,3}")
    ) and
    mc.getAnArgument() = arg
  )
  or
  exists(Callable callable, Parameter param, Call call, int i |
    isCallableAPotentialNonCryptographicHashFunction(callable, param) and
    callable.getParameter(i) = param and
    call = callable.getACall() and
    call.getArgument(i) = arg
  )
}

predicate isSuspiciousPropertyName(PropertyRead pr) {
  pr.getTarget().getQualifiedName() = "System.Diagnostics.Process.ProcessName"
}

from DataFlow::PathNode src, DataFlow::PathNode sink, DataFlowFromMethodToHash conf
where conf.hasFlow(src.getNode(), sink.getNode())
select src.getNode(), src, sink,
  "The hash is calculated on the process name $@, may be related to a backdoor. Please review the code for possible malicious intent.",
  sink.getNode(), "here"
