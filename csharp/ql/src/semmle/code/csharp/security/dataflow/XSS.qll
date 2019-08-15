/**
 * Provides a taint-tracking configuration for reasoning about cross-site scripting
 * (XSS) vulnerabilities.
 */

import csharp

module XSS {
  import semmle.code.csharp.dataflow.flowsources.Remote
  import semmle.code.csharp.frameworks.microsoft.AspNetCore
  import semmle.code.csharp.frameworks.system.Net
  import semmle.code.csharp.frameworks.system.Web
  import semmle.code.csharp.frameworks.system.web.Mvc
  import semmle.code.csharp.frameworks.system.web.WebPages
  import semmle.code.csharp.frameworks.system.web.UI
  import semmle.code.csharp.frameworks.system.web.ui.WebControls
  import semmle.code.csharp.frameworks.system.windows.Forms
  import semmle.code.csharp.security.Sanitizers
  import semmle.code.asp.AspNet

  /**
   * Holds if there is tainted flow from `source` to `sink` that may lead to a
   * cross-site scripting (XSS) vulnerability, with `message`
   * providing a description of the source.
   * This is the main predicate to use in XSS queries.
   */
  predicate xssFlow(XssNode source, XssNode sink, string message) {
    // standard taint-tracking
    exists(
      TaintTrackingConfiguration c, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode
    |
      sourceNode = source.asDataFlowNode() and
      sinkNode = sink.asDataFlowNode() and
      c.hasFlowPath(sourceNode, sinkNode) and
      message = "is written to HTML or JavaScript" +
          any(string explanation |
            if exists(sinkNode.getNode().(Sink).explanation())
            then explanation = ": " + sinkNode.getNode().(Sink).explanation() + "."
            else explanation = "."
          )
    )
    or
    // flow entirely within ASP inline code
    source = sink and
    source.asAspInlineMember().getMember() instanceof AspNetQueryStringMember and
    message = "is a remote source accessed inline in an ASPX page."
  }

  module PathGraph {
    query predicate edges(XssNode pred, XssNode succ) {
      exists(DataFlow::PathNode a, DataFlow::PathNode b | DataFlow::PathGraph::edges(a, b) |
        pred.asDataFlowNode() = a and
        succ.asDataFlowNode() = b
      )
      or
      xssFlow(pred, succ, _) and
      pred instanceof XssAspNode
    }
  }

  private newtype TXssNode =
    TXssDataFlowNode(DataFlow::PathNode node) or
    TXssAspNode(AspInlineMember m)

  /**
   * A flow node for tracking cross-site scripting (XSS) vulnerabilities.
   * Can be a standard data flow node (`XssDataFlowNode`)
   * or an ASP inline code element (`XssAspNode`).
   */
  class XssNode extends TXssNode {
    /** Gets a textual representation of this node. */
    string toString() { none() }

    /** Gets the location of this node. */
    Location getLocation() { none() }

    /** Gets the data flow node corresponding to this node, if any. */
    DataFlow::PathNode asDataFlowNode() { result = this.(XssDataFlowNode).getDataFlowNode() }

    /** Gets the ASP inline code element corresponding to this node, if any. */
    AspInlineMember asAspInlineMember() { result = this.(XssAspNode).getAspInlineMember() }
  }

  /** A data flow node, viewed as an XSS flow node. */
  class XssDataFlowNode extends TXssDataFlowNode, XssNode {
    DataFlow::PathNode node;

    XssDataFlowNode() { this = TXssDataFlowNode(node) }

    /** Gets the data flow node corresponding to this node. */
    DataFlow::PathNode getDataFlowNode() { result = node }

    override string toString() { result = node.toString() }

    override Location getLocation() { result = node.getNode().getLocation() }
  }

  /** An ASP inline code element, viewed as an XSS flow node. */
  class XssAspNode extends TXssAspNode, XssNode {
    AspInlineMember member;

    XssAspNode() { this = TXssAspNode(member) }

    /** Gets the ASP inline code element corresponding to this node. */
    AspInlineMember getAspInlineMember() { result = member }

    override string toString() { result = member.toString() }

    override Location getLocation() { result = member.getLocation() }
  }

  /**
   * A data flow sink for cross-site scripting (XSS) vulnerabilities.
   */
  abstract class Sink extends DataFlow::ExprNode {
    string explanation() { none() }
  }

  /**
   * A data flow source for cross-site scripting (XSS) vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A sanitizer for cross-site scripting (XSS) vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::ExprNode { }

  /**
   * A taint-tracking configuration for cross-site scripting (XSS) vulnerabilities.
   */
  class TaintTrackingConfiguration extends TaintTracking::Configuration {
    TaintTrackingConfiguration() { this = "XSSDataFlowConfiguration" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
  }

  /** A source of remote user input. */
  class RemoteSource extends Source {
    RemoteSource() { this instanceof RemoteFlowSource }
  }

  private class SimpleTypeSanitizer extends Sanitizer, SimpleTypeSanitizedExpr { }

  private class GuidSanitizer extends Sanitizer, GuidSanitizedExpr { }

  /** A call to an HTML encoder. */
  private class HtmlEncodeSanitizer extends Sanitizer {
    HtmlEncodeSanitizer() { this.getExpr() instanceof HtmlSanitizedExpr }
  }

  /**
   * A call to a URL encoder.
   *
   * Url encoding is sufficient to sanitize for XSS because it ensures <, >, " and ' are escaped.
   * Furthermore, URL encoding is the only valid way to sanitize URLs that get inserted into HTML
   * attributes. Other uses of URL encoding may or may not produce the desired visual result, but
   * should be safe from XSS.
   */
  private class UrlEncodeSanitizer extends Sanitizer {
    UrlEncodeSanitizer() { this.getExpr() instanceof UrlSanitizedExpr }
  }

  /** A sink where the value of the expression may be rendered as HTML. */
  abstract class HtmlSink extends DataFlow::Node { }

  /**
   * An expression that is used as an argument to an XSS sink method on
   * `HttpResponse`.
   */
  private class HttpResponseSink extends Sink, HtmlSink {
    HttpResponseSink() {
      exists(Method m, SystemWebHttpResponseClass responseClass |
        m = responseClass.getAWriteMethod() or
        m = responseClass.getAWriteFileMethod() or
        m = responseClass.getATransmitFileMethod() or
        m = responseClass.getABinaryWriteMethod()
      |
        // Calls to these methods, or overrides of them
        this.getExpr() = m.getAnOverrider*().getParameter(0).getAnAssignedArgument()
      )
    }
  }

  /**
   * An expression that is used as an argument to an XSS sink method on
   * `HtmlTextWriter`.
   */
  private class HtmlTextWriterSink extends Sink, HtmlSink {
    HtmlTextWriterSink() {
      exists(SystemWebUIHtmlTextWriterClass writeClass, Method m, Call c, int paramPos |
        paramPos = 0 and
        (
          m = writeClass.getAWriteMethod() or
          m = writeClass.getAWriteLineMethod() or
          m = writeClass.getAWriteLineNoTabsMethod() or
          m = writeClass.getAWriteBeginTagMethod() or
          m = writeClass.getAWriteAttributeMethod()
        )
        or
        // The second parameter to the `WriteAttribute` method is the attribute value, which we
        // should only consider as tainted if the call does not ask for the attribute value to be
        // encoded using the final parameter.
        m = writeClass.getAWriteAttributeMethod() and
        paramPos = 1 and
        not c.getArgumentForParameter(m.getParameter(2)).(BoolLiteral).getBoolValue() = true
      |
        c = m.getACall() and
        this.getExpr() = c.getArgumentForParameter(m.getParameter(paramPos))
      )
    }
  }

  /**
   * An expression that is used as an argument to an XSS sink method on
   * `AttributeCollection`.
   */
  private class AttributeCollectionSink extends Sink, HtmlSink {
    AttributeCollectionSink() {
      exists(SystemWebUIAttributeCollectionClass ac, Parameter p |
        p = ac.getAddMethod().getParameter(1) or
        p = ac.getItemProperty().getSetter().getParameter(0)
      |
        this.getExpr() = p.getAnAssignedArgument()
      )
    }
  }

  /**
   * An expression that is used as the second argument `HtmlElement.SetAttribute`.
   */
  private class SetAttributeSink extends Sink, HtmlSink {
    SetAttributeSink() {
      this.getExpr() = any(SystemWindowsFormsHtmlElement c)
            .getSetAttributeMethod()
            .getACall()
            .getArgument(1)
    }
  }

  /**
   * An expression that is used as an argument to an XSS sink method on
   * `System.Web.UI.Page`.
   */
  private class PageSink extends Sink {
    PageSink() {
      exists(Property p, SystemWebUIPageClass page |
        p = page.getIDProperty() or
        p = page.getMetaDescriptionProperty() or
        p = page.getMetaKeywordsProperty() or
        p = page.getTitleProperty()
      |
        this.getExpr() = p.getSetter().getParameter(0).getAnAssignedArgument()
      )
      or
      exists(Method m, SystemWebUIPageClass page |
        m = page.getRegisterStartupScriptMethod() or
        m = page.getRegisterClientScriptBlockMethod()
      |
        this.getExpr() = m.getAParameter().getAnAssignedArgument()
      )
    }
  }

  /**
   * An expression that is used as an argument to an XSS sink method on
   * `ClientScriptManager`.
   */
  private class ClientScriptManagerSink extends Sink {
    ClientScriptManagerSink() {
      exists(Method m, SystemWebUIClientScriptManagerClass clientScriptManager, int paramNumber |
        this.getExpr() = m.getParameter(paramNumber).getAnAssignedArgument() and
        (
          paramNumber = 2 and m.getNumberOfParameters() in [3 .. 4]
          or
          paramNumber = 3 and m.getNumberOfParameters() = 5
        )
      |
        m = clientScriptManager.getRegisterClientScriptBlockMethod() or
        m = clientScriptManager.getRegisterStartupScriptMethod()
      )
    }
  }

  /**
   * An expression that is used as an argument to an XSS sink setter, on
   * a class within the `System.Web.UI` namespace.
   */
  private class SystemWebSetterHtmlSink extends Sink, HtmlSink {
    SystemWebSetterHtmlSink() {
      exists(Property p, string name, ValueOrRefType declaringType |
        declaringType = p.getDeclaringType() and
        any(SystemWebUINamespace n).getAChildNamespace*() = declaringType.getNamespace() and
        this.getExpr() = p.getSetter().getParameter(0).getAnAssignedArgument() and
        p.hasName(name)
      |
        name = "Caption" and
        (declaringType.hasName("Calendar") or declaringType.hasName("Table"))
        or
        name = "InnerHtml"
      )
      or
      exists(SystemWebUIWebControlsLabelClass c |
        // Unlike `Text` properties of other web controls, `Label.Text` is not automatically HTML encoded
        this.getExpr() = c.getTextProperty().getSetter().getParameter(0).getAnAssignedArgument()
      )
    }
  }

  /**
   * An expression that is used as an argument to an XSS sink setter, on
   * a class within the `System.Web.UI` namespace.
   */
  private class SystemWebSetterNonHtmlSink extends Sink {
    SystemWebSetterNonHtmlSink() {
      exists(Property p, string name |
        any(SystemWebUINamespace n).getAChildNamespace*() = p.getDeclaringType().getNamespace() and
        this.getExpr() = p.getSetter().getParameter(0).getAnAssignedArgument() and
        p.hasName(name)
      |
        name = "GroupingTest" or
        name = "GroupName" or
        name = "Style" or
        name.matches("%URL")
      )
    }
  }

  /**
   * A call to `Parse` for a numeric type, that causes the data to be considered
   * sanitized.
   */
  private class NumericTypeParse extends Sanitizer {
    NumericTypeParse() {
      exists(Method m |
        m.getDeclaringType() instanceof IntegralType or
        m.getDeclaringType() instanceof FloatingPointType
      |
        m.hasName("Parse") and
        this.getExpr().(Call).getTarget() = m
      )
    }
  }

  /**
   * An expression that is used as an argument to `HtmlHelper.Raw`, typically in
   * a `.cshtml` file.
   */
  private class SystemWebMvcHtmlHelperRawSink extends Sink, HtmlSink {
    SystemWebMvcHtmlHelperRawSink() {
      this.getExpr() = any(SystemWebMvcHtmlHelperClass h).getRawMethod().getACall().getAnArgument()
    }
  }

  /**
   * Gets a member which is accessed by the given `AspInlineCode`.
   * The code body must consist only of an access to the member, possibly with qualified
   * field accesses or array indexing.
   */
  private Member aspxInlineAccess(AspInlineCode code) {
    result = max(int i, Member m | m = getMemberAccessByIndex(code, i) | m order by i)
  }

  /**
   * Gets the `i`th member accessed by `code`, where the string in `code`
   * must be of the form `f1.f2...fn`, `f1.f2...fn[...]`, `f1.f2...fn()`, or
   * `f1.f2...fn[...]()`. The `i`th member is `fi` in all cases.
   */
  private Member getMemberAccessByIndex(AspInlineCode code, int i) {
    exists(ValueOrRefType t |
      result.getName() = getMemberAccessNameByIndex(code, i) and
      t.hasMember(result)
    |
      // Base case: a member on the code-behind class
      i = 0 and
      t = code.getLocation().getFile().(CodeBehindFile).getInheritedType()
      or
      // Recursive case: a nested member
      exists(Member mid |
        mid = getMemberAccessByIndex(code, i - 1) and
        t = getMemberType(mid)
      )
    )
  }

  /**
   * Gets the name of the `i`th member accessed by `code`, where the string in `code`
   * must be of the form `f1.f2...fn`, `f1.f2...fn[...]`, `f1.f2...fn()`, or
   * `f1.f2...fn[...]()`. The `i`th member is `fi` in all cases.
   */
  private string getMemberAccessNameByIndex(AspInlineCode code, int i) {
    // Strip:
    // - leading and trailing whitespace, which apparently you're allowed to have
    // - trailing parens, so we can recognize nullary method calls
    // - trailing square brackets with some contents, to recognize indexing into arrays
    result = code.getBody().splitAt(".", i).regexpCapture("\\s*(.*?)(\\[.*\\])?(\\(\\))?\\s*", 1)
  }

  /**
   * An `AspInlineCode` which is an access to a member inherited from the
   * corresponding 'CodeBehind' class. This includes direct accesses as well as
   * qualified accesses or array indexing on the member.
   */
  class AspInlineMember extends AspInlineCode {
    Member member;

    AspInlineMember() { member = aspxInlineAccess(this) }

    /** Gets the member that this inline code references. */
    Member getMember() { result = member }

    Type getType() { result = getMemberType(getMember()) }
  }

  /** Gets a value that is written to the member accessed by the given `AspInlineMember`. */
  Expr aspWrittenValue(AspInlineMember m) {
    exists(Property p | p = m.getMember() |
      // a directly assigned property
      result = p.getAnAssignedValue()
      or
      // one step of flow through a variable returned by the getter
      // this is mainly to handle trivial forwarding properties
      exists(VariableAccess access |
        p.getGetter().canReturn(access) and
        result = access.getTarget().getAnAssignedValue()
      )
    )
    or
    result = m.getMember().(Field).getAnAssignedValue()
    or
    m.getMember().(Callable).canReturn(result)
  }

  private string makeUrl(Location l) {
    exists(string path, int sl, int sc, int el, int ec |
      l.hasLocationInfo(path, sl, sc, el, ec) and
      result = "file://" + path + ":" + sl + ":" + sc + ":" + el + ":" + ec
    )
  }

  /**
   * A sink for writes to properties that are accessed in ASP pages.
   *
   * Currently we only support inline code tags that directly reference a member
   * on the corresponding 'CodeBehind' class.
   * This may include qualified accesses to fields or array indexing on the member.
   * The sink is any assigned value of such a
   * member, since we don't track the flow all the way to the ASP element.
   */
  private class AspxCodeSink extends Sink {
    /** The ASP inline code element that references a member of the backing class. */
    AspInlineMember inline;

    AspxCodeSink() { this.getExpr() = aspWrittenValue(inline) }

    override string explanation() {
      result = "member is [[\"accessed inline\"|\"" + makeUrl(inline.getLocation()) +
          "\"]] in an ASPX page"
    }
  }

  /** A sink for the output stream associated with a `HttpListenerResponse`. */
  private class HttpListenerResponseSink extends Sink {
    HttpListenerResponseSink() {
      exists(PropertyAccess responseOutputStream |
        responseOutputStream.getProperty() = any(SystemNetHttpListenerResponseClass h)
              .getOutputStreamProperty()
      |
        DataFlow::localFlow(DataFlow::exprNode(responseOutputStream), this)
      )
    }
  }

  /**
   * An expression that is used as an argument to an XSS sink method on
   * `HttpResponseBase`.
   */
  private class HttpResponseBaseSink extends Sink {
    HttpResponseBaseSink() {
      exists(Method m, SystemWebHttpResponseBaseClass responseClass |
        m = responseClass.getAWriteMethod() or
        m = responseClass.getAWriteFileMethod() or
        m = responseClass.getATransmitFileMethod() or
        m = responseClass.getABinaryWriteMethod()
      |
        // Calls to these methods, or overrides of them
        this.getExpr() = m.getAnOverrider*().getParameter(0).getAnAssignedArgument()
      )
    }
  }

  /** An expression that is returned from a `ToHtmlString` method. */
  private class ToHtmlString extends Sink, HtmlSink {
    ToHtmlString() {
      exists(Method toHtmlString |
        toHtmlString = any(SystemWebIHtmlString i)
              .getToHtmlStringMethod()
              .getAnUltimateImplementor() and
        toHtmlString.canReturn(this.getExpr())
      )
    }
  }

  /**
   * An expression passed to the constructor of an `HtmlString` or a `MvcHtmlString`.
   */
  private class HtmlString extends Sink, HtmlSink {
    HtmlString() {
      exists(Class c |
        c = any(SystemWebMvcMvcHtmlString m) or
        c = any(SystemWebHtmlString m)
      |
        this.getExpr() = c.getAConstructor().getACall().getAnArgument()
      )
    }
  }

  /**
   * An expression passed as the `content` argument to the constructor of `StringContent`.
   */
  private class StringContent extends Sink {
    StringContent() {
      this.getExpr() = any(ObjectCreation oc |
          oc.getTarget().getDeclaringType().hasQualifiedName("System.Net.Http", "StringContent")
        ).getArgumentForName("content")
    }
  }

  /**
   * An expression that is used as an argument to `Page.WriteLiteral`, typically in
   * a `.cshtml` file.
   */
  class WebPageWriteLiteralSink extends Sink, HtmlSink {
    WebPageWriteLiteralSink() {
      this.getExpr() = any(WebPageClass h).getWriteLiteralMethod().getACall().getAnArgument()
    }

    override string explanation() { result = "System.Web.WebPages.WebPage.WriteLiteral() method" }
  }

  /**
   * An expression that is used as an argument to `Page.WriteLiteralTo`, typically in
   * a `.cshtml` file.
   */
  class WebPageWriteLiteralToSink extends Sink, HtmlSink {
    WebPageWriteLiteralToSink() {
      this.getExpr() = any(WebPageClass h).getWriteLiteralToMethod().getACall().getAnArgument()
    }

    override string explanation() { result = "System.Web.WebPages.WebPage.WriteLiteralTo() method" }
  }

  abstract class AspNetCoreSink extends Sink, HtmlSink { }

  /**
   * An expression that is used as an argument to `HtmlHelper.Raw`, typically in
   * a `.cshtml` file.
   */
  class MicrosoftAspNetCoreMvcHtmlHelperRawSink extends AspNetCoreSink {
    MicrosoftAspNetCoreMvcHtmlHelperRawSink() {
      this.getExpr() = any(MicrosoftAspNetCoreMvcHtmlHelperClass h)
            .getRawMethod()
            .getACall()
            .getAnArgument()
    }

    override string explanation() {
      result = "Microsoft.AspNetCore.Mvc.ViewFeatures.HtmlHelper.Raw() method"
    }
  }

  /**
   * An expression that is used as an argument to `Page.WriteLiteral` in ASP.NET 6.0 razor page, typically in
   * a `.cshtml` file.
   */
  class MicrosoftAspNetRazorPageWriteLiteralSink extends AspNetCoreSink {
    MicrosoftAspNetRazorPageWriteLiteralSink() {
      this.getExpr() = any(MicrosoftAspNetCoreMvcRazorPageBase h)
            .getWriteLiteralMethod()
            .getACall()
            .getAnArgument()
    }

    override string explanation() {
      result = "Microsoft.AspNetCore.Mvc.Razor.RazorPageBase.WriteLiteral() method"
    }
  }

  /** `HtmlString` that may be rendered as is need to have sanitized value. */
  class MicrosoftAspNetHtmlStringSink extends AspNetCoreSink {
    MicrosoftAspNetHtmlStringSink() {
      exists(ObjectCreation c, MicrosoftAspNetCoreHttpHtmlString s |
        c.getTarget() = s.getAConstructor() and
        this.asExpr() = c.getAnArgument()
      )
    }
  }
}

private Type getMemberType(Member m) {
  result = m.(Property).getType() or
  result = m.(Field).getType() or
  result = m.(Callable).getReturnType()
}
