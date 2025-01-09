private import javascript as js
private import semmle.javascript.dataflow.internal.DataFlowNode
private import semmle.javascript.dataflow.internal.VariableOrThis
private import codeql.dataflow.VariableCapture
private import semmle.javascript.dataflow.internal.sharedlib.DataFlowImplCommon as DataFlowImplCommon

module VariableCaptureConfig implements InputSig<js::DbLocation> {
  private js::Function getLambdaFromVariable(js::LocalVariable variable) {
    result.getVariable() = variable
    or
    result = variable.getAnAssignedExpr().getUnderlyingValue()
    or
    exists(js::ClassDeclStmt cls |
      result = cls.getConstructor().getBody() and
      variable = cls.getVariable()
    )
  }

  additional predicate isTopLevelLike(js::StmtContainer container) {
    container instanceof js::TopLevel
    or
    container = any(js::AmdModuleDefinition mod).getFactoryFunction()
    or
    isTopLevelLike(container.(js::ImmediatelyInvokedFunctionExpr).getEnclosingContainer())
    or
    // Containers declaring >100 captured variables tend to be singletons and are too expensive anyway
    strictcount(js::LocalVariable v | v.isCaptured() and v.getDeclaringContainer() = container) >
      100
  }

  class CapturedVariable extends LocalVariableOrThis {
    CapturedVariable() {
      DataFlowImplCommon::forceCachingInSameStage() and
      this.isCaptured() and
      not isTopLevelLike(this.getDeclaringContainer())
    }

    Callable getCallable() { result = this.getDeclaringContainer().getFunctionBoundary() }
  }

  additional predicate captures(js::Function fun, CapturedVariable variable) {
    (
      variable.asLocalVariable().getAnAccess().getContainer().getFunctionBoundary() = fun
      or
      variable.getAThisUse().getUseContainer() = fun
      or
      exists(js::Function inner |
        captures(inner, variable) and
        containsReferenceTo(fun, inner)
      )
    ) and
    not variable.getDeclaringContainer() = fun
  }

  private predicate containsReferenceTo(js::Function fun, js::Function other) {
    other.getEnclosingContainer() = fun
    or
    exists(js::LocalVariable variable |
      other = getLambdaFromVariable(variable) and
      variable.getAnAccess().getEnclosingFunction() = fun and
      fun.getEnclosingContainer() = other.getEnclosingContainer().getEnclosingContainer*() and
      other != fun
    )
  }

  private js::Function getACapturingFunctionInTree(js::AstNode e) {
    result = e and
    captures(e, _)
    or
    not e instanceof js::Function and
    result = getACapturingFunctionInTree(e.getAChild())
  }

  /**
   * Holds if `decl` declares a variable that is captured by its own initializer, that is, the initializer of `decl`.
   *
   * For example, the declaration of `obj` below captures itself in its initializer:
   * ```js
   * const obj = {
   *   method: () => { ...obj... }
   * }
   * ```
   *
   * The lambda can only observe values of `obj` at one of the aliases of that lambda. Due to limited aliases analysis,
   * the only alias we can see is the lambda itself. However, at this stage the `obj` variable is still unassigned, so it
   * just sees its implicit initialization, thus failing to capture any real flows through `obj`.
   *
   * Consider that the similar example does not have this problem:
   *
   * ```js
   * const obj = {};
   * obj.method = () => { ...obj... };
   * ```
   *
   * In this case, `obj` has already been assigned at the point of the lambda creation, so we propagate the correct value
   * into the lambda.
   *
   * Our workaround is to make the first example look like the second one, by placing the assignment of
   * `obj` before the object literal. We do this whenever a variable captures itself in its initializer.
   */
  private predicate isCapturedByOwnInitializer(js::VariableDeclarator decl) {
    exists(js::Function function |
      function = getACapturingFunctionInTree(decl.getInit()) and
      captures(function,
        LocalVariableOrThis::variable(decl.getBindingPattern().(js::VarDecl).getVariable()))
    )
  }

  class ControlFlowNode = js::ControlFlowNode;

  class BasicBlock extends js::BasicBlock {
    Callable getEnclosingCallable() { result = this.getContainer().getFunctionBoundary() }
  }

  class Callable extends js::StmtContainer {
    predicate isConstructor() {
      // JS constructors should not be seen as "constructors" in this context.
      none()
    }
  }

  class CapturedParameter extends CapturedVariable {
    CapturedParameter() { this.asLocalVariable().isParameter() or exists(this.asThisContainer()) }
  }

  class Expr extends js::AST::ValueNode {
    /** Holds if the `i`th node of basic block `bb` evaluates this expression. */
    predicate hasCfgNode(BasicBlock bb, int i) {
      // Note: this is overridden for FunctionDeclStmt
      bb.getNode(i) = this
    }
  }

  class VariableRead extends Expr instanceof js::ControlFlowNode {
    private CapturedVariable variable;

    VariableRead() { this = variable.getAUse() }

    CapturedVariable getVariable() { result = variable }
  }

  class ClosureExpr extends Expr {
    ClosureExpr() { captures(this, _) }

    predicate hasBody(Callable c) { c = this }

    predicate hasAliasedAccess(Expr e) {
      e = this
      or
      e.(js::Expr).getUnderlyingValue() = this
      or
      exists(js::LocalVariable variable |
        this = getLambdaFromVariable(variable) and
        e.(js::Expr).getUnderlyingValue() = variable.getAnAccess()
      )
    }
  }

  private newtype TVariableWrite =
    MkExplicitVariableWrite(js::VarRef pattern) {
      exists(js::DataFlow::lvalueNodeInternal(pattern)) and
      any(CapturedVariable v).asLocalVariable() = pattern.getVariable()
    } or
    MkImplicitVariableInit(CapturedVariable v) { not v instanceof CapturedParameter }

  class VariableWrite extends TVariableWrite {
    CapturedVariable getVariable() { none() } // Overridden in subclass

    string toString() { none() } // Overridden in subclass

    js::DbLocation getLocation() { none() } // Overridden in subclass

    predicate hasCfgNode(BasicBlock bb, int i) { none() } // Overridden in subclass

    // note: langauge-specific
    js::DataFlow::Node getSource() { none() } // Overridden in subclass
  }

  additional class ExplicitVariableWrite extends VariableWrite, MkExplicitVariableWrite {
    private js::VarRef pattern;

    ExplicitVariableWrite() { this = MkExplicitVariableWrite(pattern) }

    override CapturedVariable getVariable() { result.asLocalVariable() = pattern.getVariable() }

    override string toString() { result = pattern.toString() }

    /** Gets the location of this write. */
    override js::DbLocation getLocation() { result = pattern.getLocation() }

    override js::DataFlow::Node getSource() {
      // Note: there is not always an expression corresponding to the RHS of the assignment.
      // We do however have a data-flow node for this purpose (the lvalue-node).
      // We use the pattern as a placeholder here, to be mapped to a data-flow node with `DataFlow::lvalueNode`.
      result = js::DataFlow::lvalueNodeInternal(pattern)
    }

    /**
     * Gets a CFG node that should act at the place where this variable write happens, overriding its "true" CFG node.
     */
    private js::ControlFlowNode getCfgNodeOverride() {
      exists(js::VariableDeclarator decl |
        decl.getBindingPattern() = pattern and
        isCapturedByOwnInitializer(decl) and
        result = decl.getInit().getFirstControlFlowNode()
      )
    }

    /** Holds if the `i`th node of basic block `bb` evaluates this expression. */
    override predicate hasCfgNode(BasicBlock bb, int i) {
      bb.getNode(i) = this.getCfgNodeOverride()
      or
      not exists(this.getCfgNodeOverride()) and
      bb.getNode(i) = pattern.(js::LValue).getDefNode()
    }
  }

  additional class ImplicitVariableInit extends VariableWrite, MkImplicitVariableInit {
    private CapturedVariable variable;

    ImplicitVariableInit() { this = MkImplicitVariableInit(variable) }

    override string toString() { result = "[implicit init] " + variable }

    override js::DbLocation getLocation() { result = variable.getLocation() }

    override CapturedVariable getVariable() { result = variable }

    override predicate hasCfgNode(BasicBlock bb, int i) {
      // 'i' would normally be bound to 0, but we lower it to -1 so FunctionDeclStmts can be evaluated
      // at index 0.
      any(js::SsaImplicitInit def).definesAt(bb, _, variable.asLocalVariable()) and i = -1
      or
      bb.(js::EntryBasicBlock).getContainer() = variable.asThisContainer() and i = -1
    }
  }

  BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

  BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result = bb.getImmediateDominator() }

  predicate entryBlock(BasicBlock bb) { bb instanceof js::EntryBasicBlock }

  predicate exitBlock(BasicBlock bb) { bb.getLastNode() instanceof js::ControlFlowExitNode }
}

module VariableCaptureOutput = Flow<js::DbLocation, VariableCaptureConfig>;

js::DataFlow::Node getNodeFromClosureNode(VariableCaptureOutput::ClosureNode node) {
  result = TValueNode(node.(VariableCaptureOutput::ExprNode).getExpr())
  or
  result =
    TValueNode(node.(VariableCaptureOutput::ParameterNode)
          .getParameter()
          .asLocalVariable()
          .getADeclaration())
  or
  result = TThisNode(node.(VariableCaptureOutput::ParameterNode).getParameter().asThisContainer())
  or
  result = TExprPostUpdateNode(node.(VariableCaptureOutput::ExprPostUpdateNode).getExpr())
  or
  // Note: the `this` parameter in the capture library is expected to be a parameter that refers to the lambda object itself,
  // which for JS means the `TFunctionSelfReferenceNode`, not `TThisNode` as one might expect.
  result = TFunctionSelfReferenceNode(node.(VariableCaptureOutput::ThisParameterNode).getCallable())
  or
  result = TSynthCaptureNode(node.(VariableCaptureOutput::SynthesizedCaptureNode))
  or
  result = node.(VariableCaptureOutput::VariableWriteSourceNode).getVariableWrite().getSource()
}

VariableCaptureOutput::ClosureNode getClosureNode(js::DataFlow::Node node) {
  node = getNodeFromClosureNode(result)
}

private module Debug {
  private import VariableCaptureConfig

  predicate relevantContainer(js::StmtContainer container) {
    container.getEnclosingContainer*().(js::Function).getName() = "exists"
  }

  predicate localFlowStep(
    VariableCaptureOutput::ClosureNode node1, VariableCaptureOutput::ClosureNode node2
  ) {
    VariableCaptureOutput::localFlowStep(node1, node2)
  }

  predicate localFlowStepMapped(js::DataFlow::Node node1, js::DataFlow::Node node2) {
    localFlowStep(getClosureNode(node1), getClosureNode(node2)) and
    relevantContainer(node1.getContainer())
  }

  predicate readBB(VariableRead read, BasicBlock bb, int i) { read.hasCfgNode(bb, i) }

  predicate writeBB(VariableWrite write, BasicBlock bb, int i) { write.hasCfgNode(bb, i) }

  int captureDegree(js::Function fun) {
    result = strictcount(CapturedVariable v | captures(fun, v))
  }

  int maxDegree() { result = max(captureDegree(_)) }

  int captureMax(js::Function fun) { result = captureDegree(fun) and result = maxDegree() }

  int captureMax(js::Function fun, CapturedVariable v) {
    result = captureDegree(fun) and result = maxDegree() and captures(fun, v)
  }
}
