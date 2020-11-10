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

predicate irBbFunctionExit(IRBlock exit) {
  exit.getLastInstruction() instanceof ExitFunctionInstruction
}

predicate irBbNodePred(IRBlock src, IRBlock pred) { src.getAPredecessor() = pred }

predicate irBbIPostDominates(IRBlock postDominator, IRBlock node) =
  idominance(irBbFunctionExit/1, irBbNodePred/2)(_, postDominator, node)

predicate irBbStrictlyPostDominates(IRBlock postDominator, IRBlock node) {
  irBbIPostDominates+(postDominator, node)
}

/**
 * Holds if `postDominator` is a post-dominator of `node` in the control-flow graph. This
 * is reflexive.
 */
predicate irBbPostDominates(IRBlock postDominator, IRBlock node) {
  irBbStrictlyPostDominates(postDominator, node) or postDominator = node
}

bindingset[n, result]
int unbind(int n) { result >= n and result <= n }

/** Holds if `p` is the `n`'th parameter of function `f`. */
predicate parameterOf(Parameter p, Function f, int n) { p.getFunction() = f and p.getIndex() = n }

/**
 * Holds if `instr` is the `n`'th argument to a call to the function `f`, and
 * `init` is the corresponding initiazation instruction that receives the value of
 * `instr` in `f`.
 */
predicate flowIntoParameter(
  CallInstruction call, Instruction instr, Function f, int n, InitializeParameterInstruction init
) {
  call.getPositionalArgument(n) = instr and
  f = call.getStaticCallTarget() and
  init.getEnclosingFunction() = f
}

/**
 * Holds if `instr` is an argument to a call to the function `f`, and
 * `init` is the corresponding initiazation instruction that receives the value of
 * `instr` in `f`.
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
 * Holds if `instr` is the qualifier to a call to the function `f`, and
 * `init` is the corresponding initiazation instruction that receives the value of
 * `instr` in `f`.
 */
pragma[noinline]
predicate getThisArgumentInitParam(
  CallInstruction call, Instruction instr, InitializeParameterInstruction init, Function f
) {
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

/**
 * Holds if `instr` flows to the sink instruction `sink` that is a `this`
 * pointer of type `sinkClass`
 */
predicate flowsToSink(Instruction instr, Instruction sink, Class sinkClass) {
  instr = sink and
  isSink(sink, _, sinkClass)
  or
  exists(Instruction mid |
    successor(instr, mid, sinkClass) and
    flowsToSink(mid, sink, sinkClass)
  )
}

/**
 * Holds if `source` is an initialization of a `this` pointer of type `sourceClass`, and
 * `source` flows to instruction `instr`.
 */
predicate flowsFromSource(Instruction source, Instruction instr, Class sourceClass) {
  source = instr and
  isSource(source, _, sourceClass)
  or
  exists(Instruction mid |
    successorFwd(mid, instr, sourceClass) and
    flowsFromSource(source, mid, sourceClass)
  )
}

/**
 * Holds if
 * - `instr` is an argument (or argument indirection) to a call, and
 * - `succ` is the corresponding initialization instruction in the call target, and
 * - `succ` eventually flows to an instruction that is used as a `this` pointer of type `sinkClass`.
 */
predicate flowThroughCallable(Instruction instr, Instruction succ, Class sinkClass) {
  flowsToSink(succ, _, sinkClass) and
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

/**
 * Holds if `instr` flows to `succ` and `succ` eventually flows to an instruction that is used
 * as a `this` pointer of type `sinkClass`.
 */
predicate successor(Instruction instr, Instruction succ, Class sinkClass) {
  flowsToSink(succ, _, sinkClass) and
  (
    irBbPostDominates(succ.getBlock(), instr.getBlock()) and
    (
      (
        succ.(CopyInstruction).getSourceValue() = instr or
        succ.(CheckedConvertOrNullInstruction).getUnary() = instr or
        succ.(ChiInstruction).getTotal() = instr or
        succ.(ConvertInstruction).getUnary() = instr
      )
      or
      succ.(InheritanceConversionInstruction).getUnary() = instr
    )
    or
    flowThroughCallable(instr, succ, sinkClass)
  )
}

/**
 * Holds if
 * - `instr` is an argument (or argument indirection) to a call, and
 * - `succ` is the corresponding initialization instruction in the call target, and
 * - there exists an initialization of a `this` pointer of type `sourceClass` that flows to `instr`.
 */
predicate flowThroughCallableFwd(Instruction instr, Instruction succ, Class sourceClass) {
  flowsFromSource(_, instr, sourceClass) and
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
      init.getEnclosingFunction() = call.getStaticCallTarget() and
      read.getPrimaryInstruction() = call and
      read.getSideEffectOperand().getAnyDef() = instr
    |
      exists(int n |
        read.getIndex() = n and
        init.getParameter().getIndex() = unbind(n)
      )
      or
      call.getThisArgument() = instr and
      init.getIRVariable() instanceof IRThisVariable
    )
  )
}

/**
 * Holds if there exists an initialization of a `this` pointer of type `sourceClass` that flows
 * to `instr`, and `instr` flows to `succ` and `succ`.
 */
predicate successorFwd(Instruction instr, Instruction succ, Class sourceClass) {
  flowsFromSource(_, instr, sourceClass) and
  (
    irBbPostDominates(succ.getBlock(), instr.getBlock()) and
    (
      (
        succ.(CopyInstruction).getSourceValue() = instr or
        succ.(CheckedConvertOrNullInstruction).getUnary() = instr or
        succ.(ChiInstruction).getTotal() = instr or
        succ.(ConvertInstruction).getUnary() = instr
      )
      or
      succ.(InheritanceConversionInstruction).getUnary() = instr
    )
    or
    flowThroughCallableFwd(instr, succ, sourceClass)
  )
}

/**
 * Holds if `instr` is in the path from an initialization of a `this` pointer in a subclass, to a use
 * of the `this` pointer in a baseclass.
 */
predicate isInPath(Instruction instr) {
  exists(Class sourceClass, Class sinkClass |
    flowsFromSource(_, instr, sourceClass) and
    flowsToSink(instr, _, sinkClass) and
    sourceClass.getABaseClass+() = sinkClass
  )
}

query predicate edges(Instruction a, Instruction b) { successor(a, b, _) }

query predicate nodes(Instruction n, string key, string val) {
  isInPath(n) and key = "semmle.label" and val = n.toString()
}

from
  Instruction source, Instruction sink, CallInstruction call, string msg, Class sourceClass,
  Class sinkClass
where
  isSource(source, msg, sourceClass) and
  flowsToSink(source, sink, sinkClass) and
  isSink(sink, call, sinkClass) and
  sourceClass.getABaseClass+() = sinkClass
select call.getUnconvertedResultExpression(), source, sink,
  "Call to pure virtual function during " + msg
