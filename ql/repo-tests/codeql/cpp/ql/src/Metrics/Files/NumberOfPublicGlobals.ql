/**
 * @name Public global variables
 * @description The total number of global variables in each file with
 *              external (public) visibility.
 * @kind treemap
 * @id cpp/number-of-public-globals
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @tags maintainability
 *       modularity
 */

import cpp

predicate macroLocation(File f, int startLine, int endLine) {
  exists(MacroInvocation mi, Location l |
    l = mi.getLocation() and
    l.getFile() = f and
    l.getStartLine() = startLine and
    l.getEndLine() = endLine
  )
}

pragma[nomagic]
Location getVariableLocation(Variable v) { result = v.getLocation() }

predicate globalLocation(GlobalVariable gv, File f, int startLine, int endLine) {
  exists(Location l |
    l = getVariableLocation(gv) and
    l.hasLocationInfo(f.getAbsolutePath(), startLine, _, endLine, _)
  )
}

predicate inMacro(GlobalVariable gv) {
  exists(File f, int macroStart, int macroEnd, int varStart, int varEnd |
    macroLocation(f, macroStart, macroEnd) and
    globalLocation(gv, f, varStart, varEnd) and
    varStart >= macroStart and
    varEnd <= macroEnd
  )
}

from File f
where f.fromSource()
select f,
  count(GlobalVariable gv |
    gv.getFile() = f and
    not gv.isStatic() and
    not inMacro(gv)
  )
