
private import codeql.dataflow.DataFlow as DF

module DataFlowStackMake<DF::InputSig Lang>{

    import DF::DataFlowMake<Lang> as DataFlow

    module FlowStack<DataFlow::GlobalFlowSig Flow>{

        predicate eitherStackSubset(Flow::PathNode nodeA, Flow::PathNode nodeB){
            exists(StackFrame topNodeA, StackFrame topNodeB |
                topNodeA = stackFrameForFlow(nodeA) and
                topNodeB = stackFrameForFlow(nodeB) and (
                    stackIsSubsetOf(topNodeA, topNodeB)
                    or
                    stackIsSubsetOf(topNodeB, topNodeA)
                )
            )
        }

        predicate stackIsSubsetOf(StackFrame stackA, StackFrame stackB){
            // If the top of stackA is in stackB at all, and the bottom of stackA is some successor of stackB.
            exists(StackFrame stackBIntermediary |
                stackBIntermediary = stackB.getSuccessor*() and
                stackA.getCall() = stackBIntermediary.getCall() and
                stackA.getBottom().getCall() = stackBIntermediary.getSuccessor*().getCall()
            )
        }

        predicate eitherStackTerminatingSubset(Flow::PathNode nodeA, Flow::PathNode nodeB){
            exists(StackFrame topNodeA, StackFrame topNodeB |
                topNodeA = stackFrameForFlow(nodeA) and
                topNodeB = stackFrameForFlow(nodeB) and (
                    stackIsCovergingTerminatingSubsetOf(topNodeA, topNodeB)
                    or
                    stackIsCovergingTerminatingSubsetOf(topNodeB, topNodeA)
                )
            )
        }

        predicate stackIsCovergingTerminatingSubsetOf(StackFrame stackA, StackFrame stackB){
            // If the top of stackA is in stackB at any location, and the bottoms of the stack are the same call.
            stackA.getCall() = stackB.getSuccessor*().getCall() and
            stackA.getBottom().getCall() = stackB.getBottom().getCall()
        }


        private newtype TStackFrameType =
            TStackFrame(CallFrame callFrame, CallFrame bottom){
                callFrame.getSuccessor*() = bottom and
                not exists(bottom.getSuccessor())
            }

        class StackFrame extends TStackFrameType, TStackFrame{
            string toString(){
                exists(CallFrame callFrame |
                    this = TStackFrame(callFrame, _) and
                    result = callFrame.toString()
                )
            }

            StackFrame getSuccessor(){
                exists(StackFrame succ |
                    this = succ.getPredecessor() and
                    result = succ
                )
            }

            /** Filter subsection of callframes that are parent calls in callgraph, that is,
             *              limit to only the functions that indirectly/directly call the sink.
             */
            StackFrame getPredecessor(){
                exists(CallFrame callFrame, CallFrame bottom, CallFrame callFramePredecessor |
                    // Get the predecessor callframe which has a direct call inside the body to the current callFrame
                    this = TStackFrame(callFrame, bottom) and
                    callFramePredecessor = callFrame.getPredecessor*() and
                    callFramePredecessor.getCall().getARuntimeTarget() = callFrame.getCall().getEnclosingCallable() and
                    result = TStackFrame(callFramePredecessor, bottom)
                )
            }

            Flow::PathNode getPathNode(){
                exists(CallFrame callFrame |
                    this = TStackFrame(callFrame, _) and
                    result = callFrame.getPathNode()
                )
            }

            Lang::DataFlowCall getCall(){
                exists(CallFrame callFrame |
                    this = TStackFrame(callFrame, _) and
                    result = callFrame.getCall()
                )
            }

            predicate matchesCallFrame(CallFrame callFrame){
                this.getPathNode() = callFrame.getPathNode()
            }

            StackFrame getBottom(){
                result = this.getSuccessor*() and
                not exists(result.getSuccessor())
            }
        }

        StackFrame fromCallFrame(CallFrame callFrame){
            result = TStackFrame(callFrame, getBottomCallFrame(callFrame))
        }

        CallFrame getBottomCallFrame(CallFrame callFrame){
            exists(CallFrame bottom |
                bottom = callFrame.getSuccessor*() and
                not exists(bottom.getSuccessor()) and
                result = bottom
            )
        }

        private StackFrame stackFrameForFlow(Flow::PathNode node){
            // Get the CallFrame, then from the last callframe, track back up whereby each call's target should contain the next CallFrame.
            exists(CallFrame callFrame |
                callFrame = flowNodeCallFrames(node) and
                callFrame.getCall().getAnArgument() = node.getNode() and
                result = TStackFrame(callFrame, _)
            )
        }

        private newtype TCallFrameType =
            TCallFrame(Flow::PathNode node) {
                exists(Lang::DataFlowCall c |
                    c.getAnArgument() = node.getNode()
                )
            }

        private class CallFrame extends TCallFrameType, TCallFrame{
            string toString(){
                exists(Lang::DataFlowCall call |
                    call = this.getCall() and
                    result = call.toString()
                )
            }

            CallFrame getSuccessor(){
                exists(Flow::PathNode node |
                    this = TCallFrame(node) and
                    exists(Flow::PathNode succ |
                        succ = getSuccessorCall(node) and
                        result = TCallFrame(succ)
                    )
                )
            }

            CallFrame getPredecessor(){
                exists(CallFrame prior |
                    prior.getSuccessor() = this and
                    result = prior  
                )
            }

            Lang::DataFlowCall getPredecessorCall(){
                result = this.getPredecessor().getCall()
            }

            Lang::DataFlowCall getCall(){
                exists(Lang::DataFlowCall call, Flow::PathNode node |
                    this = TCallFrame(node) and
                    call.getAnArgument() = node.getNode() and
                    result = call
                )
            }

            Flow::PathNode getPathNode(){
                exists(Flow::PathNode n |
                    this = TCallFrame(n) and
                    result = n
                )
            }
        }

        private Flow::PathNode getSuccessorCall(Flow::PathNode n){
            exists(Flow::PathNode succ |
                succ = n.getASuccessor() and
                if exists(Lang::DataFlowCall c | c.getAnArgument() = succ.getNode())
                then result = succ
                else result = getSuccessorCall(succ)
            )
        }

        private CallFrame flowNodeCallFrames(Flow::PathNode node){
            exists(Flow::PathNode subnode, Lang::DataFlowCall call |
                subnode = node.getASuccessor*() and
                call.getAnArgument() = subnode.getNode() and
                result = TCallFrame(subnode)
            )
        }
    }
} 