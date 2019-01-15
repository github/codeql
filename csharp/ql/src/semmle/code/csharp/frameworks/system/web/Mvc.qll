/** Provides definitions related to the namespace `System.Web.Mvc`. */

import csharp
private import semmle.code.csharp.frameworks.system.Web

/** The `System.Web.Mvc` namespace. */
class SystemWebMvcNamespace extends Namespace {
  SystemWebMvcNamespace() {
    getParentNamespace() instanceof SystemWebNamespace and
    hasName("Mvc")
  }
}

/** A class in the `System.Web.Mvc` namespace. */
class SystemWebMvcClass extends Class {
  SystemWebMvcClass() { this.getNamespace() instanceof SystemWebMvcNamespace }
}

/** An interface in the `System.Web.Mvc` namespace. */
class SystemWebMvcInterface extends Interface {
  SystemWebMvcInterface() { this.getNamespace() instanceof SystemWebMvcNamespace }
}

/** The `System.Web.Mvc.HtmlHelper` class. */
class SystemWebMvcHtmlHelperClass extends SystemWebMvcClass {
  SystemWebMvcHtmlHelperClass() { this.hasName("HtmlHelper") }

  /** Gets the `Raw` method. */
  Method getRawMethod() { result = this.getAMethod("Raw") }
}

/** An attribute whose type is in the `System.Web.Mvc` namespace. */
class SystemWebMvcAttribute extends Attribute {
  SystemWebMvcAttribute() { getType().getNamespace() instanceof SystemWebMvcNamespace }
}

/** An attribute whose type is `System.Web.Mvc.HttpPost`. */
class HttpPostAttribute extends SystemWebMvcAttribute {
  HttpPostAttribute() { this.getType().hasName("HttpPostAttribute") }
}

/** An attribute whose type is `System.Web.Mvc.NonAction`. */
class NonActionAttribute extends SystemWebMvcAttribute {
  NonActionAttribute() { this.getType().hasName("NonActionAttribute") }
}

/**
 * An attribute whose type has a name like `ValidateAntiForgeryTokenAttribute`.
 */
class ValidateAntiForgeryTokenAttribute extends Attribute {
  ValidateAntiForgeryTokenAttribute() {
    this.getType().getName().matches("Validate%AntiForgeryTokenAttribute")
  }
}

/** The `System.Web.Mvc.UrlHelper` class. */
class SystemWebMvcUrlHelperClass extends SystemWebMvcClass {
  SystemWebMvcUrlHelperClass() { this.hasName("UrlHelper") }

  /** Gets the `IsLocalUrl` method. */
  Method getIsLocalUrl() { result = this.getAMethod("IsLocalUrl") }
}

/** The `System.Web.Mvc.Controller` class. */
class SystemWebMvcControllerClass extends SystemWebMvcClass {
  SystemWebMvcControllerClass() { this.hasName("Controller") }

  /** Gets a `Redirect..` method. */
  Method getARedirectMethod() {
    result = this.getAMethod() and
    result.getName().matches("Redirect%")
  }
}

/** A subtype of `System.Web.Mvc.Controller`. */
class Controller extends Class {
  Controller() { this.getABaseType*() instanceof SystemWebMvcControllerClass }

  /**
   * Gets an "action" method, which may be called by the MVC framework in response to a user
   * request.
   */
  Method getAnActionMethod() {
    result = this.getAMethod() and
    // Any public instance method.
    result.isPublic() and
    not result.isStatic() and
    not result.getAnAttribute() instanceof NonActionAttribute
  }

  /**
   * Gets an "action" method handling POST request, which may be called by the MVC framework in
   * response to a user request.
   */
  Method getAPostActionMethod() {
    result = this.getAnActionMethod() and
    result.getAnAttribute() instanceof HttpPostAttribute
  }
}

/** A subtype of `System.Web.Mvc.IAuthorizationFilter`. */
class AuthorizationFilter extends Class {
  AuthorizationFilter() {
    this.getABaseType*().(SystemWebMvcInterface).hasName("IAuthorizationFilter")
  }

  /** Gets the `OnAuthorization` method provided by this filter. */
  Method getOnAuthorizationMethod() { result = this.getAMethod("OnAuthorization") }
}

/** The `System.Web.Mvc.GlobalFilterCollection` class. */
class GlobalFilterCollection extends SystemWebMvcClass {
  GlobalFilterCollection() { this.hasName("GlobalFilterCollection") }

  /** Gets the `Add` method. */
  Method getAddMethod() { result = this.getAMethod("Add") }
}

/** The `System.Web.Mvc.MvcHtmlString` class. */
class SystemWebMvcMvcHtmlString extends SystemWebMvcClass {
  SystemWebMvcMvcHtmlString() { this.hasName("MvcHtmlString") }
}
