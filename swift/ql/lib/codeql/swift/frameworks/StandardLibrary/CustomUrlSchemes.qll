import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.dataflow.FlowSources

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
        // TODO: The actual source is the value of `UIApplication.LaunchOptionsKey.url` in the launchOptions dictionary.
        //       Use dictionary value contents when available.
        // ";UIApplicationDelegate;true;application(_:didFinishLaunchingWithOptions:);;;Parameter[1].MapValue;remote",
        // ";UIApplicationDelegate;true;application(_:willFinishLaunchingWithOptions:);;;Parameter[1].MapValue;remote"
      ]
  }
}

/**
 * A read of `UIApplication.LaunchOptionsKey.url` on a dictionary received in
 * `UIApplicationDelegate.application(_:didFinishLaunchingWithOptions:)` or
 * `UIApplicationDelegate.application(_:willFinishLaunchingWithOptions:)`.
 */
// This is a temporary workaround until the TODO above is addressed.
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

private class ApplicationWithLaunchOptionsFunc extends FuncDecl {
  ApplicationWithLaunchOptionsFunc() {
    this.getName() = "application(_:" + ["did", "will"] + "FinishLaunchingWithOptions:)" and
    this.getEnclosingDecl().(ClassOrStructDecl).getABaseTypeDecl*().(ProtocolDecl).getName() =
      "UIApplicationDelegate"
  }
}

private class LaunchOptionsUrlVarDecl extends VarDecl {
  LaunchOptionsUrlVarDecl() {
    this.getEnclosingDecl().(StructDecl).getFullName() = "UIApplication.LaunchOptionsKey" and
    this.getName() = "url"
  }
}
