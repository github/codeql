/**
 * @name Missing Dispose method
 * @description Classes that implement 'IDisposable' and have members of 'IDisposable' type
 *              should also declare/override 'Dispose()'.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cs/missing-dispose-method
 * @tags efficiency
 *       maintainability
 *       external/cwe/cwe-404
 *       external/cwe/cwe-459
 */

import csharp
import Dispose
import semmle.code.csharp.frameworks.System

from DisposableType t, DisposableField f
where
  f.getDeclaringType() = t and
  t.isSourceDeclaration() and
  not f.isStatic() and
  not implementsDispose(t) and
  not isAutoDisposedWebControl(f)
select t, "This type does not override 'Dispose()' but has disposable field $@.", f, f.getName()
