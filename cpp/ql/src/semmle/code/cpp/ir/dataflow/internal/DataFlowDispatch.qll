private import cpp
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.DataFlow
private import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate

/**
 * Gets a function that might be called by `call`.
 */
Function viableCallable(CallInstruction call) {
  result = call.getStaticCallTarget()
  or
  // If the target of the call does not have a body in the snapshot, it might
  // be because the target is just a header declaration, and the real target
  // will be determined at run time when the caller and callee are linked
  // together by the operating system's dynamic linker. In case a _unique_
  // function with the right signature is present in the database, we return
  // that as a potential callee.
  exists(string qualifiedName, int nparams |
    callSignatureWithoutBody(qualifiedName, nparams, call) and
    functionSignatureWithBody(qualifiedName, nparams, result) and
    strictcount(Function other | functionSignatureWithBody(qualifiedName, nparams, other)) = 1
  )
  or
  // Virtual dispatch
  result = call.(VirtualDispatch::DataSensitiveCall).resolve()
}

/**
 * Provides virtual dispatch support compatible with the original
 * implementation of `semmle.code.cpp.security.TaintTracking`.
 */
private module VirtualDispatch {
  /** A call that may dispatch differently depending on the qualifier value. */
  abstract class DataSensitiveCall extends DataFlowCall {
    /**
     * Gets the node whose value determines the target of this call. This node
     * could be the qualifier of a virtual dispatch or the function-pointer
     * expression in a call to a function pointer. What they have in common is
     * that we need to find out which data flows there, and then it's up to the
     * `resolve` predicate to stitch that information together and resolve the
     * call.
     */
    abstract DataFlow::Node getDispatchValue();

    /** Gets a candidate target for this call. */
    cached
    abstract Function resolve();

    /**
     * Whether `src` can flow to this call.
     *
     * Searches backwards from `getDispatchValue()` to `src`. The `allowFromArg`
     * parameter is true when the search is allowed to continue backwards into
     * a parameter; non-recursive callers should pass `_` for `allowFromArg`.
     */
    predicate flowsFrom(DataFlow::Node src, boolean allowFromArg) {
      src = this.getDispatchValue() and allowFromArg = true
      or
      exists(DataFlow::Node other, boolean allowOtherFromArg |
        this.flowsFrom(other, allowOtherFromArg)
      |
        // Call argument
        exists(DataFlowCall call, int i |
          other.(DataFlow::ParameterNode).isParameterOf(call.getStaticCallTarget(), i) and
          src.(ArgumentNode).argumentOf(call, i)
        ) and
        allowOtherFromArg = true and
        allowFromArg = true
        or
        // Call return
        exists(DataFlowCall call, ReturnKind returnKind |
          other = getAnOutNode(call, returnKind) and
          returnNodeWithKindAndEnclosingCallable(src, returnKind, call.getStaticCallTarget())
        ) and
        allowFromArg = false
        or
        // Local flow
        DataFlow::localFlowStep(src, other) and
        allowFromArg = allowOtherFromArg
        or
        // Flow from global variable to load.
        exists(LoadInstruction load, GlobalOrNamespaceVariable var |
          var = src.asVariable() and
          other.asInstruction() = load and
          addressOfGlobal(load.getSourceAddress(), var) and
          // The `allowFromArg` concept doesn't play a role when `src` is a
          // global variable, so we just set it to a single arbitrary value for
          // performance.
          allowFromArg = true
        )
        or
        // Flow from store to global variable.
        exists(StoreInstruction store, GlobalOrNamespaceVariable var |
          var = other.asVariable() and
          store = src.asInstruction() and
          storeIntoGlobal(store, var) and
          // Setting `allowFromArg` to `true` like in the base case means we
          // treat a store to a global variable like the dispatch itself: flow
          // may come from anywhere.
          allowFromArg = true
        )
      )
    }
  }

  pragma[noinline]
  private predicate storeIntoGlobal(StoreInstruction store, GlobalOrNamespaceVariable var) {
    addressOfGlobal(store.getDestinationAddress(), var)
  }

  /** Holds if `addressInstr` is an instruction that produces the address of `var`. */
  private predicate addressOfGlobal(Instruction addressInstr, GlobalOrNamespaceVariable var) {
    // Access directly to the global variable
    addressInstr.(VariableAddressInstruction).getASTVariable() = var
    or
    // Access to a field on a global union
    exists(FieldAddressInstruction fa |
      fa = addressInstr and
      fa.getObjectAddress().(VariableAddressInstruction).getASTVariable() = var and
      fa.getField().getDeclaringType() instanceof Union
    )
  }

  /**
   * A ReturnNode with its ReturnKind and its enclosing callable.
   *
   * Used to fix a join ordering issue in flowsFrom.
   */
  private predicate returnNodeWithKindAndEnclosingCallable(
    ReturnNode node, ReturnKind kind, DataFlowCallable callable
  ) {
    node.getKind() = kind and
    node.getEnclosingCallable() = callable
  }

  /** Call through a function pointer. */
  private class DataSensitiveExprCall extends DataSensitiveCall {
    DataSensitiveExprCall() { not exists(this.getStaticCallTarget()) }

    override DataFlow::Node getDispatchValue() { result.asInstruction() = this.getCallTarget() }

    override Function resolve() {
      exists(FunctionInstruction fi |
        this.flowsFrom(DataFlow::instructionNode(fi), _) and
        result = fi.getFunctionSymbol()
      ) and
      (
        this.getNumberOfArguments() <= result.getEffectiveNumberOfParameters() and
        this.getNumberOfArguments() >= result.getEffectiveNumberOfParameters()
        or
        result.isVarargs()
      )
    }
  }

  /** Call to a virtual function. */
  private class DataSensitiveOverriddenFunctionCall extends DataSensitiveCall {
    DataSensitiveOverriddenFunctionCall() {
      exists(this.getStaticCallTarget().(VirtualFunction).getAnOverridingFunction())
    }

    override DataFlow::Node getDispatchValue() { result.asInstruction() = this.getThisArgument() }

    override MemberFunction resolve() {
      exists(Class overridingClass |
        this.overrideMayAffectCall(overridingClass, result) and
        this.hasFlowFromCastFrom(overridingClass)
      )
    }

    /**
     * Holds if `this` is a virtual function call whose static target is
     * overridden by `overridingFunction` in `overridingClass`.
     */
    pragma[noinline]
    private predicate overrideMayAffectCall(Class overridingClass, MemberFunction overridingFunction) {
      overridingFunction.getAnOverriddenFunction+() = this.getStaticCallTarget().(VirtualFunction) and
      overridingFunction.getDeclaringType() = overridingClass
    }

    /**
     * Holds if the qualifier of `this` has flow from an upcast from
     * `derivedClass`.
     */
    pragma[noinline]
    private predicate hasFlowFromCastFrom(Class derivedClass) {
      exists(ConvertToBaseInstruction toBase |
        this.flowsFrom(DataFlow::instructionNode(toBase), _) and
        derivedClass = toBase.getDerivedClass()
      )
    }
  }
}

/**
 * Holds if `f` is a function with a body that has name `qualifiedName` and
 * `nparams` parameter count. See `functionSignature`.
 */
private predicate functionSignatureWithBody(string qualifiedName, int nparams, Function f) {
  functionSignature(f, qualifiedName, nparams) and
  exists(f.getBlock())
}

/**
 * Holds if the target of `call` is a function _with no definition_ that has
 * name `qualifiedName` and `nparams` parameter count. See `functionSignature`.
 */
pragma[noinline]
private predicate callSignatureWithoutBody(string qualifiedName, int nparams, CallInstruction call) {
  exists(Function target |
    target = call.getStaticCallTarget() and
    not exists(target.getBlock()) and
    functionSignature(target, qualifiedName, nparams)
  )
}

/**
 * Holds if `f` has name `qualifiedName` and `nparams` parameter count. This is
 * an approximation of its signature for the purpose of matching functions that
 * might be the same across link targets.
 */
private predicate functionSignature(Function f, string qualifiedName, int nparams) {
  qualifiedName = f.getQualifiedName() and
  nparams = f.getNumberOfParameters() and
  not f.isStatic()
}

/**
 * Holds if the set of viable implementations that can be called by `call`
 * might be improved by knowing the call context.
 */
predicate mayBenefitFromCallContext(CallInstruction call, Function f) { none() }

/**
 * Gets a viable dispatch target of `call` in the context `ctx`. This is
 * restricted to those `call`s for which a context might make a difference.
 */
Function viableImplInCallContext(CallInstruction call, CallInstruction ctx) { none() }
