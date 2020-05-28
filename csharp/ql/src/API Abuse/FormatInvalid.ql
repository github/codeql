/**
 * @name Invalid format string
 * @description Using a format string with an incorrect format causes a 'System.FormatException'.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cs/invalid-format-string
 * @tags reliability
 *       maintainability
 */

import csharp
import semmle.code.csharp.frameworks.Format
import FormatFlow

from FormatCall s, InvalidFormatString src, PathNode source, PathNode sink
where hasFlowPath(src, source, s, sink)
select src, source, sink, "Invalid format string used in $@ formatting call.", s, "this"
