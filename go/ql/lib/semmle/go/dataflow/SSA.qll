/**
 * Provides classes for working with static single assignment form (SSA).
 */
overlay[local]
module;

import go
private import SsaImpl
import SsaImpl::Ssa as Ssa
import Ssa

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
 * DEPRECATED: Use `SsaDefinition` instead.
 *
 * An SSA variable.
 */
deprecated class SsaVariable extends SsaDefinition {
  /** Gets the unique definition of this SSA variable. */
  SsaDefinition getDefinition() { result = this }

  /** Gets the type of this SSA variable. */
  Type getType() { result = this.getSourceVariable().getType() }

  /** Gets a use in basic block `bb` that refers to this SSA variable. */
  IR::Instruction getAUseIn(BasicBlock bb) {
    exists(int i, SsaSourceVariable v | v = this.getSourceVariable() |
      result = bb.getNode(i) and
      ssaDefReachesRead(v, this, bb, i) and
      useAt(bb, i, v)
    )
  }

  /**
   * DEPRECATED: Use `getARead()` instead.
   *
   * Gets a use that refers to this SSA variable.
   */
  deprecated IR::Instruction getAUse() { result = this.getAUseIn(_) }

  /** Gets the innermost function or file to which this SSA variable belongs. */
  ControlFlow::Root getRoot() { result = this.getBasicBlock().getScope() }

  /**
   * Gets the first instruction that the value of this SSA variable can reach without passing
   * through any other instructions, but possibly through phi nodes.
   */
  IR::Instruction getAFirstUse() { firstUse(this, result) }

  /**
   * INTERNAL: Do not use.
   *
   * Gets a short string identifying the kind of this SSA variable.
   */
  string getKind() {
    this instanceof SsaExplicitWrite and result = "def"
    or
    this instanceof SsaUncertainWrite and result = "capture"
    or
    this instanceof SsaPhiDefinition and result = "phi"
  }

  /**
   * DEPRECATED: Use `getLocation()` instead.
   *
   * Holds if this element is at the specified location.
   */
  deprecated predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/**
 * DEPRECATED: Use `SsaExplicitWrite` instead.
 *
 * An SSA definition that corresponds to an explicit assignment or other variable definition.
 */
deprecated class SsaExplicitDefinition extends SsaVariable instanceof SsaExplicitWrite {
  /** Gets the instruction where the definition happens. */
  IR::Instruction getInstruction() { result = this.(SsaExplicitWrite).getDefinition() }

  /** Gets the right-hand side of the definition. */
  IR::Instruction getRhs() { result = this.getInstruction().(IR::WriteInstruction).getRhs() }
}

/** Provides a deprecated helper for working with explicit SSA definitions. */
deprecated module SsaExplicitDefinition {
  /** Gets the SSA definition corresponding to definition `def`. */
  SsaExplicitDefinition of(IR::Instruction def) { result.getInstruction() = def }
}

/**
 * DEPRECATED: Use `SsaUncertainWrite` or `SsaPhiDefinition` instead.
 *
 * An SSA definition that does not correspond to an explicit variable definition.
 */
deprecated class SsaImplicitDefinition extends SsaVariable {
  SsaImplicitDefinition() { this instanceof SsaUncertainWrite or this instanceof SsaPhiDefinition }
}

/**
 * DEPRECATED: Use `SsaUncertainWrite` instead.
 *
 * An SSA definition representing the capturing of an SSA-convertible variable.
 */
deprecated class SsaVariableCapture extends SsaImplicitDefinition instanceof SsaUncertainWrite { }

/**
 * DEPRECATED: Use `SsaPhiDefinition` instead.
 *
 * An SSA definition that merges data flow.
 */
deprecated class SsaPseudoDefinition extends SsaImplicitDefinition instanceof SsaPhiDefinition {
  /** Gets an input of this pseudo-definition. */
  SsaVariable getAnInput() { result = this.(SsaPhiDefinition).getAnInput() }
}

/**
 * DEPRECATED: Use `SsaPhiDefinition` instead.
 *
 * An SSA phi definition.
 */
deprecated class SsaPhiNode extends SsaPseudoDefinition { }

/**
 * An SSA variable, possibly with a chain of field reads on it.
 */
private newtype TSsaWithFields =
  TRoot(SsaDefinition def) or
  TStep(SsaWithFields base, Field f) { exists(accessPathAux(base, f)) }

/**
 * Gets a representation of `insn` as an ssa-with-fields value if there is one.
 */
private TSsaWithFields accessPath(IR::Instruction insn) {
  exists(SsaDefinition def |
    insn.(IR::EvalInstruction).getExpr() = def.getARead() and
    result = TRoot(def)
  )
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
  SsaDefinition getBaseDefinition() {
    this = TRoot(result)
    or
    exists(SsaWithFields base | this = TStep(base, _) | result = base.getBaseDefinition())
  }

  /** Gets a use that refers to this SSA variable with fields. */
  DataFlow::Node getAUse() { this = accessPath(result.asInstruction()) }

  /** Gets the type of this SSA variable with fields. */
  Type getType() {
    exists(SsaDefinition def | this = TRoot(def) | result = def.getSourceVariable().getType())
    or
    exists(Field f | this = TStep(_, f) | result = f.getType())
  }

  /** Gets a textual representation of this element. */
  string toString() {
    exists(SsaDefinition def | this = TRoot(def) | result = "(" + def + ")")
    or
    exists(SsaWithFields base, Field f | this = TStep(base, f) | result = base + "." + f.getName())
  }

  /**
   * Gets an SSA-with-fields variable that is similar to this SSA-with-fields variable in the
   * sense that it has the same root variable and the same sequence of field accesses.
   */
  SsaWithFields similar() {
    result.getBaseDefinition().getSourceVariable() = this.getBaseDefinition().getSourceVariable() and
    result.getQualifiedName() = this.getQualifiedName()
  }

  /**
   * Gets the qualified name of the source variable or variable and fields that this represents.
   *
   * For example, for an SSA variable that represents the field `a.b`, this would get the string
   * `"a.b"`.
   */
  string getQualifiedName() {
    exists(SsaDefinition def | this = TRoot(def) and result = def.getSourceVariable().getName())
    or
    exists(SsaWithFields base, Field f | this = TStep(base, f) |
      result = base.getQualifiedName() + "." + f.getName()
    )
  }

  /** Gets the location of this SSA variable with fields. */
  Location getLocation() { result = this.getBaseDefinition().getLocation() }

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
