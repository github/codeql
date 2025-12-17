/**
 * @name Complex Branching Patterns
 * @description Detects complex control flow patterns that may indicate code that's hard to understand or maintain.
 * @kind problem
 * @problem.severity note
 * @tags maintainability
 *       complexity
 * @id php/complex-branching
 */

import php
import codeql.php.EnhancedControlFlow

from ComplexBranching branch
select branch.getAstNode(),
       "Complex branching pattern detected (nested conditionals or loops). " +
       "Consider refactoring for better maintainability."
