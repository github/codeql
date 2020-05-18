/**
 * @name Unused format argument
 * @description Supplying more arguments than are required for a format string may indicate an error in the format string.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id cs/format-argument-unused
 * @tags reliability
 *       maintainability
 */

import csharp
import semmle.code.csharp.frameworks.Format
import FormatFlow

from FormatCall format, int unused, ValidFormatString src, PathNode source, PathNode sink
where
  hasFlowPath(src, source, format, sink) and
  unused = format.getAnUnusedArgument(src) and
  not src.getValue() = ""
select format, source, sink, "The $@ ignores $@.", src, "format string",
  format.getSuppliedExpr(unused), "this supplied value"
