/** Provides dataflow configurations to reason about installation of arbitrary Android APKs. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.ArbitraryApkInstallation

/**
 * A dataflow configuration for flow from an external source of an APK to the
 * `setData[AndType][AndNormalize]` method of an intent.
 */
module ApkInstallationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof ExternalApkSource }

  predicate isSink(DataFlow::Node node) {
    exists(MethodCall ma |
      ma.getMethod() instanceof SetDataMethod and
      ma.getArgument(0) = node.asExpr() and
      (
        PackageArchiveMimeTypeFlow::flowToExpr(ma.getQualifier())
        or
        InstallPackageActionFlow::flowToExpr(ma.getQualifier())
      )
    )
  }
}

module ApkInstallationFlow = DataFlow::Global<ApkInstallationConfig>;

private newtype ActionState =
  ActionUnset() or
  HasInstallPackageAction()

/**
 * A dataflow configuration tracking the flow from the `android.content.Intent.ACTION_INSTALL_PACKAGE`
 * constant to either the constructor of an intent or the `setAction` method of an intent.
 *
 * This is used to track if an intent is used to install an APK.
 */
private module InstallPackageActionConfig implements DataFlow::StateConfigSig {
  class FlowState = ActionState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    source.asExpr() instanceof InstallPackageAction and state instanceof ActionUnset
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    state1 instanceof ActionUnset and
    state2 instanceof HasInstallPackageAction and
    (
      exists(ConstructorCall cc |
        cc.getConstructedType() instanceof TypeIntent and
        node1.asExpr() = cc.getArgument(0) and
        node1.asExpr().getType() instanceof TypeString and
        node2.asExpr() = cc
      )
      or
      exists(MethodCall ma |
        ma.getMethod() instanceof SetActionMethod and
        node1.asExpr() = ma.getArgument(0) and
        node2.asExpr() = ma.getQualifier()
      )
    )
  }

  predicate isSink(DataFlow::Node node, FlowState state) {
    state instanceof HasInstallPackageAction and node.asExpr().getType() instanceof TypeIntent
  }
}

private module InstallPackageActionFlow =
  TaintTracking::GlobalWithState<InstallPackageActionConfig>;

private newtype MimeTypeState =
  MimeTypeUnset() or
  HasPackageArchiveMimeType()

/**
 * A dataflow configuration tracking the flow of the Android APK MIME type to
 * the `setType` or `setTypeAndNormalize` method of an intent, followed by a call
 * to `setData[AndType][AndNormalize]`.
 */
private module PackageArchiveMimeTypeConfig implements DataFlow::StateConfigSig {
  class FlowState = MimeTypeState;

  predicate isSource(DataFlow::Node node, FlowState state) {
    node.asExpr() instanceof PackageArchiveMimeTypeLiteral and
    state instanceof MimeTypeUnset
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    state1 instanceof MimeTypeUnset and
    state2 instanceof HasPackageArchiveMimeType and
    exists(MethodCall ma |
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

  predicate isSink(DataFlow::Node node, FlowState state) {
    state instanceof HasPackageArchiveMimeType and
    node instanceof SetDataSink
  }
}

private module PackageArchiveMimeTypeFlow =
  TaintTracking::GlobalWithState<PackageArchiveMimeTypeConfig>;
