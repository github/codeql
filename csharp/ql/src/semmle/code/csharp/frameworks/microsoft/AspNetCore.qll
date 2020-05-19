/** Provides classes for working with `Microsoft.AspNetCore.Mvc`. */

import csharp
import semmle.code.csharp.frameworks.Microsoft

/** The `Microsoft.AspNetCore` namespace. */
class MicrosoftAspNetCoreNamespace extends Namespace {
  MicrosoftAspNetCoreNamespace() {
    getParentNamespace() instanceof MicrosoftNamespace and
    hasName("AspNetCore")
  }
}

/** The `Microsoft.AspNetCore.Mvc` namespace. */
class MicrosoftAspNetCoreMvcNamespace extends Namespace {
  MicrosoftAspNetCoreMvcNamespace() {
    getParentNamespace() instanceof MicrosoftAspNetCoreNamespace and
    hasName("Mvc")
  }
}

/** The 'Microsoft.AspNetCore.Mvc.ViewFeatures' namespace. */
class MicrosoftAspNetCoreMvcViewFeatures extends Namespace {
  MicrosoftAspNetCoreMvcViewFeatures() {
    getParentNamespace() instanceof MicrosoftAspNetCoreMvcNamespace and
    hasName("ViewFeatures")
  }
}

/** The 'Microsoft.AspNetCore.Mvc.Rendering' namespace. */
class MicrosoftAspNetCoreMvcRendering extends Namespace {
  MicrosoftAspNetCoreMvcRendering() {
    getParentNamespace() instanceof MicrosoftAspNetCoreMvcNamespace and
    hasName("Rendering")
  }
}

/** An attribute whose type is in the `Microsoft.AspNetCore.Mvc` namespace. */
class MicrosoftAspNetCoreMvcAttribute extends Attribute {
  MicrosoftAspNetCoreMvcAttribute() {
    getType().getNamespace() instanceof MicrosoftAspNetCoreMvcNamespace
  }
}

/** A `Microsoft.AspNetCore.Mvc.HttpPost` attribute. */
class MicrosoftAspNetCoreMvcHttpPostAttribute extends MicrosoftAspNetCoreMvcAttribute {
  MicrosoftAspNetCoreMvcHttpPostAttribute() { getType().hasName("HttpPostAttribute") }
}

/** A `Microsoft.AspNetCore.Mvc.HttpPut` attribute. */
class MicrosoftAspNetCoreMvcHttpPutAttribute extends MicrosoftAspNetCoreMvcAttribute {
  MicrosoftAspNetCoreMvcHttpPutAttribute() { getType().hasName("HttpPutAttribute") }
}

/** A `Microsoft.AspNetCore.Mvc.HttpDelete` attribute. */
class MicrosoftAspNetCoreMvcHttpDeleteAttribute extends MicrosoftAspNetCoreMvcAttribute {
  MicrosoftAspNetCoreMvcHttpDeleteAttribute() { getType().hasName("HttpDeleteAttribute") }
}

/** A `Microsoft.AspNetCore.Mvc.NonAction` attribute. */
class MicrosoftAspNetCoreMvcNonActionAttribute extends MicrosoftAspNetCoreMvcAttribute {
  MicrosoftAspNetCoreMvcNonActionAttribute() { getType().hasName("NonActionAttribute") }
}

/** The `Microsoft.AspNetCore.Antiforgery` namespace. */
class MicrosoftAspNetCoreAntiforgeryNamespace extends Namespace {
  MicrosoftAspNetCoreAntiforgeryNamespace() {
    getParentNamespace() instanceof MicrosoftAspNetCoreNamespace and
    hasName("Antiforgery")
  }
}

/** The `Microsoft.AspNetCore.Mvc.Filters` namespace. */
class MicrosoftAspNetCoreMvcFilters extends Namespace {
  MicrosoftAspNetCoreMvcFilters() {
    getParentNamespace() instanceof MicrosoftAspNetCoreMvcNamespace and
    hasName("Filters")
  }
}

/** The `Microsoft.AspNetCore.Mvc.Filters.IFilterMetadataInterface` interface. */
class MicrosoftAspNetCoreMvcIFilterMetadataInterface extends Interface {
  MicrosoftAspNetCoreMvcIFilterMetadataInterface() {
    getNamespace() instanceof MicrosoftAspNetCoreMvcFilters and
    hasName("IFilterMetadata")
  }
}

/** The `Microsoft.AspNetCore.IAuthorizationFilter` interface. */
class MicrosoftAspNetCoreIAuthorizationFilterInterface extends Interface {
  MicrosoftAspNetCoreIAuthorizationFilterInterface() {
    getNamespace() instanceof MicrosoftAspNetCoreMvcFilters and
    hasName("IAsyncAuthorizationFilter")
  }

  /** Gets the `OnAuthorizationAsync` method. */
  Method getOnAuthorizationMethod() { result = getAMethod("OnAuthorizationAsync") }
}

/** The `Microsoft.AspNetCore.IAntiforgery` interface. */
class MicrosoftAspNetCoreIAntiForgeryInterface extends Interface {
  MicrosoftAspNetCoreIAntiForgeryInterface() {
    getNamespace() instanceof MicrosoftAspNetCoreAntiforgeryNamespace and
    hasName("IAntiforgery")
  }

  /** Gets the `ValidateRequestAsync` method. */
  Method getValidateMethod() { result = getAMethod("ValidateRequestAsync") }
}

/** The `Microsoft.AspNetCore.DefaultAntiForgery` class, or another user-supplied class that implements `IAntiForgery`. */
class AntiForgeryClass extends Class {
  AntiForgeryClass() { getABaseInterface*() instanceof MicrosoftAspNetCoreIAntiForgeryInterface }

  /** Gets the `ValidateRequestAsync` method. */
  Method getValidateMethod() { result = getAMethod("ValidateRequestAsync") }
}

/** An authorization filter class defined by AspNetCore or the user. */
class AuthorizationFilterClass extends Class {
  AuthorizationFilterClass() {
    getABaseInterface*() instanceof MicrosoftAspNetCoreIAuthorizationFilterInterface
  }

  /** Gets the `OnAuthorization` method provided by this filter. */
  Method getOnAuthorizationMethod() { result = getAMethod("OnAuthorizationAsync") }
}

/** An attribute whose type has a name like `[Auto...]Validate[...]Anti[Ff]orgery[...Token]Attribute`. */
class ValidateAntiForgeryAttribute extends Attribute {
  ValidateAntiForgeryAttribute() { getType().getName().matches("%Validate%Anti_orgery%Attribute") }
}

/**
 * A class that has a name like `[Auto...]Validate[...]Anti[Ff]orgery[...Token]` and implements `IFilterMetadata` interface
 * This class can be added to a collection of global `MvcOptions.Filters` collection.
 */
class ValidateAntiforgeryTokenAuthorizationFilter extends Class {
  ValidateAntiforgeryTokenAuthorizationFilter() {
    getABaseInterface*() instanceof MicrosoftAspNetCoreMvcIFilterMetadataInterface and
    getName().matches("%Validate%Anti_orgery%")
  }
}

/** The `Microsoft.AspNetCore.Mvc.Filters.FilterCollection` class. */
class MicrosoftAspNetCoreMvcFilterCollection extends Class {
  MicrosoftAspNetCoreMvcFilterCollection() {
    getNamespace() instanceof MicrosoftAspNetCoreMvcFilters and
    hasName("FilterCollection")
  }

  /** Gets an `Add` method. */
  Method getAddMethod() {
    result = getAMethod("Add") or
    result = getABaseType().getAMethod("Add")
  }
}

/** The `Microsoft.AspNetCore.Mvc.MvcOptions` class. */
class MicrosoftAspNetCoreMvcOptions extends Class {
  MicrosoftAspNetCoreMvcOptions() {
    getNamespace() instanceof MicrosoftAspNetCoreMvcNamespace and
    hasName("MvcOptions")
  }

  /** Gets the `Filters` property. */
  Property getFilterCollectionProperty() { result = getProperty("Filters") }
}

/** The base class for controllers in MVC, i.e. `Microsoft.AspNetCore.Mvc.Controller` or `Microsoft.AspNetCore.Mvc.ControllerBase` class. */
class MicrosoftAspNetCoreMvcControllerBaseClass extends Class {
  MicrosoftAspNetCoreMvcControllerBaseClass() {
    getNamespace() instanceof MicrosoftAspNetCoreMvcNamespace and
    (
      hasName("Controller") or
      hasName("ControllerBase")
    )
  }
}

/** A subtype of `Microsoft.AspNetCore.Mvc.Controller` or `Microsoft.AspNetCore.Mvc.ControllerBase`. */
class MicrosoftAspNetCoreMvcController extends Class {
  MicrosoftAspNetCoreMvcController() {
    getABaseType*() instanceof MicrosoftAspNetCoreMvcControllerBaseClass
  }

  /** Gets an action method for this controller. */
  Method getAnActionMethod() {
    result = getAMethod() and
    result.isPublic() and
    not result.isStatic() and
    not result.getAnAttribute() instanceof MicrosoftAspNetCoreMvcNonActionAttribute
  }

  /** Gets a `Redirect*` method. */
  Method getARedirectMethod() {
    result = this.getAMethod() and
    result.getName().matches("Redirect%")
  }
}

/** The `Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper` interface. */
class MicrosoftAspNetCoreMvcRenderingIHtmlHelperInterface extends Interface {
  MicrosoftAspNetCoreMvcRenderingIHtmlHelperInterface() {
    getNamespace() instanceof MicrosoftAspNetCoreMvcRendering and
    hasName("IHtmlHelper")
  }

  /** Gets the `Raw` method. */
  Method getRawMethod() { result = getAMethod("Raw") }
}

/** A class deriving from `Microsoft.AspNetCore.Mvc.Razor.RazorPageBase`, implements Razor page in ASPNET Core. */
class MicrosoftAspNetCoreMvcRazorPageBase extends Class {
  MicrosoftAspNetCoreMvcRazorPageBase() {
    this.getABaseType*().hasQualifiedName("Microsoft.AspNetCore.Mvc.Razor", "RazorPageBase")
  }

  /** Gets the `WriteLiteral` method. */
  Method getWriteLiteralMethod() { result = getAMethod("WriteLiteral") }
}

/** A class deriving from `Microsoft.AspNetCore.Http.HttpRequest`, implements `HttpRequest` in ASP.NET Core. */
class MicrosoftAspNetCoreHttpHttpRequest extends Class {
  MicrosoftAspNetCoreHttpHttpRequest() {
    this.getABaseType*().hasQualifiedName("Microsoft.AspNetCore.Http", "HttpRequest")
  }
}

/** A class deriving from `Microsoft.AspNetCore.Http.HttpResponse`, implements `HttpResponse` in ASP.NET Core. */
class MicrosoftAspNetCoreHttpHttpResponse extends Class {
  MicrosoftAspNetCoreHttpHttpResponse() {
    this.getABaseType*().hasQualifiedName("Microsoft.AspNetCore.Http", "HttpResponse")
  }

  /** Gets the `Redirect` method. */
  Method getRedirectMethod() { result = this.getAMethod("Redirect") }

  /** Gets the `Headers` property. */
  Property getHeadersProperty() { result = this.getProperty("Headers") }
}

/** An interface that is a wrapper around the collection of cookies in the response. */
class MicrosoftAspNetCoreHttpResponseCookies extends Interface {
  MicrosoftAspNetCoreHttpResponseCookies() {
    this.hasQualifiedName("Microsoft.AspNetCore.Http.IResponseCookies")
  }

  /** Gets the `Append` method. */
  Method getAppendMethod() { result = this.getAMethod("Append") }
}

/** The class `Microsoft.AspNetCore.Http.QueryString`, holds query string in ASP.NET Core. */
class MicrosoftAspNetCoreHttpQueryString extends Struct {
  MicrosoftAspNetCoreHttpQueryString() {
    this.hasQualifiedName("Microsoft.AspNetCore.Http", "QueryString")
  }
}

/** A class or interface implementing `IQueryCollection`, holds parsed query string in ASP.NET Core. */
class MicrosoftAspNetCoreHttpQueryCollection extends RefType {
  MicrosoftAspNetCoreHttpQueryCollection() {
    this.getABaseInterface().hasQualifiedName("Microsoft.AspNetCore.Http", "IQueryCollection")
  }
}

/** The helper class `ResponseHeaders` for setting headers. */
class MicrosoftAspNetCoreHttpResponseHeaders extends RefType {
  MicrosoftAspNetCoreHttpResponseHeaders() {
    this.hasQualifiedName("Microsoft.AspNetCore.Http.Headers", "ResponseHeaders")
  }

  /** Gets the `Location` property. */
  Property getLocationProperty() { result = this.getProperty("Location") }
}

/** The `Microsoft.AspNetCore.Http.HeaderDictionaryExtensions` class. */
class MicrosoftAspNetCoreHttpHeaderDictionaryExtensions extends RefType {
  MicrosoftAspNetCoreHttpHeaderDictionaryExtensions() {
    this.hasQualifiedName("Microsoft.AspNetCore.Http", "HeaderDictionaryExtensions")
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

/**
 * The `Microsoft.AspNetCore.Html.HtmlString` class, supposed to wrap HTML-encoded string in ASP.NET Core
 * Untrusted and unsanitized data should never flow there.
 */
class MicrosoftAspNetCoreHttpHtmlString extends Class {
  MicrosoftAspNetCoreHttpHtmlString() {
    this.hasQualifiedName("Microsoft.AspNetCore.Html", "HtmlString")
  }
}
