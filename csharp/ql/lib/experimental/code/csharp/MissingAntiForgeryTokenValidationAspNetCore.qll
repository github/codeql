private import csharp
private import semmle.code.csharp.frameworks.system.Web
private import semmle.code.csharp.frameworks.system.web.Helpers as Helpers
private import semmle.code.csharp.frameworks.system.web.Mvc as Mvc
private import semmle.code.csharp.frameworks.microsoft.AspNetCore as AspNetCore

class AntiForgeryClass extends Class {
  AntiForgeryClass() {
    this instanceof Helpers::AntiForgeryClass or
    this instanceof AspNetCore::AntiForgeryClass
  }

  /** Gets the `Validate` method. */
  Method getValidateMethod() {
    result = this.(Helpers::AntiForgeryClass).getValidateMethod() or
    result = this.(AspNetCore::AntiForgeryClass).getValidateMethod()
  }
}

class ValidateAntiForgeryTokenAttribute extends Attribute {
  ValidateAntiForgeryTokenAttribute() {
    this instanceof Mvc::ValidateAntiForgeryTokenAttribute or
    this instanceof AspNetCore::ValidateAntiForgeryAttribute
  }
}

class Controller extends Class {
  Controller() {
    this instanceof Mvc::Controller or
    this instanceof AspNetCore::MicrosoftAspNetCoreMvcController
  }

  Method getAPostActionMethod() {
    result = this.(Mvc::Controller).getAPostActionMethod()
    or
    exists(Method method |
      method = this.(AspNetCore::MicrosoftAspNetCoreMvcController).getAnActionMethod() and
      method.getAnAttribute() instanceof AspNetCore::MicrosoftAspNetCoreMvcHttpPostAttribute and
      result = method
    )
  }
}

/** An `AuthorizationFilter` that calls the `AntiForgery.Validate` method. */
class AntiForgeryAuthorizationFilter extends Mvc::AuthorizationFilter {
  AntiForgeryAuthorizationFilter() {
    this.getOnAuthorizationMethod().calls*(any(AntiForgeryClass a).getValidateMethod())
  }
}

class AutoValidateAntiForgeryTokenFilter extends Expr {
  AutoValidateAntiForgeryTokenFilter() {
    exists(
      MethodCall addControllers, LambdaExpr lambda, ParameterAccess options, PropertyCall filters,
      MethodCall add
    |
      // "AddMvc", "AddControllersWithViews", "AddMvcCore", "AddControllers", "AddRazorPages", so generalised to "Add*" to future-proof
      addControllers.getTarget().getName().matches("Add%") and
      addControllers.getArgument(1) = lambda and
      lambda.getAParameter().getAnAccess() = options and
      filters.getQualifier() = options and
      filters.getTarget().getName() = "get_Filters" and
      add.getQualifier() = filters and
      add.getTarget().getUndecoratedName() = "Add" and
      this = add and
      (
        // new AutoValidateAntiforgeryTokenAttribute()
        exists(ObjectCreation obj |
          add.getArgument(0) = obj and
          obj.getType() instanceof AutoValidateAntiforgeryTokenAttributeType
        )
        or
        // typeof(AutoValidateAntiforgeryTokenAttribute)
        exists(TypeAccess access |
          add.getArgument(0).(TypeofExpr).getAChild() = access and
          access.getType() instanceof AutoValidateAntiforgeryTokenAttributeType
        )
        or
        // Add<AutoValidateAntiforgeryTokenAttribute>()
        add.getTarget().getName() = "Add<AutoValidateAntiforgeryTokenAttribute>"
      )
    )
  }
}

// Accounts for custom classes with a similar name
class AutoValidateAntiforgeryTokenAttributeType extends Type {
  AutoValidateAntiforgeryTokenAttributeType() {
    this.getName().matches("%AutoValidateAntiforgeryTokenAttribute")
  }
}

class IgnoreAntiforgeryTokenAttribute extends Attribute {
  IgnoreAntiforgeryTokenAttribute() { this.getType().getName() = "IgnoreAntiforgeryTokenAttribute" }
}

class AutoValidateAntiforgeryTokenAttribute extends Attribute {
  AutoValidateAntiforgeryTokenAttribute() {
    this.getType() instanceof AutoValidateAntiforgeryTokenAttributeType
  }
}

/**
 * Holds if the project has a global anti forgery filter.
 */
predicate hasGlobalAntiForgeryFilter() {
  // A global filter added
  exists(MethodCall addGlobalFilter |
    // addGlobalFilter adds a filter to the global filter collection
    addGlobalFilter.getTarget() = any(Mvc::GlobalFilterCollection gfc).getAddMethod() and
    // The filter is an antiforgery filter
    addGlobalFilter.getArgumentForName("filter").getType() instanceof AntiForgeryAuthorizationFilter and
    // The filter is added by the Application_Start() method
    any(WebApplication wa)
        .getApplication_StartMethod()
        .calls*(addGlobalFilter.getEnclosingCallable())
  )
  or
  // for ASP.NET Core
  exists(AutoValidateAntiForgeryTokenFilter filter)
}

predicate isLoginAction(Method m) { m.getName() = "Login" }

predicate methodHasCsrfAttribute(Method method) {
  exists(Attribute attribute |
    (
      attribute instanceof ValidateAntiForgeryTokenAttribute or
      attribute instanceof IgnoreAntiforgeryTokenAttribute
    ) and
    (
      method.getAnAttribute() = attribute or
      method.getAnUltimateImplementee().getAnAttribute() = attribute
    )
  )
}

predicate controllerHasCsrfAttribute(Controller c) {
  exists(Attribute attribute |
    (
      attribute instanceof ValidateAntiForgeryTokenAttribute or
      attribute instanceof IgnoreAntiforgeryTokenAttribute or
      attribute instanceof AutoValidateAntiforgeryTokenAttribute
    ) and
    c.getBaseClass*().getAnAttribute() = attribute
  )
}
