/**
 * Provides the JavaScript-facing static single assignment (SSA) API.
 *
 * Definitions, liveness, phi insertion, and reaching definitions are computed
 * by the shared SSA library. These classes retain the JavaScript API and
 * presentation of explicit writes, implicit initializations, captures, and
 * value-preserving refinements.
 *
 * Captured variables are conservatively recaptured at entry to a capturing
 * function, at yields, and at calls that may observe non-local assignments.
 * The global data-flow library separately uses shared variable-capture flow
 * where more precise call-graph information is available.
 */
overlay[local?]
module;

import javascript
private import semmle.javascript.dataflow.Refinements
private import semmle.javascript.dataflow.internal.sharedlib.Ssa as Shared

/** A variable that can be SSA converted, that is, a local variable. */
class SsaSourceVariable extends LocalVariable { }

final private class NativeDefinition = Shared::Definition;

/** An SSA variable, represented by its shared SSA definition. */
class SsaVariable instanceof SsaDefinition {
  /** Gets the source variable corresponding to this SSA variable. */
  SsaSourceVariable getSourceVariable() { result = this.getDefinition().getSourceVariable() }

  /** Gets the unique definition of this SSA variable. */
  SsaDefinition getDefinition() { result = this }

  /** Gets a use in basic block `bb` that refers to this SSA variable. */
  VarUse getAUseIn(ReachableBasicBlock bb) {
    exists(int i, Shared::SsaConfig::SourceVariable variable |
      variable.asLocalVariable() = this.getSourceVariable() and
      bb.useAt(i, this.getSourceVariable(), result) and
      Shared::ssaDefReachesRead(variable, this, bb, i)
    )
  }

  /** Gets a use that refers to this SSA variable. */
  VarUse getAUse() { result = this.getAUseIn(_) }

  /** Gets a textual representation of this element. */
  string toString() { result = this.getDefinition().prettyPrintRef() }

  /** Gets the location of this SSA variable. */
  Location getLocation() { result = this.getDefinition().getLocation() }

  /** DEPRECATED. Use `getLocation().hasLocationInfo()` instead. */
  deprecated predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/** An SSA definition backed by the shared SSA implementation. */
class SsaDefinition instanceof NativeDefinition {
  SsaDefinition() { exists(this.(NativeDefinition).getSourceVariable().asLocalVariable()) }

  /** Gets the SSA variable defined by this definition. */
  SsaVariable getVariable() { result = this }

  /** Gets the source variable defined by this definition. */
  SsaSourceVariable getSourceVariable() {
    result = this.(NativeDefinition).getSourceVariable().asLocalVariable()
  }

  /** Gets the basic block to which this definition belongs. */
  ReachableBasicBlock getBasicBlock() { result = this.(NativeDefinition).getBasicBlock() }

  /**
   * INTERNAL: Use `getBasicBlock()` and `getSourceVariable()` instead.
   *
   * Holds if this defines `v` at index `idx` in `bb`. Implicit initializations
   * retain their JavaScript API index of zero; shared SSA stores them at -1.
   */
  predicate definesAt(ReachableBasicBlock bb, int idx, SsaSourceVariable v) {
    exists(Shared::SsaConfig::SourceVariable variable, int nativeIndex |
      this.(NativeDefinition).definesAt(variable, bb, nativeIndex) and
      variable.asLocalVariable() = v and
      if this instanceof SsaImplicitInit then idx = 0 else idx = nativeIndex
    )
  }

  /** Gets a variable definition contributing to this SSA definition. */
  abstract VarDef getAContributingVarDef();

  /** INTERNAL: Use `toString()` instead. */
  abstract string prettyPrintDef();

  /** INTERNAL: Do not use. */
  abstract string prettyPrintRef();

  /** Gets a textual representation of this element. */
  string toString() { result = this.prettyPrintDef() }

  /** DEPRECATED. Use `getLocation().hasLocationInfo()` instead. */
  deprecated predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /** Gets the location of this element. */
  Location getLocation() { result = this.getBasicBlock().getLocation() }

  /** Gets the function or toplevel to which this definition belongs. */
  StmtContainer getContainer() { result = this.getBasicBlock().getContainer() }
}

/** An SSA definition corresponding to an explicit variable definition. */
class SsaExplicitDefinition extends SsaDefinition {
  SsaExplicitDefinition() {
    exists(Shared::SsaConfig::SourceVariable variable, BasicBlock bb, int i |
      this.(Shared::WriteDefinition).definesAt(variable, bb, i) and
      bb.defAt(i, variable.asLocalVariable(), _)
    )
  }

  /** Holds if this corresponds to the definition of `v` at `def`. */
  predicate defines(VarDef def, SsaSourceVariable v) {
    def = this.getDef() and v = this.getSourceVariable()
  }

  /** Gets the variable definition wrapped by this SSA definition. */
  VarDef getDef() {
    exists(Shared::SsaConfig::SourceVariable variable, BasicBlock bb, int i |
      this.(Shared::WriteDefinition).definesAt(variable, bb, i) and
      bb.defAt(i, variable.asLocalVariable(), result)
    )
  }

  /** Gets the variable reference on the left-hand side of this assignment. */
  VarRef getLhs() {
    exists(Shared::SsaConfig::SourceVariable variable, BasicBlock bb, int i |
      this.(Shared::WriteDefinition).definesAt(variable, bb, i) and
      bb.defAt(i, variable.asLocalVariable(), this.getDef(), result)
    )
  }

  override VarDef getAContributingVarDef() { result = this.getDef() }

  override string prettyPrintRef() {
    exists(int line, int column |
      this.getLocation().hasLocationInfo(_, line, column, _, _) and
      result = "def@" + line + ":" + column
    )
  }

  override string prettyPrintDef() { result = this.getDef().toString() }

  override Location getLocation() { result = this.getLhs().getLocation() }

  /** Gets the incoming value assigned at this definition, if any. */
  DataFlow::Node getRhsNode() {
    result = DataFlow::ssaDefinitionNode(this).getImmediatePredecessor()
  }
}

/** An SSA definition that does not correspond to an explicit variable definition. */
abstract class SsaImplicitDefinition extends SsaDefinition {
  /** INTERNAL: Gets the definition kind used in `prettyPrintRef`. */
  abstract string getKind();

  override string prettyPrintRef() {
    exists(int line, int column |
      this.getLocation().hasLocationInfo(_, line, column, _, _) and
      result = this.getKind() + "@" + line + ":" + column
    )
  }
}

/** The implicit initialization of a variable at the beginning of its scope. */
class SsaImplicitInit extends SsaImplicitDefinition {
  SsaImplicitInit() { this.(Shared::WriteDefinition).definesAt(_, any(EntryBasicBlock bb), -1) }

  override string getKind() { result = "implicitInit" }

  override VarDef getAContributingVarDef() { none() }

  override string prettyPrintDef() {
    result = "implicit initialization of " + this.getSourceVariable()
  }
}

/** A conservative capture or recapture of a variable from an enclosing scope. */
class SsaVariableCapture extends SsaImplicitDefinition {
  SsaVariableCapture() { Shared::isCaptureDefinition(this) }

  override VarDef getAContributingVarDef() { result.getAVariable() = this.getSourceVariable() }

  override string getKind() { result = "capture" }

  override string prettyPrintDef() { result = "capture variable " + this.getSourceVariable() }
}

/** A definition that merges or refines incoming SSA values. */
abstract class SsaPseudoDefinition extends SsaImplicitDefinition {
  /** Gets an input of this pseudo-definition. */
  cached
  abstract SsaVariable getAnInput();

  override VarDef getAContributingVarDef() {
    result = this.getAnInput().getDefinition().getAContributingVarDef()
  }

  /** Gets a textual representation of the inputs in lexicographical order. */
  string ppInputs() { result = concat(this.getAnInput().getDefinition().prettyPrintRef(), ", ") }
}

/** A phi definition from the shared SSA implementation. */
class SsaPhiNode extends SsaPseudoDefinition instanceof Shared::PhiNode {
  /** Gets the input arriving from predecessor block `bb`. */
  cached
  SsaVariable getInputFromBlock(BasicBlock bb) { Shared::phiHasInputFromBlock(this, result, bb) }

  override SsaVariable getAnInput() { result = this.getInputFromBlock(_) }

  override string getKind() { result = "phi" }

  override string prettyPrintDef() {
    result = this.getSourceVariable() + " = phi(" + this.ppInputs() + ")"
  }

  /** Gets the variable of which all inputs are transitive refinements, if any. */
  SsaVariable getRephinedVariable() {
    forex(SsaVariable input | input = this.getAnInput() | result = getRefinedVariable(input))
  }
}

private SsaVariable getRefinedVariable(SsaVariable variable) {
  result = getRefinedVariable(variable.(SsaRefinementNode).getAnInput())
  or
  result = getRefinedVariable(variable.(SsaPhiNode).getRephinedVariable())
  or
  not variable instanceof SsaRefinementNode and
  not variable instanceof SsaPhiNode and
  result = variable
}

/** A shared uncertain write preserving the incoming value under a refinement. */
class SsaRefinementNode extends SsaPseudoDefinition {
  SsaRefinementNode() { Shared::isRefinementDefinition(this) }

  /** Gets the guard inducing this refinement. */
  GuardControlFlowNode getGuard() {
    exists(BasicBlock bb, int i |
      this.(NativeDefinition).definesAt(_, bb, i) and result = bb.getNode(i)
    )
  }

  /** Gets the refinement associated with this definition. */
  Refinement getRefinement() { result = this.getGuard().getTest() }

  override SsaVariable getAnInput() { Shared::uncertainWriteDefinitionInput(this, result) }

  override string getKind() { result = "refine[" + this.getGuard() + "]" }

  override string prettyPrintDef() {
    result =
      this.getSourceVariable() + " = refine[" + this.getGuard() + "](" + this.ppInputs() + ")"
  }

  override Location getLocation() { result = this.getGuard().getLocation() }
}

module Ssa {
  /** Gets the definition of the implicit initialization of `v`. */
  SsaImplicitInit implicitInit(SsaSourceVariable v) { result.getSourceVariable() = v }

  /** Gets the SSA definition corresponding to `d`. */
  SsaExplicitDefinition definition(VarDef d) { result.getDef() = d }

  /** Gets the SSA variable corresponding to `d`. */
  SsaVariable variable(VarDef d) { result.getDefinition() = definition(d) }
}
