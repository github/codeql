/**
 * Library for SSA representation (Static Single Assignment form).
 */

import python
private import SsaCompute

/* The general intent of this code is to assume only the following interfaces,
 * although several Python-specific parts may have crept in.
 * 
 * SsaSourceVariable { ... }  // See interface below
 * 
 * 
 * BasicBlock {
 * 
 *    ControlFlowNode getNode(int n);
 * 
 *    BasicBlock getImmediateDominator();
 * 
 *    BasicBlock getAPredecessor();
 * 
 *    BasicBlock getATrueSuccessor();
 * 
 *    BasicBlock getAFalseSuccessor();
 * 
 *    predicate dominanceFrontier(BasicBlock other);
 * 
 *    predicate strictlyDominates(BasicBlock other);
 * 
 *    predicate hasLocationInfo(string f, int bl, int bc, int el, int ec);
 * 
 * }
 * 
 * ControlFlowNode {
 * 
 *    Location getLocation();
 * 
 *    BasicBlock getBasicBlock();
 * 
 * }
 * 
 */


 /** A source language variable, to be converted into a set of SSA variables. */
abstract class SsaSourceVariable extends @py_variable {

    /** Gets the name of this variable */
    abstract string getName();

    string toString() {
        result = "SsaSourceVariable " + this.getName()
    }

    /** Gets a use of this variable, either explicit or implicit. */
    abstract ControlFlowNode getAUse();

    /** Holds if `def` defines an ESSA variable for this variable. */
    abstract predicate hasDefiningNode(ControlFlowNode def);

    /** Holds if the edge `pred`->`succ` defines an ESSA variable for this variable. */
    abstract predicate hasDefiningEdge(BasicBlock pred, BasicBlock succ);

    /** Holds if `def` defines an ESSA variable for this variable in such a way
     * that the new variable is a refinement in some way of the variable used at `use`.
     */
    abstract predicate hasRefinement(ControlFlowNode use, ControlFlowNode def);

    /** Holds if the edge `pred`->`succ` defines an ESSA variable for this variable in such a way
     * that the new variable is a refinement in some way of the variable used at `use`.
     */
    abstract predicate hasRefinementEdge(ControlFlowNode use, BasicBlock pred, BasicBlock succ);

    /** Gets a use of this variable that corresponds to an explicit use in the source. */
    abstract ControlFlowNode getASourceUse();

}

/** An (enhanced) SSA variable derived from `SsaSourceVariable`. */
class EssaVariable extends TEssaDefinition {

    /** Gets the (unique) definition of this  variable. */
    EssaDefinition getDefinition() {
        this = result
    }

    /** Gets a use of this variable, where a "use" is defined by
     * `SsaSourceVariable.getAUse()`.
     * Note that this differs from `EssaVariable.getASourceUse()`.
     */
    ControlFlowNode getAUse() {
        result = this.getDefinition().getAUse()
    }

    /** Gets the source variable from which this variable is derived. */
    SsaSourceVariable getSourceVariable() {
        result = this.getDefinition().getSourceVariable()
    }

    /** Gets the name of this variable. */
    string getName() {
        result = this.getSourceVariable().getName()
    }

    string toString() {
        result = "SSA variable " + this.getName()
    }

    /** Gets a string representation of this variable. 
     * WARNING: The format of this may change and it may be very inefficient to compute.
     * To used for debugging and testing only.
     */
    string getRepresentation() {
        result = this.getSourceVariable().getName() + "_" + var_rank(this)
    }

    /** Gets a use of this variable, where a "use" is defined by
     * `SsaSourceVariable.getASourceUse()`.
     * Note that this differs from `EssaVariable.getAUse()`.
     */
    ControlFlowNode getASourceUse() {
        result = this.getAUse() and
        result = this.getSourceVariable().getASourceUse()
    }

    /** Gets the scope of this variable. */
    Scope getScope() {
        result = this.getDefinition().getScope()
    }

    /** Holds if this the meta-variable for a scope.
     * This is used to attach attributes for undeclared variables implicitly
     * defined by `from ... import *` and the like.
     */
    predicate isMetaVariable() {
        this.getName() = "$"
    }

}

/* Helper for location_string 
 * NOTE: This is Python specific, to make `getRepresentation()` portable will require further work.
 */
private int exception_handling(BasicBlock b) {
    b.reachesExit() and result = 0
    or
    not b.reachesExit() and result = 1
}

/* Helper for var_index. Come up with a (probably) unique string per location. */
pragma[noinline]
private string location_string(EssaVariable v) {
    exists(EssaDefinition def, BasicBlock b, int index, int line, int col |
        def = v.getDefinition() and
        (if b.getNode(0).isNormalExit() then
            line = 100000 and col = 0
        else
            b.hasLocationInfo(_, line, col, _, _)
        ) and
        /* Add large numbers to values to prevent 1000 sorting before 99 */
        result = (line + 100000) + ":" + (col*2 + 10000 + exception_handling(b)) + ":" + (index + 100003)
        |
        def = TEssaNodeDefinition(_, b, index)
        or
        def = TEssaNodeRefinement(_, b, index)
        or
        def = TEssaEdgeDefinition(_, _, b) and index = piIndex()
        or
        def = TPhiFunction(_, b) and index = phiIndex()
    )
}

/* Helper to compute an index for this SSA variable. */
private int var_index(EssaVariable v) {
    location_string(v) = rank[result](string s | exists(EssaVariable x | location_string(x) = s) | s)
}

/* Helper for `v.getRepresentation()` */
private int var_rank(EssaVariable v) {
    exists(int r, SsaSourceVariable var |
        var = v.getSourceVariable() and
        var_index(v) = rank[r](EssaVariable x | x.getSourceVariable() = var | var_index(x)) and
        result = r-1
    )
}

/** Underlying IPA type for EssaDefinition and EssaVariable. */
private cached newtype TEssaDefinition =
    TEssaNodeDefinition(SsaSourceVariable v, BasicBlock b, int i) {
        EssaDefinitions::variableDefinition(v, _, b, _, i)
    }
    or
    TEssaNodeRefinement(SsaSourceVariable v, BasicBlock b, int i) {
        EssaDefinitions::variableRefinement(v, _, b, _, i)
    }
    or
    TEssaEdgeDefinition(SsaSourceVariable v, BasicBlock pred, BasicBlock succ) {
        EssaDefinitions::piNode(v, pred, succ)
    }
    or
    TPhiFunction(SsaSourceVariable v, BasicBlock b) {
        EssaDefinitions::phiNode(v, b)
    }

/** Definition of an extended-SSA (ESSA) variable.
 *  There is exactly one definition for each variable,
 *  and exactly one variable for each definition.
 */
abstract class EssaDefinition extends TEssaDefinition {

    string toString() {
        result = "EssaDefinition"
    }

    /** Gets the source variable for which this a definition, either explicit or implicit. */
    abstract SsaSourceVariable getSourceVariable();

    /** Gets a use of this definition as defined by the `SsaSourceVariable` class. */
    abstract ControlFlowNode getAUse();

    /** Holds if this definition reaches the end of `b`. */
    abstract predicate reachesEndOfBlock(BasicBlock b);

    /** Gets the location of a control flow node that is indicative of this definition.
     * Since definitions may occur on edges of the control flow graph, the given location may 
     * be imprecise.
     * Distinct `EssaDefinitions` may return the same ControlFlowNode even for
     * the same variable. 
     */
    abstract Location getLocation();

    /** Gets a representation of this SSA definition for debugging purposes.
     * Since this is primarily for debugging and testing, performance may be poor. */
    abstract string getRepresentation();

    abstract Scope getScope();

    EssaVariable getVariable() {
        result.getDefinition() = this
    }

}

/** An ESSA definition corresponding to an edge refinement of the underlying variable. 
 * For example, the edges leaving a test on a variable both represent refinements of that
 * variable. On one edge the test is true, on the other it is false. 
 */
class EssaEdgeRefinement extends EssaDefinition, TEssaEdgeDefinition {

    override string toString() {
        result = "SSA filter definition"
    }

    boolean getSense() {
        this.getPredecessor().getATrueSuccessor() = this.getSuccessor() and result = true
        or
        this.getPredecessor().getAFalseSuccessor() = this.getSuccessor() and result = false
    }

    override SsaSourceVariable getSourceVariable() {
        this = TEssaEdgeDefinition(result, _, _)
    }

    /** Gets the basic block preceding the edge on which this refinement occurs. */
    BasicBlock getPredecessor() {
        this = TEssaEdgeDefinition(_, result, _)
    }

    /** Gets the basic block succeeding the edge on which this refinement occurs. */
    BasicBlock getSuccessor() {
        this = TEssaEdgeDefinition(_, _, result)
    }

    override ControlFlowNode getAUse() {
        SsaDefinitions::reachesUse(this.getSourceVariable(), this.getSuccessor(), piIndex(), result)
    }

    override predicate reachesEndOfBlock(BasicBlock b) {
        SsaDefinitions::reachesEndOfBlock(this.getSourceVariable(), this.getSuccessor(), piIndex(), b)
    }

    override Location getLocation() {
        result = this.getSuccessor().getNode(0).getLocation()
    }

    /** Gets the SSA variable to which this refinement applies. */
    EssaVariable getInput() {
        exists(SsaSourceVariable var , EssaDefinition def |
            var = this.getSourceVariable() and
            var = def.getSourceVariable() and
            def.reachesEndOfBlock(this.getPredecessor()) and
            result.getDefinition() = def
        )
    }

    override string getRepresentation() {
        result = this.getAQlClass() + "(" + this.getInput().getRepresentation() + ")"
    }

    /** Gets the scope of the variable defined by this definition. */
    override Scope getScope() {
        result = this.getPredecessor().getScope()
    }

}

/** A Phi-function as specified in classic SSA form. */
class PhiFunction extends EssaDefinition, TPhiFunction {

    override ControlFlowNode getAUse() {
        SsaDefinitions::reachesUse(this.getSourceVariable(), this.getBasicBlock(), phiIndex(), result)
    }

    override predicate reachesEndOfBlock(BasicBlock b) {
        SsaDefinitions::reachesEndOfBlock(this.getSourceVariable(), this.getBasicBlock(), phiIndex(), b)
    }

    override SsaSourceVariable getSourceVariable() {
        this = TPhiFunction(result, _)
    }

    /** Gets an input refinement that exists on one of the incoming edges to this phi node. */
    private EssaEdgeRefinement inputEdgeRefinement(BasicBlock pred) {
        result.getSourceVariable() = this.getSourceVariable() and
        result.getSuccessor() = this.getBasicBlock() and
        result.getPredecessor() = pred
    }

    private BasicBlock nonPiInput() {
        result = this.getBasicBlock().getAPredecessor() and
        not exists(this.inputEdgeRefinement(result))
    }

    /** Gets another definition of the same source variable that reaches this definition. */
    private EssaDefinition reachingDefinition(BasicBlock pred) {
        result.getScope() = this.getScope() and
        result.getSourceVariable() = this.getSourceVariable() and
        pred = this.nonPiInput() and
        result.reachesEndOfBlock(pred)
    }

    /** Gets the input variable for this phi node on the edge `pred` -> `this.getBasicBlock()`, if any. */
    pragma [noinline]
    EssaVariable getInput(BasicBlock pred) {
        result.getDefinition() = this.reachingDefinition(pred)
        or
        result.getDefinition() = this.inputEdgeRefinement(pred)
    }

    /** Gets an input variable for this phi node. */
    EssaVariable getAnInput() {
        result = this.getInput(_)
    }

    /** Holds if forall incoming edges in the flow graph, there is an input variable */
    predicate isComplete() {
        forall(BasicBlock pred |
            pred = this.getBasicBlock().getAPredecessor() |
            exists(this.getInput(pred))
        )
    }

    override string toString() {
        result = "SSA Phi Function"
    }

    /** Gets the basic block that succeeds this phi node. */
    BasicBlock getBasicBlock() {
        this = TPhiFunction(_, result)
    }

    override Location getLocation() {
        result = this.getBasicBlock().getNode(0).getLocation()
    }

    /** Helper for `argList(n)`. */
    private int rankInput(EssaVariable input) {
        input = this.getAnInput() and
        var_index(input) = rank[result](EssaVariable v | v = this.getAnInput() | var_index(v))
    }

    /** Helper for `argList()`. */
    private string argList(int n) {
        exists(EssaVariable input |
            n = this.rankInput(input)
            |
            n = 1 and result = input.getRepresentation()
            or
            n > 1 and result = this.argList(n-1) + ", " + input.getRepresentation()
        )
    }

    /** Helper for `getRepresentation()`. */
    private string argList() {
        exists(int last |
            last = (max(int x | x = this.rankInput(_))) and
            result = this.argList(last)
        )
    }

    override string getRepresentation() {
        not exists(this.getAnInput()) and result = "phi()"
        or
        result = "phi(" + this.argList() + ")"
        or
        exists(this.getAnInput()) and not exists(this.argList()) and
        result = "phi(" + this.getSourceVariable().getName() + "??)"
    }

    override Scope getScope() {
        result = this.getBasicBlock().getScope()
    }

    private EssaEdgeRefinement piInputDefinition(EssaVariable input) {
        input = this.getAnInput() and 
        result = input.getDefinition()
        or
        input = this.getAnInput() and result = input.getDefinition().(PhiFunction).piInputDefinition(_)
    }

    /** Gets the variable which is the common and complete input to all pi-nodes that are themselves
     * inputs to this phi-node.
     * For example:
     * ```
     * x = y()
     * if complicated_test(x):
     *     do_a()
     * else:
     *     do_b()
     * phi
     * ```
     * Which gives us the ESSA form:
     * x0 = y()
     * x1 = pi(x0, complicated_test(x0))
     * x2 = pi(x0, not complicated_test(x0))
     * x3 = phi(x1, x2)
     * However we may not be able to track the value of `x` through `compilated_test`
     * meaning that we cannot track `x` from `x0` to `x3`.
     * By using `getShortCircuitInput()` we can do so, since the short-circuit input of `x3` is `x0`.
     */
    pragma [noinline]
    EssaVariable getShortCircuitInput() {
        exists(BasicBlock common |
            forall(EssaVariable input |
                input = this.getAnInput() |
                common = this.piInputDefinition(input).getPredecessor()
            )
            and
            forall(BasicBlock succ |
                succ = common.getASuccessor() |
                succ = this.piInputDefinition(_).getSuccessor()
            )
            and
            exists(EssaEdgeRefinement ref |
                ref = this.piInputDefinition(_) and
                ref.getPredecessor() = common and
                ref.getInput() = result
            )
        )
    }
}

/** A definition of an ESSA variable that is not directly linked to
 * another ESSA variable.
 */
class EssaNodeDefinition extends EssaDefinition, TEssaNodeDefinition {

    override string toString() {
        result = "Essa node definition"
    }

    override ControlFlowNode getAUse() {
        exists(SsaSourceVariable v, BasicBlock b, int i |
            this = TEssaNodeDefinition(v, b, i) and
            SsaDefinitions::reachesUse(v, b, i, result)
        )
    }

    override predicate reachesEndOfBlock(BasicBlock b) {
        exists(BasicBlock defb, int i |
            this = TEssaNodeDefinition(_, defb, i) and
            SsaDefinitions::reachesEndOfBlock(this.getSourceVariable(), defb, i, b)
        )
    }

    override SsaSourceVariable getSourceVariable() {
        this = TEssaNodeDefinition(result, _, _)
    }

    /** Gets the ControlFlowNode corresponding to this definition */
    ControlFlowNode getDefiningNode() {
        this.definedBy(_, result)
    }

    override Location getLocation() {
        result = this.getDefiningNode().getLocation()
    }

    override string getRepresentation() {
        result = this.getDefiningNode().toString()
    }

    override Scope getScope() {
        exists(BasicBlock defb |
            this = TEssaNodeDefinition(_, defb, _) and
            result = defb.getScope()
        )
    }

    predicate definedBy(SsaSourceVariable v, ControlFlowNode def) {
        exists(BasicBlock b, int i |
            def = b.getNode(i) |
            this = TEssaNodeDefinition(v, b, i+i)
            or
            this = TEssaNodeDefinition(v, b, i+i+1)
        )
    }

}

/** A definition of an ESSA variable that takes another ESSA variable as an input.
 */
class EssaNodeRefinement extends EssaDefinition, TEssaNodeRefinement {

    override string toString() {
        result = "SSA filter definition"
    }

    /** Gets the SSA variable to which this refinement applies. */
    EssaVariable getInput() {
        result = potential_input(this) and
        not result = potential_input(potential_input(this).getDefinition())
    }

    override ControlFlowNode getAUse() {
        exists(SsaSourceVariable v, BasicBlock b, int i |
            this = TEssaNodeRefinement(v, b, i) and
            SsaDefinitions::reachesUse(v, b, i, result)
        )
    }

    override predicate reachesEndOfBlock(BasicBlock b) {
        exists(BasicBlock defb, int i |
            this = TEssaNodeRefinement(_, defb, i) and
            SsaDefinitions::reachesEndOfBlock(this.getSourceVariable(), defb, i, b)
        )
    }

    override SsaSourceVariable getSourceVariable() {
        this = TEssaNodeRefinement(result, _, _)
    }

    /** Gets the ControlFlowNode corresponding to this definition */
    ControlFlowNode getDefiningNode() {
        this.definedBy(_, result)
    }

    override Location getLocation() {
        result = this.getDefiningNode().getLocation()
    }

    override string getRepresentation() {
        result = this.getAQlClass() + "(" + this.getInput().getRepresentation() + ")"
    }

    override Scope getScope() {
        exists(BasicBlock defb |
            this = TEssaNodeRefinement(_, defb, _) and
            result = defb.getScope()
        )
    }

    predicate definedBy(SsaSourceVariable v, ControlFlowNode def) {
        exists(BasicBlock b, int i |
            def = b.getNode(i) |
            this = TEssaNodeRefinement(v, b, i+i)
            or
            this = TEssaNodeRefinement(v, b, i+i+1)
        )
    }

}

pragma[noopt]
private EssaVariable potential_input(EssaNodeRefinement ref) {
   exists(ControlFlowNode use, SsaSourceVariable var, ControlFlowNode def |
        var.hasRefinement(use, def) and
        use = result.getAUse() and
        var = result.getSourceVariable() and
        def = ref.getDefiningNode() and
        var = ref.getSourceVariable()
    )
}
