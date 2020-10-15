/**
 * @name AV Rule 53
 * @description Header files will always have a file name extension of .h.
 * @kind problem
 * @id cpp/jsf/av-rule-53
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

/*
 * Interpretation: use .h, never .H, .hpp or other variants. What else could be
 * meant by 'header file'?
 */

from File f
where
  f.getExtension().toLowerCase() = ["h", "hpp"] and
  f.getExtension() != "h"
select f, "AV Rule 53: Header files will always have a file name extension of .h."
