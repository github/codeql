import python
import semmle.python.security.TaintTracking
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.Filters as Filters

newtype TTaintTrackingContext =
    TNoParam()
    or
    TParamContext(TaintKind param, AttributePath path, int n) {
        any(TaintTrackingImplementation impl).callWithTaintedArgument(_, _, _, _, n, path, param)
    }

class TaintTrackingContext extends TTaintTrackingContext {

    string toString()  { 
        this = TNoParam() and result = ""
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
        result = this.getCaller(_)
    }

    TaintTrackingContext getCaller(CallNode call) {
        exists(TaintKind param, AttributePath path, int n |
            this = TParamContext(param, path, n) and
            exists(TaintTrackingImplementation impl |
                impl.callWithTaintedArgument(_, call, result, _, n, path, param)
            )
        )
    }

    predicate isTop() {
        this = TNoParam()
    }

}

/* For backwards compatibility -- Use `TaintTrackingContext` instead. */
deprecated
class CallContext extends TaintTrackingContext {

    TaintTrackingContext getCallee(CallNode call) {
        result.getCaller(call) = this
    }

    predicate appliesToScope(Scope s) {
        exists(PythonFunctionObjectInternal func, TaintKind param, AttributePath path, int n |
            this = TParamContext(param, path, n) and
            exists(TaintTrackingImplementation impl |
                impl.callWithTaintedArgument(_, _, _, func, n, path, param) and
                s = func.getScope()
            )
        )
        or
        this.isTop()
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

class NamedAttributePath extends TAttribute, AttributePath {

    override string toString() { 
        exists(string attr |
            this = TAttribute(attr) and
            result = "attribute " + attr
        )
    }

    override string extension() { 
        this = TAttribute(result)
    }

    override AttributePath fromAttribute(string name) {
        this = TAttribute(name) and result = TNoAttribute()
    }

}

newtype TTaintTrackingNode =
    TTaintTrackingNode_(DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind, TaintTracking::Configuration config) {
        config.(TaintTrackingImplementation).flowSource(node, context, path, kind)
        or
        config.(TaintTrackingImplementation).flowStep(_, node, context, path, kind, _)
    }

class TaintTrackingNode extends TTaintTrackingNode {

    string toString() { result = this.getTaintKind().repr() }

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
        result = this.getASuccessor(_)
    }

    TaintTrackingNode getASuccessor(string edgeLabel) {
        this.isVisible() and
        result = this.getAnUnlabeledSuccessor*().getALabeledSuccessor(edgeLabel)
    }

    private TaintTrackingNode getAnUnlabeledSuccessor() {
        this.getConfiguration().(TaintTrackingImplementation).flowStep(this, result, "")
    }

    private TaintTrackingNode getALabeledSuccessor(string label) {
        not label = "" and
        this.getConfiguration().(TaintTrackingImplementation).flowStep(this, result, label)
    }

    predicate isSource() {
        this.getConfiguration().(TaintTrackingImplementation).isPathSource(this)
    }

    predicate isSink() {
        this.getConfiguration().(TaintTrackingImplementation).isPathSink(this)
    }

    ControlFlowNode getCfgNode() {
        result = this.getNode().asCfgNode()
    }

    /** Get the AST node for this node. */
    AstNode getAstNode() {
        result = this.getCfgNode().getNode()
    }

    /** Holds if this node should be presented to the user as part of a path */
    predicate isVisible() {
        this.isSource() or
        exists(string label |
            not label = "" |
            this.getConfiguration().(TaintTrackingImplementation).flowStep(_, this, label)
        )
    }

}

class TaintTrackingImplementation extends string {


    TaintTrackingImplementation() {
        this instanceof TaintTracking::Configuration
    }

    predicate hasFlowPath(TaintTrackingNode source, TaintTrackingNode sink) {
        this.isPathSource(source) and
        this.isPathSink(sink) and
        sink = source.getASuccessor*()
    }

    predicate flowSource(DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        context = TNoParam() and path = TNoAttribute() and
        (
            this.(TaintTracking::Configuration).isSource(node, kind)
            or
            exists(TaintSource source |
                this.(TaintTracking::Configuration).isSource(source) and
                node.asCfgNode() = source and
                source.isSourceOf(kind)
            )
        )
    }


    predicate flowSink(DataFlow::Node node, AttributePath path, TaintKind kind) {
        path = TNoAttribute() and
        (
            this.(TaintTracking::Configuration).isSink(node, kind)
            or
            exists(TaintSink sink |
                this.(TaintTracking::Configuration).isSink(sink) and
                node.asCfgNode() = sink and
                sink.sinks(kind)
            )
        )
    }

    predicate isPathSource(TaintTrackingNode source) {
        exists(DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind |
            source = TTaintTrackingNode_(node, context, path, kind, this) and
            this.flowSource(node, context, path, kind)
        )
    }

    predicate isPathSink(TaintTrackingNode sink) {
        exists(DataFlow::Node node, AttributePath path, TaintKind kind |
            sink = TTaintTrackingNode_(node, _, path, kind, this) and
            this.flowSink(node, path, kind)
        )
    }

    predicate flowStep(TaintTrackingNode src, TaintTrackingNode dest, string edgeLabel) {
        exists(DataFlow::Node node, TaintTrackingContext ctx, AttributePath path, TaintKind kind |
            dest = TTaintTrackingNode_(node, ctx, path, kind, this) and
            this.flowStep(src, node, ctx, path, kind, edgeLabel)
        )
    }

    predicate flowBarrier(DataFlow::Node node, TaintKind kind) {
        this.(TaintTracking::Configuration).isBarrier(node, kind)
        or
        exists(Sanitizer sanitizer |
            this.(TaintTracking::Configuration).isSanitizer(sanitizer)
            |
            sanitizer.sanitizingNode(kind, node.asCfgNode())
            or
            sanitizer.sanitizingDefinition(kind, node.asVariable().getDefinition())
            or
            exists(MethodCallsiteRefinement call, FunctionObject callee |
                call = node.asVariable().getDefinition() and
                callee.getACall() = call.getCall() and
                sanitizer.sanitizingCall(kind, callee)
            )
            or
            sanitizer.sanitizingEdge(kind, node.asVariable().getDefinition())
            or
            sanitizer.sanitizingSingleEdge(kind, node.asVariable().getDefinition())
        )
    }

    /** Gets the boolean value that `test` evaluates to when `use` is tainted with `kind`
     * and `test` and `use` are part of a test in a branch.
     */
    boolean testEvaluates(ControlFlowNode test, ControlFlowNode use, TaintKind kind) {
        boolean_filter(_, use) and
        kind.taints(use) and
        test = use and result = kind.booleanValue()
        or
        result = testEvaluates(not_operand(test), use, kind).booleanNot()
        or
        exists(ControlFlowNode const |
            Filters::equality_test(test, use, result.booleanNot(), const) and
            const.getNode() instanceof ImmutableLiteral
        )
        or
        exists(ControlFlowNode c, ClassValue cls |
            Filters::isinstance(test, c, use) and
            c.pointsTo(cls)
            |
            kind.getType().getASuperType() = cls and result = true
            or
            not kind.getType().getASuperType() = cls and result = false
        )
    }

    predicate testEvaluatesMaybe(ControlFlowNode test, ControlFlowNode use) {
        any(PyEdgeRefinement ref).getTest().getAChild*() = test and
        test.getAChild*() = use and
        not test.(UnaryExprNode).getNode().getOp() instanceof Not and
        not Filters::equality_test(test, use, _, _) and
        not Filters::isinstance(test, _, use) and
        not test = use
        or
        testEvaluatesMaybe(not_operand(test), use)
    }

    /** Gets the operand of a unary `not` expression. */
    private ControlFlowNode not_operand(ControlFlowNode expr) {
        expr.(UnaryExprNode).getNode().getOp() instanceof Not and
        result = expr.(UnaryExprNode).getOperand()
    }

    /** Holds if `test` is the test in a branch and `use` is that test
     * with all the `not` prefixes removed.
     */
    private predicate boolean_filter(ControlFlowNode test, ControlFlowNode use) {
        any(PyEdgeRefinement ref).getTest() = test and
        (
            use = test
            or
            exists(ControlFlowNode notuse |
                boolean_filter(test, notuse) and
                use = not_operand(notuse)
            )
        )
    }

    predicate flowStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind, string edgeLabel) {
        this.unprunedStep(src, node, context, path, kind, edgeLabel) and
        node.getBasicBlock().likelyReachable() and
        not this.(TaintTracking::Configuration).isBarrier(node) and
        (
            not path = TNoAttribute()
            or
            not this.flowBarrier(node, kind) and
            exists(DataFlow::Node srcnode, TaintKind srckind |
                src = TTaintTrackingNode_(srcnode, _, _, srckind, this) and
                not this.prunedEdge(srcnode, node, srckind, kind)
            )
        )
    }

    predicate prunedEdge(DataFlow::Node srcnode, DataFlow::Node destnode, TaintKind srckind, TaintKind destkind) {
        this.(TaintTracking::Configuration).isBarrierEdge(srcnode, destnode, srckind, destkind)
        or
        srckind = destkind and this.(TaintTracking::Configuration).isBarrierEdge(srcnode, destnode)
    }

    predicate unprunedStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind, string edgeLabel) {
        this.importStep(src, node, context, path, kind, edgeLabel)
        or
        this.fromImportStep(src, node, context, path, kind, edgeLabel)
        or
        this.attributeLoadStep(src, node, context, path, kind, edgeLabel)
        or
        this.getattrStep(src, node, context, path, kind, edgeLabel)
        or
        this.useStep(src, node, context, path, kind, edgeLabel)
        or
        this.callTaintStep(src, node, context, path, kind, edgeLabel)
        or
        this.returnFlowStep(src, node, context, path, kind, edgeLabel)
        or
        this.iterationStep(src, node, context, path, kind, edgeLabel)
        or
        this.yieldStep(src, node, context, path, kind, edgeLabel)
        or
        this.parameterStep(src, node, context, path, kind, edgeLabel)
        or
        this.ifExpStep(src, node, context, path, kind, edgeLabel)
        or
        this.essaFlowStep(src, node, context, path, kind) and edgeLabel = ""
        or
        this.legacyExtensionStep(src, node, context, path, kind, edgeLabel)
        or
        exists(DataFlow::Node srcnode, TaintKind srckind |
            this.(TaintTracking::Configuration).isAdditionalFlowStep(srcnode, node, srckind, kind) and
            src = TTaintTrackingNode_(srcnode, context, path, srckind, this) and
            path.noAttribute() and edgeLabel = "additional with kind"
        )
        or
        exists(DataFlow::Node srcnode |
            this.(TaintTracking::Configuration).isAdditionalFlowStep(srcnode, node) and
            src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
            path.noAttribute() and edgeLabel = "additional"
        )
        or
        exists(DataFlow::Node srcnode, TaintKind srckind |
            src = TTaintTrackingNode_(srcnode, context, path, srckind, this) and
            path.noAttribute()
            |
            kind = srckind.getTaintForFlowStep(srcnode.asCfgNode(), node.asCfgNode(), edgeLabel)
            or
            kind.isResultOfStep(srckind, srcnode.asCfgNode(), node.asCfgNode(), edgeLabel)
        )
    }

    pragma [noinline]
    predicate importStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind, string edgeLabel) {
        edgeLabel = "import" and
        exists(ModuleValue m, string name |
            src = TTaintTrackingNode_(_, context, TNoAttribute(), kind, this) and
            this.moduleAttributeTainted(m, name, src) and
            node.asCfgNode().(ImportExprNode).pointsTo(m) and
            path = TAttribute(name)
        )
    }

    pragma [noinline]
    predicate fromImportStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind, string edgeLabel) {
        edgeLabel = "from import" and
        exists(ModuleValue m, string name |
            src = TTaintTrackingNode_(_, context, path, kind, this) and
            this.moduleAttributeTainted(m, name, src) and
            node.asCfgNode().(ImportMemberNode).getModule(name).pointsTo(m)
        )
    }

    pragma [noinline]
    predicate attributeLoadStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind, string edgeLabel) {
        exists(DataFlow::Node srcnode, AttributePath srcpath, string attrname |
            src = TTaintTrackingNode_(srcnode, context, srcpath, kind, this) and
            srcnode.asCfgNode() = node.asCfgNode().(AttrNode).getObject(attrname) and
            path = srcpath.fromAttribute(attrname) and edgeLabel = "from path attribute"
        )
        or
        exists(DataFlow::Node srcnode, TaintKind srckind, string attrname |
            src = TTaintTrackingNode_(srcnode, context, path, srckind, this) and
            srcnode.asCfgNode() = node.asCfgNode().(AttrNode).getObject(attrname) and
            kind = srckind.getTaintOfAttribute(attrname) and edgeLabel = "from taint attribute"
        )
    }

    pragma [noinline]
    predicate getattrStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind, string edgeLabel) {
        exists(DataFlow::Node srcnode, AttributePath srcpath, TaintKind srckind, string attrname |
            src = TTaintTrackingNode_(srcnode, context, srcpath, srckind, this) and
            exists(CallNode call, ControlFlowNode arg |
                call = node.asCfgNode() and
                call.getFunction().pointsTo(ObjectInternal::builtin("getattr")) and
                arg = call.getArg(0) and
                attrname = call.getArg(1).getNode().(StrConst).getText() and
                arg = srcnode.asCfgNode()
                |
                path = srcpath.fromAttribute(attrname) and
                kind = srckind
                or
                path = srcpath and
                kind = srckind.getTaintOfAttribute(attrname)
            )
        ) and edgeLabel = "getattr"
    }

    pragma [noinline]
    predicate useStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind, string edgeLabel) {
        exists(DataFlow::Node srcnode |
            src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
            node.asCfgNode() = srcnode.asVariable().getASourceUse()
        ) and edgeLabel = "use"
    }

    //pragma [noinline]
    //predicate argumentFlowStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind, string edgeLabel) {
    //    exists(CallNode call, PythonFunctionObjectInternal pyfunc, int arg |
    //        this.callWithTaintedArgument(src, call, _, pyfunc, arg, path, kind) and
    //        node.asCfgNode() = pyfunc.getParameter(arg) and
    //        context = TParamContext(kind, arg)
    //    )
    //    // TO DO... named parameters
    //}

    pragma [noinline]
    predicate returnFlowStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind, string edgeLabel) {
        exists(CallNode call, PythonFunctionObjectInternal pyfunc, int arg, TaintKind callerKind, DataFlow::Node srcNode, AttributePath callerPath, TaintTrackingContext srcContext |
            src = TTaintTrackingNode_(srcNode, srcContext, path, kind, this) and
            this.callWithTaintedArgument(_, call, context, pyfunc, arg, callerPath, callerKind) and
            srcContext = TParamContext(callerKind, callerPath, arg) and
            node.asCfgNode() = call and
            srcNode.asCfgNode() = any(Return ret | ret.getScope() = pyfunc.getScope()).getValue().getAFlowNode()
        ) and
        edgeLabel = "return"
    }

    predicate callWithTaintedArgument(TaintTrackingNode src, CallNode call, TaintTrackingContext caller, CallableValue pyfunc, int arg, AttributePath path, TaintKind kind) {
        exists(DataFlow::Node srcnode |
            src = TTaintTrackingNode_(srcnode, caller, path, kind, this) and
            srcnode.asCfgNode() = pyfunc.getArgumentForCall(call, arg)
        )
    }

    pragma [noinline]
    predicate callTaintStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind, string edgeLabel) {
        exists(DataFlow::Node srcnode, CallNode call, TaintKind srckind, string name |
            src = TTaintTrackingNode_(srcnode, context, path, srckind, this) and
            call.getFunction().(AttrNode).getObject(name) = src.getNode().asCfgNode() and
            kind = srckind.getTaintOfMethodResult(name) and
            node.asCfgNode() = call
        ) and edgeLabel = "call"
    }

    pragma [noinline]
    predicate iterationStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind, string edgeLabel) {
        exists(ForNode for, DataFlow::Node sequence, TaintKind seqkind |
            src = TTaintTrackingNode_(sequence, context, path, seqkind, this) and
            for.iterates(_, sequence.asCfgNode()) and
            node.asCfgNode() = for and
            path.noAttribute() and
            kind = seqkind.getTaintForIteration()
        ) and edgeLabel = "iteration"
    }

    pragma [noinline]
    predicate parameterStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind, string edgeLabel) {
        exists(CallNode call, PythonFunctionObjectInternal pyfunc, int arg |
            this.callWithTaintedArgument(src, call, _, pyfunc, arg, path, kind) and
            node.asCfgNode() = pyfunc.getParameter(arg) and
            context = TParamContext(kind, path, arg)
        ) and edgeLabel = "parameter"
    }

    pragma [noinline]
    predicate yieldStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind, string edgeLabel) {
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
        ) and edgeLabel = "yield"
    }

    pragma [noinline]
    predicate ifExpStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind, string edgeLabel) {
        exists(DataFlow::Node srcnode |
            src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
            srcnode.asCfgNode() = node.asCfgNode().(IfExprNode).getAnOperand()
        ) and edgeLabel = "if exp"
    }

    pragma [noinline]
    predicate essaFlowStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        this.taintedDefinition(src, node.asVariable().getDefinition(), context, path, kind)
    }

    pragma [noinline]
    predicate legacyExtensionStep(TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind, string edgeLabel) {
        exists(TaintTracking::Extension extension, DataFlow::Node srcnode, TaintKind srckind |
            this.(TaintTracking::Configuration).isExtension(extension) and
            src = TTaintTrackingNode_(srcnode, context, path, srckind, this) and
            srcnode.asCfgNode() = extension
            |
            extension.getASuccessorNode() = node.asCfgNode() and kind = srckind
            or
            extension.getASuccessorNode(srckind, kind) = node.asCfgNode()
            or
            extension.getASuccessorVariable() = node.asVariable() and kind = srckind
        ) and edgeLabel = "legacy extension"
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
        or
        this.taintedArgument(src, defn, context, path, kind)
        or
        this.taintedExceptionCapture(src, defn, context, path, kind)
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
        exists(DataFlow::Node srcnode |
            src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
            srcnode.asCfgNode() = defn.getDefiningNode()
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
    predicate taintedPiNode(TaintTrackingNode src, PyEdgeRefinement defn, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        exists(DataFlow::Node srcnode |
            src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
            srcnode.asVariable() = defn.getInput() and
            not this.(TaintTracking::Configuration).isBarrierTest(defn.getTest(), defn.getSense())
            |
            defn.getSense() = testEvaluates(defn.getTest(), defn.getInput().getSourceVariable().getAUse(), kind)
            or
            testEvaluatesMaybe(defn.getTest(), defn.getInput().getSourceVariable().getAUse())
        )
    }

    pragma [noinline]
    predicate taintedArgument(TaintTrackingNode src, ArgumentRefinement defn, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        exists(DataFlow::Node srcnode |
            src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
            defn.getInput() = srcnode.asVariable()
        )
    }


    pragma [noinline]
    predicate taintedExceptionCapture(TaintTrackingNode src, ExceptionCapture defn, TaintTrackingContext context, AttributePath path, TaintKind kind) {
        exists(DataFlow::Node srcnode |
            src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
            srcnode.asCfgNode() = defn.getDefiningNode()
        )
    }

    predicate moduleAttributeTainted(ModuleValue m, string name, TaintTrackingNode taint) {
        exists(DataFlow::Node srcnode, EssaVariable var |
            taint = TTaintTrackingNode_(srcnode, TNoParam(), _, _, this) and
            var = srcnode.asVariable() and
            var.getName() = name and
            BaseFlow::reaches_exit(var) and
            var.getScope() = m.getScope()
        )
    }

}

/* Backwards compatibility with config-less taint-tracking */
private class LegacyConfiguration extends TaintTracking::Configuration {

    LegacyConfiguration() {
        /* A name that won't be accidentally chosen by users */
        this = "Semmle: Internal legacy configuration"
    }

    override predicate isSource(DataFlow::Node source, TaintKind kind) {
        isValid() and
        exists(TaintSource src |
            source.asCfgNode() = src and
            src.isSourceOf(kind)
        )
    }

    override predicate isSink(DataFlow::Node sink, TaintKind kind) {
        isValid() and
        exists(TaintSink snk |
            sink.asCfgNode() = snk and
            snk.sinks(kind)
        )
    }

    override predicate isSanitizer(Sanitizer sanitizer) {
        isValid() and
        sanitizer = sanitizer
    }

    private predicate isValid() {
        not exists(TaintTracking::Configuration config | config != this)
    }

}

module Implementation {

    /* A call that returns a copy (or similar) of the argument */
    predicate copyCall(ControlFlowNode fromnode, CallNode tonode) {
        tonode.getFunction().(AttrNode).getObject("copy") = fromnode
        or
        exists(ModuleObject copy, string name |
            name = "copy" or name = "deepcopy" |
            copy.attr(name).(FunctionObject).getACall() = tonode and
            tonode.getArg(0) = fromnode
        )
        or
        tonode.getFunction().pointsTo(ObjectInternal::builtin("reversed")) and
        tonode.getArg(0) = fromnode
    }

}

