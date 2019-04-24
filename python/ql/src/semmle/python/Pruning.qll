import python


module Pruner {

    /** A basic block before pruning */
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

        override Compare getNode() { result = super.getNode() }

    }

    /** A control flow node corresponding to a unary expression: (`+x`), (`-x`) or (`~x`) */
    class UnprunedNot extends UnprunedCfgNode {
        UnprunedNot() {
            exists(UnaryExpr unary |
                py_flow_bb_node(this, unary, _, _) and
                unary.getOp() instanceof Not
            )
        }

        /** flow node corresponding to the operand of a unary expression */
        UnprunedCfgNode getOperand() {
            exists(UnaryExpr u | this.getNode() = u and result.getNode() = u.getOperand()) and
            result.getBasicBlock().dominates(this.getBasicBlock())
        }

        override UnaryExpr getNode() { result = super.getNode() }

    }

    /** A basic block before pruning */
    class UnprunedBasicBlock extends @py_flow_node {

        UnprunedBasicBlock() {
            py_flow_bb_node(_, _, this, _)
        }

        /** Whether this basic block contains the specified node */
        predicate contains(@py_flow_node node) {
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

    newtype TConditionalConstant =
        TTruthy(boolean b) { b = true or b = false }
        or
        TIsNone(boolean b) { b = true or b = false }
        or
        TComparedToConstant(CompareOp op, int k) {
            comparison_or_assignment_to_constant(op, k)
        }

        abstract class ConditionalConstant extends TConditionalConstant {

        abstract string toString();

        abstract ConditionalConstant invert();

        abstract predicate constrainsVariableToBe(boolean value);

        abstract predicate impliesFalse(ConditionalConstant other);

    }

    private predicate comparison_or_assignment_to_constant(CompareOp op, int k) {
        exists(Compare comp, Cmpop cop, IntegerLiteral l |
            comp.compares(_, cop, l) and
            l.getValue() = k and
            op.forOp(cop)
        )
        or
        exists(Assign a | a.getValue().(IntegerLiteral).getValue() = k) and op = eq()
    }

    class UnprunedConditionBlock extends UnprunedBasicBlock {

        UnprunedConditionBlock() { this.last().isBranch() }

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

        /** Holds if this condition controls the edge `pred->succ`, i.e. those edges for which the condition is `testIsTrue`. */
        predicate controlsEdge(UnprunedBasicBlock pred, UnprunedBasicBlock succ, boolean testIsTrue) {
            this.controls(pred, testIsTrue) and succ = pred.getASuccessor()
            or
            pred.last() = this and (
                testIsTrue = true and succ = this.getATrueSuccessor()
                or
                testIsTrue = false and succ = this.getAFalseSuccessor()
            )
        }

    }

    class Truthy extends ConditionalConstant, TTruthy {

        private boolean booleanValue() {
            this = TTruthy(result)
        }

        override string toString() {
            result = "Truthy" and this.booleanValue() = true
            or
            result = "Falsey" and this.booleanValue() = false
        }

        override ConditionalConstant invert() {
            result = TTruthy(this.booleanValue().booleanNot())
        }

        override predicate constrainsVariableToBe(boolean value) {
            value = this.booleanValue()
        }

        override predicate impliesFalse(ConditionalConstant other) {
            other.constrainsVariableToBe(this.booleanValue().booleanNot())
        }

    }

    class IsNone extends ConditionalConstant, TIsNone {

        private boolean isNone() {
            this = TIsNone(result)
        }

        override string toString() {
            result = "Is None" and this.isNone() = true
            or
            result = "Is not None" and this.isNone() = false
        }

        override ConditionalConstant invert() {
            result = TIsNone(this.isNone().booleanNot())
        }

        override predicate constrainsVariableToBe(boolean value) {
            value = false and this.isNone() = true
        }

        override predicate impliesFalse(ConditionalConstant other) {
            other = TIsNone(this.isNone().booleanNot())
            or
            this.isNone() = true and other = TTruthy(true)
        }

    }

    class ComparedToConstant extends ConditionalConstant, TComparedToConstant {

        private int intValue() {
            this = TComparedToConstant(_, result)
        }

        private CompareOp getOp() {
            this = TComparedToConstant(result, _)
        }

        override string toString() {
            result = this.getOp().repr() + " " + this.intValue().toString()
        }

        override ConditionalConstant invert() {
            result = TComparedToConstant(this.getOp().invert(), this.intValue())
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

        override predicate impliesFalse(ConditionalConstant other) {
            exists(boolean b |
                this.constrainsVariableToBe(b) and other = TTruthy(b.booleanNot())
            )
            or
            this.getOp() = eq() and other = TIsNone(true)
            or
            this.getOp() = ne() and other.(ComparedToConstant).getOp() = eq()
            and this.intValue() = other.(ComparedToConstant).intValue()
        }

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

    predicate pruned(@py_flow_node n) {
        exists(UnprunedBasicBlock bb |
            pruned_bb(bb) and bb.contains(n)
        )
    }

    //private 
    predicate pruned_bb(UnprunedBasicBlock bb) {
        not bb.isEntry() and
        forall(UnprunedBasicBlock pred |
            pred.getASuccessor() = bb
            |
            pruned_edge(pred, bb)
        )
    }

    ConditionalConstant conditionForTest(SsaVariable var, UnprunedBasicBlock test) {
        result = conditionForNode(var, test.last())
    }

    private ConditionalConstant conditionForNode(SsaVariable var, UnprunedCfgNode node) {
        py_ssa_use(node, var) and result = TTruthy(true)
        or
        exists(boolean b |
            none_test(node, var, b) and result = TIsNone(b)
        )
        or
        exists(CompareOp op, int k |
            int_test(node, var, op, k) and
            result = TComparedToConstant(op, k)
        )
        or
        result = conditionForNode(var, node.(UnprunedNot).getOperand()).invert()
    }

    predicate impliesFalse(ConditionalConstant a, ConditionalConstant b) {
        a.impliesFalse(b) or
        a.(ComparedToConstant).minValue() > b.(ComparedToConstant).maxValue() or
        a.(ComparedToConstant).maxValue() < b.(ComparedToConstant).minValue()
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

    private boolean truthy_assignment(UnprunedCfgNode asgn, SsaVariable var) {
        exists(Assign a |
            a.getATarget() = asgn.getNode() and
            py_ssa_use(asgn, var)
            |
            a.getValue() instanceof True and result = true
            or
            a.getValue() instanceof False and result = false
        )
        or
        module_import(var) and result = true
    }

    private ConditionalConstant conditionForAssign(SsaVariable var, UnprunedBasicBlock asgn) {
        exists(CompareOp op, int k |
            int_assignment(asgn.getANode(), var, op, k) and
            result = TComparedToConstant(op, k)
        )
        or
        none_assignment(asgn.getANode(), var) and result = TIsNone(true)
        or
        result = TTruthy(truthy_assignment(asgn.getANode(), var))
    }

    predicate priorCondition(UnprunedBasicBlock pred, UnprunedBasicBlock succ, ConditionalConstant preval, SsaVariable var) {
        not (blacklisted(var) and preval = TTruthy(_))
        and
        not var.getVariable().escapes()
        and
        exists(UnprunedBasicBlock first |
            not first = pred and
            first.(UnprunedConditionBlock).controlsEdge(pred, succ, true) and
            preval = conditionForTest(var, first)
            or
            not first = pred and
            first.(UnprunedConditionBlock).controlsEdge(pred, succ, false) and
            preval = conditionForTest(var, first).invert()
            or
            preval = conditionForAssign(var, first) and
            first.dominates(pred) and
            (succ = pred.getAFalseSuccessor() or succ = pred.getATrueSuccessor())
        )
    }

    predicate branchCondition(UnprunedBasicBlock pred, UnprunedBasicBlock succ, ConditionalConstant cond, SsaVariable var) {
        cond = conditionForTest(var, pred) and
        succ = pred.getATrueSuccessor()
        or
        cond = conditionForTest(var, pred).invert() and
        succ = pred.getAFalseSuccessor()
    }

    predicate controllingConditions(UnprunedBasicBlock pred, UnprunedBasicBlock succ, ConditionalConstant preval, ConditionalConstant postcond) {
        exists(SsaVariable var |
            priorCondition(pred, succ, preval, var) and
            branchCondition(pred, succ, postcond, var)
        )
    }

    predicate pruned_edge(UnprunedBasicBlock pred, UnprunedBasicBlock succ) {
        exists(ConditionalConstant pre, ConditionalConstant cond |
            controllingConditions(pred, succ, pre, cond) and
            impliesFalse(pre, cond)
        )
        or
        pruned_bb(pred) and succ = pred.getASuccessor()
        or
        simply_dead(pred, succ)
    }

    /** Holds if edge is simply dead. Stuff like `if False: ...` */
    //private 
    predicate simply_dead(UnprunedBasicBlock pred, UnprunedBasicBlock succ) {
        constTest(pred.last()) = true and pred.getAFalseSuccessor() = succ
        or
        constTest(pred.last()) = false and pred.getATrueSuccessor() = succ
    }

    private boolean constTest(UnprunedCfgNode node) {
        exists(ImmutableLiteral lit |
            result = lit.booleanValue() and lit = node.getNode()
        )
        or
        result = constTest(node.(UnprunedNot).getOperand()).booleanNot()
    }

    /** Holds if `var` is blacklisted as having possbily been mutated */
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
        module_import(var)
    }

    private predicate module_import(SsaVariable var) {
        exists(Alias alias, UnprunedCfgNode node |
            alias.getValue() instanceof ImportExpr and
            py_ssa_defn(var, node) and
            alias.getAsname() = node.getNode()
        )
    }
}

