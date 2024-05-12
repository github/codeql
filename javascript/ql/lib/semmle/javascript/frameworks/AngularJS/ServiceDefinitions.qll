/**
 * Provides classes for working with the definitions of AngularJS services.
 *
 * Supports registration and lookup of AngularJS services:
 *
 * - dependency injection services, such as `factory` and `provider`
 * - special AngularJS services, such as `filter` and `controller`
 *
 * INTERNAL: Do not import this module directly, import `AngularJS` instead.
 *
 * NOTE: The API of this library is not stable yet and may change in
 *       the future.
 */

import javascript
private import AngularJS

/**
 * A reference to a service.
 */
private newtype TServiceReference =
  MkBuiltinServiceReference(string name) { exists(getBuiltinKind(name)) } or
  MkCustomServiceReference(CustomServiceDefinition service)

/**
 * A reference to a service.
 */
abstract class ServiceReference extends TServiceReference {
  /** Gets a textual representation of this element. */
  string toString() { result = this.getName() }

  /**
   * Gets the name of this reference.
   */
  abstract string getName();

  /**
   * Gets a data flow node that may refer to this service.
   */
  DataFlow::SourceNode getAReference() {
    result = any(ServiceRequestNode request).getDependencyParameter(this)
  }

  /**
   * Gets an access to the referenced service.
   */
  DataFlow::Node getAnAccess() {
    any(ServiceRequestNode request).getDependencyParameter(this).flowsTo(result)
  }

  /**
   * Gets a call that invokes the referenced service.
   */
  DataFlow::CallNode getACall() { result.getCalleeNode() = this.getAnAccess() }

  /**
   * Gets a method call that invokes method `methodName` on the referenced service.
   */
  DataFlow::MethodCallNode getAMethodCall(string methodName) {
    result.getReceiver() = this.getAnAccess() and
    result.getMethodName() = methodName
  }

  /**
   * Gets an access to property `propertyName` on the referenced service.
   */
  DataFlow::PropRef getAPropertyAccess(string propertyName) {
    result.getBase() = this.getAnAccess() and
    result.getPropertyName() = propertyName
  }

  /**
   * Holds if the service is available for dependency injection.
   */
  abstract predicate isInjectable();
}

/**
 * A reference to a builtin service.
 */
class BuiltinServiceReference extends ServiceReference, MkBuiltinServiceReference {
  override string getName() { this = MkBuiltinServiceReference(result) }

  override predicate isInjectable() { any() }
}

/**
 * Holds if `ref` is a reference to the builtin service with the name `serviceName`.
 *
 * Note that `BuiltinServiceReference.getAnAccess` should be used instead of this predicate when possible (they are semantically equivalent for builtin services).
 * This predicate can avoid the non-monotonic recursion that `getAnAccess` can cause.
 */
DataFlow::ParameterNode builtinServiceRef(string serviceName) {
  exists(InjectableFunction f, BuiltinServiceReference service |
    service.getName() = serviceName and
    result = f.getDependencyParameter(serviceName)
  )
}

/**
 * A reference to a custom service.
 */
class CustomServiceReference extends ServiceReference, MkCustomServiceReference {
  CustomServiceDefinition def;

  CustomServiceReference() { this = MkCustomServiceReference(def) }

  override string getName() { result = def.getName() }

  override predicate isInjectable() { def instanceof RecipeDefinition }
}

/**
 * Gets the kind of the builtin "service" named `name`.
 *
 * The possible kinds are:
 * - controller-only: services that are only available to controllers.
 * - provider: a provider for a service.
 * - service: a service.
 * - type: a special builtin service that is usable everywhere.
 */
private string getBuiltinKind(string name) {
  // according to https://docs.angularjs.org/api
  result = "controller-only" and name = "$scope"
  or
  result = "service" and
  (
    // ng
    name =
      [
        "$anchorScroll", "$animate", "$animateCss", "$cacheFactory", "$controller", "$document",
        "$exceptionHandler", "$filter", "$http", "$httpBackend", "$httpParamSerializer",
        "$httpParamSerializerJQLike", "$interpolate", "$interval", "$jsonpCallbacks", "$locale",
        "$location", "$log", "$parse", "$q", "$rootElement", "$rootScope", "$sce", "$sceDelegate",
        "$templateCache", "$templateRequest", "$timeout", "$window", "$xhrFactory"
      ]
    or
    // auto
    name = ["$injector", "$provide"]
    or
    // ngAnimate
    name = ["$animate", "$animateCss"]
    or
    // ngAria
    name = "$aria"
    or
    // ngComponentRouter
    name = ["$rootRouter", "$routerRootComponent"]
    or
    // ngCookies
    name = ["$cookieStore", "$cookies"]
    or
    //ngMock
    name =
      [
        "$animate", "$componentController", "$controller", "$exceptionHandler", "$httpBackend",
        "$interval", "$log", "$timeout"
      ]
    or
    //ngMockE2E
    name = "$httpBackend"
    or
    // ngResource
    name = "$resource"
    or
    // ngRoute
    name = ["$route", "$routeParams"]
    or
    // ngSanitize
    name = "$sanitize"
    or
    // ngTouch
    name = "$swipe"
  )
  or
  result = "provider" and
  (
    // ng
    name =
      [
        "$anchorScrollProvider", "$animateProvider", "$compileProvider", "$controllerProvider",
        "$filterProvider", "$httpProvider", "$interpolateProvider", "$locationProvider",
        "$logProvider", "$parseProvider", "$provider", "$qProvider", "$rootScopeProvider",
        "$sceDelegateProvider", "$sceProvider", "$templateRequestProvider"
      ]
    or
    // ngAria
    name = "$ariaProvider"
    or
    // ngCookies
    name = "$cookiesProvider"
    or
    // ngmock
    name = "$exceptionHandlerProvider"
    or
    // ngResource
    name = "$resourceProvider"
    or
    // ngRoute
    name = "$routeProvider"
    or
    // ngSanitize
    name = "$sanitizeProvider"
  )
  or
  result = "type" and
  (
    // ng
    name = ["$cacheFactory", "$compile", "$rootScope"]
    or
    // ngMock
    name = "$rootScope"
  )
}

/**
 * A custom AngularJS service, defined through `$provide.service`,
 * `module.controller` or a similar method.
 */
abstract class CustomServiceDefinition extends DataFlow::Node {
  /** Gets a factory function used to create the defined service. */
  abstract DataFlow::SourceNode getAFactoryFunction();

  /** Gets a service defined by this definition. */
  abstract DataFlow::SourceNode getAService();

  /** Gets the name of the service defined by this definition. */
  abstract string getName();

  /** Gets the reference to the defined service. */
  ServiceReference getServiceReference() { result = MkCustomServiceReference(this) }
}

/**
 * A definition of a custom AngularJS dependency injection service using a "recipe".
 */
abstract class RecipeDefinition extends DataFlow::CallNode, CustomServiceDefinition,
  DependencyInjection
{
  string methodName;
  string name;

  RecipeDefinition() {
    (
      this = moduleRef(_).getAMethodCall(methodName) or
      this = builtinServiceRef("$provide").getAMethodCall(methodName)
    ) and
    this.getArgument(0).mayHaveStringValue(name)
  }

  override string getName() { result = name }

  override DataFlow::SourceNode getAFactoryFunction() { result.flowsTo(this.getArgument(1)) }

  override DataFlow::Node getAnInjectableFunction() {
    methodName != "value" and
    methodName != "constant" and
    result = this.getAFactoryFunction()
  }
}

/**
 * A custom special AngularJS service, defined through
 * `$controllerProvider.register`, `module.filter` or a similar method.
 *
 * Special services are those that have a meaning outside the AngularJS
 * dependency injection system.
 * This includes, filters (used in AngularJS expressions) and controllers
 * (used through `ng-controller` directives).
 */
abstract private class CustomSpecialServiceDefinition extends CustomServiceDefinition,
  DependencyInjection
{
  override DataFlow::Node getAnInjectableFunction() { result = this.getAFactoryFunction() }
}

/**
 * Holds if `mce` defines a service of type `moduleMethodName` with name `serviceName` using the `factoryFunction` as the factory function.
 */
bindingset[moduleMethodName]
private predicate isCustomServiceDefinitionOnModule(
  DataFlow::CallNode mce, string moduleMethodName, string serviceName,
  DataFlow::Node factoryFunction
) {
  mce = moduleRef(_).getAMethodCall(moduleMethodName) and
  mce.getArgument(0).mayHaveStringValue(serviceName) and
  factoryFunction = mce.getArgument(1)
}

pragma[inline]
private predicate isCustomServiceDefinitionOnProvider(
  DataFlow::CallNode mce, string providerName, string providerMethodName, string serviceName,
  DataFlow::Node factoryArgument
) {
  mce = builtinServiceRef(providerName).getAMethodCall(providerMethodName) and
  (
    mce.getNumArgument() = 1 and
    factoryArgument = mce.getOptionArgument(0, serviceName)
    or
    mce.getNumArgument() = 2 and
    mce.getArgument(0).mayHaveStringValue(serviceName) and
    factoryArgument = mce.getArgument(1)
  )
}

/**
 * A controller defined with `module.controller` or `$controllerProvider.register`.
 */
class ControllerDefinition extends CustomSpecialServiceDefinition {
  string name;
  DataFlow::Node factoryFunction;

  ControllerDefinition() {
    isCustomServiceDefinitionOnModule(this, "controller", name, factoryFunction) or
    isCustomServiceDefinitionOnProvider(this, "$controllerProvider", "register", name,
      factoryFunction)
  }

  override string getName() { result = name }

  override DataFlow::SourceNode getAService() { result = factoryFunction.getALocalSource() }

  override DataFlow::SourceNode getAFactoryFunction() { result = factoryFunction.getALocalSource() }
}

/**
 * A filter defined with `module.filter` or `$filterProvider.register`.
 */
class FilterDefinition extends CustomSpecialServiceDefinition {
  string name;
  DataFlow::Node factoryFunction;

  FilterDefinition() {
    isCustomServiceDefinitionOnModule(this, "filter", name, factoryFunction) or
    isCustomServiceDefinitionOnProvider(this, "$filterProvider", "register", name, factoryFunction)
  }

  override string getName() { result = name }

  override DataFlow::SourceNode getAService() {
    exists(InjectableFunction f |
      f = factoryFunction.getALocalSource() and
      result.flowsTo(f.asFunction().getAReturn())
    )
  }

  override DataFlow::SourceNode getAFactoryFunction() { result = factoryFunction.getALocalSource() }
}

/**
 * A directive defined with `module.directive` or `$compileProvider.directive`.
 */
class DirectiveDefinition extends CustomSpecialServiceDefinition {
  string name;
  DataFlow::Node factoryFunction;

  DirectiveDefinition() {
    isCustomServiceDefinitionOnModule(this, "directive", name, factoryFunction) or
    isCustomServiceDefinitionOnProvider(this, "$compileProvider", "directive", name, factoryFunction)
  }

  override string getName() { result = name }

  override DataFlow::SourceNode getAService() {
    exists(CustomDirective d |
      d.getDefinition() = this and
      result = d.getAnInstantiation()
    )
  }

  override DataFlow::SourceNode getAFactoryFunction() { result = factoryFunction.getALocalSource() }
}

private class CustomDirectiveControllerDependencyInjection extends DependencyInjection {
  CustomDirectiveControllerDependencyInjection() {
    this instanceof DirectiveDefinition or
    this instanceof ComponentDefinition
  }

  override DataFlow::Node getAnInjectableFunction() {
    exists(CustomDirective d |
      d.getDefinition() = this and
      // Note that `.getController` cannot be used here, since that involves a cast to InjectableFunction, and that cast only succeeds because of this method
      result = d.getMember("controller")
    )
  }
}

/**
 * A component defined with `module.component` or `$compileProvider.component`.
 */
class ComponentDefinition extends CustomSpecialServiceDefinition {
  string name;
  DataFlow::Node config;

  ComponentDefinition() {
    isCustomServiceDefinitionOnModule(this, "component", name, config) or
    isCustomServiceDefinitionOnProvider(this, "$compileProvider", "component", name, config)
  }

  override string getName() { result = name }

  override DataFlow::SourceNode getAService() {
    exists(CustomDirective d |
      d.getDefinition() = this and
      result = d.getAnInstantiation()
    )
  }

  override DataFlow::SourceNode getAFactoryFunction() { none() }

  /** Gets the configuration object for the defined component. */
  DataFlow::SourceNode getConfig() { result = config.getALocalSource() }
}

/**
 * An animation defined with `module.animation` or `$animationProvider.register`.
 */
class AnimationDefinition extends CustomSpecialServiceDefinition {
  string name;
  DataFlow::Node factoryFunction;

  AnimationDefinition() {
    isCustomServiceDefinitionOnModule(this, "animation", name, factoryFunction) or
    isCustomServiceDefinitionOnProvider(this, "$animateProvider", "register", name, factoryFunction)
  }

  override string getName() { result = name }

  override DataFlow::SourceNode getAService() {
    exists(InjectableFunction f |
      f = factoryFunction.getALocalSource() and
      result.flowsTo(f.asFunction().getAReturn())
    )
  }

  override DataFlow::SourceNode getAFactoryFunction() { result = factoryFunction.getALocalSource() }
}

/**
 * Gets a builtin service with a specific kind.
 */
BuiltinServiceReference getBuiltinServiceOfKind(string kind) {
  exists(string name |
    kind = getBuiltinKind(name) and
    result = MkBuiltinServiceReference(name)
  )
}

/**
 * A request for one or more AngularJS services.
 */
abstract class ServiceRequestNode extends DataFlow::Node {
  /**
   * Gets the parameter of this request into which `service` is injected.
   */
  abstract DataFlow::ParameterNode getDependencyParameter(ServiceReference service);
}

/**
 * The request for a scope service in the form of the link-function of a directive.
 */
private class LinkFunctionWithScopeInjection extends ServiceRequestNode instanceof LinkFunction {
  override DataFlow::ParameterNode getDependencyParameter(ServiceReference service) {
    service instanceof ScopeServiceReference and
    result = super.getScopeParameter()
  }
}

/**
 * A request for a service, in the form of a dependency-injected function.
 */
class InjectableFunctionServiceRequest extends ServiceRequestNode instanceof InjectableFunction {
  /**
   * Gets the function of this request.
   */
  InjectableFunction getAnInjectedFunction() { result = this }

  /**
   * Gets a name of a requested service.
   */
  string getAServiceName() {
    exists(this.getAnInjectedFunction().getADependencyDeclaration(result))
  }

  /**
   * Gets a service with the specified name, relative to this request.
   * (implementation detail: all services are in the global namespace)
   */
  ServiceReference getAServiceDefinition(string name) {
    result.getName() = name and
    result.isInjectable()
  }

  override DataFlow::ParameterNode getDependencyParameter(ServiceReference service) {
    service = super.getAResolvedDependency(result)
  }
}

private DataFlow::SourceNode getFactoryFunctionResult(RecipeDefinition def) {
  exists(DataFlow::FunctionNode factoryFunction, InjectableFunction f |
    f = def.getAFactoryFunction() and
    factoryFunction = f.asFunction() and
    result.flowsTo(factoryFunction.getAReturn())
  )
}

/**
 * An AngularJS factory recipe definition, that is, a method call of the form
 * `module.factory("name", f)`.
 */
class FactoryRecipeDefinition extends RecipeDefinition {
  FactoryRecipeDefinition() { methodName = "factory" }

  override DataFlow::SourceNode getAService() {
    /*
     * The Factory recipe constructs a new service using a function
     *    with zero or more arguments (these are dependencies on other
     *      services). The return value of this function is the service
     *    instance created by this recipe.
     */

    result = getFactoryFunctionResult(this)
  }
}

/**
 * An AngularJS decorator recipe definition, that is, a method call of the form
 * `module.decorator("name", f)`.
 */
class DecoratorRecipeDefinition extends RecipeDefinition {
  DecoratorRecipeDefinition() { methodName = "decorator" }

  override DataFlow::SourceNode getAService() {
    /*
     * The return value of the function provided to the decorator
     *    will take place of the service, directive, or filter being
     *    decorated.
     */

    result = getFactoryFunctionResult(this)
  }
}

/**
 * An AngularJS service recipe definition, that is, a method call of the form
 * `module.service("name", f)`.
 */
class ServiceRecipeDefinition extends RecipeDefinition {
  ServiceRecipeDefinition() { methodName = "service" }

  override DataFlow::SourceNode getAService() {
    /*
     * The service recipe produces a service just like the Value or
     *    Factory recipes, but it does so by invoking a constructor with
     *    the new operator. The constructor can take zero or more
     *    arguments, which represent dependencies needed by the instance
     *    of this type.
     */

    exists(InjectableFunction f |
      f = this.getAFactoryFunction() and
      result = f.asFunction()
    )
  }
}

/**
 * An AngularJS value recipe definition, that is, a method call of the form
 * `module.value("name", value)`.
 */
class ValueRecipeDefinition extends RecipeDefinition {
  ValueRecipeDefinition() { methodName = "value" }

  override DataFlow::SourceNode getAService() { result = this.getAFactoryFunction() }
}

/**
 * An AngularJS constant recipe definition, that is, a method call of the form
 * `module.constant("name", "constant value")`.
 */
class ConstantRecipeDefinition extends RecipeDefinition {
  ConstantRecipeDefinition() { methodName = "constant" }

  override DataFlow::SourceNode getAService() { result = this.getAFactoryFunction() }
}

/**
 * An AngularJS provider recipe definition, that is, a method call of the form
 * `module.provider("name", fun)`.
 */
class ProviderRecipeDefinition extends RecipeDefinition {
  ProviderRecipeDefinition() { methodName = "provider" }

  override string getName() { result = name or result = name + "Provider" }

  override DataFlow::SourceNode getAService() {
    /*
     * The Provider recipe is syntactically defined as a custom type
     *    that implements a $get method. This method is a factory function
     *    just like the one we use in the Factory recipe. In fact, if you
     *    define a Factory recipe, an empty Provider type with the $get
     *    method set to your factory function is automatically created
     *    under the hood.
     */

    exists(DataFlow::ThisNode thiz, InjectableFunction f |
      f = this.getAFactoryFunction() and
      thiz.getBinder() = f.asFunction() and
      result = thiz.getAPropertySource("$get")
    )
  }
}

private class ProviderRecipeServiceInjection extends DependencyInjection instanceof ProviderRecipeDefinition
{
  override DataFlow::Node getAnInjectableFunction() { result = super.getAService() }
}

/**
 * An AngularJS config method definition, that is, a method call of the form
 * `module.config(fun)`.
 */
class ConfigMethodDefinition extends ModuleApiCall {
  ConfigMethodDefinition() { methodName = "config" }

  /**
   * Gets a provided configuration method.
   */
  InjectableFunction getConfigMethod() {
    result.(DataFlow::SourceNode).flowsTo(this.getArgument(0))
  }
}

/**
 * An AngularJS run method definition, that is, a method call of the form
 * `module.run(fun)`.
 */
class RunMethodDefinition extends ModuleApiCall {
  RunMethodDefinition() { methodName = "run" }

  /**
   * Gets a provided run method.
   */
  InjectableFunction getRunMethod() { result.(DataFlow::SourceNode).flowsTo(this.getArgument(0)) }
}

/**
 * The `$scope` or `$rootScope` service.
 */
class ScopeServiceReference extends BuiltinServiceReference {
  ScopeServiceReference() { this.getName() = "$scope" or this.getName() = "$rootScope" }
}
