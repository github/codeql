/** Provides predicates for synthesizing AST nodes. */

private import AST
private import TreeSitter
private import codeql.ruby.ast.internal.Call
private import codeql.ruby.ast.internal.Constant
private import codeql.ruby.ast.internal.Expr
private import codeql.ruby.ast.internal.Variable
private import codeql.ruby.ast.internal.Pattern
private import codeql.ruby.ast.internal.Scope
private import codeql.ruby.AST

/** A synthesized AST node kind. */
newtype SynthKind =
  AddExprKind() or
  AssignExprKind() or
  BitwiseAndExprKind() or
  BitwiseOrExprKind() or
  BitwiseXorExprKind() or
  BooleanLiteralKind(boolean value) { value = true or value = false } or
  BraceBlockKind() or
  CaseMatchKind() or
  ClassVariableAccessKind(ClassVariable v) or
  DefinedExprKind() or
  DivExprKind() or
  ElseKind() or
  ExponentExprKind() or
  GlobalVariableAccessKind(GlobalVariable v) or
  IfKind() or
  InClauseKind() or
  InstanceVariableAccessKind(InstanceVariable v) or
  IntegerLiteralKind(int i) { i in [-1000 .. 1000] } or
  LShiftExprKind() or
  LocalVariableAccessRealKind(LocalVariableReal v) or
  LocalVariableAccessSynthKind(TLocalVariableSynth v) or
  LogicalAndExprKind() or
  LogicalOrExprKind() or
  MethodCallKind(string name, boolean setter, int arity) {
    any(Synthesis s).methodCall(name, setter, arity)
  } or
  ModuloExprKind() or
  MulExprKind() or
  NilLiteralKind() or
  NotExprKind() or
  RangeLiteralKind(boolean inclusive) { inclusive in [false, true] } or
  RShiftExprKind() or
  SimpleParameterKind() or
  SplatExprKind() or
  StmtSequenceKind() or
  SelfKind(SelfVariable v) or
  SubExprKind() or
  ConstantReadAccessKind(string value) { any(Synthesis s).constantReadAccess(value) } or
  ConstantWriteAccessKind(string value) { any(Synthesis s).constantWriteAccess(value) }

/**
 * An AST child.
 *
 * Either a new synthesized node or a reference to an existing node.
 */
newtype Child =
  SynthChild(SynthKind k) or
  RealChildRef(TAstNodeReal n) or
  SynthChildRef(TAstNodeSynth n)

/**
 * The purpose of this inlined predicate is to split up child references into
 * those that are from real AST nodes (for which there will be no recursion
 * through `RealChildRef`), and those that are synthesized recursively
 * (for which there will be recursion through `SynthChildRef`).
 *
 * This performs much better than having a combined `ChildRef` that includes
 * both real and synthesized AST nodes, since the recursion happening in
 * `Synthesis::child/3` is non-linear.
 */
pragma[inline]
private Child childRef(TAstNode n) {
  result = RealChildRef(n)
  or
  result = SynthChildRef(n)
}

private newtype TSynthesis = MkSynthesis()

/** A class used for synthesizing AST nodes. */
class Synthesis extends TSynthesis {
  /**
   * Holds if a node should be synthesized as the `i`th child of `parent`, or if
   * a non-synthesized node should be the `i`th child of synthesized node `parent`.
   *
   * `i = -1` is used to represent that the synthesized node is a desugared version
   * of its parent.
   */
  predicate child(AstNode parent, int i, Child child) { none() }

  /**
   * Holds if synthesized node `n` should have location `l`. Synthesized nodes for
   * which this predicate does not hold, inherit their location (recursively) from
   * their parent node.
   */
  predicate location(AstNode n, Location l) { none() }

  /**
   * Holds if a local variable, identified by `i`, should be synthesized for AST
   * node `n`.
   */
  predicate localVariable(AstNode n, int i) { none() }

  /**
   * Holds if a method call to `name` with arity `arity` is needed.
   */
  predicate methodCall(string name, boolean setter, int arity) { none() }

  /**
   * Holds if a constant read access of `name` is needed.
   */
  predicate constantReadAccess(string name) { none() }

  /**
   * Holds if a constant write access of `name` is needed.
   */
  predicate constantWriteAccess(string name) { none() }

  /**
   * Holds if `n` should be excluded from `ControlFlowTree` in the CFG construction.
   */
  predicate excludeFromControlFlowTree(AstNode n) { none() }

  final string toString() { none() }
}

private class Desugared extends AstNode {
  Desugared() { this = any(AstNode sugar).getDesugared() }

  AstNode getADescendant() {
    result = this
    or
    result = this.getADescendant().getAChild()
  }
}

/**
 * Gets the desugaring level of `n`. That is, the number of desugaring
 * transformations required before the context in which `n` occurs is
 * fully desugared.
 */
int desugarLevel(AstNode n) { result = count(Desugared desugared | n = desugared.getADescendant()) }

/**
 * Holds if `n` appears in a context that is desugared. That is, a
 * transitive, reflexive parent of `n` is a desugared node.
 */
predicate isInDesugaredContext(AstNode n) {
  n = any(AstNode sugar).getDesugared() or
  n = any(AstNode mid | isInDesugaredContext(mid)).getAChild()
}

/**
 * Holds if `n` is a node that only exists as a result of desugaring some
 * other node.
 */
predicate isDesugarNode(AstNode n) {
  n = any(AstNode sugar).getDesugared()
  or
  isInDesugaredContext(n) and
  forall(AstNode parent | parent = n.getParent() | parent.isSynthesized())
}

/**
 * Use this predicate in `Synthesis::child` to generate an assignment of `value` to
 * synthesized variable `v`, where the assignment is a child of `assignParent` at
 * index `assignIndex`.
 */
bindingset[v, assignParent, assignIndex, value]
private predicate assign(
  AstNode parent, int i, Child child, TLocalVariableSynth v, AstNode assignParent, int assignIndex,
  AstNode value
) {
  parent = assignParent and
  i = assignIndex and
  child = SynthChild(AssignExprKind())
  or
  parent = TAssignExprSynth(assignParent, assignIndex) and
  (
    i = 0 and
    child = SynthChild(LocalVariableAccessSynthKind(v))
    or
    i = 1 and
    child = childRef(value)
  )
}

/** Holds if synthesized node `n` should have location `l`. */
predicate synthLocation(AstNode n, Location l) {
  n.isSynthesized() and any(Synthesis s).location(n, l)
}

private predicate hasLocation(AstNode n, Location l) {
  l = toGenerated(n).getLocation()
  or
  synthLocation(n, l)
}

private module ImplicitSelfSynthesis {
  pragma[nomagic]
  private predicate identifierMethodCallSelfSynthesis(AstNode mc, int i, Child child) {
    child = SynthChild(SelfKind(TSelfVariable(scopeOf(toGenerated(mc)).getEnclosingSelfScope()))) and
    mc = TIdentifierMethodCall(_) and
    i = 0
  }

  private class IdentifierMethodCallSelfSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child) {
      identifierMethodCallSelfSynthesis(parent, i, child)
    }
  }

  pragma[nomagic]
  private predicate regularMethodCallSelfSynthesis(TRegularMethodCall mc, int i, Child child) {
    exists(Ruby::AstNode g |
      mc = TRegularMethodCall(g) and
      // If there's no explicit receiver, then the receiver is implicitly `self`.
      not exists(g.(Ruby::Call).getReceiver())
    ) and
    child = SynthChild(SelfKind(TSelfVariable(scopeOf(toGenerated(mc)).getEnclosingSelfScope()))) and
    i = 0
  }

  private class RegularMethodCallSelfSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child) {
      regularMethodCallSelfSynthesis(parent, i, child)
    }
  }

  pragma[nomagic]
  private AstNode instanceVarAccessSynthParentStar(InstanceVariableAccess var) {
    result = var
    or
    instanceVarAccessSynthParentStar(var) = getSynthChild(result, _)
  }

  /**
   * Gets the `SelfKind` for instance variable access `var`. This is based on the
   * "owner" of `var`; for real nodes this is the node itself, for synthetic nodes
   * this is the closest parent that is a real node.
   */
  pragma[nomagic]
  private SelfKind getSelfKind(InstanceVariableAccess var) {
    exists(Ruby::AstNode owner |
      owner = toGenerated(instanceVarAccessSynthParentStar(var)) and
      result = SelfKind(TSelfVariable(scopeOf(owner).getEnclosingSelfScope()))
    )
  }

  pragma[nomagic]
  private predicate instanceVariableSelfSynthesis(InstanceVariableAccess var, int i, Child child) {
    child = SynthChild(getSelfKind(var)) and
    i = 0
  }

  private class InstanceVariableSelfSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child) {
      instanceVariableSelfSynthesis(parent, i, child)
    }
  }
}

private module SetterDesugar {
  /** An assignment where the left-hand side is a method call. */
  private class SetterAssignExpr extends AssignExpr {
    private MethodCall mc;

    pragma[nomagic]
    SetterAssignExpr() { mc = this.getLeftOperand() }

    MethodCall getMethodCall() { result = mc }

    pragma[nomagic]
    private string getMethodName() { result = mc.getMethodName() }

    pragma[nomagic]
    MethodCallKind getCallKind(int arity) {
      result = MethodCallKind(this.getMethodName(), true, arity)
    }

    pragma[nomagic]
    Expr getReceiver() { result = mc.getReceiver() }

    pragma[nomagic]
    Expr getArgument(int i) { result = mc.getArgument(i) }

    pragma[nomagic]
    int getNumberOfArguments() { result = mc.getNumberOfArguments() }

    pragma[nomagic]
    Location getMethodCallLocation() { hasLocation(mc, result) }
  }

  pragma[nomagic]
  private predicate setterMethodCallSynthesis(AstNode parent, int i, Child child) {
    exists(SetterAssignExpr sae |
      parent = sae and
      i = -1 and
      child = SynthChild(StmtSequenceKind())
      or
      exists(AstNode seq | seq = TStmtSequenceSynth(sae, -1) |
        parent = seq and
        i = 0 and
        child = SynthChild(sae.getCallKind(sae.getNumberOfArguments() + 1))
        or
        exists(AstNode call | call = TMethodCallSynth(seq, 0, _, _, _) |
          parent = call and
          i = 0 and
          child = childRef(sae.getReceiver())
          or
          parent = call and
          child = childRef(sae.getArgument(i - 1))
          or
          exists(int valueIndex | valueIndex = sae.getNumberOfArguments() + 1 |
            parent = call and
            i = valueIndex and
            child = SynthChild(AssignExprKind())
            or
            parent = TAssignExprSynth(call, valueIndex) and
            (
              i = 0 and
              child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(sae, 0)))
              or
              i = 1 and
              child = childRef(sae.getRightOperand())
            )
          )
        )
        or
        parent = seq and
        i = 1 and
        child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(sae, 0)))
      )
    )
  }

  /**
   * ```rb
   * x.foo = y
   * ```
   *
   * desugars to
   *
   * ```rb
   * x.foo=(__synth_0 = y);
   * __synth_0;
   * ```
   */
  private class SetterMethodCallSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child) {
      setterMethodCallSynthesis(parent, i, child)
    }

    final override predicate location(AstNode n, Location l) {
      exists(SetterMethodCall sae, Assignment arg, AstNode lhs, AstNode rhs |
        arg = sae.getArgument(sae.getNumberOfArguments() - 1) and
        lhs = arg.getLeftOperand() and
        rhs = arg.getRightOperand() and
        n = [arg, lhs] and
        hasLocation(rhs, l)
      )
      or
      exists(SetterAssignExpr sae, StmtSequence seq |
        seq = sae.getDesugared() and
        l = sae.getMethodCallLocation() and
        n = seq.getAStmt()
      )
    }

    final override predicate excludeFromControlFlowTree(AstNode n) {
      n = any(SetterAssignExpr sae).getMethodCall()
    }

    final override predicate localVariable(AstNode n, int i) {
      n instanceof SetterAssignExpr and
      i = 0
    }

    final override predicate methodCall(string name, boolean setter, int arity) {
      exists(SetterAssignExpr sae |
        name = sae.getMethodCall().getMethodName() and
        setter = true and
        arity = sae.getNumberOfArguments() + 1
      )
    }
  }
}

private module AssignOperationDesugar {
  /**
   * Gets the operator kind to synthesize for operator assignment `ao`.
   */
  private SynthKind getKind(AssignOperation ao) {
    ao instanceof AssignAddExpr and result = AddExprKind()
    or
    ao instanceof AssignSubExpr and result = SubExprKind()
    or
    ao instanceof AssignMulExpr and result = MulExprKind()
    or
    ao instanceof AssignDivExpr and result = DivExprKind()
    or
    ao instanceof AssignModuloExpr and result = ModuloExprKind()
    or
    ao instanceof AssignExponentExpr and result = ExponentExprKind()
    or
    ao instanceof AssignLogicalAndExpr and result = LogicalAndExprKind()
    or
    ao instanceof AssignLogicalOrExpr and result = LogicalOrExprKind()
    or
    ao instanceof AssignLShiftExpr and result = LShiftExprKind()
    or
    ao instanceof AssignRShiftExpr and result = RShiftExprKind()
    or
    ao instanceof AssignBitwiseAndExpr and result = BitwiseAndExprKind()
    or
    ao instanceof AssignBitwiseOrExpr and result = BitwiseOrExprKind()
    or
    ao instanceof AssignBitwiseXorExpr and result = BitwiseXorExprKind()
  }

  private Location getAssignOperationLocation(AssignOperation ao) {
    exists(Ruby::OperatorAssignment g, Ruby::Token op |
      g = toGenerated(ao) and
      op.getParent() = g and
      op.getParentIndex() = 1 and
      result = op.getLocation()
    )
  }

  /** An assignment operation where the left-hand side is a variable. */
  private class VariableAssignOperation extends AssignOperation {
    private Variable v;

    pragma[nomagic]
    VariableAssignOperation() { v = this.getLeftOperand().(VariableAccess).getVariable() }

    pragma[nomagic]
    SynthKind getVariableAccessKind() {
      result in [
          LocalVariableAccessRealKind(v).(SynthKind), InstanceVariableAccessKind(v),
          ClassVariableAccessKind(v), GlobalVariableAccessKind(v)
        ]
    }
  }

  pragma[nomagic]
  private predicate variableAssignOperationSynthesis(AstNode parent, int i, Child child) {
    exists(VariableAssignOperation vao |
      parent = vao and
      i = -1 and
      child = SynthChild(AssignExprKind())
      or
      exists(AstNode assign | assign = TAssignExprSynth(vao, -1) |
        parent = assign and
        i = 0 and
        child = childRef(vao.getLeftOperand())
        or
        parent = assign and
        i = 1 and
        child = SynthChild(getKind(vao))
        or
        parent = getSynthChild(assign, 1) and
        (
          i = 0 and
          child = SynthChild(vao.getVariableAccessKind())
          or
          i = 1 and
          child = childRef(vao.getRightOperand())
        )
      )
    )
  }

  /**
   * ```rb
   * x += y
   * ```
   *
   * desugars to
   *
   * ```rb
   * x = x + y
   * ```
   *
   * when `x` is a variable.
   */
  private class VariableAssignOperationSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child) {
      variableAssignOperationSynthesis(parent, i, child)
    }

    final override predicate location(AstNode n, Location l) {
      exists(VariableAssignOperation vao, BinaryOperation bo |
        bo = vao.getDesugared().(AssignExpr).getRightOperand()
      |
        n = bo and
        l = getAssignOperationLocation(vao)
        or
        n = bo.getLeftOperand() and
        hasLocation(vao.getLeftOperand(), l)
      )
    }
  }

  /**
   * An assignment operation where the left-hand side is a constant
   * without scope expression, such as`FOO` or `::Foo`.
   */
  private class ConstantAssignOperation extends AssignOperation {
    string name;

    pragma[nomagic]
    ConstantAssignOperation() {
      name =
        any(Ruby::Constant constant | TTokenConstantAccess(constant) = this.getLeftOperand())
            .getValue()
      or
      name =
        "::" +
          any(Ruby::Constant constant |
            TScopeResolutionConstantAccess(any(Ruby::ScopeResolution g | not exists(g.getScope())),
              constant) = this.getLeftOperand()
          ).getValue()
    }

    final string getName() { result = name }
  }

  pragma[nomagic]
  private predicate constantAssignOperationSynthesis(AstNode parent, int i, Child child) {
    exists(ConstantAssignOperation cao |
      parent = cao and
      i = -1 and
      child = SynthChild(AssignExprKind())
      or
      exists(AstNode assign | assign = TAssignExprSynth(cao, -1) |
        parent = assign and
        i = 0 and
        child = childRef(cao.getLeftOperand())
        or
        parent = assign and
        i = 1 and
        child = SynthChild(getKind(cao))
        or
        parent = getSynthChild(assign, 1) and
        (
          i = 0 and
          child = SynthChild(ConstantReadAccessKind(cao.getName()))
          or
          i = 1 and
          child = childRef(cao.getRightOperand())
        )
      )
    )
  }

  /**
   * ```rb
   * FOO += y
   * ```
   *
   * desugars to
   *
   * ```rb
   * FOO = FOO + y
   * ```
   */
  private class ConstantAssignOperationSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child) {
      constantAssignOperationSynthesis(parent, i, child)
    }

    final override predicate constantReadAccess(string name) {
      name = any(ConstantAssignOperation o).getName()
    }

    final override predicate location(AstNode n, Location l) {
      exists(ConstantAssignOperation cao, BinaryOperation bo |
        bo = cao.getDesugared().(AssignExpr).getRightOperand()
      |
        n = bo and
        l = getAssignOperationLocation(cao)
        or
        n = bo.getLeftOperand() and
        hasLocation(cao.getLeftOperand(), l)
      )
    }
  }

  /**
   * An assignment operation where the left-hand side is a constant
   * with scope expression, such as `expr::FOO`.
   */
  private class ScopeResolutionAssignOperation extends AssignOperation {
    string name;
    Expr scope;

    pragma[nomagic]
    ScopeResolutionAssignOperation() {
      exists(Ruby::Constant constant, Ruby::ScopeResolution g |
        TScopeResolutionConstantAccess(g, constant) = this.getLeftOperand() and
        name = constant.getValue() and
        toGenerated(scope) = g.getScope()
      )
    }

    final string getName() { result = name }

    final Expr getScopeExpr() { result = scope }
  }

  pragma[nomagic]
  private predicate scopeResolutionAssignOperationSynthesis(AstNode parent, int i, Child child) {
    exists(ScopeResolutionAssignOperation cao |
      parent = cao and
      i = -1 and
      child = SynthChild(StmtSequenceKind())
      or
      exists(AstNode stmts | stmts = TStmtSequenceSynth(cao, -1) |
        parent = stmts and
        i = 0 and
        child = SynthChild(AssignExprKind())
        or
        exists(AstNode assign | assign = TAssignExprSynth(stmts, 0) |
          parent = assign and
          i = 0 and
          child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(cao, 0)))
          or
          parent = assign and
          i = 1 and
          child = childRef(cao.getScopeExpr())
        )
        or
        parent = stmts and
        i = 1 and
        child = SynthChild(AssignExprKind())
        or
        exists(AstNode assign | assign = TAssignExprSynth(stmts, 1) |
          parent = assign and
          i = 0 and
          child = SynthChild(ConstantWriteAccessKind(cao.getName()))
          or
          exists(AstNode cwa | cwa = TConstantWriteAccessSynth(assign, 0, cao.getName()) |
            parent = cwa and
            i = 0 and
            child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(cao, 0)))
          )
          or
          parent = assign and
          i = 1 and
          child = SynthChild(getKind(cao))
          or
          exists(AstNode op | op = getSynthChild(assign, 1) |
            parent = op and
            i = 0 and
            child = SynthChild(ConstantReadAccessKind(cao.getName()))
            or
            exists(AstNode cra | cra = TConstantReadAccessSynth(op, 0, cao.getName()) |
              parent = cra and
              i = 0 and
              child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(cao, 0)))
            )
            or
            parent = op and
            i = 1 and
            child = childRef(cao.getRightOperand())
          )
        )
      )
    )
  }

  /**
   * ```rb
   * expr::FOO += y
   * ```
   *
   * desugars to
   *
   * ```rb
   * __synth__0 = expr
   * __synth__0::FOO = _synth__0::FOO + y
   * ```
   */
  private class ScopeResolutionAssignOperationSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child) {
      scopeResolutionAssignOperationSynthesis(parent, i, child)
    }

    final override predicate constantReadAccess(string name) {
      name = any(ScopeResolutionAssignOperation o).getName()
    }

    final override predicate localVariable(AstNode n, int i) {
      n instanceof ScopeResolutionAssignOperation and
      i = 0
    }

    final override predicate constantWriteAccess(string name) { this.constantReadAccess(name) }

    final override predicate location(AstNode n, Location l) {
      exists(ScopeResolutionAssignOperation cao, StmtSequence stmts | stmts = cao.getDesugared() |
        n = stmts.getStmt(0) and
        hasLocation(cao.getScopeExpr(), l)
        or
        exists(AssignExpr assign | assign = stmts.getStmt(1) |
          n = assign and hasLocation(cao, l)
          or
          n = assign.getLeftOperand() and
          hasLocation(cao.getLeftOperand(), l)
          or
          n = assign.getLeftOperand().(ConstantAccess).getScopeExpr() and
          hasLocation(cao.getScopeExpr(), l)
          or
          exists(BinaryOperation bo | bo = assign.getRightOperand() |
            n = bo and
            l = getAssignOperationLocation(cao)
            or
            n = bo.getLeftOperand() and
            hasLocation(cao.getLeftOperand(), l)
            or
            n = bo.getLeftOperand().(ConstantAccess).getScopeExpr() and
            hasLocation(cao.getScopeExpr(), l)
          )
        )
      )
    }
  }

  /** An assignment operation where the left-hand side is a method call. */
  private class SetterAssignOperation extends AssignOperation {
    private MethodCall mc;

    pragma[nomagic]
    SetterAssignOperation() { mc = this.getLeftOperand() }

    MethodCall getMethodCall() { result = mc }

    pragma[nomagic]
    private string getMethodName() { result = mc.getMethodName() }

    pragma[nomagic]
    MethodCallKind getCallKind(boolean setter, int arity) {
      result = MethodCallKind(this.getMethodName(), setter, arity)
    }

    pragma[nomagic]
    Expr getReceiver() { result = mc.getReceiver() }

    pragma[nomagic]
    Expr getArgument(int i) { result = mc.getArgument(i) }

    pragma[nomagic]
    int getNumberOfArguments() { result = mc.getNumberOfArguments() }

    pragma[nomagic]
    Location getMethodCallLocation() { hasLocation(mc, result) }
  }

  pragma[nomagic]
  private predicate methodCallAssignOperationSynthesis(AstNode parent, int i, Child child) {
    exists(SetterAssignOperation sao |
      parent = sao and
      i = -1 and
      child = SynthChild(StmtSequenceKind())
      or
      exists(AstNode seq | seq = TStmtSequenceSynth(sao, -1) |
        // `__synth__0 = foo`
        assign(parent, i, child, TLocalVariableSynth(sao, 0), seq, 0, sao.getReceiver())
        or
        // `__synth__1 = bar`
        exists(Expr arg, int j | arg = sao.getArgument(j - 1) |
          assign(parent, i, child, TLocalVariableSynth(sao, j), seq, j, arg)
        )
        or
        // `__synth__2 = __synth__0.[](__synth__1) + y`
        exists(int opAssignIndex | opAssignIndex = sao.getNumberOfArguments() + 1 |
          parent = seq and
          i = opAssignIndex and
          child = SynthChild(AssignExprKind())
          or
          exists(AstNode assign | assign = TAssignExprSynth(seq, opAssignIndex) |
            parent = assign and
            i = 0 and
            child =
              SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(sao, opAssignIndex)))
            or
            parent = assign and
            i = 1 and
            child = SynthChild(getKind(sao))
            or
            // `__synth__0.[](__synth__1) + y`
            exists(AstNode op | op = getSynthChild(assign, 1) |
              parent = op and
              i = 0 and
              child = SynthChild(sao.getCallKind(false, sao.getNumberOfArguments()))
              or
              parent = TMethodCallSynth(op, 0, _, _, _) and
              child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(sao, i))) and
              i in [0 .. sao.getNumberOfArguments()]
              or
              parent = op and
              i = 1 and
              child = childRef(sao.getRightOperand())
            )
          )
          or
          // `__synth__0.[]=(__synth__1, __synth__2);`
          parent = seq and
          i = opAssignIndex + 1 and
          child = SynthChild(sao.getCallKind(true, opAssignIndex))
          or
          exists(AstNode setter | setter = TMethodCallSynth(seq, opAssignIndex + 1, _, _, _) |
            parent = setter and
            child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(sao, i))) and
            i in [0 .. sao.getNumberOfArguments()]
            or
            parent = setter and
            i = opAssignIndex and
            child =
              SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(sao, opAssignIndex)))
          )
          or
          parent = seq and
          i = opAssignIndex + 2 and
          child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(sao, opAssignIndex)))
        )
      )
    )
  }

  /**
   * ```rb
   * foo[bar] += y
   * ```
   *
   * desugars to
   *
   * ```rb
   * __synth__0 = foo;
   * __synth__1 = bar;
   * __synth__2 = __synth__0.[](__synth__1) + y;
   * __synth__0.[]=(__synth__1, __synth__2);
   * __synth__2;
   * ```
   */
  private class MethodCallAssignOperationSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child) {
      methodCallAssignOperationSynthesis(parent, i, child)
    }

    final override predicate location(AstNode n, Location l) {
      exists(SetterAssignOperation sao, StmtSequence seq | seq = sao.getDesugared() |
        n = seq.getStmt(0) and
        hasLocation(sao.getReceiver(), l)
        or
        exists(int i |
          n = seq.getStmt(i + 1) and
          hasLocation(sao.getArgument(i), l)
        )
        or
        exists(AssignExpr ae, int opAssignIndex |
          opAssignIndex = sao.getNumberOfArguments() + 1 and
          ae = seq.getStmt(opAssignIndex)
        |
          l = getAssignOperationLocation(sao) and
          n = ae
          or
          exists(BinaryOperation bo | bo = ae.getRightOperand() |
            n = bo.getLeftOperand() and
            l = sao.getMethodCallLocation()
            or
            exists(MethodCall mc | mc = bo.getLeftOperand() |
              n = mc.getReceiver() and
              hasLocation(sao.getReceiver(), l)
              or
              exists(int i |
                n = mc.getArgument(i) and
                hasLocation(sao.getArgument(i), l)
              )
            )
          )
          or
          exists(MethodCall mc | mc = seq.getStmt(opAssignIndex + 1) |
            n = mc and
            l = sao.getMethodCallLocation()
            or
            n = mc.getReceiver() and
            hasLocation(sao.getReceiver(), l)
            or
            exists(int i | n = mc.getArgument(i) |
              hasLocation(sao.getArgument(i), l)
              or
              i = opAssignIndex and
              l = getAssignOperationLocation(sao)
            )
          )
          or
          n = seq.getStmt(opAssignIndex + 2) and
          l = getAssignOperationLocation(sao)
        )
      )
    }

    final override predicate localVariable(AstNode n, int i) {
      n = any(SetterAssignOperation sao | i in [0 .. sao.getNumberOfArguments() + 1])
    }

    final override predicate methodCall(string name, boolean setter, int arity) {
      exists(SetterAssignOperation sao | name = sao.getMethodCall().getMethodName() |
        setter = false and
        arity = sao.getNumberOfArguments()
        or
        setter = true and
        arity = sao.getNumberOfArguments() + 1
      )
    }

    final override predicate excludeFromControlFlowTree(AstNode n) {
      n = any(SetterAssignOperation sao).getMethodCall()
    }
  }
}

private module DestructuredAssignDesugar {
  /** A destructured assignment. */
  private class DestructuredAssignExpr extends AssignExpr {
    private DestructuredLhsExpr lhs;

    pragma[nomagic]
    DestructuredAssignExpr() { lhs = this.getLeftOperand() }

    DestructuredLhsExpr getLhs() { result = lhs }

    pragma[nomagic]
    Expr getElement(int i) { result = lhs.getElement(i) }

    pragma[nomagic]
    int getNumberOfElements() {
      toGenerated(lhs) = any(DestructuredLhsExprImpl impl | result = count(impl.getChildNode(_)))
    }

    pragma[nomagic]
    int getRestIndexOrNumberOfElements() {
      result = lhs.getRestIndex()
      or
      toGenerated(lhs) = any(DestructuredLhsExprImpl impl | not exists(impl.getRestIndex())) and
      result = this.getNumberOfElements()
    }
  }

  abstract private class LhsWithReceiver extends Expr {
    LhsWithReceiver() { this = any(DestructuredAssignExpr dae).getElement(_) }

    abstract Expr getReceiver();

    abstract SynthKind getSynthKind();
  }

  private class LhsCall extends LhsWithReceiver instanceof MethodCall {
    final override Expr getReceiver() { result = MethodCall.super.getReceiver() }

    pragma[nomagic]
    private string getMethodName(int args) {
      result = super.getMethodName() and
      args = super.getNumberOfArguments()
    }

    final override SynthKind getSynthKind() {
      exists(int args | result = MethodCallKind(this.getMethodName(args), false, args))
    }
  }

  private class LhsScopedConstant extends LhsWithReceiver, ScopeResolutionConstantAccess {
    LhsScopedConstant() { exists(this.getScopeExpr()) }

    final override Expr getReceiver() { result = this.getScopeExpr() }

    final override SynthKind getSynthKind() { result = ConstantWriteAccessKind(this.getName()) }
  }

  pragma[nomagic]
  private predicate destructuredAssignSynthesis(AstNode parent, int i, Child child) {
    exists(DestructuredAssignExpr tae, int total | total = tae.getNumberOfElements() |
      parent = tae and
      i = -1 and
      child = SynthChild(StmtSequenceKind())
      or
      exists(AstNode seq | seq = TStmtSequenceSynth(tae, -1) |
        exists(LhsWithReceiver mc, int j | mc = tae.getElement(j) |
          parent = seq and
          i = j and
          child = SynthChild(AssignExprKind())
          or
          exists(AstNode assign | assign = TAssignExprSynth(seq, j) |
            parent = assign and
            i = 0 and
            child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(tae, j)))
            or
            parent = assign and
            i = 1 and
            child = childRef(mc.getReceiver())
          )
        )
        or
        parent = seq and
        i = total and
        child = SynthChild(AssignExprKind())
        or
        exists(AstNode assign | assign = TAssignExprSynth(seq, total) |
          parent = assign and
          i = 0 and
          child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(tae, total)))
          or
          parent = assign and
          i = 1 and
          child = SynthChild(SplatExprKind())
          or
          parent = TSplatExprSynth(assign, 1) and
          i = 0 and
          child = childRef(tae.getRightOperand())
        )
        or
        exists(AstNode elem, int j, int restIndex |
          elem = tae.getElement(j) and
          restIndex = tae.getRestIndexOrNumberOfElements()
        |
          parent = seq and
          i = j + 1 + total and
          child = SynthChild(AssignExprKind())
          or
          exists(AstNode assign | assign = TAssignExprSynth(seq, j + 1 + total) |
            exists(LhsWithReceiver mc | mc = elem |
              parent = assign and
              i = 0 and
              child = SynthChild(mc.getSynthKind())
              or
              exists(AstNode call | synthChild(assign, 0, call) |
                parent = call and
                i = 0 and
                child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(tae, j)))
                or
                parent = call and
                child = childRef(mc.(MethodCall).getArgument(i - 1))
              )
            )
            or
            (
              elem instanceof VariableAccess
              or
              elem instanceof ConstantAccess and
              not exists(Ruby::ScopeResolution g |
                elem = TScopeResolutionConstantAccess(g, _) and exists(g.getScope())
              )
              or
              elem instanceof DestructuredLhsExpr
            ) and
            parent = assign and
            i = 0 and
            child = childRef(elem)
            or
            parent = assign and
            i = 1 and
            child = SynthChild(MethodCallKind("[]", false, 1))
            or
            parent = TMethodCallSynth(assign, 1, _, _, _) and
            i = 0 and
            child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(tae, total)))
            or
            j < restIndex and
            parent = TMethodCallSynth(assign, 1, _, _, _) and
            i = 1 and
            child = SynthChild(IntegerLiteralKind(j))
            or
            j = restIndex and
            (
              parent = TMethodCallSynth(assign, 1, _, _, _) and
              i = 1 and
              child = SynthChild(RangeLiteralKind(true))
              or
              exists(AstNode call |
                call = TMethodCallSynth(assign, 1, _, _, _) and
                parent = TRangeLiteralSynth(call, 1, _)
              |
                i = 0 and
                child = SynthChild(IntegerLiteralKind(j))
                or
                i = 1 and
                child = SynthChild(IntegerLiteralKind(restIndex - total))
              )
            )
            or
            j > restIndex and
            parent = TMethodCallSynth(assign, 1, _, _, _) and
            i = 1 and
            child = SynthChild(IntegerLiteralKind(j - total))
          )
        )
      )
    )
  }

  /**
   * ```rb
   * x, *y, z = w
   * ```
   * desugars to
   *
   * ```rb
   * __synth__0 = *w;
   * x = __synth__0[0];
   * y = __synth__0[1..-2];
   * z = __synth__0[-1];
   * ```
   */
  private class DestructuredAssignSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child) {
      destructuredAssignSynthesis(parent, i, child)
    }

    final override predicate location(AstNode n, Location l) {
      exists(DestructuredAssignExpr tae, StmtSequence seq | seq = tae.getDesugared() |
        synthChild(seq, tae.getNumberOfElements(), n) and
        hasLocation(tae.getRightOperand(), l)
        or
        exists(LhsWithReceiver elem, int j |
          elem = tae.getElement(j) and
          synthChild(seq, j, n) and
          hasLocation(elem.getReceiver(), l)
        )
        or
        exists(AstNode elem, int j | elem = tae.getElement(j) |
          synthChild(seq, j + 1 + tae.getNumberOfElements(), n) and
          hasLocation(elem, l)
        )
      )
    }

    final override predicate localVariable(AstNode n, int i) {
      i = [0 .. n.(DestructuredAssignExpr).getNumberOfElements()]
    }

    final override predicate constantWriteAccess(string name) {
      exists(DestructuredAssignExpr tae, LhsScopedConstant ca |
        ca = tae.getElement(_) and
        name = ca.getName()
      )
    }

    final override predicate methodCall(string name, boolean setter, int arity) {
      name = "[]" and
      setter = false and
      arity = 1
      or
      exists(DestructuredAssignExpr tae, MethodCall mc |
        mc = tae.getElement(_) and
        name = mc.getMethodName() and
        setter = false and
        arity = mc.getNumberOfArguments()
      )
    }

    final override predicate excludeFromControlFlowTree(AstNode n) { n instanceof LhsWithReceiver }
  }
}

private module ArrayLiteralDesugar {
  pragma[nomagic]
  private predicate arrayLiteralSynthesis(AstNode parent, int i, Child child) {
    exists(ArrayLiteral al |
      parent = al and
      i = -1 and
      child = SynthChild(MethodCallKind("[]", false, al.getNumberOfElements()))
      or
      parent = TMethodCallSynth(al, -1, _, _, _) and
      i = 0 and
      child = SynthChild(ConstantReadAccessKind("::Array"))
      or
      parent = TMethodCallSynth(al, -1, _, _, _) and
      child = childRef(al.getElement(i - 1))
    )
  }

  /**
   * ```rb
   * [1, 2, 3]
   * ```
   * desugars to
   *
   * ```rb
   * ::Array.[](1, 2, 3)
   * ```
   */
  private class ArrayLiteralSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child) {
      arrayLiteralSynthesis(parent, i, child)
    }

    final override predicate methodCall(string name, boolean setter, int arity) {
      name = "[]" and
      setter = false and
      arity = any(ArrayLiteral al).getNumberOfElements()
    }

    final override predicate constantReadAccess(string name) { name = "::Array" }
  }
}

private module HashLiteralDesugar {
  pragma[nomagic]
  private predicate hashLiteralSynthesis(AstNode parent, int i, Child child) {
    exists(HashLiteral hl |
      parent = hl and
      i = -1 and
      child = SynthChild(MethodCallKind("[]", false, hl.getNumberOfElements()))
      or
      parent = TMethodCallSynth(hl, -1, _, _, _) and
      i = 0 and
      child = SynthChild(ConstantReadAccessKind("::Hash"))
      or
      parent = TMethodCallSynth(hl, -1, _, _, _) and
      child = childRef(hl.getElement(i - 1))
    )
  }

  /**
   * ```rb
   * { a: 1, **splat, b: 2 }
   * ```
   * desugars to
   *
   * ```rb
   * ::Hash.[](a: 1, **splat, b: 2)
   * ```
   */
  private class HashLiteralSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child) {
      hashLiteralSynthesis(parent, i, child)
    }

    final override predicate methodCall(string name, boolean setter, int arity) {
      name = "[]" and
      setter = false and
      arity = any(HashLiteral hl).getNumberOfElements()
    }

    final override predicate constantReadAccess(string name) { name = "::Hash" }
  }
}

/**
 * ```rb
 * for x in xs
 *   <loop_body>
 * end
 * ```
 * desugars to, roughly,
 * ```rb
 * if not defined? x then x = nil end
 * xs.each { |__synth__0| x = __synth__0; <loop_body> }
 * ```
 *
 * Note that for-loops, unlike blocks, do not create a new variable scope, so
 * variables within this block inherit the enclosing scope. The exception to
 * this is the synthesized variable declared by the block parameter, which is
 * scoped to the synthesized block.
 */
private module ForLoopDesugar {
  private Ruby::AstNode getForLoopPatternChild(Ruby::For for) {
    result = for.getPattern()
    or
    result.getParent() = getForLoopPatternChild(for)
  }

  /** Holds if `n` is an access to variable `v` in the pattern of `for`. */
  pragma[nomagic]
  private predicate forLoopVariableAccess(Ruby::For for, Ruby::AstNode n, VariableReal v) {
    n = getForLoopPatternChild(for) and
    access(n, v)
  }

  /** Holds if `v` is the `i`th iteration variable of `for`. */
  private predicate forLoopVariable(Ruby::For for, VariableReal v, int i) {
    v =
      rank[i + 1](VariableReal v0, Ruby::AstNode n, Location l |
        forLoopVariableAccess(for, n, v0) and
        l = n.getLocation()
      |
        v0 order by l.getStartLine(), l.getStartColumn()
      )
  }

  /** Gets the number of iteration variables of `for`. */
  private int forLoopVariableCount(Ruby::For for) {
    result = count(int j | forLoopVariable(for, _, j))
  }

  private Ruby::For toTsFor(ForExpr for) { for = TForExpr(result) }

  /**
   * Synthesizes an assignment
   * ```rb
   * if not defined? v then v = nil end
   * ```
   * anchored at index `rootIndex` of `root`.
   */
  bindingset[root, rootIndex, v]
  private predicate nilAssignUndefined(
    AstNode root, int rootIndex, AstNode parent, int i, Child child, VariableReal v
  ) {
    parent = root and
    i = rootIndex and
    child = SynthChild(IfKind())
    or
    exists(AstNode if_ | if_ = TIfSynth(root, rootIndex) |
      parent = if_ and
      i = 0 and
      child = SynthChild(NotExprKind())
      or
      exists(AstNode not_ | not_ = TNotExprSynth(if_, 0) |
        parent = not_ and
        i = 0 and
        child = SynthChild(DefinedExprKind())
        or
        parent = TDefinedExprSynth(not_, 0) and
        i = 0 and
        child = SynthChild(LocalVariableAccessRealKind(v))
      )
      or
      parent = if_ and
      i = 1 and
      child = SynthChild(AssignExprKind())
      or
      parent = TAssignExprSynth(if_, 1) and
      (
        i = 0 and
        child = SynthChild(LocalVariableAccessRealKind(v))
        or
        i = 1 and
        child = SynthChild(NilLiteralKind())
      )
    )
  }

  pragma[nomagic]
  private predicate forLoopSynthesis(AstNode parent, int i, Child child) {
    exists(ForExpr for |
      parent = for and
      i = -1 and
      child = SynthChild(StmtSequenceKind())
      or
      exists(AstNode seq | seq = TStmtSequenceSynth(for, -1) |
        exists(VariableReal v, int j | forLoopVariable(toTsFor(for), v, j) |
          nilAssignUndefined(seq, j, parent, i, child, v)
        )
        or
        exists(int numberOfVars | numberOfVars = forLoopVariableCount(toTsFor(for)) |
          // each call
          parent = seq and
          i = numberOfVars and
          child = SynthChild(MethodCallKind("each", false, 0))
          or
          exists(MethodCall eachCall |
            eachCall = TMethodCallSynth(seq, numberOfVars, "each", false, 0)
          |
            // receiver
            parent = eachCall and
            i = 0 and
            child = childRef(for.getValue()) // value is the Enumerable
            or
            parent = eachCall and
            i = 1 and
            child = SynthChild(BraceBlockKind())
            or
            exists(Block block | block = TBraceBlockSynth(eachCall, 1) |
              // block params
              parent = block and
              i = 0 and
              child = SynthChild(SimpleParameterKind())
              or
              exists(SimpleParameter param | param = TSimpleParameterSynth(block, 0) |
                parent = param and
                i = 0 and
                child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(param, 0)))
                or
                // assignment to pattern from for loop to synth parameter
                parent = block and
                i = 1 and
                child = SynthChild(AssignExprKind())
                or
                parent = TAssignExprSynth(block, 1) and
                (
                  i = 0 and
                  child = childRef(for.getPattern())
                  or
                  i = 1 and
                  child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(param, 0)))
                )
              )
              or
              // rest of block body
              parent = block and
              child = childRef(for.getBody().(Do).getStmt(i - 2))
            )
          )
        )
      )
    )
  }

  pragma[nomagic]
  private predicate isDesugaredInitNode(ForExpr for, Variable v, AstNode n) {
    exists(StmtSequence seq, AssignExpr ae |
      seq = for.getDesugared() and
      n = seq.getStmt(_) and
      ae = n.(IfExpr).getThen() and
      v = ae.getLeftOperand().getAVariable()
    )
    or
    isDesugaredInitNode(for, v, n.getParent())
  }

  private class ForLoopSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child) {
      forLoopSynthesis(parent, i, child)
    }

    final override predicate methodCall(string name, boolean setter, int arity) {
      name = "each" and
      setter = false and
      arity = 0
    }

    final override predicate localVariable(AstNode n, int i) {
      n instanceof TSimpleParameterSynth and
      i = 0
    }

    final override predicate excludeFromControlFlowTree(AstNode n) {
      n = any(ForExpr for).getBody()
    }

    final override predicate location(AstNode n, Location l) {
      exists(ForExpr for, Ruby::AstNode access, Variable v |
        forLoopVariableAccess(toTsFor(for), access, v) and
        isDesugaredInitNode(for, v, n) and
        l = access.getLocation()
      )
    }
  }
}

/**
 * ```rb
 * { a: }
 * ```
 * desugars to,
 * ```rb
 * { a: a }
 * ```
 */
private module ImplicitHashValueSynthesis {
  private Ruby::AstNode keyWithoutValue(AstNode parent, int i) {
    exists(Ruby::KeywordPattern pair |
      result = pair.getKey() and
      result = toGenerated(parent.(HashPattern).getKey(i)) and
      not exists(pair.getValue())
    )
    or
    exists(Ruby::Pair pair |
      i = 0 and
      result = pair.getKey() and
      pair = toGenerated(parent) and
      not exists(pair.getValue())
    )
  }

  private string keyName(Ruby::AstNode key) {
    result = key.(Ruby::String).getChild(0).(Ruby::StringContent).getValue() or
    result = key.(Ruby::HashKeySymbol).getValue()
  }

  private class ImplicitHashValueSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child) {
      exists(Ruby::AstNode key | key = keyWithoutValue(parent, i) |
        exists(TVariableReal variable |
          access(key, variable) and
          child = SynthChild(LocalVariableAccessRealKind(variable))
        )
        or
        not access(key, _) and
        exists(string name | name = keyName(key) |
          child = SynthChild(ConstantReadAccessKind(name)) or
          child = SynthChild(MethodCallKind(name, false, 0))
        )
      )
    }

    final override predicate methodCall(string name, boolean setter, int arity) {
      setter = false and
      arity = 0 and
      name = keyName(keyWithoutValue(_, _)) and
      not name.charAt(0).isUppercase()
    }

    final override predicate constantReadAccess(string name) {
      name = keyName(keyWithoutValue(_, _)) and
      name.charAt(0).isUppercase()
    }

    final override predicate location(AstNode n, Location l) {
      exists(AstNode p, int i | l = keyWithoutValue(p, i).getLocation() |
        n = p.(HashPattern).getValue(i)
        or
        i = 0 and n = p.(Pair).getValue()
      )
    }
  }
}

/**
 * ```rb
 * def foo(*, **, &)
 *   bar(*, **, &)
 * end
 * ```
 * desugars to,
 * ```rb
 * def foo(*__synth_0, **__synth_1, &__synth_2)
 *   bar(*__synth_0, **__synth_1, &__synth_2)
 * end
 * ```
 */
private module AnonymousParameterSynth {
  private class AnonymousParameter = TBlockParameter or THashSplatParameter or TSplatParameter;

  private class AnonymousArgument = TBlockArgument or THashSplatExpr or TSplatExpr;

  private AnonymousParameter anonymousParameter() {
    exists(Ruby::BlockParameter p | not exists(p.getName()) and toGenerated(result) = p)
    or
    exists(Ruby::SplatParameter p | not exists(p.getName()) and toGenerated(result) = p)
    or
    exists(Ruby::HashSplatParameter p | not exists(p.getName()) and toGenerated(result) = p)
  }

  private AnonymousArgument anonymousArgument() {
    exists(Ruby::BlockArgument p | not exists(p.getChild()) and toGenerated(result) = p)
    or
    exists(Ruby::SplatArgument p | not exists(p.getChild()) and toGenerated(result) = p)
    or
    exists(Ruby::HashSplatArgument p | not exists(p.getChild()) and toGenerated(result) = p)
  }

  private class AnonymousParameterSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child) {
      i = 0 and
      parent = anonymousParameter() and
      child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(parent, 0)))
    }

    final override predicate localVariable(AstNode n, int i) { n = anonymousParameter() and i = 0 }
  }

  private class AnonymousArgumentSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child) {
      i = 0 and
      parent = anonymousArgument() and
      exists(AnonymousParameter param |
        param = anonymousParameter() and
        scopeOf(toGenerated(parent)).getEnclosingMethod() = scopeOf(toGenerated(param)) and
        child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(param, 0)))
      |
        param instanceof TBlockParameter and parent instanceof TBlockArgument
        or
        param instanceof TSplatParameter and parent instanceof TSplatExpr
        or
        param instanceof THashSplatParameter and parent instanceof THashSplatExpr
      )
    }
  }
}

private module SafeNavigationCallDesugar {
  /**
   * ```rb
   * receiver&.method(args) { ... }
   * ```
   * desugars to
   *
   * ```rb
   * __synth__0 = receiver
   * if nil == __synth__0 then nil else __synth__0.method(args) {...} end
   * ```
   */
  pragma[nomagic]
  private predicate safeNavigationCallSynthesis(AstNode parent, int i, Child child) {
    exists(RegularMethodCall call, LocalVariableAccessSynthKind local |
      call.isSafeNavigationImpl() and
      local = LocalVariableAccessSynthKind(TLocalVariableSynth(call.getReceiverImpl(), 0))
    |
      parent = call and
      i = -1 and
      child = SynthChild(StmtSequenceKind())
      or
      exists(TStmtSequenceSynth seq | seq = TStmtSequenceSynth(call, -1) |
        parent = seq and
        (
          child = SynthChild(AssignExprKind()) and i = 0
          or
          child = SynthChild(IfKind()) and i = 1
        )
        or
        parent = TAssignExprSynth(seq, 0) and
        (
          child = SynthChild(local) and
          i = 0
          or
          child = childRef(call.getReceiverImpl()) and i = 1
        )
        or
        exists(TIfSynth ifExpr | ifExpr = TIfSynth(seq, 1) |
          parent = ifExpr and
          (
            child = SynthChild(MethodCallKind("==", false, 2)) and
            i = 0
            or
            child = SynthChild(NilLiteralKind()) and i = 1
            or
            child =
              SynthChild(MethodCallKind(call.getMethodNameImpl(), false,
                  call.getNumberOfArgumentsImpl())) and
            i = 2
          )
          or
          parent = TMethodCallSynth(ifExpr, 0, _, _, _) and
          (
            child = SynthChild(NilLiteralKind()) and i = 0
            or
            child = SynthChild(local) and
            i = 1
          )
          or
          exists(int arity | parent = TMethodCallSynth(ifExpr, 2, _, _, arity) |
            i = 0 and
            child = SynthChild(local)
            or
            child = childRef(call.getArgumentImpl(i - 1))
            or
            child = childRef(call.getBlockImpl()) and i = arity + 1
          )
        )
      )
    )
  }

  private class SafeNavigationCallSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child) {
      safeNavigationCallSynthesis(parent, i, child)
    }

    final override predicate methodCall(string name, boolean setter, int arity) {
      exists(RegularMethodCall call |
        call.isSafeNavigationImpl() and
        name = call.getMethodNameImpl() and
        setter = false and
        arity = call.getNumberOfArgumentsImpl()
      )
      or
      name = "==" and setter = false and arity = 2
    }

    final override predicate localVariable(AstNode n, int i) {
      i = 0 and n = any(RegularMethodCall c | c.isSafeNavigationImpl()).getReceiverImpl()
    }

    override predicate location(AstNode n, Location l) {
      exists(RegularMethodCall call, StmtSequence seq |
        call.isSafeNavigationImpl() and seq = call.getDesugared()
      |
        n = seq.getStmt(0) and
        hasLocation(call.getReceiverImpl(), l)
        or
        n = seq.getStmt(1) and
        l = toGenerated(call).(Ruby::Call).getOperator().getLocation()
        or
        n = seq.getStmt(1).(IfExpr).getCondition().(MethodCall).getArgument(0) and
        hasLocation(call.getReceiverImpl(), l)
        or
        n = seq.getStmt(1).(IfExpr).getThen() and
        hasLocation(call.getReceiverImpl(), l)
        or
        n = seq.getStmt(1).(IfExpr).getElse() and
        hasLocation(call, l)
        or
        n = seq.getStmt(1).(IfExpr).getElse().(MethodCall).getReceiver() and
        hasLocation(call.getReceiverImpl(), l)
      )
    }
  }
}

private module TestPatternDesugar {
  /**
   * ```rb
   * expr in pattern
   * ```
   * desugars to
   *
   * ```rb
   * case expr
   *   in pattern then true
   *   else false
   * end
   * ```
   */
  pragma[nomagic]
  private predicate testPatternSynthesis(AstNode parent, int i, Child child) {
    exists(TestPattern test |
      parent = test and
      i = -1 and
      child = SynthChild(CaseMatchKind())
      or
      exists(TCaseMatchSynth case | case = TCaseMatchSynth(test, -1) |
        parent = case and
        (
          child = childRef(test.getValue()) and i = 0
          or
          child = SynthChild(InClauseKind()) and i = 1
          or
          child = SynthChild(ElseKind()) and i = 2
        )
        or
        parent = TInClauseSynth(case, 1) and
        (
          child = childRef(test.getPattern()) and
          i = 0
          or
          child = SynthChild(BooleanLiteralKind(true)) and i = 1
        )
        or
        parent = TElseSynth(case, 2) and
        child = SynthChild(BooleanLiteralKind(false)) and
        i = 0
      )
    )
  }

  private class TestPatternSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child) {
      testPatternSynthesis(parent, i, child)
    }
  }
}

private module MatchPatternDesugar {
  /**
   * ```rb
   * expr => pattern
   * ```
   * desugars to
   *
   * ```rb
   * case expr
   *   in pattern then nil
   * end
   * ```
   */
  pragma[nomagic]
  private predicate matchPatternSynthesis(AstNode parent, int i, Child child) {
    exists(MatchPattern test |
      parent = test and
      i = -1 and
      child = SynthChild(CaseMatchKind())
      or
      exists(TCaseMatchSynth case | case = TCaseMatchSynth(test, -1) |
        parent = case and
        (
          child = childRef(test.getValue()) and i = 0
          or
          child = SynthChild(InClauseKind()) and i = 1
        )
        or
        parent = TInClauseSynth(case, 1) and
        (
          child = childRef(test.getPattern()) and
          i = 0
          or
          child = SynthChild(NilLiteralKind()) and i = 1
        )
      )
    )
  }

  private class MatchPatternSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child) {
      matchPatternSynthesis(parent, i, child)
    }
  }
}
