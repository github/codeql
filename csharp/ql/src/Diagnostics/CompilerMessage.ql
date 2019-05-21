/**
 * @name Compilation message
 * @description A message emitted by the compiler.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cs/compilation-warning
 * @tags internal
 */

import csharp
import semmle.code.csharp.commons.Diagnostics

from Diagnostic diagnostic
select diagnostic,
  diagnostic.getSeverityText() + " " + diagnostic.getTag() + " " + diagnostic.getFullMessage()
