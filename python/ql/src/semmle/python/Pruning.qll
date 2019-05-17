
private import AST
private import Exprs
private import Stmts
private import Import
private import Operations

module Pruner {

    /** A control flow node before pruning */
    class UnprunedCfgNode extends @py_flow_node {

        string toString() { none() }

        /** Gets a predecessor of this flow node */
        UnprunedCfgNode getAPredecessor() {
            py_successors(result, this)
        }

        /** Gets a successor of this flow node */
        UnprunedCfgNode getASuccessor() {
            py_successors(this, result)
        }

        /** Gets the immediate dominator of this flow node */
        UnprunedCfgNode getImmediateDominator() {
            py_idoms(this, result)
        }

        /* Holds if this CFG node is a branch */
        predicate isBranch() {
            py_true_successors(this, _) or py_false_successors(this, _)
        }

        /** Gets the syntactic element corresponding to this flow node */
        AstNode getNode() {
            py_flow_bb_node(this, result, _, _)
        }

        UnprunedBasicBlock getBasicBlock() {
            py_flow_bb_node(this, _, result, _)
        }

        /** Gets a successor for this node if the relevant condition is True. */
        UnprunedCfgNode getATrueSuccessor() {
            py_true_successors(this, result)
        }

        /** Gets a successor for this node if the relevant condition is False. */
        UnprunedCfgNode getAFalseSuccessor() {
            py_false_successors(this, result)
        }

    }

    /** A control flow node corresponding to a comparison operation, such as `x<y` */
    class UnprunedCompareNode extends UnprunedCfgNode {

        UnprunedCompareNode() {
            py_flow_bb_node(this, any(Compare c), _, _)
        }

        /** Whether left and right are a pair of operands for this comparison */
        predicate operands(UnprunedCfgNode left, Cmpop op, UnprunedCfgNode right) {
            exists(Compare c, Expr eleft, Expr eright |
                this.getNode() = c and left.getNode() = eleft and right.getNode() = eright  |
                eleft = c.getLeft() and eright = c.getComparator(0) and op = c.getOp(0)
                or
                exists(int i | eleft = c.getComparator(i-1) and eright = c.getComparator(i) and op = c.getOp(i))
            ) and
            left.getBasicBlock().dominates(this.getBasicBlock()) and
            right.getBasicBlock().dominates(this.getBasicBlock())
        }

    }

    /** A control flow node corresponding to a unary not expression: (`not x`) */
    class UnprunedNot extends UnprunedCfgNode {
        UnprunedNot() {
            exists(UnaryExpr unary |
                py_flow_bb_node(this, unary, _, _) and
                unary.getOp() instanceof Not
            )
        }

        /** Gets the control flow node corresponding to the operand of this `not` expression */
        UnprunedCfgNode getOperand() {
            exists(UnaryExpr u | this.getNode() = u and result.getNode() = u.getOperand()) and
            result.getBasicBlock().dominates(this.getBasicBlock())
        }

    }

    /** A basic block before pruning */
    class UnprunedBasicBlock extends @py_flow_node {

        UnprunedBasicBlock() {
            py_flow_bb_node(_, _, this, _)
        }

        /** Whether this basic block contains the specified node */
        predicate contains(UnprunedCfgNode node) {
            py_flow_bb_node(node, _, this, _)
        }

        string toString() { none() }

        /** Whether this basic block strictly dominates the other */
        pragma[nomagic] predicate strictlyDominates(UnprunedBasicBlock other) {
            other.getImmediateDominator+() = this
        }

        /** Whether this basic block dominates the other */
        pragma[nomagic] predicate dominates(UnprunedBasicBlock other) {
            this = other
            or
            this.strictlyDominates(other)
        }

        UnprunedBasicBlock getImmediateDominator() {
            this.first().getImmediateDominator().getBasicBlock() = result
        }

        UnprunedBasicBlock getASuccessor() {
            this.last().getASuccessor() = result.first()
        }

        UnprunedCfgNode first() {
            py_flow_bb_node(result, _, this, 0)
        }

        UnprunedCfgNode last() {
            py_flow_bb_node(result, _, this, max(int i | py_flow_bb_node(_, _, this, i)))
        }

        /** Gets a successor for this node if the relevant condition is True. */
        UnprunedBasicBlock getATrueSuccessor() {
            this.last().getATrueSuccessor() = result.first()
        }

        /** Gets a successor for this node if the relevant condition is False. */
        UnprunedBasicBlock getAFalseSuccessor() {
            this.last().getAFalseSuccessor() = result.first()
        }

        /** Whether this BB is the first in its scope */
        predicate isEntry() {
            py_scope_flow(this.first(), _, -1)
        }

        UnprunedCfgNode getANode() {
            py_flow_bb_node(result, _, this, _)
        }
    }

    private import Comparisons
    private import SSA

    newtype TConstraint =
        TTruthy(boolean b) { b = true or b = false }
        or
        TIsNone(boolean b) { b = true or b = false }
        or
        TConstrainedByConstant(CompareOp op, int k) {
            exists(Compare comp, Cmpop cop, IntegerLiteral l |
                comp.compares(_, cop, l) and
                l.getValue() = k and
                op.forOp(cop)
            )
            or
            exists(Assign a | a.getValue().(IntegerLiteral).getValue() = k) and op = eq()
        }

    /** A constraint that may be applied to an SSA variable.
     * Used for computing unreachable edges
     */
    abstract class Constraint extends TConstraint {

        abstract string toString();

        abstract Constraint invert();

        /** Holds if this constraint constrains the "truthiness" of the variable.
         * That is, for a variable `var` constrainted by this constraint
         * `bool(var) is value`
         */
        abstract predicate constrainsVariableToBe(boolean value);

        /** Holds if this constraint implies that `other` cannot hold for the
         * same variable.
         * For example `x > 0` implies that `not bool(x)` is `False`.
         */
        abstract predicate impliesFalse(Constraint other);

    }

    /** A basic block ending in a test (and branch). */
    class UnprunedConditionBlock extends UnprunedBasicBlock {

        UnprunedConditionBlock() { this.last().isBranch() }

        /** Holds if `controlled` is only reachable if the test in this block evaluates to `testIsTrue` */
        predicate controls(UnprunedBasicBlock controlled, boolean testIsTrue) {
            /* For this block to control the block 'controlled' with 'testIsTrue' the following must be true:
               Execution must have passed through the test i.e. 'this' must strictly dominate 'controlled'.
               Execution must have passed through the 'testIsTrue' edge leaving 'this'.

               Although "passed through the true edge" implies that this.getATrueSuccessor() dominates 'controlled',
               the reverse is not true, as flow may have passed through another edge to get to this.getATrueSuccessor()
               so we need to assert that this.getATrueSuccessor() dominates 'controlled' *and* that
               all predecessors of this.getATrueSuccessor() are either this or dominated by this.getATrueSuccessor().

               For example, in the following python snippet:
               <code>
                  if x:
                      controlled
                  false_successor
                  uncontrolled
               </code>
               false_successor dominates uncontrolled, but not all of its predecessors are this (if x)
               or dominated by itself. Whereas in the following code:
               <code>
                  if x:
                      while controlled:
                          also_controlled
                  false_successor
                  uncontrolled
               </code>
               the block 'while controlled' is controlled because all of its predecessors are this (if x)
               or (in the case of 'also_controlled') dominated by itself.

               The additional constraint on the predecessors of the test successor implies
               that `this` strictly dominates `controlled` so that isn't necessary to check
               directly.
            */
            exists(UnprunedBasicBlock succ |
                testIsTrue = true and succ = this.getATrueSuccessor()
                or
                testIsTrue = false and succ = this.getAFalseSuccessor()
                |
                succ.dominates(controlled) and
                forall(UnprunedBasicBlock pred | pred.getASuccessor() = succ |
                    pred = this or succ.dominates(pred)
                )
            )
        }

        /** Holds if the edge `pred->succ` is reachable only if the test in this block evaluates to `testIsTrue` */
        predicate controlsEdge(UnprunedBasicBlock pred, UnprunedBasicBlock succ, boolean testIsTrue) {
            this.controls(pred, testIsTrue) and succ = pred.getASuccessor()
            or
            pred = this and (
                testIsTrue = true and succ = this.getATrueSuccessor()
                or
                testIsTrue = false and succ = this.getAFalseSuccessor()
            )
        }

    }

    /** A constraint that the variable is truthy `bool(var) is True` or falsey `bool(var) is False` */
    class Truthy extends Constraint, TTruthy {

        private boolean booleanValue() {
            this = TTruthy(result)
        }

        override string toString() {
            result = "Truthy" and this.booleanValue() = true
            or
            result = "Falsey" and this.booleanValue() = false
        }

        override Constraint invert() {
            result = TTruthy(this.booleanValue().booleanNot())
        }

        override predicate constrainsVariableToBe(boolean value) {
            value = this.booleanValue()
        }

        override predicate impliesFalse(Constraint other) {
            other.constrainsVariableToBe(this.booleanValue().booleanNot())
        }

    }

    /** A constraint that the variable is None `(var is None) is True` or not None `(var is None) is False` */
    class IsNone extends Constraint, TIsNone {

        private boolean isNone() {
            this = TIsNone(result)
        }

        override string toString() {
            result = "Is None" and this.isNone() = true
            or
            result = "Is not None" and this.isNone() = false
        }

        override Constraint invert() {
            result = TIsNone(this.isNone().booleanNot())
        }

        override predicate constrainsVariableToBe(boolean value) {
            value = false and this.isNone() = true
        }

        override predicate impliesFalse(Constraint other) {
            other = TIsNone(this.isNone().booleanNot())
            or
            this.isNone() = true and other = TTruthy(true)
        }

    }

    /** A constraint that the variable fulfils some equality or inequality to an integral constant.
     * `(var op k) is True` where `op` is an equality or inequality operator and `k` is an integer constant
     */
    class ConstrainedByConstant extends Constraint, TConstrainedByConstant {

        private int intValue() {
            this = TConstrainedByConstant(_, result)
        }

        private CompareOp getOp() {
            this = TConstrainedByConstant(result, _)
        }

        override string toString() {
            result = this.getOp().repr() + " " + this.intValue().toString()
        }

        override Constraint invert() {
            result = TConstrainedByConstant(this.getOp().invert(), this.intValue())
        }

        override predicate constrainsVariableToBe(boolean value) {
            this.getOp() = eq() and this.intValue() = 0 and value = false
            or
            value = true and (
                this.getOp() = eq() and this.intValue() != 0
                or
                this.getOp() = ne() and this.intValue() = 0
                or
                this.getOp() = lt() and this.intValue() <= 0
                or
                this.getOp() = le() and this.intValue() < 0
                or
                this.getOp() = gt() and this.intValue() >= 0
                or
                this.getOp() = ge() and this.intValue() > 0
            )
        }

        override predicate impliesFalse(Constraint other) {
            exists(boolean b |
                this.constrainsVariableToBe(b) and other = TTruthy(b.booleanNot())
            )
            or
            this.getOp() = eq() and other = TIsNone(true)
            or
            this.getOp() = ne() and other.(ConstrainedByConstant).getOp() = eq()
            and this.intValue() = other.(ConstrainedByConstant).intValue()
        }

        /** The minimum value that a variable fulfilling this constraint may hold
         * within the bounds of a signed 32 bit number.
         */
        int minValue() {
            this.getOp() = eq() and result = this.intValue()
            or
            this.getOp() = lt() and result = -2147483648
            or
            this.getOp() = le() and result = -2147483648
            or
            this.getOp() = gt() and result = this.intValue()+1
            or
            this.getOp() = ge() and result = this.intValue()
        }

        /** The maximum value that a variable fulfilling this constraint may hold
         * within the bounds of a signed 32 bit number.
         */
        int maxValue() {
            this.getOp() = eq() and result = this.intValue()
            or
            this.getOp() = gt() and result = 2147483647
            or
            this.getOp() = ge() and result = 2147483647
            or
            this.getOp() = lt() and result = this.intValue()-1
            or
            this.getOp() = le() and result = this.intValue()
        }

    }

    /** Holds if the control flow node `n` is unreachable due to
     * one or more constraints.
     */
    predicate unreachable(UnprunedCfgNode n) {
        exists(UnprunedBasicBlock bb |
            unreachableBB(bb) and bb.contains(n)
        )
    }

    /** Holds if the basic block `bb` is unreachable due to
     * one or more constraints.
     */
    predicate unreachableBB(UnprunedBasicBlock bb) {
        not bb.isEntry() and
        forall(UnprunedBasicBlock pred |
            pred.getASuccessor() = bb
            |
            unreachableEdge(pred, bb)
        )
    }

    private Constraint constraintFromTest(SsaVariable var, UnprunedCfgNode node) {
        py_ssa_use(node, var) and result = TTruthy(true)
        or
        exists(boolean b |
            none_test(node, var, b) and result = TIsNone(b)
        )
        or
        exists(CompareOp op, int k |
            int_test(node, var, op, k) and
            result = TConstrainedByConstant(op, k)
        )
        or
        result = constraintFromTest(var, node.(UnprunedNot).getOperand()).invert()
    }

    predicate none_test(UnprunedCompareNode test, SsaVariable var, boolean is) {
        exists(UnprunedCfgNode left, Cmpop op, UnprunedCfgNode right |
            py_ssa_use(left, var) and
            test.operands(left, op, right) and
            right.getNode() instanceof None
            |
            op instanceof Is and is = true
            or
            op instanceof IsNot and is = false
        )
    }

    predicate int_test(UnprunedCompareNode test, SsaVariable var, CompareOp op, int k) {
        exists(UnprunedCfgNode left, UnprunedCfgNode right, Cmpop cop |
            py_ssa_use(left, var) and
            test.operands(left, cop, right) and
            right.getNode().(IntegerLiteral).getValue() = k and
            op.forOp(cop)
        )
    }

    predicate int_assignment(UnprunedCfgNode asgn, SsaVariable var, CompareOp op, int k) {
        exists(Assign a |
            a.getATarget() = asgn.getNode() and
            py_ssa_use(asgn, var) and
            k = a.getValue().(IntegerLiteral).getValue() and
            op = eq()
        )
    }

    predicate none_assignment(UnprunedCfgNode asgn, SsaVariable var) {
        exists(Assign a |
            a.getATarget() = asgn.getNode() and
            py_ssa_use(asgn, var) and
            a.getValue() instanceof None
        )
    }

    boolean truthy_assignment(UnprunedCfgNode asgn, SsaVariable var) {
        exists(Assign a |
            a.getATarget() = asgn.getNode() and
            py_ssa_use(asgn, var)
            |
            a.getValue() instanceof True and result = true
            or
            a.getValue() instanceof False and result = false
        )
        or
        module_import(asgn, var) and result = true
    }

    /** Gets the constraint on `var` resulting from the an assignment in `asgn` */
    Constraint constraintFromAssignment(SsaVariable var, UnprunedBasicBlock asgn) {
        exists(CompareOp op, int k |
            int_assignment(asgn.getANode(), var, op, k) and
            result = TConstrainedByConstant(op, k)
        )
        or
        none_assignment(asgn.getANode(), var) and result = TIsNone(true)
        or
        result = TTruthy(truthy_assignment(asgn.getANode(), var))
    }

    /** Holds if the constraint `preval` holds for `var` on edge `pred` -> `succ` as a result of a prior test or assignment */
    pragma [nomagic]
    predicate priorConstraint(UnprunedBasicBlock pred, UnprunedBasicBlock succ, Constraint preval, SsaVariable var) {
        not (blacklisted(var) and preval = TTruthy(_))
        and
        not var.getVariable().escapes()
        and
        exists(UnprunedBasicBlock first |
            not first = pred and
            first.(UnprunedConditionBlock).controlsEdge(pred, succ, true) and
            preval = constraintFromTest(var, first.last())
            or
            not first = pred and
            first.(UnprunedConditionBlock).controlsEdge(pred, succ, false) and
            preval = constraintFromTest(var, first.last()).invert()
            or
            preval = constraintFromAssignment(var, first) and
            first.dominates(pred) and
            (succ = pred.getAFalseSuccessor() or succ = pred.getATrueSuccessor())
        )
    }

    /** Holds if `cond` holds for `var` on conditional edge `pred` -> `succ` as a result of the test for that edge */
    predicate constraintOnBranch(UnprunedBasicBlock pred, UnprunedBasicBlock succ, Constraint cond, SsaVariable var) {
        cond = constraintFromTest(var, pred.last()) and
        succ = pred.getATrueSuccessor()
        or
        cond = constraintFromTest(var, pred.last()).invert() and
        succ = pred.getAFalseSuccessor()
    }

    /** Holds if the pair of constraints (`preval`, `postcond`) holds on the edge `pred` -> `succ` for some SSA variable */
    predicate controllingConditions(UnprunedBasicBlock pred, UnprunedBasicBlock succ, Constraint preval, Constraint postcond) {
        exists(SsaVariable var |
            priorConstraint(pred, succ, preval, var) and
            constraintOnBranch(pred, succ, postcond, var)
        )
    }

    /** Holds if the edge `pred` -> `succ` should be pruned as it cannot be reached */
    predicate unreachableEdge(UnprunedBasicBlock pred, UnprunedBasicBlock succ) {
        exists(Constraint pre, Constraint cond |
            controllingConditions(pred, succ, pre, cond) and
            impliesFalse(pre, cond)
        )
        or
        unreachableBB(pred) and succ = pred.getASuccessor()
        or
        simply_dead(pred, succ)
    }

    /* Helper for `unreachableEdge` */
    private predicate impliesFalse(Constraint a, Constraint b) {
        a.impliesFalse(b) or
        a.(ConstrainedByConstant).minValue() > b.(ConstrainedByConstant).maxValue() or
        a.(ConstrainedByConstant).maxValue() < b.(ConstrainedByConstant).minValue()
    }

    /** Holds if edge is simply dead. Stuff like `if False: ...` */
    predicate simply_dead(UnprunedBasicBlock pred, UnprunedBasicBlock succ) {
        constTest(pred.last()) = true and pred.getAFalseSuccessor() = succ
        or
        constTest(pred.last()) = false and pred.getATrueSuccessor() = succ
    }

    /* Helper for simply_dead */
    private boolean constTest(UnprunedCfgNode node) {
        exists(ImmutableLiteral lit |
            result = lit.booleanValue() and lit = node.getNode()
        )
        or
        result = constTest(node.(UnprunedNot).getOperand()).booleanNot()
    }

    /** Holds if `var` is blacklisted as having possibly been mutated */
    predicate blacklisted(SsaVariable var) {
        possibly_mutated(var) and not whitelisted(var)
    }

    predicate possibly_mutated(SsaVariable var) {
        exists(Subscript subscr, UnprunedCfgNode node |
            subscr.getObject() = node.getNode() and
            py_ssa_use(node, var)
        )
        or
        exists(Attribute attr, UnprunedCfgNode node |
            attr.getObject() = node.getNode() and
            py_ssa_use(node, var)
        )
    }

    /** If SSA variable is defined by an import, then it should
     * be whitelisted as taking an attribute cannot change its
     * truthiness.
     */
    predicate whitelisted(SsaVariable var) {
        module_import(_, var)
    }

    private predicate module_import(UnprunedCfgNode asgn, SsaVariable var) {
        exists(Alias alias |
            alias.getValue() instanceof ImportExpr and
            py_ssa_defn(var, asgn) and
            alias.getAsname() = asgn.getNode()
        )
    }
}

