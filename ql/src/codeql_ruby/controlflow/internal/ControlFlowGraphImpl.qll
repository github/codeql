/**
 * Provides auxiliary classes and predicates used to construct the basic successor
 * relation on control flow elements.
 *
 * The implementation is centered around the concept of a _completion_, which
 * models how the execution of a statement or expression terminates.
 * Completions are represented as an algebraic data type `Completion` defined in
 * `Completion.qll`.
 *
 * The CFG is built by structural recursion over the AST. To achieve this the
 * CFG edges related to a given AST node, `n`, are divided into three categories:
 *
 *   1. The in-going edge that points to the first CFG node to execute when
 *      `n` is going to be executed.
 *   2. The out-going edges for control flow leaving `n` that are going to some
 *      other node in the surrounding context of `n`.
 *   3. The edges that have both of their end-points entirely within the AST
 *      node and its children.
 *
 * The edges in (1) and (2) are inherently non-local and are therefore
 * initially calculated as half-edges, that is, the single node, `k`, of the
 * edge contained within `n`, by the predicates `k = first(n)` and `k = last(n, _)`,
 * respectively. The edges in (3) can then be enumerated directly by the predicate
 * `succ` by calling `first` and `last` recursively on the children of `n` and
 * connecting the end-points. This yields the entire CFG, since all edges are in
 * (3) for _some_ AST node.
 *
 * The second parameter of `last` is the completion, which is necessary to distinguish
 * the out-going edges from `n`. Note that the completion changes as the calculation of
 * `last` proceeds outward through the AST; for example, a `BreakCompletion` is
 * caught up by its surrounding loop and turned into a `NormalCompletion`.
 */

private import codeql_ruby.AST as AST
private import codeql_ruby.ast.internal.AST as ASTInternal
private import codeql_ruby.ast.internal.Scope
private import codeql_ruby.ast.Scope
private import codeql_ruby.ast.internal.TreeSitter::Generated
private import AstNodes
private import codeql_ruby.ast.internal.Variable
private import codeql_ruby.controlflow.ControlFlowGraph
private import Completion
private import SuccessorTypes
private import Splitting
private import codeql.files.FileSystem

module CfgScope {
  abstract class Range_ extends AstNode {
    abstract predicate entry(AstNode first);

    abstract predicate exit(AstNode last, Completion c);
  }

  private class ProgramScope extends Range_, Program {
    final override predicate entry(AstNode first) { first(this, first) }

    final override predicate exit(AstNode last, Completion c) { last(this, last, c) }
  }

  private class BeginBlockScope extends Range_, BeginBlock {
    final override predicate entry(AstNode first) {
      first(this.(Trees::BeginBlockTree).getFirstChildNode(), first)
    }

    final override predicate exit(AstNode last, Completion c) {
      last(this.(Trees::BeginBlockTree).getLastChildNode(), last, c)
    }
  }

  private class EndBlockScope extends Range_, EndBlock {
    final override predicate entry(AstNode first) {
      first(this.(Trees::EndBlockTree).getFirstChildNode(), first)
    }

    final override predicate exit(AstNode last, Completion c) {
      last(this.(Trees::EndBlockTree).getLastChildNode(), last, c)
    }
  }

  private class MethodScope extends Range_, AstNode {
    MethodScope() { this instanceof Method }

    final override predicate entry(AstNode first) {
      this.(Trees::RescueEnsureBlockTree).firstInner(first)
    }

    final override predicate exit(AstNode last, Completion c) {
      this.(Trees::RescueEnsureBlockTree).lastInner(last, c)
    }
  }

  private class SingletonMethodScope extends Range_, AstNode {
    SingletonMethodScope() { this instanceof SingletonMethod }

    final override predicate entry(AstNode first) {
      this.(Trees::RescueEnsureBlockTree).firstInner(first)
    }

    final override predicate exit(AstNode last, Completion c) {
      this.(Trees::RescueEnsureBlockTree).lastInner(last, c)
    }
  }

  private class DoBlockScope extends Range_, DoBlock {
    DoBlockScope() { not this.getParent() instanceof Lambda }

    final override predicate entry(AstNode first) {
      this.(Trees::RescueEnsureBlockTree).firstInner(first)
    }

    final override predicate exit(AstNode last, Completion c) {
      this.(Trees::RescueEnsureBlockTree).lastInner(last, c)
    }
  }

  private class BlockScope extends Range_, Block {
    BlockScope() { not this.getParent() instanceof Lambda }

    final override predicate entry(AstNode first) {
      first(this.(Trees::BlockTree).getFirstChildNode(), first)
    }

    final override predicate exit(AstNode last, Completion c) {
      last(this.(Trees::BlockTree).getLastChildNode(), last, c)
    }
  }

  private class LambdaScope extends Range_, Lambda {
    final override predicate entry(AstNode first) {
      first(this.getParameters(), first)
      or
      not exists(this.getParameters()) and
      (
        this.getBody().(Trees::DoBlockTree).firstInner(first)
        or
        first(this.getBody().(Trees::BlockTree).getFirstChildNode(), first)
      )
    }

    final override predicate exit(AstNode last, Completion c) {
      last(this.getParameters(), last, c) and
      not c instanceof NormalCompletion
      or
      last(this.getBody().(Trees::BlockTree).getLastChildNode(), last, c)
      or
      this.getBody().(Trees::RescueEnsureBlockTree).lastInner(last, c)
      or
      not exists(this.getBody()) and last(this.getParameters(), last, c)
    }
  }
}

abstract private class ControlFlowTree extends AstNode {
  /**
   * Holds if `first` is the first element executed within this AST node.
   */
  pragma[nomagic]
  abstract predicate first(AstNode first);

  /**
   * Holds if `last` with completion `c` is a potential last element executed
   * within this AST node.
   */
  pragma[nomagic]
  abstract predicate last(AstNode last, Completion c);

  /** Holds if abnormal execution of `child` should propagate upwards. */
  abstract predicate propagatesAbnormal(AstNode child);

  /**
   * Holds if `succ` is a control flow successor for `pred`, given that `pred`
   * finishes with completion `c`.
   */
  pragma[nomagic]
  abstract predicate succ(AstNode pred, AstNode succ, Completion c);

  /**
   * Holds if this node should be hidden in the CFG. That is, edges
   * `pred -> this -> succ` are converted to a single edge `pred -> succ`.
   */
  predicate isHidden() { none() }
}

/** Holds if `first` is the first element executed within AST node `n`. */
predicate first(ControlFlowTree n, AstNode first) { n.first(first) }

/**
 * Holds if `last` with completion `c` is a potential last element executed
 * within AST node `n`.
 */
predicate last(ControlFlowTree n, AstNode last, Completion c) {
  n.last(last, c)
  or
  exists(AstNode child |
    n.propagatesAbnormal(child) and
    last(child, last, c) and
    not c instanceof NormalCompletion
  )
}

private predicate succImpl(AstNode pred, AstNode succ, Completion c) {
  any(ControlFlowTree cft).succ(pred, succ, c)
}

private predicate isHidden(ControlFlowTree t) {
  not t = ASTInternal::toTreeSitter(_)
  or
  t.isHidden()
}

private predicate succImplIfHidden(AstNode pred, AstNode succ) {
  isHidden(pred) and
  succImpl(pred, succ, any(SimpleCompletion c))
}

/**
 * Holds if `succ` is a control flow successor for `pred`, given that `pred`
 * finishes with completion `c`.
 */
pragma[nomagic]
predicate succ(AstNode pred, AstNode succ, Completion c) {
  exists(AstNode n |
    succImpl(pred, n, c) and
    succImplIfHidden*(n, succ) and
    not isHidden(pred) and
    not isHidden(succ)
  )
}

/** Holds if `first` is first executed when entering `scope`. */
pragma[nomagic]
predicate succEntry(CfgScope::Range_ scope, AstNode first) {
  exists(AstNode n |
    scope.entry(n) and
    succImplIfHidden*(n, first) and
    not isHidden(first)
  )
}

/** Holds if `last` with completion `c` can exit `scope`. */
pragma[nomagic]
predicate succExit(CfgScope::Range_ scope, AstNode last, Completion c) {
  exists(AstNode n |
    scope.exit(n, c) and
    succImplIfHidden*(last, n) and
    not isHidden(last)
  )
}

/**
 * An AST node where the children are evaluated following a standard left-to-right
 * evaluation. The actual evaluation order is determined by the predicate
 * `getChildNode()`.
 */
abstract private class StandardNode extends ControlFlowTree {
  /** Gets the `i`th child node, in order of evaluation. */
  ControlFlowTree getChildNode(int i) {
    result = this.getAFieldOrChild() and
    i = result.getParentIndex()
  }

  private AstNode getChildNodeRanked(int i) {
    result = rank[i + 1](AstNode child, int j | child = this.getChildNode(j) | child order by j)
  }

  /** Gets the first child node of this element. */
  final AstNode getFirstChildNode() { result = this.getChildNodeRanked(0) }

  /** Gets the last child node of this node. */
  final AstNode getLastChildNode() {
    exists(int last |
      result = this.getChildNodeRanked(last) and
      not exists(this.getChildNodeRanked(last + 1))
    )
  }

  override predicate propagatesAbnormal(AstNode child) { child = this.getChildNode(_) }

  pragma[nomagic]
  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    exists(int i |
      last(this.getChildNodeRanked(i), pred, c) and
      c instanceof NormalCompletion and
      first(this.getChildNodeRanked(i + 1), succ)
    )
  }
}

abstract private class PreOrderTree extends ControlFlowTree {
  final override predicate first(AstNode first) { first = this }
}

// TODO: remove this class; it should be replaced with an implicit non AST node
private class ForIn extends AST::AstNode, ASTInternal::TForIn {
  final override string toString() { result = "In" }
}

// TODO: remove this class; it should be replaced with an implicit non AST node
private class ForRange extends AST::ForExpr {
  override predicate child(string label, AST::AstNode child) {
    AST::ForExpr.super.child(label, child)
    or
    label = "<in>" and
    child = ASTInternal::TForIn(ASTInternal::toTreeSitter(this).(For).getValue())
  }
}

// TODO: remove this predicate
predicate isValidFor(Completion c, ControlFlowTree node) {
  c instanceof SimpleCompletion and isHidden(node)
  or
  c.isValidFor(ASTInternal::fromTreeSitter(node))
}

abstract private class StandardPreOrderTree extends StandardNode, PreOrderTree {
  final override predicate last(AstNode last, Completion c) {
    last(this.getLastChildNode(), last, c)
    or
    not exists(this.getLastChildNode()) and
    isValidFor(c, this) and
    last = this
  }

  final override predicate succ(AstNode pred, AstNode succ, Completion c) {
    StandardNode.super.succ(pred, succ, c)
    or
    pred = this and
    first(this.getFirstChildNode(), succ) and
    c instanceof SimpleCompletion
  }
}

abstract private class PostOrderTree extends ControlFlowTree {
  override predicate last(AstNode last, Completion c) {
    last = this and
    isValidFor(c, last)
  }
}

private class LeftToRightPostOrderNodes =
  @argument_list or @array or @bare_string or @bare_symbol or @binary or @block_argument or
      @break or @call or @chained_string or @delimited_symbol or @destructured_left_assignment or
      @destructured_parameter or @element_reference or @exception_variable or @hash or
      @hash_splat_argument or @interpolation or @left_assignment_list or @next or
      @operator_assignment or @pair or @parenthesized_statements or @range or @redo or @regex or
      @rest_assignment or @retry or @return or @right_assignment_list or @scope_resolution or
      @token_simple_symbol or @splat_argument or @string__ or @string_array or @subshell or
      @superclass or @symbol_array or @token_hash_key_symbol or @unary or @splat_parameter or
      @hash_splat_parameter or @block_parameter;

private class LeftToRightPostOrderTree extends StandardPostOrderTree, LeftToRightPostOrderNodes {
  LeftToRightPostOrderTree() {
    not this instanceof LogicalNotAstNode and
    not this instanceof LogicalAndAstNode and
    not this instanceof LogicalOrAstNode
  }

  override predicate isHidden() {
    this instanceof ArgumentList or
    this instanceof ChainedString or
    this instanceof ExceptionVariable or
    this instanceof LeftAssignmentList or
    this instanceof RightAssignmentList or
    this instanceof SplatParameter or
    this instanceof HashSplatParameter or
    this instanceof BlockParameter
  }
}

private class LeftToRightPreOrderNodes =
  @alias or @block_parameters or @class or @do or @else or @ensure or @lambda_parameters or
      @method_parameters or @pattern or @program or @then or @undef or @yield;

private class LeftToRightPreOrderTree extends StandardPreOrderTree, LeftToRightPreOrderNodes {
  override predicate isHidden() {
    this instanceof BlockParameters or
    this instanceof Do or
    this instanceof Else or
    this instanceof LambdaParameters or
    this instanceof MethodParameters or
    this instanceof Pattern or
    this instanceof Program or
    this instanceof Then
  }
}

abstract private class StandardPostOrderTree extends StandardNode, PostOrderTree {
  final override predicate first(AstNode first) {
    first(this.getFirstChildNode(), first)
    or
    not exists(this.getFirstChildNode()) and
    first = this
  }

  final override predicate succ(AstNode pred, AstNode succ, Completion c) {
    StandardNode.super.succ(pred, succ, c)
    or
    last(this.getLastChildNode(), pred, c) and
    succ = this and
    c instanceof NormalCompletion
  }
}

abstract private class LeafTree extends PreOrderTree, PostOrderTree {
  override predicate propagatesAbnormal(AstNode child) { none() }

  override predicate succ(AstNode pred, AstNode succ, Completion c) { none() }
}

abstract class ScopeTree extends StandardNode, LeafTree {
  final override predicate propagatesAbnormal(AstNode child) { none() }

  final override predicate succ(AstNode pred, AstNode succ, Completion c) {
    StandardNode.super.succ(pred, succ, c)
  }
}

/** Defines the CFG by dispatch on the various AST types. */
module Trees {
  private class AssignmentTree extends StandardPostOrderTree, Assignment {
    final override ControlFlowTree getChildNode(int i) {
      result = this.getRight() and i = 0
      or
      result = this.getLeft() and i = 1
    }
  }

  private class BeginTree extends RescueEnsureBlockTree, PreOrderTree, Begin {
    final override AstNode getChildNode(int i, boolean rescuable) {
      result = this.getChild(i) and rescuable = true
    }

    final override predicate last(AstNode last, Completion c) { this.lastInner(last, c) }

    override predicate isHidden() { any() }
  }

  class BeginBlockTree extends ScopeTree, BeginBlock {
    final override ControlFlowTree getChildNode(int i) { result = this.getChild(i) }
  }

  class BlockTree extends ScopeTree, Block {
    final override ControlFlowTree getChildNode(int i) {
      result = this.getParameters() and i = 0
      or
      result = this.getChild(i - 1)
    }
  }

  private class CaseTree extends PreOrderTree, Case {
    final override predicate propagatesAbnormal(AstNode child) {
      child = this.getValue() or child = this.getChild(_)
    }

    final override predicate last(AstNode last, Completion c) {
      last(this.getValue(), last, c) and not exists(this.getChild(_))
      or
      last(this.getChild(_).(When).getBody(), last, c)
      or
      exists(int i, ControlFlowTree lastBranch |
        lastBranch = this.getChild(i) and
        not exists(this.getChild(i + 1)) and
        last(lastBranch, last, c)
      )
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      exists(AstNode next |
        pred = this and
        first(next, succ) and
        c instanceof SimpleCompletion
      |
        next = this.getValue()
        or
        not exists(this.getValue()) and
        next = this.getChild(0)
      )
      or
      last(this.getValue(), pred, c) and
      first(this.getChild(0), succ) and
      c instanceof SimpleCompletion
      or
      exists(int i, WhenTree branch | branch = this.getChild(i) |
        last(branch.getLastPattern(), pred, c) and
        first(this.getChild(i + 1), succ) and
        c.(ConditionalCompletion).getValue() = false
      )
    }
  }

  private class CharacterTree extends LeafTree, Character { }

  private class ClassTree extends RescueEnsureBlockTree, PreOrderTree, Class {
    final override AstNode getChildNode(int i, boolean rescuable) {
      result = this.getName() and i = 0 and rescuable = false
      or
      result = this.getSuperclass() and i = 1 and rescuable = true
      or
      result = this.getChild(i - 2) and rescuable = true
    }

    final override predicate last(AstNode last, Completion c) { this.lastInner(last, c) }
  }

  private class ClassVariableTree extends LeafTree, ClassVariable { }

  private class ComplexTree extends LeafTree, Complex { }

  private class ConstantTree extends LeafTree, Constant { }

  /** A parameter that may have a default value. */
  abstract class DefaultValueParameterTree extends ControlFlowTree {
    abstract AstNode getDefaultValue();

    abstract AstNode getAccessNode();

    predicate hasDefaultValue() { exists(this.getDefaultValue()) }

    final override predicate propagatesAbnormal(AstNode child) {
      child = this.getDefaultValue() or child = this.getAccessNode()
    }

    final override predicate first(AstNode first) { first = this.getAccessNode() }

    final override predicate last(AstNode last, Completion c) {
      last(this.getDefaultValue(), last, c) and
      c instanceof NormalCompletion
      or
      last = this.getAccessNode() and
      (
        not this.hasDefaultValue() and
        c instanceof SimpleCompletion
        or
        this.hasDefaultValue() and
        c.(MatchingCompletion).getValue() = true
      )
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      pred = this.getAccessNode() and
      first(this.getDefaultValue(), succ) and
      c.(MatchingCompletion).getValue() = false
    }
  }

  class DoBlockTree extends RescueEnsureBlockTree, PostOrderTree, DoBlock {
    final override predicate first(AstNode first) { first = this }

    final override AstNode getChildNode(int i, boolean rescuable) {
      result = this.getParameters() and i = 0 and rescuable = false
      or
      result = this.getChild(i - 1) and rescuable = true
    }
  }

  private class EmptyStatementTree extends LeafTree, EmptyStatement { }

  class EndBlockTree extends ScopeTree, EndBlock {
    final override ControlFlowTree getChildNode(int i) { result = this.getChild(i) }
  }

  private class ExceptionsTree extends PreOrderTree, Exceptions {
    final override predicate propagatesAbnormal(AstNode child) { none() }

    final override predicate last(AstNode last, Completion c) {
      last(this.getChild(_), last, c) and
      c.(MatchingCompletion).getValue() = true
      or
      exists(int lst |
        last(this.getChild(lst), last, c) and
        not exists(this.getChild(lst + 1))
      )
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      pred = this and
      first(this.getChild(0), succ) and
      c instanceof SimpleCompletion
      or
      exists(int i |
        last(this.getChild(i), pred, c) and
        c.(MatchingCompletion).getValue() = false and
        first(this.getChild(i + 1), succ)
      )
    }

    override predicate isHidden() { any() }
  }

  private class FalseTree extends LeafTree, False { }

  private class FloatTree extends LeafTree, Float { }

  /**
   * Control flow of a for-in loop
   *
   * For example, this program fragment:
   *
   * ```rb
   * for arg in args do
   *   puts arg
   * end
   * puts "done";
   * ```
   *
   * has the following control flow graph:
   *
   * ```
   *           args
   *            |
   *           in------<-----
   *           / \           \
   *          /   \          |
   *         /     \         |
   *        /       \        |
   *     empty    non-empty  |
   *       |          \      |
   *      for          \     |
   *       |          arg    |
   *       |            |    |
   *  puts "done"   puts arg |
   *                     \___/
   * ```
   */
  private class ForTree extends PostOrderTree, For {
    final override predicate propagatesAbnormal(AstNode child) {
      child = this.getPattern() or child = this.getArray()
    }

    final override predicate first(AstNode first) { first(this.getArray(), first) }

    private In getIn() { result = this.getValue() }

    private UnderscoreArg getArray() { result = this.getValue().getChild() }

    /**
     * for pattern in array do body end
     * ```
     * array +-> in +--[non empty]--> pattern -> body -> in
     *              |--[empty]--> for
     * ```
     */
    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(this.getArray(), pred, c) and
      first(this.getIn(), succ) and
      c instanceof SimpleCompletion
      or
      last(this.getIn(), pred, c) and
      first(this.getPattern(), succ) and
      c.(EmptinessCompletion).getValue() = false
      or
      last(this.getPattern(), pred, c) and
      first(this.getBody(), succ) and
      c instanceof NormalCompletion
      or
      last(this.getBody(), pred, c) and
      first(this.getIn(), succ) and
      c.continuesLoop()
      or
      last(this.getBody(), pred, c) and
      first(this.getBody(), succ) and
      c instanceof RedoCompletion
      or
      succ = this and
      (
        last(this.getIn(), pred, c) and
        c.(EmptinessCompletion).getValue() = true
        or
        last(this.getBody(), pred, c) and
        not c.continuesLoop() and
        not c instanceof BreakCompletion and
        not c instanceof RedoCompletion
        or
        last(this.getBody(), pred, c.(NestedBreakCompletion).getAnInnerCompatibleCompletion())
      )
    }
  }

  private class GlobalVariableTree extends LeafTree, GlobalVariable { }

  private HeredocBody heredoc(HeredocBeginning start) {
    exists(int i, File f |
      start =
        rank[i](HeredocBeginning b |
          f = b.getLocation().getFile()
        |
          b order by b.getLocation().getStartLine(), b.getLocation().getStartColumn()
        ) and
      result =
        rank[i](HeredocBody b |
          f = b.getLocation().getFile()
        |
          b order by b.getLocation().getStartLine(), b.getLocation().getStartColumn()
        )
    )
  }

  private class HeredocBeginningTree extends StandardPreOrderTree, HeredocBeginning {
    final override ControlFlowTree getChildNode(int i) { result = heredoc(this).getChild(i) }
  }

  private class IdentifierTree extends LeafTree, Identifier { }

  private class IfElsifTree extends PostOrderTree, IfElsifAstNode {
    final override predicate propagatesAbnormal(AstNode child) {
      child = this.getConditionNode() or child = this.getBranch(_)
    }

    final override predicate first(AstNode first) { first(this.getConditionNode(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      exists(boolean b |
        last(this.getConditionNode(), pred, c) and
        b = c.(BooleanCompletion).getValue()
      |
        first(this.getBranch(b), succ)
        or
        not exists(this.getBranch(b)) and
        succ = this
      )
      or
      last(this.getBranch(_), pred, c) and
      succ = this and
      c instanceof NormalCompletion
    }
  }

  private class InTree extends LeafTree, In { }

  private class InstanceVariableTree extends LeafTree, InstanceVariable { }

  private class IntegerTree extends LeafTree, Integer { }

  private class KeywordParameterTree extends DefaultValueParameterTree, KeywordParameter {
    final override AstNode getDefaultValue() { result = this.getValue() }

    final override AstNode getAccessNode() { result = this.getName() }
  }

  class LambdaTree extends LeafTree, Lambda {
    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(this.getParameters(), pred, c) and
      c instanceof NormalCompletion and
      (
        this.getBody().(DoBlockTree).firstInner(succ)
        or
        first(this.getBody().(BlockTree).getFirstChildNode(), succ)
      )
    }
  }

  class LogicalAndTree extends PostOrderTree, LogicalAndAstNode {
    final override predicate propagatesAbnormal(AstNode child) { child in [left, right] }

    final override predicate first(AstNode first) { first(left, first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(left, pred, c) and
      c instanceof TrueCompletion and
      first(right, succ)
      or
      last(left, pred, c) and
      c instanceof FalseCompletion and
      succ = this
      or
      last(right, pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  class LogicalOrTree extends PostOrderTree, LogicalOrAstNode {
    final override predicate propagatesAbnormal(AstNode child) { child in [left, right] }

    final override predicate first(AstNode first) { first(left, first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(left, pred, c) and
      c instanceof FalseCompletion and
      first(right, succ)
      or
      last(left, pred, c) and
      c instanceof TrueCompletion and
      succ = this
      or
      last(right, pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  class LogicalNotTree extends PostOrderTree, LogicalNotAstNode {
    final override predicate propagatesAbnormal(AstNode child) { child = operand }

    final override predicate first(AstNode first) { first(operand, first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      succ = this and
      last(operand, pred, c) and
      c instanceof NormalCompletion
    }
  }

  private class MethodTree extends RescueEnsureBlockTree, PostOrderTree, Method {
    final override AstNode getChildNode(int i, boolean rescuable) {
      result = this.getParameters() and i = 0 and rescuable = false
      or
      result = this.getChild(i - 1) and rescuable = true
    }

    final override predicate first(AstNode first) { first(this.getName(), first) }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      RescueEnsureBlockTree.super.succ(pred, succ, c)
      or
      last(this.getName(), pred, c) and
      succ = this and
      c instanceof NormalCompletion
    }
  }

  private class ModuleTree extends RescueEnsureBlockTree, PreOrderTree, Module {
    final override AstNode getChildNode(int i, boolean rescuable) {
      result = this.getName() and i = 0 and rescuable = false
      or
      result = this.getChild(i - 1) and rescuable = true
    }

    final override predicate last(AstNode last, Completion c) { this.lastInner(last, c) }
  }

  private class NilTree extends LeafTree, Nil { }

  private class OptionalParameterTree extends DefaultValueParameterTree, OptionalParameter {
    final override AstNode getDefaultValue() { result = this.getValue() }

    final override AstNode getAccessNode() { result = this.getName() }
  }

  private class RationalTree extends LeafTree, Rational { }

  private class RescueTree extends PreOrderTree, Rescue {
    final override predicate propagatesAbnormal(AstNode child) { child = this.getExceptions() }

    predicate lastMatch(AstNode last, Completion c) {
      last(this.getBody(), last, c)
      or
      not exists(this.getBody()) and
      (
        last(this.getVariable(), last, c)
        or
        not exists(this.getVariable()) and
        (
          last(this.getExceptions(), last, c) and
          c.(MatchingCompletion).getValue() = true
          or
          not exists(this.getExceptions()) and
          last = this and
          isValidFor(c, this)
        )
      )
    }

    predicate lastNoMatch(AstNode last, Completion c) {
      last(this.getExceptions(), last, c) and
      c.(MatchingCompletion).getValue() = false
    }

    final override predicate last(AstNode last, Completion c) {
      this.lastNoMatch(last, c)
      or
      this.lastMatch(last, c)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      exists(AstNode next |
        pred = this and
        first(next, succ) and
        c instanceof SimpleCompletion
      |
        next = this.getExceptions()
        or
        not exists(this.getExceptions()) and
        (
          next = this.getVariable()
          or
          not exists(this.getVariable()) and
          next = this.getBody()
        )
      )
      or
      exists(AstNode next |
        last(this.getExceptions(), pred, c) and
        first(next, succ) and
        c.(MatchingCompletion).getValue() = true
      |
        next = this.getVariable()
        or
        not exists(this.getVariable()) and
        next = this.getBody()
      )
      or
      last(this.getVariable(), pred, c) and
      first(this.getBody(), succ) and
      c instanceof NormalCompletion
    }
  }

  /** Gets a child of `n` that is in CFG scope `scope`. */
  pragma[noinline]
  private AstNode getAChildInScope(AstNode n, CfgScope scope) {
    result.getParent() = n and
    scope = getCfgScope(result)
  }

  /** A block that may contain `rescue`/`ensure`. */
  abstract class RescueEnsureBlockTree extends ControlFlowTree {
    /**
     * Gets the `i`th child of this block. `rescuable` indicates whether exceptional
     * execution of the child can be caught by `rescue`/`ensure`.
     */
    abstract AstNode getChildNode(int i, boolean rescuable);

    /** Gets the `i`th child in the body of this block. */
    final private AstNode getBodyChild(int i, boolean rescuable) {
      result = this.getChildNode(_, rescuable) and
      result =
        rank[i + 1](AstNode child, int j |
          child = this.getChildNode(j, _) and
          not result instanceof Rescue and
          not result instanceof Ensure and
          not result instanceof Else
        |
          child order by j
        )
    }

    /** Gets the `i`th `rescue` block in this block. */
    final Rescue getRescue(int i) {
      result = rank[i + 1](Rescue s | s = this.getAFieldOrChild() | s order by s.getParentIndex())
    }

    /** Gets the `else` block in this block, if any. */
    final private Else getElse() { result = unique(Else s | s = this.getAFieldOrChild()) }

    /** Gets the `ensure` block in this block, if any. */
    final Ensure getEnsure() { result = unique(Ensure s | s = this.getAFieldOrChild()) }

    final private predicate hasEnsure() { exists(this.getEnsure()) }

    final override predicate propagatesAbnormal(AstNode child) { none() }

    /**
     * Gets a descendant that belongs to the `ensure` block of this block, if any.
     * Nested `ensure` blocks are not included.
     */
    AstNode getAnEnsureDescendant() {
      result = this.getEnsure()
      or
      exists(AstNode mid |
        mid = this.getAnEnsureDescendant() and
        result = getAChildInScope(mid, getCfgScope(mid)) and
        not exists(RescueEnsureBlockTree nestedBlock |
          result = nestedBlock.getEnsure() and
          nestedBlock != this
        )
      )
    }

    /**
     * Holds if `innerBlock` has an `ensure` block and is immediately nested inside the
     * `ensure` block of this block.
     */
    private predicate nestedEnsure(RescueEnsureBlockTree innerBlock) {
      exists(Ensure innerEnsure |
        innerEnsure = getAChildInScope(this.getAnEnsureDescendant(), getCfgScope(this)) and
        innerEnsure = innerBlock.getEnsure()
      )
    }

    /**
     * Gets the `ensure`-nesting level of this block. That is, the number of `ensure`
     * blocks that this block is nested under.
     */
    int nestLevel() { result = count(RescueEnsureBlockTree outer | outer.nestedEnsure+(this)) }

    /**
     * Holds if `last` is a last element in the body of this block. `ensurable`
     * indicates whether `last` may be a predecessor of an `ensure` block.
     */
    pragma[nomagic]
    private predicate lastBody(AstNode last, Completion c, boolean ensurable) {
      exists(boolean rescuable |
        if c instanceof RaiseCompletion then ensurable = rescuable else ensurable = true
      |
        last(this.getBodyChild(_, rescuable), last, c) and
        not c instanceof NormalCompletion
        or
        exists(int lst |
          last(this.getBodyChild(lst, rescuable), last, c) and
          not exists(this.getBodyChild(lst + 1, _))
        )
      )
    }

    /**
     * Gets a last element from this block that may finish with completion `c`, such
     * that control may be transferred to the `ensure` block (if it exists), but only
     * if `ensurable = true`.
     */
    pragma[nomagic]
    private AstNode getAnEnsurePredecessor(Completion c, boolean ensurable) {
      this.lastBody(result, c, ensurable) and
      (
        // Any non-throw completion will always continue directly to the `ensure` block,
        // unless there is an `else` block
        not c instanceof RaiseCompletion and
        not exists(this.getElse())
        or
        // Any completion will continue to the `ensure` block when there are no `rescue`
        // blocks
        not exists(this.getRescue(_))
      )
      or
      // Last element from any matching `rescue` block continues to the `ensure` block
      this.getRescue(_).(RescueTree).lastMatch(result, c) and
      ensurable = true
      or
      // If the last `rescue` block does not match, continue to the `ensure` block
      exists(int lst, MatchingCompletion mc |
        this.getRescue(lst).(RescueTree).lastNoMatch(result, mc) and
        mc.getValue() = false and
        not exists(this.getRescue(lst + 1)) and
        c =
          any(NestedEnsureCompletion nec |
            nec.getOuterCompletion() instanceof RaiseCompletion and
            nec.getInnerCompletion() = mc and
            nec.getNestLevel() = 0
          ) and
        ensurable = true
      )
      or
      // Last element of `else` block continues to the `ensure` block
      last(this.getElse(), result, c) and
      ensurable = true
    }

    pragma[nomagic]
    private predicate lastEnsure0(AstNode last, Completion c) { last(this.getEnsure(), last, c) }

    pragma[nomagic]
    private predicate lastEnsure(
      AstNode last, NormalCompletion ensure, Completion outer, int nestLevel
    ) {
      this.lastEnsure0(last, ensure) and
      exists(
        this.getAnEnsurePredecessor(any(Completion c0 | outer = c0.getOuterCompletion()), true)
      ) and
      nestLevel = this.nestLevel()
    }

    predicate lastInner(AstNode last, Completion c) {
      exists(boolean ensurable | last = this.getAnEnsurePredecessor(c, ensurable) |
        not this.hasEnsure()
        or
        ensurable = false
      )
      or
      // If the body completes normally, take the completion from the `ensure` block
      this.lastEnsure(last, c, any(NormalCompletion nc), _)
      or
      // If the `ensure` block completes normally, it inherits any non-normal
      // completion from the body
      c =
        any(NestedEnsureCompletion nec |
          this.lastEnsure(last, nec.getAnInnerCompatibleCompletion(), nec.getOuterCompletion(),
            nec.getNestLevel())
        )
      or
      not exists(this.getBodyChild(_, _)) and
      not exists(this.getRescue(_)) and
      this.lastEnsure0(last, c)
      or
      last([this.getEnsure(), this.getBodyChild(_, false)], last, c) and
      not c instanceof NormalCompletion
    }

    predicate firstInner(AstNode first) {
      first(this.getBodyChild(0, _), first)
      or
      not exists(this.getBodyChild(_, _)) and
      (
        first(this.getRescue(_), first)
        or
        not exists(this.getRescue(_)) and
        first(this.getEnsure(), first)
      )
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      this instanceof PreOrderTree and
      pred = this and
      c instanceof SimpleCompletion and
      this.firstInner(succ)
      or
      // Normal left-to-right evaluation in the body
      exists(int i |
        last(this.getBodyChild(i, _), pred, c) and
        first(this.getBodyChild(i + 1, _), succ) and
        c instanceof NormalCompletion
      )
      or
      // Exceptional flow from body to first `rescue`
      this.lastBody(pred, c, true) and
      first(this.getRescue(0), succ) and
      c instanceof RaiseCompletion
      or
      // Flow from one `rescue` clause to the next when there is no match
      exists(RescueTree rescue, int i | rescue = this.getRescue(i) |
        rescue.lastNoMatch(pred, c) and
        first(this.getRescue(i + 1), succ)
      )
      or
      // Flow from body to `else` block when no exception
      this.lastBody(pred, c, _) and
      first(this.getElse(), succ) and
      c instanceof NormalCompletion
      or
      // Flow into `ensure` block
      pred = getAnEnsurePredecessor(c, true) and
      first(this.getEnsure(), succ)
    }
  }

  private class RescueModifierTree extends PreOrderTree, RescueModifier {
    final override predicate propagatesAbnormal(AstNode child) { child = this.getHandler() }

    final override predicate last(AstNode last, Completion c) {
      last(this.getBody(), last, c) and
      not c instanceof RaiseCompletion
      or
      last(this.getHandler(), last, c)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      pred = this and
      first(this.getBody(), succ) and
      c instanceof SimpleCompletion
      or
      last(this.getBody(), pred, c) and
      c instanceof RaiseCompletion and
      first(this.getHandler(), succ)
    }
  }

  private class SelfTree extends LeafTree, Self { }

  private class SetterTree extends LeafTree, Setter { }

  private class SingletonClassTree extends RescueEnsureBlockTree, PreOrderTree, SingletonClass {
    final override AstNode getChildNode(int i, boolean rescuable) {
      rescuable = true and
      (
        result = this.getValue() and i = 0
        or
        result = this.getChild(i - 1)
      )
    }

    final override predicate last(AstNode last, Completion c) { this.lastInner(last, c) }
  }

  private class SingletonMethodTree extends RescueEnsureBlockTree, PostOrderTree, SingletonMethod {
    final override AstNode getChildNode(int i, boolean rescuable) {
      result = this.getParameters() and
      i = 0 and
      rescuable = false
      or
      result = this.getChild(i - 1) and
      rescuable = true
    }

    final override predicate first(AstNode first) { first(this.getObject(), first) }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      RescueEnsureBlockTree.super.succ(pred, succ, c)
      or
      last(this.getObject(), pred, c) and
      first(this.getName(), succ) and
      c instanceof NormalCompletion
      or
      last(this.getName(), pred, c) and
      succ = this and
      c instanceof NormalCompletion
    }
  }

  private class SuperTree extends LeafTree, Super { }

  private class TrueTree extends LeafTree, True { }

  private class WhenTree extends PreOrderTree, When {
    final override predicate propagatesAbnormal(AstNode child) { child = this.getPattern(_) }

    final Pattern getLastPattern() {
      exists(int i |
        result = this.getPattern(i) and
        not exists(this.getPattern(i + 1))
      )
    }

    final override predicate last(AstNode last, Completion c) {
      last(this.getLastPattern(), last, c) and
      c.(ConditionalCompletion).getValue() = false
      or
      last(this.getBody(), last, c)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      pred = this and
      first(this.getPattern(0), succ) and
      c instanceof SimpleCompletion
      or
      exists(int i, Pattern p, boolean b |
        p = this.getPattern(i) and
        last(p, pred, c) and
        b = c.(ConditionalCompletion).getValue()
      |
        b = true and
        first(this.getBody(), succ)
        or
        b = false and
        first(this.getPattern(i + 1), succ)
      )
    }
  }

  private class ConditionalLoopTree extends PostOrderTree, ConditionalLoopAstNode {
    final override predicate propagatesAbnormal(AstNode child) { child = this.getConditionNode() }

    final override predicate first(AstNode first) { first(this.getConditionNode(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(this.getConditionNode(), pred, c) and
      this.continueLoop(c) and
      first(this.getBodyNode(), succ)
      or
      last(this.getBodyNode(), pred, c) and
      first(this.getConditionNode(), succ) and
      c.continuesLoop()
      or
      last(this.getBodyNode(), pred, c) and
      first(this.getBodyNode(), succ) and
      c instanceof RedoCompletion
      or
      succ = this and
      (
        last(this.getConditionNode(), pred, c) and
        this.endLoop(c)
        or
        last(this.getBodyNode(), pred, c) and
        not c.continuesLoop() and
        not c instanceof BreakCompletion and
        not c instanceof RedoCompletion
        or
        last(this.getBodyNode(), pred, c.(NestedBreakCompletion).getAnInnerCompatibleCompletion())
      )
    }
  }
}

private Scope::Range parent(Scope::Range n) {
  result = n.getOuterScope() and
  not n instanceof CfgScope::Range_
}

cached
private module Cached {
  /** Gets the CFG scope of node `n`. */
  cached
  CfgScope getCfgScope(AstNode n) { ASTInternal::toTreeSitter(result) = parent*(scopeOf(n)) }

  private predicate isAbnormalExitType(SuccessorType t) {
    t instanceof RaiseSuccessor or t instanceof ExitSuccessor
  }

  cached
  newtype TCfgNode =
    TEntryNode(CfgScope scope) { succEntrySplits(scope, _, _, _) } or
    TAnnotatedExitNode(CfgScope scope, boolean normal) {
      exists(Reachability::SameSplitsBlock b, SuccessorType t | b.isReachable(_) |
        succExitSplits(b.getANode(), _, scope, t) and
        if isAbnormalExitType(t) then normal = false else normal = true
      )
    } or
    TExitNode(CfgScope scope) {
      exists(Reachability::SameSplitsBlock b | b.isReachable(_) |
        succExitSplits(b.getANode(), _, scope, _)
      )
    } or
    TAstCfgNode(AstNode n, Splits splits) {
      exists(Reachability::SameSplitsBlock b | b.isReachable(splits) | n = b.getANode())
    }

  cached
  newtype TSuccessorType =
    TSuccessorSuccessor() or
    TBooleanSuccessor(boolean b) { b in [false, true] } or
    TEmptinessSuccessor(boolean isEmpty) { isEmpty in [false, true] } or
    TMatchingSuccessor(boolean isMatch) { isMatch in [false, true] } or
    TReturnSuccessor() or
    TBreakSuccessor() or
    TNextSuccessor() or
    TRedoSuccessor() or
    TRetrySuccessor() or
    TRaiseSuccessor() or // TODO: Add exception type?
    TExitSuccessor()

  /** Gets a successor node of a given flow type, if any. */
  cached
  CfgNode getASuccessor(CfgNode pred, SuccessorType t) {
    exists(CfgScope scope, AstNode succElement, Splits succSplits |
      pred = TEntryNode(scope) and
      succEntrySplits(scope, succElement, succSplits, t) and
      result = TAstCfgNode(succElement, succSplits)
    )
    or
    exists(AstNode predNode, Splits predSplits | pred = TAstCfgNode(predNode, predSplits) |
      exists(CfgScope scope, boolean normal |
        succExitSplits(predNode, predSplits, scope, t) and
        (if isAbnormalExitType(t) then normal = false else normal = true) and
        result = TAnnotatedExitNode(scope, normal)
      )
      or
      exists(AstNode succElement, Splits succSplits, Completion c |
        succSplits(predNode, predSplits, succElement, succSplits, c) and
        t = c.getAMatchingSuccessorType() and
        result = TAstCfgNode(succElement, succSplits)
      )
    )
    or
    exists(CfgScope scope |
      pred = TAnnotatedExitNode(scope, _) and
      t instanceof SuccessorTypes::NormalSuccessor and
      result = TExitNode(scope)
    )
  }

  /** Gets a first control flow element executed within `n`. */
  cached
  AstNode getAControlFlowEntryNode(AstNode n) { first(n, result) }

  /** Gets a potential last control flow element executed within `n`. */
  cached
  AstNode getAControlFlowExitNode(AstNode n) { last(n, result, _) }
}

import Cached

/** An AST node that is split into multiple control flow nodes. */
class SplitAstNode extends AstNode {
  SplitAstNode() { strictcount(CfgNode n | ASTInternal::toTreeSitter(n.getNode()) = this) > 1 }
}
