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
  DataFlow::Content::FieldContent {
  WKScriptMessageBodyInheritsTaint() {
    exists(FieldDecl f | this.getField() = f |
      f.getEnclosingDecl() instanceof WKScriptMessageDecl and
      f.getName() = "body"
    )
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
        // TODO: These models could use content flow to be more precise
        ";JSValue;true;atIndex(_:);;;Argument[-1];ReturnValue;taint",
        ";JSValue;true;defineProperty(_:descriptor:);;;Argument[1];Argument[-1];taint",
        ";JSValue;true;forProperty(_:);;;Argument[-1];ReturnValue;taint",
        ";JSValue;true;setValue(_:at:);;;Argument[0];Argument[-1];taint",
        ";JSValue;true;setValue(_:forProperty:);;;Argument[0];Argument[-1];taint"
      ]
  }
}

/** The class `JSContext`. */
private class JsContextDecl extends ClassDecl {
  JsContextDecl() { this.getName() = "JSContext" }
}

/** The type of an object exposed to JavaScript through `JSContext.setObject`. */
private class TypeExposedThroughJsContext extends Type {
  TypeExposedThroughJsContext() {
    exists(ApplyExpr c, FuncDecl f |
      c.getStaticTarget() = f and
      f.getEnclosingDecl() instanceof JsContextDecl and
      f.getName() = "setObject(_:forKeyedSubscript)"
    |
      c.getArgument(0).getExpr().getType() = this
    )
  }
}

/**
 * The members (fields and parameters of functions) of a class or struct
 * an instance of which is exposed to JavaScript through `JSContext.setObject`.
 */
private class ExposedThroughJsContextSource extends RemoteFlowSource {
  ExposedThroughJsContextSource() {
    exists(ParamDecl p | this.(DataFlow::ParameterNode).getParameter() = p |
      p.getDeclaringFunction().getEnclosingDecl().(ClassOrStructDecl).getType() instanceof
        TypeExposedThroughJsContext
    )
    or
    exists(FieldDecl f | this.asDefinition().getSourceVariable() = f |
      f.getEnclosingDecl().(ClassOrStructDecl).getType() instanceof TypeExposedThroughJsContext
    )
  }

  override string getSourceType() { result = "Member of a type exposed through JSContext" }
}
