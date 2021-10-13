/**
 * @name Dependency mismatch
 * @description If the injected dependencies of a function go out of sync
 *              with its parameters, the function will become difficult to
 *              understand and maintain.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id js/angular/dependency-injection-mismatch
 * @tags correctness
 *       maintainability
 *       frameworks/angularjs
 */

import javascript

from AngularJS::InjectableFunction f, SimpleParameter p, string msg
where
  p = f.asFunction().getAParameter() and
  (
    not p = f.getDependencyParameter(_) and
    msg = "This parameter has no injected dependency."
    or
    exists(string n | p = f.getDependencyParameter(n) |
      p.getName() != n and
      exists(f.getDependencyParameter(p.getName())) and
      msg =
        "This parameter is named '" + p.getName() + "', " + "but actually refers to dependency '" +
          n + "'."
    )
  )
select p, msg
