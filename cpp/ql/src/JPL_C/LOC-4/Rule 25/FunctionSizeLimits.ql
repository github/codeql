/**
 * @name Function too long
 * @description Function length should be limited to what can be printed on a single sheet of paper (60 lines). Number of parameters is limited to 6 or fewer.
 * @kind problem
 * @id cpp/jpl-c/function-size-limits
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jpl
 */

import cpp

string lengthWarning(Function f) {
  exists(int lines | lines = f.getMetrics().getNumberOfLines() |
    lines > 60 and
    result = f.getName() + " has too many lines (" + lines + ", while 60 are allowed)."
  )
}

string paramWarning(Function f) {
  exists(int params | params = f.getMetrics().getNumberOfParameters() |
    params > 6 and
    result = f.getName() + " has too many parameters (" + params + ", while 6 are allowed)."
  )
}

from Function f, string msg
where
  msg = lengthWarning(f) or
  msg = paramWarning(f)
select f, msg
