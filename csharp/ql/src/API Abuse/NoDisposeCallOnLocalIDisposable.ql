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

private class ReturnNode extends DataFlow::ExprNode {
  ReturnNode() {
    exists(Callable c, Expr e | e = this.getExpr() | c.canReturn(e) or c.canYieldReturn(e))
  }
}

private class Conf extends DataFlow::Configuration {
  Conf() { this = "NoDisposeCallOnLocalIDisposable" }

  override predicate isSource(DataFlow::Node node) {
    node.asExpr() =
      any(LocalScopeDisposableCreation disposable |
        // Only care about library types - user types often have spurious IDisposable declarations
        disposable.getType().fromLibrary() and
        // WebControls are usually disposed automatically
        not disposable.getType() instanceof WebControl
      )
  }

  override predicate isSink(DataFlow::Node node) {
    // Things that return may be disposed elsewhere
    node instanceof ReturnNode
    or
    exists(Expr e | e = node.asExpr() |
      // Disposables constructed in the initializer of a `using` are safe
      exists(UsingStmt us | us.getAnExpr() = e)
      or
      // Foreach calls Dispose
      exists(ForeachStmt fs | fs.getIterableExpr() = e)
      or
      // As are disposables on which the Dispose method is called explicitly
      exists(MethodCall mc |
        mc.getTarget() instanceof DisposeMethod and
        mc.getQualifier() = e
      )
      or
      // A disposing method
      exists(Call c, Parameter p | e = c.getArgumentForParameter(p) | mayBeDisposed(p))
      or
      // Things that are assigned to fields, properties, or indexers may be disposed
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
      exists(MethodCall mc | mc.getAnArgument() = e | mc.getTarget().hasName("Add"))
      or
      exists(MethodCall mc | mc.getQualifier() = e |
        // Close can often be used instead of Dispose
        mc.getTarget().hasName("Close")
        or
        // Used as an alias for Dispose
        mc.getTarget().hasName("Clear")
      )
    )
  }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    node2.asExpr() =
      any(LocalScopeDisposableCreation other | other.getAnArgument() = node1.asExpr())
  }

  override predicate isBarrierOut(DataFlow::Node node) {
    this.isSink(node) and
    not node instanceof ReturnNode
  }
}

/** Holds if `disposable` may not be disposed. */
predicate mayNotBeDisposed(LocalScopeDisposableCreation disposable) {
  exists(Conf conf, DataFlow::ExprNode e |
    e.getExpr() = disposable and
    conf.isSource(e) and
    not exists(DataFlow::Node sink | conf.hasFlow(DataFlow::exprNode(disposable), sink) |
      sink instanceof ReturnNode
      implies
      sink.getEnclosingCallable() = disposable.getEnclosingCallable()
    )
  )
}

from LocalScopeDisposableCreation disposable
where mayNotBeDisposed(disposable)
select disposable, "Disposable '" + disposable.getType() + "' is created here but is not disposed."
