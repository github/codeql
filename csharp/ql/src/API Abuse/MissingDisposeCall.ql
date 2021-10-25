/**
 * @name Missing Dispose call
 * @description Classes that implement 'IDisposable' and have members of 'IDisposable' type
 *              should dispose those members in their 'Dispose()' method.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cs/member-not-disposed
 * @tags efficiency
 *       maintainability
 *       external/cwe/cwe-404
 *       external/cwe/cwe-459
 */

import csharp
import Dispose
import semmle.code.csharp.frameworks.System

from DisposableType t, DisposableField f, Method dispose
where
  f.getDeclaringType() = t and
  not f.isStatic() and
  t.isSourceDeclaration() and
  dispose = getInvokedDisposeMethod(t) and
  dispose.getDeclaringType() = t and
  not exists(MethodCall mc |
    mc.getTarget() instanceof DisposeMethod and
    mc.getQualifier() = f.getAnAccess() and
    mc.getEnclosingCallable() = dispose
  )
select dispose, "This 'Dispose()' method does not call 'Dispose()' on `IDisposable` field $@.", f,
  f.getName()
