/**
 * Provides classes and predicates for detecting insecure cookies.
 */
deprecated module;

import csharp
import semmle.code.csharp.frameworks.microsoft.AspNetCore

/**
 * Holds if the expression is a variable with a sensitive name.
 */
predicate isCookieWithSensitiveName(Expr cookieExpr) {
  exists(DataFlow::Node sink |
    AuthCookieName::flowTo(sink) and
    sink.asExpr() = cookieExpr
  )
}

/**
 * Configuration for tracking if a variable with a sensitive name is used as an argument.
 */
private module AuthCookieNameConfig implements DataFlow::ConfigSig {
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

  predicate isSource(DataFlow::Node source) { isAuthVariable(source.asExpr()) }

  predicate isSink(DataFlow::Node sink) { exists(Call c | sink.asExpr() = c.getAnArgument()) }
}

/**
 * Tracks if a variable with a sensitive name is used as an argument.
 */
private module AuthCookieName = DataFlow::Global<AuthCookieNameConfig>;

/**
 * Configuration module tracking creation of `CookieOptions` to `IResponseCookies.Append(String, String, CookieOptions)`
 * calls as a third parameter.
 */
private module CookieOptionsTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().(ObjectCreation).getType() instanceof MicrosoftAspNetCoreHttpCookieOptions
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MicrosoftAspNetCoreHttpResponseCookies iResponse, MethodCall mc |
      iResponse.getAppendMethod() = mc.getTarget() and
      mc.getArgument(2) = sink.asExpr()
    )
  }
}

/**
 * Tracking creation of `CookieOptions` to `IResponseCookies.Append(String, String, CookieOptions)`
 * calls as a third parameter.
 */
module CookieOptionsTracking = DataFlow::Global<CookieOptionsTrackingConfig>;

/**
 * Looks for property value of `CookiePolicyOptions` passed to `app.UseCookiePolicy` in `Startup.Configure`.
 */
Expr getAValueForCookiePolicyProp(string prop) {
  exists(Method m, MethodCall mc, ObjectCreation oc, Expr val |
    m.getName() = "Configure" and
    m.getDeclaringType().getName() = "Startup" and
    m.getBody().getAChild+() = mc and
    mc.getTarget() =
      any(MicrosoftAspNetCoreBuilderCookiePolicyAppBuilderExtensions e).getUseCookiePolicyMethod() and
    oc.getType() instanceof MicrosoftAspNetCoreBuilderCookiePolicyOptions and
    getAValueForProp(oc, _, prop) = val and
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

private signature string propertyName();

/**
 * Configuration for tracking if a callback used in `OnAppendCookie` sets a cookie property to `true`.
 */
private module OnAppendCookieTrackingConfig<propertyName/0 getPropertyName> implements
  DataFlow::ConfigSig
{
  /**
   * Specifies the cookie property name to track.
   */
  predicate isSource(DataFlow::Node source) {
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

  predicate isSink(DataFlow::Node sink) {
    exists(PropertyWrite pw, Assignment a |
      pw.getProperty().getDeclaringType() instanceof MicrosoftAspNetCoreHttpCookieOptions and
      pw.getProperty().getName() = getPropertyName() and
      a.getLValue() = pw and
      exists(Expr val |
        DataFlow::localExprFlow(val, a.getRValue()) and
        val.getValue() = "true"
      ) and
      sink.asExpr() = pw.getQualifier()
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    node2.asExpr() =
      any(PropertyRead pr |
        pr.getQualifier() = node1.asExpr() and
        pr.getProperty().getDeclaringType() instanceof
          MicrosoftAspNetCoreCookiePolicyAppendCookieContext
      )
  }
}

private string getPropertyNameSecure() { result = "Secure" }

/**
 * Configuration module for tracking if a callback used in `OnAppendCookie` sets `Secure` to `true`.
 */
private module OnAppendCookieSecureTrackingConfig =
  OnAppendCookieTrackingConfig<getPropertyNameSecure/0>;

/**
 * Tracks if a callback used in `OnAppendCookie` sets `Secure` to `true`.
 */
module OnAppendCookieSecureTracking = DataFlow::Global<OnAppendCookieSecureTrackingConfig>;

private string getPropertyNameHttpOnly() { result = "HttpOnly" }

/**
 * Configuration module for tracking if a callback used in `OnAppendCookie` sets `HttpOnly` to `true`.
 */
private module OnAppendCookieHttpOnlyTrackingConfig =
  OnAppendCookieTrackingConfig<getPropertyNameHttpOnly/0>;

/**
 * Tracks if a callback used in `OnAppendCookie` sets `HttpOnly` to `true`.
 */
module OnAppendCookieHttpOnlyTracking = DataFlow::Global<OnAppendCookieHttpOnlyTrackingConfig>;
