/**
 * Provides utilities for determining which expressions contain
 * stack addresses.
 */

import cpp
import semmle.code.cpp.controlflow.SSA

/**
 * A stack address flows to `use`.
 * The simplest case is when `use` is the expression `&var`, but
 * assignments are also handled. For example:
 *
 *    x = &var;
 *    y = x;
 *    ...y...   // use of &var
 *
 * `useType` is the type of data which we believe was allocated on the
 * stack. It is particularly important when dealing with pointers. Consider
 * this example:
 *
 *     int x[10];
 *     int *y = new int[10];
 *     ... = &x[1];
 *     ... = &y[1];
 *
 * In this example, x and y are both stack variables. But &x[1] is a
 * pointer to the stack and &y[1] is a pointer to the heap.  The difference
 * is that the type of x is int[10], but the type of y is int*. This
 * information is stored in `useType`.
 *
 * `source` is the origin of the stack address. It is only used to improve
 * the quality of the error messages.
 *
 * `isLocal` is true if the stack address came from the current
 * function. It is false if the stack address arrived via a function
 * parameter. This information is only used to improve the quality of the
 * error messages.
 */
predicate stackPointerFlowsToUse(Expr use, Type useType, Expr source, boolean isLocal) {
  // Arrays in C are convertible to pointers. For example, if the type of x
  // is int[10] then it is convertible to int*. The same rule applies to
  // multidimensional arrays: if the type of y is int[2][3][4], then it is
  // convertible to int(*)[3][4]. This conversion is what happens under the
  // hood when we index an array. For example, x[5] is equivalent to
  // *(x+5), so x is first converted to a pointer and then the pointer
  // arithmetic is applied to the pointer.
  exists(ArrayType arrayType |
    stackReferenceFlowsToUse(use, arrayType, source, isLocal) and
    useType = getExprPtrType(use.getConversion()).getBaseType()
  )
  or
  // Address of: &x
  stackReferenceFlowsToUse(use.(AddressOfExpr).getOperand(), useType, source, isLocal)
  or
  // Pointer subtract: if p is a pointer to a stack address, then p-1 is
  // too.
  stackPointerFlowsToUse(use.(PointerSubExpr).getLeftOperand(), useType, source, isLocal)
  or
  // Pointer add: if p is a pointer to a stack address, then p+1 is too.
  stackPointerFlowsToUse(use.(PointerAddExpr).getAnOperand(), useType, source, isLocal)
  or
  // Indirect use of a stack address.
  exists(SsaDefinition def, StackVariable var |
    stackPointerFlowsToDef(def, var, useType, source, isLocal) and
    use = def.getAUse(var)
  )
  or
  // Use of a stack address which arrived via one of the function's
  // parameters. We do not use the original pointer source here because it
  // could lead to an extremely large number of results if the function has
  // many callers. Instead we set `source` to the use of the parameter.
  exists(SsaDefinition def, Parameter param |
    pointerParamFlowsToDef(def, param, useType) and
    use = def.getAUse(param) and
    source = use and
    isLocal = false
  )
  or
  // Similar to the parameter case above. If a member function is called
  // on an object which is allocated on the stack, then the "this" pointer
  // contains a stack address.
  exists(ThisExpr thisExpr |
    use = thisExpr and
    memberFcnMightRunOnStack(thisExpr.getEnclosingFunction(), useType) and
    source = use and
    isLocal = false
  )
}

/**
 * Helper function for stackPointerFlowsToUse. Gets the type of a pointer
 * expression.
 */
cached
private PointerType getExprPtrType(Expr use) { result = use.getUnspecifiedType() }

predicate stackReferenceFlowsToUse(Expr use, Type useType, Expr source, boolean isLocal) {
  // Stack variables
  exists(StackVariable var |
    use = source and
    source = var.getAnAccess() and
    isLocal = true and
    // If the type of the variable is a reference type, such as int&, then
    // we need to look at its definition to determine whether it contains a
    // stack reference. This is handled by stackReferenceFlowsToDef, below.
    not isReferenceVariable(var) and
    // There is a subtlety relating to ArrayType which is hidden by the
    // simplicity of the line below. Consider this example:
    //
    //     int arraytest(int p[3][4][5]) {
    //       int x[3][4][5] = { ... };
    //       return x[1][2][3] + p[1][2][3];
    //     }
    //
    // The types of `x` and `p` are the same, but `x` is stack allocated
    // and `p` is not. So we want `useType` to be an ArrayType for `x` and
    // a PointerType for `p`. Luckily, this conversion happens
    // automatically when the variable is used. So we get the correct type
    // provided that we get it from `use` rather than from `var`.
    useType = use.getUnspecifiedType()
  )
  or
  // Accessing the field of a class, struct, or union.
  exists(FieldAccess access, Class classType |
    use = access and useType = access.getUnspecifiedType()
  |
    // Handle both x.f and x->f:
    stackReferenceFlowsToUse(access.getQualifier(), classType, source, isLocal) or
    stackPointerFlowsToUse(access.getQualifier(), classType, source, isLocal)
  )
  or
  // Array indexing: x[i].
  // Note that array types are converted to pointers in
  // stackPointerFlowsToUse.
  stackPointerFlowsToUse(use.(ArrayExpr).getArrayBase(), useType, source, isLocal)
  or
  // Pointer dereference: *x
  stackPointerFlowsToUse(use.(PointerDereferenceExpr).getOperand(), useType, source, isLocal)
  or
  // Indirect use of a stack reference, via a reference variable.
  exists(SsaDefinition def, StackVariable var |
    stackReferenceFlowsToDef(def, var, useType, source, isLocal) and
    use = def.getAUse(var)
  )
  or
  // Use of a stack reference which arrived via one of the function's
  // parameters. We do not use the original reference source here because
  // it could lead to an extremely large number of results if the function
  // has many callers. Instead we set `source` to the use of the parameter.
  exists(SsaDefinition def, Parameter param |
    referenceParamFlowsToDef(def, param, useType) and
    use = def.getAUse(param) and
    source = use and
    isLocal = false
  )
}

/**
 * Helper predicate for stackPointerFlowsToUse. Tracks the flow of stack
 * addresses through SSA definitions.
 */
predicate stackPointerFlowsToDef(
  SsaDefinition def, StackVariable var, Type useType, Expr source, boolean isLocal
) {
  stackPointerFlowsToUse(def.getDefiningValue(var), useType, source, isLocal)
  or
  // Increment/decrement operators.
  exists(VariableAccess access |
    access = def.(CrementOperation).getOperand() and
    var = access.getTarget() and
    stackPointerFlowsToUse(access, useType, source, isLocal)
  )
  or
  // Transitive closure over phi definitions.
  stackPointerFlowsToDef(def.getAPhiInput(var), var, useType, source, isLocal)
}

/**
 * Helper predicate for stackPointerFlowsToUse. Tracks the flow of stack
 * references through SSA definitions. This predicate is almost identical
 * to stackPointerFlowsToDef, except it handles references types, such as
 * int&, rather than pointers.
 */
predicate stackReferenceFlowsToDef(
  SsaDefinition def, StackVariable var, Type useType, Expr source, boolean isLocal
) {
  // Check that the type of the variable is a reference type and delegate
  // the rest of the work to stackReferenceFlowsToDef_Impl.
  isReferenceVariable(var) and
  stackReferenceFlowsToDef_Impl(def, var, useType, source, isLocal)
}

/**
 * stackReferenceFlowsToDef delegates most of the work to this
 * predicate.
 */
predicate stackReferenceFlowsToDef_Impl(
  SsaDefinition def, StackVariable var, Type useType, Expr source, boolean isLocal
) {
  stackReferenceFlowsToUse(def.getDefiningValue(var), useType, source, isLocal)
  or
  // Increment/decrement operators.
  exists(VariableAccess access |
    access = def.(CrementOperation).getOperand() and
    var = access.getTarget() and
    stackReferenceFlowsToUse(access, useType, source, isLocal)
  )
  or
  // Transitive closure over phi definitions.
  stackReferenceFlowsToDef(def.getAPhiInput(var), var, useType, source, isLocal)
}

/** The type of the variable is a reference type, such as int&. */
predicate isReferenceVariable(StackVariable var) {
  var.getUnspecifiedType() instanceof ReferenceType
}

/**
 * Helper predicate for stackPointerFlowsToUse. Tracks the flow of stack
 * addresses which arrived through one of the function's parameters. This
 * predicate is very similar to stackPointerFlowsToDef but they cannot be
 * merged, because we cannot identify a sensible source expression here.
 */
predicate pointerParamFlowsToDef(SsaDefinition def, Parameter param, Type useType) {
  // Only include a parameter definition if we can find a call site which
  // might pass it a stack address.
  exists(FunctionCall call |
    call.getTarget() = param.getFunction() and
    stackPointerFlowsToUse(call.getArgument(param.getIndex()), useType, _, _) and
    def.definedByParameter(param)
  )
  or
  // Transitive closure over phi definitions.
  pointerParamFlowsToDef(def.getAPhiInput(param), param, useType)
}

/**
 * Helper predicate for stackPointerFlowsToUse. Tracks the flow of stack
 * addresses which arrived through one of the function's parameters. This
 * predicate is very similar to stackPointerFlowsToDef but they cannot be
 * merged, because we cannot identify a sensible source expression here.
 */
predicate referenceParamFlowsToDef(SsaDefinition def, Parameter param, Type useType) {
  // Only include a parameter definition if we can find a call site which
  // might pass it a stack reference.
  exists(FunctionCall call |
    call.getTarget() = param.getFunction() and
    stackReferenceFlowsToUse(call.getArgument(param.getIndex()), useType, _, _) and
    def.definedByParameter(param)
  )
  or
  // Transitive closure over phi definitions.
  referenceParamFlowsToDef(def.getAPhiInput(param), param, useType)
}

/**
 * Holds if this member function might be called on an object which
 * is allocated on the stack.
 */
predicate memberFcnMightRunOnStack(MemberFunction fcn, Type useType) {
  exists(FunctionCall call | call.getTarget() = fcn |
    // Call of the form `x.f()` where `x` is allocated on the stack.
    stackReferenceFlowsToUse(call.getQualifier(), useType, _, _)
    or
    // Call of the form `x->f()` where `x` is allocated on the stack.
    stackPointerFlowsToUse(call.getQualifier(), useType, _, _)
  )
  or
  // Constructor calls need to be treated as a special case, because
  // `call.getQualifier()` is empty.
  constructorMightRunOnStack(fcn) and
  useType = fcn.getDeclaringType().getUnspecifiedType()
}

/**
 * Helper predicate for memberFcnMightRunOnStack. Function calls
 * to constructors need to be treated as a special case, because
 * `call.getQualifier()` is empty. Instead, we need to check whether
 * the constructor is called from an initializer. There are several
 * kinds of initializers to consider.
 */
predicate constructorMightRunOnStack(Constructor constructor) {
  exists(ConstructorCall call | call.getTarget() = constructor |
    // Call to a constructor from a stack variable's initializer.
    exists(StackVariable var | var.getInitializer().getExpr() = call)
    or
    // Call to a constructor from another constructor which might
    // also run on the stack.
    constructorMightRunOnStack(call.getEnclosingFunction()) and
    (
      call instanceof ConstructorDirectInit or
      call instanceof ConstructorVirtualInit or
      call instanceof ConstructorDelegationInit or
      exists(ConstructorFieldInit init | init.getExpr() = call)
    )
  )
}
