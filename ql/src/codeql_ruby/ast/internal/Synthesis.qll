/** Provides predicates for synthesizing AST nodes. */

private import AST
private import TreeSitter
private import codeql_ruby.ast.internal.Call
private import codeql_ruby.ast.internal.Operation
private import codeql_ruby.ast.internal.Parameter
private import codeql_ruby.ast.internal.Variable
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
  ElementReferenceKind() or
  ExponentExprKind() or
  GlobalVariableAccessKind(GlobalVariable v) or
  InstanceVariableAccessKind(InstanceVariable v) or
  IntegerLiteralKind(int i) { i in [0 .. 1000] } or
  LShiftExprKind() or
  LocalVariableAccessRealKind(LocalVariableReal v) or
  LocalVariableAccessSynthKind(TLocalVariableSynth v) or
  LogicalAndExprKind() or
  LogicalOrExprKind() or
  MethodCallKind(string name) {
    exists(Generated::Identifier g | isIdentifierMethodCall(g) and name = g.getValue())
    or
    exists(Generated::Identifier i | isScopeResolutionMethodCall(_, i) and name = i.getValue())
    or
    name = regularMethodCallName(_)
  } or
  ModuloExprKind() or
  MulExprKind() or
  StmtSequenceKind() or
  RShiftExprKind() or
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
   * Holds if `n` should be excluded from `ControlFlowTree` in the CFG construction.
   */
  predicate excludeFromControlFlowTree(AstNode n) { none() }

  final string toString() { none() }
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
  parent = getSynthChild(assignParent, assignIndex) and
  (
    i = 0 and
    child = SynthChild(LocalVariableAccessSynthKind(v))
    or
    i = 1 and
    child = RealChild(value)
  )
}

private SynthKind getCallKind(MethodCall mc) {
  result = MethodCallKind(methodCallName(mc))
  or
  mc instanceof ElementReference and
  result = ElementReferenceKind()
}

private SomeLocation getSomeLocation(AstNode n) {
  result = SomeLocation(toGenerated(n).getLocation())
}

private module ImplicitSelfSynthesis {
  private class IdentifierMethodCallSelfSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child, LocationOption l) {
      child = SynthChild(SelfKind()) and
      parent = TIdentifierMethodCall(_) and
      i = 0 and
      l = NoneLocation()
    }
  }

  private class RegularMethodCallSelfSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child, LocationOption l) {
      child = SynthChild(SelfKind()) and
      i = 0 and
      exists(Generated::AstNode g |
        parent = TRegularMethodCall(g) and
        // If there's no explicit receiver (or scope resolution that acts like a
        // receiver), then the receiver is implicitly `self`.  N.B.  `::Foo()` is
        // not valid Ruby.
        not exists(g.(Generated::Call).getReceiver()) and
        not exists(g.(Generated::Call).getMethod().(Generated::ScopeResolution).getScope())
      ) and
      l = NoneLocation()
    }
  }
}

private module SetterDesugar {
  /**
   * ```rb
   * x.foo = y
   * ```
   *
   * desugars to
   *
   * ```rb
   * x.foo=(y)
   * ```
   */
  private class SetterMethodCallSynthesis extends Synthesis {
    final override predicate child(AstNode parent, int i, Child child, LocationOption l) {
      exists(AssignExpr ae, MethodCall mc | mc = ae.getLeftOperand() |
        parent = ae and
        i = -1 and
        child = SynthChild(getCallKind(mc)) and
        l = getSomeLocation(mc)
        or
        parent = getSynthChild(ae, -1) and
        l = NoneLocation() and
        (
          i = 0 and
          child = RealChild(mc.getReceiver())
          or
          child = RealChild(mc.getArgument(i - 1))
          or
          i = mc.getNumberOfArguments() + 1 and
          child = RealChild(ae.getRightOperand())
          or
          // special "number of arguments argument"; required to avoid non-monotonic recursion
          i = -2 and
          child = SynthChild(IntegerLiteralKind(mc.getNumberOfArguments() + 1)) and
          l = NoneLocation()
        )
      )
    }

    final override predicate excludeFromControlFlowTree(AstNode n) {
      n.(MethodCall) = any(AssignExpr ae).getLeftOperand()
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
      exists(AssignOperation ao, VariableReal v |
        v = ao.getLeftOperand().(VariableAccess).getVariable()
      |
        parent = ao and
        i = -1 and
        child = SynthChild(AssignExprKind()) and
        l = NoneLocation()
        or
        exists(AstNode assign | assign = getSynthChild(ao, -1) |
          parent = assign and
          i = 0 and
          child = RealChild(ao.getLeftOperand()) and
          l = NoneLocation()
          or
          parent = assign and
          i = 1 and
          child = SynthChild(getKind(ao)) and
          l = SomeLocation(getAssignOperationLocation(ao))
          or
          parent = getSynthChild(assign, 1) and
          (
            i = 0 and
            child =
              SynthChild([
                  LocalVariableAccessRealKind(v).(SynthKind), InstanceVariableAccessKind(v),
                  ClassVariableAccessKind(v), GlobalVariableAccessKind(v)
                ]) and
            l = getSomeLocation(ao.getLeftOperand())
            or
            i = 1 and
            child = RealChild(ao.getRightOperand()) and
            l = NoneLocation()
          )
        )
      )
    }
  }

  /** Gets an assignment operation where the LHS is method call `mc`. */
  private AssignOperation assignOperationMethodCall(MethodCall mc) { result.getLeftOperand() = mc }

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
      exists(AssignOperation ao, MethodCall mc | ao = assignOperationMethodCall(mc) |
        parent = ao and
        i = -1 and
        child = SynthChild(StmtSequenceKind()) and
        l = NoneLocation()
        or
        exists(AstNode seq, AstNode receiver |
          seq = getSynthChild(ao, -1) and receiver = mc.getReceiver()
        |
          // `__synth__0 = foo`
          assign(parent, i, child, TLocalVariableSynth(ao, 0), seq, 0, receiver) and
          l = getSomeLocation(receiver)
          or
          // `__synth__1 = bar`
          exists(Expr arg, int j | arg = mc.getArgument(j - 1) |
            assign(parent, i, child, TLocalVariableSynth(ao, j), seq, j, arg) and
            l = getSomeLocation(arg)
          )
          or
          // `__synth__2 = __synth__0.[](__synth__1) + y`
          exists(int opAssignIndex | opAssignIndex = mc.getNumberOfArguments() + 1 |
            parent = seq and
            i = opAssignIndex and
            child = SynthChild(AssignExprKind()) and
            l = SomeLocation(getAssignOperationLocation(ao))
            or
            exists(AstNode assign | assign = getSynthChild(seq, opAssignIndex) |
              parent = assign and
              i = 0 and
              child =
                SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(ao, opAssignIndex))) and
              l = SomeLocation(getAssignOperationLocation(ao))
              or
              parent = assign and
              i = 1 and
              child = SynthChild(getKind(ao)) and
              l = SomeLocation(getAssignOperationLocation(ao))
              or
              // `__synth__0.[](__synth__1) + y`
              exists(AstNode op | op = getSynthChild(assign, 1) |
                parent = op and
                i = 0 and
                child = SynthChild(getCallKind(mc)) and
                l = getSomeLocation(mc)
                or
                parent = getSynthChild(op, 0) and
                child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(ao, i))) and
                (
                  i = 0 and
                  l = getSomeLocation(receiver)
                  or
                  l = getSomeLocation(mc.getArgument(i - 1))
                )
                or
                parent = op and
                i = 1 and
                child = RealChild(ao.getRightOperand()) and
                l = NoneLocation()
              )
            )
            or
            // `__synth__0.[]=(__synth__1, __synth__2);`
            parent = seq and
            i = opAssignIndex + 1 and
            child = SynthChild(getCallKind(mc)) and
            l = getSomeLocation(mc)
            or
            exists(AstNode setter | setter = getSynthChild(seq, opAssignIndex + 1) |
              parent = setter and
              child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(ao, i))) and
              (
                i = 0 and
                l = getSomeLocation(receiver)
                or
                l = getSomeLocation(mc.getArgument(i - 1))
              )
              or
              parent = setter and
              i = opAssignIndex + 1 and
              child =
                SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(ao, opAssignIndex))) and
              l = SomeLocation(getAssignOperationLocation(ao))
              or
              // special "number of arguments argument"; required to avoid non-monotonic recursion
              parent = setter and
              i = -2 and
              child = SynthChild(IntegerLiteralKind(opAssignIndex + 1)) and
              l = NoneLocation()
            )
            or
            parent = seq and
            i = opAssignIndex + 2 and
            child = SynthChild(LocalVariableAccessSynthKind(TLocalVariableSynth(ao, opAssignIndex))) and
            l = SomeLocation(getAssignOperationLocation(ao))
          )
        )
      )
    }

    final override predicate localVariable(AstNode n, int i) {
      exists(MethodCall mc | n = assignOperationMethodCall(mc) |
        i in [0 .. mc.getNumberOfArguments() + 1]
      )
    }

    final override predicate excludeFromControlFlowTree(AstNode n) {
      exists(assignOperationMethodCall(n))
    }
  }
}
