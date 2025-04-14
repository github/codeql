deprecated module;

private import java
private import semmle.code.java.dataflow.FlowSources

/**
 * A concatenate expression using the string `redirect:` or `ajaxredirect:` or `forward:` on the left.
 *
 * E.g: `"redirect:" + redirectUrl`
 */
class RedirectBuilderExpr extends AddExpr {
  RedirectBuilderExpr() {
    this.getLeftOperand().(CompileTimeConstantExpr).getStringValue() in [
        "redirect:", "ajaxredirect:", "forward:"
      ]
  }
}

/**
 * A call to `StringBuilder.append` or `StringBuffer.append` method, and the parameter value is
 * `"redirect:"` or `"ajaxredirect:"` or `"forward:"`.
 *
 * E.g: `StringBuilder.append("redirect:")`
 */
class RedirectAppendCall extends MethodCall {
  RedirectAppendCall() {
    this.getMethod().hasName("append") and
    this.getMethod().getDeclaringType() instanceof StringBuildingType and
    this.getArgument(0).(CompileTimeConstantExpr).getStringValue() in [
        "redirect:", "ajaxredirect:", "forward:"
      ]
  }
}

/** A URL redirection sink from spring controller method. */
abstract class SpringUrlRedirectSink extends DataFlow::Node { }

/**
 * A sink for URL Redirection via the Spring View classes.
 */
private class SpringViewUrlRedirectSink extends SpringUrlRedirectSink {
  SpringViewUrlRedirectSink() {
    // Hardcoded redirect such as "redirect:login"
    this.asExpr()
        .(CompileTimeConstantExpr)
        .getStringValue()
        .indexOf(["redirect:", "ajaxredirect:", "forward:"]) = 0 and
    any(SpringRequestMappingMethod sqmm).polyCalls*(this.getEnclosingCallable())
    or
    exists(RedirectBuilderExpr rbe |
      rbe.getRightOperand() = this.asExpr() and
      any(SpringRequestMappingMethod sqmm).polyCalls*(this.getEnclosingCallable())
    )
    or
    exists(MethodCall ma, RedirectAppendCall rac |
      DataFlow::localExprFlow(rac.getQualifier(), ma.getQualifier()) and
      ma.getMethod().hasName("append") and
      ma.getArgument(0) = this.asExpr() and
      any(SpringRequestMappingMethod sqmm).polyCalls*(this.getEnclosingCallable())
    )
    or
    exists(MethodCall ma |
      ma.getMethod().hasName("setUrl") and
      ma.getMethod()
          .getDeclaringType()
          .hasQualifiedName("org.springframework.web.servlet.view", "AbstractUrlBasedView") and
      ma.getArgument(0) = this.asExpr()
    )
    or
    exists(ClassInstanceExpr cie |
      cie.getConstructedType()
          .hasQualifiedName("org.springframework.web.servlet.view", "RedirectView") and
      cie.getArgument(0) = this.asExpr()
    )
    or
    exists(ClassInstanceExpr cie |
      cie.getConstructedType().hasQualifiedName("org.springframework.web.servlet", "ModelAndView") and
      exists(RedirectBuilderExpr rbe |
        rbe = cie.getArgument(0) and rbe.getRightOperand() = this.asExpr()
      )
    )
  }
}

/**
 * A sink for URL Redirection via the `ResponseEntity` class.
 */
private class SpringResponseEntityUrlRedirectSink extends SpringUrlRedirectSink {
  SpringResponseEntityUrlRedirectSink() {
    // Find `new ResponseEntity(httpHeaders, ...)` or
    // `new ResponseEntity(..., httpHeaders, ...)` sinks
    exists(ClassInstanceExpr cie, Argument argument |
      cie.getConstructedType() instanceof SpringResponseEntity and
      argument.getType() instanceof SpringHttpHeaders and
      argument = cie.getArgument([0, 1]) and
      this.asExpr() = argument
    )
    or
    // Find `ResponseEntity.status(...).headers(taintHeaders).build()` or
    // `ResponseEntity.status(...).location(URI.create(taintURL)).build()` sinks
    exists(MethodCall ma |
      ma.getMethod()
          .getDeclaringType()
          .hasQualifiedName("org.springframework.http", "ResponseEntity$HeadersBuilder<BodyBuilder>") and
      ma.getMethod().getName() in ["headers", "location"] and
      this.asExpr() = ma.getArgument(0)
    )
  }
}

private class HttpHeadersMethodCall extends MethodCall {
  HttpHeadersMethodCall() { this.getMethod().getDeclaringType() instanceof SpringHttpHeaders }
}

private class HttpHeadersAddSetMethodCall extends HttpHeadersMethodCall {
  HttpHeadersAddSetMethodCall() { this.getMethod().getName() in ["add", "set"] }
}

private class HttpHeadersSetLocationMethodCall extends HttpHeadersMethodCall {
  HttpHeadersSetLocationMethodCall() { this.getMethod().hasName("setLocation") }
}

/**
 * Holds if `fromNode` to `toNode` is a dataflow step from a tainted argument to
 * a `HttpHeaders` instance qualifier, i.e. `httpHeaders.setLocation(tainted)`.
 */
predicate springUrlRedirectTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(HttpHeadersSetLocationMethodCall ma |
    fromNode.asExpr() = ma.getArgument(0) and
    toNode.asExpr() = ma.getQualifier()
  )
}

/**
 * A sanitizer to exclude the cases where the `HttpHeaders.add` or `HttpHeaders.set`
 * methods are called with a HTTP header other than "Location".
 * E.g: `httpHeaders.add("X-Some-Header", taintedUrlString)`
 */
predicate nonLocationHeaderSanitizer(DataFlow::Node node) {
  exists(HttpHeadersAddSetMethodCall ma, Argument firstArg | node.asExpr() = ma.getArgument(1) |
    firstArg = ma.getArgument(0) and
    not firstArg.(CompileTimeConstantExpr).getStringValue() = "Location"
  )
}
