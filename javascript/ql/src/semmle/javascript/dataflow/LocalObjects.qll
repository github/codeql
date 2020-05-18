/**
 * Provides classes for the local objects that the dataflow library can reason about soundly.
 */

import javascript

/**
 * Holds if the dataflow library can not track flow through `escape` due to `cause`.
 */
private predicate isEscape(DataFlow::Node escape, string cause) {
  escape = any(DataFlow::InvokeNode invk).getAnArgument() and cause = "argument"
  or
  escape = any(DataFlow::FunctionNode fun).getAReturn() and cause = "return"
  or
  escape = any(YieldExpr yield).getOperand().flow() and cause = "yield"
  or
  escape = any(ThrowStmt t).getExpr().flow() and cause = "throw"
  or
  escape = any(GlobalVariable v).getAnAssignedExpr().flow() and cause = "global"
  or
  escape = any(DataFlow::PropWrite write).getRhs() and cause = "heap"
  or
  escape = any(ExportDeclaration e).getSourceNode(_) and cause = "export"
  or
  exists(WithStmt with, Assignment assign |
    with.mayAffect(assign.getLhs()) and
    assign.getRhs().flow() = escape and
    cause = "heap"
  )
}

private DataFlow::Node getAnEscape() { isEscape(result, _) }

/**
 * Holds if `n` can flow to a `this`-variable.
 */
private predicate exposedAsReceiver(DataFlow::SourceNode n) {
  // pragmatic limitation: guarantee for object literals only
  not n instanceof DataFlow::ObjectLiteralNode
  or
  exists(AbstractValue v | n.getAPropertyWrite().getRhs().analyze().getALocalValue() = v |
    v.isIndefinite(_) or
    exists(ThisExpr dis | dis.getBinder() = v.(AbstractCallable).getFunction())
  )
  or
  n.flowsToExpr(any(FunctionBindExpr bind).getObject())
  or
  // technically, the builtin prototypes could have a `this`-using function through which this node escapes, but we ignore that here
  // (we also ignore `o['__' + 'proto__'] = ...`)
  exists(n.getAPropertyWrite("__proto__"))
  or
  // could check the assigned value of all affected variables, but it is unlikely to matter in practice
  exists(WithStmt with | n.flowsToExpr(with.getExpr()))
}

/**
 * An object that is entirely local, in the sense that the dataflow
 * library models all of its flow.
 *
 * All uses of this node are modeled by `this.flowsTo(_)` and related predicates.
 */
class LocalObject extends DataFlow::SourceNode {
  LocalObject() {
    // pragmatic limitation: object literals only
    this instanceof DataFlow::ObjectLiteralNode and
    not flowsTo(getAnEscape()) and
    not exposedAsReceiver(this)
  }

  pragma[nomagic]
  predicate hasOwnProperty(string name) {
    // the property is defined in the initializer,
    any(DataFlow::PropWrite write).writes(this, name, _) and
    // and it is never deleted
    not hasDeleteWithName(name) and
    // and there is no deleted property with computed name
    not hasDeleteWithComputedProperty()
  }

  pragma[noinline]
  private predicate hasDeleteWithName(string name) {
    exists(DeleteExpr del, DataFlow::PropRef ref |
      del.getOperand().flow() = ref and
      flowsTo(ref.getBase()) and
      ref.getPropertyName() = name
    )
  }

  pragma[noinline]
  private predicate hasDeleteWithComputedProperty() {
    exists(DeleteExpr del, DataFlow::PropRef ref |
      del.getOperand().flow() = ref and
      flowsTo(ref.getBase()) and
      not exists(ref.getPropertyName())
    )
  }
}
