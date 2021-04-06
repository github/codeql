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
 * Holds if taint is propagated from `pred` to `succ`.
 */
predicate requestForgeryStep(DataFlow::Node pred, DataFlow::Node succ) {
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

/** A data flow sink for request forgery vulnerabilities. */
abstract class RequestForgerySink extends DataFlow::Node { }

/**
 * An argument to an url `openConnection` or `openStream` call
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
 * An argument to any Apache Request Instantiation call taken as a
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
 * An argument to a Apache RequestBuilder method call taken as a
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
 * An argument to any Java.net.http.request Instantiation call taken as a
 *   sink for request forgery vulnerabilities.
 */
private class HttpRequestNewBuilder extends RequestForgerySink {
  HttpRequestNewBuilder() {
    exists(MethodAccess call |
      call.getCallee().hasName("newBuilder") and
      call.getMethod().getDeclaringType().getName() = "HttpRequest"
    |
      this.asExpr() = call.getArgument(0)
    )
  }
}

/**
 * An argument to an Http Builder `uri` call taken as a
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
 * An argument to a Spring Rest Template method call taken as a
 *   sink for request forgery vulnerabilities.
 */
private class SpringRestTemplateArgument extends RequestForgerySink {
  SpringRestTemplateArgument() {
    exists(MethodAccess ma |
      this.asExpr() = ma.getMethod().(SpringRestTemplateUrlMethods).getUrlArgument(ma)
    )
  }
}

/**
 * An argument to `javax.ws.rs.Client`s `target` method call taken as a
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
 * An argument to `org.springframework.http.RequestEntity`s constructor call
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
 * A class representing all Spring Rest Template methods
 * which take an URL as an argument.
 */
private class SpringRestTemplateUrlMethods extends Method {
  SpringRestTemplateUrlMethods() {
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

private class HostnameSanitizingPrefix extends CompileTimeConstantExpr {
  int offset;

  HostnameSanitizingPrefix() {
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
class HostnameSanitizedExpr extends Expr {
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
        // An argument that sanitizes will be come before this:
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
class HostnameSantizer extends RequestForgerySanitizer {
  HostnameSantizer() { this.asExpr() instanceof HostnameSanitizedExpr }
}
