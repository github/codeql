/**
 * @name Futile conditional
 * @description An if-statement with an empty then-branch and no else-branch
 *              may indicate that the code is incomplete.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/empty-if
 * @tags reliability
 *       readability
 */

import cpp

predicate macroUse(Locatable l) {
  l instanceof PreprocessorDirective or l instanceof MacroInvocation
}

predicate macroUseLocation(File f, int start, int end) {
  exists(Locatable l, Location loc |
    macroUse(l) and
    loc = l.getLocation() and
    f = loc.getFile() and
    start = loc.getStartLine() and
    end = loc.getEndLine()
  )
}

pragma[noopt]
predicate emptyIf(IfStmt s, BlockStmt b, File f, int start, int end) {
  s instanceof IfStmt and
  not exists(s.getElse()) and
  b = s.getThen() and
  b instanceof BlockStmt and
  not exists(b.getAChild()) and
  f = b.getFile() and
  exists(Location l |
    l = b.getLocation() and
    start = l.getStartLine() and
    end = l.getEndLine()
  )
}

pragma[noopt]
predicate query(IfStmt s, BlockStmt b) {
  exists(File f, int blockStart, int blockEnd |
    emptyIf(s, b, f, blockStart, blockEnd) and
    not exists(int macroStart, int macroEnd |
      macroUseLocation(f, macroStart, macroEnd) and
      macroStart > blockStart and
      macroEnd < blockEnd
    )
  )
}

from IfStmt s, BlockStmt b
where
  query(s, b) and
  not b.isInMacroExpansion()
select s, "If-statement with an empty then-branch and no else-branch."
