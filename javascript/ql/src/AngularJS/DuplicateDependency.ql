/**
 * @name Duplicate dependency
 * @description Repeated dependency names are redundant for AngularJS dependency injection.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id js/angular/duplicate-dependency
 * @tags maintainability
 *       frameworks/angularjs
 */

import javascript
import semmle.javascript.RestrictedLocations

predicate isRepeatedDependency(AngularJS::InjectableFunction f, string name, ASTNode location) {
  exists(int i, int j |
    i < j and
    exists(f.getDependencyDeclaration(i, name)) and
    location = f.getDependencyDeclaration(j, name)
  )
}

from AngularJS::InjectableFunction f, ASTNode node, string name
where
  isRepeatedDependency(f, name, node) and
  not count(f.asFunction().getParameterByName(name)) > 1 // avoid duplicating reports from js/duplicate-parameter-name
select f.asFunction().(FirstLineOf), "This function has a duplicate dependency '$@'.", node, name
