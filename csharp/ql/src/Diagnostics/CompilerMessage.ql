/**
 * @name Compilation message
 * @description A message emitted by the compiler, including warnings and errors.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/compilation-message
 * @tags internal non-attributable
 */

import csharp
import semmle.code.csharp.commons.Diagnostics

from Diagnostic diagnostic
select diagnostic,
  diagnostic.getSeverityText() + " " + diagnostic.getTag() + " " + diagnostic.getFullMessage()
