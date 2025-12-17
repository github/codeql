/**
 * @name Inheritance Depth Analysis
 * @description Identifies deep inheritance hierarchies that might indicate design issues
 * @kind problem
 * @problem.severity note
 * @tags polymorphism
 *       design
 *       complexity
 */

import php
import codeql.php.polymorphism.Polymorphism
import codeql.php.polymorphism.ClassResolver

/**
 * Find inheritance chains that are too deep (>5 levels)
 */
from Class classC, int depth
where
  depth = count(Class ancestor | getAncestorClass(ancestor) = classC or ancestor = classC) and
  depth > 5
select classC,
  "Class " + classC.getName() + " has inheritance depth of " + depth +
    " - consider refactoring to reduce complexity"
