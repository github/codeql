/** Provides classes for working with `Microsoft.AspNetCore.Components` */

import csharp
import semmle.code.csharp.frameworks.Microsoft
import semmle.code.csharp.frameworks.microsoft.AspNetCore

/** The `Microsoft.AspNetCore.Components` namespace */
class MicrosoftAspNetCoreComponentsNamespace extends Namespace {
  MicrosoftAspNetCoreComponentsNamespace() {
    this.getParentNamespace() instanceof MicrosoftAspNetCoreNamespace and
    this.hasName("Components")
  }
}

/**
 * A class in the `Microsoft.AspNetCore.Components` namespace.
 */
private class MicrosoftAspNetCoreComponentsClass extends Class {
  MicrosoftAspNetCoreComponentsClass() {
    this.getNamespace() instanceof MicrosoftAspNetCoreComponentsNamespace
  }
}

/** The `Microsoft.AspNetCore.Components.CascadingParameterAttributeBase` class. */
class MicrosoftAspNetCoreComponentsCascadingParameterAttributeBaseClass extends MicrosoftAspNetCoreComponentsClass
{
  MicrosoftAspNetCoreComponentsCascadingParameterAttributeBaseClass() {
    this.hasName("CascadingParameterAttributeBase")
  }
}

/** The `Microsoft.AspNetCore.Components.ComponentBase` class. */
class MicrosoftAspNetCoreComponentsComponentBaseClass extends MicrosoftAspNetCoreComponentsClass {
  MicrosoftAspNetCoreComponentsComponentBaseClass() { this.hasName("ComponentBase") }
}

/** The `Microsoft.AspNetCore.Components.IComponent` interface. */
class MicrosoftAspNetCoreComponentsIComponentInterface extends Interface {
  MicrosoftAspNetCoreComponentsIComponentInterface() {
    this.getNamespace() instanceof MicrosoftAspNetCoreComponentsNamespace and
    this.hasName("IComponent")
  }
}

/** The `Microsoft.AspNetCore.Components.RouteAttribute` attribute. */
private class MicrosoftAspNetCoreComponentsRouteAttribute extends Attribute {
  MicrosoftAspNetCoreComponentsRouteAttribute() {
    this.getType().getNamespace() instanceof MicrosoftAspNetCoreComponentsNamespace and
    this.getType().hasName("RouteAttribute")
  }
}

/** The `Microsoft.AspNetCore.Components.ParameterAttribute` attribute. */
private class MicrosoftAspNetCoreComponentsParameterAttribute extends Attribute {
  MicrosoftAspNetCoreComponentsParameterAttribute() {
    this.getType().getNamespace() instanceof MicrosoftAspNetCoreComponentsNamespace and
    this.getType().hasName("ParameterAttribute")
  }
}

/** An ASP.NET Core (Blazor) component. */
class MicrosoftAspNetCoreComponentsComponent extends Class {
  MicrosoftAspNetCoreComponentsComponent() {
    this.getABaseType+() instanceof MicrosoftAspNetCoreComponentsComponentBaseClass or
    this.getABaseType+() instanceof MicrosoftAspNetCoreComponentsIComponentInterface
  }

  /** Gets a property whose value cascades down the component hierarchy. */
  Property getACascadingParameterProperty() {
    result = this.getAProperty() and
    result.getAnAttribute().getType().getBaseClass() instanceof
      MicrosoftAspNetCoreComponentsCascadingParameterAttributeBaseClass
  }

  /** Gets the url for the route from the `Microsoft.AspNetCore.Components.RouteAttribute` of the component. */
  private string getRouteAttributeUrl() {
    exists(MicrosoftAspNetCoreComponentsRouteAttribute a | a = this.getAnAttribute() |
      result = a.getArgument(0).getValue()
    )
  }

  /**
   * Gets a route parameter from the `Microsoft.AspNetCore.Components.RouteAttribute` of the component.
   *
   * A route parameter is defined in the URL by wrapping its name in a pair of { braces } when adding a component's @page declaration.
   * There are various extensions that can be added next to the parameter name, such as `:int` or `?` to make the parameter optional.
   * Optionally, the parameter name can start with a `*` to make it a catch-all parameter.
   *
   * An example of a route parameter is `@page "/counter/{id:int}/{other?}/{*rest}"`, from this we're getting the `id`, `other` and `rest` parameters.
   */
  pragma[nomagic]
  private string getARouteParameter() {
    exists(string s |
      s = this.getRouteAttributeUrl().splitAt("{").regexpCapture("\\*?([^:?}]+)[:?}](.*)", 1) and
      result = s.toLowerCase()
    )
  }

  /** Gets a property attributed with `[Parameter]` attribute. */
  pragma[nomagic]
  private Property getAParameterProperty(string name) {
    result = this.getAProperty() and
    result.getAnAttribute() instanceof MicrosoftAspNetCoreComponentsParameterAttribute and
    name = result.getName().toLowerCase()
  }

  /** Gets a property whose value is populated from route parameters. */
  Property getARouteParameterProperty() {
    exists(string name | name = this.getARouteParameter() |
      result = this.getAParameterProperty(name)
    )
  }
}

/**
 * The `Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder::AddComponentParameter` method.
 */
private class MicrosoftAspNetCoreComponentsAddComponentParameterMethod extends Method {
  MicrosoftAspNetCoreComponentsAddComponentParameterMethod() {
    this.hasFullyQualifiedName("Microsoft.AspNetCore.Components.Rendering", "RenderTreeBuilder",
      "AddComponentParameter")
  }
}

private module Sources {
  private import semmle.code.csharp.security.dataflow.flowsources.Remote

  /**
   * A property with a `[Parameter]` attribute in an ASP.NET Core component which
   * is populated from a route parameter.
   */
  private class AspNetCoreComponentRouteParameterFlowSource extends AspNetRemoteFlowSource,
    DataFlow::ExprNode
  {
    AspNetCoreComponentRouteParameterFlowSource() {
      exists(MicrosoftAspNetCoreComponentsComponent c, Property p |
        p = c.getARouteParameterProperty()
      |
        this.asExpr() = p.getGetter().getACall()
      )
    }

    override string getSourceType() { result = "ASP.NET Core component route parameter" }
  }
}

private module JumpNodes {
  /**
   * A call to `Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder::AddComponentParameter` which
   * sets the value of a parameter.
   */
  private class ParameterPassingCall extends Call {
    ParameterPassingCall() {
      this.getTarget() instanceof MicrosoftAspNetCoreComponentsAddComponentParameterMethod
    }

    /**
     * Gets the property whose value is being set.
     */
    Property getParameterProperty() {
      result.getAnAttribute() instanceof MicrosoftAspNetCoreComponentsParameterAttribute and
      (
        exists(NameOfExpr ne | ne = this.getArgument(1) | result.getAnAccess() = ne.getAccess())
        or
        exists(string propertyName | propertyName = this.getArgument(1).(StringLiteral).getValue() |
          result.hasName(propertyName)
        )
      )
    }

    /**
     * Gets the value being set.
     */
    Expr getParameterValue() { result = this.getArgument(2) }
  }

  private class ComponentParameterJump extends DataFlow::NonLocalJumpNode {
    Property prop;

    ComponentParameterJump() {
      exists(ParameterPassingCall call |
        prop = call.getParameterProperty() and
        this.asExpr() = call.getParameterValue()
      )
    }

    override DataFlow::Node getAJumpSuccessor(boolean preservesValue) {
      preservesValue = true and
      result.asExpr() = prop.getAnAccess()
    }
  }
}
