/** Provides predicates for recognizing clickjacking-related response-header configuration. */

import csharp
import semmle.code.csharp.dataflow.DataFlow
import semmle.code.csharp.frameworks.microsoft.AspNetCore
import semmle.code.csharp.frameworks.system.Web

/** Holds if `name` is the `X-Frame-Options` header name, ignoring case. */
bindingset[name]
predicate isXFrameOptionsText(string name) { name.toLowerCase() = "x-frame-options" }

/** Holds if `name` is the enforced `Content-Security-Policy` header name, ignoring case. */
bindingset[name]
predicate isContentSecurityPolicyText(string name) {
  name.toLowerCase() = "content-security-policy"
}

/**
 * Holds if `value` contains a `frame-ancestors` directive at the start of a CSP policy or
 * after a directive or policy separator.
 */
bindingset[value]
predicate containsFrameAncestorsDirective(string value) {
  value.regexpMatch("(?is)(^|.*[;,])\\s*frame-ancestors(\\s|;|$).*")
}

private predicate isXFrameOptionsHeaderNameExpr(Expr name) {
  isXFrameOptionsText(name.stripImplicit().getValue())
  or
  name.stripImplicit().(FieldAccess).getTarget() =
    any(MicrosoftNetHttpHeadersHeaderNames f).getXFrameOptionsField()
}

private predicate isContentSecurityPolicyHeaderNameExpr(Expr name) {
  isContentSecurityPolicyText(name.stripImplicit().getValue()) or
  name.stripImplicit().(FieldAccess).getTarget() =
    any(MicrosoftNetHttpHeadersHeaderNames f).getContentSecurityPolicyField()
}

private predicate containsFrameAncestorsDirectiveExpr(Expr value) {
  containsFrameAncestorsDirective(value.stripImplicit().getValue())
}

private predicate isDirectResponseHeadersAccess(Expr expr) {
  exists(PropertyAccess headers, MicrosoftAspNetCoreHttpHttpResponse response |
    expr.stripImplicit() = headers and headers.getProperty() = response.getHeadersProperty()
  )
}

private predicate isCallOnResponseHeadersAccess(Call call) {
  exists(Expr qualifier |
    call.(MethodCall).getQualifier() = qualifier or
    call.(ExtensionMethodCall).getArgument(0) = qualifier or
    call.(AccessorCall).getQualifier() = qualifier
  |
    exists(Expr directAccess |
      isDirectResponseHeadersAccess(directAccess) and
      DataFlow::localExprFlow(directAccess, qualifier.stripImplicit())
    )
  )
}

private predicate isClickjackingHeaderCall(MethodCall call) {
  (
    call.getTarget() = any(SystemWebHttpResponseClass r).getAppendHeaderMethod() or
    call.getTarget() = any(SystemWebHttpResponseClass r).getAddHeaderMethod()
  ) and
  (
    isXFrameOptionsHeaderNameExpr(call.getArgumentForName("name"))
    or
    isContentSecurityPolicyHeaderNameExpr(call.getArgumentForName("name")) and
    containsFrameAncestorsDirectiveExpr(call.getArgumentForName("value"))
  )
}

private predicate isClickjackingHeaderDictionaryLikeWrite(Call call) {
  (
    call.getTarget().hasUndecoratedName(["Append", "Add", "TryAdd"])
    or
    call.(IndexerCall).getTarget() instanceof Setter
  ) and
  (
    isXFrameOptionsHeaderNameExpr(call.getArgumentForName("key"))
    or
    isContentSecurityPolicyHeaderNameExpr(call.getArgumentForName("key")) and
    containsFrameAncestorsDirectiveExpr(call.getArgumentForName("value"))
  )
}

private predicate isClickjackingPropertyWrite(Call c) {
  c.getTarget() instanceof Setter and
  (
    c.(PropertyCall).getProperty() =
      any(MicrosoftAspNetCoreHttpIHeaderDictionary dic).getXFrameOptionsProperty()
    or
    c.(PropertyCall).getProperty() =
      any(MicrosoftAspNetCoreHttpIHeaderDictionary dic).getContentSecurityPolicyProperty() and
    containsFrameAncestorsDirectiveExpr(c.getArgumentForName("value"))
  )
}

/** Gets an expression that configures a clickjacking-related response header. */
Call getAClickjackingHeaderWrite() {
  isClickjackingHeaderCall(result)
  or
  isCallOnResponseHeadersAccess(result) and
  (
    isClickjackingHeaderDictionaryLikeWrite(result)
    or
    isClickjackingPropertyWrite(result)
  )
}
