/**
 * @name Trait Composition Vulnerabilities
 * @description Detects vulnerabilities from unsafe trait composition
 * @kind problem
 * @problem.severity warning
 * @security-severity medium
 * @precision medium
 * @tags security
 *       polymorphism
 *       traits
 */

import php
import codeql.php.polymorphism.Polymorphism
import codeql.php.polymorphism.TraitComposition
import codeql.php.polymorphism.TraitUsage

/**
 * Detects trait method conflicts that could be unintentionally resolved
 */
from Class classUsing, Trait trait1, Trait trait2, Method method
where
  classUsing.getMethod(trait1.getMethod(method.getName()).getName()) = trait1.getMethod(method.getName()) and
  classUsing.getMethod(trait2.getMethod(method.getName()).getName()) = trait2.getMethod(method.getName()) and
  method.getName() = trait1.getMethod(method.getName()).getName() and
  method.getName() = trait2.getMethod(method.getName()).getName() and
  trait1 != trait2
select classUsing,
  "Trait conflict detected: methods with same name in traits " +
    trait1.getName() + " and " + trait2.getName() +
    " used without explicit conflict resolution"
