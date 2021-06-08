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
 *       external/cwe/cwe-755
 */

import java
import semmle.code.java.frameworks.android.Intent
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.NumberFormatException
import DataFlow::PathGraph

/**
 * Taint configuration tracking flow from untrusted inputs to number conversion calls in exported Android compononents.
 */
class NFELocalDoSConfiguration extends TaintTracking::Configuration {
  NFELocalDoSConfiguration() { this = "NFELocalDoSConfiguration" }

  /** Holds if source is a remote flow source */
  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  /** Holds if NFE is thrown but not caught */
  override predicate isSink(DataFlow::Node sink) {
    exists(Expr e |
      e.getEnclosingCallable().getDeclaringType().(ExportableAndroidComponent).isExported() and
      throwsNFE(e) and
      not exists(TryStmt t |
        t.getBlock() = e.getAnEnclosingStmt() and
        catchesNFE(t)
      ) and
      sink.asExpr() = e
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, NFELocalDoSConfiguration conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Uncaught NumberFormatException in an exported Android component due to $@.", source.getNode(),
  "user-provided value"
