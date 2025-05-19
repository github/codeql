private import codeql.dataflow.DataFlow as DF
private import codeql.dataflow.TaintTracking as TT
private import codeql.util.Location

signature module TaintTrackingStackSig<
  LocationSig Location, DF::InputSig<Location> Lang, TT::InputSig<Location, Lang> TTLang,
  DF::Configs<Location, Lang>::ConfigSig Config>
{
  Lang::Node getNode(TT::TaintFlowMake<Location, Lang, TTLang>::Global<Config>::PathNode n);

  predicate isSource(TT::TaintFlowMake<Location, Lang, TTLang>::Global<Config>::PathNode n);

  TT::TaintFlowMake<Location, Lang, TTLang>::Global<Config>::PathNode getASuccessor(
    TT::TaintFlowMake<Location, Lang, TTLang>::Global<Config>::PathNode n
  );

  Lang::DataFlowCallable getARuntimeTarget(Lang::DataFlowCall call);

  Lang::Node getAnArgumentNode(Lang::DataFlowCall call);
}

module TaintTrackingStackMake<
  LocationSig Location, DF::InputSig<Location> Lang, TT::InputSig<Location, Lang> TTLang>
{
  module DataFlow = DF::DataFlowMake<Location, Lang>;

  module TaintTracking = TT::TaintFlowMake<Location, Lang, TTLang>;

  module BiStackAnalysis<
    DF::Configs<Location, Lang>::ConfigSig ConfigA,
    TaintTrackingStackSig<Location, Lang, TTLang, ConfigA> TaintTrackingStackA,
    DF::Configs<Location, Lang>::ConfigSig ConfigB,
    TaintTrackingStackSig<Location, Lang, TTLang, ConfigB> TaintTrackingStackB>
  {
    module FlowA = TaintTracking::Global<ConfigA>;

    module FlowStackA = FlowStack<ConfigA, TaintTrackingStackA>;

    module FlowB = TaintTracking::Global<ConfigB>;

    module FlowStackB = FlowStack<ConfigB, TaintTrackingStackB>;

    /**
     * Holds if either the Stack associated with `sourceNodeA` is a subset of the stack associated with `sourceNodeB`
     * or vice-versa.
     */
    predicate eitherStackSubset(
      FlowA::PathNode sourceNodeA, FlowA::PathNode sinkNodeA, FlowB::PathNode sourceNodeB,
      FlowB::PathNode sinkNodeB
    ) {
      FlowStackA::isSource(sourceNodeA) and
      FlowStackB::isSource(sourceNodeB) and
      FlowStackA::isSink(sinkNodeA) and
      FlowStackB::isSink(sinkNodeB) and
      exists(FlowStackA::FlowStack flowStackA, FlowStackB::FlowStack flowStackB |
        flowStackA = FlowStackA::createFlowStack(sourceNodeA, sinkNodeA) and
        flowStackB = FlowStackB::createFlowStack(sourceNodeB, sinkNodeB) and
        (
          BiStackAnalysisImpl<ConfigA, TaintTrackingStackA, ConfigB, TaintTrackingStackB>::flowStackIsSubsetOf(flowStackA,
            flowStackB)
          or
          BiStackAnalysisImpl<ConfigB, TaintTrackingStackB, ConfigA, TaintTrackingStackA>::flowStackIsSubsetOf(flowStackB,
            flowStackA)
        )
      )
    }

    /**
     * Holds if the stack associated with path `sourceNodeA` is a subset (and shares a common stack bottom) with
     * the stack associated with path `sourceNodeB`, or vice-versa.
     *
     * For the given pair of (source, sink) for two (potentially disparate) DataFlows,
     * determine whether one Flow's Stack (at time of sink execution) is a subset of the other flow's Stack.
     */
    predicate eitherStackTerminatingSubset(
      FlowA::PathNode sourceNodeA, FlowA::PathNode sinkNodeA, FlowB::PathNode sourceNodeB,
      FlowB::PathNode sinkNodeB
    ) {
      FlowStackA::isSource(sourceNodeA) and
      FlowStackB::isSource(sourceNodeB) and
      FlowStackA::isSink(sinkNodeA) and
      FlowStackB::isSink(sinkNodeB) and
      exists(FlowStackA::FlowStack flowStackA, FlowStackB::FlowStack flowStackB |
        flowStackA = FlowStackA::createFlowStack(sourceNodeA, sinkNodeA) and
        flowStackB = FlowStackB::createFlowStack(sourceNodeB, sinkNodeB) and
        (
          BiStackAnalysisImpl<ConfigA, TaintTrackingStackA, ConfigB, TaintTrackingStackB>::flowStackIsConvergingTerminatingSubsetOf(flowStackA,
            flowStackB)
          or
          BiStackAnalysisImpl<ConfigB, TaintTrackingStackB, ConfigA, TaintTrackingStackA>::flowStackIsConvergingTerminatingSubsetOf(flowStackB,
            flowStackA)
        )
      )
    }

    /**
     * Alias for BiStackAnalysisImpl<FlowA,FlowB>::flowStackIsSubsetOf
     *
     * Holds if stackA is a subset of stackB,
     * The top of stackA is in stackB and the bottom of stackA is then some successor further down stackB.
     */
    predicate flowStackIsSubsetOf(FlowStackA::FlowStack flowStackA, FlowStackB::FlowStack flowStackB) {
      BiStackAnalysisImpl<ConfigA, TaintTrackingStackA, ConfigB, TaintTrackingStackB>::flowStackIsSubsetOf(flowStackA,
        flowStackB)
    }

    /**
     * Alias for BiStackAnalysisImpl<FlowA,FlowB>::flowStackIsConvergingTerminatingSubsetOf
     *
     * If the top of stackA is in stackB at any location, and the bottoms of the stack are the same call.
     */
    predicate flowStackIsConvergingTerminatingSubsetOf(
      FlowStackA::FlowStack flowStackA, FlowStackB::FlowStack flowStackB
    ) {
      BiStackAnalysisImpl<ConfigA, TaintTrackingStackA, ConfigB, TaintTrackingStackB>::flowStackIsConvergingTerminatingSubsetOf(flowStackA,
        flowStackB)
    }
  }

  private module BiStackAnalysisImpl<
    DF::Configs<Location, Lang>::ConfigSig ConfigA,
    TaintTrackingStackSig<Location, Lang, TTLang, ConfigA> DataFlowStackA,
    DF::Configs<Location, Lang>::ConfigSig ConfigB,
    TaintTrackingStackSig<Location, Lang, TTLang, ConfigB> DataFlowStackB>
  {
    module FlowStackA = FlowStack<ConfigA, DataFlowStackA>;

    module FlowStackB = FlowStack<ConfigB, DataFlowStackB>;

    /**
     * Holds if stackA is a subset of stackB,
     * The top of stackA is in stackB and the bottom of stackA is then some successor further down stackB.
     */
    predicate flowStackIsSubsetOf(FlowStackA::FlowStack flowStackA, FlowStackB::FlowStack flowStackB) {
      exists(
        FlowStackA::FlowStackFrame highestStackFrameA, FlowStackB::FlowStackFrame highestStackFrameB
      |
        highestStackFrameA = flowStackA.getTopFrame() and
        highestStackFrameB = flowStackB.getTopFrame() and
        // Check if some intermediary frame `intStackFrameB`of StackB is in the stack of highestStackFrameA
        exists(FlowStackB::FlowStackFrame intStackFrameB |
          intStackFrameB = highestStackFrameB.getASucceedingTerminalStateFrame*() and
          sharesCallWith(highestStackFrameA, intStackFrameB) and
          sharesCallWith(flowStackA.getTerminalFrame(),
            intStackFrameB.getASucceedingTerminalStateFrame*())
        )
      )
    }

    /**
     * If the top of stackA is in stackB at any location, and the bottoms of the stack are the same call.
     */
    predicate flowStackIsConvergingTerminatingSubsetOf(
      FlowStackA::FlowStack flowStackA, FlowStackB::FlowStack flowStackB
    ) {
      flowStackA.getTerminalFrame().getCall() = flowStackB.getTerminalFrame().getCall() and
      exists(FlowStackB::FlowStackFrame intStackFrameB |
        intStackFrameB = flowStackB.getTopFrame().getASucceedingTerminalStateFrame*() and
        sharesCallWith(flowStackA.getTopFrame(), intStackFrameB)
      )
    }

    /**
     * Holds if the given FlowStackFrames share the same call.
     * i.e. they are both arguments of the same function call.
     */
    predicate sharesCallWith(FlowStackA::FlowStackFrame frameA, FlowStackB::FlowStackFrame frameB) {
      frameA.getCall() = frameB.getCall()
    }
  }

  module FlowStack<
    DF::Configs<Location, Lang>::ConfigSig Config,
    TaintTrackingStackSig<Location, Lang, TTLang, Config> TaintTrackingStack>
  {
    private module Flow = TT::TaintFlowMake<Location, Lang, TTLang>::Global<Config>;

    /**
     * Determines whether or not the given PathNode is a source
     * TODO: Refactor to Flow::PathNode signature
     */
    predicate isSource(Flow::PathNode node) { TaintTrackingStack::isSource(node) }

    /**
     * Determines whether or not the given PathNode is a sink
     * TODO: Refactor to Flow::PathNode signature
     */
    predicate isSink(Flow::PathNode node) { not exists(TaintTrackingStack::getASuccessor(node)) }

    /** A FlowStack encapsulates flows between a source and a sink, and all the pathways inbetween (possibly multiple) */
    private newtype FlowStackType =
      TFlowStack(Flow::PathNode source, Flow::PathNode sink) {
        TaintTrackingStack::isSource(source) and
        not exists(TaintTrackingStack::getASuccessor(sink)) and
        TaintTrackingStack::getASuccessor*(source) = sink
      }

    class FlowStack extends FlowStackType, TFlowStack {
      string toString() { result = "FlowStack" }

      /**
       * Get the first frame in the DataFlowStack, irregardless of whether or not it has a parent.
       */
      FlowStackFrame getFirstFrame() {
        exists(FlowStackFrame flowStackFrame, CallFrame frame |
          flowStackFrame = TFlowStackFrame(this, frame) and
          not exists(frame.getPredecessor()) and
          result = flowStackFrame
        )
      }

      /**
       * Get the top frame in the DataFlowStack, ie the frame that is the highest in the stack for the given flow.
       */
      FlowStackFrame getTopFrame() {
        exists(FlowStackFrame flowStackFrame |
          flowStackFrame = TFlowStackFrame(this, _) and
          not exists(flowStackFrame.getParentStackFrame()) and
          result = flowStackFrame
        )
      }

      /**
       * Get the terminal frame in the DataFlowStack, ie the frame that is the end of the flow.
       */
      FlowStackFrame getTerminalFrame() {
        exists(FlowStackFrame flowStackFrame, CallFrame frame |
          flowStackFrame = TFlowStackFrame(this, frame) and
          not exists(frame.getSuccessor()) and
          result = flowStackFrame
        )
      }
    }

    FlowStack createFlowStack(Flow::PathNode source, Flow::PathNode sink) {
      result = TFlowStack(source, sink)
    }

    /** A FlowStackFrame encapsulates a Stack frame that is bound between a given source and sink. */
    private newtype FlowStackFrameType =
      TFlowStackFrame(FlowStack flowStack, CallFrame frame) {
        exists(Flow::PathNode source, Flow::PathNode sink |
          flowStack = TFlowStack(source, sink) and
          frame.getPathNode() = TaintTrackingStack::getASuccessor*(source) and
          TaintTrackingStack::getASuccessor*(frame.getPathNode()) = sink
        )
      }

    class FlowStackFrame extends FlowStackFrameType, TFlowStackFrame {
      string toString() { result = "FlowStackFrame" }

      /**
       * Get the next frame in the DataFlow Stack
       */
      FlowStackFrame getASuccessor() {
        exists(FlowStack flowStack, CallFrame frame, CallFrame nextFrame |
          this = TFlowStackFrame(flowStack, frame) and
          nextFrame = frame.getSuccessor() and
          result = TFlowStackFrame(flowStack, nextFrame)
        )
      }

      /**
       * Gets the next FlowStackFrame from the direct descendents that is a frame in the end-state (terminal) stack.
       */
      FlowStackFrame getASucceedingTerminalStateFrame() {
        result = this.getChildStackFrame() and
        // There are no other direct children that are further in the flow
        not result.getASuccessor+() = this.getChildStackFrame()
      }

      /**
       * Gets a predecessor FlowStackFrame of this FlowStackFrame.
       */
      FlowStackFrame getAPredecessor() { result.getASuccessor() = this }

      /**
       * Gets a predecessor FlowStackFrame that is a parent in the stack.
       */
      FlowStackFrame getParentStackFrame() { result.getChildStackFrame() = this }

      /**
       * Gets the set of succeeding FlowStackFrame which are a direct descendant of this frame in the Stack.
       */
      FlowStackFrame getChildStackFrame() {
        exists(FlowStackFrame transitiveSuccessor |
          transitiveSuccessor = this.getASuccessor+() and
          TaintTrackingStack::getARuntimeTarget(this.getCall()) =
            transitiveSuccessor.getCall().getEnclosingCallable() and
          result = transitiveSuccessor
        )
      }

      /**
       * Unpacks the PathNode associated with this FlowStackFrame
       */
      Flow::PathNode getPathNode() {
        exists(CallFrame callFrame |
          this = TFlowStackFrame(_, callFrame) and
          result = callFrame.getPathNode()
        )
      }

      /**
       * Unpacks the DataFlowCall associated with this FlowStackFrame
       */
      Lang::DataFlowCall getCall() { result = this.getCallFrame().getCall() }

      /**
       * Unpacks the CallFrame associated with this FlowStackFrame
       */
      CallFrame getCallFrame() { this = TFlowStackFrame(_, result) }
    }

    /**
     * A CallFrame is a PathNode that represents a (DataFlowCall/Accessor).
     */
    private newtype TCallFrameType =
      TCallFrame(Flow::PathNode node) {
        exists(Lang::DataFlowCall c |
          TaintTrackingStack::getAnArgumentNode(c) = TaintTrackingStack::getNode(node)
        )
      }

    /**
     * The CallFrame is a PathNode that represents an argument to a Call.
     */
    private class CallFrame extends TCallFrameType, TCallFrame {
      string toString() {
        exists(Lang::DataFlowCall call |
          call = this.getCall() and
          result = call.toString()
        )
      }

      /**
       * Find the set of CallFrames that are immediate successors of this CallFrame.
       */
      CallFrame getSuccessor() { result = TCallFrame(getSuccessorCall(this.getPathNode())) }

      /**
       * Find the set of CallFrames that are an immediate predecessor of this CallFrame.
       */
      CallFrame getPredecessor() {
        exists(CallFrame prior |
          prior.getSuccessor() = this and
          result = prior
        )
      }

      /**
       * Unpack the CallFrame and retrieve the associated DataFlowCall.
       */
      Lang::DataFlowCall getCall() {
        exists(Lang::DataFlowCall call, Flow::PathNode node |
          this = TCallFrame(node) and
          TaintTrackingStack::getAnArgumentNode(call) = TaintTrackingStack::getNode(node) and
          result = call
        )
      }

      /**
       * Unpack the CallFrame and retrieve the associated PathNode.
       */
      Flow::PathNode getPathNode() {
        exists(Flow::PathNode n |
          this = TCallFrame(n) and
          result = n
        )
      }
    }

    /**
     * From the given PathNode argument, find the set of successors that are an argument in a DataFlowCall,
     * and return them as the result.
     */
    private Flow::PathNode getSuccessorCall(Flow::PathNode n) {
      exists(Flow::PathNode succ |
        succ = TaintTrackingStack::getASuccessor(n) and
        if
          exists(Lang::DataFlowCall c |
            TaintTrackingStack::getAnArgumentNode(c) = TaintTrackingStack::getNode(succ)
          )
        then result = succ
        else result = getSuccessorCall(succ)
      )
    }

    /**
     * A user-supplied predicate which given a Stack Frame, returns some Node associated with it.
     */
    signature Lang::Node extractNodeFromFrame(Flow::PathNode pathNode);

    /**
     * Provides some higher-order predicates for analyzing Stacks
     */
    module StackFrameAnalysis<extractNodeFromFrame/1 customFrameCond> {
      /**
       * Find the highest stack frame that satisfies the given predicate,
       * and return the Node(s) that the user-supplied predicate returns.
       *
       * There should be no higher stack frame that satisfies the user-supplied predicate FROM the point that the
       * argument .
       */
      Lang::Node extractingFromHighestStackFrame(FlowStack flowStack) {
        exists(FlowStackFrame topStackFrame, FlowStackFrame someStackFrame |
          topStackFrame = flowStack.getTopFrame() and
          someStackFrame = topStackFrame.getASuccessor*() and
          result = customFrameCond(someStackFrame.getPathNode()) and
          not exists(FlowStackFrame predecessor |
            predecessor = someStackFrame.getAPredecessor+() and
            // The predecessor is *not* prior to the user-given 'top' of the stack frame.
            not predecessor = topStackFrame.getAPredecessor+() and
            exists(customFrameCond(predecessor.getPathNode()))
          )
        )
      }

      /**
       * Find the lowest stack frame that satisfies the given predicate,
       * and return the Node(s) that the user-supplied predicate returns.
       */
      Lang::Node extractingFromLowestStackFrame(FlowStack flowStack) {
        exists(FlowStackFrame topStackFrame, FlowStackFrame someStackFrame |
          topStackFrame = flowStack.getTopFrame() and
          someStackFrame = topStackFrame.getChildStackFrame*() and
          result = customFrameCond(someStackFrame.getPathNode()) and
          not exists(FlowStackFrame successor |
            successor = someStackFrame.getChildStackFrame+() and
            exists(customFrameCond(successor.getPathNode()))
          )
        )
      }
    }
  }
}
