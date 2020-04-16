/**
 * Provides classes representing data flow sources for remote user input.
 */

import csharp
private import semmle.code.csharp.frameworks.system.Net
private import semmle.code.csharp.frameworks.system.Web
private import semmle.code.csharp.frameworks.system.web.Http
private import semmle.code.csharp.frameworks.system.web.Mvc
private import semmle.code.csharp.frameworks.system.web.Services
private import semmle.code.csharp.frameworks.system.web.ui.WebControls
private import semmle.code.csharp.frameworks.WCF
private import semmle.code.csharp.frameworks.microsoft.Owin
private import semmle.code.csharp.frameworks.microsoft.AspNetCore

/** A data flow source of remote user input. */
abstract class RemoteFlowSource extends DataFlow::Node {
  /** Gets a string that describes the type of this remote flow source. */
  abstract string getSourceType();
}

/** A data flow source of remote user input (ASP.NET). */
abstract class AspNetRemoteFlowSource extends RemoteFlowSource { }

/** A member containing an ASP.NET query string. */
class AspNetQueryStringMember extends Member {
  AspNetQueryStringMember() {
    exists(RefType t |
      t instanceof SystemWebHttpRequestClass or
      t instanceof SystemNetHttpListenerRequestClass or
      t instanceof SystemWebHttpRequestBaseClass
    |
      this = t.getProperty(getHttpRequestFlowPropertyNames()) or
      this.(Field).getType() = t or
      this.(Property).getType() = t or
      this.(Callable).getReturnType() = t
    )
  }
}

/**
 * Gets the names of the properties in `HttpRequest` classes that should propagate taint out of the
 * request.
 */
private string getHttpRequestFlowPropertyNames() {
  result = "QueryString" or
  result = "Headers" or
  result = "RawUrl" or
  result = "Url" or
  result = "Cookies" or
  result = "Form" or
  result = "Params" or
  result = "Path" or
  result = "PathInfo"
}

/** A data flow source of remote user input (ASP.NET query string). */
class AspNetQueryStringRemoteFlowSource extends AspNetRemoteFlowSource, DataFlow::ExprNode {
  AspNetQueryStringRemoteFlowSource() {
    exists(RefType t |
      t instanceof SystemWebHttpRequestClass or
      t instanceof SystemNetHttpListenerRequestClass or
      t instanceof SystemWebHttpRequestBaseClass
    |
      // A request object can be indexed, so taint the object as well
      this.getExpr().getType() = t
    )
    or
    this.getExpr() = any(AspNetQueryStringMember m).getAnAccess()
  }

  override string getSourceType() { result = "ASP.NET query string" }
}

/** A data flow source of remote user input (ASP.NET unvalidated request data). */
class AspNetUnvalidatedQueryStringRemoteFlowSource extends AspNetRemoteFlowSource,
  DataFlow::ExprNode {
  AspNetUnvalidatedQueryStringRemoteFlowSource() {
    this.getExpr() = any(SystemWebUnvalidatedRequestValues c).getAProperty().getGetter().getACall() or
    this.getExpr() =
      any(SystemWebUnvalidatedRequestValuesBase c).getAProperty().getGetter().getACall()
  }

  override string getSourceType() { result = "ASP.NET unvalidated request data" }
}

/** A data flow source of remote user input (ASP.NET user input). */
class AspNetUserInputRemoteFlowSource extends AspNetRemoteFlowSource, DataFlow::ExprNode {
  AspNetUserInputRemoteFlowSource() { getType() instanceof SystemWebUIWebControlsTextBoxClass }

  override string getSourceType() { result = "ASP.NET user input" }
}

/** A data flow source of remote user input (WCF based web service). */
class WcfRemoteFlowSource extends RemoteFlowSource, DataFlow::ParameterNode {
  WcfRemoteFlowSource() { exists(OperationMethod om | om.getAParameter() = this.getParameter()) }

  override string getSourceType() { result = "web service input" }
}

/** A data flow source of remote user input (ASP.NET web service). */
class AspNetServiceRemoteFlowSource extends RemoteFlowSource, DataFlow::ParameterNode {
  AspNetServiceRemoteFlowSource() {
    exists(Method m |
      m.getAParameter() = this.getParameter() and
      m.getAnAttribute().getType() instanceof SystemWebServicesWebMethodAttributeClass
    )
  }

  override string getSourceType() { result = "ASP.NET web service input" }
}

/** A data flow source of remote user input (ASP.NET request message). */
class SystemNetHttpRequestMessageRemoteFlowSource extends RemoteFlowSource, DataFlow::ExprNode {
  SystemNetHttpRequestMessageRemoteFlowSource() {
    getType() instanceof SystemWebHttpRequestMessageClass
  }

  override string getSourceType() { result = "ASP.NET request message" }
}

/**
 * A data flow source of remote user input (Microsoft Owin, a query, request,
 * or path string).
 */
class MicrosoftOwinStringFlowSource extends RemoteFlowSource, DataFlow::ExprNode {
  MicrosoftOwinStringFlowSource() {
    this.getExpr() = any(MicrosoftOwinString owinString).getValueProperty().getGetter().getACall()
  }

  override string getSourceType() { result = "Microsoft Owin request or query string" }
}

/** A data flow source of remote user input (`Microsoft Owin IOwinRequest`). */
class MicrosoftOwinRequestRemoteFlowSource extends RemoteFlowSource, DataFlow::ExprNode {
  MicrosoftOwinRequestRemoteFlowSource() {
    exists(Property p, MicrosoftOwinIOwinRequestClass owinRequest |
      this.getExpr() = p.getGetter().getACall()
    |
      p = owinRequest.getAcceptProperty() or
      p = owinRequest.getBodyProperty() or
      p = owinRequest.getCacheControlProperty() or
      p = owinRequest.getContentTypeProperty() or
      p = owinRequest.getContextProperty() or
      p = owinRequest.getCookiesProperty() or
      p = owinRequest.getHeadersProperty() or
      p = owinRequest.getHostProperty() or
      p = owinRequest.getMediaTypeProperty() or
      p = owinRequest.getMethodProperty() or
      p = owinRequest.getPathProperty() or
      p = owinRequest.getPathBaseProperty() or
      p = owinRequest.getQueryProperty() or
      p = owinRequest.getQueryStringProperty() or
      p = owinRequest.getRemoteIpAddressProperty() or
      p = owinRequest.getSchemeProperty() or
      p = owinRequest.getURIProperty()
    )
  }

  override string getSourceType() { result = "Microsoft Owin request" }
}

/** A parameter to an Mvc controller action method, viewed as a source of remote user input. */
class ActionMethodParameter extends RemoteFlowSource, DataFlow::ParameterNode {
  ActionMethodParameter() {
    exists(Parameter p |
      p = this.getParameter() and
      p.fromSource()
    |
      p = any(Controller c).getAnActionMethod().getAParameter() or
      p = any(ApiController c).getAnActionMethod().getAParameter()
    )
  }

  override string getSourceType() { result = "ASP.NET MVC action method parameter" }
}

/** A data flow source of remote user input (ASP.NET Core). */
abstract class AspNetCoreRemoteFlowSource extends RemoteFlowSource { }

/** A data flow source of remote user input (ASP.NET query collection). */
class AspNetCoreQueryRemoteFlowSource extends AspNetCoreRemoteFlowSource, DataFlow::ExprNode {
  AspNetCoreQueryRemoteFlowSource() {
    exists(ValueOrRefType t |
      t instanceof MicrosoftAspNetCoreHttpHttpRequest or
      t instanceof MicrosoftAspNetCoreHttpQueryCollection or
      t instanceof MicrosoftAspNetCoreHttpQueryString
    |
      this.getExpr().(Call).getTarget().getDeclaringType() = t or
      this.asExpr().(Access).getTarget().getDeclaringType() = t
    )
    or
    exists(Call c |
      c
          .getTarget()
          .getDeclaringType()
          .hasQualifiedName("Microsoft.AspNetCore.Http", "IQueryCollection") and
      c.getTarget().getName() = "TryGetValue" and
      this.asExpr() = c.getArgumentForName("value")
    )
  }

  override string getSourceType() { result = "ASP.NET Core query string" }
}

/** A parameter to a `Mvc` controller action method, viewed as a source of remote user input. */
class AspNetCoreActionMethodParameter extends RemoteFlowSource, DataFlow::ParameterNode {
  AspNetCoreActionMethodParameter() {
    exists(Parameter p |
      p = this.getParameter() and
      p.fromSource()
    |
      p = any(MicrosoftAspNetCoreMvcController c).getAnActionMethod().getAParameter()
    )
  }

  override string getSourceType() { result = "ASP.NET Core MVC action method parameter" }
}
