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
private import semmle.code.csharp.dataflow.internal.ExternalFlow
private import semmle.code.csharp.security.dataflow.flowsources.FlowSources

/** A data flow source of remote user input. */
abstract class RemoteFlowSource extends SourceNode {
  override string getSourceType() { result = "remote flow source" }

  override string getThreatModel() { result = "remote" }
}

/**
 * A module for importing frameworks that defines remote flow sources.
 */
private module RemoteFlowSources {
  private import semmle.code.csharp.frameworks.ServiceStack
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
  result =
    ["QueryString", "Headers", "RawUrl", "Url", "Cookies", "Form", "Params", "Path", "PathInfo"]
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
  DataFlow::ExprNode
{
  AspNetUnvalidatedQueryStringRemoteFlowSource() {
    this.getExpr() = any(SystemWebUnvalidatedRequestValues c).getAProperty().getGetter().getACall() or
    this.getExpr() =
      any(SystemWebUnvalidatedRequestValuesBase c).getAProperty().getGetter().getACall()
  }

  override string getSourceType() { result = "ASP.NET unvalidated request data" }
}

/** A data flow source of remote user input (ASP.NET user input). */
class AspNetUserInputRemoteFlowSource extends AspNetRemoteFlowSource, DataFlow::ExprNode {
  AspNetUserInputRemoteFlowSource() { this.getType() instanceof SystemWebUIWebControlsTextBoxClass }

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
    this.getType() instanceof SystemWebHttpRequestMessageClass
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
      p = owinRequest.getUriProperty()
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

private predicate reachesMapGetArg(DataFlow::Node n) {
  exists(MethodCall mc |
    mc.getTarget() = any(MicrosoftAspNetCoreBuilderEndpointRouteBuilderExtensions c).getAMapMethod() and
    n.asExpr() = mc.getArgument(2)
  )
  or
  exists(DataFlow::Node mid | reachesMapGetArg(mid) |
    DataFlow::localFlowStep(n, mid) or
    n.asExpr() = mid.asExpr().(DelegateCreation).getArgument()
  )
}

/** A parameter to a routing method delegate. */
class AspNetCoreRoutingMethodParameter extends AspNetCoreRemoteFlowSource, DataFlow::ParameterNode {
  AspNetCoreRoutingMethodParameter() {
    exists(DataFlow::Node n, Callable c |
      reachesMapGetArg(n) and
      c.getAParameter() = this.asParameter() and
      c.isSourceDeclaration()
    |
      n.asExpr() = c
      or
      n.asExpr().(CallableAccess).getTarget().getUnboundDeclaration() = c
    )
  }

  override string getSourceType() { result = "ASP.NET Core routing endpoint." }
}

/**
 * Data flow for ASP.NET Core.
 *
 * Flow is defined from any ASP.NET Core remote source object to any of its member
 * properties.
 */
private class AspNetCoreRemoteFlowSourceMember extends TaintTracking::TaintedMember, Property {
  AspNetCoreRemoteFlowSourceMember() {
    this.getDeclaringType() = any(AspNetCoreRemoteFlowSource source).getType() and
    this.isPublic() and
    not this.isStatic() and
    this.isAutoImplemented() and
    this.getGetter().isPublic() and
    this.getSetter().isPublic()
  }
}

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
      c.getTarget()
          .getDeclaringType()
          .hasFullyQualifiedName("Microsoft.AspNetCore.Http", "IQueryCollection") and
      c.getTarget().getName() = "TryGetValue" and
      this.asExpr() = c.getArgumentForName("value")
    )
  }

  override string getSourceType() { result = "ASP.NET Core query string" }
}

/** A parameter to a `Mvc` controller action method, viewed as a source of remote user input. */
class AspNetCoreActionMethodParameter extends AspNetCoreRemoteFlowSource, DataFlow::ParameterNode {
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

private class ExternalRemoteFlowSource extends RemoteFlowSource {
  ExternalRemoteFlowSource() { sourceNode(this, "remote") }

  override string getSourceType() { result = "external" }
}
