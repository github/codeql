/**
 * @name AV Rule 54
 * @description Implementation files will always have a file name extension of .cpp.
 * @kind problem
 * @id cpp/jsf/av-rule-54
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

from CppFile f
where f.getExtension() != "cpp"
select f, "AV Rule 53: Implementation files will always have a file name extension of .cpp."
