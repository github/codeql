/**
 * Provides heuristic models that match taint sources and flow through unknown
 * classes and libraries.
 */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.FlowSources

/**
 * An initializer call `ce` that has a "contentsOf" argument, along with a
 * guess `isRemote` as to whether it is the contents of a remote source. For
 * example:
 * ```
 * let myObject = MyClass(contentsOf: url) // isRemote = true
 * let myObject = MyClass(contentsOfFile: "foo.txt") // isRemote = false
 * ```
 */
private predicate contentsOfInitializer(InitializerCallExpr ce, boolean isRemote) {
  exists(Argument arg |
    ce.getAnArgument() = arg and
    arg.getLabel() = ["contentsOf", "contentsOfFile", "contentsOfPath", "contentsOfDirectory"] and
    if arg.getExpr().getType().getUnderlyingType().getName() = ["URL", "NSURL"]
    then isRemote = true
    else isRemote = false
  )
}

/**
 * An imprecise flow source for an initializer call with a "contentsOf"
 * argument that appears to be remote. For example:
 * ```
 * let myObject = MyClass(contentsOf: url)
 * ```
 */
private class InitializerContentsOfRemoteSource extends RemoteFlowSource {
  InitializerContentsOfRemoteSource() { contentsOfInitializer(this.asExpr(), true) }

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
  InitializerContentsOfLocalSource() { contentsOfInitializer(this.asExpr(), false) }

  override string getSourceType() { result = "contentsOf initializer" }
}
