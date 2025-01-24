/**
 * Provides an implementation for constructing control-flow graphs (CFGs) from
 * abstract syntax trees (ASTs), using the shared library from `codeql.controlflow.Cfg`.
 */

import csharp
private import codeql.controlflow.Cfg as CfgShared
private import Completion
private import Splitting
private import semmle.code.csharp.ExprOrStmtParent
private import semmle.code.csharp.commons.Compilation

/** An element that defines a new CFG scope. */
class CfgScope extends Element, @top_level_exprorstmt_parent {
  CfgScope() {
    this.getFile().fromSource() and
    (
      this =
        any(Callable c |
          c.(Constructor).hasInitializer()
          or
          InitializerSplitting::constructorInitializes(c, _)
          or
          c.hasBody()
        )
      or
      // For now, static initializer values have their own scope. Eventually, they
      // should be treated like instance initializers.
      this.(Assignable).(Modifiable).isStatic() and
      expr_parent_top_level_adjusted2(_, _, this)
    )
  }
}

private class TAstNode = @callable or @control_flow_element;

private Element getAChild(Element p) {
  result = p.getAChild() or
  result = p.(AssignOperation).getExpandedAssignment()
}

/** An AST node. */
class AstNode extends Element, TAstNode {
  AstNode() { this = getAChild*(any(@top_level_exprorstmt_parent p | not p instanceof Attribute)) }

  int getId() { idOf(this, result) }
}

private predicate id(AstNode x, AstNode y) { x = y }

private predicate idOf(AstNode x, int y) = equivalenceRelation(id/2)(x, y)

private module CfgInput implements CfgShared::InputSig<Location> {
  private import ControlFlowGraphImpl as Impl
  private import Completion as Comp
  private import SuccessorType as ST
  private import semmle.code.csharp.Caching

  class AstNode = Impl::AstNode;

  class Completion = Comp::Completion;

  predicate completionIsNormal(Completion c) { c instanceof Comp::NormalCompletion }

  predicate completionIsSimple(Completion c) { c instanceof Comp::SimpleCompletion }

  predicate completionIsValidFor(Completion c, AstNode e) { c.isValidFor(e) }

  class CfgScope = Impl::CfgScope;

  CfgScope getCfgScope(AstNode n) {
    Stages::ControlFlowStage::forceCachingInSameStage() and
    result = n.(ControlFlowElement).getEnclosingCallable()
  }

  predicate scopeFirst(CfgScope scope, AstNode first) { Impl::scopeFirst(scope, first) }

  predicate scopeLast(CfgScope scope, AstNode last, Completion c) {
    Impl::scopeLast(scope, last, c)
  }

  class SuccessorType = ST::SuccessorType;

  SuccessorType getAMatchingSuccessorType(Completion c) { result = c.getAMatchingSuccessorType() }

  predicate successorTypeIsSimple(SuccessorType t) {
    t instanceof ST::SuccessorTypes::NormalSuccessor
  }

  predicate successorTypeIsCondition(SuccessorType t) {
    t instanceof ST::SuccessorTypes::ConditionalSuccessor
  }

  predicate isAbnormalExitType(SuccessorType t) {
    t instanceof ST::SuccessorTypes::ExceptionSuccessor or
    t instanceof ST::SuccessorTypes::ExitSuccessor
  }

  int idOfAstNode(AstNode node) { result = node.getId() }

  int idOfCfgScope(CfgScope node) { result = idOfAstNode(node) }
}

private module CfgSplittingInput implements CfgShared::SplittingInputSig<Location, CfgInput> {
  private import Splitting as S

  class SplitKindBase = S::TSplitKind;

  class Split = S::Split;
}

private module ConditionalCompletionSplittingInput implements
  CfgShared::ConditionalCompletionSplittingInputSig<Location, CfgInput, CfgSplittingInput>
{
  import Splitting::ConditionalCompletionSplitting::ConditionalCompletionSplittingInput
}

import CfgShared::MakeWithSplitting<Location, CfgInput, CfgSplittingInput, ConditionalCompletionSplittingInput>

/**
 * A compilation.
 *
 * Unlike the standard `Compilation` class, this class also supports buildless
 * extraction.
 */
newtype CompilationExt =
  TCompilation(Compilation c) { not extractionIsStandalone() } or
  TBuildless() { extractionIsStandalone() }

/** Gets the compilation that source file `f` belongs to. */
CompilationExt getCompilation(File f) {
  exists(Compilation c |
    f = c.getAFileCompiled() and
    result = TCompilation(c)
  )
  or
  result = TBuildless()
}

/**
 * The `expr_parent_top_level_adjusted()` relation restricted to exclude relations
 * between properties and their getters' expression bodies in properties such as
 * `int P => 0`.
 *
 * This is in order to only associate the expression body with one CFG scope, namely
 * the getter (and not the declaration itself).
 */
private predicate expr_parent_top_level_adjusted2(
  Expr child, int i, @top_level_exprorstmt_parent parent
) {
  expr_parent_top_level_adjusted(child, i, parent) and
  not exists(Getter g |
    g.getDeclaration() = parent and
    i = 0
  )
}

/** Holds if `first` is first executed when entering `scope`. */
predicate scopeFirst(CfgScope scope, AstNode first) {
  scope =
    any(Callable c |
      if exists(c.(Constructor).getInitializer())
      then first(c.(Constructor).getInitializer(), first)
      else
        if InitializerSplitting::constructorInitializes(c, _)
        then first(InitializerSplitting::constructorInitializeOrder(c, _, 0), first)
        else first(c.getBody(), first)
    )
  or
  expr_parent_top_level_adjusted2(any(Expr e | first(e, first)), _, scope) and
  not scope instanceof Callable
}

/** Holds if `scope` is exited when `last` finishes with completion `c`. */
predicate scopeLast(CfgScope scope, AstNode last, Completion c) {
  scope =
    any(Callable callable |
      last(callable.getBody(), last, c) and
      not c instanceof GotoCompletion
      or
      last(InitializerSplitting::lastConstructorInitializer(scope, _), last, c) and
      not callable.hasBody()
    )
  or
  expr_parent_top_level_adjusted2(any(Expr e | last(e, last, c)), _, scope) and
  not scope instanceof Callable
}

private class ConstructorTree extends ControlFlowTree instanceof Constructor {
  final override predicate propagatesAbnormal(AstNode child) { none() }

  final override predicate first(AstNode first) { none() }

  final override predicate last(AstNode last, Completion c) { none() }

  /** Gets the body of this constructor belonging to compilation `comp`. */
  pragma[noinline]
  AstNode getBody(CompilationExt comp) {
    result = super.getBody() and
    comp = getCompilation(result.getFile())
  }

  final override predicate succ(AstNode pred, AstNode succ, Completion c) {
    exists(CompilationExt comp, int i, AssignExpr ae |
      ae = InitializerSplitting::constructorInitializeOrder(this, comp, i) and
      last(ae, pred, c) and
      c instanceof NormalCompletion
    |
      // Flow from one member initializer to the next
      first(InitializerSplitting::constructorInitializeOrder(this, comp, i + 1), succ)
      or
      // Flow from last member initializer to constructor body
      ae = InitializerSplitting::lastConstructorInitializer(this, comp) and
      first(this.getBody(comp), succ)
    )
  }
}

abstract private class SwitchTree extends ControlFlowTree instanceof Switch {
  override predicate propagatesAbnormal(AstNode child) { child = super.getExpr() }

  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    // Flow from last element of switch expression to first element of first case
    last(super.getExpr(), pred, c) and
    c instanceof NormalCompletion and
    first(super.getCase(0), succ)
    or
    // Flow from last element of case pattern to next case
    exists(Case case, int i | case = super.getCase(i) |
      last(case.getPattern(), pred, c) and
      c.(MatchingCompletion).isNonMatch() and
      first(super.getCase(i + 1), succ)
    )
    or
    // Flow from last element of condition to next case
    exists(Case case, int i | case = super.getCase(i) |
      last(case.getCondition(), pred, c) and
      c instanceof FalseCompletion and
      first(super.getCase(i + 1), succ)
    )
  }
}

abstract private class CaseTree extends ControlFlowTree instanceof Case {
  final override predicate propagatesAbnormal(AstNode child) {
    child in [super.getPattern().(ControlFlowElement), super.getCondition(), super.getBody()]
  }

  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    last(super.getPattern(), pred, c) and
    c.(MatchingCompletion).isMatch() and
    (
      if exists(super.getCondition())
      then
        // Flow from the last element of pattern to the condition
        first(super.getCondition(), succ)
      else
        // Flow from last element of pattern to first element of body
        first(super.getBody(), succ)
    )
    or
    // Flow from last element of condition to first element of body
    last(super.getCondition(), pred, c) and
    c instanceof TrueCompletion and
    first(super.getBody(), succ)
  }
}

module Expressions {
  /** An expression that should not be included in the control flow graph. */
  abstract private class NoNodeExpr extends Expr { }

  private class SimpleNoNodeExpr extends NoNodeExpr {
    SimpleNoNodeExpr() {
      this instanceof TypeAccess and
      not this instanceof TypeAccessPatternExpr
    }
  }

  /** A write access that is not also a read access. */
  private class WriteAccess extends AssignableWrite {
    WriteAccess() {
      // `x++` is both a read and write access
      not this instanceof AssignableRead
    }
  }

  private class WriteAccessNoNodeExpr extends WriteAccess, NoNodeExpr {
    WriteAccessNoNodeExpr() {
      // For example a write to a static field, `Foo.Bar = 0`.
      forall(Expr e | e = this.getAChildExpr() | e instanceof NoNodeExpr)
    }
  }

  private AstNode getExprChild0(Expr e, int i) {
    not e instanceof NameOfExpr and
    not e instanceof QualifiableExpr and
    not e instanceof Assignment and
    not e instanceof AnonymousFunctionExpr and
    result = e.getChild(i)
    or
    e = any(ExtensionMethodCall emc | result = emc.getArgument(i))
    or
    e =
      any(QualifiableExpr qe |
        not qe instanceof ExtensionMethodCall and
        result = qe.getChild(i)
      )
    or
    e =
      any(Assignment a |
        // The left-hand side of an assignment is evaluated before the right-hand side
        i = 0 and result = a.getLValue()
        or
        i = 1 and result = a.getRValue()
      )
  }

  private AstNode getExprChild(Expr e, int i) {
    result =
      rank[i + 1](AstNode cfe, int j |
        cfe = getExprChild0(e, j) and
        not cfe instanceof NoNodeExpr
      |
        cfe order by j
      )
  }

  private AstNode getLastExprChild(Expr e) {
    exists(int last |
      result = getExprChild(e, last) and
      not exists(getExprChild(e, last + 1))
    )
  }

  private class StandardExpr extends StandardPostOrderTree instanceof Expr {
    StandardExpr() {
      // The following expressions need special treatment
      not this instanceof LogicalNotExpr and
      not this instanceof LogicalAndExpr and
      not this instanceof LogicalOrExpr and
      not this instanceof NullCoalescingExpr and
      not this instanceof ConditionalExpr and
      not this instanceof AssignOperationWithExpandedAssignment and
      not this instanceof ConditionallyQualifiedExpr and
      not this instanceof ThrowExpr and
      not this instanceof ObjectCreation and
      not this instanceof ArrayCreation and
      not this instanceof QualifiedWriteAccess and
      not this instanceof AccessorWrite and
      not this instanceof NoNodeExpr and
      not this instanceof SwitchExpr and
      not this instanceof SwitchCaseExpr and
      not this instanceof ConstructorInitializer and
      not this instanceof NotPatternExpr and
      not this instanceof OrPatternExpr and
      not this instanceof AndPatternExpr and
      not this instanceof RecursivePatternExpr and
      not this instanceof PositionalPatternExpr and
      not this instanceof PropertyPatternExpr
    }

    final override AstNode getChildNode(int i) { result = getExprChild(this, i) }
  }

  /**
   * A qualified write access. In a qualified write access, the access itself is
   * not evaluated, only the qualifier and the indexer arguments (if any).
   */
  private class QualifiedWriteAccess extends ControlFlowTree instanceof WriteAccess, QualifiableExpr
  {
    QualifiedWriteAccess() {
      this.hasQualifier()
      or
      // Member initializers like
      // ```csharp
      // new Dictionary<int, string>() { [0] = "Zero", [1] = "One", [2] = "Two" }
      // ```
      // need special treatment, because the accesses `[0]`, `[1]`, and `[2]`
      // have no qualifier.
      this = any(MemberInitializer mi).getLValue()
    }

    final override predicate propagatesAbnormal(AstNode child) { child = getExprChild(this, _) }

    final override predicate first(AstNode first) { first(getExprChild(this, 0), first) }

    final override predicate last(AstNode last, Completion c) {
      // Skip the access in a qualified write access
      last(getLastExprChild(this), last, c)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      exists(int i |
        last(getExprChild(this, i), pred, c) and
        c instanceof NormalCompletion and
        first(getExprChild(this, i + 1), succ)
      )
    }
  }

  private class StatOrDynAccessorCall_ =
    @dynamic_member_access_expr or @dynamic_element_access_expr or @call_access_expr;

  /** A normal or a (potential) dynamic call to an accessor. */
  private class StatOrDynAccessorCall extends Expr, StatOrDynAccessorCall_ { }

  /**
   * An expression that writes via an accessor call, for example `x.Prop = 0`,
   * where `Prop` is a property.
   *
   * Accessor writes need special attention, because we need to model the fact
   * that the accessor is called *after* the assigned value has been evaluated.
   * In the example above, this means we want a CFG that looks like
   *
   * ```csharp
   * x -> 0 -> set_Prop -> x.Prop = 0
   * ```
   */
  class AccessorWrite extends PostOrderTree instanceof Expr {
    AssignableDefinition def;

    AccessorWrite() {
      def.getExpr() = this and
      def.getTargetAccess().(WriteAccess) instanceof StatOrDynAccessorCall and
      not this instanceof AssignOperationWithExpandedAssignment
    }

    /**
     * Gets the `i`th accessor being called in this write. More than one call
     * can happen in tuple assignments.
     */
    StatOrDynAccessorCall getCall(int i) {
      result =
        rank[i + 1](AssignableDefinitions::TupleAssignmentDefinition tdef |
          tdef.getExpr() = this and tdef.getTargetAccess() instanceof StatOrDynAccessorCall
        |
          tdef order by tdef.getEvaluationOrder()
        ).getTargetAccess()
      or
      i = 0 and
      result = def.getTargetAccess() and
      not def instanceof AssignableDefinitions::TupleAssignmentDefinition
    }

    final override predicate propagatesAbnormal(AstNode child) {
      child = getExprChild(this, _)
      or
      child = this.getCall(_)
    }

    final override predicate first(AstNode first) { first(getExprChild(this, 0), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Standard left-to-right evaluation
      exists(int i |
        last(getExprChild(this, i), pred, c) and
        c instanceof NormalCompletion and
        first(getExprChild(this, i + 1), succ)
      )
      or
      // Flow from last element of last child to first accessor call
      last(getLastExprChild(this), pred, c) and
      succ = this.getCall(0) and
      c instanceof NormalCompletion
      or
      // Flow from one call to the next
      exists(int i | pred = this.getCall(i) |
        succ = this.getCall(i + 1) and
        c.isValidFor(pred) and
        c instanceof NormalCompletion
      )
      or
      // Post-order: flow from last call to element itself
      exists(int last | last = max(int i | exists(this.getCall(i))) |
        pred = this.getCall(last) and
        succ = this and
        c.isValidFor(pred) and
        c instanceof NormalCompletion
      )
    }
  }

  private class LogicalNotExprTree extends PostOrderTree instanceof LogicalNotExpr {
    private Expr operand;

    LogicalNotExprTree() { operand = this.getOperand() }

    final override predicate propagatesAbnormal(AstNode child) { child = operand }

    final override predicate first(AstNode first) { first(operand, first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      succ = this and
      last(operand, pred, c) and
      c instanceof NormalCompletion
    }
  }

  private class LogicalAndExprTree extends PostOrderTree instanceof LogicalAndExpr {
    final override predicate propagatesAbnormal(AstNode child) {
      child in [super.getLeftOperand(), super.getRightOperand()]
    }

    final override predicate first(AstNode first) { first(super.getLeftOperand(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Flow from last element of left operand to first element of right operand
      last(super.getLeftOperand(), pred, c) and
      c instanceof TrueCompletion and
      first(super.getRightOperand(), succ)
      or
      // Post-order: flow from last element of left operand to element itself
      last(super.getLeftOperand(), pred, c) and
      c instanceof FalseCompletion and
      succ = this
      or
      // Post-order: flow from last element of right operand to element itself
      last(super.getRightOperand(), pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  private class LogicalOrExprTree extends PostOrderTree instanceof LogicalOrExpr {
    final override predicate propagatesAbnormal(AstNode child) {
      child in [super.getLeftOperand(), super.getRightOperand()]
    }

    final override predicate first(AstNode first) { first(super.getLeftOperand(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Flow from last element of left operand to first element of right operand
      last(super.getLeftOperand(), pred, c) and
      c instanceof FalseCompletion and
      first(super.getRightOperand(), succ)
      or
      // Post-order: flow from last element of left operand to element itself
      last(super.getLeftOperand(), pred, c) and
      c instanceof TrueCompletion and
      succ = this
      or
      // Post-order: flow from last element of right operand to element itself
      last(super.getRightOperand(), pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  private class NullCoalescingExprTree extends PostOrderTree instanceof NullCoalescingExpr {
    final override predicate propagatesAbnormal(AstNode child) {
      child in [super.getLeftOperand(), super.getRightOperand()]
    }

    final override predicate first(AstNode first) { first(super.getLeftOperand(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Flow from last element of left operand to first element of right operand
      last(super.getLeftOperand(), pred, c) and
      c.(NullnessCompletion).isNull() and
      first(super.getRightOperand(), succ)
      or
      // Post-order: flow from last element of left operand to element itself
      last(super.getLeftOperand(), pred, c) and
      succ = this and
      c instanceof NormalCompletion and
      not c.(NullnessCompletion).isNull()
      or
      // Post-order: flow from last element of right operand to element itself
      last(super.getRightOperand(), pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  private class ConditionalExprTree extends PostOrderTree instanceof ConditionalExpr {
    final override predicate propagatesAbnormal(AstNode child) {
      child in [super.getCondition(), super.getThen(), super.getElse()]
    }

    final override predicate first(AstNode first) { first(super.getCondition(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Flow from last element of condition to first element of then branch
      last(super.getCondition(), pred, c) and
      c instanceof TrueCompletion and
      first(super.getThen(), succ)
      or
      // Flow from last element of condition to first element of else branch
      last(super.getCondition(), pred, c) and
      c instanceof FalseCompletion and
      first(super.getElse(), succ)
      or
      // Post-order: flow from last element of a branch to element itself
      last([super.getThen(), super.getElse()], pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  /**
   * An assignment operation that has an expanded version. We use the expanded
   * version in the control flow graph in order to get better data flow / taint
   * tracking.
   */
  private class AssignOperationWithExpandedAssignment extends ControlFlowTree instanceof AssignOperation
  {
    private Expr expanded;

    AssignOperationWithExpandedAssignment() { expanded = this.getExpandedAssignment() }

    final override predicate first(AstNode first) { first(expanded, first) }

    final override predicate last(AstNode last, Completion c) { last(expanded, last, c) }

    final override predicate propagatesAbnormal(AstNode child) { none() }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) { none() }
  }

  /** A conditionally qualified expression. */
  private class ConditionallyQualifiedExpr extends PostOrderTree instanceof QualifiableExpr {
    private Expr qualifier;

    ConditionallyQualifiedExpr() { this.isConditional() and qualifier = getExprChild(this, 0) }

    final override predicate propagatesAbnormal(AstNode child) { child = qualifier }

    final override predicate first(AstNode first) { first(qualifier, first) }

    pragma[nomagic]
    private predicate lastQualifier(AstNode last, Completion c) { last(qualifier, last, c) }

    final override predicate last(AstNode last, Completion c) {
      PostOrderTree.super.last(last, c)
      or
      // Qualifier exits with a `null` completion
      this.lastQualifier(last, c) and
      c.(NullnessCompletion).isNull()
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      exists(int i |
        last(getExprChild(this, i), pred, c) and
        c instanceof NormalCompletion and
        if i = 0 then c.(NullnessCompletion).isNonNull() else any()
      |
        // Post-order: flow from last element of last child to element itself
        i = max(int j | exists(getExprChild(this, j))) and
        succ = this
        or
        // Standard left-to-right evaluation
        first(getExprChild(this, i + 1), succ)
      )
    }
  }

  private class ThrowExprTree extends PostOrderTree instanceof ThrowExpr {
    final override predicate propagatesAbnormal(AstNode child) { child = super.getExpr() }

    final override predicate first(AstNode first) { first(super.getExpr(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(super.getExpr(), pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  private class ObjectCreationTree extends ControlFlowTree instanceof ObjectCreation {
    private Expr getObjectCreationArgument(int i) {
      i >= 0 and
      if super.hasInitializer()
      then result = getExprChild(this, i + 1)
      else result = getExprChild(this, i)
    }

    final override predicate propagatesAbnormal(AstNode child) {
      child = this.getObjectCreationArgument(_)
    }

    final override predicate first(AstNode first) {
      first(this.getObjectCreationArgument(0), first)
      or
      not exists(this.getObjectCreationArgument(0)) and
      first = this
    }

    final override predicate last(AstNode last, Completion c) {
      // Post-order: element itself (when no initializer)
      last = this and
      not super.hasInitializer() and
      c.isValidFor(this)
      or
      // Last element of initializer
      last(super.getInitializer(), last, c)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Flow from last element of argument `i` to first element of argument `i+1`
      exists(int i | last(this.getObjectCreationArgument(i), pred, c) |
        first(this.getObjectCreationArgument(i + 1), succ) and
        c instanceof NormalCompletion
      )
      or
      // Flow from last element of last argument to self
      exists(int last | last = max(int i | exists(this.getObjectCreationArgument(i))) |
        last(this.getObjectCreationArgument(last), pred, c) and
        succ = this and
        c instanceof NormalCompletion
      )
      or
      // Flow from self to first element of initializer
      pred = this and
      first(super.getInitializer(), succ) and
      c instanceof SimpleCompletion
    }
  }

  private class ArrayCreationTree extends ControlFlowTree instanceof ArrayCreation {
    final override predicate propagatesAbnormal(AstNode child) {
      child = super.getALengthArgument()
    }

    final override predicate first(AstNode first) {
      // First element of first length argument
      first(super.getLengthArgument(0), first)
      or
      // No length argument: element itself
      not exists(super.getLengthArgument(0)) and
      first = this
    }

    final override predicate last(AstNode last, Completion c) {
      // Post-order: element itself (when no initializer)
      last = this and
      not super.hasInitializer() and
      c.isValidFor(this)
      or
      // Last element of initializer
      last(super.getInitializer(), last, c)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Flow from self to first element of initializer
      pred = this and
      first(super.getInitializer(), succ) and
      c instanceof SimpleCompletion
      or
      exists(int i |
        last(super.getLengthArgument(i), pred, c) and
        c instanceof SimpleCompletion
      |
        // Flow from last length argument to self
        i = max(int j | exists(super.getLengthArgument(j))) and
        succ = this
        or
        // Flow from one length argument to the next
        first(super.getLengthArgument(i + 1), succ)
      )
    }
  }

  private class SwitchExprTree extends PostOrderTree, SwitchTree instanceof SwitchExpr {
    final override predicate propagatesAbnormal(AstNode child) {
      SwitchTree.super.propagatesAbnormal(child)
      or
      child = super.getACase()
    }

    final override predicate first(AstNode first) { first(super.getExpr(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      SwitchTree.super.succ(pred, succ, c)
      or
      last(super.getACase(), pred, c) and
      succ = this and
      c instanceof NormalCompletion
    }
  }

  private class SwitchCaseExprTree extends PostOrderTree, CaseTree instanceof SwitchCaseExpr {
    final override predicate first(AstNode first) { first(super.getPattern(), first) }

    pragma[noinline]
    private predicate lastNoMatch(AstNode last, ConditionalCompletion cc) {
      last([super.getPattern(), super.getCondition()], last, cc) and
      (cc.(MatchingCompletion).isNonMatch() or cc instanceof FalseCompletion)
    }

    final override predicate last(AstNode last, Completion c) {
      PostOrderTree.super.last(last, c)
      or
      // Last case exists with a non-match
      exists(SwitchExpr se, int i, ConditionalCompletion cc |
        this = se.getCase(i) and
        not super.matchesAll() and
        not exists(se.getCase(i + 1)) and
        this.lastNoMatch(last, cc) and
        c =
          any(NestedCompletion nc |
            nc.getNestLevel() = 0 and
            nc.getInnerCompletion() = cc and
            nc.getOuterCompletion()
                .(ThrowCompletion)
                .getExceptionClass()
                .hasFullyQualifiedName("System", "InvalidOperationException")
          )
      )
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      CaseTree.super.succ(pred, succ, c)
      or
      last(super.getBody(), pred, c) and
      succ = this and
      c instanceof NormalCompletion
    }
  }

  private class ConstructorInitializerTree extends PostOrderTree instanceof ConstructorInitializer {
    private ControlFlowTree getChildNode(int i) { result = getExprChild(this, i) }

    final override predicate propagatesAbnormal(AstNode child) { child = this.getChildNode(_) }

    final override predicate first(AstNode first) {
      first(this.getChildNode(0), first)
      or
      not exists(this.getChildNode(0)) and
      first = this
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Post-order: flow from last element of last child to element itself
      exists(int lst |
        lst = max(int i | exists(this.getChildNode(i))) and
        last(this.getChildNode(lst), pred, c) and
        succ = this and
        c instanceof NormalCompletion
      )
      or
      // Standard left-to-right evaluation
      exists(int i |
        last(this.getChildNode(i), pred, c) and
        c instanceof NormalCompletion and
        first(this.getChildNode(i + 1), succ)
      )
      or
      exists(ConstructorTree con, CompilationExt comp |
        last(this, pred, c) and
        con = super.getConstructor() and
        comp = getCompilation(this.getFile()) and
        c instanceof NormalCompletion
      |
        // Flow from constructor initializer to first member initializer
        first(InitializerSplitting::constructorInitializeOrder(con, comp, 0), succ)
        or
        // Flow from constructor initializer to first element of constructor body
        not exists(InitializerSplitting::constructorInitializeOrder(con, comp, _)) and
        first(con.getBody(comp), succ)
      )
    }
  }

  private class NotPatternExprTree extends PostOrderTree instanceof NotPatternExpr {
    final override predicate propagatesAbnormal(AstNode child) { child = super.getPattern() }

    final override predicate first(AstNode first) { first(super.getPattern(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      succ = this and
      last(super.getPattern(), pred, c) and
      c instanceof NormalCompletion
    }
  }

  private class AndPatternExprTree extends PostOrderTree instanceof AndPatternExpr {
    final override predicate propagatesAbnormal(AstNode child) { child = super.getAnOperand() }

    final override predicate first(AstNode first) { first(super.getLeftOperand(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Flow from last element of left operand to first element of right operand
      last(super.getLeftOperand(), pred, c) and
      c.(MatchingCompletion).getValue() = true and
      first(super.getRightOperand(), succ)
      or
      // Post-order: flow from last element of left operand to element itself
      last(super.getLeftOperand(), pred, c) and
      c.(MatchingCompletion).getValue() = false and
      succ = this
      or
      // Post-order: flow from last element of right operand to element itself
      last(super.getRightOperand(), pred, c) and
      c instanceof MatchingCompletion and
      succ = this
    }
  }

  private class OrPatternExprTree extends PostOrderTree instanceof OrPatternExpr {
    final override predicate propagatesAbnormal(AstNode child) { child = super.getAnOperand() }

    final override predicate first(AstNode first) { first(super.getLeftOperand(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Flow from last element of left operand to first element of right operand
      last(super.getLeftOperand(), pred, c) and
      c.(MatchingCompletion).getValue() = false and
      first(super.getRightOperand(), succ)
      or
      // Post-order: flow from last element of left operand to element itself
      last(super.getLeftOperand(), pred, c) and
      c.(MatchingCompletion).getValue() = true and
      succ = this
      or
      // Post-order: flow from last element of right operand to element itself
      last(super.getRightOperand(), pred, c) and
      c instanceof MatchingCompletion and
      succ = this
    }
  }
}

private class RecursivePatternExprTree extends PostOrderTree instanceof RecursivePatternExpr {
  private Expr getTypeExpr() {
    result = super.getVariableDeclExpr()
    or
    not exists(super.getVariableDeclExpr()) and
    result = super.getTypeAccess()
  }

  private PatternExpr getChildPattern() {
    result = super.getPositionalPatterns()
    or
    result = super.getPropertyPatterns()
  }

  final override predicate propagatesAbnormal(AstNode child) { child = this.getChildPattern() }

  final override predicate first(AstNode first) {
    first(this.getTypeExpr(), first)
    or
    not exists(this.getTypeExpr()) and
    first(this.getChildPattern(), first)
  }

  final override predicate succ(AstNode pred, AstNode succ, Completion c) {
    // Flow from type test to child pattern
    last(this.getTypeExpr(), pred, c) and
    first(this.getChildPattern(), succ) and
    c.(MatchingCompletion).getValue() = true
    or
    // Flow from type test to self
    last(this.getTypeExpr(), pred, c) and
    succ = this and
    c.(MatchingCompletion).getValue() = false
    or
    // Flow from child pattern to self
    last(this.getChildPattern(), pred, c) and
    succ = this and
    c instanceof MatchingCompletion
  }
}

private class PositionalPatternExprTree extends PreOrderTree instanceof PositionalPatternExpr {
  final override predicate propagatesAbnormal(AstNode child) { child = super.getPattern(_) }

  final override predicate last(AstNode last, Completion c) {
    last = this and
    c.(MatchingCompletion).getValue() = false
    or
    last(super.getPattern(_), last, c) and
    c.(MatchingCompletion).getValue() = false
    or
    exists(int lst |
      last(super.getPattern(lst), last, c) and
      not exists(super.getPattern(lst + 1))
    )
  }

  final override predicate succ(AstNode pred, AstNode succ, Completion c) {
    // Flow from self to first pattern
    pred = this and
    c.(MatchingCompletion).getValue() = true and
    first(super.getPattern(0), succ)
    or
    // Flow from one pattern to the next
    exists(int i |
      last(super.getPattern(i), pred, c) and
      c.(MatchingCompletion).getValue() = true and
      first(super.getPattern(i + 1), succ)
    )
  }
}

private class PropertyPatternExprExprTree extends PostOrderTree instanceof PropertyPatternExpr {
  final override predicate propagatesAbnormal(AstNode child) { child = super.getPattern(_) }

  final override predicate first(AstNode first) {
    first(super.getPattern(0), first)
    or
    not exists(super.getPattern(0)) and
    first = this
  }

  final override predicate succ(AstNode pred, AstNode succ, Completion c) {
    // Flow from one pattern to the next
    exists(int i |
      last(super.getPattern(i), pred, c) and
      c.(MatchingCompletion).getValue() = true and
      first(super.getPattern(i + 1), succ)
    )
    or
    // Post-order: flow from last element of failing pattern to element itself
    last(super.getPattern(_), pred, c) and
    c.(MatchingCompletion).getValue() = false and
    succ = this
    or
    // Post-order: flow from last element of last pattern to element itself
    exists(int last |
      last(super.getPattern(last), pred, c) and
      not exists(super.getPattern(last + 1)) and
      c instanceof MatchingCompletion and
      succ = this
    )
  }
}

module Statements {
  private class StandardStmt extends StandardPreOrderTree instanceof Stmt {
    StandardStmt() {
      // The following statements need special treatment
      not this instanceof IfStmt and
      not this instanceof SwitchStmt and
      not this instanceof CaseStmt and
      not this instanceof LoopStmt and
      not this instanceof TryStmt and
      not this instanceof SpecificCatchClause and
      not this instanceof JumpStmt and
      not this instanceof LabeledStmt
    }

    private ControlFlowTree getChildNode0(int i) {
      not this instanceof GeneralCatchClause and
      not this instanceof FixedStmt and
      not this instanceof UsingBlockStmt and
      result = this.getChild(i)
      or
      this = any(GeneralCatchClause gcc | i = 0 and result = gcc.getBlock())
      or
      this =
        any(FixedStmt fs |
          result = fs.getVariableDeclExpr(i)
          or
          result = fs.getBody() and
          i = max(int j | exists(fs.getVariableDeclExpr(j))) + 1
        )
      or
      this =
        any(UsingBlockStmt us |
          result = us.getExpr() and
          i = 0
          or
          result = us.getVariableDeclExpr(i)
          or
          result = us.getBody() and
          i = max([1, count(us.getVariableDeclExpr(_))])
        )
    }

    final override AstNode getChildNode(int i) {
      result = rank[i + 1](AstNode cfe, int j | cfe = this.getChildNode0(j) | cfe order by j)
    }
  }

  private class IfStmtTree extends PreOrderTree instanceof IfStmt {
    final override predicate propagatesAbnormal(AstNode child) { child = super.getCondition() }

    final override predicate last(AstNode last, Completion c) {
      // Condition exits with a false completion and there is no `else` branch
      last(super.getCondition(), last, c) and
      c instanceof FalseCompletion and
      not exists(super.getElse())
      or
      // Then branch exits with any completion
      last(super.getThen(), last, c)
      or
      // Else branch exits with any completion
      last(super.getElse(), last, c)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Pre-order: flow from statement itself to first element of condition
      pred = this and
      first(super.getCondition(), succ) and
      c instanceof SimpleCompletion
      or
      last(super.getCondition(), pred, c) and
      (
        // Flow from last element of condition to first element of then branch
        c instanceof TrueCompletion and first(super.getThen(), succ)
        or
        // Flow from last element of condition to first element of else branch
        c instanceof FalseCompletion and first(super.getElse(), succ)
      )
    }
  }

  private class SwitchStmtTree extends PreOrderTree, SwitchTree instanceof SwitchStmt {
    final override predicate last(AstNode last, Completion c) {
      // Switch expression exits normally and there are no cases
      not exists(super.getACase()) and
      last(super.getExpr(), last, c) and
      c instanceof NormalCompletion
      or
      // A statement exits with a `break` completion
      last(super.getStmt(_), last, c.(NestedBreakCompletion).getAnInnerCompatibleCompletion())
      or
      // A statement exits abnormally
      last(super.getStmt(_), last, c) and
      not c instanceof BreakCompletion and
      not c instanceof NormalCompletion and
      not any(LabeledStmtTree t |
        t.hasLabelInCallable(c.(GotoCompletion).getLabel(), super.getEnclosingCallable())
      ) instanceof CaseStmt
      or
      // Last case exits with a non-match
      exists(CaseStmt cs, int last_ |
        last_ = max(int i | exists(super.getCase(i))) and
        cs = super.getCase(last_)
      |
        last(cs.getPattern(), last, c) and
        not c.(MatchingCompletion).isMatch()
        or
        last(cs.getCondition(), last, c) and
        c instanceof FalseCompletion
      )
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      SwitchTree.super.succ(pred, succ, c)
      or
      // Pre-order: flow from statement itself to first switch expression
      pred = this and
      first(super.getExpr(), succ) and
      c instanceof SimpleCompletion
      or
      // Flow from last element of non-`case` statement `i` to first element of statement `i+1`
      exists(int i | last(super.getStmt(i), pred, c) |
        not super.getStmt(i) instanceof CaseStmt and
        c instanceof NormalCompletion and
        first(super.getStmt(i + 1), succ)
      )
      or
      // Flow from last element of `case` statement `i` to first element of statement `i+1`
      exists(int i | last(super.getStmt(i).(CaseStmt).getBody(), pred, c) |
        c instanceof NormalCompletion and
        first(super.getStmt(i + 1), succ)
      )
    }
  }

  private class CaseStmtTree extends PreOrderTree, CaseTree instanceof CaseStmt {
    final override predicate last(AstNode last, Completion c) {
      // Condition exists with a `false` completion
      last(super.getCondition(), last, c) and
      c instanceof FalseCompletion
      or
      // Case pattern exits with a non-match
      last(super.getPattern(), last, c) and
      not c.(MatchingCompletion).isMatch()
      or
      // Case body exits with any completion
      last(super.getBody(), last, c)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      CaseTree.super.succ(pred, succ, c)
      or
      pred = this and
      first(super.getPattern(), succ) and
      c instanceof SimpleCompletion
    }
  }

  abstract private class LoopStmtTree extends PreOrderTree instanceof LoopStmt {
    final override predicate propagatesAbnormal(AstNode child) { child = super.getCondition() }

    final override predicate last(AstNode last, Completion c) {
      // Condition exits with a false completion
      last(super.getCondition(), last, c) and
      c instanceof FalseCompletion
      or
      // Body exits with a break completion
      last(super.getBody(), last, c.(NestedBreakCompletion).getAnInnerCompatibleCompletion())
      or
      // Body exits with a completion that does not continue the loop
      last(super.getBody(), last, c) and
      not c instanceof BreakCompletion and
      not c.continuesLoop()
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Flow from last element of condition to first element of loop body
      last(super.getCondition(), pred, c) and
      c instanceof TrueCompletion and
      first(super.getBody(), succ)
      or
      // Flow from last element of loop body back to first element of condition
      not this instanceof ForStmt and
      last(super.getBody(), pred, c) and
      c.continuesLoop() and
      first(super.getCondition(), succ)
    }
  }

  private class WhileStmtTree extends LoopStmtTree instanceof WhileStmt {
    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      LoopStmtTree.super.succ(pred, succ, c)
      or
      pred = this and
      first(super.getCondition(), succ) and
      c instanceof SimpleCompletion
    }
  }

  private class DoStmtTree extends LoopStmtTree instanceof DoStmt {
    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      LoopStmtTree.super.succ(pred, succ, c)
      or
      pred = this and
      first(super.getBody(), succ) and
      c instanceof SimpleCompletion
    }
  }

  private class ForStmtTree extends LoopStmtTree instanceof ForStmt {
    /** Gets the condition if it exists, otherwise the body. */
    private AstNode getConditionOrBody() {
      result = super.getCondition()
      or
      not exists(super.getCondition()) and
      result = super.getBody()
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      LoopStmtTree.super.succ(pred, succ, c)
      or
      // Pre-order: flow from statement itself to first element of first initializer/
      // condition/loop body
      exists(AstNode next |
        pred = this and
        first(next, succ) and
        c instanceof SimpleCompletion
      |
        next = super.getInitializer(0)
        or
        not exists(super.getInitializer(0)) and
        next = this.getConditionOrBody()
      )
      or
      // Flow from last element of initializer `i` to first element of initializer `i+1`
      exists(int i | last(super.getInitializer(i), pred, c) |
        c instanceof NormalCompletion and
        first(super.getInitializer(i + 1), succ)
      )
      or
      // Flow from last element of last initializer to first element of condition/loop body
      exists(int last | last = max(int i | exists(super.getInitializer(i))) |
        last(super.getInitializer(last), pred, c) and
        c instanceof NormalCompletion and
        first(this.getConditionOrBody(), succ)
      )
      or
      // Flow from last element of condition into first element of loop body
      last(super.getCondition(), pred, c) and
      c instanceof TrueCompletion and
      first(super.getBody(), succ)
      or
      // Flow from last element of loop body to first element of update/condition/self
      exists(AstNode next |
        last(super.getBody(), pred, c) and
        c.continuesLoop() and
        first(next, succ) and
        if exists(super.getUpdate(0))
        then next = super.getUpdate(0)
        else next = this.getConditionOrBody()
      )
      or
      // Flow from last element of update to first element of next update/condition/loop body
      exists(AstNode next, int i |
        last(super.getUpdate(i), pred, c) and
        c instanceof NormalCompletion and
        first(next, succ) and
        if exists(super.getUpdate(i + 1))
        then next = super.getUpdate(i + 1)
        else next = this.getConditionOrBody()
      )
    }
  }

  private class ForeachStmtTree extends ControlFlowTree instanceof ForeachStmt {
    final override predicate propagatesAbnormal(AstNode child) { child = super.getIterableExpr() }

    final override predicate first(AstNode first) {
      // Unlike most other statements, `foreach` statements are not modeled in
      // pre-order, because we use the `foreach` node itself to represent the
      // emptiness test that determines whether to execute the loop body
      first(super.getIterableExpr(), first)
    }

    final override predicate last(AstNode last, Completion c) {
      // Emptiness test exits with no more elements
      last = this and
      c.(EmptinessCompletion).isEmpty()
      or
      // Body exits with a break completion
      last(super.getBody(), last, c.(NestedBreakCompletion).getAnInnerCompatibleCompletion())
      or
      // Body exits abnormally
      last(super.getBody(), last, c) and
      not c instanceof NormalCompletion and
      not c instanceof ContinueCompletion and
      not c instanceof BreakCompletion
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Flow from last element of iterator expression to emptiness test
      last(super.getIterableExpr(), pred, c) and
      c instanceof NormalCompletion and
      succ = this
      or
      // Flow from emptiness test to first element of variable declaration/loop body
      pred = this and
      c = any(EmptinessCompletion ec | not ec.isEmpty()) and
      (
        first(super.getVariableDeclExpr(), succ)
        or
        first(super.getVariableDeclTuple(), succ)
        or
        not exists(super.getVariableDeclExpr()) and
        not exists(super.getVariableDeclTuple()) and
        first(super.getBody(), succ)
      )
      or
      // Flow from last element of variable declaration to first element of loop body
      (
        last(super.getVariableDeclExpr(), pred, c) or
        last(super.getVariableDeclTuple(), pred, c)
      ) and
      c instanceof SimpleCompletion and
      first(super.getBody(), succ)
      or
      // Flow from last element of loop body back to emptiness test
      last(super.getBody(), pred, c) and
      c.continuesLoop() and
      succ = this
    }
  }

  pragma[nomagic]
  private AstNode lastLastCatchClause(CatchClause cc, Completion c) {
    cc.isLast() and
    last(cc, result, c)
  }

  pragma[nomagic]
  private AstNode lastCatchClauseBlock(CatchClause cc, Completion c) {
    last(cc.getBlock(), result, c)
  }

  /** Gets a child of `cfe` that is in CFG scope `scope`. */
  pragma[noinline]
  private ControlFlowElement getAChildInScope(AstNode cfe, Callable scope) {
    result = getAChild(cfe) and
    scope = result.getEnclosingCallable()
  }

  class TryStmtTree extends PreOrderTree instanceof TryStmt {
    final override predicate propagatesAbnormal(AstNode child) { child = super.getFinally() }

    /**
     * Gets a descendant that belongs to the finally block of this try statement.
     */
    AstNode getAFinallyDescendant() {
      result = super.getFinally()
      or
      exists(ControlFlowElement mid |
        mid = this.getAFinallyDescendant() and
        result = getAChildInScope(mid, mid.getEnclosingCallable()) and
        not exists(TryStmt nestedTry |
          result = nestedTry.getFinally() and
          nestedTry != this
        )
      )
    }

    /**
     * Holds if `innerTry` has a finally block and is immediately nested inside the
     * finally block of this try statement.
     */
    private predicate nestedFinally(TryStmt innerTry) {
      exists(AstNode innerFinally |
        innerFinally = getAChildInScope(this.getAFinallyDescendant(), super.getEnclosingCallable()) and
        innerFinally = innerTry.getFinally()
      )
    }

    /**
     * Gets the finally-nesting level of this try statement. That is, the number of
     * finally blocks that this try statement is nested under.
     */
    int nestLevel() { result = count(TryStmtTree outer | outer.nestedFinally+(this)) }

    /** Holds if `last` is a last element of the block of this try statement. */
    pragma[nomagic]
    predicate lastBlock(AstNode last, Completion c) { last(super.getBlock(), last, c) }

    /**
     * Gets a last element from a `try` or `catch` block of this try statement
     * that may finish with completion `c`, such that control may be transferred
     * to the finally block (if it exists), but only if `finalizable = true`.
     */
    pragma[nomagic]
    AstNode getAFinallyPredecessor(Completion c, boolean finalizable) {
      // Exit completions skip the finally block
      (if c instanceof ExitCompletion then finalizable = false else finalizable = true) and
      (
        this.lastBlock(result, c) and
        (
          // Any non-throw completion from the `try` block will always continue directly
          // to the finally block
          not c instanceof ThrowCompletion
          or
          // Any completion from the `try` block will continue to the finally block
          // when there are no catch clauses
          not exists(super.getACatchClause())
        )
        or
        // Last element from any of the `catch` clause blocks continues to the finally block
        result = lastCatchClauseBlock(super.getACatchClause(), c)
        or
        // Last element of last `catch` clause continues to the finally block
        result = lastLastCatchClause(super.getACatchClause(), c)
      )
    }

    pragma[nomagic]
    private predicate lastFinally0(AstNode last, Completion c) { last(super.getFinally(), last, c) }

    pragma[nomagic]
    private predicate lastFinally(
      AstNode last, NormalCompletion finally, Completion outer, int nestLevel
    ) {
      this.lastFinally0(last, finally) and
      exists(
        this.getAFinallyPredecessor(any(Completion c0 | outer = c0.getOuterCompletion()), true)
      ) and
      nestLevel = this.nestLevel()
    }

    final override predicate last(AstNode last, Completion c) {
      exists(boolean finalizable | last = this.getAFinallyPredecessor(c, finalizable) |
        // If there is no finally block, last elements are from the body, from
        // the blocks of one of the `catch` clauses, or from the last `catch` clause
        not super.hasFinally()
        or
        finalizable = false
      )
      or
      this.lastFinally(last, c, any(NormalCompletion nc), _)
      or
      // If the finally block completes normally, it inherits any non-normal
      // completion that was current before the finally block was entered
      exists(int nestLevel |
        c =
          any(NestedCompletion nc |
            this.lastFinally(last, nc.getAnInnerCompatibleCompletion(), nc.getOuterCompletion(),
              nestLevel) and
            // unbind
            nc.getNestLevel() >= nestLevel and
            nc.getNestLevel() <= nestLevel
          )
      )
    }

    /**
     * Gets an exception type that is thrown by `cfe` in the block of this `try`
     * statement. Throw completion `c` matches the exception type.
     */
    ExceptionClass getAThrownException(AstNode cfe, ThrowCompletion c) {
      this.lastBlock(cfe, c) and
      result = c.getExceptionClass()
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Pre-order: flow from statement itself to first element of body
      pred = this and
      first(super.getBlock(), succ) and
      c instanceof SimpleCompletion
      or
      // Flow from last element of body to first `catch` clause
      exists(this.getAThrownException(pred, c)) and
      first(super.getCatchClause(0), succ)
      or
      exists(CatchClause cc, int i | cc = super.getCatchClause(i) |
        // Flow from one `catch` clause to the next
        pred = cc and
        last(super.getCatchClause(i), cc, c) and
        first(super.getCatchClause(i + 1), succ) and
        c = any(MatchingCompletion mc | not mc.isMatch())
        or
        // Flow from last element of `catch` clause filter to next `catch` clause
        last(super.getCatchClause(i), pred, c) and
        last(cc.getFilterClause(), pred, _) and
        first(super.getCatchClause(i + 1), succ) and
        c instanceof FalseCompletion
      )
      or
      // Flow into finally block
      pred = this.getAFinallyPredecessor(c, true) and
      first(super.getFinally(), succ)
    }
  }

  private class SpecificCatchClauseTree extends PreOrderTree instanceof SpecificCatchClause {
    final override predicate propagatesAbnormal(AstNode child) { child = super.getFilterClause() }

    pragma[nomagic]
    private predicate lastFilterClause(AstNode last, Completion c) {
      last(super.getFilterClause(), last, c)
    }

    /**
     * Holds if the `try` block that this catch clause belongs to may throw an
     * exception of type `c`, where no `catch` clause is guaranteed to catch it.
     * This catch clause is the last catch clause in the try statement that
     * it belongs to.
     */
    pragma[nomagic]
    private predicate throwMayBeUncaught(ThrowCompletion c) {
      exists(TryStmt ts |
        ts = super.getTryStmt() and
        ts.(TryStmtTree).lastBlock(_, c) and
        not ts.getACatchClause() instanceof GeneralCatchClause and
        forall(SpecificCatchClause scc | scc = ts.getACatchClause() |
          scc.hasFilterClause()
          or
          not c.getExceptionClass().getABaseType*() = scc.getCaughtExceptionType()
        ) and
        super.isLast()
      )
    }

    final override predicate last(AstNode last, Completion c) {
      // Last element of `catch` block
      last(super.getBlock(), last, c)
      or
      not super.isLast() and
      (
        // Incompatible exception type: clause itself
        last = this and
        c.(MatchingCompletion).isNonMatch()
        or
        // Incompatible filter
        this.lastFilterClause(last, c) and
        c instanceof FalseCompletion
      )
      or
      // Last `catch` clause inherits throw completions from the `try` block,
      // when the clause does not match
      super.isLast() and
      c =
        any(NestedCompletion nc |
          nc.getNestLevel() = 0 and
          this.throwMayBeUncaught(nc.getOuterCompletion()) and
          (
            // Incompatible exception type: clause itself
            last = this and
            nc.getInnerCompletion() =
              any(MatchingCompletion mc |
                mc.isNonMatch() and
                mc.isValidFor(this)
              )
            or
            // Incompatible filter
            this.lastFilterClause(last, nc.getInnerCompletion().(FalseCompletion))
          )
        )
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Flow from catch clause to variable declaration/filter clause/block
      pred = this and
      c.(MatchingCompletion).isMatch() and
      exists(AstNode next | first(next, succ) |
        if exists(super.getVariableDeclExpr())
        then next = super.getVariableDeclExpr()
        else
          if exists(super.getFilterClause())
          then next = super.getFilterClause()
          else next = super.getBlock()
      )
      or
      // Flow from variable declaration to filter clause/block
      last(super.getVariableDeclExpr(), pred, c) and
      c instanceof SimpleCompletion and
      exists(AstNode next | first(next, succ) |
        if exists(super.getFilterClause())
        then next = super.getFilterClause()
        else next = super.getBlock()
      )
      or
      // Flow from filter to block
      last(super.getFilterClause(), pred, c) and
      c instanceof TrueCompletion and
      first(super.getBlock(), succ)
    }
  }

  private class JumpStmtTree extends PostOrderTree instanceof JumpStmt {
    final override predicate propagatesAbnormal(AstNode child) { child = this.getChild(0) }

    final override predicate first(AstNode first) {
      first(this.getChild(0), first)
      or
      not exists(this.getChild(0)) and first = this
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(this.getChild(0), pred, c) and
      succ = this and
      c instanceof NormalCompletion
    }
  }

  pragma[nomagic]
  private predicate goto(ControlFlowElement cfe, GotoCompletion gc, string label, Callable enclosing) {
    last(_, cfe, gc) and
    // Special case: when a `goto` happens inside a try statement with a
    // finally block, flow does not go directly to the target, but instead
    // to the finally block (and from there possibly to the target)
    not cfe =
      any(Statements::TryStmtTree t | t.(TryStmt).hasFinally()).getAFinallyPredecessor(_, true) and
    label = gc.getLabel() and
    enclosing = cfe.getEnclosingCallable()
  }

  private class LabeledStmtTree extends PreOrderTree instanceof LabeledStmt {
    final override predicate propagatesAbnormal(AstNode child) { none() }

    final override predicate last(AstNode last, Completion c) {
      if this instanceof DefaultCase
      then last(super.getStmt(), last, c)
      else (
        not this instanceof CaseStmt and
        last = this and
        c.isValidFor(this)
      )
    }

    pragma[noinline]
    predicate hasLabelInCallable(string label, Callable c) {
      super.getEnclosingCallable() = c and
      label = super.getLabel()
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      this instanceof DefaultCase and
      pred = this and
      first(super.getStmt(), succ) and
      c instanceof SimpleCompletion
      or
      // Flow from element with matching `goto` completion to this statement
      exists(string label, Callable enclosing |
        goto(pred, c, label, enclosing) and
        this.hasLabelInCallable(label, enclosing) and
        succ = this
      )
    }
  }
}

/** A control flow element that is split into multiple control flow nodes. */
class SplitAstNode extends AstNode, ControlFlowElement {
  SplitAstNode() { strictcount(this.getAControlFlowNode()) > 1 }
}
