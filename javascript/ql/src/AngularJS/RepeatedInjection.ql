/**
 * @name Repeated dependency injection
 * @description Specifying dependency injections of an AngularJS component multiple times overrides earlier specifications.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id js/angular/repeated-dependency-injection
 * @tags quality
 *       maintainability
 *       readability
 *       frameworks/angularjs
 */

import javascript
import semmle.javascript.RestrictedLocations

from AngularJS::InjectableFunction f, DataFlow::Node explicitInjection
where
  count(f.getAnExplicitDependencyInjection()) > 1 and
  explicitInjection = f.getAnExplicitDependencyInjection()
select f.asFunction().getFunction().(FirstLineOf),
  "This function has $@ defined in multiple places.", explicitInjection, "dependency injections"
