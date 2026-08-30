/**
 * Provides the Python SSA implementation built on the new (shared) CFG.
 *
 * Mirrors the Java SSA adapter at
 * `java/ql/lib/semmle/code/java/dataflow/internal/SsaImpl.qll`:
 * an `InputSig` is defined in terms of positional `(BasicBlock, int)`
 * variable references, and the shared
 * `codeql.ssa.Ssa::Make<Location, Cfg, Input>` module is then
 * instantiated.
 *
 * `SourceVariable` is the AST-level `Py::Variable`. Variable references
 * are looked up via the CFG facade's `NameNode.defines`/`uses`/`deletes`
 * predicates, which themselves are one-line bridges to AST-level
 * `Name.defines`/`uses`/`deletes`.
 *
 * Implicit-entry definitions are inserted for:
 *   - non-local / global / builtin variables that are read in the scope
 *     but never assigned (no enclosing CFG node defines them),
 *   - captured variables (variables defined in an enclosing scope that
 *     are read inside the scope), and
 *   - parameters, but only if the corresponding parameter name is *not*
 *     itself a CFG node. With the C#-style parameter wiring already
 *     installed in `AstNodeImpl.qll`, parameter names *are* CFG nodes,
 *     so the regular `variableWrite` path handles them — no `i = -1`
 *     entry is needed for ordinary parameters.
 */
overlay[local?]
module;

private import python as Py
private import semmle.python.controlflow.internal.AstNodeImpl as CfgImpl
private import semmle.python.controlflow.internal.Cfg as Cfg
private import codeql.ssa.Ssa as SsaImplCommon
private import codeql.controlflow.BasicBlock as BB

/**
 * A source variable for SSA, wrapping a Python AST `Variable`.
 *
 * We only track variables that are read at least once in their scope —
 * tracking write-only variables would be unnecessary work — *except*
 * for module-scope globals, where the "read" can be external (e.g.
 * `import mymodule; mymodule.x`). Such globals are tracked
 * unconditionally so that import-resolution can find their defining
 * write.
 */
private newtype TSsaSourceVariable =
  TPyVar(Py::Variable v) {
    not v.getALoad() instanceof Py::NameConstant and
    (
      // Has a use somewhere — read-relevant for SSA.
      exists(Cfg::NameNode n | n.uses(v))
      or
      // Or has a deletion (treated as a write that destroys the value).
      exists(Cfg::NameNode n | n.deletes(v))
      or
      // Or is a module-scope global written in this module — must be
      // tracked even if never read locally, because importers may read
      // it as an attribute on the module object.
      v.getScope() instanceof Py::Module and
      exists(Cfg::NameNode n | n.defines(v))
      or
      // Or is a parameter — parameters must always have a
      // `ParameterDefinition` for dataflow argument-routing to work,
      // even if the parameter is never read in its scope. Mirrors
      // legacy ESSA's `ParameterDefinition` (which fired for every
      // parameter binding regardless of liveness).
      exists(Py::Parameter p | p.asName() = v.getAStore())
    )
  }

/**
 * A source variable for SSA, wrapping a Python AST `Variable`.
 */
class SsaSourceVariable extends TSsaSourceVariable {
  /** Gets the underlying Python AST variable. */
  Py::Variable getVariable() { this = TPyVar(result) }

  /** Gets the (textual) name of this variable. */
  string getName() { result = this.getVariable().getId() }

  /** Gets a textual representation of this source variable. */
  string toString() { result = this.getVariable().toString() }

  /** Gets the location of this source variable. */
  Py::Location getLocation() { result = this.getVariable().getScope().getLocation() }

  /** Gets the scope in which this variable lives. */
  Py::Scope getScope() { result = this.getVariable().getScope() }

  /**
   * Gets a use of this variable as it appears in the source — a `NameNode`
   * that loads or deletes the variable. Mirrors legacy
   * `SsaSourceVariable.getASourceUse()`.
   */
  Cfg::ControlFlowNode getASourceUse() {
    exists(Cfg::NameNode n | result = n |
      n.uses(this.getVariable()) or n.deletes(this.getVariable())
    )
  }

  /**
   * Gets an implicit use of this variable. The new SSA does not have
   * implicit-use refinements, but we keep this for API parity — every
   * normal-exit of the variable's scope counts as a sink, ensuring
   * variables stay live to scope exit for taint-tracking.
   */
  Cfg::ControlFlowNode getAnImplicitUse() {
    result.isNormalExit() and result.getScope() = this.getScope()
  }

  /**
   * Gets a use of this variable — either an explicit source use or an
   * implicit use at scope exit. Mirrors legacy `SsaSourceVariable.getAUse()`.
   */
  Cfg::ControlFlowNode getAUse() {
    result = this.getASourceUse() or result = this.getAnImplicitUse()
  }
}

/**
 * Holds if `v` is a non-local read in scope `s`, in the sense that `s`
 * uses `v` but does not write it within `s`. This includes globals,
 * builtins, and variables captured from an enclosing function scope.
 *
 * The `Py::Variable` `v` lives in some defining scope (the module for
 * globals, an outer function for closures, etc.); the reading scope
 * `s` is the scope where the use of `v` occurs.
 */
private predicate nonLocalReadIn(Py::Variable v, Py::Scope s) {
  exists(Cfg::NameNode n |
    n.uses(v) and
    n.getScope() = s and
    not exists(Cfg::NameNode def | def.defines(v) and def.getScope() = s)
  ) and
  // Match legacy ESSA: only create entry defs for variables that have
  // at least one defining store somewhere — otherwise the entry def
  // represents "nothing reaches here", which is the default anyway and
  // introduces no useful flow. (Legacy's `ModuleVariable` required a
  // store; this is the closure-aware generalisation.)
  exists(Cfg::NameNode store | store.defines(v))
}

/**
 * Holds if `bb` is the entry basic block of a scope where `v` should
 * have an implicit entry definition. This covers:
 *   - non-local / global / builtin variables read in `s`, and
 *   - captured variables (defined in an enclosing scope but read in `s`).
 *
 * Each reading scope gets its own entry def, so a closure variable can
 * have multiple entry defs across all functions/methods that read it.
 *
 * Parameters are *not* included: their bound `Name` is itself a CFG
 * node (per the C#-style parameter wiring), so `variableWrite` fires at
 * the parameter's natural CFG index.
 */
private predicate hasEntryDefIn(SsaSourceVariable v, CfgImpl::BasicBlock bb) {
  exists(Py::Scope s |
    nonLocalReadIn(v.getVariable(), s) and
    bb = entryBlock(s)
  )
}

/**
 * Gets the entry basic block of scope `s`, where implicit entry
 * definitions are placed (at synthetic index `-1`).
 */
private CfgImpl::BasicBlock entryBlock(Py::Scope s) {
  exists(CfgImpl::ControlFlowNode entry |
    entry instanceof CfgImpl::ControlFlow::EntryNode and
    entry.getEnclosingCallable().asScope() = s and
    result = entry.getBasicBlock()
  )
}

/**
 * The SSA `InputSig` for Python. References are positional
 * `(BasicBlock, int)` pairs into the new CFG.
 */
private module SsaImplInput implements SsaImplCommon::InputSig<Py::Location, CfgImpl::BasicBlock> {
  class SourceVariable = SsaSourceVariable;

  predicate variableWrite(CfgImpl::BasicBlock bb, int i, SourceVariable v, boolean certain) {
    // Explicit binding at a CFG node — includes assignments,
    // parameter Names (wired in via the C# pattern), exception-handler
    // `as`-bindings, import aliases, and match-pattern captures.
    exists(Cfg::NameNode n |
      bb.getNode(i) = n and
      n.defines(v.getVariable()) and
      certain = true
    )
    or
    // `del x` — removes the binding. modeled as a certain write that
    // makes any subsequent read invalid.
    exists(Cfg::NameNode n |
      bb.getNode(i) = n and
      n.deletes(v.getVariable()) and
      certain = true
    )
    or
    // Implicit entry definition for non-local / captured / global /
    // builtin variables read in some scope. Each reading scope's entry
    // block gets one such write, allowing closures: e.g. when `x` is a
    // parameter of an outer function and read inside a nested
    // function, both scopes get entry defs for `x`.
    hasEntryDefIn(v, bb) and
    i = -1 and
    certain = true
    or
    // `from X import *` — possibly rebinds every name in the importing
    // scope. modeled as an uncertain write at the import-star's CFG
    // position for every variable that lives in (or is referenced
    // from) the same scope as the import-star. Mirrors legacy ESSA's
    // `ImportStarRefinement` (see `essa/SsaDefinitions.qll`'s
    // `import_star_refinement` predicate). The write is uncertain so
    // that prior definitions of the variable remain available — the
    // shared-SSA `SsaUncertainWrite` merges the new value with the
    // immediately preceding definition.
    exists(Cfg::ImportStarNode imp |
      imp.injects(_) and
      bb.getNode(i) = imp and
      certain = false and
      (
        v.getVariable().getScope() = imp.getScope()
        or
        // Variable is defined in some other scope but referenced in
        // the same scope as the import-star (matches legacy clause 2:
        // `other.uses(v) and def.getScope() = other.getScope()`).
        exists(Cfg::NameNode other |
          other.uses(v.getVariable()) and
          imp.getScope() = other.getScope()
        )
      )
    )
  }

  predicate variableRead(CfgImpl::BasicBlock bb, int i, SourceVariable v, boolean certain) {
    // Explicit source use — a `Name` load or a `del x` of the variable.
    exists(Cfg::NameNode n |
      bb.getNode(i) = n and
      n.uses(v.getVariable()) and
      certain = true
    )
    or
    // Synthetic use at the normal exit of the variable's defining scope.
    // This keeps every variable live to scope exit so that callers (e.g.
    // `module_export` in ImportResolution.qll, or taint-tracking pass-through
    // through unread locals) can ask "which definition reaches end of
    // scope?". Mirrors legacy ESSA's `SsaSourceVariable.getAUse()` which
    // included `getScope().getANormalExit()`.
    exists(Cfg::ControlFlowNode exit |
      exit.isNormalExit() and
      exit.getScope() = v.getVariable().getScope() and
      bb.getNode(i) = exit and
      certain = true
    )
  }
}

import SsaImplCommon::MakeWithCachedLiveness<Py::Location, CfgImpl::Cfg, SsaImplInput> as Impl

// Matching the cases in `SsaImplInput.variableWrite` above
newtype TVariableWrite =
  TName(CfgImpl::Ast::Expr name, SsaSourceVariable v) {
    exists(Py::Name n | name.asExpr() = n and n.getVariable() = v.getVariable() |
      n.isDefinition() or
      n.isDeletion()
    )
  } or
  TImportStar(CfgImpl::Ast::Expr i, SsaSourceVariable v) {
    exists(Py::ImportStar imp | i.asExpr() = imp.getModuleExpr() |
      v.getScope() = imp.getScope()
      or
      exists(Py::Name other |
        other.uses(v.getVariable()) and
        imp.getScope() = other.getScope()
      )
    )
  }

private module SsaInput implements Impl::SsaInputSig {
  // private import java as J
  // class Expr = Py::Expr;
  class Expr extends CfgImpl::Ast::Expr {
    CfgImpl::Cfg::ControlFlowNode getControlFlowNode() { result.injects(this) }
  }

  class Parameter = CfgImpl::Ast::Parameter;

  class VariableWrite extends TVariableWrite {
    Expr asExpr() {
      this = TName(result, _)
      or
      this = TImportStar(result, _)
    }

    Expr getValue() {
      exists(CfgImpl::Ast::Expr name, Py::Name n, Cfg::DefinitionNode def |
        this = TName(name, _) and name.asExpr() = n and def.getNode() = n
      |
        result.asExpr() = def.getValue().getNode()
      )
    }

    predicate isParameterInit(CfgImpl::Ast::Parameter p) { this = TName(p, _) }

    string toString() {
      exists(CfgImpl::Ast::Expr n | this = TName(n, _) | result = n.toString())
      or
      exists(CfgImpl::Ast::Expr imp | this = TImportStar(imp, _) | result = imp.toString())
    }

    Py::Location getLocation() {
      exists(CfgImpl::Ast::Expr n | this = TName(n, _) | result = n.getLocation())
      or
      exists(CfgImpl::Ast::Expr imp | this = TImportStar(imp, _) | result = imp.getLocation())
    }

    predicate writesAt(CfgImpl::BasicBlock bb, int i, SsaSourceVariable v) {
      exists(CfgImpl::Ast::Expr n |
        this = TName(n, v) and
        bb.getNode(i).getAstNode() = n
      )
      or
      exists(CfgImpl::Ast::Expr imp |
        this = TImportStar(imp, v) and
        bb.getNode(i).getAstNode() = imp
      )
    }
  }

  predicate explicitWrite(VariableWrite def, CfgImpl::Cfg::BasicBlock bb, int i, SsaSourceVariable v) {
    def.writesAt(bb, i, v)
  }
}

module Ssa = Impl::MakeSsa<SsaInput>;

final class Definition = Impl::Definition;

final class WriteDefinition = Impl::WriteDefinition;

final class UncertainWriteDefinition = Impl::UncertainWriteDefinition;

final class PhiNode = Impl::PhiNode;

// ===========================================================================
// ESSA-shaped adapter layer
//
// The dataflow library (`python/ql/lib/semmle/python/dataflow/new/`) and
// related modules (`ApiGraphs.qll`, etc.) consume the legacy ESSA API
// (`EssaVariable`, `EssaDefinition`, `AssignmentDefinition`,
// `ScopeEntryDefinition`, `ParameterDefinition`, `WithDefinition`,
// `PhiFunction`, plus the `AdjacentUses` module). To migrate them off
// the legacy CFG, we expose the same API surface on top of the
// shared SSA built above.
//
// This adapter is intentionally narrow: it covers only the predicates
// that new dataflow consumes. The richer legacy ESSA — refinement
// nodes, attribute refinements, edge refinements — stays available
// via `semmle.python.essa.Essa` for points-to / legacy code.
// ===========================================================================
/**
 * Gets the CFG node at which a write definition's binding takes place.
 *
 * For ordinary writes (assignment, deletion, parameter) this is the
 * canonical CFG node of the bound Name. For implicit entry definitions
 * (synthesised at position `-1` of a scope's entry BB) this is the
 * scope's entry node.
 */
private Cfg::ControlFlowNode writeDefNode(Ssa::SsaWriteDefinition def) {
  exists(CfgImpl::BasicBlock bb, int i | def.definesAt(_, bb, i) |
    i >= 0 and result = bb.getNode(i)
    or
    i = -1 and result = bb.getNode(0)
  )
}

/**
 * A write definition whose binding has a corresponding CFG node — i.e.
 * everything that's not a phi node. Mirrors legacy ESSA's
 * `EssaNodeDefinition`.
 */
class EssaNodeDefinition extends Ssa::SsaWriteDefinition {
  /** Gets the CFG node where this definition's binding takes place. */
  Cfg::ControlFlowNode getDefiningNode() { result = writeDefNode(this) }

  /** Gets the variable defined here (legacy name). */
  SsaSourceVariable getVariable() { result = this.getSourceVariable() }

  /** Gets the enclosing scope. */
  Py::Scope getScope() {
    exists(Cfg::ControlFlowNode n | n = this.getDefiningNode() | result = n.getScope())
  }

  /**
   * Holds if this definition defines source variable `v` at CFG node
   * `defNode`. Flatter form of `getSourceVariable()` +
   * `getDefiningNode()`, matching legacy ESSA's `definedBy`.
   */
  predicate definedBy(SsaSourceVariable v, Cfg::ControlFlowNode defNode) {
    v = this.getSourceVariable() and defNode = this.getDefiningNode()
  }
}

/**
 * An assignment definition: any binding where the value being assigned
 * is statically known via `Cfg::DefinitionNode.getValue()`. Includes
 * plain assignments, walrus, annotated assignments, augmented
 * assignments, import aliases (`import x` / `from m import x [as y]`),
 * `with ... as x`, and for-target bindings (where `getValue()` returns
 * the iter expression's CFG node). Excludes parameter bindings —
 * those are modeled by `ParameterDefinition`.
 */
class AssignmentDefinition extends EssaNodeDefinition {
  AssignmentDefinition() {
    exists(Cfg::NameNode n | n = this.getDefiningNode() |
      exists(n.(Cfg::DefinitionNode).getValue()) and
      not n.(Cfg::ControlFlowNode).isParameter()
    )
  }

  /** Gets the CFG node for the value being assigned, if statically known. */
  Cfg::ControlFlowNode getValue() {
    result = this.getDefiningNode().(Cfg::DefinitionNode).getValue()
  }
}

/**
 * A parameter definition — the binding of a parameter name in a
 * function's scope.
 */
class ParameterDefinition extends EssaNodeDefinition {
  ParameterDefinition() { this.getDefiningNode().isParameter() }

  /** Gets the AST `Parameter` (a `Py::Name` in param context). */
  Py::Name getParameter() { result = this.getDefiningNode().getNode() }
}

/**
 * A definition introduced by a `with ... as x:` clause.
 */
class WithDefinition extends EssaNodeDefinition {
  WithDefinition() {
    exists(Cfg::NameNode n, Py::With w |
      n = this.getDefiningNode() and
      w.getOptionalVars() = n.getNode()
    )
  }
}

/**
 * An assignment where the LHS is a tuple/list and the RHS is unpacked:
 * `a, b = (1, 2)` or `a, *rest = xs`. The SSA def lives at the inner
 * `Name` CFG node, but for IterableUnpacking integration we expose
 * the enclosing `StarredNode` as the `getDefiningNode()` for `*rest`
 * patterns — mirroring legacy ESSA's `multi_assignment_definition`,
 * which placed the def at the StarredNode CFG node.
 */
class MultiAssignmentDefinition extends EssaNodeDefinition {
  MultiAssignmentDefinition() {
    exists(Cfg::NameNode n | n = super.getDefiningNode() |
      exists(Py::Assign a, Py::Expr lhs |
        a.getATarget() = lhs and
        (lhs instanceof Py::Tuple or lhs instanceof Py::List) and
        lhs.getASubExpression+() = n.getNode()
      )
      or
      // For-loop with tuple/list target: `for a, b in xs:` —
      // tuple-unpacking semantics applies to the for-target.
      exists(Py::For f, Py::Expr lhs |
        f.getTarget() = lhs and
        (lhs instanceof Py::Tuple or lhs instanceof Py::List) and
        lhs.getASubExpression+() = n.getNode()
      )
    )
  }

  override Cfg::ControlFlowNode getDefiningNode() {
    // Default: the underlying `Name` CFG node (where the SSA def lives).
    not exists(Cfg::StarredNode s |
      s.getNode().(Py::Starred).getValue() = super.getDefiningNode().getNode()
    ) and
    result = super.getDefiningNode()
    or
    // Exception: for `*rest`, expose the enclosing `Starred` CFG node
    // so that `IterableUnpacking::iterableUnpackingStarredElementStoreStep`
    // can attach the rest-list to it.
    exists(Cfg::StarredNode s |
      s.getNode().(Py::Starred).getValue() = super.getDefiningNode().getNode()
    |
      result = s
    )
  }
}

/**
 * An implicit entry definition for a non-local / captured / global /
 * builtin variable read in a scope but not defined there.
 *
 * Inherits from `EssaNodeDefinition` and exposes the scope's entry node
 * as its defining node (matching legacy ESSA semantics).
 */
class ScopeEntryDefinition extends EssaNodeDefinition {
  ScopeEntryDefinition() {
    exists(CfgImpl::BasicBlock bb |
      this.definesAt(_, bb, -1) and
      bb instanceof CfgImpl::Cfg::EntryBasicBlock
    )
  }

  /** Gets the enclosing scope (the scope whose entry block this def is in). */
  override Py::Scope getScope() {
    exists(CfgImpl::BasicBlock bb |
      this.definesAt(_, bb, -1) and
      result = bb.getNode(0).(Cfg::ControlFlowNode).getScope()
    )
  }
}

/** A phi node (alias matching legacy naming). */
class PhiFunction extends PhiNode {
  /**
   * Gets an input to this phi function (a definition that flows into
   * the phi from one of its predecessor blocks). Mirrors legacy
   * ESSA's `PhiFunction.getAnInput()`.
   */
  Ssa::SsaDefinition getAnInput() { Impl::phiHasInputFromBlock(this, result, _) }
}

/** An ESSA definition (legacy-shaped). */
class EssaDefinition = Ssa::SsaDefinition;

/**
 * An adapter representing a single SSA-defined "variable" — wrapping
 * one `Ssa::Definition`. Mirrors legacy `EssaVariable` API.
 */
class EssaVariable extends Ssa::SsaDefinition {
  /** Gets the underlying SSA definition (legacy name). */
  Ssa::SsaDefinition getDefinition() { result = this }

  /**
   * Gets a CFG node where this definition is used. Includes regular
   * `Name` reads as well as the synthetic scope-exit "use" registered
   * via `SsaImplInput::variableRead` — mirrors legacy ESSA's
   * `EssaVariable.getAUse()` which inherited the synthetic exit-use
   * from `SsaSourceVariable`.
   */
  Cfg::ControlFlowNode getAUse() {
    exists(CfgImpl::BasicBlock bb, int i |
      Impl::ssaDefReachesRead(this.getSourceVariable(), this, bb, i) and
      bb.getNode(i) = result
    )
  }

  /** Gets the (textual) name of the underlying variable. */
  string getName() { result = this.getSourceVariable().getVariable().getId() }

  /** Gets the scope in which this variable lives. */
  Py::Scope getScope() { result = this.getSourceVariable().getVariable().getScope() }
}

/**
 * Adjacent use-use and def-use relations exposed by the shared SSA
 * library. Provides the same interface as legacy
 * `semmle.python.essa.SsaCompute::AdjacentUses`.
 */
cached
module AdjacentUses {
  /** Holds if `nodeFrom` and `nodeTo` are adjacent uses of the same SSA variable. */
  cached
  predicate adjacentUseUse(Cfg::NameNode nodeFrom, Cfg::NameNode nodeTo) {
    exists(CfgImpl::BasicBlock bb1, int i1, CfgImpl::BasicBlock bb2, int i2 |
      Impl::adjacentUseUse(bb1, i1, bb2, i2, _, _) and
      nodeFrom = bb1.getNode(i1) and
      nodeTo = bb2.getNode(i2)
    )
  }

  /** Holds if `use` is a first use of definition `def`. */
  cached
  predicate firstUse(Ssa::SsaDefinition def, Cfg::NameNode use) {
    exists(CfgImpl::BasicBlock bb, int i |
      Impl::firstUse(def, bb, i, _) and
      use = bb.getNode(i)
    )
  }

  /**
   * Holds if `use` is any reachable use of definition `def`. Combines
   * `firstUse` with transitive use-use adjacency.
   */
  cached
  predicate useOfDef(Ssa::SsaDefinition def, Cfg::NameNode use) {
    firstUse(def, use)
    or
    exists(Cfg::NameNode mid | useOfDef(def, mid) and adjacentUseUse(mid, use))
  }
}
