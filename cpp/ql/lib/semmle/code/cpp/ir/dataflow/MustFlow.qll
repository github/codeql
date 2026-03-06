/**
 * This file provides a library for inter-procedural must-flow data flow analysis.
 * Unlike `DataFlow.qll`, the analysis provided by this file checks whether data _must_ flow
 * from a source to a _sink_.
 */

private import cpp
private import semmle.code.cpp.ir.IR

/**
 * Provides an inter-procedural must-flow data flow analysis.
 */
module MustFlow {
  /**
   * An input configuration of a data flow analysis that performs must-flow analysis. This is different
   * from `DataFlow.qll` which performs may-flow analysis (i.e., it finds paths where the source _may_
   * flow to the sink).
   */
  signature module ConfigSig {
    /**
     * Holds if `source` is a relevant data flow source.
     */
    predicate isSource(Instruction source);

    /**
     * Holds if `sink` is a relevant data flow sink.
     */
    predicate isSink(Operand sink);

    /**
     * Holds if data flow through `instr` is prohibited.
     */
    default predicate isBarrier(Instruction instr) { none() }

    /**
     * Holds if the additional flow step from `node1` to `node2` must be taken
     * into account in the analysis.
     */
    default predicate isAdditionalFlowStep(Operand node1, Instruction node2) { none() }

    /** Holds if this configuration allows flow from arguments to parameters. */
    default predicate allowInterproceduralFlow() { any() }
  }

  /**
   * Constructs a global must-flow computation.
   */
  module Global<ConfigSig Config> {
    import Config

    /**
     * Holds if data must flow from `source` to `sink`.
     *
     * The corresponding paths are generated from the end-points and the graph
     * included in the module `PathGraph`.
     */
    predicate flowPath(PathNode source, PathSink sink) {
      isSource(source.getInstruction()) and
      source.getASuccessor*() = sink
    }

    /** Holds if `node` flows from a source. */
    pragma[nomagic]
    private predicate flowsFromSource(Instruction node) {
      not isBarrier(node) and
      (
        isSource(node)
        or
        exists(Instruction mid |
          step(mid, node) and
          flowsFromSource(mid)
        )
      )
    }

    /** Holds if `node` flows to a sink. */
    pragma[nomagic]
    private predicate flowsToSink(Instruction node) {
      flowsFromSource(node) and
      (
        isSink(node.getAUse())
        or
        exists(Instruction mid |
          step(node, mid) and
          flowsToSink(mid)
        )
      )
    }

    /** Holds if `nodeFrom` flows to `nodeTo`. */
    private predicate step(Instruction nodeFrom, Instruction nodeTo) {
      Cached::localStep(nodeFrom, nodeTo)
      or
      allowInterproceduralFlow() and
      Cached::flowThroughCallable(nodeFrom, nodeTo)
      or
      isAdditionalFlowStep(nodeFrom.getAUse(), nodeTo)
    }

    private newtype TLocalPathNode =
      MkLocalPathNode(Instruction n) {
        flowsToSink(n) and
        (
          isSource(n)
          or
          exists(PathNode mid | step(mid.getInstruction(), n))
        )
      }

    /** A `Node` that is in a path from a source to a sink. */
    class PathNode extends TLocalPathNode {
      Instruction n;

      PathNode() { this = MkLocalPathNode(n) }

      /** Gets the underlying node. */
      Instruction getInstruction() { result = n }

      /** Gets a textual representation of this node. */
      string toString() { result = n.getAst().toString() }

      /** Gets the location of this element. */
      Location getLocation() { result = n.getLocation() }

      /** Gets a successor node, if any. */
      PathNode getASuccessor() { step(this.getInstruction(), result.getInstruction()) }
    }

    private class PathSink extends PathNode {
      PathSink() { isSink(this.getInstruction().getAUse()) }
    }

    /**
     * Provides the query predicates needed to include a graph in a path-problem query.
     */
    module PathGraph {
      private predicate reach(PathNode n) { n instanceof PathSink or reach(n.getASuccessor()) }

      /** Holds if `(a,b)` is an edge in the graph of data flow path explanations. */
      query predicate edges(PathNode a, PathNode b) { a.getASuccessor() = b and reach(b) }

      /** Holds if `n` is a node in the graph of data flow path explanations. */
      query predicate nodes(PathNode n, string key, string val) {
        reach(n) and key = "semmle.label" and val = n.toString()
      }
    }
  }
}

cached
private module Cached {
  /** Holds if `p` is the `n`'th parameter of the non-virtual function `f`. */
  private predicate parameterOf(Parameter p, Function f, int n) {
    not f.isVirtual() and f.getParameter(n) = p
  }

  /**
   * Holds if `instr` is the `n`'th argument to a call to the non-virtual function `f`, and
   * `init` is the corresponding initialization instruction that receives the value of `instr` in `f`.
   */
  private predicate flowIntoParameter(
    Function f, int n, CallInstruction call, Instruction instr, InitializeParameterInstruction init
  ) {
    not f.isVirtual() and
    call.getPositionalArgument(n) = instr and
    f = call.getStaticCallTarget() and
    isEnclosingNonVirtualFunctionInitializeParameter(init, f) and
    init.getParameter().getIndex() = pragma[only_bind_into](pragma[only_bind_out](n))
  }

  /**
   * Holds if `instr` is an argument to a call to the function `f`, and `init` is the
   * corresponding initialization instruction that receives the value of `instr` in `f`.
   */
  pragma[noinline]
  private predicate isPositionalArgumentInitParam(
    CallInstruction call, Instruction instr, InitializeParameterInstruction init, Function f
  ) {
    exists(int n |
      parameterOf(_, f, n) and
      flowIntoParameter(f, pragma[only_bind_into](pragma[only_bind_out](n)), call, instr, init)
    )
  }

  /**
   * Holds if `instr` is the qualifier to a call to the non-virtual function `f`, and
   * `init` is the corresponding initialization instruction that receives the value of
   * `instr` in `f`.
   */
  pragma[noinline]
  private predicate isThisArgumentInitParam(
    CallInstruction call, Instruction instr, InitializeParameterInstruction init, Function f
  ) {
    not f.isVirtual() and
    call.getStaticCallTarget() = f and
    isEnclosingNonVirtualFunctionInitializeParameter(init, f) and
    call.getThisArgument() = instr and
    init.getIRVariable() instanceof IRThisVariable
  }

  /** Holds if `f` is the enclosing non-virtual function of `init`. */
  private predicate isEnclosingNonVirtualFunctionInitializeParameter(
    InitializeParameterInstruction init, Function f
  ) {
    not f.isVirtual() and
    init.getEnclosingFunction() = f
  }

  /** Holds if `f` is the enclosing non-virtual function of `init`. */
  private predicate isEnclosingNonVirtualFunctionInitializeIndirection(
    InitializeIndirectionInstruction init, Function f
  ) {
    not f.isVirtual() and
    init.getEnclosingFunction() = f
  }

  /**
   * Holds if `argument` is an argument (or argument indirection) to a call, and
   * `parameter` is the corresponding initialization instruction in the call target.
   */
  cached
  predicate flowThroughCallable(Instruction argument, Instruction parameter) {
    // Flow from an argument to a parameter
    exists(CallInstruction call, InitializeParameterInstruction init | init = parameter |
      isPositionalArgumentInitParam(call, argument, init, call.getStaticCallTarget())
      or
      isThisArgumentInitParam(call, argument, init, call.getStaticCallTarget())
    )
    or
    // Flow from argument indirection to parameter indirection
    exists(
      CallInstruction call, ReadSideEffectInstruction read, InitializeIndirectionInstruction init
    |
      init = parameter and
      read.getPrimaryInstruction() = call and
      isEnclosingNonVirtualFunctionInitializeIndirection(init, call.getStaticCallTarget())
    |
      exists(int n |
        read.getSideEffectOperand().getAnyDef() = argument and
        read.getIndex() = pragma[only_bind_into](n) and
        init.getParameter().getIndex() = pragma[only_bind_into](n)
      )
      or
      call.getThisArgument() = argument and
      init.getIRVariable() instanceof IRThisVariable
    )
  }

  private predicate instructionToOperandStep(Instruction instr, Operand operand) {
    operand.getDef() = instr
  }

  /**
   * Holds if data flows from `operand` to `instr`.
   *
   * This predicate ignores flow through `PhiInstruction`s to create a 'must flow' relation.
   */
  private predicate operandToInstructionStep(Operand operand, Instruction instr) {
    instr.(CopyInstruction).getSourceValueOperand() = operand
    or
    instr.(ConvertInstruction).getUnaryOperand() = operand
    or
    instr.(CheckedConvertOrNullInstruction).getUnaryOperand() = operand
    or
    instr.(InheritanceConversionInstruction).getUnaryOperand() = operand
    or
    instr.(ChiInstruction).getTotalOperand() = operand
  }

  cached
  predicate localStep(Instruction nodeFrom, Instruction nodeTo) {
    exists(Operand mid |
      instructionToOperandStep(nodeFrom, mid) and
      operandToInstructionStep(mid, nodeTo)
    )
  }
}
