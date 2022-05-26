/**
 * @name Unused AngularJS dependency
 * @description Unused dependencies are confusing, and should be removed.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id js/angular/unused-dependency
 * @tags maintainability
 *       frameworks/angularjs
 */

import javascript
import Declarations.UnusedParameter
import semmle.javascript.RestrictedLocations

predicate isUnusedParameter(Function f, string msg, Parameter parameter) {
  exists(Variable pv |
    isUnused(f, parameter, pv, _) and
    not isAnAccidentallyUnusedParameter(parameter) and // avoid double alerts
    msg = "Unused dependency " + pv.getName() + "."
  )
}

predicate isMissingParameter(AngularJS::InjectableFunction f, string msg, AstNode location) {
  exists(int paramCount, int injectionCount |
    DataFlow::valueNode(location) = f and
    paramCount = f.asFunction().getNumParameter() and
    injectionCount = count(f.getADependencyDeclaration(_)) and
    paramCount < injectionCount and
    exists(string parametersString, string dependenciesAreString |
      (if paramCount = 1 then parametersString = "parameter" else parametersString = "parameters") and
      (
        if injectionCount = 1
        then dependenciesAreString = "dependency is"
        else dependenciesAreString = "dependencies are"
      ) and
      msg =
        "This function has " + paramCount + " " + parametersString + ", but " + injectionCount + " "
          + dependenciesAreString + " injected into it."
    )
  )
}

from AngularJS::InjectableFunction f, string message, AstNode location
where
  isUnusedParameter(f.asFunction(), message, location) or isMissingParameter(f, message, location)
select location.(FirstLineOf), message
