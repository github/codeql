/**
 * @name Missing cross-site request forgery token validation
 * @description Handling a POST request without verifying that the request came from the user
 *              allows a malicious attacker to submit a request on behalf of the user.
 * @kind problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id cs/web/missing-token-validation
 * @tags security
 *       external/cwe/cwe-352
 */

import csharp
import semmle.code.csharp.frameworks.system.Web
import semmle.code.csharp.frameworks.system.web.Helpers
import semmle.code.csharp.frameworks.system.web.Mvc
import semmle.code.csharp.frameworks.microsoft.AspNetCore as AspNetCore

private Method getAValidatingMethod() {
  result = any(AntiForgeryClass a).getValidateMethod()
  or
  result.calls(getAValidatingMethod())
}

/** An `AuthorizationFilter` that calls the `AntiForgery.Validate` method. */
class AntiForgeryAuthorizationFilter extends AuthorizationFilter {
  AntiForgeryAuthorizationFilter() { this.getOnAuthorizationMethod() = getAValidatingMethod() }
}

private Method getAStartedMethod() {
  result = any(WebApplication wa).getApplication_StartMethod()
  or
  getAStartedMethod().calls(result)
}

/**
 * Holds if the project has a global anti forgery filter.
 *
 * No AspNetCore case here as the corresponding class doesn't seem to exist.
 */
predicate hasGlobalAntiForgeryFilter() {
  // A global filter added
  exists(MethodCall addGlobalFilter |
    // addGlobalFilter adds a filter to the global filter collection
    addGlobalFilter.getTarget() = any(GlobalFilterCollection gfc).getAddMethod() and
    // The filter is an antiforgery filter
    addGlobalFilter.getArgumentForName("filter").getType() instanceof AntiForgeryAuthorizationFilter and
    // The filter is added by the Application_Start() method
    getAStartedMethod() = addGlobalFilter.getEnclosingCallable()
  )
}

private class RequireAntiforgeryTokenAttribute extends Attribute {
  RequireAntiforgeryTokenAttribute() {
    this.getType()
        .hasFullyQualifiedName("Microsoft.AspNetCore.Antiforgery",
          "RequireAntiforgeryTokenAttribute")
  }

  predicate requiresValidation() {
    not exists(this.getArgument(0))
    or
    this.getArgument(0).isImplicit()
    or
    this.getArgument(0).getValue() = "true"
  }
}

private predicate hasAspNetCoreAntiForgeryMiddleware() {
  exists(MethodCall call |
    call.getTarget()
        .hasFullyQualifiedName("Microsoft.AspNetCore.Builder",
          "AntiforgeryApplicationBuilderExtensions", "UseAntiforgery")
  )
}

bindingset[method]
private RequireAntiforgeryTokenAttribute getEffectiveRequireAntiforgeryTokenAttributeOnMethod(
  Method method
) {
  exists(Method attributedMethod |
    attributedMethod = method.getOverridee*() and
    result = attributedMethod.getAnAttribute() and
    not exists(Method closerMethod |
      closerMethod = method.getOverridee*() and
      closerMethod.getOverridee+() = attributedMethod and
      closerMethod.getAnAttribute() instanceof RequireAntiforgeryTokenAttribute
    )
  )
}

bindingset[controller]
private RequireAntiforgeryTokenAttribute getEffectiveRequireAntiforgeryTokenAttributeOnClass(
  Class controller
) {
  exists(Class attributedClass |
    attributedClass = controller.getBaseClass*() and
    result = attributedClass.getAnAttribute() and
    not exists(Class closerClass |
      closerClass = controller.getBaseClass*() and
      closerClass.getBaseClass+() = attributedClass and
      closerClass.getAnAttribute() instanceof RequireAntiforgeryTokenAttribute
    )
  )
}

bindingset[controller, method]
private RequireAntiforgeryTokenAttribute getEffectiveRequireAntiforgeryTokenAttribute(
  Class controller, Method method
) {
  result = getEffectiveRequireAntiforgeryTokenAttributeOnMethod(method)
  or
  not exists(getEffectiveRequireAntiforgeryTokenAttributeOnMethod(method)) and
  result = getEffectiveRequireAntiforgeryTokenAttributeOnClass(controller)
}

bindingset[controller, method]
private predicate hasAspNetCoreAntiForgeryValidation(Class controller, Method method) {
  method.getAnAttribute() instanceof AspNetCore::ValidateAntiForgeryAttribute
  or
  controller.getABaseType*().getAnAttribute() instanceof AspNetCore::ValidateAntiForgeryAttribute
  or
  hasAspNetCoreAntiForgeryMiddleware() and
  getEffectiveRequireAntiforgeryTokenAttribute(controller, method).requiresValidation()
}

predicate isUnvalidatedPostMethod(Class c, Method m) {
  c.(Controller).getAPostActionMethod() = m and
  not m.getAnAttribute() instanceof ValidateAntiForgeryTokenAttribute and
  not c.getABaseType*().getAnAttribute() instanceof ValidateAntiForgeryTokenAttribute
  or
  c.(AspNetCore::MicrosoftAspNetCoreMvcController).getAnActionMethod() = m and
  m.getAnAttribute() instanceof AspNetCore::MicrosoftAspNetCoreMvcHttpPostAttribute and
  not hasAspNetCoreAntiForgeryValidation(c, m)
}

Element getAValidatedElement() {
  any(ValidateAntiForgeryTokenAttribute a).getTarget() = result
  or
  any(AspNetCore::ValidateAntiForgeryAttribute a).getTarget() = result
  or
  hasAspNetCoreAntiForgeryMiddleware() and
  any(RequireAntiforgeryTokenAttribute a | a.requiresValidation()).getTarget() = result
}

from Class c, Method postMethod
where
  isUnvalidatedPostMethod(c, postMethod) and
  // Verify that validate anti forgery token attributes are used somewhere within this project, to
  // avoid reporting false positives on projects that use an alternative approach to mitigate CSRF
  // issues.
  exists(getAValidatedElement()) and
  // Also ignore cases where a global anti forgery filter is in use.
  not hasGlobalAntiForgeryFilter()
select postMethod,
  "Method '" + postMethod.getName() +
    "' handles a POST request without performing CSRF token validation."
