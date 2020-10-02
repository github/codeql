/**
 * Library for SSA representation (Static Single Assignment form).
 */

import python
private import SsaCompute
import semmle.python.essa.Definitions

/** An (enhanced) SSA variable derived from `SsaSourceVariable`. */
class EssaVariable extends TEssaDefinition {
  /** Gets the (unique) definition of this  variable. */
  EssaDefinition getDefinition() { this = result }

  /**
   * Gets a use of this variable, where a "use" is defined by
   * `SsaSourceVariable.getAUse()`.
   * Note that this differs from `EssaVariable.getASourceUse()`.
   */
  ControlFlowNode getAUse() { result = this.getDefinition().getAUse() }

  /** Gets the source variable from which this variable is derived. */
  SsaSourceVariable getSourceVariable() { result = this.getDefinition().getSourceVariable() }

  /** Gets the name of this variable. */
  string getName() { result = this.getSourceVariable().getName() }

  /** Gets a textual representation of this element. */
  string toString() { result = "SSA variable " + this.getName() }

  /**
   * Gets a string representation of this variable.
   * WARNING: The format of this may change and it may be very inefficient to compute.
   * To used for debugging and testing only.
   */
  string getRepresentation() { result = this.getSourceVariable().getName() + "_" + var_rank(this) }

  /**
   * Gets a use of this variable, where a "use" is defined by
   * `SsaSourceVariable.getASourceUse()`.
   * Note that this differs from `EssaVariable.getAUse()`.
   */
  ControlFlowNode getASourceUse() {
    exists(SsaSourceVariable var |
      result = use_for_var(var) and
      result = var.getASourceUse()
    )
  }

  pragma[nomagic]
  private ControlFlowNode use_for_var(SsaSourceVariable var) {
    result = this.getAUse() and
    var = this.getSourceVariable()
  }

  /** Gets the scope of this variable. */
  Scope getScope() { result = this.getDefinition().getScope() }

  /**
   * Holds if this the meta-variable for a scope.
   * This is used to attach attributes for undeclared variables implicitly
   * defined by `from ... import *` and the like.
   */
  predicate isMetaVariable() { this.getName() = "$" }
}

/*
 * Helper for location_string
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
    (
      if b.getNode(0).isNormalExit()
      then line = 100000 and col = 0
      else b.hasLocationInfo(_, line, col, _, _)
    ) and
    /* Add large numbers to values to prevent 1000 sorting before 99 */
    result =
      (line + 100000) + ":" + (col * 2 + 10000 + exception_handling(b)) + ":" + (index + 100003)
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
    result = r - 1
  )
}

/** Underlying IPA type for EssaDefinition and EssaVariable. */
cached
private newtype TEssaDefinition =
  TEssaNodeDefinition(SsaSourceVariable v, BasicBlock b, int i) {
    EssaDefinitions::variableDefinition(v, _, b, _, i)
  } or
  TEssaNodeRefinement(SsaSourceVariable v, BasicBlock b, int i) {
    EssaDefinitions::variableRefinement(v, _, b, _, i)
  } or
  TEssaEdgeDefinition(SsaSourceVariable v, BasicBlock pred, BasicBlock succ) {
    EssaDefinitions::piNode(v, pred, succ)
  } or
  TPhiFunction(SsaSourceVariable v, BasicBlock b) { EssaDefinitions::phiNode(v, b) }

/**
 * Definition of an extended-SSA (ESSA) variable.
 * There is exactly one definition for each variable,
 * and exactly one variable for each definition.
 */
abstract class EssaDefinition extends TEssaDefinition {
  /** Gets a textual representation of this element. */
  string toString() { result = "EssaDefinition" }

  /** Gets the source variable for which this a definition, either explicit or implicit. */
  abstract SsaSourceVariable getSourceVariable();

  /** Gets a use of this definition as defined by the `SsaSourceVariable` class. */
  abstract ControlFlowNode getAUse();

  /** Holds if this definition reaches the end of `b`. */
  abstract predicate reachesEndOfBlock(BasicBlock b);

  /**
   * Gets the location of a control flow node that is indicative of this definition.
   * Since definitions may occur on edges of the control flow graph, the given location may
   * be imprecise.
   * Distinct `EssaDefinitions` may return the same ControlFlowNode even for
   * the same variable.
   */
  abstract Location getLocation();

  /**
   * Gets a representation of this SSA definition for debugging purposes.
   * Since this is primarily for debugging and testing, performance may be poor.
   */
  abstract string getRepresentation();

  abstract Scope getScope();

  EssaVariable getVariable() { result.getDefinition() = this }

  abstract BasicBlock getBasicBlock();
}

/**
 * An ESSA definition corresponding to an edge refinement of the underlying variable.
 * For example, the edges leaving a test on a variable both represent refinements of that
 * variable. On one edge the test is true, on the other it is false.
 */
class EssaEdgeRefinement extends EssaDefinition, TEssaEdgeDefinition {
  override string toString() { result = "SSA filter definition" }

  boolean getSense() {
    this.getPredecessor().getATrueSuccessor() = this.getSuccessor() and result = true
    or
    this.getPredecessor().getAFalseSuccessor() = this.getSuccessor() and result = false
  }

  override SsaSourceVariable getSourceVariable() { this = TEssaEdgeDefinition(result, _, _) }

  /** Gets the basic block preceding the edge on which this refinement occurs. */
  BasicBlock getPredecessor() { this = TEssaEdgeDefinition(_, result, _) }

  /** Gets the basic block succeeding the edge on which this refinement occurs. */
  BasicBlock getSuccessor() { this = TEssaEdgeDefinition(_, _, result) }

  override ControlFlowNode getAUse() {
    SsaDefinitions::reachesUse(this.getSourceVariable(), this.getSuccessor(), piIndex(), result)
  }

  override predicate reachesEndOfBlock(BasicBlock b) {
    SsaDefinitions::reachesEndOfBlock(this.getSourceVariable(), this.getSuccessor(), piIndex(), b)
  }

  override Location getLocation() { result = this.getSuccessor().getNode(0).getLocation() }

  /** Gets the SSA variable to which this refinement applies. */
  EssaVariable getInput() {
    exists(SsaSourceVariable var, EssaDefinition def |
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
  override Scope getScope() { result = this.getPredecessor().getScope() }

  override BasicBlock getBasicBlock() { result = this.getSuccessor() }
}

/** A Phi-function as specified in classic SSA form. */
class PhiFunction extends EssaDefinition, TPhiFunction {
  override ControlFlowNode getAUse() {
    SsaDefinitions::reachesUse(this.getSourceVariable(), this.getBasicBlock(), phiIndex(), result)
  }

  override predicate reachesEndOfBlock(BasicBlock b) {
    SsaDefinitions::reachesEndOfBlock(this.getSourceVariable(), this.getBasicBlock(), phiIndex(), b)
  }

  override SsaSourceVariable getSourceVariable() { this = TPhiFunction(result, _) }

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

  pragma[noinline]
  private SsaSourceVariable pred_var(BasicBlock pred) {
    result = this.getSourceVariable() and
    pred = this.nonPiInput()
  }

  /** Gets another definition of the same source variable that reaches this definition. */
  private EssaDefinition reachingDefinition(BasicBlock pred) {
    result.getScope() = this.getScope() and
    result.getSourceVariable() = pred_var(pred) and
    result.reachesEndOfBlock(pred)
  }

  /** Gets the input variable for this phi node on the edge `pred` -> `this.getBasicBlock()`, if any. */
  cached
  EssaVariable getInput(BasicBlock pred) {
    result.getDefinition() = this.reachingDefinition(pred)
    or
    result.getDefinition() = this.inputEdgeRefinement(pred)
  }

  /** Gets an input variable for this phi node. */
  EssaVariable getAnInput() { result = this.getInput(_) }

  /** Holds if forall incoming edges in the flow graph, there is an input variable */
  predicate isComplete() {
    forall(BasicBlock pred | pred = this.getBasicBlock().getAPredecessor() |
      exists(this.getInput(pred))
    )
  }

  override string toString() { result = "SSA Phi Function" }

  /** Gets the basic block that succeeds this phi node. */
  override BasicBlock getBasicBlock() { this = TPhiFunction(_, result) }

  override Location getLocation() { result = this.getBasicBlock().getNode(0).getLocation() }

  /** Helper for `argList(n)`. */
  private int rankInput(EssaVariable input) {
    input = this.getAnInput() and
    var_index(input) = rank[result](EssaVariable v | v = this.getAnInput() | var_index(v))
  }

  /** Helper for `argList()`. */
  private string argList(int n) {
    exists(EssaVariable input | n = this.rankInput(input) |
      n = 1 and result = input.getRepresentation()
      or
      n > 1 and result = this.argList(n - 1) + ", " + input.getRepresentation()
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
    exists(this.getAnInput()) and
    not exists(this.argList()) and
    result = "phi(" + this.getSourceVariable().getName() + "??)"
  }

  override Scope getScope() { result = this.getBasicBlock().getScope() }

  private EssaEdgeRefinement piInputDefinition(EssaVariable input) {
    input = this.getAnInput() and
    result = input.getDefinition()
    or
    input = this.getAnInput() and result = input.getDefinition().(PhiFunction).piInputDefinition(_)
  }

  /**
   * Gets the variable which is the common and complete input to all pi-nodes that are themselves
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
  pragma[noinline]
  EssaVariable getShortCircuitInput() {
    exists(BasicBlock common |
      forall(EssaVariable input | input = this.getAnInput() |
        common = this.piInputDefinition(input).getPredecessor()
      ) and
      forall(BasicBlock succ | succ = common.getASuccessor() |
        succ = this.piInputDefinition(_).getSuccessor()
      ) and
      exists(EssaEdgeRefinement ref |
        ref = this.piInputDefinition(_) and
        ref.getPredecessor() = common and
        ref.getInput() = result
      )
    )
  }
}

/**
 * A definition of an ESSA variable that is not directly linked to
 * another ESSA variable.
 */
class EssaNodeDefinition extends EssaDefinition, TEssaNodeDefinition {
  override string toString() { result = "Essa node definition" }

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

  override SsaSourceVariable getSourceVariable() { this = TEssaNodeDefinition(result, _, _) }

  /** Gets the ControlFlowNode corresponding to this definition */
  ControlFlowNode getDefiningNode() { this.definedBy(_, result) }

  override Location getLocation() { result = this.getDefiningNode().getLocation() }

  override string getRepresentation() { result = this.getAQlClass() }

  override Scope getScope() {
    exists(BasicBlock defb |
      this = TEssaNodeDefinition(_, defb, _) and
      result = defb.getScope()
    )
  }

  predicate definedBy(SsaSourceVariable v, ControlFlowNode def) {
    exists(BasicBlock b, int i | def = b.getNode(i) |
      this = TEssaNodeDefinition(v, b, i + i)
      or
      this = TEssaNodeDefinition(v, b, i + i + 1)
    )
  }

  override BasicBlock getBasicBlock() { result = this.getDefiningNode().getBasicBlock() }
}

/** A definition of an ESSA variable that takes another ESSA variable as an input. */
class EssaNodeRefinement extends EssaDefinition, TEssaNodeRefinement {
  override string toString() { result = "SSA filter definition" }

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

  override SsaSourceVariable getSourceVariable() { this = TEssaNodeRefinement(result, _, _) }

  /** Gets the ControlFlowNode corresponding to this definition */
  ControlFlowNode getDefiningNode() { this.definedBy(_, result) }

  override Location getLocation() { result = this.getDefiningNode().getLocation() }

  override string getRepresentation() {
    result = this.getAQlClass() + "(" + this.getInput().getRepresentation() + ")"
    or
    not exists(this.getInput()) and
    result = this.getAQlClass() + "(" + this.getSourceVariable().getName() + "??)"
  }

  override Scope getScope() {
    exists(BasicBlock defb |
      this = TEssaNodeRefinement(_, defb, _) and
      result = defb.getScope()
    )
  }

  predicate definedBy(SsaSourceVariable v, ControlFlowNode def) {
    exists(BasicBlock b, int i | def = b.getNode(i) |
      this = TEssaNodeRefinement(v, b, i + i)
      or
      this = TEssaNodeRefinement(v, b, i + i + 1)
    )
  }

  override BasicBlock getBasicBlock() { result = this.getDefiningNode().getBasicBlock() }
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

/* For backwards compatibility */
deprecated class PyNodeDefinition = EssaNodeDefinition;

/* For backwards compatibility */
deprecated class PyNodeRefinement = EssaNodeRefinement;

/** An assignment to a variable `v = val` */
class AssignmentDefinition extends EssaNodeDefinition {
  AssignmentDefinition() {
    SsaSource::assignment_definition(this.getSourceVariable(), this.getDefiningNode(), _)
  }

  ControlFlowNode getValue() {
    SsaSource::assignment_definition(this.getSourceVariable(), this.getDefiningNode(), result)
  }

  override string getRepresentation() { result = this.getValue().getNode().toString() }
}

/** Capture of a raised exception `except ExceptionType ex:` */
class ExceptionCapture extends EssaNodeDefinition {
  ExceptionCapture() {
    SsaSource::exception_capture(this.getSourceVariable(), this.getDefiningNode())
  }

  ControlFlowNode getType() {
    exists(ExceptFlowNode ex |
      ex.getName() = this.getDefiningNode() and
      result = ex.getType()
    )
  }

  override string getRepresentation() { result = "except " + this.getSourceVariable().getName() }
}

/** An assignment to a variable as part of a multiple assignment `..., v, ... = val` */
class MultiAssignmentDefinition extends EssaNodeDefinition {
  MultiAssignmentDefinition() {
    SsaSource::multi_assignment_definition(this.getSourceVariable(), this.getDefiningNode(), _, _)
  }

  override string getRepresentation() {
    exists(ControlFlowNode value, int n |
      this.indexOf(n, value) and
      result = value.(DefinitionNode).getValue().getNode().toString() + "[" + n + "]"
    )
  }

  /** Holds if `this` has (zero-based) index `index` in `lhs`. */
  predicate indexOf(int index, SequenceNode lhs) {
    SsaSource::multi_assignment_definition(this.getSourceVariable(), this.getDefiningNode(), index,
      lhs)
  }
}

/** A definition of a variable in a `with` statement */
class WithDefinition extends EssaNodeDefinition {
  WithDefinition() { SsaSource::with_definition(this.getSourceVariable(), this.getDefiningNode()) }

  override string getRepresentation() { result = "with" }
}

/** A definition of a variable by declaring it as a parameter */
class ParameterDefinition extends EssaNodeDefinition {
  ParameterDefinition() {
    SsaSource::parameter_definition(this.getSourceVariable(), this.getDefiningNode())
  }

  predicate isSelf() { this.getDefiningNode().getNode().(Parameter).isSelf() }

  /** Gets the control flow node for the default value of this parameter */
  ControlFlowNode getDefault() { result.getNode() = this.getParameter().getDefault() }

  /** Gets the annotation control flow node of this parameter */
  ControlFlowNode getAnnotation() { result.getNode() = this.getParameter().getAnnotation() }

  /** Gets the name of this parameter definition */
  string getName() { result = this.getParameter().asName().getId() }

  predicate isVarargs() {
    exists(Function func | func.getVararg() = this.getDefiningNode().getNode())
  }

  /**
   * Holds if this parameter is a 'kwargs' parameter.
   * The `kwargs` in `f(a, b, **kwargs)`.
   */
  predicate isKwargs() {
    exists(Function func | func.getKwarg() = this.getDefiningNode().getNode())
  }

  /** Gets the `Parameter` this `ParameterDefinition` represents. */
  Parameter getParameter() { result = this.getDefiningNode().getNode() }
}

/** A deletion of a variable `del v` */
class DeletionDefinition extends EssaNodeDefinition {
  DeletionDefinition() {
    SsaSource::deletion_definition(this.getSourceVariable(), this.getDefiningNode())
  }
}

/**
 * Definition of variable at the entry of a scope. Usually this represents the transfer of
 * a global or non-local variable from one scope to another.
 */
class ScopeEntryDefinition extends EssaNodeDefinition {
  ScopeEntryDefinition() {
    this.getDefiningNode() = this.getSourceVariable().getScopeEntryDefinition() and
    not this instanceof ImplicitSubModuleDefinition
  }

  override Scope getScope() { result.getEntryNode() = this.getDefiningNode() }
}

/** Possible redefinition of variable via `from ... import *` */
class ImportStarRefinement extends EssaNodeRefinement {
  ImportStarRefinement() {
    SsaSource::import_star_refinement(this.getSourceVariable(), _, this.getDefiningNode())
  }
}

/** Assignment of an attribute `obj.attr = val` */
class AttributeAssignment extends EssaNodeRefinement {
  AttributeAssignment() {
    SsaSource::attribute_assignment_refinement(this.getSourceVariable(), _, this.getDefiningNode())
  }

  string getName() { result = this.getDefiningNode().(AttrNode).getName() }

  ControlFlowNode getValue() { result = this.getDefiningNode().(DefinitionNode).getValue() }

  override string getRepresentation() {
    result =
      this.getAQlClass() + " '" + this.getName() + "'(" + this.getInput().getRepresentation() + ")"
    or
    not exists(this.getInput()) and
    result =
      this.getAQlClass() + " '" + this.getName() + "'(" + this.getSourceVariable().getName() + "??)"
  }
}

/** A use of a variable as an argument, `foo(v)`, which might modify the object referred to. */
class ArgumentRefinement extends EssaNodeRefinement {
  ControlFlowNode argument;

  ArgumentRefinement() {
    SsaSource::argument_refinement(this.getSourceVariable(), argument, this.getDefiningNode())
  }

  ControlFlowNode getArgument() { result = argument }

  CallNode getCall() { result = this.getDefiningNode() }
}

/** Deletion of an attribute `del obj.attr`. */
class EssaAttributeDeletion extends EssaNodeRefinement {
  EssaAttributeDeletion() {
    SsaSource::attribute_deletion_refinement(this.getSourceVariable(), _, this.getDefiningNode())
  }

  string getName() { result = this.getDefiningNode().(AttrNode).getName() }
}

/** A pi-node (guard) with only one successor. */
class SingleSuccessorGuard extends EssaNodeRefinement {
  SingleSuccessorGuard() {
    SsaSource::test_refinement(this.getSourceVariable(), _, this.getDefiningNode())
  }

  boolean getSense() {
    exists(this.getDefiningNode().getAFalseSuccessor()) and result = false
    or
    exists(this.getDefiningNode().getATrueSuccessor()) and result = true
  }

  override string getRepresentation() {
    result = EssaNodeRefinement.super.getRepresentation() + " [" + this.getSense().toString() + "]"
    or
    not exists(this.getSense()) and
    result = EssaNodeRefinement.super.getRepresentation() + " [??]"
  }

  ControlFlowNode getTest() { result = this.getDefiningNode() }

  predicate useAndTest(ControlFlowNode use, ControlFlowNode test) {
    test = this.getDefiningNode() and
    SsaSource::test_refinement(this.getSourceVariable(), use, test)
  }
}

/**
 * Implicit definition of the names of sub-modules in a package.
 * Although the interpreter does not pre-define these names, merely populating them
 * as they are imported, this is a good approximation for static analysis.
 */
class ImplicitSubModuleDefinition extends EssaNodeDefinition {
  ImplicitSubModuleDefinition() {
    SsaSource::init_module_submodule_defn(this.getSourceVariable(), this.getDefiningNode())
  }
}

/** An implicit (possible) definition of an escaping variable at a call-site */
class CallsiteRefinement extends EssaNodeRefinement {
  override string toString() { result = "CallsiteRefinement" }

  CallsiteRefinement() {
    exists(SsaSourceVariable var, ControlFlowNode defn |
      defn = var.redefinedAtCallSite() and
      this.definedBy(var, defn) and
      not this instanceof ArgumentRefinement and
      not this instanceof MethodCallsiteRefinement and
      not this instanceof SingleSuccessorGuard
    )
  }

  CallNode getCall() { this.getDefiningNode() = result }
}

/** An implicit (possible) modification of the object referred at a method call */
class MethodCallsiteRefinement extends EssaNodeRefinement {
  MethodCallsiteRefinement() {
    SsaSource::method_call_refinement(this.getSourceVariable(), _, this.getDefiningNode()) and
    not this instanceof SingleSuccessorGuard
  }

  CallNode getCall() { this.getDefiningNode() = result }
}

/** An implicit (possible) modification of `self` at a method call */
class SelfCallsiteRefinement extends MethodCallsiteRefinement {
  SelfCallsiteRefinement() { this.getSourceVariable().(Variable).isSelf() }
}

/** Python specific sub-class of generic EssaEdgeRefinement */
class PyEdgeRefinement extends EssaEdgeRefinement {
  override string getRepresentation() {
    /*
     * This is for testing so use capital 'P' to make it sort before 'phi' and
     * be more visually distinctive.
     */

    result = "Pi(" + this.getInput().getRepresentation() + ") [" + this.getSense() + "]"
    or
    not exists(this.getInput()) and
    result = "Pi(" + this.getSourceVariable().getName() + "??) [" + this.getSense() + "]"
  }

  ControlFlowNode getTest() { result = this.getPredecessor().getLastNode() }
}
