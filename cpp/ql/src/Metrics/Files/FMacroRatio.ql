/**
 * @name Usage of macros
 * @description The percentage of source lines in each file that contain
 *              use of macros.
 * @kind treemap
 * @id cpp/macro-ratio-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg max
 * @tags maintainability
 *       readability
 */

import cpp

predicate macroLines(File f, int line) {
  exists(MacroInvocation mi |
    mi.getFile() = f and
    mi.getLocation().getStartLine() = line
  )
}

predicate macroLineCount(File f, int num) { num = count(int line | macroLines(f, line)) }

from MetricFile f, int macroLines, int loc
where
  f.fromSource() and
  loc = f.getNumberOfLinesOfCode() and
  loc > 0 and
  macroLineCount(f, macroLines)
select f, 100.0 * (macroLines.(float) / loc.(float)) as ratio order by ratio desc
