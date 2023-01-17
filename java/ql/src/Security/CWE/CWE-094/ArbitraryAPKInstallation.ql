/**
 * @name Android APK installation
 * @description Installing an APK from an untrusted source.
 * @kind path-problem
 * @tags security
 */

import java
import semmle.code.java.frameworks.android.Intent
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.dataflow.ExternalFlow

class PackageArchiveMimeTypeLiteral extends StringLiteral {
  PackageArchiveMimeTypeLiteral() { this.getValue() = "application/vnd.android.package-archive" }
}

class SetTypeMethod extends Method {
  SetTypeMethod() {
    this.hasName(["setType", "setTypeAndNormalize"]) and
    this.getDeclaringType().getASupertype*() instanceof TypeIntent
  }
}

class SetDataAndTypeMethod extends Method {
  SetDataAndTypeMethod() {
    this.hasName(["setDataAndType", "setDataAndTypeAndNormalize"]) and
    this.getDeclaringType().getASupertype*() instanceof TypeIntent
  }
}

class SetDataMethod extends Method {
  SetDataMethod() {
    this.hasName(["setData", "setDataAndNormalize", "setDataAndType", "setDataAndTypeAndNormalize"]) and
    this.getDeclaringType().getASupertype*() instanceof TypeIntent
  }
}

class SetDataSink extends DataFlow::ExprNode {
  SetDataSink() { this.getExpr().(MethodAccess).getMethod() instanceof SetDataMethod }

  DataFlow::ExprNode getUri() { result.asExpr() = this.getExpr().(MethodAccess).getArgument(0) }
}

class UriParseMethod extends Method {
  UriParseMethod() {
    this.hasName(["parse", "fromFile"]) and
    this.getDeclaringType().hasQualifiedName("android.net", "Uri")
  }
}

class ExternalSource extends DataFlow::Node {
  ExternalSource() {
    sourceNode(this, "android-external-storage-dir") or
    this.asExpr().(MethodAccess).getMethod() instanceof UriParseMethod or
    this.asExpr().(StringLiteral).getValue().matches(["file://%", "http://%", "https://%"])
  }
}

class ExternalSourceConfiguration extends DataFlow2::Configuration {
  ExternalSourceConfiguration() { this = "ExternalSourceConfiguration" }

  override predicate isSource(DataFlow::Node node) { node instanceof ExternalSource }

  override predicate isSink(DataFlow::Node node) {
    // any(PackageArchiveMimeTypeConfiguration c).hasFlow(_, node)
    node instanceof SetDataSink
  }
}

class PackageArchiveMimeTypeConfiguration extends TaintTracking::Configuration {
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
    //    and any(ExternalSourceConfiguration c).hasFlow(_, node.(SetDataSink).getUri())
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, PackageArchiveMimeTypeConfiguration config
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Android APK installation"
