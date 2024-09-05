/** Provides classes for working with `Microsoft.AspNetCore.Components`. */

import csharp
import semmle.code.csharp.frameworks.Microsoft
import semmle.code.csharp.frameworks.microsoft.AspNetCore

/** The `Microsoft.AspNetCore.Components` namespace. */
class MicrosoftAspNetCoreComponentsNamespace extends Namespace {
  MicrosoftAspNetCoreComponentsNamespace() {
    this.getParentNamespace() instanceof MicrosoftAspNetCoreNamespace and
    this.hasName("Components")
  }
}

/** A class in the `Microsoft.AspNetCore.Components` namespace. */
class MicrosoftAspNetCoreComponentsClass extends Class {
  MicrosoftAspNetCoreComponentsClass() {
    this.getNamespace() instanceof MicrosoftAspNetCoreComponentsNamespace
  }
}

/** An interface in the `Microsoft.AspNetCore.Components` namespace. */
class MicrosoftAspNetCoreComponentsInterface extends Interface {
  MicrosoftAspNetCoreComponentsInterface() {
    this.getNamespace() instanceof MicrosoftAspNetCoreComponentsNamespace
  }
}

/** The `Microsoft.AspNetCore.Components.SupplyParameterFromQueryAttribute` class. */
class SupplyParameterFromQueryAttributeClass extends MicrosoftAspNetCoreComponentsClass {
  SupplyParameterFromQueryAttributeClass() { this.hasName("SupplyParameterFromQueryAttribute") }
}

/** The `Microsoft.AspNetCore.Components.ParameterAttribute` class. */
class ParameterAttributeClass extends MicrosoftAspNetCoreComponentsClass {
  ParameterAttributeClass() { this.hasName("ParameterAttribute") }
}

/** The `Microsoft.AspNetCore.Components.CascadingParameterAttributeBase` class. */
class CascadingParameterAttributeBaseClass extends MicrosoftAspNetCoreComponentsClass {
  CascadingParameterAttributeBaseClass() { this.hasName("CascadingParameterAttributeBase") }
}

/** The `Microsoft.AspNetCore.Components.ComponentBase` class. */
class ComponentBaseClass extends MicrosoftAspNetCoreComponentsClass {
  ComponentBaseClass() { this.hasName("ComponentBase") }
}

/** The `Microsoft.AspNetCore.Components.IComponent` interface. */
class IComponentInterface extends MicrosoftAspNetCoreComponentsInterface {
  IComponentInterface() { this.hasName("IComponent") }
}

/** An ASP.NET Core (Blazor) component. */
class Component extends Class {
  Component() {
    this.getABaseType+() instanceof ComponentBaseClass or
    this.getABaseType+() instanceof IComponentInterface
  }

  /** Gets a property whose value cascades down the component hierarchy. */
  Property getACascadingParameterProperty() {
    result = this.getAProperty() and
    result.getAnAttribute().getType().getBaseClass() instanceof CascadingParameterAttributeBaseClass
  }

  private string getRouteAttributeUrl() {
    exists(Attribute a |
      a = this.getAnAttribute() and
      a.getType().hasFullyQualifiedName("Microsoft.AspNetCore.Components", "RouteAttribute") and
      result = a.getArgument(0).getValue()
    )
  }

  private string getARouteParameter() {
    result = this.getRouteAttributeUrl().splitAt("{").regexpCapture("\\*?([^:?}]+)[:?}](.*)", 1)
  }

  /** Gets a property whose value is populated from route parameters. */
  Property getARouteParameterProperty() {
    exists(string urlParamName |
      urlParamName = this.getARouteParameter() and
      result = this.getAProperty() and
      result.getName().toLowerCase() = urlParamName.toLowerCase() and
      result.getAnAttribute().getType() instanceof ParameterAttributeClass
    )
  }
}
