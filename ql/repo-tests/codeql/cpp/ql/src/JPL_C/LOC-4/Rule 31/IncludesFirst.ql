/**
 * @name Misplaced include
 * @description #include directives in a file shall only be preceded by other preprocessor directives or comments.
 * @kind problem
 * @id cpp/jpl-c/includes-first
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jpl
 */

import cpp

int firstCodeLine(File f) {
  result =
    min(Declaration d, Location l, int toMin |
      (
        l = d.getLocation() and
        l.getFile() = f and
        not d.isInMacroExpansion()
      ) and
      toMin = l.getStartLine()
    |
      toMin
    )
}

int badIncludeLine(File f, Include i) {
  result = i.getLocation().getStartLine() and
  result > firstCodeLine(f) and
  f = i.getFile()
}

from File f, Include i, int line
where
  line = badIncludeLine(f, i) and
  line = min(badIncludeLine(f, _))
select i,
  "'" + i.toString() + "' is preceded by code -- it should be moved above line " + firstCodeLine(f) +
    " in " + f.getBaseName() + "."
