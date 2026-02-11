/**
 * @name Local Android DoS Caused By NumberFormatException
 * @description NumberFormatException thrown but not caught by an Android
 *              application that allows external inputs can crash the
 *              application, constituting a local Denial of Service (DoS)
 *              attack.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id java/android/nfe-local-android-dos
 * @tags security
 *       experimental
 *       external/cwe/cwe-755
 */

import java
import semmle.code.java.frameworks.android.Intent
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.NumberFormatException
import NfeLocalDoSFlow::PathGraph

/**
 * Taint configuration tracking flow from untrusted inputs to number conversion calls in exported Android compononents.
 */
module NfeLocalDoSConfig implements DataFlow::ConfigSig {
  /** Holds if source is a remote flow source */
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  /** Holds if NFE is thrown but not caught */
  predicate isSink(DataFlow::Node sink) {
    exists(Expr e |
      e.getEnclosingCallable().getDeclaringType().(ExportableAndroidComponent).isExported() and
      throwsNfe(e) and
      not exists(TryStmt t |
        t.getBlock() = e.getAnEnclosingStmt() and
        catchesNfe(t)
      ) and
      sink.asExpr() = e
    )
  }
}

module NfeLocalDoSFlow = TaintTracking::Global<NfeLocalDoSConfig>;

deprecated query predicate problems(
  DataFlow::Node sinkNode, NfeLocalDoSFlow::PathNode source, NfeLocalDoSFlow::PathNode sink,
  string message1, DataFlow::Node sourceNode, string message2
) {
  NfeLocalDoSFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message1 = "Uncaught NumberFormatException in an exported Android component due to $@." and
  sourceNode = source.getNode() and
  message2 = "user-provided value"
}
