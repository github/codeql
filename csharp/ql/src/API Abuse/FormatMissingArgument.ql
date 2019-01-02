/**
 * @name Missing format argument
 * @description Supplying too few arguments to a format string causes a 'System.FormatException'.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/format-argument-missing
 * @tags reliability
 *       maintainability
 */

import csharp
import semmle.code.csharp.frameworks.Format

from FormatCall format, ValidFormatString src, int used, int supplied
where
  src = format.getAFormatSource() and
  used = src.getAnInsert() and
  supplied = format.getSuppliedArguments() and
  used >= supplied
select format, "Argument '{" + used + "}' has not been supplied to $@ format string.", src, "this"
