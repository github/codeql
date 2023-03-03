/**
 * @id java/android/arbitrary-apk-installation
 * @name Android APK installation
 * @description Creating an intent with a URI pointing to a untrusted file can lead to the installation of an untrusted application.
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
import semmle.code.java.dataflow.TaintTracking3
private import semmle.code.java.dataflow.ExternalFlow
import DataFlow::PathGraph

/** A string literal that represents the MIME type for Android APKs. */
class PackageArchiveMimeTypeLiteral extends StringLiteral {
  PackageArchiveMimeTypeLiteral() { this.getValue() = "application/vnd.android.package-archive" }
}

/** The `android.content.Intent.ACTION_INSTALL_PACKAGE` constant. */
class InstallPackageAction extends Expr {
  InstallPackageAction() {
    this.(StringLiteral).getValue() = "android.intent.action.INSTALL_PACKAGE"
    or
    exists(VarAccess va |
      va.getVariable().hasName("ACTION_INSTALL_PACKAGE") and
      va.getQualifier().getType() instanceof TypeIntent
    )
  }
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
  SetDataSink() {
    exists(MethodAccess ma |
      this.getExpr() = ma.getQualifier() and
      ma.getMethod() instanceof SetDataMethod
    )
  }
}

/** A method that generates a URI. */
class UriConstructorMethod extends Method {
  UriConstructorMethod() {
    this.hasQualifiedName("android.net", "Uri", ["fromFile", "fromParts"]) or
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
      (
        any(PackageArchiveMimeTypeConfiguration c).hasFlowToExpr(ma.getQualifier())
        or
        any(InstallPackageActionConfiguration c).hasFlowToExpr(ma.getQualifier())
      )
    )
  }
}

/** The `setAction` method of the `android.content.Intent` class. */
class SetActionMethod extends Method {
  SetActionMethod() {
    this.hasName("setAction") and
    this.getDeclaringType() instanceof TypeIntent
  }
}

/**
 * A dataflow configuration tracking the flow from the `android.content.Intent.ACTION_INSTALL_PACKAGE`
 * constant to either the constructor of an intent or the `setAction` method of an intent.
 *
 * This is used to track if an intent is used to install an APK.
 */
private class InstallPackageActionConfiguration extends TaintTracking3::Configuration {
  InstallPackageActionConfiguration() { this = "InstallPackageActionConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof InstallPackageAction
  }

  override predicate isAdditionalTaintStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    state1 instanceof DataFlow::FlowStateEmpty and
    state2 = "hasPackageInstallAction" and
    (
      exists(ConstructorCall cc |
        cc.getConstructedType() instanceof TypeIntent and
        node1.asExpr() = cc.getArgument(0) and
        node1.asExpr().getType() instanceof TypeString and
        node2.asExpr() = cc
      )
      or
      exists(MethodAccess ma |
        ma.getMethod() instanceof SetActionMethod and
        node1.asExpr() = ma.getArgument(0) and
        node2.asExpr() = ma.getQualifier()
      )
    )
  }

  override predicate isSink(DataFlow::Node node, DataFlow::FlowState state) {
    state = "hasPackageInstallAction" and node.asExpr().getType() instanceof TypeIntent
  }
}

/**
 * A dataflow configuration tracking the flow of the Android APK MIME type to
 * the `setType` or `setTypeAndNormalize` method of an intent, followed by a call
 * to `setData[AndType][AndNormalize]`.
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
