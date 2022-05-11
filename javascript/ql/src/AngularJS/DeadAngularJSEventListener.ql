/**
 * @name Dead AngularJS event listener
 * @description An AngularJS event listener that listens for a non-existent event has no effect.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id js/angular/dead-event-listener
 * @tags correctness
 *       frameworks/angularjs
 */

import javascript

/**
 * Holds if the name is a known AngularJS event name.
 */
predicate isABuiltinEventName(string name) {
  // $rootScope.Scope
  name = "$destroy"
  or
  // $location
  name = ["$locationChangeStart", "$locationChangeSuccess"]
  or
  // ngView
  name = "$viewContentLoaded"
  or
  // angular-ui/ui-router
  name =
    [
      "$stateChangeStart", "$stateNotFound", "$stateChangeSuccess", "$stateChangeError",
      "$viewContentLoading ", "$viewContentLoaded "
    ]
  or
  // $route
  name = ["$routeChangeStart", "$routeChangeSuccess", "$routeChangeError", "$routeUpdate"]
  or
  // ngInclude
  name = ["$includeContentRequested", "$includeContentLoaded", "$includeContentError"]
}

/**
 * Holds if user code emits or broadcasts an event named `name`.
 */
predicate isAUserDefinedEventName(string name) {
  exists(string methodName, MethodCallExpr mce | methodName = "$emit" or methodName = "$broadcast" |
    mce.getArgument(0).mayHaveStringValue(name) and
    (
      // dataflow based scope resolution
      mce = any(AngularJS::ScopeServiceReference scope).getAMethodCall(methodName)
      or
      // heuristic scope resolution: assume parameters like `$scope` or `$rootScope` are AngularJS scope objects
      exists(SimpleParameter param |
        param.getName() = any(AngularJS::ScopeServiceReference scope).getName() and
        mce.getReceiver().mayReferToParameter(param) and
        mce.getMethodName() = methodName
      )
      or
      // a call in an AngularJS expression
      exists(AngularJS::NgCallExpr call |
        call.getCallee().(AngularJS::NgVarExpr).getName() = methodName and
        call.getArgument(0).(AngularJS::NgString).getStringValue() = name
      )
    )
  )
}

from AngularJS::ScopeServiceReference scope, MethodCallExpr mce, string eventName
where
  mce = scope.getAMethodCall("$on") and
  mce.getArgument(0).mayHaveStringValue(eventName) and
  not (
    isAUserDefinedEventName(eventName) or
    isABuiltinEventName(eventName) or
    // external, namespaced
    eventName.regexpMatch(".*[.:].*") or
    // from other event system (DOM: onClick et al)
    eventName.regexpMatch("on[A-Z][a-zA-Z]+") // camelCased with 'on'-prefix
  )
select mce.getArgument(1),
  "This event listener is dead, the event '" + eventName + "' is not emitted anywhere."
