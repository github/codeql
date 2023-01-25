/**
 * @id java/android/arbitrary-apk-installation
 * @name Android APK installation
 * @description Installing an APK from an untrusted source.
 * @kind path-problem
 * @security-severity 9.3
 * @problem.severity warning
 * @precision medium
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import semmle.code.java.frameworks.android.Intent
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking2
private import semmle.code.java.dataflow.ExternalFlow
import DataFlow::PathGraph

/** A string literal that represents the MIME type for Android APKs. */
class PackageArchiveMimeTypeLiteral extends StringLiteral {
  PackageArchiveMimeTypeLiteral() { this.getValue() = "application/vnd.android.package-archive" }
}

/** A method that sets the MIME type of an intent. */
class SetTypeMethod extends Method {
  SetTypeMethod() {
    this.hasName(["setType", "setTypeAndNormalize"]) and
    this.getDeclaringType() instanceof TypeIntent
  }
}

/** A method that sets the data URI and the MIME type of an intent. */
class SetDataAndTypeMethod extends Method {
  SetDataAndTypeMethod() {
    this.hasName(["setDataAndType", "setDataAndTypeAndNormalize"]) and
    this.getDeclaringType() instanceof TypeIntent
  }
}

/** A method that sets the data URI of an intent. */
class SetDataMethod extends Method {
  SetDataMethod() {
    this.hasName(["setData", "setDataAndNormalize", "setDataAndType", "setDataAndTypeAndNormalize"]) and
    this.getDeclaringType() instanceof TypeIntent
  }
}

/** A dataflow sink for the URI of an intent. */
class SetDataSink extends DataFlow::ExprNode {
  SetDataSink() { this.getExpr().(MethodAccess).getMethod() instanceof SetDataMethod }
}

/** A method that generates a URI. */
class UriConstructorMethod extends Method {
  UriConstructorMethod() {
    this.hasQualifiedName("android.net", "Uri", ["parse", "fromFile", "fromParts"]) or
    this.hasQualifiedName("androidx.core.content", "FileProvider", "getUriForFile")
  }
}

/**
 * A dataflow source representing the URIs which an APK not controlled by the
 * application may come from. Including external storage and web URLs.
 */
class ExternalApkSource extends DataFlow::Node {
  ExternalApkSource() {
    sourceNode(this, "android-external-storage-dir") or
    this.asExpr().(MethodAccess).getMethod() instanceof UriConstructorMethod or
    this.asExpr().(StringLiteral).getValue().matches("file://%")
  }
}

/**
 * A dataflow configuration for flow from an external source of an APK to the
 * `setData[AndType][AndNormalize]` method of an intent.
 */
class ApkConfiguration extends DataFlow::Configuration {
  ApkConfiguration() { this = "ApkConfiguration" }

  override predicate isSource(DataFlow::Node node) { node instanceof ExternalApkSource }

  override predicate isSink(DataFlow::Node node) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof SetDataMethod and
      ma.getArgument(0) = node.asExpr() and
      any(PackageArchiveMimeTypeConfiguration c).hasFlowToExpr(ma)
    )
  }
}

/**
 * A dataflow configuration tracking the flow of the Android APK MIME type to
 * the `setType` or `setTypeAndNormalize` method of an intent.
 */
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

from DataFlow::PathNode source, DataFlow::PathNode sink, ApkConfiguration config
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Arbitrary Android APK installation."
