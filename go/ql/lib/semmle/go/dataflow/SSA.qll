/**
 * Provides classes for working with static single assignment form (SSA).
 */

import go
private import SsaImpl

/**
 * A variable that can be SSA converted, that is, a local variable, but not a variable
 * declared in file scope.
 */
class SsaSourceVariable extends LocalVariable {
  SsaSourceVariable() { not this.getScope() instanceof FileScope }

  /**
   * Holds if there may be indirect references of this variable that are not covered by `getAReference()`.
   *
   * This is the case for variables that have their address taken, and for variables whose
   * name resolution information may be incomplete (for instance due to an extractor error).
   */
  predicate mayHaveIndirectReferences() {
    // variables that have their address taken
    exists(AddressExpr addr | addr.getOperand().stripParens() = this.getAReference())
    or
    exists(DataFlow::MethodReadNode mrn |
      mrn.getReceiver() = this.getARead() and
      mrn.getMethod().getReceiverType() instanceof PointerType
    )
    or
    // variables where there is an unresolved reference with the same name in the same
    // scope or a nested scope, suggesting that name resolution information may be incomplete
    exists(FunctionScope scope, FuncDef inner |
      scope = this.getScope().(LocalScope).getEnclosingFunctionScope() and
      unresolvedReference(this.getName(), inner) and
      inner.getScope().getOuterScope*() = scope
    )
  }
}

/**
 * Holds if there is an unresolved reference to `name` in `fn`.
 */
private predicate unresolvedReference(string name, FuncDef fn) {
  exists(Ident unresolved |
    unresolvedIdentifier(unresolved, name) and
    not unresolved = any(SelectorExpr sel).getSelector() and
    fn = unresolved.getEnclosingFunction()
  )
}

/**
 * Holds if `id` is an unresolved identifier with the given `name`.
 */
pragma[noinline]
private predicate unresolvedIdentifier(Ident id, string name) {
  id.getName() = name and
  id instanceof ReferenceExpr and
  not id.refersTo(_)
}

/**
 * An SSA variable.
 */
class SsaVariable extends TSsaDefinition {
  /** Gets the source variable corresponding to this SSA variable. */
  SsaSourceVariable getSourceVariable() { result = this.(SsaDefinition).getSourceVariable() }

  /** Gets the (unique) definition of this SSA variable. */
  SsaDefinition getDefinition() { result = this }

  /** Gets the type of this SSA variable. */
  Type getType() { result = this.getSourceVariable().getType() }

  /** Gets a use in basic block `bb` that refers to this SSA variable. */
  IR::Instruction getAUseIn(ReachableBasicBlock bb) {
    exists(int i, SsaSourceVariable v | v = this.getSourceVariable() |
      result = bb.getNode(i) and
      this = getDefinition(bb, i, v)
    )
  }

  /** Gets a use that refers to this SSA variable. */
  IR::Instruction getAUse() { result = this.getAUseIn(_) }

  /** Gets a textual representation of this element. */
  string toString() { result = this.getDefinition().prettyPrintRef() }

  /** Gets the location of this SSA variable. */
  Location getLocation() { result = this.getDefinition().getLocation() }

  /**
   * DEPRECATED: Use `getLocation()` instead.
   *
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  deprecated predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/**
 * An SSA definition.
 */
class SsaDefinition extends TSsaDefinition {
  /** Gets the SSA variable defined by this definition. */
  SsaVariable getVariable() { result = this }

  /** Gets the source variable defined by this definition. */
  abstract SsaSourceVariable getSourceVariable();

  /**
   * Gets the basic block to which this definition belongs.
   */
  abstract ReachableBasicBlock getBasicBlock();

  /**
   * INTERNAL: Use `getBasicBlock()` and `getSourceVariable()` instead.
   *
   * Holds if this is a definition of source variable `v` at index `idx` in basic block `bb`.
   *
   * Phi nodes are considered to be at index `-1`, all other definitions at the index of
   * the control flow node they correspond to.
   */
  abstract predicate definesAt(SsaSourceVariable v, ReachableBasicBlock bb, int idx);

  /**
   * INTERNAL: Use `toString()` instead.
   *
   * Gets a pretty-printed representation of this SSA definition.
   */
  abstract string prettyPrintDef();

  /**
   * INTERNAL: Do not use.
   *
   * Gets a pretty-printed representation of a reference to this SSA definition.
   */
  abstract string prettyPrintRef();

  /** Gets the innermost function or file to which this SSA definition belongs. */
  ControlFlow::Root getRoot() { result = this.getBasicBlock().getRoot() }

  /** Gets a textual representation of this element. */
  string toString() { result = this.prettyPrintDef() }

  /** Gets the source location for this element. */
  abstract Location getLocation();

  /**
   * DEPRECATED: Use `getLocation()` instead.
   *
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  deprecated predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /**
   * Gets the first instruction that the value of this `SsaDefinition` can
   * reach without passing through any other instructions, but possibly through
   * phi nodes.
   */
  IR::Instruction getAFirstUse() { firstUse(this, result) }
}

/**
 * An SSA definition that corresponds to an explicit assignment or other variable definition.
 */
class SsaExplicitDefinition extends SsaDefinition, TExplicitDef {
  /** Gets the instruction where the definition happens. */
  IR::Instruction getInstruction() {
    exists(BasicBlock bb, int i | this = TExplicitDef(bb, i, _) | result = bb.getNode(i))
  }

  /** Gets the right-hand side of the definition. */
  IR::Instruction getRhs() { this.getInstruction().writes(_, result) }

  override predicate definesAt(SsaSourceVariable v, ReachableBasicBlock bb, int i) {
    this = TExplicitDef(bb, i, v)
  }

  override ReachableBasicBlock getBasicBlock() { this.definesAt(_, result, _) }

  override SsaSourceVariable getSourceVariable() { this.definesAt(result, _, _) }

  override string prettyPrintRef() {
    exists(Location loc | loc = this.getLocation() |
      result = "def@" + loc.getStartLine() + ":" + loc.getStartColumn()
    )
  }

  override string prettyPrintDef() { result = "definition of " + this.getSourceVariable() }

  override Location getLocation() { result = this.getInstruction().getLocation() }
}

/** Provides a helper predicate for working with explicit SSA definitions. */
module SsaExplicitDefinition {
  /**
   * Gets the SSA definition corresponding to definition `def`.
   */
  SsaExplicitDefinition of(IR::Instruction def) { result.getInstruction() = def }
}

/**
 * An SSA definition that does not correspond to an explicit variable definition.
 */
abstract class SsaImplicitDefinition extends SsaDefinition {
  /**
   * INTERNAL: Do not use.
   *
   * Gets the definition kind to include in `prettyPrintRef`.
   */
  abstract string getKind();

  override string prettyPrintRef() {
    exists(Location loc | loc = this.getLocation() |
      result = this.getKind() + "@" + loc.getStartLine() + ":" + loc.getStartColumn()
    )
  }

  override Location getLocation() { result = this.getBasicBlock().getLocation() }
}

/**
 * An SSA definition representing the capturing of an SSA-convertible variable
 * in the closure of a nested function.
 *
 * Capturing definitions appear at the beginning of such functions, as well as
 * at any function call that may affect the value of the variable.
 */
class SsaVariableCapture extends SsaImplicitDefinition, TCapture {
  override predicate definesAt(SsaSourceVariable v, ReachableBasicBlock bb, int i) {
    this = TCapture(bb, i, v)
  }

  override ReachableBasicBlock getBasicBlock() { this.definesAt(_, result, _) }

  override SsaSourceVariable getSourceVariable() { this.definesAt(result, _, _) }

  override string getKind() { result = "capture" }

  override string prettyPrintDef() { result = "capture variable " + this.getSourceVariable() }

  override Location getLocation() {
    exists(ReachableBasicBlock bb, int i | this.definesAt(_, bb, i) |
      result = bb.getNode(i).getLocation()
    )
  }
}

/**
 * An SSA definition such as a phi node that has no actual semantics, but simply serves to
 * merge or filter data flow.
 */
abstract class SsaPseudoDefinition extends SsaImplicitDefinition {
  /**
   * Gets an input of this pseudo-definition.
   */
  abstract SsaVariable getAnInput();

  /**
   * Gets a textual representation of the inputs of this pseudo-definition
   * in lexicographical order.
   */
  string ppInputs() { result = concat(this.getAnInput().getDefinition().prettyPrintRef(), ", ") }
}

/**
 * An SSA phi node, that is, a pseudo-definition for a variable at a point
 * in the flow graph where otherwise two or more definitions for the variable
 * would be visible.
 */
class SsaPhiNode extends SsaPseudoDefinition, TPhi {
  override SsaVariable getAnInput() {
    result = getDefReachingEndOf(this.getBasicBlock().getAPredecessor(), this.getSourceVariable())
  }

  override predicate definesAt(SsaSourceVariable v, ReachableBasicBlock bb, int i) {
    bb = this.getBasicBlock() and v = this.getSourceVariable() and i = -1
  }

  override ReachableBasicBlock getBasicBlock() { this = TPhi(result, _) }

  override SsaSourceVariable getSourceVariable() { this = TPhi(_, result) }

  override string getKind() { result = "phi" }

  override string prettyPrintDef() {
    result = this.getSourceVariable() + " = phi(" + this.ppInputs() + ")"
  }

  override Location getLocation() { result = this.getBasicBlock().getLocation() }
}

/**
 * An SSA variable, possibly with a chain of field reads on it.
 */
private newtype TSsaWithFields =
  TRoot(SsaVariable v) or
  TStep(SsaWithFields base, Field f) { exists(accessPathAux(base, f)) }

/**
 * Gets a representation of `insn` as an ssa-with-fields value if there is one.
 */
private TSsaWithFields accessPath(IR::Instruction insn) {
  exists(SsaVariable v | insn = v.getAUse() | result = TRoot(v))
  or
  exists(SsaWithFields base, Field f | insn = accessPathAux(base, f) | result = TStep(base, f))
}

/**
 * Gets a data-flow node that reads a field `f` from a node that is represented
 * by ssa-with-fields value `base`.
 */
private IR::Instruction accessPathAux(TSsaWithFields base, Field f) {
  exists(IR::FieldReadInstruction fr, IR::Instruction frb |
    fr.getBase() = frb or
    fr.getBase() = IR::implicitDerefInstruction(frb.(IR::EvalInstruction).getExpr())
  |
    base = accessPath(frb) and
    f = fr.getField() and
    result = fr
  )
}

/** An SSA variable with zero or more fields read from it. */
class SsaWithFields extends TSsaWithFields {
  /**
   * Gets the SSA variable corresponding to the base of this SSA variable with fields.
   *
   * For example, the SSA variable corresponding to `a` for the SSA variable with fields
   * corresponding to `a.b`.
   */
  SsaVariable getBaseVariable() {
    this = TRoot(result)
    or
    exists(SsaWithFields base | this = TStep(base, _) | result = base.getBaseVariable())
  }

  /** Gets a use that refers to this SSA variable with fields. */
  DataFlow::Node getAUse() { this = accessPath(result.asInstruction()) }

  /** Gets the type of this SSA variable with fields. */
  Type getType() {
    exists(SsaVariable var | this = TRoot(var) | result = var.getType())
    or
    exists(Field f | this = TStep(_, f) | result = f.getType())
  }

  /** Gets a textual representation of this element. */
  string toString() {
    exists(SsaVariable var | this = TRoot(var) | result = "(" + var + ")")
    or
    exists(SsaWithFields base, Field f | this = TStep(base, f) | result = base + "." + f.getName())
  }

  /**
   * Gets an SSA-with-fields variable that is similar to this SSA-with-fields variable in the
   * sense that it has the same root variable and the same sequence of field accesses.
   */
  SsaWithFields similar() {
    result.getBaseVariable().getSourceVariable() = this.getBaseVariable().getSourceVariable() and
    result.getQualifiedName() = this.getQualifiedName()
  }

  /**
   * Gets the qualified name of the source variable or variable and fields that this represents.
   *
   * For example, for an SSA variable that represents the field `a.b`, this would get the string
   * `"a.b"`.
   */
  string getQualifiedName() {
    exists(SsaVariable v | this = TRoot(v) and result = v.getSourceVariable().getName())
    or
    exists(SsaWithFields base, Field f | this = TStep(base, f) |
      result = base.getQualifiedName() + "." + f.getName()
    )
  }

  /** Gets the location of this SSA variable with fields. */
  Location getLocation() { result = this.getBaseVariable().getLocation() }

  /**
   * DEPRECATED: Use `getLocation()` instead.
   *
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  deprecated predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/**
 * Gets a read similar to `node`, according to the same rules as `SsaWithFields.similar()`.
 */
DataFlow::Node getASimilarReadNode(DataFlow::Node node) {
  exists(SsaWithFields readFields | node = readFields.getAUse() |
    result = readFields.similar().getAUse()
  )
}

/**
 * Gets an instruction such that  `pred` and `result` form an adjacent
 * use-use-pair of the same`SsaSourceVariable`, that is, the value read in
 * `pred` can reach `result` without passing through any other use or any SSA
 * definition of the variable except for phi nodes and uncertain implicit
 * updates.
 */
IR::Instruction getAnAdjacentUse(IR::Instruction pred) { adjacentUseUse(pred, result) }
