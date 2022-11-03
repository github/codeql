/**
 * @name Repeated dependency injection
 * @description Specifying dependency injections of an AngularJS component multiple times overrides earlier specifications.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id js/angular/repeated-dependency-injection
 * @tags maintainability
 *       frameworks/angularjs
 */

import javascript
import semmle.javascript.RestrictedLocations

from AngularJS::InjectableFunction f, ASTNode explicitInjection
where
  count(f.getAnExplicitDependencyInjection()) > 1 and
  explicitInjection = f.getAnExplicitDependencyInjection()
select f.asFunction().(FirstLineOf), "This function has $@ defined in multiple places.",
  explicitInjection, "dependency injections"
