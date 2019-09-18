/**
 * @name Missing explicit dependency injection
 * @description Functions without explicit dependency injections
 *                will not work when their parameter names are minified.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id js/angular/missing-explicit-injection
 * @tags correctness
 *         maintainability
 *       frameworks/angularjs
 */

import javascript

from AngularJS::InjectableFunction f1, AngularJS::InjectableFunction f2
where
  f1.asFunction().getNumParameter() > 0 and
  not exists(f1.getAnExplicitDependencyInjection()) and
  // ... but only if explicit dependencies are used somewhere else in the same file
  f1 != f2 and
  exists(f2.getAnExplicitDependencyInjection()) and
  f1.getFile() = f2.getFile()
select f1,
  "This function has no explicit dependency injections, but $@ has an explicit dependency injection.",
  f2, "this function"
