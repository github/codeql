/**
 * @name Android insecure context creation
 * @description Using untrusted input to create a context can lead to arbitary code execution
 * @kind path-problem
 * @id java/android-insecure-context-creation
 * @tags security
 *       external/cwe/cwe-691
 */

import java
import DataFlow::PathGraph
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking

/**
 * A taint-tracking configuration for insecure context creation vulnerabilities
 */
class InsecureContextCreationConfig extends TaintTracking::Configuration {
  InsecureContextCreationConfig() { this = "Android insecure context creation config" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof AndroidPackageInput or
    source instanceof RemoteFlowSource or
    source instanceof LocalStringSource
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof InsecureContextCreationSink }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    packageInfoAccessStep(node1, node2)
  }
}

/**
 * A data-flow helper configuration for tracking flow of flag field to `createPackageContext` calls
 */
private class FlagFlowConfig extends DataFlow2::Configuration {
  FlagFlowConfig() { this = "Android insecure context creation config" }

  override predicate isSource(DataFlow::Node source) {
    exists(OrBitwiseExpr e |
      forex(FieldAccess a | e.getAnOperand() = a |
        a instanceof ContextIgnoreSecurity or a instanceof ContextIncludeCode
      )
    |
      source.asExpr() = e
    )
    or
    exists(IntegerLiteral i | i.getIntValue() = 3 | source.asExpr() = i)
  }

  override predicate isSink(DataFlow::Node sink) { any() }
}

/** A `java.lang.String` which can be a source for insecure context creation vulnerabilities */
private class LocalStringSource extends DataFlow::ExprNode {
  LocalStringSource() {
    exists(string pattern, StringLiteral s |
      s.getRepresentedString().matches(pattern) and
      pattern = ["com%", "org%", "my%"]
    |
      s = this.asExpr()
    )
  }
}

/** A sink for insecure context creation vulnerabilities */
private class InsecureContextCreationSink extends DataFlow::ExprNode {
  InsecureContextCreationSink() {
    exists(MethodAccess ma, Method m |
      ma.getMethod() = m and
      m.getDeclaringType().hasQualifiedName("android.content", "ContextWrapper") and
      m.getName().matches("create%Context") and
      exists(FlagFlowConfig fc | fc.hasFlowToExpr(ma.getArgument(1)))
    |
      this.asExpr() = ma.getArgument(0)
    )
  }
}

/** Holds if a taint flows from `node1` to `node2` through an access on the `PackageInfo` object */
private predicate packageInfoAccessStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(FieldAccess fa |
    fa.getQualifier() = node1.asExpr() and
    fa.getField().getDeclaringType() instanceof AndroidPackageInfo
  |
    fa = node2.asExpr()
  )
}

/**  Models the `android.content.pm.PackageInfo` class. */
private class AndroidPackageInfo extends RefType {
  AndroidPackageInfo() { this.hasQualifiedName("android.content.pm", "PackageInfo") }
}

/**  Models the constant `CONTEXT_INCLUDE_CODE` declared in `android.content.Context`class. */
private class ContextIncludeCode extends FieldAccess {
  ContextIncludeCode() {
    exists(TypeContext t |
      this.getField().getDeclaringType().extendsOrImplements*(t) and
      this.getField().hasName("CONTEXT_INCLUDE_CODE")
    )
  }
}

/**  Models the constant `CONTEXT_IGNORE_SECURITY` declared in `android.content.Context`. */
private class ContextIgnoreSecurity extends FieldAccess {
  ContextIgnoreSecurity() {
    exists(TypeContext t |
      this.getField().getDeclaringType().extendsOrImplements*(t) and
      this.getField().hasName("CONTEXT_IGNORE_SECURITY")
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, InsecureContextCreationConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Arbitary code execution from $@.", source.getNode(),
  "this user input"
