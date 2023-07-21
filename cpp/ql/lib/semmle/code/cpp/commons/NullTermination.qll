import cpp
private import semmle.code.cpp.models.interfaces.ArrayFunction
private import semmle.code.cpp.models.implementations.Strcat
private import semmle.code.cpp.ir.dataflow.DataFlow

/**
 * Holds if the expression `e` assigns something including `va` to a
 * stack variable `v0`.
 */
private predicate mayAddNullTerminatorHelper(Expr e, VariableAccess va, StackVariable v0) {
  exists(Expr val |
    exprDefinition(v0, e, val) and // `e` is `v0 := val`
    val.getAChild*() = va
  )
}

bindingset[n1, n2]
private predicate controlFlowNodeSuccessorTransitive(ControlFlowNode n1, ControlFlowNode n2) {
  exists(BasicBlock bb1, int pos1, BasicBlock bb2, int pos2 |
    pragma[only_bind_into](bb1).getNode(pos1) = n1 and
    pragma[only_bind_into](bb2).getNode(pos2) = n2 and
    (
      bb1 = bb2 and pos1 < pos2
      or
      bb1.getASuccessor+() = bb2
    )
  )
}

/**
 * Holds if the expression `e` may add a null terminator to the string
 * accessed by `va`.
 */
predicate mayAddNullTerminator(Expr e, VariableAccess va) {
  // Assignment: dereferencing or array access
  exists(AssignExpr ae | e = ae |
    (
      // *v = x, *v++ = x, etc.
      ae.getLValue().(PointerDereferenceExpr).getOperand().getAChild*() = va
      or
      // v[x] = y
      ae.getLValue().(ArrayExpr).getArrayBase() = va
    ) and
    // Rule out assignments where the assigned value is a non-zero constant
    not ae.getRValue().getFullyConverted().getValue().toInt() != 0
  )
  or
  // Assignment to another stack variable
  exists(StackVariable v0, Expr e0 |
    mayAddNullTerminatorHelper(e, va, v0) and
    mayAddNullTerminator(pragma[only_bind_into](e0), pragma[only_bind_into](v0.getAnAccess())) and
    controlFlowNodeSuccessorTransitive(e, e0)
  )
  or
  // Assignment to non-stack variable
  exists(AssignExpr ae | e = ae |
    not ae.getLValue().(VariableAccess).getTarget() instanceof StackVariable and
    ae.getRValue().getAChild*() = va
  )
  or
  // Function calls...
  exists(Call c, Function f, int i |
    e = c and
    f = c.getTarget() and
    not functionArgumentMustBeNullTerminated(f, i) and
    c.getAnArgumentSubExpr(i) = va
  |
    // library function
    not f.hasEntryPoint()
    or
    // function where the relevant parameter is potentially added a null terminator
    mayAddNullTerminator(_, f.getParameter(i).getAnAccess())
    or
    // varargs function
    f.isVarargs() and i >= f.getNumberOfParameters()
    or
    // function containing assembler code
    exists(AsmStmt s | s.getEnclosingFunction() = f)
    or
    // function where the relevant parameter is returned (leaking it to be potentially null terminated elsewhere)
    DataFlow::localFlow(DataFlow::parameterNode(f.getParameter(i)),
      DataFlow::exprNode(any(ReturnStmt rs).getExpr()))
  )
  or
  // Call without target (e.g., function pointer call)
  exists(Call c |
    e = c and
    not exists(c.getTarget()) and
    c.getAnArgumentSubExpr(_) = va
  )
}

/**
 * Holds if `f` is a (library) function whose `i`th argument must be null
 * terminated.
 */
predicate functionArgumentMustBeNullTerminated(Function f, int i) {
  f.(ArrayFunction).hasArrayWithNullTerminator(i) and
  f.(ArrayFunction).hasArrayInput(i)
  or
  f instanceof StrcatFunction and i = 0
}

/**
 * Holds if `arg` is a string format argument to a formatting function call
 * `ffc`.
 */
predicate formatArgumentMustBeNullTerminated(FormattingFunctionCall ffc, Expr arg) {
  // String argument to a formatting function (such as `printf`)
  exists(int n, FormatLiteral fl |
    ffc.getConversionArgument(n) = arg and
    fl = ffc.getFormat() and
    fl.getConversionType(n) instanceof PointerType and // `%s`, `%ws` etc
    not fl.getConversionType(n) instanceof VoidPointerType and // exclude: `%p`
    not fl.hasPrecision(n) // exclude: `%.*s`
  )
}

/**
 * Holds if `va` is a variable access where the contents must be null terminated.
 */
predicate variableMustBeNullTerminated(VariableAccess va) {
  exists(FunctionCall fc |
    // Call to a function that requires null termination
    exists(int i |
      functionArgumentMustBeNullTerminated(fc.getTarget(), i) and
      fc.getArgument(i) = va
    )
    or
    // String argument to a formatting function (such as `printf`)
    formatArgumentMustBeNullTerminated(fc, va)
    or
    // Call to a wrapper function that requires null termination
    // (not itself adding a null terminator)
    exists(Function wrapper, int i, Parameter p, VariableAccess use |
      fc.getTarget() = wrapper and
      fc.getArgument(i) = va and
      p = wrapper.getParameter(i) and
      parameterUsePair(p, use) and
      variableMustBeNullTerminated(use) and
      // Simplified: check that `p` may not be null terminated on *any*
      // path to `use` (including the one found via `parameterUsePair`)
      not exists(Expr e |
        mayAddNullTerminator(pragma[only_bind_into](e), p.getAnAccess()) and
        controlFlowNodeSuccessorTransitive(e, use)
      )
    )
  )
}
