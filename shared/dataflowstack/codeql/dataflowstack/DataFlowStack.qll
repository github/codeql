
private import codeql.dataflow.DataFlow as DF

module DataFlowStackMake<DF::InputSig Lang>{

    import DF::DataFlowMake<Lang> as DataFlow

    module BiStackAnalysis<DataFlow::GlobalFlowSig FlowA, DataFlow::GlobalFlowSig FlowB>{

        module FlowStackA = FlowStack<FlowA>;
        module FlowStackB = FlowStack<FlowB>;

        /**
         * Holds if either the Stack associated with `sourceNodeA` is a subset of the stack associated with `sourceNodeB`
         * or vice-versa.
         */
        predicate eitherStackSubset(FlowA::PathNode sourceNodeA, FlowA::PathNode sinkNodeA, FlowB::PathNode sourceNodeB, FlowB::PathNode sinkNodeB){
            sourceNodeA.isSource() and
            sourceNodeB.isSource() and
            not exists(sinkNodeA.getASuccessor()) and
            not exists(sinkNodeB.getASuccessor()) and
            exists(FlowStackA::FlowStack flowStackA, FlowStackB::FlowStack flowStackB |
                flowStackA  = FlowStackA::createFlowStack(sourceNodeA, sinkNodeA) and
                flowStackB  = FlowStackB::createFlowStack(sourceNodeB, sinkNodeB) and (
                    BiStackAnalysisImpl<FlowA, FlowB>::flowStackIsSubsetOf(flowStackA, flowStackB)
                    or
                    BiStackAnalysisImpl<FlowB, FlowA>::flowStackIsSubsetOf(flowStackB, flowStackA)
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
        predicate eitherStackTerminatingSubset(FlowA::PathNode sourceNodeA, FlowA::PathNode sinkNodeA, FlowB::PathNode sourceNodeB, FlowB::PathNode sinkNodeB){
            sourceNodeA.isSource() and
            sourceNodeB.isSource() and
            not exists(sinkNodeA.getASuccessor()) and
            not exists(sinkNodeB.getASuccessor()) and
            exists(FlowStackA::FlowStack flowStackA, FlowStackB::FlowStack flowStackB |
                flowStackA = FlowStackA::createFlowStack(sourceNodeA, sinkNodeA) and
                flowStackB = FlowStackB::createFlowStack(sourceNodeB, sinkNodeB) and (
                    BiStackAnalysisImpl<FlowA, FlowB>::flowStackIsConvergingTerminatingSubsetOf(flowStackA, flowStackB)
                    or
                    BiStackAnalysisImpl<FlowB, FlowA>::flowStackIsConvergingTerminatingSubsetOf(flowStackB, flowStackA)
                )
            )
        }

        /**
         * Alias for BiStackAnalysisImpl<FlowA,FlowB>::flowStackIsSubsetOf
         * 
         * Holds if stackA is a subset of stackB,
         * The top of stackA is in stackB and the bottom of stackA is then some successor further down stackB.
         */
        predicate flowStackIsSubsetOf(FlowStackA::FlowStack flowStackA, FlowStackB::FlowStack flowStackB){
            BiStackAnalysisImpl<FlowA,FlowB>::flowStackIsSubsetOf(flowStackA, flowStackB)
        }

        /**
         * Alias for BiStackAnalysisImpl<FlowA,FlowB>::flowStackIsConvergingTerminatingSubsetOf
         * 
         * If the top of stackA is in stackB at any location, and the bottoms of the stack are the same call.
         */
        predicate flowStackIsConvergingTerminatingSubsetOf(FlowStackA::FlowStack flowStackA, FlowStackB::FlowStack flowStackB){
            BiStackAnalysisImpl<FlowA,FlowB>::flowStackIsConvergingTerminatingSubsetOf(flowStackA, flowStackB)
        }
    }

    private module BiStackAnalysisImpl<DataFlow::GlobalFlowSig FlowA, DataFlow::GlobalFlowSig FlowB>{

        module FlowStackA = FlowStack<FlowA>;
        module FlowStackB = FlowStack<FlowB>;

        /**
         * Holds if stackA is a subset of stackB,
         * The top of stackA is in stackB and the bottom of stackA is then some successor further down stackB.
         */
        predicate flowStackIsSubsetOf(FlowStackA::FlowStack flowStackA, FlowStackB::FlowStack flowStackB){
            exists(FlowStackA::FlowStackFrame highestStackFrameA, FlowStackB::FlowStackFrame highestStackFrameB |
                highestStackFrameA = flowStackA.getTopFrame() and
                highestStackFrameB = flowStackB.getTopFrame() and
                // Check if some intermediary frame `intStackFrameB`of StackB is in the stack of highestStackFrameA
                exists(FlowStackB::FlowStackFrame intStackFrameB |
                    intStackFrameB = highestStackFrameB.getASucceedingTerminalStateFrame*() and
                    intStackFrameB.getCall() = highestStackFrameA.getCall() and
                    flowStackA.getBottomFrame().getCall() = intStackFrameB.getASucceedingTerminalStateFrame*().getCall()
                )
            )
        }

        /**
         * If the top of stackA is in stackB at any location, and the bottoms of the stack are the same call.
         */
        predicate flowStackIsConvergingTerminatingSubsetOf(FlowStackA::FlowStack flowStackA, FlowStackB::FlowStack flowStackB){
            flowStackA.getBottomFrame().getCall() = flowStackB.getBottomFrame().getCall() and
            exists(FlowStackB::FlowStackFrame intStackFrameB |
                intStackFrameB = flowStackB.getTopFrame().getASucceedingTerminalStateFrame*() and
                intStackFrameB.getCall() = flowStackA.getTopFrame().getCall()
            )
        }
    }

    module FlowStack<DataFlow::GlobalFlowSig Flow>{

        /** A FlowStack encapsulates flows between a source and a sink, and all the pathways inbetween (possibly multiple) */
        private newtype FlowStackType =
            TFlowStack(Flow::PathNode source, Flow::PathNode sink){
                source.isSource() and
                not exists(sink.getASuccessor()) and
                source.getASuccessor*() = sink
            }

        class FlowStack extends FlowStackType, TFlowStack{
            string toString(){
                result = "FlowStack"
            }

            FlowStackFrame getFirstFrame(){
                exists(FlowStackFrame flowStackFrame, CallFrame frame |
                    flowStackFrame = TFlowStackFrame(this, frame) and
                    not exists(frame.getPredecessor()) and
                    result = flowStackFrame
                )
            }

            FlowStackFrame getTopFrame(){
                exists(FlowStackFrame flowStackFrame |
                    flowStackFrame = TFlowStackFrame(this, _) and
                    not exists(flowStackFrame.getParentStackFrame()) and
                    result = flowStackFrame
                )
            }

            FlowStackFrame getBottomFrame(){
                exists(FlowStackFrame flowStackFrame, CallFrame frame |
                    flowStackFrame = TFlowStackFrame(this, frame) and
                    not exists(frame.getSuccessor()) and
                    result = flowStackFrame
                )
            }
        }

        FlowStack createFlowStack(Flow::PathNode source, Flow::PathNode sink){
            result = TFlowStack(source, sink)
        }

        /** A FlowStackFrame encapsulates a Stack frame that is bound between a given source and sink. */
        private newtype FlowStackFrameType =
            TFlowStackFrame(FlowStack flowStack, CallFrame frame){
                exists(Flow::PathNode source, Flow::PathNode sink |
                    flowStack = TFlowStack(source, sink) and
                    frame.getPathNode() = source.getASuccessor*() and
                    frame.getPathNode().getASuccessor*() = sink
                )
            }

        class FlowStackFrame extends FlowStackFrameType, TFlowStackFrame{
            string toString(){
                result = "FlowStackFrame"
            }

            /**
             * Get the next frame in the DataFlow Stack
             */
            FlowStackFrame getASuccessor(){
                exists(FlowStack flowStack, CallFrame frame, CallFrame nextFrame |
                    this = TFlowStackFrame(flowStack, frame) and
                    nextFrame = frame.getSuccessor() and
                    result = TFlowStackFrame(flowStack, nextFrame)
                )
            }

            /**
             * Gets the next FlowStackFrame from the successors which is a frame in the end-state (terminal) stack.
             */
            FlowStackFrame getASucceedingTerminalStateFrame(){
                exists(FlowStackFrame nextHighestFrame |
                    nextHighestFrame = this.getChildStackFrame() and
                    // There are no other direct children that are further in the flow
                    not exists(FlowStackFrame succeedingChildStackFrame |
                        succeedingChildStackFrame = this.getChildStackFrame() and
                        nextHighestFrame.getASuccessor+() = succeedingChildStackFrame
                    ) and
                    result = nextHighestFrame
                )
            }

            /**
             * Gets a predecessor FlowStackFrame of this FlowStackFrame.
             */
            FlowStackFrame getAPredecessor(){
                result.getASuccessor() = this
            }

            /**
             * Gets a predecessor FlowStackFrame that is a parent in the stack.
             */
            FlowStackFrame getParentStackFrame(){
                result.getChildStackFrame() = this
            }

            /**
             * Gets the set of succeeding FlowStackFrame which are a direct descendant of this frame in the Stack.
             */
            FlowStackFrame getChildStackFrame(){
                exists(FlowStackFrame transitiveSuccessor |
                    transitiveSuccessor = this.getASuccessor*() and
                    this.getCall().getARuntimeTarget() = transitiveSuccessor.getCall().getEnclosingCallable() and
                    result = transitiveSuccessor
                )
            }

            /**
             * Unpacks the PathNode associated with this FlowStackFrame
             */
            Flow::PathNode getPathNode(){
                exists(CallFrame callFrame |
                    this = TFlowStackFrame(_, callFrame) and
                    result = callFrame.getPathNode()
                )
            }

            /**
             * Unpacks the DataFlowCall associated with this FlowStackFrame
             */
            Lang::DataFlowCall getCall(){
                exists(CallFrame callFrame |
                    this = TFlowStackFrame(_, callFrame) and
                    result = callFrame.getCall()
                )
            }

            /**
             * Equivalence check on the CallFrame associated with this FlowStackFrame with given CallFrame
             */
            predicate matchesCallFrame(CallFrame callFrame){
                this.getPathNode() = callFrame.getPathNode()
            }
        }


        /**
         * A CallFrame is a PathNode that represents a Function Call (DataFlowCall).
         */
        private newtype TCallFrameType =
            TCallFrame(Flow::PathNode node) {
                exists(Lang::DataFlowCall c |
                    c.getAnArgumentNode() = node.getNode()
                )
            }

        private class CallFrame extends TCallFrameType, TCallFrame{
            string toString(){
                exists(Lang::DataFlowCall call |
                    call = this.getCall() and
                    result = call.toString()
                )
            }

            /**
             * Find the set of CallFrames that are immediate successors of this CallFrame.
             */
            CallFrame getSuccessor(){
                exists(Flow::PathNode node |
                    this = TCallFrame(node) and
                    exists(Flow::PathNode succ |
                        succ = getSuccessorCall(node) and
                        result = TCallFrame(succ)
                    )
                )
            }

            /**
             * Find the set of CallFrames that are an immediate predecessor of this CallFrame.
             */
            CallFrame getPredecessor(){
                exists(CallFrame prior |
                    prior.getSuccessor() = this and
                    result = prior  
                )
            }

            /**
             * Unpack the CallFrame and retrieve the associated DataFlowCall.
             */
            Lang::DataFlowCall getCall(){
                exists(Lang::DataFlowCall call, Flow::PathNode node |
                    this = TCallFrame(node) and
                    call.getAnArgumentNode() = node.getNode() and
                    result = call
                )
            }

            /**
             * Unpack the CallFrame and retrieve the associated PathNode.
             */
            Flow::PathNode getPathNode(){
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
        private Flow::PathNode getSuccessorCall(Flow::PathNode n){
            exists(Flow::PathNode succ |
                succ = n.getASuccessor() and
                if exists(Lang::DataFlowCall c | c.getAnArgumentNode() = succ.getNode())
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
        module StackFrameAnalysis<extractNodeFromFrame/1 customFrameCond>{

            /**
             * Find the highest stack frame that satisfies the given predicate,
             * and return the Node(s) that the user-supplied predicate returns.
             * 
             * There should be no higher stack frame that satisfies the user-supplied predicate FROM the point that the
             * argument .
             */
            Lang::Node extractingFromHighestStackFrame(FlowStack flowStack){
                exists(FlowStackFrame topStackFrame, FlowStackFrame someStackFrame |
                    topStackFrame = flowStack.getTopFrame() and
                    someStackFrame = topStackFrame.getASuccessor*() and
                    result = customFrameCond(someStackFrame.getPathNode()) and
                    not exists(FlowStackFrame predecessor |
                        predecessor = someStackFrame.getAPredecessor+() and
                        // The predecessor is *not* prior to the user-given 'top' of the stack frame.
                        not predecessor = topStackFrame.getAPredecessor*() and
                        exists(customFrameCond(predecessor.getPathNode()))
                    )
                )
            }

            /**
             * Find the lowest stack frame that satisfies the given predicate,
             * and return the Node(s) that the user-supplied predicate returns.
             */
            Lang::Node extractingFromLowestStackFrame(FlowStack flowStack){
                exists(FlowStackFrame topStackFrame, FlowStackFrame someStackFrame |
                    topStackFrame = flowStack.getTopFrame() and
                    someStackFrame = topStackFrame.getASuccessor*() and
                    result = customFrameCond(someStackFrame.getPathNode()) and
                    not exists(FlowStackFrame successor |
                        successor = someStackFrame.getASuccessor+() and
                        exists(customFrameCond(successor.getPathNode()))
                    )
                )
            }
        }
    }
} 