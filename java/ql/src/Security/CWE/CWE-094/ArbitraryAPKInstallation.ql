/**
 * @name Android APK installation
 * @description Installing an APK from an untrusted source.
 * @kind path-problem
 * @tags security
 */

import java
import semmle.code.java.frameworks.android.Intent
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking2
private import semmle.code.java.dataflow.ExternalFlow

class PackageArchiveMimeTypeLiteral extends StringLiteral {
  PackageArchiveMimeTypeLiteral() { this.getValue() = "application/vnd.android.package-archive" }
}

class SetTypeMethod extends Method {
  SetTypeMethod() {
    this.hasName(["setType", "setTypeAndNormalize"]) and
    this.getDeclaringType() instanceof TypeIntent
  }
}

class SetDataAndTypeMethod extends Method {
  SetDataAndTypeMethod() {
    this.hasName(["setDataAndType", "setDataAndTypeAndNormalize"]) and
    this.getDeclaringType() instanceof TypeIntent
  }
}

class SetDataMethod extends Method {
  SetDataMethod() {
    this.hasName(["setData", "setDataAndNormalize", "setDataAndType", "setDataAndTypeAndNormalize"]) and
    this.getDeclaringType() instanceof TypeIntent
  }
}

class SetDataSink extends DataFlow::ExprNode {
  SetDataSink() { this.getExpr().(MethodAccess).getMethod() instanceof SetDataMethod }
}

class UriConstructorMethod extends Method {
  UriConstructorMethod() {
    this.hasQualifiedName("android.net", "Uri", ["parse", "fromFile", "fromParts"])
  }
}

class ExternalSource extends DataFlow::Node {
  ExternalSource() {
    sourceNode(this, "android-external-storage-dir") or
    this.asExpr().(MethodAccess).getMethod() instanceof UriConstructorMethod or
    this.asExpr().(StringLiteral).getValue().matches(["file://%", "http://%", "https://%"])
  }
}

class ExternalSourceConfiguration extends DataFlow::Configuration {
  ExternalSourceConfiguration() { this = "ExternalSourceConfiguration" }

  override predicate isSource(DataFlow::Node node) { node instanceof ExternalSource }

  override predicate isSink(DataFlow::Node node) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof SetDataMethod and
      ma.getArgument(0) = node.asExpr() and
      any(PackageArchiveMimeTypeConfiguration c).hasFlowToExpr(ma)
    )
  }
}

private class PackageArchiveMimeTypeConfiguration extends TaintTracking2::Configuration {
  PackageArchiveMimeTypeConfiguration() { this = "PackageArchiveMimeTypeConfiguration" }

  override predicate isSource(DataFlow::Node node) {
    node.asExpr() instanceof PackageArchiveMimeTypeLiteral
  }

  override predicate isAdditionalTaintStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    state1 instanceof DataFlow::FlowStateEmpty and
    state2 = "typeSet" and
    exists(MethodAccess ma |
      ma.getQualifier() = node2.asExpr() and
      (
        ma.getMethod() instanceof SetTypeMethod and
        ma.getArgument(0) = node1.asExpr()
        or
        ma.getMethod() instanceof SetDataAndTypeMethod and
        ma.getArgument(1) = node1.asExpr()
      )
    )
  }

  override predicate isSink(DataFlow::Node node, DataFlow::FlowState state) {
    state = "typeSet" and
    node instanceof SetDataSink
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, ExternalSourceConfiguration config
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Android APK installation"
