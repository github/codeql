/**
 * Provides heuristic models that match taint sources and flow through unknown
 * classes and libraries.
 */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.FlowSources

/**
 * An imprecise flow source for an initializer call with a "contentsOf"
 * argument that appears to be remote. For example:
 * ```
 * let myObject = MyClass(contentsOf: url)
 * ```
 */
private class InitializerContentsOfRemoteSource extends RemoteFlowSource {
  InitializerContentsOfRemoteSource() {
    exists(InitializerCallExpr ce, Argument arg |
      ce.getAnArgument() = arg and
      arg.getLabel() = ["contentsOf", "contentsOfFile", "contentsOfPath", "contentsOfDirectory"] and
      arg.getExpr().getType().getUnderlyingType().getName() = ["URL", "NSURL"] and
      this.asExpr() = ce
    )
  }

  override string getSourceType() { result = "contentsOf initializer" }
}

/**
 * An imprecise flow source for an initializer call with a "contentsOf"
 * argument that appears to be local. For example:
 * ```
 * let myObject = MyClass(contentsOfFile: "foo.txt")
 * ```
 */
private class InitializerContentsOfLocalSource extends LocalFlowSource {
  InitializerContentsOfLocalSource() {
    exists(InitializerCallExpr ce, Argument arg |
      ce.getAnArgument() = arg and
      arg.getLabel() = ["contentsOf", "contentsOfFile", "contentsOfPath", "contentsOfDirectory"] and
      not arg.getExpr().getType().getUnderlyingType().getName() = ["URL", "NSURL"] and
      this.asExpr() = ce
    )
  }

  override string getSourceType() { result = "contentsOf initializer" }
}
