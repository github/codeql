/**
 * @name Invalid format string
 * @description Using a format string with an incorrect format causes a 'System.FormatException'.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/invalid-format-string
 * @tags reliability
 *       maintainability
 */

import csharp
import semmle.code.csharp.frameworks.Format

from FormatCall s, InvalidFormatString src
where src = s.getAFormatSource()
select src, "Invalid format string used in $@ formatting call.", s, "this"
