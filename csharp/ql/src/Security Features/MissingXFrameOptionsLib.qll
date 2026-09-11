/** Provides predicates for recognizing clickjacking-related response-header configuration. */

import csharp
import semmle.code.csharp.dataflow.DataFlow
import semmle.code.csharp.frameworks.microsoft.AspNetCore
import semmle.code.csharp.frameworks.system.Web

/** Holds if `name` is the `X-Frame-Options` header name, ignoring case. */
bindingset[name]
predicate isXFrameOptionsHeaderName(string name) { name.toLowerCase() = "x-frame-options" }

/** Holds if `name` is the enforced `Content-Security-Policy` header name, ignoring case. */
bindingset[name]
predicate isContentSecurityPolicyHeaderName(string name) {
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

private predicate isHeaderNamesField(Expr name, string fieldName) {
  exists(FieldAccess access |
    name.stripImplicit() = access and
    access.getTarget().hasFullyQualifiedName("Microsoft.Net.Http.Headers", "HeaderNames", fieldName)
  )
}

private predicate isXFrameOptionsHeaderNameExpr(Expr name) {
  isXFrameOptionsHeaderName(name.stripImplicit().getValue())
  or
  isHeaderNamesField(name, "XFrameOptions")
}

private predicate isContentSecurityPolicyHeaderNameExpr(Expr name) {
  isContentSecurityPolicyHeaderName(name.stripImplicit().getValue())
  or
  isHeaderNamesField(name, "ContentSecurityPolicy")
}

private predicate containsFrameAncestorsDirectiveExpr(Expr value) {
  containsFrameAncestorsDirective(value.stripImplicit().getValue())
}

private predicate isClickjackingHeader(Expr name, Expr value) {
  isXFrameOptionsHeaderNameExpr(name)
  or
  isContentSecurityPolicyHeaderNameExpr(name) and containsFrameAncestorsDirectiveExpr(value)
}

private predicate isDirectResponseHeadersAccess(Expr expr) {
  exists(PropertyAccessExpr headers, MicrosoftAspNetCoreHttpHttpResponse response |
    expr.stripImplicit() = headers and headers.getProperty() = response.getHeadersProperty()
  )
}

private predicate isResponseHeadersAccess(Expr expr) {
  exists(Expr directAccess |
    isDirectResponseHeadersAccess(directAccess) and
    DataFlow::localExprFlow(directAccess, expr.stripImplicit())
  )
}

private Expr getHeaderDictionaryReceiver(MethodCall call) {
  result = call.getQualifier()
  or
  call.getTarget().isExtensionMethod() and
  result = call.getArgumentForParameter(call.getTarget().getParameter(0))
}

private predicate isClickjackingHeaderCall(MethodCall call) {
  (
    call.getTarget() = any(SystemWebHttpResponseClass r).getAppendHeaderMethod() or
    call.getTarget() = any(SystemWebHttpResponseClass r).getAddHeaderMethod()
  ) and
  isClickjackingHeader(call.getArgumentForName("name"), call.getArgumentForName("value"))
  or
  call.getTarget().hasUndecoratedName(["Append", "Add", "TryAdd"]) and
  isResponseHeadersAccess(getHeaderDictionaryReceiver(call)) and
  isClickjackingHeader(call.getArgumentForName("key"), call.getArgumentForName("value"))
}

private predicate isClickjackingHeaderIndexerAssignment(AssignExpr assignment) {
  exists(IndexerCall indexer |
    assignment.getLeftOperand() = indexer and
    isResponseHeadersAccess(indexer.getQualifier()) and
    isClickjackingHeader(indexer.getArgument(0), assignment.getRightOperand())
  )
}

private predicate isClickjackingNamedHeaderPropertyAssignment(AssignExpr assignment) {
  exists(PropertyAccessExpr header |
    assignment.getLeftOperand() = header and
    isResponseHeadersAccess(header.(QualifiableExpr).getQualifier()) and
    (
      header.getProperty().hasName("XFrameOptions")
      or
      header.getProperty().hasName("ContentSecurityPolicy") and
      containsFrameAncestorsDirectiveExpr(assignment.getRightOperand())
    )
  )
}

/** Gets an expression that configures a clickjacking-related response header. */
Expr getAClickjackingHeaderWrite() {
  result = any(MethodCall call | isClickjackingHeaderCall(call))
  or
  result =
    any(AssignExpr assignment |
      isClickjackingHeaderIndexerAssignment(assignment) or
      isClickjackingNamedHeaderPropertyAssignment(assignment)
    )
}
