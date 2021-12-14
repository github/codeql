/**
 * @name Use of exit() or quit()
 * @description exit() or quit() may fail if the interpreter is run with the -S option.
 * @kind problem
 * @tags maintainability
 * @problem.severity warning
 * @sub-severity low
 * @precision very-high
 * @id py/use-of-exit-or-quit
 */

import python

from CallNode call, string name
where call.getFunction().pointsTo(Value::siteQuitter(name))
select call,
  "The '" + name +
    "' site.Quitter object may not exist if the 'site' module is not loaded or is modified."
