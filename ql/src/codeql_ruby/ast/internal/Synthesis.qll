/** Provides predicates for synthesizing AST nodes. */

private import AST
private import TreeSitter
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
  ExponentExprKind() or
  GlobalVariableAccessKind(GlobalVariable v) or
  InstanceVariableAccessKind(InstanceVariable v) or
  LShiftExprKind() or
  LocalVariableAccessRealKind(LocalVariableReal v) or
  LocalVariableAccessSynthKind(TLocalVariableSynth v) or
  LogicalAndExprKind() or
  LogicalOrExprKind() or
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
        v = ao.getLeftOperand().(VariableAccessReal).getVariableReal()
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
}
