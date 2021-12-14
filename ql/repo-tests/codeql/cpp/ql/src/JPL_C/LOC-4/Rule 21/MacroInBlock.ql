/**
 * @name Macro definition in block
 * @description Macros shall not be #define'd within a function or a block.
 * @kind problem
 * @id cpp/jpl-c/macro-in-block
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jpl
 */

import cpp

int lineInBlock(File f) {
  exists(BlockStmt block, Location blockLocation |
    block.getFile() = f and blockLocation = block.getLocation()
  |
    result in [blockLocation.getStartLine() .. blockLocation.getEndLine()]
  )
}

from Macro m
where m.getLocation().getStartLine() = lineInBlock(m.getFile())
select m, "The macro " + m.getHead() + " is defined in a block."
