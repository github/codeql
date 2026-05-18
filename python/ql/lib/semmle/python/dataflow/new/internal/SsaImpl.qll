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
