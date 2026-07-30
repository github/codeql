/** Provides classes for working with `Microsoft.AspNetCore.Mvc`. */

import csharp
import semmle.code.csharp.frameworks.Microsoft
private import semmle.code.csharp.commons.Compilation
private import semmle.code.csharp.frameworks.System

/** The `Microsoft.AspNetCore` namespace. */
class MicrosoftAspNetCoreNamespace extends Namespace {
  MicrosoftAspNetCoreNamespace() {
    this.getParentNamespace() instanceof MicrosoftNamespace and
    this.hasName("AspNetCore")
  }
}

/** The `Microsoft.AspNetCore.Mvc` namespace. */
class MicrosoftAspNetCoreMvcNamespace extends Namespace {
  MicrosoftAspNetCoreMvcNamespace() {
    this.getParentNamespace() instanceof MicrosoftAspNetCoreNamespace and
    this.hasName("Mvc")
  }
}

/** The 'Microsoft.AspNetCore.Mvc.ViewFeatures' namespace. */
class MicrosoftAspNetCoreMvcViewFeatures extends Namespace {
  MicrosoftAspNetCoreMvcViewFeatures() {
    this.getParentNamespace() instanceof MicrosoftAspNetCoreMvcNamespace and
    this.hasName("ViewFeatures")
  }
}

/** The 'Microsoft.AspNetCore.Mvc.Rendering' namespace. */
class MicrosoftAspNetCoreMvcRendering extends Namespace {
  MicrosoftAspNetCoreMvcRendering() {
    this.getParentNamespace() instanceof MicrosoftAspNetCoreMvcNamespace and
    this.hasName("Rendering")
  }
}

/** An attribute whose type is in the `Microsoft.AspNetCore.Mvc` namespace. */
class MicrosoftAspNetCoreMvcAttribute extends Attribute {
  MicrosoftAspNetCoreMvcAttribute() {
    this.getType().getNamespace() instanceof MicrosoftAspNetCoreMvcNamespace
  }
}

/** A `Microsoft.AspNetCore.Mvc.HttpPost` attribute. */
class MicrosoftAspNetCoreMvcHttpPostAttribute extends MicrosoftAspNetCoreMvcAttribute {
  MicrosoftAspNetCoreMvcHttpPostAttribute() { this.getType().hasName("HttpPostAttribute") }
}

/** A `Microsoft.AspNetCore.Mvc.HttpPut` attribute. */
class MicrosoftAspNetCoreMvcHttpPutAttribute extends MicrosoftAspNetCoreMvcAttribute {
  MicrosoftAspNetCoreMvcHttpPutAttribute() { this.getType().hasName("HttpPutAttribute") }
}

/** A `Microsoft.AspNetCore.Mvc.HttpDelete` attribute. */
class MicrosoftAspNetCoreMvcHttpDeleteAttribute extends MicrosoftAspNetCoreMvcAttribute {
  MicrosoftAspNetCoreMvcHttpDeleteAttribute() { this.getType().hasName("HttpDeleteAttribute") }
}

/** A `Microsoft.AspNetCore.Mvc.NonAction` attribute. */
class MicrosoftAspNetCoreMvcNonActionAttribute extends MicrosoftAspNetCoreMvcAttribute {
  MicrosoftAspNetCoreMvcNonActionAttribute() { this.getType().hasName("NonActionAttribute") }
}

/** A `Microsoft.AspNetCore.Mvc.NonController` attribute. */
class MicrosoftAspNetCoreMvcNonControllerAttribute extends MicrosoftAspNetCoreMvcAttribute {
  MicrosoftAspNetCoreMvcNonControllerAttribute() {
    this.getType().hasName("NonControllerAttribute")
  }
}

/** The `Microsoft.AspNetCore.Antiforgery` namespace. */
class MicrosoftAspNetCoreAntiforgeryNamespace extends Namespace {
  MicrosoftAspNetCoreAntiforgeryNamespace() {
    this.getParentNamespace() instanceof MicrosoftAspNetCoreNamespace and
    this.hasName("Antiforgery")
  }
}

/** The `Microsoft.AspNetCore.Mvc.Filters` namespace. */
class MicrosoftAspNetCoreMvcFilters extends Namespace {
  MicrosoftAspNetCoreMvcFilters() {
    this.getParentNamespace() instanceof MicrosoftAspNetCoreMvcNamespace and
    this.hasName("Filters")
  }
}

/** The `Microsoft.AspNetCore.Mvc.Filters.IFilterMetadataInterface` interface. */
class MicrosoftAspNetCoreMvcIFilterMetadataInterface extends Interface {
  MicrosoftAspNetCoreMvcIFilterMetadataInterface() {
    this.getNamespace() instanceof MicrosoftAspNetCoreMvcFilters and
    this.hasName("IFilterMetadata")
  }
}

/** The `Microsoft.AspNetCore.IAuthorizationFilter` interface. */
class MicrosoftAspNetCoreIAuthorizationFilterInterface extends Interface {
  MicrosoftAspNetCoreIAuthorizationFilterInterface() {
    this.getNamespace() instanceof MicrosoftAspNetCoreMvcFilters and
    this.hasName("IAsyncAuthorizationFilter")
  }

  /** Gets the `OnAuthorizationAsync` method. */
  Method getOnAuthorizationMethod() { result = this.getAMethod("OnAuthorizationAsync") }
}

/** The `Microsoft.AspNetCore.IAntiforgery` interface. */
class MicrosoftAspNetCoreIAntiForgeryInterface extends Interface {
  MicrosoftAspNetCoreIAntiForgeryInterface() {
    this.getNamespace() instanceof MicrosoftAspNetCoreAntiforgeryNamespace and
    this.hasName("IAntiforgery")
  }

  /** Gets the `ValidateRequestAsync` method. */
  Method getValidateMethod() { result = this.getAMethod("ValidateRequestAsync") }
}

/** The `Microsoft.AspNetCore.DefaultAntiForgery` class, or another user-supplied class that implements `IAntiForgery`. */
class AntiForgeryClass extends Class {
  AntiForgeryClass() {
    this.getABaseInterface*() instanceof MicrosoftAspNetCoreIAntiForgeryInterface
  }

  /** Gets the `ValidateRequestAsync` method. */
  Method getValidateMethod() { result = this.getAMethod("ValidateRequestAsync") }
}

/** An authorization filter class defined by AspNetCore or the user. */
class AuthorizationFilterClass extends Class {
  AuthorizationFilterClass() {
    this.getABaseInterface*() instanceof MicrosoftAspNetCoreIAuthorizationFilterInterface
  }

  /** Gets the `OnAuthorization` method provided by this filter. */
  Method getOnAuthorizationMethod() { result = this.getAMethod("OnAuthorizationAsync") }
}

/** An attribute whose type has a name like `[Auto...]Validate[...]Anti[Ff]orgery[...Token]Attribute`. */
class ValidateAntiForgeryAttribute extends Attribute {
  ValidateAntiForgeryAttribute() {
    this.getType().getName().matches("%Validate%Anti_orgery%Attribute")
  }
}

/**
 * A class that has a name like `[Auto...]Validate[...]Anti[Ff]orgery[...Token]` and implements `IFilterMetadata` interface
 * This class can be added to a collection of global `MvcOptions.Filters` collection.
 */
class ValidateAntiforgeryTokenAuthorizationFilter extends Class {
  ValidateAntiforgeryTokenAuthorizationFilter() {
    this.getABaseInterface*() instanceof MicrosoftAspNetCoreMvcIFilterMetadataInterface and
    this.getName().matches("%Validate%Anti_orgery%")
  }
}

/** The `Microsoft.AspNetCore.Mvc.Filters.FilterCollection` class. */
class MicrosoftAspNetCoreMvcFilterCollection extends Class {
  MicrosoftAspNetCoreMvcFilterCollection() {
    this.getNamespace() instanceof MicrosoftAspNetCoreMvcFilters and
    this.hasName("FilterCollection")
  }

  /** Gets an `Add` method. */
  Method getAddMethod() {
    result = this.getAMethod("Add") or
    result = this.getABaseType().getAMethod("Add")
  }
}

/** The `Microsoft.AspNetCore.Mvc.MvcOptions` class. */
class MicrosoftAspNetCoreMvcOptions extends Class {
  MicrosoftAspNetCoreMvcOptions() {
    this.getNamespace() instanceof MicrosoftAspNetCoreMvcNamespace and
    this.hasName("MvcOptions")
  }

  /** Gets the `Filters` property. */
  Property getFilterCollectionProperty() { result = this.getProperty("Filters") }
}

/** The base class for controllers in MVC, i.e. `Microsoft.AspNetCore.Mvc.Controller` or `Microsoft.AspNetCore.Mvc.ControllerBase` class. */
class MicrosoftAspNetCoreMvcControllerBaseClass extends Class {
  MicrosoftAspNetCoreMvcControllerBaseClass() {
    this.getNamespace() instanceof MicrosoftAspNetCoreMvcNamespace and
    (
      this.hasName("Controller") or
      this.hasName("ControllerBase")
    )
  }
}

private predicate isPotentialMicrosoftAspNetCoreMvcController(Class controller) {
  controller =
    any(Class c |
      (
        exists(Assembly a |
          a.getName() = ["Microsoft.AspNetCore.Mvc.Core", "Microsoft.AspNetCore.Mvc.ViewFeatures"]
        ) or
        exists(UsingNamespaceDirective ns |
          ns.getImportedNamespace() instanceof MicrosoftAspNetCoreMvcNamespace
        )
      ) and
      c.isPublic() and
      not c instanceof Generic and
      (
        c.getABaseType*() instanceof MicrosoftAspNetCoreMvcControllerBaseClass
        or
        c.getABaseType*().getName().matches("%Controller")
        or
        c.getABaseType*()
            .getAnAttribute()
            .getType()
            .getABaseType*()
            // ApiControllerAttribute is derived from ControllerAttribute
            .hasFullyQualifiedName("Microsoft.AspNetCore.Mvc", "ControllerAttribute")
      ) and
      not c.getABaseType*().getAnAttribute() instanceof MicrosoftAspNetCoreMvcNonControllerAttribute
    )
}

private Compilation getACompilationFor(Element element) {
  result.getAFileCompiled() = element.getFile()
}

private Assembly getAnAssemblyFor(Type type) {
  result = getACompilationFor(type).getOutputAssembly()
}

private predicate isMicrosoftAspNetCoreMvcRegistration(MethodCall call) {
  call.getTarget()
      .hasFullyQualifiedName("Microsoft.Extensions.DependencyInjection",
        ["MvcServiceCollectionExtensions", "MvcCoreServiceCollectionExtensions"],
        ["AddControllers", "AddControllersWithViews", "AddMvc", "AddMvcCore"])
}

private predicate isMicrosoftAspNetCoreMvcApplication(Compilation compilation) {
  exists(MethodCall registration |
    isMicrosoftAspNetCoreMvcRegistration(registration) and
    compilation.getAFileCompiled() = registration.getFile()
  )
}

private predicate isMicrosoftAspNetCoreMvcAddApplicationPart(MethodCall call) {
  call.getTarget()
      .hasFullyQualifiedName("Microsoft.Extensions.DependencyInjection",
        ["MvcCoreMvcBuilderExtensions", "MvcCoreMvcCoreBuilderExtensions"], "AddApplicationPart")
}

private predicate isMicrosoftAspNetCoreMvcApplicationPart(Compilation application, Assembly part) {
  part = application.getOutputAssembly()
  or
  exists(AssemblyAttribute attr, StringLiteral assemblyName |
    application.getAFileCompiled() = attr.getFile() and
    attr.getType()
        .hasFullyQualifiedName("Microsoft.AspNetCore.Mvc.ApplicationParts",
          "ApplicationPartAttribute") and
    assemblyName = attr.getArgument(0) and
    assemblyName.getValue() = part.getName()
  )
  or
  exists(MethodCall addPart, PropertyAccess assemblyAccess, TypeofExpr typeOf, Type partType |
    application.getAFileCompiled() = addPart.getFile() and
    isMicrosoftAspNetCoreMvcAddApplicationPart(addPart) and
    assemblyAccess = addPart.getArgumentForName("assembly") and
    assemblyAccess.getTarget().hasName("Assembly") and
    assemblyAccess.getQualifier() = typeOf and
    partType = typeOf.getTypeAccess().getTarget() and
    part = getAnAssemblyFor(partType)
  )
}

private predicate isInMicrosoftAspNetCoreMvcApplication(Class controller, Compilation application) {
  isMicrosoftAspNetCoreMvcApplication(application) and
  isMicrosoftAspNetCoreMvcApplicationPart(application, getAnAssemblyFor(controller))
}

private predicate hasMicrosoftAspNetCoreMvcAttributeRoute(Class controller) {
  exists(Attribute attr |
    (
      attr = controller.getABaseType*().getAnAttribute()
      or
      exists(Method method |
        controller.hasMember(method) and
        attr = method.getOverridee*().getAnAttribute()
      )
    ) and
    attr.getType()
        .getABaseType*()
        .getABaseInterface*()
        .hasFullyQualifiedName("Microsoft.AspNetCore.Mvc.Routing", "IRouteTemplateProvider")
  )
}

private predicate isMicrosoftAspNetCoreMvcConventionalEndpointMapping(MethodCall call) {
  call.getTarget()
      .hasFullyQualifiedName("Microsoft.AspNetCore.Builder",
        "ControllerEndpointRouteBuilderExtensions",
        [
          "MapAreaControllerRoute", "MapControllerRoute", "MapDefaultControllerRoute",
          "MapDynamicControllerRoute"
        ])
  or
  call.getTarget()
      .hasFullyQualifiedName("Microsoft.AspNetCore.Builder", "MvcApplicationBuilderExtensions",
        "UseMvcWithDefaultRoute")
  or
  call.getTarget()
      .hasFullyQualifiedName("Microsoft.AspNetCore.Builder", "MvcApplicationBuilderExtensions",
        "UseMvc") and
  exists(call.getArgumentForName("configureRoutes"))
  or
  call.getTarget()
      .hasFullyQualifiedName("Microsoft.AspNetCore.Builder", "MvcAreaRouteBuilderExtensions",
        "MapAreaRoute")
}

private predicate isMicrosoftAspNetCoreMvcAttributeEndpointMapping(MethodCall call) {
  call.getTarget()
      .hasFullyQualifiedName("Microsoft.AspNetCore.Builder",
        "ControllerEndpointRouteBuilderExtensions", "MapControllers")
  or
  call.getTarget()
      .hasFullyQualifiedName("Microsoft.AspNetCore.Builder", "MvcApplicationBuilderExtensions",
        "UseMvc") and
  not exists(call.getArgumentForName("configureRoutes"))
}

private predicate hasMicrosoftAspNetCoreMvcEndpointMapping(Compilation application, Class controller) {
  exists(MethodCall mapping |
    application.getAFileCompiled() = mapping.getFile() and
    (
      isMicrosoftAspNetCoreMvcConventionalEndpointMapping(mapping)
      or
      isMicrosoftAspNetCoreMvcAttributeEndpointMapping(mapping) and
      hasMicrosoftAspNetCoreMvcAttributeRoute(controller)
    )
  )
}

private predicate hasMicrosoftAspNetCoreMvcControllerIdentity(Class controller) {
  controller.getABaseType*() instanceof MicrosoftAspNetCoreMvcControllerBaseClass
  or
  controller
      .getABaseType*()
      .getAnAttribute()
      .getType()
      .getABaseType*()
      .hasFullyQualifiedName("Microsoft.AspNetCore.Mvc", "ControllerAttribute")
}

private predicate isDefaultMicrosoftAspNetCoreMvcController(Class controller) {
  controller instanceof NonNestedType and
  controller.isPublic() and
  not controller.isAbstract() and
  not controller instanceof Generic and
  (
    hasMicrosoftAspNetCoreMvcControllerIdentity(controller)
    or
    exists(Compilation application |
      controller.getName().toLowerCase().matches("%controller") and
      isInMicrosoftAspNetCoreMvcApplication(controller, application) and
      hasMicrosoftAspNetCoreMvcEndpointMapping(application, controller)
    )
  ) and
  not controller.getABaseType*().getAnAttribute() instanceof
    MicrosoftAspNetCoreMvcNonControllerAttribute
}

/** A class treated as an owner of ASP.NET Core MVC controller helper methods. */
class MicrosoftAspNetCoreMvcControllerHelperClass extends Class {
  MicrosoftAspNetCoreMvcControllerHelperClass() {
    isPotentialMicrosoftAspNetCoreMvcController(this)
  }

  /** Gets a `Redirect*`, `Accepted*`, or `Created*` method. */
  Method getAResponseMethod() {
    result = this.getAMethod() and
    (
      result.getName().matches("Redirect%")
      or
      result.getName().matches("Accepted%")
      or
      result.getName().matches("Created%")
    )
  }
}

/**
 * A valid ASP.NET Core controller according to:
 * https://docs.microsoft.com/en-us/aspnet/core/mvc/controllers/actions?view=aspnetcore-3.1
 * https://github.com/dotnet/aspnetcore/blob/b3c93967ba508b8ef139add27132d9483c1a9eb4/src/Mvc/Mvc.Core/src/Controllers/ControllerFeatureProvider.cs#L39-L75
 */
class MicrosoftAspNetCoreMvcController extends Class {
  MicrosoftAspNetCoreMvcController() { isDefaultMicrosoftAspNetCoreMvcController(this) }

  /** Gets an action method for this controller. */
  Method getAnActionMethod() {
    this.hasMember(result) and
    result.isPublic() and
    not result.isStatic() and
    not result.isAbstract() and
    not result.getUnboundDeclaration() instanceof UnboundGenericMethod and
    not result.getOverridee*().getAnAttribute() instanceof MicrosoftAspNetCoreMvcNonActionAttribute and
    not result.getOverridee*().getDeclaringType() instanceof ObjectType and
    not result instanceof DisposeMethod
  }

  /** Gets a `Redirect*` method. */
  Method getARedirectMethod() {
    result = this.(MicrosoftAspNetCoreMvcControllerHelperClass).getAResponseMethod()
  }
}

/** The `Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper` interface. */
class MicrosoftAspNetCoreMvcRenderingIHtmlHelperInterface extends Interface {
  MicrosoftAspNetCoreMvcRenderingIHtmlHelperInterface() {
    this.getNamespace() instanceof MicrosoftAspNetCoreMvcRendering and
    this.hasName("IHtmlHelper")
  }

  /** Gets the `Raw` method. */
  Method getRawMethod() { result = this.getAMethod("Raw") }
}

/** A class deriving from `Microsoft.AspNetCore.Mvc.Razor.RazorPageBase`, implements Razor page in ASPNET Core. */
class MicrosoftAspNetCoreMvcRazorPageBase extends Class {
  MicrosoftAspNetCoreMvcRazorPageBase() {
    this.getABaseType*().hasFullyQualifiedName("Microsoft.AspNetCore.Mvc.Razor", "RazorPageBase")
  }

  /** Gets the `WriteLiteral` method. */
  Method getWriteLiteralMethod() { result = this.getAMethod("WriteLiteral") }
}

/** A class deriving from `Microsoft.AspNetCore.Http.HttpRequest`, implements `HttpRequest` in ASP.NET Core. */
class MicrosoftAspNetCoreHttpHttpRequest extends Class {
  MicrosoftAspNetCoreHttpHttpRequest() {
    this.getABaseType*().hasFullyQualifiedName("Microsoft.AspNetCore.Http", "HttpRequest")
  }
}

/** A class deriving from `Microsoft.AspNetCore.Http.HttpResponse`, implements `HttpResponse` in ASP.NET Core. */
class MicrosoftAspNetCoreHttpHttpResponse extends Class {
  MicrosoftAspNetCoreHttpHttpResponse() {
    this.getABaseType*().hasFullyQualifiedName("Microsoft.AspNetCore.Http", "HttpResponse")
  }

  /** Gets the `Redirect` method. */
  Method getRedirectMethod() { result = this.getAMethod("Redirect") }

  /** Gets the `Headers` property. */
  Property getHeadersProperty() { result = this.getProperty("Headers") }
}

/** An interface that is a wrapper around the collection of cookies in the response. */
class MicrosoftAspNetCoreHttpResponseCookies extends Interface {
  MicrosoftAspNetCoreHttpResponseCookies() {
    this.hasFullyQualifiedName("Microsoft.AspNetCore.Http", "IResponseCookies")
  }

  /** Gets the `Append` method. */
  Method getAppendMethod() { result = this.getAMethod("Append") }
}

/** The class `Microsoft.AspNetCore.Http.QueryString`, holds query string in ASP.NET Core. */
class MicrosoftAspNetCoreHttpQueryString extends Struct {
  MicrosoftAspNetCoreHttpQueryString() {
    this.hasFullyQualifiedName("Microsoft.AspNetCore.Http", "QueryString")
  }
}

/** A class or interface implementing `IQueryCollection`, holds parsed query string in ASP.NET Core. */
class MicrosoftAspNetCoreHttpQueryCollection extends RefType {
  MicrosoftAspNetCoreHttpQueryCollection() {
    this.getABaseInterface().hasFullyQualifiedName("Microsoft.AspNetCore.Http", "IQueryCollection")
  }
}

/** The helper class `ResponseHeaders` for setting headers. */
class MicrosoftAspNetCoreHttpResponseHeaders extends RefType {
  MicrosoftAspNetCoreHttpResponseHeaders() {
    this.hasFullyQualifiedName("Microsoft.AspNetCore.Http.Headers", "ResponseHeaders")
  }

  /** Gets the `Location` property. */
  Property getLocationProperty() { result = this.getProperty("Location") }
}

/** The `Microsoft.AspNetCore.Http.HeaderDictionaryExtensions` class. */
class MicrosoftAspNetCoreHttpHeaderDictionaryExtensions extends RefType {
  MicrosoftAspNetCoreHttpHeaderDictionaryExtensions() {
    this.hasFullyQualifiedName("Microsoft.AspNetCore.Http", "HeaderDictionaryExtensions")
  }

  /** Gets the `Append` extension method. */
  Method getAppendMethod() { result = this.getAMethod("Append") }

  /** Gets the `AppendCommaSeparatedValues` extension method. */
  Method getAppendCommaSeparatedValuesMethod() {
    result = this.getAMethod("AppendCommaSeparatedValues")
  }

  /** Gets the `SetCommaSeparatedValues` extension method. */
  Method getSetCommaSeparatedValuesMethod() { result = this.getAMethod("SetCommaSeparatedValues") }
}

/** The `Microsoft.AspNetCore.Http.CookieOptions` class. */
class MicrosoftAspNetCoreHttpCookieOptions extends RefType {
  MicrosoftAspNetCoreHttpCookieOptions() {
    this.hasFullyQualifiedName("Microsoft.AspNetCore.Http", "CookieOptions")
  }
}

/** The `Microsoft.AspNetCore.Http.CookieBuilder` class. */
class MicrosoftAspNetCoreHttpCookieBuilder extends RefType {
  MicrosoftAspNetCoreHttpCookieBuilder() {
    this.hasFullyQualifiedName("Microsoft.AspNetCore.Http", "CookieBuilder")
  }
}

/** The `Microsoft.AspNetCore.Builder.CookiePolicyOptions` class. */
class MicrosoftAspNetCoreBuilderCookiePolicyOptions extends RefType {
  MicrosoftAspNetCoreBuilderCookiePolicyOptions() {
    this.hasFullyQualifiedName("Microsoft.AspNetCore.Builder", "CookiePolicyOptions")
  }
}

/** The `Microsoft.AspNetCore.CookiePolicy.AppendCookieContext` class. */
class MicrosoftAspNetCoreCookiePolicyAppendCookieContext extends RefType {
  MicrosoftAspNetCoreCookiePolicyAppendCookieContext() {
    this.hasFullyQualifiedName("Microsoft.AspNetCore.CookiePolicy", "AppendCookieContext")
  }
}

/** The `Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions` class. */
class MicrosoftAspNetCoreAuthenticationCookiesCookieAuthenticationOptions extends RefType {
  MicrosoftAspNetCoreAuthenticationCookiesCookieAuthenticationOptions() {
    this.hasFullyQualifiedName("Microsoft.AspNetCore.Authentication.Cookies",
      "CookieAuthenticationOptions")
  }
}

/** The `Microsoft.AspNetCore.Builder.CookiePolicyAppBuilderExtensions` class. */
class MicrosoftAspNetCoreBuilderCookiePolicyAppBuilderExtensions extends RefType {
  MicrosoftAspNetCoreBuilderCookiePolicyAppBuilderExtensions() {
    this.hasFullyQualifiedName("Microsoft.AspNetCore.Builder", "CookiePolicyAppBuilderExtensions")
  }

  /** Gets the `UseCookiePolicy` extension method. */
  Method getUseCookiePolicyMethod() { result = this.getAMethod("UseCookiePolicy") }
}

/**
 * The `Microsoft.AspNetCore.Html.HtmlString` class, supposed to wrap HTML-encoded string in ASP.NET Core
 * Untrusted and unsanitized data should never flow there.
 */
class MicrosoftAspNetCoreHttpHtmlString extends Class {
  MicrosoftAspNetCoreHttpHtmlString() {
    this.hasFullyQualifiedName("Microsoft.AspNetCore.Html", "HtmlString")
  }
}

/**
 * The `Microsoft.AspNetCore.Builder.EndpointRouteBuilderExtensions` class.
 */
class MicrosoftAspNetCoreBuilderEndpointRouteBuilderExtensions extends Class {
  MicrosoftAspNetCoreBuilderEndpointRouteBuilderExtensions() {
    this.hasFullyQualifiedName("Microsoft.AspNetCore.Builder", "EndpointRouteBuilderExtensions")
  }

  /** Gets the `Map` extension method. */
  Method getMapMethod() { result = this.getAMethod("Map") }

  /** Gets the `MapGet` extension method. */
  Method getMapGetMethod() { result = this.getAMethod("MapGet") }

  /** Gets the `MapPost` extension method. */
  Method getMapPostMethod() { result = this.getAMethod("MapPost") }

  /** Gets the `MapPut` extension method. */
  Method getMapPutMethod() { result = this.getAMethod("MapPut") }

  /** Gets the `MapDelete` extension method. */
  Method getMapDeleteMethod() { result = this.getAMethod("MapDelete") }

  /** Get a `Map` like extension methods. */
  Method getAMapMethod() {
    result =
      [
        this.getMapMethod(), this.getMapGetMethod(), this.getMapPostMethod(),
        this.getMapPutMethod(), this.getMapDeleteMethod()
      ]
  }
}
