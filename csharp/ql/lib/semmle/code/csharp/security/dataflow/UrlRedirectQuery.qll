/**
 * Provides a taint-tracking configuration for reasoning about unvalidated URL redirect problems.
 */

import csharp
private import semmle.code.csharp.security.dataflow.flowsinks.FlowSinks
private import semmle.code.csharp.security.dataflow.flowsources.FlowSources
private import semmle.code.csharp.controlflow.Guards
private import semmle.code.csharp.frameworks.Format
private import semmle.code.csharp.frameworks.system.Web
private import semmle.code.csharp.frameworks.system.web.Mvc
private import semmle.code.csharp.security.Sanitizers
private import semmle.code.csharp.frameworks.microsoft.AspNetCore
private import semmle.code.csharp.dataflow.internal.ExternalFlow

/**
 * A data flow source for unvalidated URL redirect vulnerabilities.
 */
abstract class Source extends DataFlow::Node { }

/**
 * A data flow sink for unvalidated URL redirect vulnerabilities.
 */
abstract class Sink extends ApiSinkExprNode { }

/**
 * A sanitizer for unvalidated URL redirect vulnerabilities.
 */
abstract class Sanitizer extends DataFlow::ExprNode { }

/**
 * A taint-tracking configuration for reasoning about unvalidated URL redirect vulnerabilities.
 */
private module UrlRedirectConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * A taint-tracking module for reasoning about unvalidated URL redirect vulnerabilities.
 */
module UrlRedirect = TaintTracking::Global<UrlRedirectConfig>;

/**
 * DEPRECATED: Use `ThreatModelSource` instead.
 *
 * A source of remote user input.
 */
deprecated class RemoteSource extends DataFlow::Node instanceof RemoteFlowSource { }

/** A source supported by the current threat model. */
class ThreatModelSource extends Source instanceof ActiveThreatModelSource { }

/** URL Redirection sinks defined through Models as Data. */
private class ExternalUrlRedirectExprSink extends Sink {
  ExternalUrlRedirectExprSink() { sinkNode(this, "url-redirection") }
}

/**
 * A URL argument to a call to `HttpResponse.Redirect()` or `Controller.Redirect()`, that is a
 * sink for URL redirects.
 */
class RedirectSink extends Sink {
  RedirectSink() {
    exists(MethodCall mc |
      mc.getTarget() = any(SystemWebHttpResponseClass response).getRedirectMethod() or
      mc.getTarget() = any(SystemWebMvcControllerClass response).getARedirectMethod()
    |
      // Redirect uses the parameter name url
      this.getExpr() = mc.getArgumentForName("url")
      or
      // RedirectToAction
      this.getExpr() = mc.getArgumentForName("actionName")
      or
      // RedirectToRoute
      this.getExpr() = mc.getArgumentForName("routeName")
    )
  }
}

/**
 * A value argument to a call to `AddHeader` or `AppendHeader` that adds the `Location`.
 */
class LocationHeaderSink extends Sink {
  LocationHeaderSink() {
    exists(MethodCall call |
      call.getTarget() = any(SystemWebHttpResponseClass r).getAppendHeaderMethod() or
      call.getTarget() = any(SystemWebHttpResponseClass r).getAddHeaderMethod()
    |
      call.getArgumentForName("name").getValue() = "Location" and
      this.getExpr() = call.getArgumentForName("value")
    )
  }
}

/**
 * A path argument to a call to `HttpServerUtility.Transfer`.
 */
class HttpServerTransferSink extends Sink {
  HttpServerTransferSink() {
    exists(MethodCall call |
      call.getTarget() = any(SystemWebHttpServerUtility s).getTransferMethod()
    |
      this.getExpr() = call.getArgumentForName("path")
    )
  }
}

private predicate isLocalUrlSanitizerMethodCall(MethodCall guard, Expr e, AbstractValue v) {
  exists(Method m | m = guard.getTarget() |
    m.hasName("IsLocalUrl") and
    e = guard.getArgument(0)
    or
    m.hasName("IsUrlLocalToHost") and
    e = guard.getArgument(1)
  ) and
  v.(AbstractValues::BooleanValue).getValue() = true
}

private predicate isLocalUrlSanitizer(Guard g, Expr e, AbstractValue v) {
  isLocalUrlSanitizerMethodCall(g, e, v)
}

/**
 * A URL argument to a call to `UrlHelper.IsLocalUrl()` or `HttpRequestBase.IsUrlLocalToHost()` that
 * is a sanitizer for URL redirects.
 */
class LocalUrlSanitizer extends Sanitizer {
  LocalUrlSanitizer() { this = DataFlow::BarrierGuard<isLocalUrlSanitizer/3>::getABarrierNode() }
}

/**
 * An argument to a call to `List.Contains()` that is a sanitizer for URL redirects.
 */
private predicate isContainsUrlSanitizer(Guard guard, Expr e, AbstractValue v) {
  guard =
    any(MethodCall method |
      exists(Method m | m = method.getTarget() |
        m.hasName("Contains") and
        e = method.getArgument(0)
      ) and
      v.(AbstractValues::BooleanValue).getValue() = true
    )
}

/**
 * An URL argument to a call to `.Contains()` that is a sanitizer for URL redirects.
 *
 * This `Contains` method is usually called on a list, but the sanitizer matches any call to a method
 * called `Contains`, so other methods with the same name will also be considered sanitizers.
 */
class ContainsUrlSanitizer extends Sanitizer {
  ContainsUrlSanitizer() {
    this = DataFlow::BarrierGuard<isContainsUrlSanitizer/3>::getABarrierNode()
  }
}

/**
 * A check that the URL is relative, and therefore safe for URL redirects.
 */
private predicate isRelativeUrlSanitizer(Guard guard, Expr e, AbstractValue v) {
  guard =
    any(PropertyAccess access |
      access.getProperty().hasFullyQualifiedName("System", "Uri", "IsAbsoluteUri") and
      e = access.getQualifier() and
      v.(AbstractValues::BooleanValue).getValue() = false
    )
}

/**
 * A check that the URL is relative, and therefore safe for URL redirects.
 */
class RelativeUrlSanitizer extends Sanitizer {
  RelativeUrlSanitizer() {
    this = DataFlow::BarrierGuard<isRelativeUrlSanitizer/3>::getABarrierNode()
  }
}

/**
 * A comparison on the `Host` property of a url, that is a sanitizer for URL redirects.
 * E.g. `url.Host == "example.org"`
 */
private predicate isHostComparisonSanitizer(Guard guard, Expr e, AbstractValue v) {
  guard =
    any(EqualityOperation comparison |
      exists(PropertyAccess access | access = comparison.getAnOperand() |
        access.getProperty().hasFullyQualifiedName("System", "Uri", "Host") and
        e = access.getQualifier()
      ) and
      if comparison instanceof EQExpr
      then v.(AbstractValues::BooleanValue).getValue() = true
      else v.(AbstractValues::BooleanValue).getValue() = false
    )
}

/**
 * A comparison on the `Host` property of a url, that is a sanitizer for URL redirects.
 */
class HostComparisonSanitizer extends Sanitizer {
  HostComparisonSanitizer() {
    this = DataFlow::BarrierGuard<isHostComparisonSanitizer/3>::getABarrierNode()
  }
}

/**
 * A call to the getter of the RawUrl property, whose value is considered to be safe for URL
 * redirects.
 */
class RawUrlSanitizer extends Sanitizer {
  RawUrlSanitizer() {
    this.getExpr() = any(SystemWebHttpRequestClass r).getRawUrlProperty().getGetter().getACall()
  }
}

/**
 * A string concatenation expression, where the left hand side contains the character "?".
 *
 * This is considered as sanitizing the overall expression, because the attacker can then
 * only control the query string parameters, rather than the location itself. In the majority of
 * cases, this will only allow the attacker to redirect the user to a link they could have already
 * redirected them to.
 */
class ConcatenationSanitizer extends Sanitizer {
  ConcatenationSanitizer() {
    this.getType() instanceof StringType and
    this.getExpr().(AddExpr).getLeftOperand().getValue().matches("%?%")
  }
}

/**
 * A string interpolation expression, where the first part (before any inserts) of the
 * expression contains the character "?".
 *
 * This is considered a sanitizer by the same reasoning as `ConcatenationSanitizer`.
 */
private class InterpolationSanitizer extends Sanitizer {
  InterpolationSanitizer() {
    this.getExpr().(InterpolatedStringExpr).getText(0).getValue().matches("%?%")
  }
}

/**
 * A call to `string.Format`, where the format expression (before any inserts)
 * contains the character "?".
 *
 * This is considered a sanitizer by the same reasoning as `ConcatenationSanitizer`.
 */
private class StringFormatSanitizer extends Sanitizer {
  StringFormatSanitizer() {
    exists(FormatCall c, Expr e, int index, string format |
      c = this.getExpr() and e = c.getFormatExpr()
    |
      format = e.(StringLiteral).getValue() and
      exists(format.regexpFind("\\{[0-9]+\\}", 0, index)) and
      format.substring(0, index).matches("%?%")
    )
  }
}

/** A call to an URL encoder. */
class UrlEncodeSanitizer extends Sanitizer {
  UrlEncodeSanitizer() { this.getExpr() instanceof UrlSanitizedExpr }
}

private class SimpleTypeSanitizer extends Sanitizer, SimpleTypeSanitizedExpr { }

private class GuidSanitizer extends Sanitizer, GuidSanitizedExpr { }

/**
 * A URL argument to a call to `HttpResponse.Redirect()` or `Controller.Redirect()`, that is a
 * sink for URL redirects.
 */
class AspNetCoreRedirectSink extends Sink {
  AspNetCoreRedirectSink() {
    exists(MethodCall mc |
      mc.getTarget() = any(MicrosoftAspNetCoreHttpHttpResponse response).getRedirectMethod() or
      mc.getTarget() = any(MicrosoftAspNetCoreMvcController response).getARedirectMethod()
    |
      // Response.Redirect uses 'location' parameter
      this.getExpr() = mc.getArgumentForName("location")
      or
      // Redirect uses the parameter name 'url'
      this.getExpr() = mc.getArgumentForName("url")
      or
      // Controller.RedirectToAction*
      this.getExpr() = mc.getArgumentForName("actionName")
      or
      // Controller.RedirectToRoute*
      this.getExpr() = mc.getArgumentForName("routeName")
      or
      // Controller.RedirectToPage*
      this.getExpr() = mc.getArgumentForName("pageName")
    )
  }
}

/**
 * Anything that is setting "location" header in the response headers.
 */
class AspNetCoreLocationHeaderSink extends Sink {
  AspNetCoreLocationHeaderSink() {
    // ResponseHeaders.Location = <user-provided value>
    exists(AssignableDefinition def |
      def.getTarget() = any(MicrosoftAspNetCoreHttpResponseHeaders headers).getLocationProperty()
    |
      this.asExpr() = def.getSource()
    )
    or
    // HttpResponse.Headers.Append("location", <user-provided value>)
    exists(MethodCall mc, MicrosoftAspNetCoreHttpHeaderDictionaryExtensions ext |
      mc.getTarget() = ext.getAppendMethod() or
      mc.getTarget() = ext.getAppendCommaSeparatedValuesMethod() or
      mc.getTarget() = ext.getSetCommaSeparatedValuesMethod()
    |
      mc.getArgumentForName("key").getValue().toLowerCase() = "location" and
      this.getExpr() = mc.getArgument(2)
    )
    or
    // HttpResponse.Headers.Add("location", <user-provided value>)
    exists(
      RefType cl, MicrosoftAspNetCoreHttpHttpResponse resp, PropertyAccess qualifier, MethodCall add
    |
      qualifier.getTarget() = resp.getHeadersProperty() and
      add.getTarget() = cl.getAMethod("Add") and
      qualifier = add.getQualifier() and
      add.getArgument(0).getValue().toLowerCase() = "location" and
      this.getExpr() = add.getArgument(1)
    )
    or
    // HttpResponse.Headers["location"] = <user-provided value>
    exists(
      RefType cl, MicrosoftAspNetCoreHttpHttpResponse resp, IndexerAccess ci, Call cs,
      PropertyAccess qualifier
    |
      qualifier.getTarget() = resp.getHeadersProperty() and
      ci.getTarget() = cl.getAnIndexer() and
      qualifier = ci.getQualifier() and
      cs.getTarget() = cl.getAnIndexer().getSetter() and
      cs.getArgument(0).getValue().toLowerCase() = "location" and
      this.asExpr() = cs.getArgument(1)
    )
  }
}
