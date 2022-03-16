/**
 * @name Inconsistent deprecation
 * @description A deprecated predicate that overrides a non-deprecated predicate is an indication that the super-predicate should be deprecated.
 * @kind problem
 * @problem.severity warning
 * @id ql/inconsistent-deprecation
 * @tags correctness
 *       maintanability
 * @precision very-high
 */

import ql

predicate overrides(ClassPredicate sub, ClassPredicate sup, string description, string overrides) {
  sub.overrides(sup) and description = "predicate" and overrides = "predicate"
}

from AstNode sub, AstNode sup, string description, string overrides
where
  overrides(sub, sup, description, overrides) and
  sub.hasAnnotation("deprecated") and
  not sup.hasAnnotation("deprecated")
select sub, "This deprecated " + description + " overrides $@. Consider deprecating both.", sup,
  "a non-deprecated " + overrides
