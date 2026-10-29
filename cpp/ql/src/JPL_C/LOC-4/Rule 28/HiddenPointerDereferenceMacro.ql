/**
 * @name Pointer dereference hidden in macro
 * @description Pointer dereference operations should not be hidden in macro definitions.
 * @kind problem
 * @id cpp/jpl-c/hidden-pointer-dereference-macro
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jpl
 */

import cpp

from Macro m
where
  forex(MacroInvocation mi | mi.getMacro() = m |
    exists(PointerDereferenceExpr e, Location miLoc, Location eLoc | e = mi.getAGeneratedElement() |
      miLoc = mi.getLocation() and
      eLoc = e.getLocation() and
      eLoc.getStartColumn() = miLoc.getStartColumn() and
      eLoc.getStartLine() = miLoc.getStartLine()
    )
  )
select m, "The macro " + m.getHead() + " hides pointer dereference operations."
