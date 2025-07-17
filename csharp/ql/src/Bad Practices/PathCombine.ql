/**
 * @name Call to System.IO.Path.Combine
 * @description Finds calls to System.IO.Path's Combine method
 * @kind problem
 * @problem.severity recommendation
 * @precision very-high
 * @id cs/path-combine
 * @tags quality
 *       reliability
 *       correctness
 */

import csharp
import semmle.code.csharp.frameworks.System

from MethodCall call
where call.getTarget().hasFullyQualifiedName("System.IO", "Path", "Combine")
select call, "Call to 'System.IO.Path.Combine'."
