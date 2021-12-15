/**
 * @name Loop body executes at most once
 * @description A loop that executes at most once is confusing and should be rewritten
 *              as a conditional.
 * @kind problem
 * @problem.severity recommendation
 * @id js/single-run-loop
 * @tags readability
 * @precision low
 */

import javascript
import semmle.javascript.RestrictedLocations
import semmle.javascript.frameworks.Emscripten

from LoopStmt l, BasicBlock body
where
  body = l.getBody().getBasicBlock() and
  not body.getASuccessor+() = body and
  not l instanceof EnhancedForLoop and
  // Emscripten generates lots of `do { ... } while(0);` loops, so exclude
  not l.getTopLevel() instanceof EmscriptenGeneratedToplevel
select l.(FirstLineOf), "This loop executes at most once."
