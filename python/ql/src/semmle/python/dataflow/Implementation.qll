import python
import semmle.python.dataflow.TaintTracking
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.Filters as Filters
import semmle.python.dataflow.Legacy

/*
 * See tests/library-tests/taint/examples
 * For examples of taint sources, sinks and flow,
 * including attribute paths, contexts and edges.
 */

newtype TTaintTrackingContext =
  TNoParam() or
  TParamContext(TaintKind param, AttributePath path, int n) {
    any(TaintTrackingImplementation impl).callWithTaintedArgument(_, _, _, _, n, path, param)
  }

/**
 * The context for taint-tracking.
 *  There are two types of contexts:
 *  * No context; the context at a source.
 *  * Tainted parameter; tracks the taint and attribute-path for a parameter
 *    Used to track taint through calls accurately and reasonably efficiently.
 */
class TaintTrackingContext extends TTaintTrackingContext {
  /** Gets a textual representation of this element. */
  string toString() {
    this = TNoParam() and result = ""
    or
    exists(TaintKind param, AttributePath path, int n |
      this = TParamContext(param, path, n) and
      result = "p" + n.toString() + path.extension() + " = " + param
    )
  }

  TaintKind getParameterTaint(int n) { this = TParamContext(result, _, n) }

  AttributePath getAttributePath() { this = TParamContext(_, result, _) }

  TaintTrackingContext getCaller() { result = this.getCaller(_) }

  TaintTrackingContext getCaller(CallNode call) {
    exists(TaintKind param, AttributePath path, int n |
      this = TParamContext(param, path, n) and
      exists(TaintTrackingImplementation impl |
        impl.callWithTaintedArgument(_, call, result, _, n, path, param)
      )
    )
  }

  predicate isTop() { this = TNoParam() }
}

private newtype TAttributePath =
  TNoAttribute() or
  /*
   * It might make sense to add another level, attribute of attribute.
   * But some experimentation would be needed.
   */

  TAttribute(string name) { exists(Attribute a | a.getName() = name) }

/**
 * The attribute of the tracked value holding the taint.
 * This is usually "no attribute".
 * Used for tracking tainted attributes of objects.
 */
abstract class AttributePath extends TAttributePath {
  /** Gets a textual representation of this element. */
  abstract string toString();

  abstract string extension();

  abstract AttributePath fromAttribute(string name);

  AttributePath getAttribute(string name) { this = result.fromAttribute(name) }

  predicate noAttribute() { this = TNoAttribute() }
}

/** AttributePath for no attribute. */
class NoAttribute extends TNoAttribute, AttributePath {
  override string toString() { result = "no attribute" }

  override string extension() { result = "" }

  override AttributePath fromAttribute(string name) { none() }
}

/** AttributePath for an attribute. */
class NamedAttributePath extends TAttribute, AttributePath {
  override string toString() {
    exists(string attr |
      this = TAttribute(attr) and
      result = "attribute " + attr
    )
  }

  override string extension() {
    exists(string attr |
      this = TAttribute(attr) and
      result = "." + attr
    )
  }

  override AttributePath fromAttribute(string name) {
    this = TAttribute(name) and result = TNoAttribute()
  }
}

/**
 * Type representing the (node, context, path, kind) tuple.
 * Construction of this type is mutually recursive with `TaintTrackingImplementation.flowStep(...)`
 */
newtype TTaintTrackingNode =
  TTaintTrackingNode_(
    DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind,
    TaintTracking::Configuration config
  ) {
    config.(TaintTrackingImplementation).flowSource(node, context, path, kind)
    or
    config.(TaintTrackingImplementation).flowStep(_, node, context, path, kind, _)
  }

/**
 * Class representing the (node, context, path, kind) tuple.
 *  Used for context-sensitive path-aware taint-tracking.
 */
class TaintTrackingNode extends TTaintTrackingNode {
  /** Gets a textual representation of this element. */
  string toString() {
    if this.getPath() instanceof NoAttribute
    then result = this.getTaintKind().repr()
    else result = this.getPath().extension() + " = " + this.getTaintKind().repr()
  }

  /** Gets the data flow node for this taint-tracking node */
  DataFlow::Node getNode() { this = TTaintTrackingNode_(result, _, _, _, _) }

  /** Gets the taint kind for this taint-tracking node */
  TaintKind getTaintKind() { this = TTaintTrackingNode_(_, _, _, result, _) }

  /** Gets the taint-tracking context for this taint-tracking node */
  TaintTrackingContext getContext() { this = TTaintTrackingNode_(_, result, _, _, _) }

  /** Gets the attribute path context for this taint-tracking node */
  AttributePath getPath() { this = TTaintTrackingNode_(_, _, result, _, _) }

  TaintTracking::Configuration getConfiguration() { this = TTaintTrackingNode_(_, _, _, _, result) }

  Location getLocation() { result = this.getNode().getLocation() }

  predicate isSource() { this.getConfiguration().(TaintTrackingImplementation).isPathSource(this) }

  predicate isSink() { this.getConfiguration().(TaintTrackingImplementation).isPathSink(this) }

  ControlFlowNode getCfgNode() { result = this.getNode().asCfgNode() }

  /** Get the AST node for this node. */
  AstNode getAstNode() { result = this.getCfgNode().getNode() }

  TaintTrackingNode getASuccessor(string edgeLabel) {
    this.isVisible() and
    result = this.unlabeledSuccessor*().labeledSuccessor(edgeLabel)
  }

  TaintTrackingNode getASuccessor() {
    result = this.getASuccessor(_)
    or
    this.isVisible() and
    result = this.unlabeledSuccessor+() and
    result.isSink()
  }

  private TaintTrackingNode unlabeledSuccessor() {
    this.getConfiguration().(TaintTrackingImplementation).flowStep(this, result, "")
  }

  private TaintTrackingNode labeledSuccessor(string label) {
    not label = "" and
    this.getConfiguration().(TaintTrackingImplementation).flowStep(this, result, label)
  }

  private predicate isVisible() {
    any(TaintTrackingNode pred).labeledSuccessor(_) = this
    or
    this.isSource()
  }

  predicate flowsTo(TaintTrackingNode other) { this.getASuccessor*() = other }
}

/**
 * The implementation of taint-tracking
 * Each `TaintTrackingImplementation` is also a `TaintTracking::Configuration`
 * It is implemented as a separate class for clarity and to keep the code
 * in `TaintTracking::Configuration` simpler.
 */
class TaintTrackingImplementation extends string {
  TaintTrackingImplementation() { this instanceof TaintTracking::Configuration }

  /**
   * Hold if there is a flow from `source`, which is a taint source, to
   * `sink`, which is a taint sink, with this configuration.
   */
  predicate hasFlowPath(TaintTrackingNode source, TaintTrackingNode sink) {
    this.isPathSource(source) and
    this.isPathSink(sink) and
    source.flowsTo(sink)
  }

  /**
   * Hold if `node` is a source of taint `kind` with context `context` and attribute path `path`.
   */
  predicate flowSource(
    DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind
  ) {
    context = TNoParam() and
    path = TNoAttribute() and
    this.(TaintTracking::Configuration).isSource(node, kind)
  }

  /** Hold if `source` is a source of taint. */
  predicate isPathSource(TaintTrackingNode source) {
    exists(DataFlow::Node node, TaintTrackingContext context, AttributePath path, TaintKind kind |
      source = TTaintTrackingNode_(node, context, path, kind, this) and
      this.flowSource(node, context, path, kind)
    )
  }

  /** Hold if `sink` is a taint sink. */
  predicate isPathSink(TaintTrackingNode sink) {
    exists(DataFlow::Node node, AttributePath path, TaintKind kind |
      sink = TTaintTrackingNode_(node, _, path, kind, this) and
      path = TNoAttribute() and
      this.(TaintTracking::Configuration).isSink(node, kind)
    )
  }

  /**
   * Hold if taint flows to `src` to `dest` in a single step, labeled with `edgeLabel`
   * `edgeLabel` is purely informative.
   */
  predicate flowStep(TaintTrackingNode src, TaintTrackingNode dest, string edgeLabel) {
    exists(DataFlow::Node node, TaintTrackingContext ctx, AttributePath path, TaintKind kind |
      dest = TTaintTrackingNode_(node, ctx, path, kind, this) and
      this.flowStep(src, node, ctx, path, kind, edgeLabel)
    )
  }

  /**
   * Hold if taint flows to `src` to `(node, context, path, kind)` in a single step, labelled with `egdeLabel` with this configuration.
   * `edgeLabel` is purely informative.
   */
  predicate flowStep(
    TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path,
    TaintKind kind, string edgeLabel
  ) {
    this.unprunedStep(src, node, context, path, kind, edgeLabel) and
    node.getBasicBlock().likelyReachable() and
    not this.(TaintTracking::Configuration).isBarrier(node) and
    (
      not path = TNoAttribute()
      or
      not this.(TaintTracking::Configuration).isBarrier(node, kind) and
      exists(DataFlow::Node srcnode, TaintKind srckind |
        src = TTaintTrackingNode_(srcnode, _, _, srckind, this) and
        not this.prunedEdge(srcnode, node, srckind, kind)
      )
    )
  }

  private predicate prunedEdge(
    DataFlow::Node srcnode, DataFlow::Node destnode, TaintKind srckind, TaintKind destkind
  ) {
    this.(TaintTracking::Configuration).isBarrierEdge(srcnode, destnode, srckind, destkind)
    or
    srckind = destkind and this.(TaintTracking::Configuration).isBarrierEdge(srcnode, destnode)
  }

  private predicate unprunedStep(
    TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path,
    TaintKind kind, string edgeLabel
  ) {
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
    this.callFlowStep(src, node, context, path, kind, edgeLabel)
    or
    this.iterationStep(src, node, context, path, kind, edgeLabel)
    or
    this.yieldStep(src, node, context, path, kind, edgeLabel)
    or
    this.parameterStep(src, node, context, path, kind, edgeLabel)
    or
    this.ifExpStep(src, node, context, path, kind, edgeLabel)
    or
    this.essaFlowStep(src, node, context, path, kind, edgeLabel)
    or
    this.instantiationStep(src, node, context, path, kind, edgeLabel)
    or
    this.legacyExtensionStep(src, node, context, path, kind, edgeLabel)
    or
    exists(DataFlow::Node srcnode, TaintKind srckind |
      this.(TaintTracking::Configuration).isAdditionalFlowStep(srcnode, node, srckind, kind) and
      src = TTaintTrackingNode_(srcnode, context, path, srckind, this) and
      path.noAttribute() and
      edgeLabel = "additional with kind"
    )
    or
    exists(DataFlow::Node srcnode |
      this.(TaintTracking::Configuration).isAdditionalFlowStep(srcnode, node) and
      src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
      path.noAttribute() and
      edgeLabel = "additional"
    )
    or
    exists(DataFlow::Node srcnode, TaintKind srckind |
      src = TTaintTrackingNode_(srcnode, context, path, srckind, this) and
      path.noAttribute()
    |
      kind = srckind.getTaintForFlowStep(srcnode.asCfgNode(), node.asCfgNode(), edgeLabel)
      or
      kind = srckind.(CollectionKind).getMember() and
      srckind.(CollectionKind).flowToMember(srcnode, node) and
      edgeLabel = "to member"
      or
      srckind = kind.(CollectionKind).getMember() and
      kind.(CollectionKind).flowFromMember(srcnode, node) and
      edgeLabel = "from member"
      or
      kind = srckind and srckind.flowStep(srcnode, node, edgeLabel)
      or
      kind = srckind and
      srckind instanceof DictKind and
      DictKind::flowStep(srcnode.asCfgNode(), node.asCfgNode(), edgeLabel)
      or
      kind = srckind and
      srckind instanceof SequenceKind and
      SequenceKind::flowStep(srcnode.asCfgNode(), node.asCfgNode(), edgeLabel)
    )
  }

  pragma[noinline]
  predicate importStep(
    TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path,
    TaintKind kind, string edgeLabel
  ) {
    edgeLabel = "import" and
    exists(ModuleValue m, string name, AttributePath srcpath |
      src = TTaintTrackingNode_(_, context, srcpath, kind, this) and
      this.moduleAttributeTainted(m, name, src) and
      node.asCfgNode().pointsTo(m) and
      path = srcpath.getAttribute(name)
    )
  }

  pragma[noinline]
  predicate fromImportStep(
    TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path,
    TaintKind kind, string edgeLabel
  ) {
    edgeLabel = "from import" and
    exists(ModuleValue m, string name |
      src = TTaintTrackingNode_(_, context, path, kind, this) and
      this.moduleAttributeTainted(m, name, src) and
      node.asCfgNode().(ImportMemberNode).getModule(name).pointsTo(m)
    )
  }

  pragma[noinline]
  predicate attributeLoadStep(
    TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path,
    TaintKind kind, string edgeLabel
  ) {
    exists(DataFlow::Node srcnode, AttributePath srcpath, string attrname |
      src = TTaintTrackingNode_(srcnode, context, srcpath, kind, this) and
      srcnode.asCfgNode() = node.asCfgNode().(AttrNode).getObject(attrname) and
      path = srcpath.fromAttribute(attrname) and
      edgeLabel = "from path attribute"
    )
    or
    exists(DataFlow::Node srcnode, TaintKind srckind, string attrname |
      src = TTaintTrackingNode_(srcnode, context, path, srckind, this) and
      srcnode.asCfgNode() = node.asCfgNode().(AttrNode).getObject(attrname) and
      kind = srckind.getTaintOfAttribute(attrname) and
      edgeLabel = "from taint attribute" and
      path instanceof NoAttribute
    )
  }

  pragma[noinline]
  predicate getattrStep(
    TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path,
    TaintKind kind, string edgeLabel
  ) {
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
    ) and
    edgeLabel = "getattr"
  }

  pragma[noinline]
  predicate useStep(
    TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path,
    TaintKind kind, string edgeLabel
  ) {
    exists(DataFlow::Node srcnode |
      src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
      node.asCfgNode() = srcnode.asVariable().getASourceUse()
    ) and
    edgeLabel = "use"
  }

  /* If the return value is tainted without context, then it always flows back to the caller */
  pragma[noinline]
  predicate returnFlowStep(
    TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path,
    TaintKind kind, string edgeLabel
  ) {
    exists(CallNode call, PythonFunctionObjectInternal pyfunc, DataFlow::Node retval |
      pyfunc.getACall() = call and
      context = TNoParam() and
      src = TTaintTrackingNode_(retval, TNoParam(), path, kind, this) and
      node.asCfgNode() = call and
      retval.asCfgNode() =
        any(Return ret | ret.getScope() = pyfunc.getScope()).getValue().getAFlowNode()
    ) and
    edgeLabel = "return"
  }

  /*
   * Avoid taint flow from return value to caller as it can produce imprecise flow graphs
   * Step directly from tainted argument to call result.
   */

  pragma[noinline]
  predicate callFlowStep(
    TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path,
    TaintKind kind, string edgeLabel
  ) {
    exists(
      CallNode call, PythonFunctionObjectInternal pyfunc, TaintTrackingContext callee,
      DataFlow::Node retval, TaintTrackingNode retnode
    |
      this.callContexts(call, src, pyfunc, context, callee) and
      retnode = TTaintTrackingNode_(retval, callee, path, kind, this) and
      node.asCfgNode() = call and
      retval.asCfgNode() =
        any(Return ret | ret.getScope() = pyfunc.getScope()).getValue().getAFlowNode()
    ) and
    edgeLabel = "call"
  }

  pragma[noinline]
  predicate callContexts(
    CallNode call, TaintTrackingNode argnode, PythonFunctionObjectInternal pyfunc,
    TaintTrackingContext caller, TaintTrackingContext callee
  ) {
    exists(int arg, TaintKind callerKind, AttributePath callerPath |
      this.callWithTaintedArgument(argnode, call, caller, pyfunc, arg, callerPath, callerKind) and
      callee = TParamContext(callerKind, callerPath, arg)
    )
  }

  predicate callWithTaintedArgument(
    TaintTrackingNode src, CallNode call, TaintTrackingContext caller, CallableValue pyfunc,
    int arg, AttributePath path, TaintKind kind
  ) {
    exists(DataFlow::Node srcnode |
      src = TTaintTrackingNode_(srcnode, caller, path, kind, this) and
      srcnode.asCfgNode() = pyfunc.getArgumentForCall(call, arg)
    )
  }

  predicate instantiationStep(
    TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path,
    TaintKind kind, string edgeLabel
  ) {
    exists(PythonFunctionValue init, EssaVariable self, TaintTrackingContext callee |
      instantiationCall(node.asCfgNode(), src, init, context, callee) and
      this.(EssaTaintTracking).taintedDefinition(_, self.getDefinition(), callee, path, kind) and
      self.getSourceVariable().(Variable).isSelf() and
      BaseFlow::reaches_exit(self) and
      self.getScope() = init.getScope()
    ) and
    edgeLabel = "instantiation"
  }

  predicate instantiationCall(
    CallNode call, TaintTrackingNode argnode, PythonFunctionObjectInternal init,
    TaintTrackingContext caller, TaintTrackingContext callee
  ) {
    exists(ClassValue cls |
      call.getFunction().pointsTo(cls) and
      cls.lookup("__init__") = init
    |
      exists(int arg, TaintKind callerKind, AttributePath callerPath, DataFlow::Node argument |
        argnode = TTaintTrackingNode_(argument, caller, callerPath, callerKind, this) and
        call.getArg(arg - 1) = argument.asCfgNode() and
        callee = TParamContext(callerKind, callerPath, arg)
      )
    )
  }

  pragma[noinline]
  predicate callTaintStep(
    TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path,
    TaintKind kind, string edgeLabel
  ) {
    exists(DataFlow::Node srcnode, CallNode call, TaintKind srckind, string name |
      src = TTaintTrackingNode_(srcnode, context, path, srckind, this) and
      call.getFunction().(AttrNode).getObject(name) = src.getNode().asCfgNode() and
      kind = srckind.getTaintOfMethodResult(name) and
      node.asCfgNode() = call
    ) and
    edgeLabel = "call"
  }

  pragma[noinline]
  predicate iterationStep(
    TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path,
    TaintKind kind, string edgeLabel
  ) {
    exists(ForNode for, DataFlow::Node sequence, TaintKind seqkind |
      src = TTaintTrackingNode_(sequence, context, path, seqkind, this) and
      for.iterates(_, sequence.asCfgNode()) and
      node.asCfgNode() = for and
      path.noAttribute() and
      kind = seqkind.getTaintForIteration()
    ) and
    edgeLabel = "iteration"
  }

  pragma[noinline]
  predicate parameterStep(
    TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path,
    TaintKind kind, string edgeLabel
  ) {
    exists(CallNode call, PythonFunctionObjectInternal pyfunc, int arg |
      this.callWithTaintedArgument(src, call, _, pyfunc, arg, path, kind) and
      node.asCfgNode() = pyfunc.getParameter(arg) and
      context = TParamContext(kind, path, arg)
    ) and
    edgeLabel = "parameter"
  }

  pragma[noinline]
  predicate yieldStep(
    TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path,
    TaintKind kind, string edgeLabel
  ) {
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
    ) and
    edgeLabel = "yield"
  }

  pragma[noinline]
  predicate ifExpStep(
    TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path,
    TaintKind kind, string edgeLabel
  ) {
    exists(DataFlow::Node srcnode |
      src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
      srcnode.asCfgNode() = node.asCfgNode().(IfExprNode).getAnOperand()
    ) and
    edgeLabel = "if exp"
  }

  pragma[noinline]
  predicate essaFlowStep(
    TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path,
    TaintKind kind, string edgeLabel
  ) {
    this
        .(EssaTaintTracking)
        .taintedDefinition(src, node.asVariable().getDefinition(), context, path, kind) and
    edgeLabel = ""
  }

  pragma[noinline]
  predicate legacyExtensionStep(
    TaintTrackingNode src, DataFlow::Node node, TaintTrackingContext context, AttributePath path,
    TaintKind kind, string edgeLabel
  ) {
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
    ) and
    edgeLabel = "legacy extension"
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

/**
 * Another taint-tracking class to help partition the code for clarity
 * This class handle tracking of ESSA variables.
 */
private class EssaTaintTracking extends string {
  EssaTaintTracking() { this instanceof TaintTracking::Configuration }

  pragma[noinline]
  predicate taintedDefinition(
    TaintTrackingNode src, EssaDefinition defn, TaintTrackingContext context, AttributePath path,
    TaintKind kind
  ) {
    this.taintedPhi(src, defn, context, path, kind)
    or
    this.taintedAssignment(src, defn, context, path, kind)
    or
    this.taintedMultiAssignment(src, defn, context, path, kind)
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
    or
    this.taintedScopeEntryDefinition(src, defn, context, path, kind)
    or
    this.taintedWith(src, defn, context, path, kind)
  }

  pragma[noinline]
  private predicate taintedPhi(
    TaintTrackingNode src, PhiFunction defn, TaintTrackingContext context, AttributePath path,
    TaintKind kind
  ) {
    exists(DataFlow::Node srcnode, BasicBlock pred, EssaVariable predvar, DataFlow::Node phi |
      src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
      defn = phi.asVariable().getDefinition() and
      predvar = defn.getInput(pred) and
      not pred.unlikelySuccessor(defn.getBasicBlock()) and
      not this.(TaintTracking::Configuration).isBarrierEdge(srcnode, phi) and
      srcnode.asVariable() = predvar
    )
  }

  pragma[noinline]
  private predicate taintedAssignment(
    TaintTrackingNode src, AssignmentDefinition defn, TaintTrackingContext context,
    AttributePath path, TaintKind kind
  ) {
    exists(DataFlow::Node srcnode |
      src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
      defn.getValue() = srcnode.asCfgNode()
    )
  }

  pragma[noinline]
  private predicate taintedMultiAssignment(
    TaintTrackingNode src, MultiAssignmentDefinition defn, TaintTrackingContext context,
    AttributePath path, TaintKind kind
  ) {
    exists(DataFlow::Node srcnode, TaintKind srckind, Assign assign, int depth |
      src = TTaintTrackingNode_(srcnode, context, path, srckind, this) and
      path.noAttribute()
    |
      assign.getValue().getAFlowNode() = srcnode.asCfgNode() and
      depth = iterable_unpacking_descent(assign.getATarget().getAFlowNode(), defn.getDefiningNode()) and
      kind = taint_at_depth(srckind, depth)
    )
  }

  pragma[noinline]
  private predicate taintedAttributeAssignment(
    TaintTrackingNode src, AttributeAssignment defn, TaintTrackingContext context,
    AttributePath path, TaintKind kind
  ) {
    exists(DataFlow::Node srcnode, AttributePath srcpath, string attrname |
      src = TTaintTrackingNode_(srcnode, context, srcpath, kind, this) and
      defn.getValue() = srcnode.asCfgNode() and
      defn.getName() = attrname and
      path = srcpath.getAttribute(attrname)
    )
  }

  pragma[noinline]
  private predicate taintedParameterDefinition(
    TaintTrackingNode src, ParameterDefinition defn, TaintTrackingContext context,
    AttributePath path, TaintKind kind
  ) {
    exists(DataFlow::Node srcnode |
      src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
      srcnode.asCfgNode() = defn.getDefiningNode()
    )
  }

  pragma[noinline]
  private predicate taintedCallsite(
    TaintTrackingNode src, CallsiteRefinement defn, TaintTrackingContext context,
    AttributePath path, TaintKind kind
  ) {
    /*
     * In the interest of simplicity and performance we assume that tainted escaping variables remain tainted across calls.
     * In the cases were this assumption is false, it is easy enough to add an additional barrier.
     */

    exists(DataFlow::Node srcnode |
      src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
      srcnode.asVariable() = defn.getInput()
    )
  }

  pragma[noinline]
  private predicate taintedMethodCallsite(
    TaintTrackingNode src, MethodCallsiteRefinement defn, TaintTrackingContext context,
    AttributePath path, TaintKind kind
  ) {
    exists(DataFlow::Node srcnode |
      src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
      srcnode.asVariable() = defn.getInput()
    )
  }

  pragma[noinline]
  private predicate taintedUniEdge(
    TaintTrackingNode src, SingleSuccessorGuard defn, TaintTrackingContext context,
    AttributePath path, TaintKind kind
  ) {
    exists(DataFlow::Node srcnode |
      src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
      srcnode.asVariable() = defn.getInput() and
      not this.(TaintTracking::Configuration).isBarrierTest(defn.getTest(), defn.getSense())
    )
  }

  private predicate taintedPiNode(
    TaintTrackingNode src, PyEdgeRefinement defn, TaintTrackingContext context, AttributePath path,
    TaintKind kind
  ) {
    taintedPiNodeOneway(src, defn, context, path, kind)
    or
    taintedPiNodeBothways(src, defn, context, path, kind)
  }

  pragma[noinline]
  private predicate taintedPiNodeOneway(
    TaintTrackingNode src, PyEdgeRefinement defn, TaintTrackingContext context, AttributePath path,
    TaintKind kind
  ) {
    exists(DataFlow::Node srcnode, ControlFlowNode use |
      src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
      not this.(TaintTracking::Configuration).isBarrierTest(defn.getTest(), defn.getSense()) and
      defn.getSense() = testEvaluates(defn, defn.getTest(), use, src)
    )
  }

  pragma[noinline]
  private predicate taintedPiNodeBothways(
    TaintTrackingNode src, PyEdgeRefinement defn, TaintTrackingContext context, AttributePath path,
    TaintKind kind
  ) {
    exists(DataFlow::Node srcnode, ControlFlowNode test, ControlFlowNode use |
      src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
      piNodeTestAndUse(defn, test, use) and
      srcnode.asVariable() = defn.getInput() and
      not this.(TaintTracking::Configuration).isBarrierTest(test, defn.getSense()) and
      testEvaluatesMaybe(test, use)
    )
  }

  pragma[noinline]
  private predicate taintedArgument(
    TaintTrackingNode src, ArgumentRefinement defn, TaintTrackingContext context,
    AttributePath path, TaintKind kind
  ) {
    exists(DataFlow::Node srcnode |
      src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
      defn.getInput() = srcnode.asVariable()
    )
  }

  pragma[noinline]
  private predicate taintedExceptionCapture(
    TaintTrackingNode src, ExceptionCapture defn, TaintTrackingContext context, AttributePath path,
    TaintKind kind
  ) {
    exists(DataFlow::Node srcnode |
      src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
      srcnode.asCfgNode() = defn.getDefiningNode()
    )
  }

  pragma[noinline]
  private predicate taintedScopeEntryDefinition(
    TaintTrackingNode src, ScopeEntryDefinition defn, TaintTrackingContext context,
    AttributePath path, TaintKind kind
  ) {
    exists(EssaVariable var |
      BaseFlow::scope_entry_value_transfer_from_earlier(var, _, defn, _) and
      this.taintedDefinition(src, var.getDefinition(), context, path, kind)
    )
  }

  pragma[noinline]
  private predicate taintedWith(
    TaintTrackingNode src, WithDefinition defn, TaintTrackingContext context, AttributePath path,
    TaintKind kind
  ) {
    exists(DataFlow::Node srcnode |
      src = TTaintTrackingNode_(srcnode, context, path, kind, this) and
      with_flow(_, srcnode.asCfgNode(), defn.getDefiningNode())
    )
  }

  /**
   * Gets the boolean value that `test` evaluates to when `use` is tainted with `kind`
   * and `test` and `use` are part of a test in a branch.
   */
  private boolean testEvaluates(
    PyEdgeRefinement defn, ControlFlowNode test, ControlFlowNode use, TaintTrackingNode src
  ) {
    defn.getTest().getAChild*() = use and
    exists(DataFlow::Node srcnode, TaintKind kind |
      srcnode.asVariable() = defn.getInput() and
      srcnode.asVariable().getASourceUse() = use and
      src = TTaintTrackingNode_(srcnode, _, TNoAttribute(), kind, this)
    |
      test = use and result = kind.booleanValue()
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
        exists(ClassValue scls | scls = kind.getType() |
          scls.getASuperType() = cls and result = true
          or
          not scls.getASuperType() = cls and result = false
        )
        or
        not exists(kind.getType()) and result = maybe()
      )
    )
    or
    result = testEvaluates(defn, not_operand(test), use, src).booleanNot()
  }

  /**
   * Holds if `test` is the test in a branch and `use` is that test
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
}

private predicate testEvaluatesMaybe(ControlFlowNode test, ControlFlowNode use) {
  any(PyEdgeRefinement ref).getTest().getAChild*() = test and
  test.getAChild*() = use and
  not test.(UnaryExprNode).getNode().getOp() instanceof Not and
  not exists(ControlFlowNode const |
    Filters::equality_test(test, use, _, const) and
    const.getNode() instanceof ImmutableLiteral
  ) and
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

/* Helper predicate for tainted_with */
private predicate with_flow(With with, ControlFlowNode contextManager, ControlFlowNode var) {
  with.getContextExpr() = contextManager.getNode() and
  with.getOptionalVars() = var.getNode() and
  contextManager.strictlyDominates(var)
}

/* Helper predicate for taintedPiNode */
pragma[noinline]
private predicate piNodeTestAndUse(PyEdgeRefinement defn, ControlFlowNode test, ControlFlowNode use) {
  test = defn.getTest() and use = defn.getInput().getASourceUse() and test.getAChild*() = use
}

/** Helper predicate for taintedMultiAssignment */
private TaintKind taint_at_depth(SequenceKind parent_kind, int depth) {
  depth >= 0 and
  (
    // base-case #0
    depth = 0 and
    result = parent_kind
    or
    // base-case #1
    depth = 1 and
    result = parent_kind.getMember()
    or
    // recursive case
    depth > 1 and
    result = taint_at_depth(parent_kind.getMember(), depth - 1)
  )
}

/**
 * Helper predicate for taintedMultiAssignment
 *
 * Returns the `depth` the elements that are assigned to `left_defn` with iterable unpacking has,
 * compared to `left_parent`. Special care is taken for `StarredNode` that is assigned a sequence of items.
 *
 * For example, `((x, *y), ...) = value` with any nesting on LHS
 * - with `left_defn` = `x`, `left_parent` = `(x, *y)`, result = 1
 * - with `left_defn` = `x`, `left_parent` = `((x, *y), ...)`, result = 2
 * - with `left_defn` = `*y`, `left_parent` = `(x, *y)`, result = 0
 * - with `left_defn` = `*y`, `left_parent` = `((x, *y), ...)`, result = 1
 */
int iterable_unpacking_descent(SequenceNode left_parent, ControlFlowNode left_defn) {
  exists(Assign a | a.getATarget().getASubExpression*().getAFlowNode() = left_parent) and
  left_parent.getAnElement() = left_defn and
  // Handle `a, *b = some_iterable`
  if left_defn instanceof StarredNode then result = 0 else result = 1
  or
  result = 1 + iterable_unpacking_descent(left_parent.getAnElement(), left_defn)
}

module Implementation {
  /* A call that returns a copy (or similar) of the argument */
  predicate copyCall(ControlFlowNode fromnode, CallNode tonode) {
    tonode.getFunction().(AttrNode).getObject("copy") = fromnode
    or
    exists(ModuleObject copy, string name | name = "copy" or name = "deepcopy" |
      copy.attr(name).(FunctionObject).getACall() = tonode and
      tonode.getArg(0) = fromnode
    )
    or
    tonode.getFunction().pointsTo(ObjectInternal::builtin("reversed")) and
    tonode.getArg(0) = fromnode
  }
}
