/**
 * Provides models related to custom URL schemes.
 */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.dataflow.FlowSources
private import codeql.swift.dataflow.FlowSteps

/**
 * A model for custom URL remote flow sources. iOS apps can receive arbitrary
 * URLs from other apps in these functions if they register a custom URL scheme.
 */
private class CustomUrlRemoteFlowSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        ";UIApplicationDelegate;true;application(_:open:options:);;;Parameter[1];remote",
        ";UIApplicationDelegate;true;application(_:handleOpen:);;;Parameter[1];remote",
        ";UIApplicationDelegate;true;application(_:open:sourceApplication:annotation:);;;Parameter[1];remote",
        ";UISceneDelegate;true;scene(_:continue:);;;Parameter[1];remote",
        ";UISceneDelegate;true;scene(_:didUpdate:);;;Parameter[1];remote",
        ";UISceneDelegate;true;scene(_:openURLContexts:);;;Parameter[1];remote",
        ";UISceneDelegate;true;scene(_:willConnectTo:options:);;;Parameter[2];remote"
      ]
  }
}

/**
 * A read of `UIApplication.LaunchOptionsKey.url` on a dictionary received in
 * `UIApplicationDelegate.application(_:didFinishLaunchingWithOptions:)` or
 * `UIApplicationDelegate.application(_:willFinishLaunchingWithOptions:)`.
 */
private class UrlLaunchOptionsRemoteFlowSource extends RemoteFlowSource {
  UrlLaunchOptionsRemoteFlowSource() {
    exists(ApplicationWithLaunchOptionsFunc f, SubscriptExpr e |
      DataFlow::localExprFlow(f.getParam(1).getAnAccess(), e.getBase()) and
      e.getAnArgument().getExpr().(MemberRefExpr).getMember() instanceof LaunchOptionsUrlVarDecl and
      this.asExpr() = e
    )
  }

  override string getSourceType() {
    result = "Remote URL in UIApplicationDelegate.application.launchOptions"
  }
}

private class ApplicationWithLaunchOptionsFunc extends Function {
  ApplicationWithLaunchOptionsFunc() {
    this.getName() = "application(_:" + ["did", "will"] + "FinishLaunchingWithOptions:)" and
    this.getEnclosingDecl().asNominalTypeDecl().getABaseTypeDecl*().(ProtocolDecl).getName() =
      "UIApplicationDelegate"
  }
}

private class LaunchOptionsUrlVarDecl extends VarDecl {
  LaunchOptionsUrlVarDecl() {
    this.getEnclosingDecl().asNominalTypeDecl().getFullName() = "UIApplication.LaunchOptionsKey" and
    this.getName() = "url"
  }
}

/**
 * A content implying that, if a `UIOpenURLContext` is tainted, then its field `url` is also tainted.
 */
private class UiOpenUrlContextUrlInheritTaint extends TaintInheritingContent,
  DataFlow::Content::FieldContent
{
  UiOpenUrlContextUrlInheritTaint() {
    this.getField().getEnclosingDecl().asNominalTypeDecl().getName() = "UIOpenURLContext" and
    this.getField().getName() = "url"
  }
}

/**
 * A content implying that, if a `NSUserActivity` is tainted, then its field `webpageURL` is also tainted.
 */
private class UserActivityUrlInheritTaint extends TaintInheritingContent,
  DataFlow::Content::FieldContent
{
  UserActivityUrlInheritTaint() {
    this.getField().getEnclosingDecl().asNominalTypeDecl().getName() = "NSUserActivity" and
    this.getField().getName() = ["webpageURL", "referrerURL"]
  }
}

/**
 * A content implying that, if a `UIScene.ConnectionOptions` is tainted, then its fields
 * `userActivities` and `urlContexts` are also tainted.
 */
private class ConnectionOptionsFieldsInheritTaint extends TaintInheritingContent,
  DataFlow::Content::FieldContent
{
  ConnectionOptionsFieldsInheritTaint() {
    this.getField().getEnclosingDecl().asNominalTypeDecl().getName() = "ConnectionOptions" and
    this.getField().getName() = ["userActivities", "urlContexts"]
  }
}
