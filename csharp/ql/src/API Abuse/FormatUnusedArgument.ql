/**
 * @name Unused format argument
 * @description Supplying more arguments than are required for a format string may indicate an error in the format string.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/format-argument-unused
 * @tags reliability
 *       maintainability
 */

import csharp
import semmle.code.csharp.frameworks.Format

from FormatCall format, int unused, ValidFormatString src
where
  src = format.getAFormatSource() and
  unused = format.getAnUnusedArgument(src) and
  not src.getValue() = ""
select format, "The $@ ignores $@.", src, "format string", format.getSuppliedExpr(unused),
  "this supplied value"
