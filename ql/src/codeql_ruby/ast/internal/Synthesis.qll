/** Provides predicates for synthesizing AST nodes. */

private import AST
private import TreeSitter
private import codeql_ruby.ast.internal.Call
private import codeql_ruby.ast.internal.Variable
private import codeql_ruby.ast.internal.Pattern
private import codeql_ruby.AST

/** A synthesized AST node kind. */
newtype SynthKind =
  AddExprKind() or
  AssignExprKind() or
  BitwiseAndExprKind() or
  BitwiseOrExprKind() or
  BitwiseXorExprKind() or
  ClassVariableAccessKind(ClassVariable v) or
  DivExprKind() or
  ExponentExprKind() or
  GlobalVariableAccessKind(GlobalVariable v) or
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
  RangeLiteralKind(boolean inclusive) { inclusive in [false, true] } or
  RShiftExprKind() or
  SplatExprKind() or
  StmtSequenceKind() or
  SelfKind() or
  SubExprKind()

/**
 * An AST child.
 *
 * Either a new synthesized node or a reference to an existing node.
 */
newtype Child =
  SynthChild(SynthKind k) or
  RealChild(AstNode n)

newtype LocationOption =
  NoneLocation() or
  SomeLocation(Location l)

private newtype TSynthesis = MkSynthesis()

/** A class used for synthesizing AST nodes. */
class Synthesis extends TSynthesis {
  /**
   * Holds if a node should be synthesized as the `i`th child of `parent`, or if
   * a non-synthesized node should be the `i`th child of synthesized node `parent`.
   *
   * `i = -1` is used to represent that the synthesized node is a desugared version
   * of its parent.
   *
   * In case a new node is synthesized, it will have the location specified by `l`.
   */
  predicate child(AstNode parent, int i, Child child, LocationOption l) { none() }

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
   * Holds if `n` should be excluded from `ControlFlowTree` in the CFG construction.
   */
  predicate excludeFromControlFlowTree(AstNode n) { none() }

  final string toString() { none() }
}

private class Desugared extends AstNode {
  Desugared() { this = any(AstNode sugar).getDesugared() }

  AstNode getADescendant() { result = this.getAChild*() }
}

/**
 * Gets the desugaring level of `n`. That is, the number of desugaring
 * transformations required before the context in which `n` occurs is
 * fully desugared.
 */
int desugarLevel(AstNode n) { result = count(Desugared desugared | n = desugared.getADescendant()) }

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
    child = RealChild(value)
  )
}

/** Holds if synthesized node `n` should have location `l`. */
predicate synthLocation(AstNode n, Location l) {
  exists(Synthesis s, AstNode parent, int i |
    s.child(parent, i, _, SomeLocation(l)) and
    n = getSynthChild(parent, i)
  )
}

private SomeLocation getSomeLocation(AstNode n) {
  result = SomeLocation(toGenerated(n).getLocation())
  or
  result = SomeLocation(any(Location l | synthLocation(n, l)))
}

private module ImplicitSelfSynthesis {
  pragma[nomagic]
  private predicate identifierMethodCallSelfSynthesis(
    AstNode mc, int i, Child child, LocationOption l
  ) {
    child = SynthChild(SelfKind()) and
    mc = TIdentifierMethodCall(_) and
    i = 0 and
    l = NoneLocation()
  }

  private class IdentifierMethodCallSelfSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child, LocationOption l) {
      identifierMethodCallSelfSynthesis(parent, i, child, l)
    }
  }

  pragma[nomagic]
  private predicate regularMethodCallSelfSynthesis(
    TRegularMethodCall mc, int i, Child child, LocationOption l
  ) {
    exists(Generated::AstNode g |
      mc = TRegularMethodCall(g) and
      // If there's no explicit receiver (or scope resolution that acts like a
      // receiver), then the receiver is implicitly `self`.  N.B.  `::Foo()` is
      // not valid Ruby.
      not exists(g.(Generated::Call).getReceiver()) and
      not exists(g.(Generated::Call).getMethod().(Generated::ScopeResolution).getScope())
    ) and
    child = SynthChild(SelfKind()) and
    i = 0 and
    l = NoneLocation()
  }

  private class RegularMethodCallSelfSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child, LocationOption l) {
      regularMethodCallSelfSynthesis(parent, i, child, l)
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
    MethodCallKind getCallKind(boolean setter, int arity) {
      result = MethodCallKind(mc.getMethodName(), setter, arity)
    }

    pragma[nomagic]
    Expr getReceiver() { result = mc.getReceiver() }

    pragma[nomagic]
    Expr getArgument(int i) { result = mc.getArgument(i) }

    pragma[nomagic]
    int getNumberOfArguments() { result = mc.getNumberOfArguments() }

    pragma[nomagic]
    LocationOption getMethodCallLocation() { result = getSomeLocation(mc) }
  }

  pragma[nomagic]
  private predicate setterMethodCallSynthesis(AstNode parent, int i, Child child, LocationOption l) {
    exists(SetterAssignExpr sae |
      parent = sae and
      i = -1 and
      child = SynthChild(StmtSequenceKind()) and
      l = NoneLocation()
      or
      exists(AstNode seq | seq = TStmtSequenceSynth(sae, -1) |
        parent = seq and
        i = 0 and
        child = SynthChild(sae.getCallKind(true, sae.getNumberOfArguments() + 1)) and
        l = sae.getMethodCallLocation()
        or
        exists(AstNode call | call = TMethodCallSynth(seq, 0, _, _, _) |
          parent = call and
          i = 0 and
          child = RealChild(sae.getReceiver()) and
          l = NoneLocation()
          or
          parent = call and
          child = RealChild(sae.getArgument(i - 1)) and
          l = NoneLocation()
          or
          l = sae.getMethodCallLocation() and
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
              child = RealChild(sae.getRightOperand())
            )
          )
        )
        or
        parent = seq and
        i = 1 and
        child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(sae, 0))) and
        l = sae.getMethodCallLocation()
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
    final override predicate child(AstNode parent, int i, Child child, LocationOption l) {
      setterMethodCallSynthesis(parent, i, child, l)
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
    exists(Generated::OperatorAssignment g, Generated::Token op |
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
  private predicate variableAssignOperationSynthesis(
    AstNode parent, int i, Child child, LocationOption l
  ) {
    exists(VariableAssignOperation vao |
      parent = vao and
      i = -1 and
      child = SynthChild(AssignExprKind()) and
      l = NoneLocation()
      or
      exists(AstNode assign | assign = TAssignExprSynth(vao, -1) |
        parent = assign and
        i = 0 and
        child = RealChild(vao.getLeftOperand()) and
        l = NoneLocation()
        or
        parent = assign and
        i = 1 and
        child = SynthChild(getKind(vao)) and
        l = SomeLocation(getAssignOperationLocation(vao))
        or
        parent = getSynthChild(assign, 1) and
        (
          i = 0 and
          child = SynthChild(vao.getVariableAccessKind()) and
          l = getSomeLocation(vao.getLeftOperand())
          or
          i = 1 and
          child = RealChild(vao.getRightOperand()) and
          l = NoneLocation()
        )
      )
    )
  }

  /**
   * ```rb
   * x += y
   * ```
   *
   * desguars to
   *
   * ```rb
   * x = x + y
   * ```
   *
   * when `x` is a variable.
   */
  private class VariableAssignOperationSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child, LocationOption l) {
      variableAssignOperationSynthesis(parent, i, child, l)
    }
  }

  /** An assignment operation where the left-hand side is a method call. */
  private class SetterAssignOperation extends AssignOperation {
    private MethodCall mc;

    pragma[nomagic]
    SetterAssignOperation() { mc = this.getLeftOperand() }

    MethodCall getMethodCall() { result = mc }

    pragma[nomagic]
    MethodCallKind getCallKind(boolean setter, int arity) {
      result = MethodCallKind(mc.getMethodName(), setter, arity)
    }

    pragma[nomagic]
    Expr getReceiver() { result = mc.getReceiver() }

    pragma[nomagic]
    Expr getArgument(int i) { result = mc.getArgument(i) }

    pragma[nomagic]
    int getNumberOfArguments() { result = mc.getNumberOfArguments() }

    pragma[nomagic]
    LocationOption getMethodCallLocation() { result = getSomeLocation(mc) }
  }

  pragma[nomagic]
  private predicate methodCallAssignOperationSynthesis(
    AstNode parent, int i, Child child, LocationOption l
  ) {
    exists(SetterAssignOperation sao |
      parent = sao and
      i = -1 and
      child = SynthChild(StmtSequenceKind()) and
      l = NoneLocation()
      or
      exists(AstNode seq, AstNode receiver |
        seq = TStmtSequenceSynth(sao, -1) and receiver = sao.getReceiver()
      |
        // `__synth__0 = foo`
        assign(parent, i, child, TLocalVariableSynth(sao, 0), seq, 0, receiver) and
        l = getSomeLocation(receiver)
        or
        // `__synth__1 = bar`
        exists(Expr arg, int j | arg = sao.getArgument(j - 1) |
          assign(parent, i, child, TLocalVariableSynth(sao, j), seq, j, arg) and
          l = getSomeLocation(arg)
        )
        or
        // `__synth__2 = __synth__0.[](__synth__1) + y`
        exists(int opAssignIndex | opAssignIndex = sao.getNumberOfArguments() + 1 |
          parent = seq and
          i = opAssignIndex and
          child = SynthChild(AssignExprKind()) and
          l = SomeLocation(getAssignOperationLocation(sao))
          or
          exists(AstNode assign | assign = TAssignExprSynth(seq, opAssignIndex) |
            parent = assign and
            i = 0 and
            child =
              SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(sao, opAssignIndex))) and
            l = SomeLocation(getAssignOperationLocation(sao))
            or
            parent = assign and
            i = 1 and
            child = SynthChild(getKind(sao)) and
            l = SomeLocation(getAssignOperationLocation(sao))
            or
            // `__synth__0.[](__synth__1) + y`
            exists(AstNode op | op = getSynthChild(assign, 1) |
              parent = op and
              i = 0 and
              child = SynthChild(sao.getCallKind(false, sao.getNumberOfArguments())) and
              l = sao.getMethodCallLocation()
              or
              parent = TMethodCallSynth(op, 0, _, _, _) and
              child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(sao, i))) and
              (
                i = 0 and
                l = getSomeLocation(receiver)
                or
                l = getSomeLocation(sao.getArgument(i - 1))
              )
              or
              parent = op and
              i = 1 and
              child = RealChild(sao.getRightOperand()) and
              l = NoneLocation()
            )
          )
          or
          // `__synth__0.[]=(__synth__1, __synth__2);`
          parent = seq and
          i = opAssignIndex + 1 and
          child = SynthChild(sao.getCallKind(true, opAssignIndex)) and
          l = sao.getMethodCallLocation()
          or
          exists(AstNode setter | setter = TMethodCallSynth(seq, opAssignIndex + 1, _, _, _) |
            parent = setter and
            child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(sao, i))) and
            (
              i = 0 and
              l = getSomeLocation(receiver)
              or
              l = getSomeLocation(sao.getArgument(i - 1))
            )
            or
            parent = setter and
            i = opAssignIndex + 1 and
            child =
              SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(sao, opAssignIndex))) and
            l = SomeLocation(getAssignOperationLocation(sao))
          )
          or
          parent = seq and
          i = opAssignIndex + 2 and
          child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(sao, opAssignIndex))) and
          l = SomeLocation(getAssignOperationLocation(sao))
        )
      )
    )
  }

  /**
   * ```rb
   * foo[bar] += y
   * ```
   *
   * desguars to
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
    final override predicate child(AstNode parent, int i, Child child, LocationOption l) {
      methodCallAssignOperationSynthesis(parent, i, child, l)
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

private module CompoundAssignDesugar {
  /** An assignment where the left-hand side is a tuple pattern. */
  private class TupleAssignExpr extends AssignExpr {
    private TuplePattern tp;

    pragma[nomagic]
    TupleAssignExpr() { tp = this.getLeftOperand() }

    TuplePattern getTuplePattern() { result = tp }

    pragma[nomagic]
    Pattern getElement(int i) { result = tp.getElement(i) }

    pragma[nomagic]
    int getNumberOfElements() {
      toGenerated(tp) = any(TuplePatternImpl impl | result = count(impl.getChildNode(_)))
    }

    pragma[nomagic]
    int getRestIndexOrNumberOfElements() {
      result = tp.getRestIndex()
      or
      toGenerated(tp) = any(TuplePatternImpl impl | not exists(impl.getRestIndex())) and
      result = this.getNumberOfElements()
    }

    pragma[nomagic]
    SomeLocation getRightOperandLocation() { result = getSomeLocation(this.getRightOperand()) }
  }

  pragma[nomagic]
  private predicate compoundAssignSynthesis(AstNode parent, int i, Child child, LocationOption l) {
    exists(TupleAssignExpr tae |
      parent = tae and
      i = -1 and
      child = SynthChild(StmtSequenceKind()) and
      l = NoneLocation()
      or
      exists(AstNode seq | seq = TStmtSequenceSynth(tae, -1) |
        parent = seq and
        i = 0 and
        child = SynthChild(AssignExprKind()) and
        l = tae.getRightOperandLocation()
        or
        exists(AstNode assign | assign = TAssignExprSynth(seq, 0) |
          parent = assign and
          i = 0 and
          child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(tae, 0))) and
          l = tae.getRightOperandLocation()
          or
          parent = assign and
          i = 1 and
          child = SynthChild(SplatExprKind()) and
          l = tae.getRightOperandLocation()
          or
          parent = TSplatExprSynth(assign, 1) and
          i = 0 and
          child = RealChild(tae.getRightOperand()) and
          l = NoneLocation()
        )
        or
        exists(Pattern p, int j, int restIndex |
          p = tae.getElement(j) and
          restIndex = tae.getRestIndexOrNumberOfElements()
        |
          parent = seq and
          i = j + 1 and
          child = SynthChild(AssignExprKind()) and
          l = getSomeLocation(p)
          or
          exists(AstNode assign | assign = TAssignExprSynth(seq, j + 1) |
            parent = assign and
            i = 0 and
            child = RealChild(p) and
            l = NoneLocation()
            or
            parent = assign and
            i = 1 and
            child = SynthChild(MethodCallKind("[]", false, 1)) and
            l = getSomeLocation(p)
            or
            l = getSomeLocation(p) and
            (
              parent = TMethodCallSynth(assign, 1, _, _, _) and
              i = 0 and
              child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(tae, 0)))
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
                  child = SynthChild(IntegerLiteralKind(restIndex - tae.getNumberOfElements()))
                )
              )
              or
              j > restIndex and
              parent = TMethodCallSynth(assign, 1, _, _, _) and
              i = 1 and
              child = SynthChild(IntegerLiteralKind(j - tae.getNumberOfElements()))
            )
          )
        )
      )
    )
  }

  /**
   * ```rb
   * x, *y, z = w
   * ```
   * desguars to
   *
   * ```rb
   * __synth__0 = *w;
   * x = __synth__0[0];
   * y = __synth__0[1..-2];
   * z = __synth__0[-1];
   * ```
   */
  private class CompoundAssignSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child, LocationOption l) {
      compoundAssignSynthesis(parent, i, child, l)
    }

    final override predicate localVariable(AstNode n, int i) {
      n instanceof TupleAssignExpr and
      i = 0
    }

    final override predicate methodCall(string name, boolean setter, int arity) {
      name = "[]" and
      setter = false and
      arity = 1
    }

    final override predicate excludeFromControlFlowTree(AstNode n) {
      n = any(TupleAssignExpr tae).getTuplePattern()
    }
  }
}
