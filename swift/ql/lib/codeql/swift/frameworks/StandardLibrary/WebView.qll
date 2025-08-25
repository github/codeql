/**
 * Provides models for WebView-related Swift classes.
 */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.dataflow.FlowSources
private import codeql.swift.dataflow.FlowSteps

/**
 * A model for WKScriptMessage sources. Classes implementing the `WKScriptMessageHandler` protocol
 * act as a bridge between JavaScript and native code. The messages sent from JavaScript code are
 * stored in the `message` parameter of `userContentController`.
 */
private class WKScriptMessageSources extends SourceModelCsv {
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
  DataFlow::Content::FieldContent
{
  WKScriptMessageBodyInheritsTaint() {
    exists(FieldDecl f | this.getField() = f |
      f.getEnclosingDecl().asNominalTypeDecl() instanceof WKScriptMessageDecl and
      f.getName() = "body"
    )
  }
}

/**
 * A type or extension declaration that adopts the protocol `WKNavigationDelegate`.
 */
private class AdoptsWkNavigationDelegate extends Decl {
  AdoptsWkNavigationDelegate() {
    this.asNominalTypeDecl().getABaseTypeDecl*().(ProtocolDecl).getName() = "WKNavigationDelegate"
  }
}

/**
 * A source for the `decidePolicyFor` parameter of the `webView` method of a type adopting `WKNavigationDelegate`.
 */
private class WKNavigationDelegateSource extends RemoteFlowSource {
  WKNavigationDelegateSource() {
    exists(ParamDecl p, Function f, AdoptsWkNavigationDelegate t |
      t.getAMember() = f and
      f.getName() =
        [
          "webView(_:decidePolicyFor:preferences:decisionHandler:)",
          "webView(_:decidePolicyFor:decisionHandler:)"
        ] and
      p.getDeclaringFunction() = f and
      p.getIndex() = 1 and
      this.asParameter() = p
    )
  }

  override string getSourceType() { result = "Navigation action of a WebView" }
}

/**
 * A content implying that, if a `WKNavigationAction` is tainted, its
 * `request` field is also tainted.
 */
private class UrlRequestFieldsInheritTaint extends TaintInheritingContent,
  DataFlow::Content::FieldContent
{
  UrlRequestFieldsInheritTaint() {
    this.getField().getEnclosingDecl().asNominalTypeDecl().getName() = "WKNavigationAction" and
    this.getField().getName() = "request"
  }
}

/**
 * A model for `JSContext` sources. `JSContext` acts as a bridge between JavaScript and
 * native code, so any object obtained from it has the potential of being tainted by a malicious
 * website visited in the WebView.
 */
private class JsContextSources extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        ";JSContext;true;globalObject;;;;remote",
        ";JSContext;true;objectAtIndexedSubscript(_:);;;ReturnValue;remote",
        ";JSContext;true;objectForKeyedSubscript(_:);;;ReturnValue;remote"
      ]
  }
}

/**
 * A model for `JSValue` summaries. If a `JSValue` is tainted, any object it is converted into
 * is also tainted.
 */
private class JsValueSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";JSValue;true;init(object:in:);;;Argument[0];ReturnValue;taint",
        ";JSValue;true;init(bool:in:);;;Argument[0];ReturnValue;taint",
        ";JSValue;true;init(double:in:);;;Argument[0];ReturnValue;taint",
        ";JSValue;true;init(int32:in:);;;Argument[0];ReturnValue;taint",
        ";JSValue;true;init(uInt32:in:);;;Argument[0];ReturnValue;taint",
        ";JSValue;true;init(point:in:);;;Argument[0];ReturnValue;taint",
        ";JSValue;true;init(range:in:);;;Argument[0];ReturnValue;taint",
        ";JSValue;true;init(rect:in:);;;Argument[0];ReturnValue;taint",
        ";JSValue;true;init(size:in:);;;Argument[0];ReturnValue;taint",
        ";JSValue;true;toObject();;;Argument[-1];ReturnValue;taint",
        ";JSValue;true;toObjectOf(_:);;;Argument[-1];ReturnValue;taint",
        ";JSValue;true;toBool();;;Argument[-1];ReturnValue;taint",
        ";JSValue;true;toDouble();;;Argument[-1];ReturnValue;taint",
        ";JSValue;true;toInt32();;;Argument[-1];ReturnValue;taint",
        ";JSValue;true;toUInt32();;;Argument[-1];ReturnValue;taint",
        ";JSValue;true;toNumber();;;Argument[-1];ReturnValue;taint",
        ";JSValue;true;toString();;;Argument[-1];ReturnValue;taint",
        ";JSValue;true;toDate();;;Argument[-1];ReturnValue;taint",
        ";JSValue;true;toArray();;;Argument[-1];ReturnValue;taint",
        ";JSValue;true;toDictionary();;;Argument[-1];ReturnValue;taint",
        ";JSValue;true;toPoint();;;Argument[-1];ReturnValue;taint",
        ";JSValue;true;toRange();;;Argument[-1];ReturnValue;taint",
        ";JSValue;true;toRect();;;Argument[-1];ReturnValue;taint",
        ";JSValue;true;toSize();;;Argument[-1];ReturnValue;taint",
        ";JSValue;true;atIndex(_:);;;Argument[-1];ReturnValue;taint",
        ";JSValue;true;defineProperty(_:descriptor:);;;Argument[1];Argument[-1];taint",
        ";JSValue;true;forProperty(_:);;;Argument[-1];ReturnValue;taint",
        ";JSValue;true;setValue(_:at:);;;Argument[0];Argument[-1];taint",
        ";JSValue;true;setValue(_:forProperty:);;;Argument[0];Argument[-1];taint"
      ]
  }
}

/** The `JSExport` protocol. */
private class JsExport extends ProtocolDecl {
  JsExport() { this.getName() = "JSExport" }
}

/** A protocol inheriting `JSExport`. */
private class JsExportedProto extends ProtocolDecl {
  JsExportedProto() { this.getABaseTypeDecl+() instanceof JsExport }
}

/** A type that adopts a `JSExport`-inherited protocol. */
private class JsExportedType extends ClassOrStructDecl {
  JsExportedType() { this.getABaseTypeDecl*() instanceof JsExportedProto }
}

/**
 * A flow source that models properties and methods defined in a `JSExport`-inherited protocol
 * and implemented in a type adopting that protcol. These members are accessible from JavaScript
 * when the object is assigned to a `JSContext`.
 */
private class JsExportedSource extends RemoteFlowSource {
  JsExportedSource() {
    exists(Method adopter, Method base |
      base.getEnclosingDecl().asNominalTypeDecl() instanceof JsExportedProto and
      adopter.getEnclosingDecl().asNominalTypeDecl() instanceof JsExportedType
    |
      this.asParameter().getDeclaringFunction() = adopter and
      pragma[only_bind_out](adopter.getName()) = pragma[only_bind_out](base.getName())
    )
    or
    exists(FieldDecl adopter, FieldDecl base |
      base.getEnclosingDecl().asNominalTypeDecl() instanceof JsExportedProto and
      adopter.getEnclosingDecl().asNominalTypeDecl() instanceof JsExportedType
    |
      this.asExpr().(MemberRefExpr).getMember() = adopter and
      pragma[only_bind_out](adopter.getName()) = pragma[only_bind_out](base.getName())
    )
  }

  override string getSourceType() { result = "Member of a type exposed through JSExport" }
}

/**
 * A model for `WKUserScript` summaries.
 */
private class WKUserScriptSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";WKUserScript;true;init(source:injectionTime:forMainFrameOnly:);;;Argument[0];ReturnValue;taint",
        ";WKUserScript;true;init(source:injectionTime:forMainFrameOnly:in:);;;Argument[0];ReturnValue;taint"
      ]
  }
}

/**
 * A content implying that, if a `WKUserScript` is tainted, its `source` field is tainted.
 */
private class WKUserScriptInheritsTaint extends TaintInheritingContent,
  DataFlow::Content::FieldContent
{
  WKUserScriptInheritsTaint() { this.getField().hasQualifiedName("WKUserScript", "source") }
}
