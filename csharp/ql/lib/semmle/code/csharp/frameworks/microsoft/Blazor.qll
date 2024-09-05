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

  private predicate hasSubComponent(
    MethodCall openCall, int openCallIndex, MethodCall closeCall, int closeCallIndex,
    ValueOrRefType componentType, Callable enclosing
  ) {
    openCall.getEnclosingCallable+() = this.getAMethod("BuildRenderTree") and
    openCall.getEnclosingCallable() = enclosing and
    // TODO: there's another overload of OpenComponent
    openCall = this.getRenderTreeBuilderCall(openCallIndex, "OpenComponent`1", enclosing) and
    openCall.getTarget().(ConstructedGeneric).getTypeArgument(0) = componentType and
    closeCall = this.getCloseComponentCall(closeCallIndex, enclosing) and
    closeCallIndex > openCallIndex and
    not exists(int k, MethodCall mc |
      k in [openCallIndex + 1 .. closeCallIndex - 1] and
      mc = this.getCloseComponentCall(k, enclosing)
    )
  }

  predicate hasPropertySetOnSubComponent(
    MethodCall addCall, ValueOrRefType componentType, Property p, Expr value
  ) {
    exists(
      int i, int j, int k, MethodCall openCall, Callable enclosing, Expr cast, Expr typeCheckCall
    |
      this.hasSubComponent(openCall, i, _, j, componentType, enclosing) and
      p = componentType.getABaseType*().getAProperty() and
      // The below doesn't work for InputText:
      // p.getAnAttribute().getType() instanceof ParameterAttributeClass and
      k in [i + 1 .. j - 1] and
      addCall = this.getRenderTreeBuilderCall(k, "AddComponentParameter", enclosing) and
      p.getName() = addCall.getArgument(1).getValue() and
      cast = addCall.getArgument(2) and
      (
        if cast.(CastExpr).getTargetType().hasFullyQualifiedName("System", "Object")
        then typeCheckCall = cast.(CastExpr).getExpr()
        else typeCheckCall = cast
      ) and
      (
        if
          typeCheckCall
              .(MethodCall)
              .getTarget()
              .getUnboundDeclaration()
              .hasFullyQualifiedName("Microsoft.AspNetCore.Components.CompilerServices.RuntimeHelpers",
                "TypeCheck`1")
        then value = typeCheckCall.(MethodCall).getArgument(0)
        else value = typeCheckCall
      )
    )
  }

  private MethodCall getRenderTreeBuilderCall(int index, string name, Callable enclosing) {
    result.getEnclosingCallable() = enclosing and
    result.getParent().getIndex() = index and
    result
        .getTarget()
        .getUnboundDeclaration()
        .hasFullyQualifiedName("Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder", name)
  }

  private MethodCall getCloseComponentCall(int index, Callable enclosing) {
    result = this.getRenderTreeBuilderCall(index, "CloseComponent", enclosing)
  }
}

private AssignableMemberAccess getMemberAccessAssignedToInputValueProperty(
  Component c, AssignableMember member
) {
  exists(ValueOrRefType componentType, Property componentProperty |
    c.hasPropertySetOnSubComponent(_, componentType, componentProperty, result) and
    componentType
        .getBaseClass+()
        .getUnboundDeclaration()
        .hasFullyQualifiedName("Microsoft.AspNetCore.Components.Forms", "InputBase`1") and
    componentProperty.hasName("Value") and
    result.getTarget() = member and
    member.getDeclaringType() = c and
    result.hasThisQualifier()
    // TODO: add support for Prop1.Prop2.Prop3 chains
  )
}

module Sources {
  private import semmle.code.csharp.security.dataflow.flowsources.Remote

  /** A data flow source of remote user input (ASP.NET Core component query string). */
  private class AspNetComponentQueryStringRemoteFlowSource extends AspNetRemoteFlowSource,
    DataFlow::ExprNode
  {
    AspNetComponentQueryStringRemoteFlowSource() {
      exists(Property p |
        p = any(Component c).getACascadingParameterProperty() and
        p.getAnAttribute().getType() instanceof SupplyParameterFromQueryAttributeClass and
        this.getExpr() = p.getGetter().getACall()
      )
    }

    override string getSourceType() { result = "ASP.NET Core component query string" }
  }

  /** A data flow source of remote user input (ASP.NET Core component route parameter). */
  private class AspNetComponentRouteParameterRemoteFlowSource extends AspNetRemoteFlowSource,
    DataFlow::ExprNode
  {
    AspNetComponentRouteParameterRemoteFlowSource() {
      exists(Property p |
        p = any(Component c).getARouteParameterProperty() and
        this.getExpr() = p.getGetter().getACall()
      )
    }

    override string getSourceType() { result = "ASP.NET Core component route parameter" }
  }

  private class AspNetComponentInputBaseValueFlowSource extends AspNetRemoteFlowSource,
    DataFlow::ExprNode
  {
    AspNetComponentInputBaseValueFlowSource() {
      this.getExpr() = getMemberAccessAssignedToInputValueProperty(_, _)
    }

    override string getSourceType() {
      result = "ASP.NET Core `InputBase<>.Value`-bound property read"
    }
  }
}

// TODO: this is only true
// - if there's no custom `ValueChanged` handler defined on the `InputText` component, such as `<InputText Value="@InputValue1" ValueChanged="HandleChange" />` or
// - if `@bind-Value` is used on the component. In case of `<InputText Value="@InputValue1" ValueExpression="@(() => InputValue1)" />`, there's only one way binding.
private class InputBaseValuePropertyJumpNode extends DataFlow::NonLocalJumpNode {
  Component c;
  AssignableMember member;

  InputBaseValuePropertyJumpNode() {
    this.asExpr() = getMemberAccessAssignedToInputValueProperty(c, member)
  }

  override DataFlow::Node getAJumpSuccessor(boolean preservesValue) {
    preservesValue = true and
    exists(MemberAccess access |
      result.asExpr() = access and
      access.getTarget() = member and
      access.hasThisQualifier() and
      access instanceof AssignableRead
    )
  }
}
