/**
 * @name Use of incompletely initialized object
 * @description Accessing 'this' or a property of 'super' in the constructor of a
 *              subclass before calling the super constructor will cause a runtime error.
 * @kind problem
 * @problem.severity error
 * @id js/incomplete-object-initialization
 * @tags correctness
 *       language-features
 * @precision high
 */

import javascript
import semmle.javascript.RestrictedLocations

/**
 * Holds if `e` is an expression of the given `kind` that must be guarded by a
 * call to the super constructor if it appears in the constructor of a class
 * with a superclass.
 */
predicate needsGuard(Expr e, string kind) {
  e instanceof ThisExpr and kind = "this"
  or
  e instanceof SuperPropAccess and kind = "super"
}

/**
 * Holds if `bb` is a basic block that can be reached from the start of `ctor`,
 * which is the constructor of a class that has a superclass, without going through
 * a `super` call.
 */
predicate unguardedBB(BasicBlock bb, Function ctor) {
  exists(ClassDefinition c | exists(c.getSuperClass()) |
    ctor = c.getConstructor().getBody() and
    bb = ctor.getStartBB()
  )
  or
  exists(BasicBlock pred | pred = bb.getAPredecessor() |
    unguardedBB(pred, ctor) and
    not pred.getANode() instanceof SuperCall
  )
}

/**
 * Holds if `nd` is a CFG node that can be reached from the start of `ctor`,
 * which is the constructor of a class that has a superclass, without going through
 * a `super` call.
 */
predicate unguarded(ControlFlowNode nd, Function ctor) {
  exists(BasicBlock bb, int i | nd = bb.getNode(i) |
    unguardedBB(bb, ctor) and
    not bb.getNode([0 .. i - 1]) instanceof SuperCall
  )
}

from Expr e, string kind, Function ctor
where
  needsGuard(e, kind) and
  unguarded(e, ctor) and
  // don't flag if there is a super call in a nested arrow function
  not exists(SuperCall sc |
    sc.getBinder() = ctor and
    sc.getEnclosingFunction() != ctor
  )
select ctor.(FirstLineOf), "The super constructor must be called before using '$@'.", e, kind
