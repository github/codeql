/**
 * Provides classes and predicates for detecting insecure cookies.
 */

import csharp
import semmle.code.csharp.frameworks.microsoft.AspNetCore

/**
 * Holds if the expression is a variable with a sensitive name.
 */
predicate isCookieWithSensitiveName(Expr cookieExpr) {
  exists(AuthCookieNameConfiguration dataflow, DataFlow::Node source, DataFlow::Node sink |
    dataflow.hasFlow(source, sink) and
    sink.asExpr() = cookieExpr
  )
}

/**
 * Tracks if a variable with a sensitive name is used as an argument.
 */
private class AuthCookieNameConfiguration extends DataFlow::Configuration {
  AuthCookieNameConfiguration() { this = "AuthCookieNameConfiguration" }

  private predicate isAuthVariable(Expr expr) {
    exists(string val |
      (
        val = expr.getValue() or
        val = expr.(Access).getTarget().getName()
      ) and
      val.regexpMatch("(?i).*(session|login|token|user|auth|credential).*") and
      not val.regexpMatch("(?i).*(xsrf|csrf|forgery).*")
    )
  }

  override predicate isSource(DataFlow::Node source) { isAuthVariable(source.asExpr()) }

  override predicate isSink(DataFlow::Node sink) {
    exists(Call c | sink.asExpr() = c.getAnArgument())
  }
}

/**
 * Tracks creation of `CookieOptions` to `IResponseCookies.Append(String, String, CookieOptions)` call as a third parameter.
 */
class CookieOptionsTrackingConfiguration extends DataFlow::Configuration {
  CookieOptionsTrackingConfiguration() { this = "CookieOptionsTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(ObjectCreation).getType() instanceof MicrosoftAspNetCoreHttpCookieOptions
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MicrosoftAspNetCoreHttpResponseCookies iResponse, MethodCall mc |
      iResponse.getAppendMethod() = mc.getTarget() and
      mc.getArgument(2) = sink.asExpr()
    )
  }
}

/**
 * Looks for property value of `CookiePolicyOptions` passed to `app.UseCookiePolicy` in `Startup.Configure`.
 */
Expr getAValueForCookiePolicyProp(string prop) {
  exists(Method m, MethodCall mc, ObjectCreation oc, Assignment a, Expr val |
    m.getName() = "Configure" and
    m.getDeclaringType().getName() = "Startup" and
    m.getBody().getAChild+() = mc and
    mc.getTarget() =
      any(MicrosoftAspNetCoreBuilderCookiePolicyAppBuilderExtensions e).getUseCookiePolicyMethod() and
    oc.getType() instanceof MicrosoftAspNetCoreBuilderCookiePolicyOptions and
    getAValueForProp(oc, a, prop) = val and
    result = val
  )
}

/**
 * A simplistic points-to alternative: given an object creation and a property name, get the values that property can be assigned.
 *
 * Assumptions:
 *    - we don't reassign the variable that the creation is stored in
 *    - we always access the creation through the same variable it is initially assigned to
 *
 * This should cover most typical patterns...
 */
Expr getAValueForProp(ObjectCreation create, Assignment a, string prop) {
  // values set in object init
  exists(MemberInitializer init, Expr src, PropertyAccess pa |
    a.getLValue() = pa and
    pa.getTarget().hasName(prop) and
    init = create.getInitializer().(ObjectInitializer).getAMemberInitializer() and
    init.getLValue() = pa and
    DataFlow::localExprFlow(src, init.getRValue()) and
    result = src
  )
  or
  // values set on var that create is assigned to
  exists(Expr src, PropertyAccess pa |
    a.getLValue() = pa and
    pa.getTarget().hasName(prop) and
    DataFlow::localExprFlow(create, pa.getQualifier()) and
    DataFlow::localExprFlow(src, a.getRValue()) and
    result = src
  )
}

/**
 * Checks if the given property was explicitly set to a value.
 */
predicate isPropertySet(ObjectCreation oc, string prop) { exists(getAValueForProp(oc, _, prop)) }

/**
 * Tracks if a callback used in `OnAppendCookie` sets `Secure` to `true`.
 */
class OnAppendCookieSecureTrackingConfig extends OnAppendCookieTrackingConfig {
  OnAppendCookieSecureTrackingConfig() { this = "OnAppendCookieSecureTrackingConfig" }

  override string propertyName() { result = "Secure" }
}

/**
 * Tracks if a callback used in `OnAppendCookie` sets `HttpOnly` to `true`.
 */
class OnAppendCookieHttpOnlyTrackingConfig extends OnAppendCookieTrackingConfig {
  OnAppendCookieHttpOnlyTrackingConfig() { this = "OnAppendCookieHttpOnlyTrackingConfig" }

  override string propertyName() { result = "HttpOnly" }
}

/**
 * Tracks if a callback used in `OnAppendCookie` sets a cookie property to `true`.
 */
abstract private class OnAppendCookieTrackingConfig extends DataFlow::Configuration {
  bindingset[this]
  OnAppendCookieTrackingConfig() { any() }

  /**
   * Specifies the cookie property name to track.
   */
  abstract string propertyName();

  override predicate isSource(DataFlow::Node source) {
    exists(PropertyWrite pw, Assignment delegateAssign, Callable c |
      pw.getProperty().getName() = "OnAppendCookie" and
      pw.getProperty().getDeclaringType() instanceof MicrosoftAspNetCoreBuilderCookiePolicyOptions and
      delegateAssign.getLValue() = pw and
      (
        exists(LambdaExpr lambda |
          delegateAssign.getRValue() = lambda and
          lambda = c
        )
        or
        exists(DelegateCreation delegate |
          delegateAssign.getRValue() = delegate and
          delegate.getArgument().(CallableAccess).getTarget() = c
        )
      ) and
      c.getParameter(0) = source.asParameter()
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(PropertyWrite pw, Assignment a |
      pw.getProperty().getDeclaringType() instanceof MicrosoftAspNetCoreHttpCookieOptions and
      pw.getProperty().getName() = propertyName() and
      a.getLValue() = pw and
      exists(Expr val |
        DataFlow::localExprFlow(val, a.getRValue()) and
        val.getValue() = "true"
      ) and
      sink.asExpr() = pw.getQualifier()
    )
  }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    node2.asExpr() =
      any(PropertyRead pr |
        pr.getQualifier() = node1.asExpr() and
        pr.getProperty().getDeclaringType() instanceof
          MicrosoftAspNetCoreCookiePolicyAppendCookieContext
      )
  }
}
