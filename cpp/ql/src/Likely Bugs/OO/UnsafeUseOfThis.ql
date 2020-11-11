/**
 * @name Unsafe use of this in constructor
 * @description A call to a pure virtual function using a this
 *              pointer of an object that is under construction
 *              may lead to undefined behavior.
 * @kind path-problem
 * @id cpp/unsafe-use-of-this
 * @problem.severity error
 * @precision high
 * @tags correctness
 *       language-features
 *       security
 */

import semmle.code.cpp.ir.IR
import cpp

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
  init.getEnclosingFunction() = f and
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
  init.getEnclosingFunction() = f and
  call.getThisArgument() = instr and
  init.getIRVariable() instanceof IRThisVariable
}

/** Holds if `instr` is a `this` pointer of type `c` used by the call instruction `call`. */
predicate isSink(Instruction instr, CallInstruction call, Class c) {
  exists(PureVirtualFunction func |
    call.getStaticCallTarget() = func and
    call.getThisArgument() = instr and
    instr.getResultType().stripType() = c and
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

/** Holds if `instr` flows to a sink. */
predicate flowsToSink(Instruction instr) {
  isSink(instr, _, _)
  or
  exists(Instruction mid |
    successor(instr, mid) and
    flowsToSink(mid)
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

/**
 * Holds if `instr` is an argument (or argument indirection) to a call, and
 * `succ` is the corresponding initialization instruction in the call target.
 */
predicate flowThroughCallable(Instruction instr, Instruction succ) {
  flowsToSink(succ) and
  (
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
      init.getEnclosingFunction() = call.getStaticCallTarget()
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
  )
}

/** Holds if `instr` flows to `succ`. */
predicate successor(Instruction instr, Instruction succ) {
  flowsToSink(succ) and
  (
    irBbPostDominates(succ.getBlock(), instr.getBlock()) and
    (
      succ.(CopyInstruction).getSourceValue() = instr or
      succ.(CheckedConvertOrNullInstruction).getUnary() = instr or
      succ.(ChiInstruction).getTotal() = instr or
      succ.(ConvertInstruction).getUnary() = instr or
      succ.(InheritanceConversionInstruction).getUnary() = instr
    )
    or
    flowThroughCallable(instr, succ)
  )
}

predicate successorTC(Instruction i1, Instruction i2) = fastTC(successor/2)(i1, i2)

/**
 * Holds if:
 * - `source` is an initialization of a `this` pointer of type `sourceClass`, and
 * - `sink` is a use of the `this` pointer as type `sinkClass`, and
 * - `call` invokes a pure virtual function using `sink` as the `this` pointer, and
 * - `msg` is a string describing whether `source` is from a constructor or destructor.
 */
predicate flows(
  Instruction source, string msg, Class sourceClass, Instruction sink, CallInstruction call,
  Class sinkClass
) {
  isSource(source, msg, sourceClass) and
  successorTC(source, sink) and
  isSink(sink, call, sinkClass)
}

query predicate edges(Instruction a, Instruction b) {
  successor(a, b) and flowsFromSource(a) and flowsFromSource(b)
}

query predicate nodes(Instruction n, string key, string val) {
  flowsFromSource(n) and
  flowsToSink(n) and
  key = "semmle.label" and
  val = n.toString()
}

from
  Instruction source, Instruction sink, CallInstruction call, string msg, Class sourceClass,
  Class sinkClass
where
  flows(source, msg, sourceClass, sink, call, sinkClass) and
  sourceClass.getABaseClass+() = sinkClass
select call.getUnconvertedResultExpression(), source, sink,
  "Call to pure virtual function during " + msg
