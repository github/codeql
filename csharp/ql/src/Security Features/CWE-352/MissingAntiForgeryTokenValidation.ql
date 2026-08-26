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
  or
  exists(MethodCall addGlobalFilter, MethodCall registrationCall |
    addGlobalFilter.getTarget() =
      any(AspNetCore::MicrosoftAspNetCoreMvcFilterCollection collection).getAddMethod() and
    // The filter is the `AutoValidateAntiforgeryTokenAttribute` filter.
    addGlobalFilter.getArgument(0).getType() instanceof
      AspNetCore::AutoValidateAntiforgeryTokenAttribute and
    // The filter is added in an ASP.NET Core registration call, which is provided as a lambda argument
    // to the Mvc registration method.
    registrationCall.getTarget() instanceof AspNetCore::MicrosoftAspNetCoreMvcRegistration and
    registrationCall.getAnArgument() = addGlobalFilter.getEnclosingCallable()
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

class MvcControllerPostMethod extends Method {
  private Controller controller;

  MvcControllerPostMethod() { controller.getAPostActionMethod() = this }

  predicate hasValidateAntiForgeryAttribute() {
    this.getAnAttribute() instanceof ValidateAntiForgeryTokenAttribute or
    controller.getABaseType*().getAnAttribute() instanceof ValidateAntiForgeryTokenAttribute
  }
}

class AspNetCoreControllerPostMethod extends Method {
  private AspNetCore::MicrosoftAspNetCoreMvcController controller;

  AspNetCoreControllerPostMethod() {
    controller.getAnActionMethod() = this and
    this.getAnAttribute() instanceof AspNetCore::MicrosoftAspNetCoreMvcHttpPostAttribute
  }

  predicate hasValidateAntiForgeryAttribute() {
    this.getAnAttribute() instanceof AspNetCore::ValidateAntiForgeryAttribute or
    controller.getABaseType*().getAnAttribute() instanceof AspNetCore::ValidateAntiForgeryAttribute
  }

  predicate hasRequireAntiForgeryAttribute() {
    hasAspNetCoreAntiForgeryMiddleware() and
    (
      getEffectiveRequireAntiforgeryTokenAttributeOnMethod(this).requiresValidation()
      or
      not exists(getEffectiveRequireAntiforgeryTokenAttributeOnMethod(this)) and
      getEffectiveRequireAntiforgeryTokenAttributeOnClass(controller).requiresValidation()
    )
  }
}

predicate isUnvalidatedAspNetCorePostMethod(AspNetCoreControllerPostMethod m) {
  not m.hasValidateAntiForgeryAttribute() and
  not m.hasRequireAntiForgeryAttribute()
}

predicate isUnvalidatedMvcPostMethod(MvcControllerPostMethod m) {
  not m.hasValidateAntiForgeryAttribute()
}

predicate isUnvalidatedPostMethod(Method m) {
  isUnvalidatedMvcPostMethod(m) or
  isUnvalidatedAspNetCorePostMethod(m)
}

Element getAValidatedElement() {
  any(ValidateAntiForgeryTokenAttribute a).getTarget() = result
  or
  any(AspNetCore::ValidateAntiForgeryAttribute a).getTarget() = result
  or
  hasAspNetCoreAntiForgeryMiddleware() and
  any(RequireAntiforgeryTokenAttribute a | a.requiresValidation()).getTarget() = result
}

from Method postMethod
where
  isUnvalidatedPostMethod(postMethod) and
  // Verify that validate anti forgery token attributes are used somewhere within this project, to
  // avoid reporting false positives on projects that use an alternative approach to mitigate CSRF
  // issues.
  exists(getAValidatedElement()) and
  // Also ignore cases where a global anti forgery filter is in use.
  not hasGlobalAntiForgeryFilter()
select postMethod,
  "Method '" + postMethod.getName() +
    "' handles a POST request without performing CSRF token validation."
