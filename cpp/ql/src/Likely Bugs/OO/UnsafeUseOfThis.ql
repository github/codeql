/**
 * @name Unsafe use of this in constructor
 * @description A call to a pure virtual function using a 'this'
 *              pointer of an object that is under construction
 *              may lead to undefined behavior.
 * @kind path-problem
 * @id cpp/unsafe-use-of-this
 * @problem.severity error
 * @security-severity 3.6
 * @precision very-high
 * @tags correctness
 *       language-features
 *       security
 *       external/cwe/cwe-670
 */

import cpp
// We don't actually use the global value numbering library in this query, but without it we end up
// recomputing the IR.
private import semmle.code.cpp.valuenumbering.GlobalValueNumbering
private import semmle.code.cpp.ir.IR

bindingset[n, result]
int unbind(int n) { result >= n and result <= n }

/** Holds if `p` is the `n`'th parameter of the non-virtual function `f`. */
predicate parameterOf(Parameter p, Function f, int n) {
  not f.isVirtual() and f.getParameter(n) = p
}

/**
 * Holds if `instr` is the `n`'th argument to a call to the non-virtual function `f`, and
 * `init` is the corresponding initiazation instruction that receives the value of `instr` in `f`.
 */
predicate flowIntoParameter(
  CallInstruction call, Instruction instr, Function f, int n, InitializeParameterInstruction init
) {
  not f.isVirtual() and
  call.getPositionalArgument(n) = instr and
  f = call.getStaticCallTarget() and
  getEnclosingNonVirtualFunctionInitializeParameter(init, f) and
  init.getParameter().getIndex() = unbind(n)
}

/**
 * Holds if `instr` is an argument to a call to the function `f`, and `init` is the
 * corresponding initialization instruction that receives the value of `instr` in `f`.
 */
pragma[noinline]
predicate getPositionalArgumentInitParam(
  CallInstruction call, Instruction instr, InitializeParameterInstruction init, Function f
) {
  exists(int n |
    parameterOf(_, f, n) and
    flowIntoParameter(call, instr, f, unbind(n), init)
  )
}

/**
 * Holds if `instr` is the qualifier to a call to the non-virtual function `f`, and
 * `init` is the corresponding initiazation instruction that receives the value of
 * `instr` in `f`.
 */
pragma[noinline]
predicate getThisArgumentInitParam(
  CallInstruction call, Instruction instr, InitializeParameterInstruction init, Function f
) {
  not f.isVirtual() and
  call.getStaticCallTarget() = f and
  getEnclosingNonVirtualFunctionInitializeParameter(init, f) and
  call.getThisArgument() = instr and
  init.getIRVariable() instanceof IRThisVariable
}

/** Holds if `instr` is a `this` pointer used by the call instruction `call`. */
predicate isSink(Instruction instr, CallInstruction call) {
  exists(PureVirtualFunction func |
    call.getStaticCallTarget() = func and
    call.getThisArgument() = instr and
    // Weed out implicit calls to destructors of a base class
    not func instanceof Destructor
  )
}

/** Holds if `init` initializes the `this` pointer in class `c`. */
predicate isSource(InitializeParameterInstruction init, string msg, Class c) {
  (
    exists(Constructor func |
      not func instanceof CopyConstructor and
      not func instanceof MoveConstructor and
      func = init.getEnclosingFunction() and
      msg = "construction"
    )
    or
    init.getEnclosingFunction() instanceof Destructor and msg = "destruction"
  ) and
  init.getIRVariable() instanceof IRThisVariable and
  init.getEnclosingFunction().getDeclaringType() = c
}

/**
 * Holds if `instr` flows to a sink (which is a use of the value of `instr` as a `this` pointer).
 */
predicate flowsToSink(Instruction instr, Instruction sink) {
  flowsFromSource(instr) and
  (
    isSink(instr, _) and instr = sink
    or
    exists(Instruction mid |
      successor(instr, mid) and
      flowsToSink(mid, sink)
    )
  )
}

/** Holds if `instr` flows from a source. */
predicate flowsFromSource(Instruction instr) {
  isSource(instr, _, _)
  or
  exists(Instruction mid |
    successor(mid, instr) and
    flowsFromSource(mid)
  )
}

/** Holds if `f` is the enclosing non-virtual function of `init`. */
predicate getEnclosingNonVirtualFunctionInitializeParameter(
  InitializeParameterInstruction init, Function f
) {
  not f.isVirtual() and
  init.getEnclosingFunction() = f
}

/** Holds if `f` is the enclosing non-virtual function of `init`. */
predicate getEnclosingNonVirtualFunctionInitializeIndirection(
  InitializeIndirectionInstruction init, Function f
) {
  not f.isVirtual() and
  init.getEnclosingFunction() = f
}

/**
 * Holds if `instr` is an argument (or argument indirection) to a call, and
 * `succ` is the corresponding initialization instruction in the call target.
 */
predicate flowThroughCallable(Instruction instr, Instruction succ) {
  // Flow from an argument to a parameter
  exists(CallInstruction call, InitializeParameterInstruction init | init = succ |
    getPositionalArgumentInitParam(call, instr, init, call.getStaticCallTarget())
    or
    getThisArgumentInitParam(call, instr, init, call.getStaticCallTarget())
  )
  or
  // Flow from argument indirection to parameter indirection
  exists(
    CallInstruction call, ReadSideEffectInstruction read, InitializeIndirectionInstruction init
  |
    init = succ and
    read.getPrimaryInstruction() = call and
    getEnclosingNonVirtualFunctionInitializeIndirection(init, call.getStaticCallTarget())
  |
    exists(int n |
      read.getSideEffectOperand().getAnyDef() = instr and
      read.getIndex() = n and
      init.getParameter().getIndex() = unbind(n)
    )
    or
    call.getThisArgument() = instr and
    init.getIRVariable() instanceof IRThisVariable
  )
}

/** Holds if `instr` flows to `succ`. */
predicate successor(Instruction instr, Instruction succ) {
  succ.(CopyInstruction).getSourceValue() = instr or
  succ.(CheckedConvertOrNullInstruction).getUnary() = instr or
  succ.(ChiInstruction).getTotal() = instr or
  succ.(ConvertInstruction).getUnary() = instr or
  succ.(InheritanceConversionInstruction).getUnary() = instr or
  flowThroughCallable(instr, succ)
}

/**
 * Holds if:
 * - `source` is an initialization of a `this` pointer of type `sourceClass`, and
 * - `sink` is a use of the `this` pointer, and
 * - `call` invokes a pure virtual function using `sink` as the `this` pointer, and
 * - `msg` is a string describing whether `source` is from a constructor or destructor.
 */
predicate flows(
  Instruction source, string msg, Class sourceClass, Instruction sink, CallInstruction call
) {
  isSource(source, msg, sourceClass) and
  flowsToSink(source, sink) and
  isSink(sink, call)
}

query predicate edges(Instruction a, Instruction b) { successor(a, b) and flowsToSink(b, _) }

query predicate nodes(Instruction n, string key, string val) {
  flowsToSink(n, _) and
  key = "semmle.label" and
  val = n.toString()
}

from Instruction source, Instruction sink, CallInstruction call, string msg, Class sourceClass
where
  flows(source, msg, sourceClass, sink, call) and
  // Only raise an alert if there is no override of the pure virtual function in any base class.
  not exists(Class c | c = sourceClass.getABaseClass*() |
    c.getAMemberFunction().getAnOverriddenFunction() = call.getStaticCallTarget()
  )
select call.getUnconvertedResultExpression(), source, sink,
  "Call to pure virtual function during " + msg
