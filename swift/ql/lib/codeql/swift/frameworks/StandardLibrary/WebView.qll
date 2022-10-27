import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.dataflow.FlowSources
private import codeql.swift.dataflow.FlowSteps

private class WKScriptMessageSource extends SourceModelCsv {
  override predicate row(string row) {
    row = ";WKScriptMessageHandler;true;userContentController(_:didReceive:);;;Parameter[1];remote"
  }
}

/** The class `WKScriptMessage`. */
private class WKScriptMessageDecl extends ClassDecl {
  WKScriptMessageDecl() { this.getName() = "WKScriptMessage" }
}

/**
 * A content implying that, if a `WKScriptMessage` is tainted, its `body` field is tainted.
 */
private class WKScriptMessageBodyInheritsTaint extends TaintInheritingContent,
  DataFlow::Content::FieldContent {
  WKScriptMessageBodyInheritsTaint() {
    exists(FieldDecl f | this.getField() = f |
      f.getEnclosingDecl() instanceof WKScriptMessageDecl and
      f.getName() = "body"
    )
  }
}
