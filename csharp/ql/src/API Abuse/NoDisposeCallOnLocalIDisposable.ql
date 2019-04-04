/**
 * @name Missing Dispose call on local IDisposable
 * @description Methods that create objects of type 'IDisposable' should call 'Dispose' on those
 *              objects, otherwise unmanaged resources may not be released.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/local-not-disposed
 * @tags efficiency
 *       maintainability
 *       external/cwe/cwe-404
 *       external/cwe/cwe-459
 *       external/cwe/cwe-460
 */

import csharp
import Dispose
import semmle.code.csharp.frameworks.System
import semmle.code.csharp.commons.Disposal

/** Holds if expression `e` escapes the local method scope. */
predicate escapes(Expr e) {
  // Things that return escape
  exists(Callable c | c.canReturn(e) or c.canYieldReturn(e))
  or
  // Things that are assigned to fields, properties, or indexers escape the scope
  exists(AssignableDefinition def, Assignable a |
    def.getSource() = e and
    a = def.getTarget()
  |
    a instanceof Field or
    a instanceof Property or
    a instanceof Indexer
  )
  or
  // Things that are added to a collection of some kind are likely to escape the scope
  exists(MethodCall mc | mc.getTarget().hasName("Add") | mc.getAnArgument() = e)
}

/** Holds if the `disposable` is a whitelisted result. */
predicate isWhitelisted(LocalScopeDisposableCreation disposable) {
  exists(MethodCall mc |
    // Close can often be used instead of Dispose
    mc.getTarget().hasName("Close")
    or
    // Used as an alias for Dispose
    mc.getTarget().hasName("Clear")
  |
    mc.getQualifier() = disposable.getADisposeTarget()
  )
  or
  // WebControls are usually disposed automatically
  disposable.getType() instanceof WebControl
}

from LocalScopeDisposableCreation disposable
// The disposable is local scope - the lifetime is the execution of this method
where
  not escapes(disposable.getADisposeTarget()) and
  // Only care about library types - user types often have spurious IDisposable declarations
  disposable.getType().fromLibrary() and
  // Disposables constructed in the initializer of a `using` are safe
  not exists(UsingStmt us | us.getAnExpr() = disposable.getADisposeTarget()) and
  // Foreach calls Dispose
  not exists(ForeachStmt fs | fs.getIterableExpr() = disposable.getADisposeTarget()) and
  // As are disposables on which the Dispose method is called explicitly
  not exists(MethodCall mc |
    mc.getTarget() instanceof DisposeMethod and
    mc.getQualifier() = disposable.getADisposeTarget()
  ) and
  // Ignore whitelisted results
  not isWhitelisted(disposable) and
  // Not passed to a disposing method
  not exists(Call c, Parameter p | disposable.getADisposeTarget() = c.getArgumentForParameter(p) |
    mayBeDisposed(p)
  )
select disposable, "Disposable '" + disposable.getType() + "' is created here but is not disposed."
