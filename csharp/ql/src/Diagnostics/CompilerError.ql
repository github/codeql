/**
 * @name Compilation error
 * @description A compilation error can cause extraction problems, and could lead to inaccurate results.
 * @kind diagnostic
 * @id cs/compilation-error
 * @tags internal non-attributable
 */

import csharp
import semmle.code.csharp.commons.Diagnostics

from CompilerError diagnostic
select diagnostic,
  diagnostic.getSeverityText() + " " + diagnostic.getTag() + " " + diagnostic.getFullMessage()
