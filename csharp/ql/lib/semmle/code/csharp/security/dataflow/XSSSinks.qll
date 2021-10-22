/**
 * Provides sink definitions for cross-site scripting (XSS) vulnerabilities.
 */

import csharp
private import semmle.code.asp.AspNet
private import semmle.code.csharp.frameworks.system.Net
private import semmle.code.csharp.frameworks.system.Web
private import semmle.code.csharp.frameworks.system.web.UI
private import semmle.code.csharp.security.dataflow.flowsinks.Html
private import semmle.code.csharp.security.dataflow.flowsinks.Remote
private import semmle.code.csharp.dataflow.ExternalFlow
private import semmle.code.csharp.frameworks.ServiceStack::XSS

/**
 * A data flow sink for cross-site scripting (XSS) vulnerabilities.
 *
 * Any XSS sink is also a remote flow sink, so this class contributes
 * to the abstract class `RemoteFlowSink`.
 */
abstract class Sink extends DataFlow::ExprNode, RemoteFlowSink {
  /** Gets an explanation of this XSS sink. */
  string explanation() { none() }
}

private class ExternalXssSink extends Sink {
  ExternalXssSink() { sinkNode(this, "xss") }
}

private class HtmlSinkSink extends Sink {
  HtmlSinkSink() { this instanceof HtmlSink }

  override string explanation() {
    this instanceof WebPageWriteLiteralSink and
    result = "System.Web.WebPages.WebPage.WriteLiteral() method"
    or
    this instanceof WebPageWriteLiteralToSink and
    result = "System.Web.WebPages.WebPage.WriteLiteralTo() method"
    or
    this instanceof MicrosoftAspNetCoreMvcHtmlHelperRawSink and
    result = "Microsoft.AspNetCore.Mvc.ViewFeatures.HtmlHelper.Raw() method"
    or
    this instanceof MicrosoftAspNetRazorPageWriteLiteralSink and
    result = "Microsoft.AspNetCore.Mvc.Razor.RazorPageBase.WriteLiteral() method"
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

  /** Gets the type of this member. */
  Type getType() { result = getMemberType(this.getMember()) }
}

/** Gets a value that is written to the member accessed by the given `AspInlineMember`. */
private Expr aspWrittenValue(AspInlineMember m) {
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
    result =
      "member is [[\"accessed inline\"|\"" + makeUrl(inline.getLocation()) + "\"]] in an ASPX page"
  }
}

/** A sink for the output stream associated with a `HttpListenerResponse`. */
private class HttpListenerResponseSink extends Sink {
  HttpListenerResponseSink() {
    exists(PropertyAccess responseOutputStream |
      responseOutputStream.getProperty() =
        any(SystemNetHttpListenerResponseClass h).getOutputStreamProperty()
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

/**
 * An expression passed as the `content` argument to the constructor of `StringContent`.
 */
private class StringContentSinkModelCsv extends SinkModelCsv {
  override predicate row(string row) {
    row = "System.Net.Http;StringContent;false;StringContent;;;Argument[0];xss"
  }
}

private Type getMemberType(Member m) {
  result = m.(Property).getType() or
  result = m.(Field).getType() or
  result = m.(Callable).getReturnType()
}
