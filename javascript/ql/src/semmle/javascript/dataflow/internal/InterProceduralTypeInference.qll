/**
 * INTERNAL: Do not use directly; use `semmle.javascript.dataflow.TypeInference` instead.
 *
 * Provides classes implementing type inference across function calls.
 */

import javascript
import AbstractValuesImpl

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

/**
 * Holds if the execution of function `f` may complete normally without
 * encountering a `return` or `throw` statement.
 *
 * Note that this is an overapproximation, that is, the predicate may hold
 * of functions that cannot actually complete normally, since it does not
 * account for `finally` blocks and does not check reachability.
 */
predicate mayReturnImplicitly(Function f) {
  exists (ConcreteControlFlowNode final |
    final.getContainer() = f and
    final.isAFinalNode() and
    not final instanceof ReturnStmt and
    not final instanceof ThrowStmt
  )
}

/**
 * A call with inter-procedural type inference for the return value.
 */
abstract class CallWithAnalyzedReturnFlow extends DataFlow::CallNode, DataFlow::AnalyzedValueNode {

  /**
   * Gets a called function.
   */
  abstract Function getAFunction();
  
  /**
   * Gets a return value for this call.
   */
  AbstractValue getAReturnValue() {
    exists (Function f | f = getAFunction() |
      if f.isGenerator() or f.isAsync() then
        result = TAbstractOtherObject()
      else (
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
        result = TAbstractUndefined()
      )
    )
  }

  override AbstractValue getALocalValue() {
    result = getAReturnValue()
  }
}

/**
 * Flow analysis for the return value of IIFEs.
 */
private class IIFEWithAnalyzedReturnFlow extends CallWithAnalyzedReturnFlow {
  
  ImmediatelyInvokedFunctionExpr iife;
  
  IIFEWithAnalyzedReturnFlow() {
    this.asExpr() = iife.getInvocation()
  }
  
  override Function getAFunction() {
    result = iife
  }
  
}

/** A function that only is used locally, making it amenable to type inference. */
class LocalFunction extends Function {

  DataFlow::Impl::ExplicitInvokeNode invk;

  LocalFunction() {
    this instanceof FunctionDeclStmt and
    exists (LocalVariable v, Expr callee |
      callee = invk.getCalleeNode().asExpr() and
      v = getVariable() and
      v.getAnAccess() = callee and
      forall(VarAccess o | o = v.getAnAccess() | o = callee) and
      not exists(v.getAnAssignedExpr()) and
      not exists(ExportDeclaration export | export.exportsAs(v, _))
    ) and
    // if the function is non-strict and its `arguments` object is accessed, we
    // also assume that there may be other calls (through `arguments.callee`)
    (isStrict() or not usesArgumentsObject())
  }

  /** Gets an invocation of this function. */
  DataFlow::InvokeNode getAnInvocation() {
    result = invk
  }

}

/**
 * Enables inter-procedural type inference for a call to a `LocalFunction`.
 */
private class LocalFunctionCallWithAnalyzedReturnFlow extends CallWithAnalyzedReturnFlow {

  LocalFunction f;

  LocalFunctionCallWithAnalyzedReturnFlow() {
    this = f.getAnInvocation()
  }

  override Function getAFunction() {
    result = f
  }

}