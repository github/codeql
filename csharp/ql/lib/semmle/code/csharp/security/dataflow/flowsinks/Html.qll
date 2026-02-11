/**
 * Provides classes representing HTML data flow sinks.
 */

import csharp
private import Remote
private import semmle.code.csharp.frameworks.microsoft.AspNetCore
private import semmle.code.csharp.frameworks.system.Net
private import semmle.code.csharp.frameworks.system.Web
private import semmle.code.csharp.frameworks.system.web.Mvc
private import semmle.code.csharp.frameworks.system.web.WebPages
private import semmle.code.csharp.frameworks.system.web.UI
private import semmle.code.csharp.frameworks.system.web.ui.WebControls
private import semmle.code.csharp.frameworks.system.windows.Forms
private import semmle.code.csharp.security.dataflow.flowsources.Remote
private import semmle.code.csharp.dataflow.internal.ExternalFlow
private import semmle.code.asp.AspNet

/**
 * A sink where the value of the expression may be rendered as HTML,
 * without implicit HTML encoding.
 */
abstract class HtmlSink extends DataFlow::ExprNode, RemoteFlowSink { }

private class ExternalHtmlSink extends HtmlSink {
  ExternalHtmlSink() { sinkNode(this, "html-injection") }
}

/**
 * An expression that is used as an argument to an HTML sink method on
 * `HtmlTextWriter`.
 */
class HtmlTextWriterSink extends HtmlSink {
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
 * DEPRECATED: Attribute collections are no longer considered HTML sinks.
 */
deprecated class AttributeCollectionSink extends DataFlow::ExprNode {
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
class SetAttributeSink extends HtmlSink {
  SetAttributeSink() {
    this.getExpr() =
      any(SystemWindowsFormsHtmlElement c).getSetAttributeMethod().getACall().getArgument(1)
  }
}

/**
 * An expression that is used as an argument to an HTML sink setter, on
 * a class within the `System.Web.UI` namespace.
 */
class SystemWebSetterHtmlSink extends HtmlSink {
  SystemWebSetterHtmlSink() {
    exists(Property p, string name, ValueOrRefType declaringType |
      declaringType = p.getDeclaringType() and
      any(SystemWebUINamespace n).getAChildNamespace*() = declaringType.getNamespace() and
      this.getExpr() = p.getAnAssignedValue() and
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
 * An expression that is used as an argument to `HtmlHelper.Raw`, typically in
 * a `.cshtml` file.
 */
class SystemWebMvcHtmlHelperRawSink extends HtmlSink {
  SystemWebMvcHtmlHelperRawSink() {
    this.getExpr() = any(SystemWebMvcHtmlHelperClass h).getRawMethod().getACall().getAnArgument()
  }
}

/** An expression that is returned from a `ToHtmlString` method. */
class ToHtmlString extends HtmlSink {
  ToHtmlString() {
    exists(Method toHtmlString |
      toHtmlString = any(SystemWebIHtmlString i).getToHtmlStringMethod().getAnUltimateImplementor() and
      toHtmlString.canReturn(this.getExpr())
    )
  }
}

/**
 * An expression passed to the constructor of an `HtmlString` or a `MvcHtmlString`.
 */
class HtmlString extends HtmlSink {
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
 * An expression that is used as an argument to `Page.WriteLiteral`, typically in
 * a `.cshtml` file.
 */
class WebPageWriteLiteralSink extends HtmlSink {
  WebPageWriteLiteralSink() {
    this.getExpr() = any(WebPageClass h).getWriteLiteralMethod().getACall().getAnArgument()
  }
}

/**
 * An expression that is used as an argument to `Page.WriteLiteralTo`, typically in
 * a `.cshtml` file.
 */
class WebPageWriteLiteralToSink extends HtmlSink {
  WebPageWriteLiteralToSink() {
    this.getExpr() = any(WebPageClass h).getWriteLiteralToMethod().getACall().getAnArgument()
  }
}

/** An ASP.NET Core HTML sink. */
abstract class AspNetCoreHtmlSink extends HtmlSink { }

/**
 * An expression that is used as an argument to `IHtmlHelper.Raw`, typically in
 * a `.cshtml` file.
 */
class MicrosoftAspNetCoreMvcHtmlHelperRawSink extends AspNetCoreHtmlSink {
  MicrosoftAspNetCoreMvcHtmlHelperRawSink() {
    exists(Call c, Callable target |
      c.getTarget() = target and
      target.hasName("Raw") and
      target.getDeclaringType().getABaseType*() instanceof
        MicrosoftAspNetCoreMvcRenderingIHtmlHelperInterface and
      this.getExpr() = c.getAnArgument()
    )
  }
}

/**
 * An expression that is used as an argument to `Page.WriteLiteral` in ASP.NET 6.0 razor page, typically in
 * a `.cshtml` file.
 */
class MicrosoftAspNetRazorPageWriteLiteralSink extends AspNetCoreHtmlSink {
  MicrosoftAspNetRazorPageWriteLiteralSink() {
    this.getExpr() =
      any(MicrosoftAspNetCoreMvcRazorPageBase h).getWriteLiteralMethod().getACall().getAnArgument()
  }
}

/** `HtmlString` that may be rendered as is need to have sanitized value. */
class MicrosoftAspNetHtmlStringSink extends AspNetCoreHtmlSink {
  MicrosoftAspNetHtmlStringSink() {
    exists(ObjectCreation c, MicrosoftAspNetCoreHttpHtmlString s |
      c.getTarget() = s.getAConstructor() and
      this.asExpr() = c.getAnArgument()
    )
  }
}
