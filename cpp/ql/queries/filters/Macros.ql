/**
 * @name Filter: exclude results on lines covered by a macro expansion
 * @description Use this filter to return results only when there is no
 *              macro expansion whose location spans all the lines of
 *              the result's location.
 * @kind problem
 * @id cpp/macros-filter
 * @tags filter
 */

import cpp
import external.DefectFilter

predicate macroLocation(File f, int startLine, int endLine) {
  exists(MacroInvocation mi, Location l |
    l = mi.getLocation() and
    l.getFile() = f and
    l.getStartLine() = startLine and
    l.getEndLine() = endLine
  )
}

predicate macroCovering(DefectResult r) {
  exists(File f, int macroStart, int macroEnd, int defectStart, int defectEnd |
    f = r.getFile() and
    defectStart = r.getStartLine() and
    defectEnd = r.getEndLine() and
    macroLocation(f, macroStart, macroEnd) and
    macroStart <= defectStart and
    macroEnd >= defectEnd
  )
}

from DefectResult res
where not macroCovering(res)
select res, res.getMessage()
