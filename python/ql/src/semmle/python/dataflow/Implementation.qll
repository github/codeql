import python
import semmle.python.security.TaintTracking
private import semmle.python.objects.ObjectInternal

newtype TTaintTrackingContext =
    TNoParam()
    or
    TParamContext(TaintKind param, AttributePath path, int n) {
        any(TaintTrackingImplementation impl).callWithTaintedArgument(_, _, _, _, n, path, param)
    }

class TaintTrackingContext extends TTaintTrackingContext {

    string toString()  { 
        this = TNoParam() and result = "No context"
        or
        exists(TaintKind param, AttributePath path, int n |
            this = TParamContext(param, path, n) and
            result = "Parameter " + n.toString() + "(" + path.toString() + ") is " + param
        )
    }

    TaintKind getParameterTaint(int n) {
        this = TParamContext(result, _, n)
    }

    AttributePath getAttributePath() {
        this = TParamContext(_, result, _)
    }

    TaintTrackingContext getCaller() {
        exists(TaintKind param, AttributePath path, int n |
            this = TParamContext(param, path, n) and
            exists(TaintTrackingImplementation impl |
                impl.callWithTaintedArgument(_, _, result, _, n, path, param)
            )
        )
    }

}


private newtype TAttributePath =
    TNoAttribute()
    or
    TAttribute(string name) {
        none()
    }
    or
    TAttributeAttribute(string name1, string name2) {
        none()
    }

abstract class AttributePath extends TAttributePath {

    abstract string toString();

    abstract string extension();

    abstract AttributePath fromAttribute(string name);

    AttributePath getAttribute(string name) {
        this = result.fromAttribute(name)
    }

    predicate noAttribute() {
        this = TNoAttribute()
    }

}


class NoAttribute extends TNoAttribute, AttributePath {

    override string toString() { result = "no attribute" }

    override string extension() { result = "" }

    override AttributePath fromAttribute(string name) {
        none()
    }

}


newtype TTaintTrackingNode =
    TTaintTrackingNode_(DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind, TaintTracking::Configuration config) {
        config.(TaintTrackingImplementation).flowStep(_, node, context, path, kind)
        or
        config.isSource(node, kind) and context = TNoParam() and path = TNoAttribute()
        or
        exists(TaintSource source |
            config.isSource(source) and
            node.asCfgNode() = source and
            source.isSourceOf(kind)
        ) and
        context = TNoParam() and path = TNoAttribute()
    }

class TaintTrackingNode extends TTaintTrackingNode {

    string toString() { result = this.getTaintKind()  + " at " + this.getNode().getLocation() }

    DataFlow::Node getNode() {
        this = TTaintTrackingNode_(result, _, _, _, _)
    }

    TaintKind getTaintKind() {
        this = TTaintTrackingNode_(_, _, _, result, _)
    }

    TaintTrackingContext getContext() {
        this = TTaintTrackingNode_(_, result, _, _, _)
    }

    AttributePath getPath() {
        this = TTaintTrackingNode_(_, _, result, _, _)
    }

    TaintTracking::Configuration getConfiguration() {
        this = TTaintTrackingNode_(_, _, _, _, result)
    }

    Location getLocation() {
        result = this.getNode().getLocation()
    }

    TaintTrackingNode getASuccessor() {
        exists(DataFlow::Node node, TaintTrackingContext ctx, AttributePath path, 
               TaintKind kind, TaintTracking::Configuration config |
            result = TTaintTrackingNode_(node, ctx, path, kind, config) and
            config.(TaintTrackingImplementation).flowStep(this, node, ctx, path, kind)
        )
    }

    predicate isSource() {
        this.getConfiguration().(TaintTrackingImplementation).isPathSource(this)
    }

    predicate isSink() {
        this.getConfiguration().(TaintTrackingImplementation).isPathSink(this)
    }

}

class TaintTrackingImplementation extends string {

    predicate hasFlowPath(TaintTrackingNode source, TaintTrackingNode sink) {
        this.isPathSource(source) and
        this.isPathSink(sink) and
        sink = source.getASuccessor*()
    }

    predicate isPathSource(TaintTrackingNode source) {
        exists(DataFlow::Node srcnode, TaintKind kind |
            source = TTaintTrackingNode_(srcnode, TNoParam(), TNoAttribute(), kind, this) and
            this.(TaintTracking::Configuration).isSource(srcnode, kind)
        )
    }

    predicate isPathSink(TaintTrackingNode sink) {
        exists(DataFlow::Node sinknode, TaintKind kind |
            sink = TTaintTrackingNode_(sinknode, _, TNoAttribute(), kind, this) and
            this.(TaintTracking::Configuration).isSink(sinknode, kind)
        )
    }

    predicate flowStep(TaintTrackingNode src, TaintTrackingNode dest) {
        exists(DataFlow::Node node, TaintTrackingContext ctx, AttributePath path, TaintKind kind |
            dest = TTaintTrackingNode_(node, ctx, path, kind, this) and
            this.flowStep(src, node, ctx, path, kind)
        )
    }

    TaintTrackingImplementation() { this instanceof TaintTracking::Configuration }

    predicate flowStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        this.unprunedStep(src, node, context, path, kind) and
        node.getBasicBlock().likelyReachable()
    }

    predicate unprunedStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        this.importStep(src, node, context, path, kind)
        or
        this.fromImportStep(src, node, context, path, kind)
        //or
        //this.attributeLoadStep(src, node, context, path, kind)
        //or
        //this.getattrStep(src, node, context, path, kind)
        or
        this.useStep(src, node, context, path, kind)
        or
        this.callTaintStep(src, node, context, path, kind)
        or
        this.returnFlowStep(src, node, context, path, kind)
        //or
        //this.iterationStep(src, node, context, path, kind)
        //or
        //this.yieldStep(src, node, context, path, kind)
        //or
        //this.subscriptStep(src, node, context, path, kind)
        //or
        //this.ifExprStep(src, node, context, path, kind)
        or
        this.essaFlowStep(src, node, context, path, kind)
        or
        exists(DataFlow::Node srcnode, TaintKind srckind |
            this.(TaintTracking::Configuration).isAdditionalFlowStep(srcnode, node, srckind, kind) and
            src = TTaintTrackingNode_(srcnode, context, path, srckind, this) and
            path.noAttribute()
        )
        or
        exists(DataFlow::Node srcnode |
            this.(TaintTracking::Configuration).isAdditionalFlowStep(srcnode, node) and
            src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
            path.noAttribute()
        )
        or
        exists(DataFlow::Node srcnode, TaintKind srckind |
            kind = srckind.getTaintForFlowStep(srcnode.asCfgNode(), node.asCfgNode()) and
            src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
            path.noAttribute()
        )
    }

    pragma [noinline]
    predicate importStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        // TO DO
        none()
    }

    pragma [noinline]
    predicate fromImportStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        // TO DO
        none()
    }

    pragma [noinline]
    predicate attributeLoadStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        exists(DataFlow::Node srcnode, AttributePath srcpath, string attrname |
            src = TTaintTrackingNode_(srcnode, context, srcpath, kind, this) and
            node.asCfgNode() = srcnode.asCfgNode().(AttrNode).getObject(attrname) and
            path = srcpath.fromAttribute(attrname)
        )
    }

    pragma [noinline]
    predicate getattrStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        exists(DataFlow::Node srcnode, AttributePath srcpath, string attrname |
            src = TTaintTrackingNode_(srcnode, context, srcpath, kind, this) and
            exists(CallNode call, ControlFlowNode arg |
                call = node.asCfgNode() and
                call.getFunction().pointsTo(ObjectInternal::builtin("getattr")) and
                arg = call.getArg(0) and
                attrname = call.getArg(1).getNode().(StrConst).getText() and
                arg = srcnode.asCfgNode() and
                path = srcpath.fromAttribute(attrname)
            )
        )
    }

    pragma [noinline]
    predicate useStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        exists(DataFlow::Node srcnode |
            src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
            node.asCfgNode() = srcnode.asVariable().getASourceUse()
        )
    }

    //pragma [noinline]
    //predicate argumentFlowStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind) {
    //    exists(CallNode call, PythonFunctionObjectInternal pyfunc, int arg |
    //        this.callWithTaintedArgument(src, call, _, pyfunc, arg, path, kind) and
    //        node.asCfgNode() = pyfunc.getParameter(arg) and
    //        context = TParamContext(kind, arg)
    //    )
    //    // TO DO... named parameters
    //}

    pragma [noinline]
    predicate returnFlowStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        exists(CallNode call, PythonFunctionObjectInternal pyfunc, int arg, TaintKind callerKind, DataFlow::Node srcNode, AttributePath callerPath, TaintTrackingContext srcContext |
            src = TTaintTrackingNode_(srcNode, srcContext, path, kind, this) and
            this.callWithTaintedArgument(_, call, context, pyfunc, arg, callerPath, callerKind) and
            srcContext = TParamContext(callerKind, callerPath, arg) and
            node.asCfgNode() = call and
            srcNode.asCfgNode() = any(Return ret | ret.getScope() = pyfunc.getScope()).getValue().getAFlowNode()
        )
    }

    predicate callWithTaintedArgument(TaintTrackingNode src, CallNode call, TaintTrackingContext caller, CallableValue pyfunc, int arg, AttributePath path, TaintKind kind) {
        exists(DataFlow::Node srcnode |
            src = TTaintTrackingNode_(srcnode, caller, path, kind, this) and
            srcnode.asCfgNode() = pyfunc.getArgumentForCall(call, arg)
        )
    }

    pragma [noinline]
    predicate callTaintStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        exists(DataFlow::Node srcnode, CallNode call, TaintKind srckind, string name |
            src = TTaintTrackingNode_(srcnode, context, path, srckind, this) and
            call.getFunction().(AttrNode).getObject(name) = src.getNode().asCfgNode() and
            kind = srckind.getTaintOfMethodResult(name) and
            node.asCfgNode() = call
        )
    }

    pragma [noinline]
    predicate iterationStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        exists(ForNode for, DataFlow::Node sequence, TaintKind seqkind |
            src = TTaintTrackingNode_(sequence, context, path, seqkind, this) and
            for.iterates(_, sequence.asCfgNode()) and
            node.asCfgNode() = for and
            path.noAttribute() and
            kind = seqkind.getTaintForIteration()
        )
    }

    pragma [noinline]
    predicate yieldStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        exists(DataFlow::Node srcnode, TaintKind itemkind |
            src = TTaintTrackingNode_(srcnode, context, path, itemkind, this) and
            itemkind = kind.getTaintForIteration() and
            exists(PyFunctionObject func |
                func.getFunction().isGenerator() and
                func.getACall() = node.asCfgNode() and
                exists(Yield yield |
                    yield.getScope() = func.getFunction() and
                    yield.getValue() = srcnode.asCfgNode().getNode()
                )
            )
        )
    }

    pragma [noinline]
    predicate subscriptStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        exists(DataFlow::Node srcnode, SequenceKind seqkind |
            src = TTaintTrackingNode_(srcnode, context, path, seqkind, this) and
            srcnode.asCfgNode() = node.asCfgNode().(SubscriptNode).getObject() and
            kind = seqkind.getItem()
        )
    }

    pragma [noinline]
    predicate ifExprStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        exists(DataFlow::Node srcnode |
            src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
            srcnode.asCfgNode() = node.asCfgNode().(IfExprNode).getAnOperand()
        )
    }

    pragma [noinline]
    predicate essaFlowStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        this.taintedDefinition(src, node.asVariable().getDefinition(), context, path, kind)
    }

    pragma [noinline]
    predicate taintedDefinition(TaintTrackingNode src, EssaDefinition defn, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        this.taintedPhi(src, defn, context, path, kind)
        or
        this.taintedAssignment(src, defn, context, path, kind)
        or
        this.taintedAttributeAssignment(src, defn, context, path, kind)
        or
        this.taintedParameterDefinition(src, defn, context, path, kind)
        or
        this.taintedCallsite(src, defn, context, path, kind)
        or
        this.taintedMethodCallsite(src, defn, context, path, kind)
        or
        this.taintedUniEdge(src, defn, context, path, kind)
        or
        this.taintedPiNode(src, defn, context, path, kind)
    }

    pragma [noinline]
    predicate taintedPhi(TaintTrackingNode src, PhiFunction defn, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        exists(DataFlow::Node srcnode, BasicBlock pred, EssaVariable predvar |
            src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
            predvar = defn.getInput(pred) and
            not pred.unlikelySuccessor(defn.getBasicBlock()) and
            not predvar.(DataFlowExtension::DataFlowVariable).prunedSuccessor(defn.getVariable()) and
            srcnode.asVariable() = predvar
        )
    }

    pragma [noinline]
    predicate taintedAssignment(TaintTrackingNode src, AssignmentDefinition defn, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        exists(DataFlow::Node srcnode |
            src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
            defn.getValue() = srcnode.asCfgNode()
        )
    }

    pragma [noinline]
    predicate taintedAttributeAssignment(TaintTrackingNode src, AttributeAssignment defn, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        exists(DataFlow::Node srcnode, AttributePath srcpath, string attrname |
            src = TTaintTrackingNode_(srcnode, context, srcpath, kind, this) and
            defn.getValue() = srcnode.asCfgNode() and
            defn.getName() = attrname and
            path = srcpath.getAttribute(attrname)
        )
    }

    pragma [noinline]
    predicate taintedParameterDefinition(TaintTrackingNode src, ParameterDefinition defn, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        exists(CallNode call, PythonFunctionObjectInternal pyfunc, int arg |
            this.callWithTaintedArgument(src, call, _, pyfunc, arg, path, kind) and
            defn.getDefiningNode() = pyfunc.getParameter(arg) and
            context = TParamContext(kind, path, arg)
        )
    }

    pragma [noinline]
    predicate taintedCallsite(TaintTrackingNode src, CallsiteRefinement defn, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        /* In the interest of simplicity and performance we assume that tainted escaping variables remain tainted across calls.
         * In the cases were this assumption is false, it is easy enough to add an additional barrier.
         */
         exists(DataFlow::Node srcnode |
            src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
            srcnode.asVariable() = defn.getInput()
        )
    }

    pragma [noinline]
    predicate taintedMethodCallsite(TaintTrackingNode src, MethodCallsiteRefinement defn, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        exists(DataFlow::Node srcnode |
            src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
            srcnode.asVariable() = defn.getInput()
        )
    }

    pragma [noinline]
    predicate taintedUniEdge(TaintTrackingNode src, SingleSuccessorGuard defn, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        exists(DataFlow::Node srcnode |
            src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
            srcnode.asVariable() = defn.getInput() and
            not this.(TaintTracking::Configuration).isBarrierTest(defn.getTest(), defn.getSense())
        )
    }

    pragma [noinline]
    predicate taintedPiNode(TaintTrackingNode src, SingleSuccessorGuard defn, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        exists(DataFlow::Node srcnode |
            src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
            srcnode.asVariable() = defn.getInput() and
            not this.(TaintTracking::Configuration).isBarrierTest(defn.getTest(), defn.getSense())
        )
    }

}



