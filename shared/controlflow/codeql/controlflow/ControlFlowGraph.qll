overlay[local?]
module;

private import codeql.util.Boolean
private import codeql.util.FileSystem
private import codeql.util.Location
private import SuccessorType

signature class TypSig;

signature module AstSig<LocationSig Location> {
  /** An AST node. */
  class AstNode {
    /** Gets a textual representation of this AST node. */
    string toString();

    /** Gets the location of this AST node. */
    Location getLocation();
  }

  /** Gets the child of this AST node at the specified index. */
  AstNode getChild(AstNode n, int index);

  /** Gets the immediately enclosing callable that contains this node. */
  Callable getEnclosingCallable(AstNode node);

  class Callable extends AstNode;

  /** Gets the body of this callable, if any. */
  AstNode callableGetBody(Callable c);

  /** A statement. */
  class Stmt extends AstNode;

  /** An expression. */
  class Expr extends AstNode;

  class BlockStmt extends Stmt {
    /** Gets the `n`th (zero-based) statement in this block. */
    Stmt getStmt(int n);

    Stmt getLastStmt();
  }

  class ExprStmt extends Stmt {
    /** Gets the expression in this expression statement. */
    Expr getExpr();
  }

  class IfStmt extends Stmt {
    /** Gets the condition of this if statement. */
    Expr getCondition();

    /** Gets the `then` (true) branch of this `if` statement. */
    Stmt getThen();

    /** Gets the `else` (false) branch of this `if` statement, if any. */
    Stmt getElse();
  }

  class LoopStmt extends Stmt {
    /** Gets the body of this loop statement. */
    Stmt getBody();
  }

  class WhileStmt extends LoopStmt {
    /** Gets the boolean condition of this `while` loop. */
    Expr getCondition();
  }

  class DoStmt extends LoopStmt {
    /** Gets the boolean condition of this `do-while` loop. */
    Expr getCondition();
  }

  /** A traditional C-style `for` loop. */
  class ForStmt extends LoopStmt {
    /** Gets the initializer expression of the loop at the specified (zero-based) position, if any. */
    Expr getInit(int index);

    /** Gets the boolean condition of this `for` loop. */
    Expr getCondition();

    /** Gets the update expression of this loop at the specified (zero-based) position, if any. */
    Expr getUpdate(int index);
  }

  class ForeachStmt extends LoopStmt {
    /** Gets the variable declaration of this `foreach` loop. */
    Expr getVariable();

    /** Gets the collection expression of this `foreach` loop. */
    Expr getCollection();
  }

  class BreakStmt extends Stmt;

  class ContinueStmt extends Stmt;

  class ReturnStmt extends Stmt {
    /** Gets the expression being returned, if any. */
    Expr getExpr();
  }

  class ThrowStmt extends Stmt {
    /** Gets the expression being thrown. */
    Expr getExpr();
  }

  class TryStmt extends Stmt {
    /** Gets the body of this `try` statement. */
    Stmt getBody();

    /**
     * Gets the `catch` clause at the specified (zero-based) position `index`
     * in this `try` statement.
     */
    CatchClause getCatch(int index);

    /** Gets the `finally` block of this `try` statement, if any. */
    Stmt getFinally();
  }

  /**
   * Gets the initializer of this `try` statement at the specified (zero-based)
   * position `index`, if any.
   *
   * An example of this are resource declarations in Java's try-with-resources
   * statement.
   */
  default AstNode getTryInit(TryStmt try, int index) { none() }

  /**
   * Gets the `else` block of this `try` statement, if any.
   *
   * Only some languages (e.g. Python) support `try-else` constructs.
   */
  default AstNode getTryElse(TryStmt try) { none() }

  class CatchClause extends AstNode {
    AstNode getVariable();

    Expr getCondition();

    /** Gets the body of this catch clause. */
    Stmt getBody();
  }

  class Switch extends AstNode {
    /**
     * Gets the expression being switched on.
     *
     * In some languages this is optional, in which case this predicate then
     * might not hold.
     */
    Expr getExpr();

    /** Gets the case at the specified (zero-based) `index`. */
    Case getCase(int index);
  }

  /**
   * Gets an integer indicating the control flow order of a case within a switch.
   * This is most often the same as the AST order, but can be different in some
   * languages if the language allows a default case to appear before other
   * cases.
   */
  default int getCaseControlFlowOrder(Switch s, Case c) { s.getCase(result) = c }

  class Case extends AstNode {
    /** Gets a pattern being matched by this case. */
    AstNode getAPattern();

    /** Gets the guard expression of this case, if any. */
    Expr getGuard();

    /**
     * Gets the body element of this case at the specified (zero-based) `index`.
     *
     * This is either unique when the case has a single right-hand side, or it
     * is the sequence of statements between this case and the next case.
     */
    AstNode getBodyElement(int index);
  }

  /**
   * Holds if this case can fall through to the next case if it is not
   * otherwise prevented with a `break` or similar.
   */
  default predicate fallsThrough(Case c) { none() }

  class ConditionalExpr extends Expr {
    /** Gets the condition of this expression. */
    Expr getCondition();

    /** Gets the true branch of this expression. */
    Expr getThen();

    /** Gets the false branch of this expression. */
    Expr getElse();
  }

  class BinaryExpr extends Expr {
    /** Gets the left operand of this binary expression. */
    Expr getLeftOperand();

    /** Gets the right operand of this binary expression. */
    Expr getRightOperand();
  }

  class LogicalAndExpr extends BinaryExpr;

  class LogicalOrExpr extends BinaryExpr;

  class NullCoalescingExpr extends BinaryExpr;

  class UnaryExpr extends Expr {
    /** Gets the operand of this unary expression. */
    Expr getOperand();
  }

  class LogicalNotExpr extends UnaryExpr;

  class BooleanLiteral extends Expr {
    /** Gets the boolean value of this literal. */
    boolean getValue();
  }
}

module Make0<LocationSig Location, AstSig<Location> Ast> {
  private import Ast

  signature module InputSig1 {
    /**
     * A label used for matching jump sources and targets, for example in goto
     * statements.
     */
    class Label {
      string toString();
    }

    /**
     * Holds if the node `n` has the label `l`. For example, a label in a goto
     * statement or a goto target.
     */
    default predicate hasLabel(AstNode n, Label l) { none() }

    /**
     * Holds if the value of `child` is propagated to `parent`. For example,
     * the right-hand side of short-circuiting expressions.
     */
    default predicate propagatesValue(AstNode child, AstNode parent) { none() }

    /**
     * Holds if `n` is in a conditional context of kind `kind`. For example,
     * the left-hand side of a short-circuiting `&&` expression is in a
     * boolean conditional context.
     */
    default predicate inConditionalContext(AstNode n, ConditionKind kind) { none() }

    /**
     * Holds if `n` is executed in post-order or in-order. This means that an
     * additional node is created to represent `n` in the control flow graph.
     * Otherwise, `n` is represented by the "before" node.
     */
    default predicate postOrInOrder(AstNode n) { none() }

    /**
     * Holds if an additional node tagged with `tag` should be created for
     * `n`. Edges targeting such nodes are labeled with `t` and therefore `t`
     * should be unique for a given `(n,tag)` pair.
     */
    default predicate additionalNode(AstNode n, string tag, NormalSuccessor t) { none() }

    /**
     * Holds if `t1` implies `t2`.
     *
     * For example, in JavaScript, true (truthy) implies not-null, and null implies false (falsy).
     */
    default predicate successorValueImplies(ConditionalSuccessor t1, ConditionalSuccessor t2) {
      none()
    }
  }

  module Make1<InputSig1 Input1> {
    private predicate postOrInOrder(AstNode n) {
      Input1::postOrInOrder(n)
      or
      n instanceof ReturnStmt
      or
      n instanceof ThrowStmt
      or
      n instanceof BreakStmt
      or
      n instanceof ContinueStmt
      or
      n instanceof Expr and
      exists(getChild(n, _)) and
      not n instanceof LogicalAndExpr and
      not n instanceof LogicalOrExpr and
      not n instanceof NullCoalescingExpr and
      not n instanceof LogicalNotExpr and
      not n instanceof ConditionalExpr and
      not n instanceof Switch and
      not n instanceof Case
    }

    private predicate shortCircuiting(BinaryExpr expr, ConditionalSuccessor shortcircuitValue) {
      expr instanceof LogicalAndExpr and shortcircuitValue.(BooleanSuccessor).getValue() = false
      or
      expr instanceof LogicalOrExpr and shortcircuitValue.(BooleanSuccessor).getValue() = true
      or
      expr instanceof NullCoalescingExpr and shortcircuitValue.(NullnessSuccessor).getValue() = true
    }

    /**
     * Holds if the value of `child` is propagated to `parent`. For example,
     * the right-hand side of short-circuiting expressions.
     */
    private predicate propagatesValue(AstNode child, AstNode parent) {
      Input1::propagatesValue(child, parent)
      or
      shortCircuiting(parent, _) and
      not postOrInOrder(parent) and
      parent.(BinaryExpr).getRightOperand() = child
      or
      parent.(ConditionalExpr).getThen() = child
      or
      parent.(ConditionalExpr).getElse() = child
      or
      parent.(BlockStmt).getLastStmt() = child
      or
      parent.(ExprStmt).getExpr() = child
    }

    /**
     * Holds if `n` is in a conditional context of kind `kind`. For example,
     * the left-hand side of a short-circuiting `&&` expression is in a
     * boolean conditional context.
     */
    private predicate inConditionalContext(AstNode n, ConditionKind kind) {
      Input1::inConditionalContext(n, kind)
      or
      exists(AstNode parent |
        propagatesValue(n, parent) and
        inConditionalContext(parent, kind)
      )
      or
      exists(LogicalNotExpr notexpr |
        n = notexpr.getOperand() and
        inConditionalContext(notexpr, kind) and
        kind.isBoolean()
      )
      or
      exists(BinaryExpr binexpr, ConditionalSuccessor shortcircuitValue |
        shortCircuiting(binexpr, shortcircuitValue) and
        n = binexpr.getLeftOperand() and
        kind = shortcircuitValue.getKind()
      )
      or
      kind.isBoolean() and
      (
        any(IfStmt ifstmt).getCondition() = n or
        any(WhileStmt whilestmt).getCondition() = n or
        any(DoStmt dostmt).getCondition() = n or
        any(ForStmt forstmt).getCondition() = n or
        any(ConditionalExpr condexpr).getCondition() = n or
        any(CatchClause catch).getCondition() = n or
        any(Case case).getGuard() = n
      )
      or
      any(ForeachStmt foreachstmt).getCollection() = n and kind.isEmptiness()
      or
      n instanceof CatchClause and kind.isMatching()
      or
      n instanceof Case and kind.isMatching()
    }

    /**
     * Holds if `n` is a simple leaf node in the AST that does not appear in a
     * conditional context. For such nodes, there is no need to create separate
     * "before" and "after" control flow nodes, so we merge them.
     */
    private predicate simpleLeafNode(AstNode n) {
      not exists(getChild(n, _)) and
      not postOrInOrder(n) and
      not inConditionalContext(n, _)
    }

    private string loopHeaderTag() { result = "[LoopHeader]" }

    private predicate additionalNode(AstNode n, string tag, NormalSuccessor t) {
      Input1::additionalNode(n, tag, t)
      or
      n instanceof LoopStmt and
      tag = loopHeaderTag() and
      t instanceof DirectSuccessor
    }

    /**
     * Holds if `n` cannot terminate normally. For these cases there is no
     * need to create an "after" node as that would be unreachable.
     * Furthermore, skipping these nodes improves precision slightly for
     * finally blocks, as the corresponding try blocks are otherwise generally
     * assumed to be able to terminate normally, and hence allows for
     * a normal successor from the finally block.
     */
    private predicate cannotTerminateNormally(AstNode n) {
      n instanceof BreakStmt
      or
      n instanceof ContinueStmt
      or
      n instanceof ReturnStmt
      or
      n instanceof ThrowStmt
      or
      cannotTerminateNormally(n.(BlockStmt).getLastStmt())
      or
      cannotTerminateNormally(n.(ExprStmt).getExpr())
      or
      exists(IfStmt ifstmt |
        ifstmt = n and
        cannotTerminateNormally(ifstmt.getThen()) and
        cannotTerminateNormally(ifstmt.getElse())
      )
      or
      exists(TryStmt trystmt |
        trystmt = n and
        cannotTerminateNormally(trystmt.getBody()) and
        forall(CatchClause catch | trystmt.getCatch(_) = catch |
          cannotTerminateNormally(catch.getBody())
        )
      )
    }

    /*
     * - Every AST node has "before" and "after" control flow nodes (except simple leaf nodes).
     * - CFG snippets always start at the "before" node.
     * - In case of normal termination, the final node is an "after" node.
     * - Boolean and other conditional completions are encoded in the "after" nodes.
     * - The number of "after" nodes for a given AST node depends on whether the AST
     *   node is in a conditional context.
     * - Successors are specified as simple steps between control flow nodes for
     *   NormalSuccessors, and as pairs of half-edges for AbruptSuccessors. This
     *   allows all specifications to be local.
     * - Every AST node has a unique control flow node representing it. For
     *   preorder this is the "before" node, and for inorder/postorder this is an
     *   additional node that typically sits just before "after" (but may or may
     *   not step to it, since "after" represents normal termination).
     */

    private newtype TNode =
      TBeforeNode(AstNode n) { exists(getEnclosingCallable(n)) } or
      TAstNode(AstNode n) { postOrInOrder(n) } or
      TAfterValueNode(AstNode n, ConditionalSuccessor t) { inConditionalContext(n, t.getKind()) } or
      TAfterNode(AstNode n) {
        exists(getEnclosingCallable(n)) and
        not inConditionalContext(n, _) and
        not cannotTerminateNormally(n) and
        not simpleLeafNode(n)
      } or
      TAdditionalNode(AstNode n, string tag) { additionalNode(n, tag, _) } or
      TEntryNode(Callable c) { exists(callableGetBody(c)) } or
      TAnnotatedExitNode(Callable c, Boolean normal) { exists(callableGetBody(c)) } or
      TExitNode(Callable c) { exists(callableGetBody(c)) }

    private class NodeImpl extends TNode {
      /**
       * Holds if this is the node representing the point in the control flow
       * before the execution of `n`.
       */
      predicate isBefore(AstNode n) { this = TBeforeNode(n) }

      /**
       * Holds if this is a node representing the point in the control flow
       * after the normal termination of `n`. For simple leaf nodes, this is
       * merged with the "before" node and is hence equal to it. For nodes in
       * conditional contexts, this may be one of two possible "after" nodes
       * representing the different possible values of `n`.
       */
      predicate isAfter(AstNode n) {
        this = TAfterNode(n)
        or
        this = TAfterValueNode(n, _)
        or
        this = TBeforeNode(n) and simpleLeafNode(n)
      }

      /**
       * Holds if this is the node representing the normal termination of `n`
       * with the value `t`.
       *
       * Note that `n`, and most importantly `t`, must be bound, and if this
       * predicate is used to identify the starting point of a step, then
       * `inConditionalContext(n, t.getKind())` must hold. On the other hand, if
       * this is used to identify the end point of a step, then there is no
       * such requirement - in that case `t` will be translated to the
       * appropriate `SuccessorType` for `n`.
       */
      bindingset[n, t]
      predicate isAfterValue(AstNode n, ConditionalSuccessor t) {
        this = TAfterNode(n) and exists(t)
        or
        this = TBeforeNode(n) and simpleLeafNode(n) and exists(t)
        or
        this = TAfterValueNode(n, t)
        or
        exists(ConditionalSuccessor t0 | this = TAfterValueNode(n, t0) |
          Input1::successorValueImplies(t, t0)
          or
          not Input1::successorValueImplies(t, _) and
          t.getKind() != t0.getKind()
        )
      }

      /**
       * Holds if this is the node representing the evaluation of `n` to the
       * value `true`.
       *
       * Note that if this predicate is used to identify the starting point of
       * a step, then `inConditionalContext(n, BooleanCondition())` must hold.
       * On the other hand, if this is used to identify the end point of a
       * step, then there is no such requirement.
       */
      predicate isAfterTrue(AstNode n) {
        this.isAfterValue(n, any(BooleanSuccessor b | b.getValue() = true))
      }

      /**
       * Holds if this is the node representing the evaluation of `n` to the
       * value `false`.
       *
       * Note that if this predicate is used to identify the starting point of
       * a step, then `inConditionalContext(n, BooleanCondition())` must hold.
       * On the other hand, if this is used to identify the end point of a
       * step, then there is no such requirement.
       */
      predicate isAfterFalse(AstNode n) {
        this.isAfterValue(n, any(BooleanSuccessor b | b.getValue() = false))
      }

      /**
       * Holds if this is the node representing the given AST node when `n`
       * has an in-order or post-order execution.
       */
      predicate isIn(AstNode n) { this = TAstNode(n) }

      /**
       * Holds if this is an additional control flow node with the given tag
       * for the given AST node.
       */
      predicate isAdditional(AstNode n, string tag) { this = TAdditionalNode(n, tag) }

      /**
       * Holds if this is the unique control flow node that represents the
       * given AST node.
       */
      predicate injects(AstNode n) {
        if postOrInOrder(n) then this = TAstNode(n) else this = TBeforeNode(n)
      }

      /** Gets the statement this control flow node uniquely represents, if any. */
      Stmt asStmt() { this.injects(result) }

      /** Gets the expression this control flow node uniquely represents, if any. */
      Expr asExpr() { this.injects(result) }

      /** Gets the enclosing callable of this control flow node. */
      Callable getEnclosingCallable() { result = getEnclosingCallable(this.getAstNode()) }

      /** Gets the AST node with which this control flow node is associated. */
      abstract AstNode getAstNode();

      /**
       * INTERNAL: Do not use.
       *
       * Gets a tag such that the pair `(getAstNode(), getIdTag())` uniquely
       * identifies this node.
       */
      abstract string getIdTag();

      /** Gets a textual representation of this node. */
      abstract string toString();

      /** Gets the source location for this node. */
      Location getLocation() { result = this.getAstNode().getLocation() }
    }

    final class PreControlFlowNode = NodeImpl;

    private class BeforeNode extends NodeImpl, TBeforeNode {
      private AstNode n;

      BeforeNode() { this = TBeforeNode(n) }

      override AstNode getAstNode() { result = n }

      override string getIdTag() { result = "before" }

      override string toString() {
        if postOrInOrder(n) then result = "Before " + n.toString() else result = n.toString()
      }
    }

    private class MidNode extends NodeImpl, TAstNode {
      private AstNode n;

      MidNode() { this = TAstNode(n) }

      override AstNode getAstNode() { result = n }

      override string getIdTag() { result = "ast" }

      override string toString() { result = n.toString() }
    }

    private class AfterValueNode extends NodeImpl, TAfterValueNode {
      private AstNode n;
      private ConditionalSuccessor t;

      AfterValueNode() { this = TAfterValueNode(n, t) }

      override AstNode getAstNode() { result = n }

      override string getIdTag() {
        t.getValue() = true and result = "after-true"
        or
        t.getValue() = false and result = "after-false"
      }

      override string toString() { result = "After " + n.toString() + " [" + t.toString() + "]" }
    }

    private class AfterNode extends NodeImpl, TAfterNode {
      private AstNode n;

      AfterNode() { this = TAfterNode(n) }

      override AstNode getAstNode() { result = n }

      override string getIdTag() { result = "after" }

      override string toString() { result = "After " + n.toString() }
    }

    private class AdditionalNode extends NodeImpl, TAdditionalNode {
      private AstNode n;
      private string tag;

      AdditionalNode() { this = TAdditionalNode(n, tag) }

      override AstNode getAstNode() { result = n }

      NormalSuccessor getSuccessorType() { additionalNode(n, tag, result) }

      override string getIdTag() { result = "add. " + tag }

      override string toString() { result = tag + " " + n.toString() }
    }

    final private class EntryNodeImpl extends NodeImpl, TEntryNode {
      private Callable c;

      EntryNodeImpl() { this = TEntryNode(c) }

      override Callable getEnclosingCallable() { result = c }

      override AstNode getAstNode() { result = c }

      override string getIdTag() { result = "entry" }

      override string toString() { result = "Entry" }
    }

    /** A control flow node indicating the normal or exceptional termination of a callable. */
    final private class AnnotatedExitNodeImpl extends NodeImpl, TAnnotatedExitNode {
      Callable c;
      boolean normal;

      AnnotatedExitNodeImpl() { this = TAnnotatedExitNode(c, normal) }

      override Callable getEnclosingCallable() { result = c }

      override AstNode getAstNode() { result = c }

      override string getIdTag() {
        normal = true and result = "exit-normal"
        or
        normal = false and result = "exit-exc"
      }

      override string toString() {
        normal = true and result = "Normal Exit"
        or
        normal = false and result = "Exceptional Exit"
      }
    }

    /** A control flow node indicating normal termination of a callable. */
    final private class NormalExitNodeImpl extends AnnotatedExitNodeImpl {
      NormalExitNodeImpl() { this = TAnnotatedExitNode(_, true) }
    }

    /** A control flow node indicating exceptional termination of a callable. */
    final private class ExceptionalExitNodeImpl extends AnnotatedExitNodeImpl {
      ExceptionalExitNodeImpl() { this = TAnnotatedExitNode(_, false) }
    }

    /** A control flow node indicating the termination of a callable. */
    final private class ExitNodeImpl extends NodeImpl, TExitNode {
      Callable c;

      ExitNodeImpl() { this = TExitNode(c) }

      override Callable getEnclosingCallable() { result = c }

      override AstNode getAstNode() { result = c }

      override string getIdTag() { result = "exit" }

      override string toString() { result = "Exit" }
    }

    private newtype TAbruptCompletion =
      TSimpleAbruptCompletion(AbruptSuccessor t) or
      TLabeledAbruptCompletion(JumpSuccessor t, Input1::Label l)

    /**
     * A value indicating an abrupt completion of an AST node in the control
     * flow graph. This is mostly equivalent to an AbruptSuccessor, but may
     * also carry a label to, for example, link a goto with its target.
     */
    class AbruptCompletion extends TAbruptCompletion {
      string toString() {
        exists(AbruptSuccessor t | this = TSimpleAbruptCompletion(t) and result = t.toString())
        or
        exists(AbruptSuccessor t, Input1::Label l |
          this = TLabeledAbruptCompletion(t, l) and
          result = t.toString() + " " + l.toString()
        )
      }

      AbruptSuccessor getSuccessorType() {
        this = TSimpleAbruptCompletion(result) or this = TLabeledAbruptCompletion(result, _)
      }

      AbruptSuccessor asSimpleAbruptCompletion() { this = TSimpleAbruptCompletion(result) }

      predicate hasLabel(Input1::Label l) { this = TLabeledAbruptCompletion(_, l) }
    }

    signature module InputSig2 {
      /** Holds if this catch clause catches all exceptions. */
      default predicate catchAll(CatchClause catch) { none() }

      /**
       * Holds if this case matches all possible values, for example, if it is a
       * `default` case or a match-all pattern like `Object o` or if it is the
       * final case in a switch that is known to be exhaustive.
       *
       * A match-all case can still ultimately fail to match if it has a guard.
       */
      default predicate matchAll(Case c) { none() }

      /**
       * Holds if `ast` may result in an abrupt completion `c` originating at
       * `n`. The boolean `always`  indicates whether the abrupt completion
       * always occurs or whether `n` may also terminate normally.
       */
      predicate beginAbruptCompletion(
        AstNode ast, PreControlFlowNode n, AbruptCompletion c, boolean always
      );

      /**
       * Holds if an abrupt completion `c` from within `ast` is caught with
       * flow continuing at `n`.
       */
      predicate endAbruptCompletion(AstNode ast, PreControlFlowNode n, AbruptCompletion c);

      /** Holds if there is a local non-abrupt step from `n1` to `n2`. */
      predicate step(PreControlFlowNode n1, PreControlFlowNode n2);
    }

    module Make2<InputSig2 Input2> {
      /**
       * Holds if `ast` may result in an abrupt completion `c` originating at
       * `n`. The boolean `always` indicates whether the abrupt completion
       * always occurs or whether `n` may also terminate normally.
       */
      private predicate beginAbruptCompletion(
        AstNode ast, PreControlFlowNode n, AbruptCompletion c, boolean always
      ) {
        Input2::beginAbruptCompletion(ast, n, c, always)
        or
        n.isIn(ast) and
        always = true and
        (
          ast instanceof ReturnStmt and
          c.getSuccessorType() instanceof ReturnSuccessor
          or
          ast instanceof ThrowStmt and
          c.getSuccessorType() instanceof ExceptionSuccessor
          or
          ast instanceof BreakStmt and
          c.getSuccessorType() instanceof BreakSuccessor
          or
          ast instanceof ContinueStmt and
          c.getSuccessorType() instanceof ContinueSuccessor
        ) and
        (
          not Input1::hasLabel(ast, _) and not c.hasLabel(_)
          or
          exists(Input1::Label l |
            Input1::hasLabel(ast, l) and
            c.hasLabel(l)
          )
        )
        or
        exists(TryStmt trystmt, int i, CatchClause catchclause |
          trystmt.getCatch(i) = catchclause and
          not exists(trystmt.getCatch(i + 1)) and
          ast = catchclause and
          n.isAfterValue(catchclause, any(MatchingSuccessor t | t.getValue() = false)) and
          c.getSuccessorType() instanceof ExceptionSuccessor and
          always = true
        )
      }

      /**
       * Holds if an abrupt completion `c` from within `ast` is caught with
       * flow continuing at `n`.
       */
      private predicate endAbruptCompletion(AstNode ast, PreControlFlowNode n, AbruptCompletion c) {
        Input2::endAbruptCompletion(ast, n, c)
        or
        exists(Callable callable | ast = callableGetBody(callable) |
          c.getSuccessorType() instanceof ReturnSuccessor and
          n.(NormalExitNodeImpl).getEnclosingCallable() = callable
          or
          c.getSuccessorType() instanceof ExceptionSuccessor and
          n.(ExceptionalExitNodeImpl).getEnclosingCallable() = callable
          or
          c.getSuccessorType() instanceof ExitSuccessor and
          n.(ExceptionalExitNodeImpl).getEnclosingCallable() = callable
        )
        or
        exists(LoopStmt loop | ast = loop.getBody() |
          (
            c.getSuccessorType() instanceof BreakSuccessor and
            n.isAfter(loop)
            or
            c.getSuccessorType() instanceof ContinueSuccessor and
            n.isAdditional(loop, loopHeaderTag())
          ) and
          (
            not c.hasLabel(_)
            or
            exists(Input1::Label l |
              c.hasLabel(l) and
              Input1::hasLabel(loop, l)
            )
          )
        )
        or
        exists(TryStmt trystmt |
          ast = getTryInit(trystmt, _)
          or
          ast = trystmt.getBody()
        |
          c.getSuccessorType() instanceof ExceptionSuccessor and
          (
            n.isBefore(trystmt.getCatch(0))
            or
            not exists(trystmt.getCatch(_)) and
            n.isBefore(trystmt.getFinally())
          )
          or
          (
            // Exit completions skip the finally block
            c.getSuccessorType() instanceof ReturnSuccessor or
            c.getSuccessorType() instanceof JumpSuccessor
          ) and
          n.isBefore(trystmt.getFinally())
        )
        or
        exists(TryStmt trystmt |
          ast = trystmt.getCatch(_)
          or
          ast = getTryElse(trystmt)
        |
          n.isBefore(trystmt.getFinally()) and
          not c.getSuccessorType() instanceof ExitSuccessor
        )
        or
        exists(Switch switch |
          ast = switch.getCase(_).getBodyElement(_) and
          n.isAfter(switch) and
          c.getSuccessorType() instanceof BreakSuccessor
        |
          not c.hasLabel(_)
          or
          exists(Input1::Label l |
            c.hasLabel(l) and
            Input1::hasLabel(switch, l)
          )
        )
      }

      private Case getRankedCaseCfgOrder(Switch s, int rnk) {
        result = rank[rnk](Case c, int i | getCaseControlFlowOrder(s, c) = i | c order by i)
      }

      private AstNode getFirstCaseBodyElement(Case case) {
        result = case.getBodyElement(0)
        or
        not exists(case.getBodyElement(0)) and
        exists(Switch s, int i |
          fallsThrough(case) and
          // fall-through follows AST order, not case control flow order:
          s.getCase(i) = case and
          result = getFirstCaseBodyElement(s.getCase(i + 1))
        )
      }

      private AstNode getNextCaseBodyElement(AstNode bodyElement) {
        exists(Case case, int i | case.getBodyElement(i) = bodyElement |
          result = case.getBodyElement(i + 1)
          or
          not exists(case.getBodyElement(i + 1)) and
          exists(Switch s, int j |
            fallsThrough(case) and
            // fall-through follows AST order, not case control flow order:
            s.getCase(j) = case and
            result = getFirstCaseBodyElement(s.getCase(j + 1))
          )
        )
      }

      /** Holds if there is a local non-abrupt step from `n1` to `n2`. */
      private predicate explicitStep(PreControlFlowNode n1, PreControlFlowNode n2) {
        Input2::step(n1, n2)
        or
        exists(Callable c |
          n1.(EntryNodeImpl).getEnclosingCallable() = c and
          n2.isBefore(callableGetBody(c))
          or
          n1.isAfter(callableGetBody(c)) and
          n2.(NormalExitNodeImpl).getEnclosingCallable() = c
          or
          n1.(AnnotatedExitNodeImpl).getEnclosingCallable() = c and
          n2.(ExitNodeImpl).getEnclosingCallable() = c
        )
        or
        exists(AstNode child, AstNode parent | propagatesValue(child, parent) |
          exists(ConditionalSuccessor t |
            inConditionalContext(parent, t.getKind()) and
            n1.isAfterValue(child, t) and
            n2.isAfterValue(parent, t)
          )
          or
          not inConditionalContext(parent, _) and
          n1.isAfter(child) and
          n2.isAfter(parent)
        )
        or
        exists(BinaryExpr binexpr, ConditionalSuccessor shortcircuitValue |
          shortCircuiting(binexpr, shortcircuitValue)
        |
          n1.isBefore(binexpr) and
          n2.isBefore(binexpr.getLeftOperand())
          or
          n1.isAfterValue(binexpr.getLeftOperand(), shortcircuitValue.getDual()) and
          n2.isBefore(binexpr.getRightOperand())
          or
          n1.isAfterValue(binexpr.getLeftOperand(), shortcircuitValue) and
          n2.isAfterValue(binexpr, shortcircuitValue)
          or
          // short-circuiting operations with side-effects (e.g. `x &&= y`, `x?.Prop = y`) are in post-order:
          n1.isAfter(binexpr.getRightOperand()) and
          n2.isIn(binexpr)
          or
          n1.isIn(binexpr) and
          n2.isAfter(binexpr)
        )
        or
        exists(LogicalNotExpr notexpr |
          n1.isBefore(notexpr) and
          n2.isBefore(notexpr.getOperand())
          or
          exists(BooleanSuccessor t |
            n1.isAfterValue(notexpr.getOperand(), t) and
            n2.isAfterValue(notexpr, t.getDual())
          )
        )
        or
        exists(ConditionalExpr condexpr |
          n1.isBefore(condexpr) and
          n2.isBefore(condexpr.getCondition())
          or
          n1.isAfterTrue(condexpr.getCondition()) and
          n2.isBefore(condexpr.getThen())
          or
          n1.isAfterFalse(condexpr.getCondition()) and
          n2.isBefore(condexpr.getElse())
        )
        or
        exists(BooleanLiteral boollit |
          inConditionalContext(boollit, _) and
          n1.isBefore(boollit) and
          n2.isAfterValue(boollit, any(BooleanSuccessor t | t.getValue() = boollit.getValue()))
        )
        or
        exists(ExprStmt exprstmt |
          n1.isBefore(exprstmt) and
          n2.isBefore(exprstmt.getExpr())
          // the `isAfter(exprstmt.getExpr())` to `isAfter(exprstmt)` case is handled by `propagatesValue` above.
        )
        or
        exists(BlockStmt blockstmt |
          n1.isBefore(blockstmt) and
          n2.isBefore(blockstmt.getStmt(0))
          or
          not exists(blockstmt.getStmt(_)) and
          n1.isBefore(blockstmt) and
          n2.isAfter(blockstmt) and
          not simpleLeafNode(blockstmt)
          or
          exists(int i |
            n1.isAfter(blockstmt.getStmt(i)) and
            n2.isBefore(blockstmt.getStmt(i + 1))
          )
          // the `isAfter(blockstmt.getLastStmt())` to `isAfter(blockstmt)` case is handled by `propagatesValue` above.
        )
        or
        exists(IfStmt ifstmt |
          n1.isBefore(ifstmt) and
          n2.isBefore(ifstmt.getCondition())
          or
          n1.isAfterTrue(ifstmt.getCondition()) and
          n2.isBefore(ifstmt.getThen())
          or
          n1.isAfterFalse(ifstmt.getCondition()) and
          (
            n2.isBefore(ifstmt.getElse())
            or
            not exists(ifstmt.getElse()) and
            n2.isAfter(ifstmt)
          )
          or
          n1.isAfter(ifstmt.getThen()) and
          n2.isAfter(ifstmt)
          or
          n1.isAfter(ifstmt.getElse()) and
          n2.isAfter(ifstmt)
        )
        or
        exists(WhileStmt whilestmt |
          n1.isBefore(whilestmt) and
          n2.isAdditional(whilestmt, loopHeaderTag())
        )
        or
        exists(DoStmt dostmt |
          n1.isBefore(dostmt) and
          n2.isBefore(dostmt.getBody())
        )
        or
        exists(LoopStmt loopstmt, AstNode cond |
          loopstmt.(WhileStmt).getCondition() = cond or loopstmt.(DoStmt).getCondition() = cond
        |
          n1.isAdditional(loopstmt, loopHeaderTag()) and
          n2.isBefore(cond)
          or
          n1.isAfterTrue(cond) and
          n2.isBefore(loopstmt.getBody())
          or
          n1.isAfterFalse(cond) and
          n2.isAfter(loopstmt)
          or
          n1.isAfter(loopstmt.getBody()) and
          n2.isAdditional(loopstmt, loopHeaderTag())
        )
        or
        exists(ForeachStmt foreachstmt |
          n1.isBefore(foreachstmt) and
          n2.isBefore(foreachstmt.getCollection())
          or
          n1.isAfterValue(foreachstmt.getCollection(),
            any(EmptinessSuccessor t | t.getValue() = true)) and
          n2.isAfter(foreachstmt)
          or
          n1.isAfterValue(foreachstmt.getCollection(),
            any(EmptinessSuccessor t | t.getValue() = false)) and
          n2.isBefore(foreachstmt.getVariable())
          or
          n1.isAfter(foreachstmt.getVariable()) and
          n2.isBefore(foreachstmt.getBody())
          or
          n1.isAfter(foreachstmt.getBody()) and
          n2.isAdditional(foreachstmt, loopHeaderTag())
          or
          n1.isAdditional(foreachstmt, loopHeaderTag()) and
          n2.isAfter(foreachstmt)
          or
          n1.isAdditional(foreachstmt, loopHeaderTag()) and
          n2.isBefore(foreachstmt.getVariable())
        )
        or
        exists(ForStmt forstmt, PreControlFlowNode condentry |
          // Any part of the control flow that aims for the condition needs to hit either the condition...
          condentry.isBefore(forstmt.getCondition())
          or
          // ...or the body if the for doesn't include a condition.
          not exists(forstmt.getCondition()) and condentry.isBefore(forstmt.getBody())
        |
          n1.isBefore(forstmt) and
          (
            n2.isBefore(forstmt.getInit(0))
            or
            not exists(forstmt.getInit(_)) and n2 = condentry
          )
          or
          exists(int i | n1.isAfter(forstmt.getInit(i)) |
            n2.isBefore(forstmt.getInit(i + 1))
            or
            not exists(forstmt.getInit(i + 1)) and n2 = condentry
          )
          or
          n1.isAfterTrue(forstmt.getCondition()) and
          n2.isBefore(forstmt.getBody())
          or
          n1.isAfterFalse(forstmt.getCondition()) and
          n2.isAfter(forstmt)
          or
          n1.isAfter(forstmt.getBody()) and
          n2.isAdditional(forstmt, loopHeaderTag())
          or
          n1.isAdditional(forstmt, loopHeaderTag()) and
          (
            n2.isBefore(forstmt.getUpdate(0))
            or
            not exists(forstmt.getUpdate(_)) and n2 = condentry
          )
          or
          exists(int i | n1.isAfter(forstmt.getUpdate(i)) |
            n2.isBefore(forstmt.getUpdate(i + 1))
            or
            not exists(forstmt.getUpdate(i + 1)) and n2 = condentry
          )
        )
        or
        exists(TryStmt trystmt |
          n1.isBefore(trystmt) and
          (
            n2.isBefore(getTryInit(trystmt, 0))
            or
            not exists(getTryInit(trystmt, _)) and n2.isBefore(trystmt.getBody())
          )
          or
          exists(int i | n1.isAfter(getTryInit(trystmt, i)) |
            n2.isBefore(getTryInit(trystmt, i + 1))
            or
            not exists(getTryInit(trystmt, i + 1)) and n2.isBefore(trystmt.getBody())
          )
          or
          exists(PreControlFlowNode beforeElse, PreControlFlowNode beforeFinally |
            (
              beforeElse.isBefore(getTryElse(trystmt))
              or
              not exists(getTryElse(trystmt)) and beforeElse = beforeFinally
            ) and
            (
              beforeFinally.isBefore(trystmt.getFinally())
              or
              not exists(trystmt.getFinally()) and beforeFinally.isAfter(trystmt)
            )
          |
            n1.isAfter(trystmt.getBody()) and
            n2 = beforeElse
            or
            n1.isAfter(getTryElse(trystmt)) and
            n2 = beforeFinally
            or
            n1.isAfter(trystmt.getCatch(_).getBody()) and
            n2 = beforeFinally
          )
          or
          n1.isAfter(trystmt.getFinally()) and
          n2.isAfter(trystmt)
          or
          exists(int i |
            n1.isAfterValue(trystmt.getCatch(i), any(MatchingSuccessor t | t.getValue() = false)) and
            n2.isBefore(trystmt.getCatch(i + 1))
          )
        )
        or
        exists(CatchClause catchclause |
          exists(MatchingSuccessor t |
            n1.isBefore(catchclause) and
            n2.isAfterValue(catchclause, t) and
            if Input2::catchAll(catchclause) then t.getValue() = true else any()
          )
          or
          exists(PreControlFlowNode beforeVar, PreControlFlowNode beforeCond |
            (
              beforeVar.isBefore(catchclause.getVariable())
              or
              not exists(catchclause.getVariable()) and beforeVar = beforeCond
            ) and
            (
              beforeCond.isBefore(catchclause.getCondition())
              or
              not exists(catchclause.getCondition()) and beforeCond.isBefore(catchclause.getBody())
            )
          |
            n1.isAfterValue(catchclause, any(MatchingSuccessor t | t.getValue() = true)) and
            n2 = beforeVar
            or
            n1.isAfter(catchclause.getVariable()) and
            n2 = beforeCond
          )
          or
          n1.isAfterTrue(catchclause.getCondition()) and
          n2.isBefore(catchclause.getBody())
          or
          n1.isAfterFalse(catchclause.getCondition()) and
          n2.isAfterValue(catchclause, any(MatchingSuccessor t | t.getValue() = false))
        )
        or
        exists(Switch switch |
          n1.isBefore(switch) and
          n2.isBefore(switch.getExpr())
          or
          n1.isBefore(switch) and
          not exists(switch.getExpr()) and
          n2.isBefore(getRankedCaseCfgOrder(switch, 1))
          or
          n1.isAfter(switch.getExpr()) and
          n2.isBefore(getRankedCaseCfgOrder(switch, 1))
          or
          exists(int i |
            n1.isAfterValue(getRankedCaseCfgOrder(switch, i),
              any(MatchingSuccessor t | t.getValue() = false))
          |
            n2.isBefore(getRankedCaseCfgOrder(switch, i + 1))
            or
            not exists(getRankedCaseCfgOrder(switch, i + 1)) and
            n2.isAfter(switch)
          )
        )
        or
        exists(Case case |
          exists(MatchingSuccessor t |
            n1.isBefore(case) and
            n2.isAfterValue(case, t) and
            if Input2::matchAll(case) then t.getValue() = true else any()
          )
          or
          exists(
            PreControlFlowNode beforePattern, PreControlFlowNode beforeGuard,
            PreControlFlowNode beforeBody
          |
            (
              beforePattern.isBefore(case.getAPattern())
              or
              not exists(case.getAPattern()) and beforePattern = beforeGuard
            ) and
            (
              beforeGuard.isBefore(case.getGuard())
              or
              not exists(case.getGuard()) and beforeGuard = beforeBody
            ) and
            (
              beforeBody.isBefore(getFirstCaseBodyElement(case))
              or
              not exists(getFirstCaseBodyElement(case)) and
              beforeBody.isAfter(any(Switch s | s.getCase(_) = case))
            )
          |
            n1.isAfterValue(case, any(MatchingSuccessor t | t.getValue() = true)) and
            n2 = beforePattern
            or
            n1.isAfter(case.getAPattern()) and
            n2 = beforeGuard
            or
            n1.isAfterTrue(case.getGuard()) and
            n2 = beforeBody
            or
            n1.isAfterFalse(case.getGuard()) and
            n2.isAfterValue(case, any(MatchingSuccessor t | t.getValue() = false))
          )
        )
        or
        exists(AstNode caseBodyElement |
          n1.isAfter(caseBodyElement) and
          n2.isBefore(getNextCaseBodyElement(caseBodyElement))
          or
          n1.isAfter(caseBodyElement) and
          not exists(getNextCaseBodyElement(caseBodyElement)) and
          n2.isAfter(any(Switch s | s.getCase(_).getBodyElement(_) = caseBodyElement))
        )
      }

      /**
       * Holds if `ast` does not have explicitly defined control flow steps
       * and therefore should use default left-to-right evaluation.
       */
      private predicate defaultCfg(AstNode ast) {
        not explicitStep(any(PreControlFlowNode n | n.isBefore(ast)), _)
      }

      private AstNode getRankedChild(AstNode parent, int rnk) {
        defaultCfg(parent) and
        result = rank[rnk](AstNode c, int ix | c = getChild(parent, ix) | c order by ix)
      }

      /**
       * Holds if `n1` to `n2` is a default left-to-right evaluation step for
       * an `AstNode` that does not otherwise have explicitly defined control
       * flow.
       */
      private predicate defaultStep(PreControlFlowNode n1, PreControlFlowNode n2) {
        exists(AstNode ast | defaultCfg(ast) |
          n1.isBefore(ast) and
          n2.isBefore(getRankedChild(ast, 1))
          or
          exists(int i |
            n1.isAfter(getRankedChild(ast, i)) and
            n2.isBefore(getRankedChild(ast, i + 1))
          )
          or
          (
            n1.isBefore(ast) and not exists(getRankedChild(ast, _)) and not simpleLeafNode(ast)
            or
            exists(int i |
              n1.isAfter(getRankedChild(ast, i)) and not exists(getRankedChild(ast, i + 1))
            )
          ) and
          (if postOrInOrder(ast) then n2.isIn(ast) else n2.isAfter(ast))
          or
          n1.isIn(ast) and
          n2.isAfter(ast) and
          not beginAbruptCompletion(ast, n1, _, true)
        )
      }

      /** Holds if there is a local non-abrupt step from `n1` to `n2`. */
      private predicate step(PreControlFlowNode n1, PreControlFlowNode n2) {
        explicitStep(n1, n2) or defaultStep(n1, n2)
      }

      /**
       * Holds if the execution of `ast` may result in an abrupt completion
       * `c` originating at `last`.
       */
      private predicate last(AstNode ast, PreControlFlowNode last, AbruptCompletion c) {
        // Require a predecessor as a coarse approximation of reachability.
        // In particular, this prevents a catch-all catch clause preceding a
        // finally block from adding exception edges out of the finally.
        step(_, last) and
        beginAbruptCompletion(ast, last, c, _)
        or
        exists(AstNode child |
          getChild(ast, _) = child and
          last(child, last, c) and
          not endAbruptCompletion(child, _, c)
        )
        or
        exists(
          AstNode inner, TryStmt try, Stmt finally, PreControlFlowNode finallyEntry,
          PreControlFlowNode finallyExit
        |
          try.getFinally() = finally and
          ast = finally and
          finallyEntry.isBefore(finally) and
          finallyExit.isAfter(finally) and
          endAbruptCompletion(inner, finallyEntry, c) and
          last(inner, _, c) and
          last = finallyExit
        )
      }

      private predicate succ(PreControlFlowNode n1, PreControlFlowNode n2, SuccessorType t) {
        step(n1, n2) and n2 = TAfterValueNode(_, t)
        or
        step(n1, n2) and n2.(AdditionalNode).getSuccessorType() = t
        or
        step(n1, n2) and
        not n2 instanceof AfterValueNode and
        not n2 instanceof AdditionalNode and
        t instanceof DirectSuccessor
        or
        exists(AstNode ast, AbruptCompletion c |
          last(ast, n1, c) and endAbruptCompletion(ast, n2, c) and t = c.getSuccessorType()
        )
      }

      /** Holds if `n` is reachable from an entry node. */
      private predicate reachable(PreControlFlowNode n) {
        n instanceof EntryNodeImpl
        or
        exists(PreControlFlowNode mid | reachable(mid) and succ(mid, n, _))
      }

      /**
       * A node in the control flow graph. This is restricted to nodes that
       * are reachable from an entry node.
       */
      final class ControlFlowNode extends PreControlFlowNode {
        ControlFlowNode() { reachable(this) }

        /** Gets the basic block containing this control flow node. */
        BasicBlock getBasicBlock() { result.getANode() = this }

        /** Gets an immediate successor of a given type, if any. */
        ControlFlowNode getASuccessor(SuccessorType t) { succ(this, result, t) }

        /** Gets an immediate successor of this node. */
        ControlFlowNode getASuccessor() { result = this.getASuccessor(_) }

        /** Gets an immediate predecessor of this node. */
        ControlFlowNode getAPredecessor() { result.getASuccessor() = this }

        /**
         * Gets a normal successor of this node, if any. This includes direct
         * successors and conditional successors.
         */
        ControlFlowNode getANormalSuccessor() {
          result = this.getASuccessor(any(NormalSuccessor t))
        }

        /** Gets an exception successor of this node, if any. */
        ControlFlowNode getAnExceptionSuccessor() {
          result = this.getASuccessor(any(ExceptionSuccessor t))
        }
      }

      /** The control flow node at the entry point of a callable. */
      final class EntryNode extends ControlFlowNode, EntryNodeImpl { }

      /** A control flow node indicating the normal or exceptional termination of a callable. */
      final class AnnotatedExitNode extends ControlFlowNode, AnnotatedExitNodeImpl { }

      /** A control flow node indicating normal termination of a callable. */
      final class NormalExitNode extends AnnotatedExitNode, NormalExitNodeImpl { }

      /** A control flow node indicating exceptional termination of a callable. */
      final class ExceptionalExitNode extends AnnotatedExitNode, ExceptionalExitNodeImpl { }

      /** A control flow node indicating the termination of a callable. */
      final class ExitNode extends ControlFlowNode, ExitNodeImpl { }

      private import codeql.controlflow.BasicBlock as BB

      private module BbInput implements BB::InputSig<Location> {
        predicate successorTypeIsCondition(SuccessorType t) { none() }

        class CfgScope = Ast::Callable;

        class Node = ControlFlowNode;

        CfgScope nodeGetCfgScope(Node node) { node.getEnclosingCallable() = result }

        Node nodeGetASuccessor(Node node, SuccessorType t) { result = node.getASuccessor(t) }

        predicate nodeIsDominanceEntry(Node node) { node instanceof EntryNode }

        predicate nodeIsPostDominanceExit(Node node) { node instanceof NormalExitNode }
      }

      import CfgAlias

      private module CfgAlias = Cfg;

      module Cfg = BB::Make<Location, BbInput>;

      /*
       * CFG printing
       */

      private import PrintGraph as Pp

      private class ControlFlowNodeAlias = ControlFlowNode;

      private module PrintGraphInput implements Pp::InputSig<Location> {
        class Callable = Ast::Callable;

        class ControlFlowNode = ControlFlowNodeAlias;

        ControlFlowNode getASuccessor(ControlFlowNode n, SuccessorType t) {
          result = n.getASuccessor(t)
        }
      }

      import Pp::PrintGraph<Location, PrintGraphInput>

      /*
       * Consistency checks
       *
       * - there should be no dead ends except at ExitNodes
       * - inConditionalContext(n, kind) kind must be unique for n
       * - flow must preserve getEnclosingCallable
       * - additionalNode(AstNode n, string tag, NormalSuccessor t) should have a unique t for (n, tag)
       * - if "before" is reachable and node is post-or-in-order, then "in" must generally be reachable
       */

      /** Provides a set of consistency queries. */
      module Consistency {
        /** Holds if `node` is lacking a successor. */
        query predicate deadEnd(ControlFlowNode node) {
          not node instanceof ExitNode and
          not exists(node.getASuccessor(_))
        }

        query predicate nonUniqueInConditionalContext(AstNode n) {
          1 < strictcount(ConditionKind kind | inConditionalContext(n, kind))
        }

        query predicate nonLocalStep(ControlFlowNode n1, SuccessorType t, ControlFlowNode n2) {
          n1.getASuccessor(t) = n2 and
          n1.getEnclosingCallable() != n2.getEnclosingCallable()
        }

        query predicate ambiguousAdditionalNode(AstNode n, string tag) {
          1 < strictcount(NormalSuccessor t | additionalNode(n, tag, t))
        }

        query predicate missingInNodeForPostOrInOrder(AstNode ast) {
          postOrInOrder(ast) and
          exists(ControlFlowNode before | before.isBefore(ast)) and
          not exists(ControlFlowNode mid | mid.isIn(ast)) and
          // A non-terminating child could prevent reaching the "in" node, and that's fine:
          not exists(AstNode child |
            getChild(ast, _) = child and
            exists(ControlFlowNode beforeChild | beforeChild.isBefore(child)) and
            not exists(ControlFlowNode afterChild | afterChild.isAfter(child))
          )
        }

        /** Holds if `node` has multiple successors of the same type `t`. */
        query predicate multipleSuccessors(
          ControlFlowNode node, SuccessorType t, ControlFlowNode successor
        ) {
          strictcount(node.getASuccessor(t)) > 1 and
          successor = node.getASuccessor(t) and
          // allow for loop headers in foreach loops (they're checking emptiness on the iterator, not the collection)
          not (
            t instanceof DirectSuccessor and
            node.isAdditional(any(ForeachStmt foreach), loopHeaderTag())
          ) and
          // allow for functions with multiple bodies
          not (t instanceof DirectSuccessor and node instanceof EntryNode)
        }

        /** Holds if `node` has conditional successors of different kinds. */
        query predicate multipleConditionalSuccessorKinds(
          ControlFlowNode node, ConditionalSuccessor t1, ConditionalSuccessor t2,
          ControlFlowNode succ1, ControlFlowNode succ2
        ) {
          t1.getKind() != t2.getKind() and
          succ1 = node.getASuccessor(t1) and
          succ2 = node.getASuccessor(t2)
        }

        /** Holds if `node` has both a direct and a conditional successor type. */
        query predicate directAndConditionalSuccessors(
          ControlFlowNode node, ConditionalSuccessor t1, DirectSuccessor t2, ControlFlowNode succ1,
          ControlFlowNode succ2
        ) {
          succ1 = node.getASuccessor(t1) and
          succ2 = node.getASuccessor(t2)
        }
      }
    }
  }
}
