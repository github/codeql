/**
 * @name Duplicate dependency
 * @description Repeated dependency names are redundant for AngularJS dependency injection.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id js/angular/duplicate-dependency
 * @tags quality
 *       maintainability
 *       readability
 *       frameworks/angularjs
 */

import javascript
import semmle.javascript.RestrictedLocations

predicate isRepeatedDependency(AngularJS::InjectableFunction f, string name, DataFlow::Node node) {
  exists(int i, int j |
    i < j and
    exists(f.getDependencyDeclaration(i, name)) and
    node = f.getDependencyDeclaration(j, name)
  )
}

from AngularJS::InjectableFunction f, DataFlow::Node node, string name
where
  isRepeatedDependency(f, name, node) and
  not count(f.asFunction().getParameterByName(name)) > 1 // avoid duplicating reports from js/duplicate-parameter-name
select f.asFunction().getFunction().(FirstLineOf), "This function has a duplicate dependency $@.",
  node, name
