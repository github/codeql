/**
 * @name Incompatible dependency injection
 * @description Dependency-injecting a service of the wrong kind causes an error at runtime.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id js/angular/incompatible-service
 * @tags correctness
 *       frameworks/angularjs
 */

import javascript
import AngularJS

/**
 * Holds if `request` originates from a "service", "directive" or "filter" method call.
 */
predicate isServiceDirectiveOrFilterFunction(InjectableFunctionServiceRequest request) {
  exists(InjectableFunction f | f = request.getAnInjectedFunction() |
    exists(ServiceRecipeDefinition def | def.getAFactoryFunction() = f) or
    exists(FactoryRecipeDefinition def | def.getAFactoryFunction() = f) or
    exists(DirectiveDefinition def | def.getAFactoryFunction() = f) or
    exists(FilterDefinition def | def.getAFactoryFunction() = f)
  )
}

/**
 * Holds if `request` originates from a "controller" method call.
 */
predicate isControllerFunction(InjectableFunctionServiceRequest request) {
  exists(InjectableFunction f | f = request.getAnInjectedFunction() |
    exists(ControllerDefinition def | def.getAFactoryFunction() = f)
  )
}

/**
 * Holds if `request` originates from a "run" method call.
 */
predicate isRunMethod(InjectableFunctionServiceRequest request) {
  exists(InjectableFunction f | f = request.getAnInjectedFunction() |
    exists(RunMethodDefinition def | def.getRunMethod() = f)
  )
}

/**
 * Holds if `request` originates from a "config" method call.
 */
predicate isConfigMethod(InjectableFunctionServiceRequest request) {
  exists(InjectableFunction f | f = request.getAnInjectedFunction() |
    exists(ConfigMethodDefinition def | def.getConfigMethod() = f)
  )
}

/**
 * Holds if `kind` is a service kind that is compatible with all requests.
 */
predicate isWildcardKind(string kind) {
  kind = "type" or // builtins of kind "type" are usable everywhere
  kind = "decorator" // a decorator is always allowed, its decoratee might not be
}

/**
 * Holds if `request` is compatible with a service of kind `kind`.
 * (see https://docs.angularjs.org/guide/di)
 */
predicate isCompatibleRequestedService(InjectableFunctionServiceRequest request, string kind) {
  isWildcardKind(kind) and exists(request)
  or
  (
    isServiceDirectiveOrFilterFunction(request) or
    isRunMethod(request) or
    isControllerFunction(request)
  ) and
  kind = ["value", "service", "factory", "constant", "provider-value"]
  or
  isControllerFunction(request) and
  kind = "controller-only"
  or
  isConfigMethod(request) and
  (
    kind = "constant" or
    kind = "provider"
  )
}

/**
 * Gets the kind of a service named `serviceName`.
 */
string getServiceKind(InjectableFunctionServiceRequest request, string serviceName) {
  exists(ServiceReference id | id = request.getAServiceDefinition(serviceName) |
    id = getBuiltinServiceOfKind(result)
    or
    exists(CustomServiceDefinition custom |
      id = custom.getServiceReference() and
      (
        custom instanceof ValueRecipeDefinition and result = "value"
        or
        custom instanceof ServiceRecipeDefinition and result = "service"
        or
        custom instanceof FactoryRecipeDefinition and result = "factory"
        or
        custom instanceof DecoratorRecipeDefinition and result = "decorator"
        or
        custom instanceof ConstantRecipeDefinition and result = "constant"
        or
        (
          custom instanceof ProviderRecipeDefinition and
          if serviceName.matches("%Provider")
          then result = "provider"
          else result = "provider-value"
        )
      )
    )
  )
}

from
  InjectableFunctionServiceRequest request, string name, string componentDescriptionString,
  string compatibleWithString, string kind
where
  name = request.getAServiceName() and
  name != "$provide" and
  name != "$injector" and // special case: these services are always allowed
  kind = getServiceKind(request, name) and
  exists(request.getAServiceDefinition(name)) and // ignore unknown/undefined services
  not isCompatibleRequestedService(request, kind) and
  compatibleWithString =
    concat(string compatibleKind |
      isCompatibleRequestedService(request, compatibleKind) and
      not isWildcardKind(compatibleKind)
    |
      "'" + compatibleKind + "'", ", " order by compatibleKind
    ).regexpReplaceAll(",(?=[^,]+$)", " or") and
  (
    isServiceDirectiveOrFilterFunction(request) and
    componentDescriptionString = "Components such as services, directives, filters, and animations"
    or
    isControllerFunction(request) and
    componentDescriptionString = "Controllers"
    or
    isRunMethod(request) and
    componentDescriptionString = "Run methods"
    or
    isConfigMethod(request) and
    componentDescriptionString = "Config methods"
  )
select request,
  "'" + name + "' is a dependency of kind '" + kind + "', and cannot be injected here. " +
    componentDescriptionString + " can only be injected with dependencies of kind " +
    compatibleWithString + "."
