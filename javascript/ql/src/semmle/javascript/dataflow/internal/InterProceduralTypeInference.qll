/**
 * INTERNAL: Do not use directly; use `semmle.javascript.dataflow.TypeInference` instead.
 *
 * Provides classes implementing type inference across function calls.
 */

import javascript
import AbstractValuesImpl

/**
 * Flow analysis for immediately-invoked function expressions (IIFEs).
 */
private class IifeReturnFlow extends DataFlow::AnalyzedValueNode {
  ImmediatelyInvokedFunctionExpr iife;

  IifeReturnFlow() {
    astNode = (CallExpr)iife.getInvocation()
  }

  override AbstractValue getALocalValue() {
    result = getAReturnValue(iife)
  }
}

/**
 * Gets a return value for the immediately-invoked function expression `f`.
 */
private AbstractValue getAReturnValue(ImmediatelyInvokedFunctionExpr f) {
  // explicit return value
  result = f.getAReturnedExpr().analyze().getALocalValue()
  or
  // implicit return value
  (
    // either because execution of the function may terminate normally
    mayReturnImplicitly(f)
    or
    // or because there is a bare `return;` statement
    exists (ReturnStmt ret | ret = f.getAReturnStmt() | not exists(ret.getExpr()))
  ) and
  result = getDefaultReturnValue(f)
}


/**
 * Holds if the execution of function `f` may complete normally without
 * encountering a `return` or `throw` statement.
 *
 * Note that this is an overapproximation, that is, the predicate may hold
 * of functions that cannot actually complete normally, since it does not
 * account for `finally` blocks and does not check reachability.
 */
private predicate mayReturnImplicitly(Function f) {
  exists (ConcreteControlFlowNode final |
    final.getContainer() = f and
    final.isAFinalNode() and
    not final instanceof ReturnStmt and
    not final instanceof ThrowStmt
  )
}

/**
 * Gets the default return value for immediately-invoked function expression `f`,
 * that is, the value that `f` returns if its execution terminates without
 * encountering an explicit `return` statement.
 */
private AbstractValue getDefaultReturnValue(ImmediatelyInvokedFunctionExpr f) {
  if f.isGenerator() or f.isAsync() then
    result = TAbstractOtherObject()
  else
    result = TAbstractUndefined()
}

/**
 * Flow analysis for `this` expressions inside functions.
 */
private abstract class AnalyzedThisExpr extends DataFlow::AnalyzedValueNode, DataFlow::ThisNode {
  DataFlow::FunctionNode binder;

  AnalyzedThisExpr() {
    binder = getBinder()
  }
}


/**
 * Flow analysis for `this` expressions that are bound with
 * `Function.prototype.bind`, `Function.prototype.call`,
 * `Function.prototype.apply`, or the `::`-operator.
 *
 * However, since the function could be invoked without being `this` being
 * "inherited", we additionally still infer the ordinary abstract value.
 */
private class AnalyzedThisInBoundFunction extends AnalyzedThisExpr {

  AnalyzedValueNode thisSource;

  AnalyzedThisInBoundFunction() {
    exists(string name |
      name = "bind" or name = "call" or name = "apply" |
      thisSource = binder.getAMethodCall(name).getArgument(0)
    )
    or
    exists(FunctionBindExpr binding |
      binder.flowsToExpr(binding.getCallee()) and
      thisSource.asExpr() = binding.getObject()
    )
  }

  override AbstractValue getALocalValue() {
    result = thisSource.getALocalValue() or
    result = AnalyzedThisExpr.super.getALocalValue()
  }

}

/**
 * Flow analysis for `this` expressions inside a function that is instantiated.
 *
 * These expressions are assumed to refer to an instance of that function. Since
 * this is only a heuristic, however, we additionally still infer an indefinite
 * abstract value.
 */
private class AnalyzedThisInConstructorFunction extends AnalyzedThisExpr {
  AbstractValue value;

  AnalyzedThisInConstructorFunction() {
    value = AbstractInstance::of(binder.getFunction())
  }

  override AbstractValue getALocalValue() {
    result = value or
    result = AnalyzedThisExpr.super.getALocalValue()
  }
}

/**
 * Flow analysis for `this` expressions inside an instance member of a class.
 *
 * These expressions are assumed to refer to an instance of that class. This
 * is a safe assumption in practice, but to guard against corner cases we still
 * additionally infer an indefinite abstract value.
 */
private class AnalyzedThisInInstanceMember extends AnalyzedThisExpr {
  ClassDefinition c;

  AnalyzedThisInInstanceMember() {
    exists (MemberDefinition m |
      m = c.getAMember() and
      not m.isStatic() and
      binder = DataFlow::valueNode(c.getAMember().getInit())
    )
  }

  override AbstractValue getALocalValue() {
    result = AbstractInstance::of(c) or
    result = AnalyzedThisExpr.super.getALocalValue()
  }
}

/**
 * Flow analysis for `this` expressions inside a function that is assigned to a property.
 *
 * These expressions are assumed to refer to the object to whose property the function
 * is assigned. Since this is only a heuristic, however, we additionally still infer an
 * indefinite abstract value.
 *
 * The following code snippet shows an example:
 *
 * ```
 * var o = {
 *   p: function() {
 *     this;  // assumed to refer to object literal `o`
 *   }
 * };
 * ```
 */
private class AnalyzedThisInPropertyFunction extends AnalyzedThisExpr {
  DataFlow::AnalyzedNode base;

  AnalyzedThisInPropertyFunction() {
    exists (DataFlow::PropWrite pwn |
      pwn.getRhs() = binder and
      base = pwn.getBase().analyze()
    )
  }

  override AbstractValue getALocalValue() {
    result = base.getALocalValue() or
    result = AnalyzedThisExpr.super.getALocalValue()
  }
}

