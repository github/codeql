/** Provides classes to reason about server-side request forgery (SSRF) attacks. */

import java
import semmle.code.java.frameworks.Networking
import semmle.code.java.frameworks.ApacheHttp
import semmle.code.java.frameworks.spring.Spring
import semmle.code.java.frameworks.JaxWS
import semmle.code.java.frameworks.javase.Http
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.StringFormat

/**
 * A unit class for adding additional taint steps that are specific to Server-side
 * Request Forgery (SSRF) attacks.
 *
 * Extend this class to add additional taint steps to the SSRF query.
 */
class RequestForgeryAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `pred` to `succ` should be considered a taint
   * step for Server-side Request Forgery.
   */
  abstract predicate propagatesTaint(DataFlow::Node pred, DataFlow::Node succ);
}

private class DefaultRequestForgeryAdditionalTaintStep extends RequestForgeryAdditionalTaintStep {
  override predicate propagatesTaint(DataFlow::Node pred, DataFlow::Node succ) {
    // propagate to a URI when its host is assigned to
    exists(UriCreation c | c.getHostArg() = pred.asExpr() | succ.asExpr() = c)
    or
    // propagate to a URL when its host is assigned to
    exists(UrlConstructorCall c | c.getHostArg() = pred.asExpr() | succ.asExpr() = c)
    or
    // propagate to a RequestEntity when its url is assigned to
    exists(MethodAccess m |
      m.getMethod().getDeclaringType() instanceof SpringRequestEntity and
      (
        m.getMethod().hasName(["get", "post", "head", "delete", "options", "patch", "put"]) and
        m.getArgument(0) = pred.asExpr() and
        m = succ.asExpr()
        or
        m.getMethod().hasName("method") and
        m.getArgument(1) = pred.asExpr() and
        m = succ.asExpr()
      )
    )
    or
    // propagate from a `RequestEntity<>$BodyBuilder` to a `RequestEntity`
    // when the builder is tainted
    exists(MethodAccess m, RefType t |
      m.getMethod().getDeclaringType() = t and
      t.hasQualifiedName("org.springframework.http", "RequestEntity<>$BodyBuilder") and
      m.getMethod().hasName("body") and
      m.getQualifier() = pred.asExpr() and
      m = succ.asExpr()
    )
  }
}

/** A data flow sink for server-side request forgery (SSRF) vulnerabilities. */
abstract class RequestForgerySink extends DataFlow::Node { }

/**
 * An argument to a url `openConnection` or `openStream` call
 *  taken as a sink for request forgery vulnerabilities.
 */
private class UrlOpen extends RequestForgerySink {
  UrlOpen() {
    exists(MethodAccess ma |
      ma.getMethod() instanceof UrlOpenConnectionMethod or
      ma.getMethod() instanceof UrlOpenStreamMethod
    |
      this.asExpr() = ma.getQualifier()
    )
  }
}

/**
 * An argument to an Apache `setURI` call taken as a
 *   sink for request forgery vulnerabilities.
 */
private class ApacheSetUri extends RequestForgerySink {
  ApacheSetUri() {
    exists(MethodAccess ma |
      ma.getReceiverType() instanceof ApacheHttpRequest and
      ma.getMethod().hasName("setURI")
    |
      this.asExpr() = ma.getArgument(0)
    )
  }
}

/**
 * An argument to any Apache `HttpRequest` instantiation taken as a
 *   sink for request forgery vulnerabilities.
 */
private class ApacheHttpRequestInstantiation extends RequestForgerySink {
  ApacheHttpRequestInstantiation() {
    exists(ClassInstanceExpr c | c.getConstructedType() instanceof ApacheHttpRequest |
      this.asExpr() = c.getArgument(0)
    )
  }
}

/**
 * An argument to an Apache `RequestBuilder` method call taken as a
 *   sink for request forgery vulnerabilities.
 */
private class ApacheHttpRequestBuilderArgument extends RequestForgerySink {
  ApacheHttpRequestBuilderArgument() {
    exists(MethodAccess ma |
      ma.getReceiverType() instanceof TypeApacheHttpRequestBuilder and
      ma.getMethod().hasName(["setURI", "get", "post", "put", "optons", "head", "delete"])
    |
      this.asExpr() = ma.getArgument(0)
    )
  }
}

/**
 * An argument to any `java.net.http.HttpRequest` Instantiation taken as a
 *   sink for request forgery vulnerabilities.
 */
private class HttpRequestNewBuilder extends RequestForgerySink {
  HttpRequestNewBuilder() {
    exists(MethodAccess call |
      call.getCallee().hasName("newBuilder") and
      call.getMethod().getDeclaringType().hasQualifiedName("java.net.http", "HttpRequest")
    |
      this.asExpr() = call.getArgument(0)
    )
  }
}

/**
 * An argument to an `HttpBuilder` `uri` call taken as a
 *   sink for request forgery vulnerabilities.
 */
private class HttpBuilderUriArgument extends RequestForgerySink {
  HttpBuilderUriArgument() {
    exists(MethodAccess ma | ma.getMethod() instanceof HttpBuilderUri |
      this.asExpr() = ma.getArgument(0)
    )
  }
}

/**
 * An argument to a Spring `RestTemplate` method call taken as a
 *   sink for request forgery vulnerabilities.
 */
private class SpringRestTemplateArgument extends RequestForgerySink {
  SpringRestTemplateArgument() {
    exists(MethodAccess ma |
      this.asExpr() = ma.getMethod().(SpringRestTemplateUrlMethod).getUrlArgument(ma)
    )
  }
}

/**
 * An argument to a `javax.ws.rs.Client` `target` method call taken as a
 *   sink for request forgery vulnerabilities.
 */
private class JaxRsClientTarget extends RequestForgerySink {
  JaxRsClientTarget() {
    exists(MethodAccess ma |
      ma.getMethod().getDeclaringType() instanceof JaxRsClient and
      ma.getMethod().hasName("target")
    |
      this.asExpr() = ma.getArgument(0)
    )
  }
}

/**
 * An argument to an `org.springframework.http.RequestEntity` constructor call
 *   which is an URI taken as a sink for request forgery vulnerabilities.
 */
private class RequestEntityUriArg extends RequestForgerySink {
  RequestEntityUriArg() {
    exists(ClassInstanceExpr e, Argument a |
      e.getConstructedType() instanceof SpringRequestEntity and
      e.getAnArgument() = a and
      a.getType() instanceof TypeUri and
      this.asExpr() = a
    )
  }
}

/**
 * A Spring Rest Template method
 * which take a URL as an argument.
 */
private class SpringRestTemplateUrlMethod extends Method {
  SpringRestTemplateUrlMethod() {
    this.getDeclaringType() instanceof SpringRestTemplate and
    this.hasName([
        "doExecute", "postForEntity", "postForLocation", "postForObject", "put", "exchange",
        "execute", "getForEntity", "getForObject", "patchForObject"
      ])
  }

  /**
   * Gets the argument which corresponds to a URL argument
   * passed as a `java.net.URL` object or as a string or the like
   */
  Argument getUrlArgument(MethodAccess ma) {
    // doExecute(URI url, HttpMethod method, RequestCallback requestCallback,
    //  ResponseExtractor<T> responseExtractor)
    result = ma.getArgument(0)
  }
}

/** A sanitizer for request forgery vulnerabilities. */
abstract class RequestForgerySanitizer extends DataFlow::Node { }

private class PrimitiveSanitizer extends RequestForgerySanitizer {
  PrimitiveSanitizer() { this.getType() instanceof PrimitiveType }
}

private class HostnameSanitizingPrefix extends CompileTimeConstantExpr {
  int offset;

  HostnameSanitizingPrefix() {
    // Matches strings that look like when prepended to untrusted input, they will restrict
    // the host or entity addressed: for example, anything containing `?` or `#`, or a slash that
    // doesn't appear to be a protocol specifier (e.g. `http://` is not sanitizing), or specifically
    // the string "/".
    exists(
      this.getStringValue()
          .regexpFind(".*([?#]|[^?#:/\\\\][/\\\\]).*|[/\\\\][^/\\\\].*|^/$", 0, offset)
    )
  }

  /**
   * Gets the offset in this constant string where a sanitizing substring begins.
   */
  int getOffset() { result = offset }
}

private AddExpr getParentAdd(AddExpr e) { result = e.getParent() }

private AddExpr getAnAddContainingHostnameSanitizingPrefix() {
  result = getParentAdd*(any(HostnameSanitizingPrefix p).getParent())
}

private Expr getASanitizedAddOperand() {
  exists(AddExpr e |
    e = getAnAddContainingHostnameSanitizingPrefix() and
    (
      e.getLeftOperand() = getAnAddContainingHostnameSanitizingPrefix() or
      e.getLeftOperand() instanceof HostnameSanitizingPrefix
    ) and
    result = e.getRightOperand()
  )
}

private MethodAccess getNextAppend(MethodAccess append) {
  result = any(StringBuilderVar sbv).getNextAppend(append)
}

private Expr getQualifier(MethodAccess e) { result = e.getQualifier() }

private MethodAccess getAChainedAppend(Expr e) {
  (
    result.getQualifier() = e
    or
    result.getQualifier() = getAChainedAppend(e)
  ) and
  result.getCallee().getDeclaringType() instanceof StringBuildingType and
  result.getCallee().getName() = "append"
}

/**
 * An expression that is sanitized because it is concatenated onto a string that looks like
 * a hostname or a URL separator, preventing the appended string from arbitrarily controlling
 * the addressed server.
 */
private class HostnameSanitizedExpr extends Expr {
  HostnameSanitizedExpr() {
    // Sanitize expressions that come after a sanitizing prefix in a tree of string additions:
    this = getASanitizedAddOperand()
    or
    // Sanitize all appends to a StringBuilder that is initialized with a sanitizing prefix:
    // (note imprecision: if the same StringBuilder/StringBuffer has more than one constructor call,
    //  this sanitizes all of its append calls, not just those that may follow the constructor).
    exists(StringBuilderVar sbv, ConstructorCall constructor, Expr initializer |
      initializer = sbv.getAnAssignedValue() and
      constructor = getQualifier*(initializer) and
      constructor.getArgument(0) instanceof HostnameSanitizingPrefix and
      (
        this = sbv.getAnAppend().getArgument(0)
        or
        this = getAChainedAppend(constructor).getArgument(0)
      )
    )
    or
    // Sanitize expressions that come after a sanitizing prefix in a sequence of StringBuilder operations:
    exists(MethodAccess appendSanitizingConstant, MethodAccess subsequentAppend |
      appendSanitizingConstant.getArgument(0) instanceof HostnameSanitizingPrefix and
      getNextAppend*(appendSanitizingConstant) = subsequentAppend and
      this = subsequentAppend.getArgument(0)
    )
    or
    // Sanitize expressions that come after a sanitizing prefix in the args to a format call:
    exists(
      FormattingCall formatCall, FormatString formatString, HostnameSanitizingPrefix prefix,
      int sanitizedFromOffset, int laterOffset, int sanitizedArg
    |
      formatString = unique(FormatString fs | fs = formatCall.getAFormatString()) and
      (
        // A sanitizing argument comes before this:
        exists(int argIdx |
          formatCall.getArgumentToBeFormatted(argIdx) = prefix and
          sanitizedFromOffset = formatString.getAnArgUsageOffset(argIdx)
        )
        or
        // The format string itself sanitizes subsequent arguments:
        formatString = prefix.getStringValue() and
        sanitizedFromOffset = prefix.getOffset()
      ) and
      laterOffset > sanitizedFromOffset and
      laterOffset = formatString.getAnArgUsageOffset(sanitizedArg) and
      this = formatCall.getArgumentToBeFormatted(sanitizedArg)
    )
  }
}

/**
 * A value that is the result of prepending a string that prevents any value from controlling the
 * host of a URL.
 */
private class HostnameSantizer extends RequestForgerySanitizer {
  HostnameSantizer() { this.asExpr() instanceof HostnameSanitizedExpr }
}
