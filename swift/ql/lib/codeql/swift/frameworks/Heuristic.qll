/**
 * Provides heuristic models that match taint sources and flow through unknown
 * classes and libraries.
 */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.FlowSources
private import codeql.swift.dataflow.FlowSteps

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

/**
 * An imprecise flow step for an initializer call with a "data" argument.  For
 * example:
 * ```
 * let mc = MyClass(data: taintedData)
 * ```
 */
private class InitializerFromDataStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(InitializerCallExpr ce, Argument arg |
      ce.getAnArgument() = arg and
      arg.getLabel() = "data" and
      node1.asExpr() = arg.getExpr() and
      node2.asExpr() = ce
    )
  }
}

/**
 * An imprecise flow step for an `append`, `insert` or similar function.  For
 * example:
 * ```
 * mc.append(taintedObj)
 * mc.insert(taintedObj, at: 0)
 * ```
 */
private class AppendCallStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(CallExpr ce, Argument arg |
      ce.getAnArgument() = arg and
      ce.getStaticTarget().(Function).getShortName() = ["append", "insert"] and
      arg.getLabel() = ["", "contentsOf"] and
      node1.asExpr() = arg.getExpr() and
      node2.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr() = ce.getQualifier()
    )
  }
}

/**
 * An imprecise flow step for an `appending` or similar function.  For
 * example:
 * ```
 * let mc2 = mc.appending(taintedObj)
 * ```
 */
private class AppendingCallStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(CallExpr ce, Argument arg |
      ce.getAnArgument() = arg and
      ce.getStaticTarget().(Function).getShortName() = ["appending", "inserting"] and
      arg.getLabel() = ["", "contentsOf"] and
      node1.asExpr() = arg.getExpr() and
      node2.asExpr() = ce
    )
  }
}
