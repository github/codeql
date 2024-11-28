/** Provides classes for working with `Microsoft.AspNetCore.Components`. */

import csharp
import semmle.code.csharp.frameworks.Microsoft
import semmle.code.csharp.frameworks.microsoft.AspNetCore
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate as DataFlowPrivate

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

  /**
   * Gets a route parameter from the `Microsoft.AspNetCore.Components.RouteAttribute` of the component.
   *
   * A route parameter is defined in the URL by wrapping its name in a pair of { braces } when adding a component's @page declaration.
   * There are various extensions that can be added next to the parameter name, such as `:int` or `?` to make the parameter optional.
   * Optionally, the parameter name can start with a `*` to make it a catch-all parameter.
   *
   * And example of a route parameter is `@page "/counter/{id:int}/{other?}/{*rest}"`, from this we're getting the `id`, `other` and `rest` parameters.
   */
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

  /**
   * Holds for matching `RenderTreeBuilder.OpenComponent<>` and `RenderTreeBuilder.CloseComponent` calls with index `openCallIndex` and `closeCallIndex` respectively
   * within the `enclosing` enclosing callabale. The `component` is the type of the component that is being opened and closed.
   */
  private predicate hasSubComponent(
    MethodCall openCall, int openCallIndex, MethodCall closeCall, int closeCallIndex,
    Component component, Callable enclosing
  ) {
    openCall.getEnclosingCallable+() = this.getAMethod("BuildRenderTree") and
    openCall.getEnclosingCallable() = enclosing and
    // TODO: there's another overload of OpenComponent
    openCall = this.getRenderTreeBuilderCall(openCallIndex, "OpenComponent`1", enclosing) and
    openCall.getTarget().(ConstructedGeneric).getTypeArgument(0) = component and
    closeCall = this.getCloseComponentCall(closeCallIndex, enclosing) and
    closeCallIndex > openCallIndex and
    not exists(int k, MethodCall mc |
      k in [openCallIndex + 1 .. closeCallIndex - 1] and
      mc = this.getCloseComponentCall(k, enclosing)
    )
  }

  /**
   * Holds for expressions that are assigned to component parameters. `value` is assigned in `addCall` to a property `p` in component `component`.
   */
  predicate hasAddComponentParameter(MethodCall addCall, Component component, Property p, Expr value) {
    exists(int i, int j, int k, MethodCall openCall, Callable enclosing |
      this.hasSubComponent(openCall, i, _, j, component, enclosing) and
      p = component.getABaseType*().getAProperty() and
      // The below doesn't work for InputText, probably due to some extraction issue:
      // p.getAnAttribute().getType() instanceof ParameterAttributeClass and
      k in [i + 1 .. j - 1] and
      addCall = this.getRenderTreeBuilderCall(k, "AddComponentParameter", enclosing) and
      p.getName() = addCall.getArgument(1).getValue() and
      value = addCall.getArgument(2)
    )
  }

  /**
   * Holds for expressions that are assigned to component parameters. The expression is stripped from the `TypeCheck` call and the optional boxing.
   * The assignment happens in `addCall`, which is a call to `Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder.AddComponentParameter`.
   * The assigned parameter is property `p` in component `component`.
   */
  predicate hasPropertySetOnSubComponent(
    MethodCall addCall, Component component, Property p, Expr value
  ) {
    this.hasAddComponentParameter(addCall, component, p, _) and
    value = stripFluffFromAssignedComponentPropertyValue(addCall, p, _)
  }

  /**
   * Gets a method call to an instance of `Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder`.
   */
  private MethodCall getRenderTreeBuilderCall(int index, string name, Callable enclosing) {
    result.getEnclosingCallable() = enclosing and
    result.getParent().getIndex() = index and
    result
        .getTarget()
        .getUnboundDeclaration()
        .hasFullyQualifiedName("Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder", name)
  }

  /**
   * Gets a method call to `Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder.CloseComponent`.
   */
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

// This is an approximation of the data flow that happens when `@bind-Value` is used on an `Microsoft.AspNetCore.Components.Forms.InputBase` component.
// Some caveats are listed below in the TODO section.
// Another way of modeling this would be to create a jump from the `"Value"` to the `"ValueChanged"` in the `AddComponentParameter` calls.
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

// Jump
// from `@InputValue1` in `<InputText Value="@InputValue1" />`
// to any property read of `InputValue1` inside the declaring component.
private class ComponentPropertyAssignmentJumpNode extends DataFlow::NonLocalJumpNode {
  Property p;
  MethodCall mc;

  ComponentPropertyAssignmentJumpNode() {
    any(Component c).hasAddComponentParameter(mc, _, p, _) and
    this.(DataFlowPrivate::PostUpdateNode).getPreUpdateNode().asExpr() = mc.getArgument(1)
  }

  override DataFlow::Node getAJumpSuccessor(boolean preservesValue) {
    preservesValue = false and
    Helpers::isComponentParameterRead(result.asExpr(), p)
  }
}

/**
 * Gets an expression that is assigned to a component property. The expression is stripped from the `TypeCheck` call and the optional boxing.
 */
private Expr stripFluffFromAssignedComponentPropertyValue(
  MethodCall mc, Property p, Expr assignedExpr
) {
  exists(Expr typeCheckCall |
    any(Component c).hasAddComponentParameter(mc, _, p, assignedExpr) and
    (
      if assignedExpr.(CastExpr).getTargetType().hasFullyQualifiedName("System", "Object")
      then typeCheckCall = assignedExpr.(CastExpr).getExpr()
      else typeCheckCall = assignedExpr
    ) and
    (
      if
        typeCheckCall
            .(MethodCall)
            .getTarget()
            .getUnboundDeclaration()
            .hasFullyQualifiedName("Microsoft.AspNetCore.Components.CompilerServices.RuntimeHelpers",
              "TypeCheck`1")
      then result = typeCheckCall.(MethodCall).getArgument(0)
      else result = typeCheckCall
    )
  )
}

module Helpers {
  /**
   * Holds for expressions that are the qualifier of an `EventCallback.InvokeAsync` call, where the event callback is a `[Parameter]` of a component.
   */
  predicate isComponentEventCallbackInvokeQualifier(Expr qualifier, Property parameterProperty) {
    exists(MethodCall mc |
      mc.getQualifier() = qualifier and
      mc.getTarget()
          .getUnboundDeclaration()
          .hasFullyQualifiedName("Microsoft.AspNetCore.Components.EventCallback`1", "InvokeAsync") and
      parameterProperty = mc.getQualifier().(PropertyAccess).getTarget() and
      parameterProperty.getAnAttribute().getType() instanceof ParameterAttributeClass and
      mc.getQualifier().(PropertyAccess).hasThisQualifier()
    )
  }

  /**
   * Holds for property reads inside a component. The read property needs to be assigned at least in one other component.
   */
  predicate isComponentParameterRead(PropertyRead read, Property p) {
    any(Component c).hasAddComponentParameter(_, _, p, _) and
    read.getTarget() = p and
    read.hasThisQualifier()
    // todo: should we limit this to property reads that happen inside the `BuildRenderTree`?
  }

  /**
   * Holds for expressions that are assigned to non-callback component parameters. The expression is stripped from the `TypeCheck` call and the optional boxing.
   */
  predicate isInflowSource(MethodCall addComponentParameter, Expr expr) {
    exists(Property p |
      any(Component c).hasPropertySetOnSubComponent(addComponentParameter, _, p, expr) and
      not p.getType()
          .getUnboundDeclaration()
          .hasFullyQualifiedName("Microsoft.AspNetCore.Components", "EventCallback`1")
    )
  }

  /**
   * Holds for parameters of event callbacks.
   */
  predicate isOutflowSource(MethodCall addComponentParameter, Parameter eventCallbackParameter) {
    exists(
      Property eventCallbackProperty, MethodCall eventCallbackFactoryCreate,
      Expr eventCallbackFactoryCreateArg
    |
      any(Component c).hasAddComponentParameter(addComponentParameter, _, eventCallbackProperty, _) and
      eventCallbackFactoryCreate =
        stripFluffFromAssignedComponentPropertyValue(addComponentParameter, eventCallbackProperty, _) and
      eventCallbackProperty
          .getType()
          .getUnboundDeclaration()
          .hasFullyQualifiedName("Microsoft.AspNetCore.Components", "EventCallback`1") and
      eventCallbackFactoryCreate
          .getTarget()
          .getUnboundDeclaration()
          .hasFullyQualifiedName("Microsoft.AspNetCore.Components.EventCallbackFactory", "Create`1") and
      eventCallbackFactoryCreateArg = eventCallbackFactoryCreate.getArgument(1) and
      (
        eventCallbackParameter =
          eventCallbackFactoryCreateArg
              .(DelegateCreation)
              .getArgument()
              .(CallableAccess)
              .getTarget()
              .getParameter(0)
        or
        eventCallbackParameter = eventCallbackFactoryCreateArg.(LambdaExpr).getParameter(0)
      )
    )
  }
}

// Jump
// from `Param1Changed` in `Param1Changed.InvokeAsync(...)`
// to `"Param1Changed"` in `__builder.AddComponentParameter(133, "Param1Changed", ...)`
private class ComponentEventCallbackJumpNode extends DataFlow::NonLocalJumpNode {
  Property p;

  ComponentEventCallbackJumpNode() {
    Helpers::isComponentEventCallbackInvokeQualifier(this.(DataFlowPrivate::PostUpdateNode)
          .getPreUpdateNode()
          .asExpr(), p)
  }

  override DataFlow::Node getAJumpSuccessor(boolean preservesValue) {
    preservesValue = false and
    exists(MethodCall addComponentParameter |
      any(Component c).hasAddComponentParameter(addComponentParameter, p.getDeclaringType(), p, _) and
      result.asExpr() = addComponentParameter.getArgument(1)
    )
  }
}

// Jump
// from `"Param1Changed"` in `__builder.AddComponentParameter(133, "Param1Changed", TypeCheck<>(EventCallback.Factory.Create<>(this, (s) => {})))`
// to `s` in `(s) => {}`
private class ComponentEventCallbackJumpNode2 extends DataFlow::NonLocalJumpNode {
  Property p;
  MethodCall addComponentParameter;

  ComponentEventCallbackJumpNode2() {
    any(Component c).hasAddComponentParameter(addComponentParameter, p.getDeclaringType(), p, _) and
    this.asExpr() = addComponentParameter.getArgument(1) and
    Helpers::isComponentEventCallbackInvokeQualifier(_, p)
  }

  override DataFlow::Node getAJumpSuccessor(boolean preservesValue) {
    preservesValue = false and
    Helpers::isOutflowSource(addComponentParameter, result.asParameter())
  }
}
