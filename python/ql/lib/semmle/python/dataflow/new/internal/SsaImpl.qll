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
 * Adapts the Python `Cfg` facade to the shared SSA library's `CfgSig`.
 * All members are inherited from `Cfg::ControlFlowNode` and
 * `Cfg::BasicBlock`.
 */
private module CfgForSsa implements BB::CfgSig<Py::Location> {
  class ControlFlowNode = CfgImpl::ControlFlowNode;

  class BasicBlock = CfgImpl::BasicBlock;

  class EntryBasicBlock = CfgImpl::Cfg::EntryBasicBlock;

  predicate dominatingEdge = CfgImpl::Cfg::dominatingEdge/2;
}

/**
 * A source variable for SSA. Wraps a Python `Variable` (the AST-level
 * notion of a named binding within a scope) so that the shared SSA
 * implementation can use it as a `SourceVariable`.
 *
 * We only track variables that are read at least once in their scope —
 * tracking write-only variables is unnecessary work.
 */
private newtype TSsaSourceVariable =
  TPyVar(Py::Variable v) {
    // Has a use somewhere — read-relevant for SSA.
    exists(Cfg::NameNode n | n.uses(v))
    or
    // Or has a deletion (treated as a write that destroys the value).
    exists(Cfg::NameNode n | n.deletes(v))
  }

/**
 * A source variable for SSA, wrapping a Python AST `Variable`.
 */
class SsaSourceVariable extends TSsaSourceVariable {
  /** Gets the underlying Python AST variable. */
  Py::Variable getVariable() { this = TPyVar(result) }

  /** Gets a textual representation of this source variable. */
  string toString() { result = this.getVariable().toString() }

  /** Gets the location of this source variable. */
  Py::Location getLocation() { result = this.getVariable().getScope().getLocation() }
}

/**
 * Holds if `v` is a non-local read in scope `s`, in the sense that `s`
 * uses `v` but does not write it within `s`. This includes globals,
 * builtins, and variables captured from an enclosing function scope.
 */
private predicate nonLocalReadIn(Py::Variable v, Py::Scope s) {
  exists(Cfg::NameNode n |
    n.uses(v) and
    n.getScope() = s and
    not exists(Cfg::NameNode def | def.defines(v) and def.getScope() = s)
  )
}

/**
 * Holds if `v` should have an implicit entry definition at the start of
 * scope `s`. This covers:
 *   - non-local / global / builtin variables (defined outside `s`), and
 *   - captured variables (defined in an enclosing scope but read here).
 *
 * Parameters are *not* included: their bound `Name` is itself a CFG
 * node (per the C#-style parameter wiring), so `variableWrite` fires at
 * the parameter's natural CFG index.
 */
private predicate hasEntryDef(SsaSourceVariable v, Py::Scope s) {
  nonLocalReadIn(v.getVariable(), s)
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
    // `del x` — removes the binding. Modelled as a certain write that
    // makes any subsequent read invalid.
    exists(Cfg::NameNode n |
      bb.getNode(i) = n and
      n.deletes(v.getVariable()) and
      certain = true
    )
    or
    // Implicit entry definition for non-local / captured / global /
    // builtin variables read in the scope.
    bb = entryBlock(v.getVariable().getScope()) and
    hasEntryDef(v, v.getVariable().getScope()) and
    i = -1 and
    certain = true
  }

  predicate variableRead(CfgImpl::BasicBlock bb, int i, SourceVariable v, boolean certain) {
    exists(Cfg::NameNode n |
      bb.getNode(i) = n and
      n.uses(v.getVariable()) and
      certain = true
    )
  }
}

/**
 * The shared SSA instantiation for Python.
 *
 * Members:
 *   - `Definition` — the union of explicit, uncertain, and phi definitions
 *   - `WriteDefinition`, `UncertainWriteDefinition`, `PhiNode`
 *   - the standard SSA predicates (`getAUse`, `getAnUltimateDefinition`, ...).
 */
module Ssa = SsaImplCommon::Make<Py::Location, CfgForSsa, SsaImplInput>;

final class Definition = Ssa::Definition;

final class WriteDefinition = Ssa::WriteDefinition;

final class UncertainWriteDefinition = Ssa::UncertainWriteDefinition;

final class PhiNode = Ssa::PhiNode;

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
 * This is the `Cfg::ControlFlowNode` whose index in `def`'s basic block
 * is the same as `def`'s defining index. Phi definitions have no
 * defining CFG node and are excluded.
 */
private Cfg::ControlFlowNode writeDefNode(Ssa::WriteDefinition def) {
  exists(CfgImpl::BasicBlock bb, int i |
    def.definesAt(_, bb, i) and
    result = bb.getNode(i)
  )
}

/**
 * A write definition whose binding has a corresponding CFG node — i.e.
 * everything that's not a phi node. Mirrors legacy ESSA's
 * `EssaNodeDefinition`.
 */
class EssaNodeDefinition extends Ssa::WriteDefinition {
  /** Gets the CFG node where this definition's binding takes place. */
  Cfg::ControlFlowNode getDefiningNode() { result = writeDefNode(this) }

  /** Gets the variable defined here (legacy name). */
  SsaSourceVariable getVariable() { result = this.getSourceVariable() }

  /** Gets the enclosing scope. */
  Py::Scope getScope() {
    exists(Cfg::ControlFlowNode n | n = this.getDefiningNode() | result = n.getScope())
  }
}

/**
 * An assignment definition `x = e`. The defining node is `x`'s CFG
 * node; the value is `e`'s CFG node.
 */
class AssignmentDefinition extends EssaNodeDefinition {
  AssignmentDefinition() {
    exists(Cfg::NameNode n | n = this.getDefiningNode() |
      exists(Py::Assign a | a.getATarget() = n.getNode())
      or
      exists(Py::AnnAssign a | a.getTarget() = n.getNode() and exists(a.getValue()))
      or
      exists(Py::AssignExpr a | a.getTarget() = n.getNode())
      or
      exists(Py::AugAssign a | a.getTarget() = n.getNode())
    )
  }

  /** Gets the CFG node for the value being assigned, if statically known. */
  Cfg::ControlFlowNode getValue() {
    exists(Cfg::NameNode target | target = this.getDefiningNode() |
      exists(Py::Assign a |
        a.getATarget() = target.getNode() and
        result.getNode() = a.getValue()
      )
      or
      exists(Py::AnnAssign a |
        a.getTarget() = target.getNode() and
        result.getNode() = a.getValue()
      )
      or
      exists(Py::AssignExpr a |
        a.getTarget() = target.getNode() and
        result.getNode() = a.getValue()
      )
    )
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
 * An implicit entry definition for a non-local / captured / global /
 * builtin variable read in a scope but not defined there.
 */
class ScopeEntryDefinition extends Ssa::Definition {
  ScopeEntryDefinition() {
    exists(CfgImpl::BasicBlock bb |
      this.definesAt(_, bb, -1) and
      bb instanceof CfgImpl::Cfg::EntryBasicBlock
    )
  }

  /** Gets the variable being entered. */
  SsaSourceVariable getVariable() { result = this.getSourceVariable() }

  /** Gets the enclosing scope. */
  Py::Scope getScope() {
    exists(CfgImpl::BasicBlock bb |
      this.definesAt(_, bb, -1) and
      result = this.getSourceVariable().getVariable().getScope()
    )
  }
}

/** A phi node (alias matching legacy naming). */
class PhiFunction = PhiNode;

/** Base class for all ESSA definitions (legacy-shaped). */
class EssaDefinition = Ssa::Definition;

/**
 * An adapter representing a single SSA-defined "variable" — wrapping
 * one `Ssa::Definition`. Mirrors legacy `EssaVariable` API.
 */
class EssaVariable extends Ssa::Definition {
  /** Gets the underlying SSA definition (legacy name). */
  Ssa::Definition getDefinition() { result = this }

  /** Gets a CFG node where this definition is used. */
  Cfg::NameNode getAUse() {
    exists(CfgImpl::BasicBlock bb, int i |
      Ssa::ssaDefReachesRead(this.getSourceVariable(), this, bb, i) and
      bb.getNode(i) = result
    )
  }

  /** Gets the (textual) name of the underlying variable. */
  string getName() { result = this.getSourceVariable().getVariable().getId() }

  /** Gets an ultimate non-phi ancestor of this definition. */
  EssaVariable getAnUltimateDefinition() {
    if this instanceof PhiNode
    then
      exists(Ssa::Definition input |
        Ssa::phiHasInputFromBlock(this, input, _) and
        result = input.(EssaVariable).getAnUltimateDefinition()
      )
    else result = this
  }
}

/**
 * Adjacent use-use and def-use relations exposed by the shared SSA
 * library. Provides the same interface as legacy
 * `semmle.python.essa.SsaCompute::AdjacentUses`.
 */
module AdjacentUses {
  /** Holds if `nodeFrom` and `nodeTo` are adjacent uses of the same SSA variable. */
  predicate adjacentUseUse(Cfg::NameNode nodeFrom, Cfg::NameNode nodeTo) {
    exists(SsaSourceVariable v, CfgImpl::BasicBlock bb1, int i1, CfgImpl::BasicBlock bb2, int i2 |
      Ssa::adjacentUseUse(bb1, i1, bb2, i2, v, _) and
      nodeFrom = bb1.getNode(i1) and
      nodeTo = bb2.getNode(i2)
    )
  }

  /** Holds if `use` is a first use of definition `def`. */
  predicate firstUse(Ssa::Definition def, Cfg::NameNode use) {
    exists(CfgImpl::BasicBlock bb, int i |
      Ssa::firstUse(def, bb, i, _) and
      use = bb.getNode(i)
    )
  }
}
