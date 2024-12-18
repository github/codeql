/**
 * Provides classes for working with assignables.
 */

import csharp
private import semmle.code.csharp.dataflow.internal.SsaImpl as SsaImpl

/**
 * An assignable, that is, an element that can be assigned to. Either a
 * variable (`Variable`), a property (`Property`), an indexer (`Indexer`),
 * or an event (`Event`).
 */
class Assignable extends Declaration, @assignable {
  /** Gets the type of this assignable. */
  Type getType() { none() }

  /** Gets the annotated type of this assignable. */
  final AnnotatedType getAnnotatedType() { result.appliesTo(this) }

  /** Gets an access to this assignable. */
  AssignableAccess getAnAccess() { result.getTarget() = this }

  /** Gets an expression assigned to this assignable, if any. */
  Expr getAnAssignedValue() {
    result = any(AssignableDefinition def | def.getTarget() = this).getSource()
  }
}

/**
 * An assignable that is also a member. Either a field (`Field`), a
 * property (`Property`), an indexer (`Indexer`), or an event (`Event`).
 */
class AssignableMember extends Member, Assignable, Attributable {
  override AssignableMemberAccess getAnAccess() { result = Assignable.super.getAnAccess() }

  override string toString() { result = Assignable.super.toString() }
}

/**
 * An access to an assignable that is also a member. Either a field access
 * (`FieldAccess`), a property access (`PropertyAccess`), an indexer access
 * (`IndexerAccess`), or an event access (`EventAccess`).
 */
class AssignableMemberAccess extends MemberAccess, AssignableAccess {
  override AssignableMember getTarget() { result = AssignableAccess.super.getTarget() }
}

private predicate nameOfChild(NameOfExpr noe, Expr child) {
  child = noe
  or
  exists(Expr mid | nameOfChild(noe, mid) | child = mid.getAChildExpr())
}

/**
 * An access to an assignable that reads the underlying value. Either a
 * variable read (`VariableRead`), a property read (`PropertyRead`), an
 * indexer read (`IndexerRead`), or an event read (`EventRead`).
 *
 * For example, the last occurrence of `Length` in
 *
 * ```csharp
 * class C {
 *   int Length;
 *
 *   int GetLength() {
 *     return Length;
 *   }
 * }
 * ```
 */
class AssignableRead extends AssignableAccess {
  AssignableRead() {
    (
      not this instanceof AssignableWrite
      or
      this = any(AssignableDefinitions::MutationDefinition def).getTargetAccess()
      or
      this.isRefArgument()
      or
      this = any(AssignableDefinitions::AddressOfDefinition def).getTargetAccess()
    ) and
    not nameOfChild(_, this)
  }

  pragma[noinline]
  private ControlFlow::Node getAnAdjacentReadSameVar() {
    SsaImpl::adjacentReadPairSameVar(_, this.getAControlFlowNode(), result)
  }

  /**
   * Gets a next read of the same underlying assignable. That is, a read
   * that can be reached from this read without passing through any other reads,
   * and which is guaranteed to read the same value. Example:
   *
   * ```csharp
   * int Field;
   *
   * void SetField(int i) {
   *   this.Field = i;
   *   Use(this.Field);
   *   if (i > 0)
   *     this.Field = i - 1;
   *   else if (i < 0)
   *     SetField(1);
   *   Use(this.Field);
   *   Use(this.Field);
   * }
   * ```
   *
   * - The read of `i` on line 6 is next to the read on line 4.
   * - The reads of `i` on lines 7 and 8 are next to the read on line 6.
   * - The read of `this.Field` on line 11 is next to the read on line 10.
   */
  pragma[nomagic]
  AssignableRead getANextRead() {
    forex(ControlFlow::Node cfn | cfn = result.getAControlFlowNode() |
      cfn = this.getAnAdjacentReadSameVar()
    )
  }
}

/**
 * An access to an assignable that updates the underlying value. Either a
 * variable write (`VariableWrite`), a property write (`PropertyWrite`),
 * an indexer write (`IndexerWrite`), or an event write (`EventWrite`).
 *
 * For example, the last occurrence of `Length` in
 *
 * ```csharp
 * class C {
 *   int Length;
 *
 *   void SetLength(int length) {
 *     Length = length;
 *   }
 * }
 * ```
 */
class AssignableWrite extends AssignableAccess {
  AssignableWrite() { exists(AssignableDefinition def | def.getTargetAccess() = this) }
}

/**
 * A `ref` argument in a call.
 *
 * All predicates in this class deliberately do not use the `Call` class, or any
 * subclass thereof, as that results in too conservative negative recursion
 * compilation errors.
 */
private class RefArg extends AssignableAccess {
  private Expr call;
  private int position;

  RefArg() {
    this.isRefArgument() and
    this = call.getChildExpr(position) and
    (
      call instanceof @method_invocation_expr
      or
      call instanceof @delegate_invocation_expr
      or
      call instanceof @local_function_invocation_expr
      or
      call instanceof @object_creation_expr
    )
  }

  pragma[noinline]
  Parameter getAParameter(string name) {
    exists(Callable callable | result = callable.getAParameter() |
      expr_call(call, callable) and
      result.getName() = name
    )
  }

  /** Gets the parameter that this argument corresponds to. */
  private Parameter getParameter() {
    exists(string name | result = this.getAParameter(name) |
      // Appears in the positional part of the call
      result.getPosition() = position and
      not exists(this.getExplicitArgumentName())
      or
      // Appears in the named part of the call
      name = this.getExplicitArgumentName()
    )
  }

  private Callable getUnboundDeclarationTarget(Parameter p) {
    p = this.getParameter().getUnboundDeclaration() and
    result.getAParameter() = p
  }

  /**
   * Holds if the assignment to this `ref` argument via parameter `p` is
   * analyzable. That is, the target callable is non-overridable and from
   * source.
   */
  predicate isAnalyzable(Parameter p) {
    exists(Callable callable | callable = this.getUnboundDeclarationTarget(p) |
      not callable.(Overridable).isOverridableOrImplementable() and
      callable.hasBody()
    )
  }

  /** Gets an assignment to analyzable parameter `p`. */
  AssignableDefinition getAnAnalyzableRefDef(Parameter p) {
    this.isAnalyzable(p) and
    result.getTarget() = p and
    not result = TImplicitParameterDefinition(_)
  }

  /**
   * Holds if this `ref` assignment is *not* analyzable. Equivalent with
   * `not this.isAnalyzable(_)`, but avoids negative recursion.
   */
  private predicate isNonAnalyzable() {
    call instanceof @delegate_invocation_expr
    or
    exists(Callable callable | callable = this.getUnboundDeclarationTarget(_) |
      callable.(Virtualizable).isOverridableOrImplementable() or
      not callable.hasBody()
    )
  }

  /** Holds if this `ref` access is a potential assignment. */
  predicate isPotentialAssignment() {
    this.isNonAnalyzable() or
    exists(this.getAnAnalyzableRefDef(_))
  }
}

/** INTERNAL: Do not use. */
module AssignableInternal {
  private predicate tupleAssignmentDefinition(AssignExpr ae, Expr leaf) {
    exists(TupleExpr te |
      ae.getLValue() = te and
      te.getAnArgument+() = leaf and
      // `leaf` is either an assignable access or a local variable declaration
      not leaf instanceof TupleExpr
    )
  }

  /**
   * Holds if `ae` is a tuple assignment, and `left` is a sub expression
   * on the left-hand side of the assignment, with corresponding
   * right-hand side `right`.
   */
  private predicate tupleAssignmentPair(AssignExpr ae, Expr left, Expr right) {
    tupleAssignmentDefinition(ae, _) and
    left = ae.getLValue() and
    right = ae.getRValue()
    or
    exists(TupleExpr l, TupleExpr r, int i | tupleAssignmentPair(ae, l, r) |
      left = l.getArgument(i) and
      right = r.getArgument(i)
    )
  }

  // Not defined by dispatch in order to avoid too conservative negative recursion error
  Expr getExpr(AssignableDefinition def) {
    def = TAssignmentDefinition(result)
    or
    def = TTupleAssignmentDefinition(result, _)
    or
    def = TOutRefDefinition(any(AssignableAccess aa | result = aa.getParent()))
    or
    def = TMutationDefinition(result)
    or
    def = TLocalVariableDefinition(result)
    or
    def = TAddressOfDefinition(result)
    or
    def = TPatternDefinition(result)
  }

  /** A local variable declaration at the top-level of a pattern. */
  class TopLevelPatternDecl extends LocalVariableDeclExpr {
    private PatternMatch pm;

    TopLevelPatternDecl() { this = pm.getPattern().(BindingPatternExpr).getVariableDeclExpr() }

    PatternMatch getMatch() { result = pm }
  }

  cached
  private module Cached {
    cached
    newtype TAssignableDefinition =
      TAssignmentDefinition(Assignment a) { not a.getLValue() instanceof TupleExpr } or
      TTupleAssignmentDefinition(AssignExpr ae, Expr leaf) { tupleAssignmentDefinition(ae, leaf) } or
      TOutRefDefinition(AssignableAccess aa) {
        aa.isOutArgument()
        or
        aa.(RefArg).isPotentialAssignment()
      } or
      TMutationDefinition(MutatorOperation mo) or
      TLocalVariableDefinition(LocalVariableDeclExpr lvde) {
        not lvde.hasInitializer() and
        not exists(getTupleSource(TTupleAssignmentDefinition(_, lvde))) and
        not lvde instanceof TopLevelPatternDecl and
        not lvde.isOutArgument()
      } or
      TImplicitParameterDefinition(Parameter p) {
        exists(Callable c | p = c.getAParameter() |
          c.hasBody()
          or
          // Same as `c.(Constructor).hasInitializer()`, but avoids negative recursion warning
          c.getAChildExpr() instanceof @constructor_init_expr
        )
      } or
      TAddressOfDefinition(AddressOfExpr aoe) or
      TPatternDefinition(TopLevelPatternDecl tlpd)

    /**
     * Gets the source expression assigned in tuple definition `def`, if any.
     */
    cached
    Expr getTupleSource(TTupleAssignmentDefinition def) {
      exists(AssignExpr ae, Expr leaf | def = TTupleAssignmentDefinition(ae, leaf) |
        tupleAssignmentPair(ae, leaf, result)
      )
    }

    // Not defined by dispatch in order to avoid too conservative negative recursion error
    cached
    Assignable getTarget(AssignableDefinition def) {
      result = def.getTargetAccess().getTarget()
      or
      exists(Expr leaf | def = TTupleAssignmentDefinition(_, leaf) |
        result = leaf.(LocalVariableDeclExpr).getVariable()
      )
      or
      def = any(AssignableDefinitions::ImplicitParameterDefinition p | result = p.getParameter())
      or
      def =
        any(AssignableDefinitions::LocalVariableDefinition decl |
          result = decl.getDeclaration().getVariable()
        )
      or
      def =
        any(AssignableDefinitions::PatternDefinition pd | result = pd.getDeclaration().getVariable())
      or
      def = any(AssignableDefinitions::InitializerDefinition init | result = init.getAssignable())
    }

    // Not defined by dispatch in order to avoid too conservative negative recursion error
    cached
    AssignableAccess getTargetAccess(AssignableDefinition def) {
      def = TAssignmentDefinition(any(Assignment a | a.getLValue() = result))
      or
      def = TTupleAssignmentDefinition(_, result)
      or
      def = TOutRefDefinition(result)
      or
      def = TMutationDefinition(any(MutatorOperation mo | mo.getOperand() = result))
      or
      def = TAddressOfDefinition(any(AddressOfExpr aoe | aoe.getOperand() = result))
    }

    /**
     * Gets the argument for the implicit `value` parameter in accessor access
     * `a`, if any.
     */
    cached
    Expr getAccessorCallValueArgument(AccessorCall ac) {
      exists(AssignExpr ae | tupleAssignmentDefinition(ae, ac) |
        tupleAssignmentPair(ae, ac, result)
      )
      or
      exists(Assignment ass | ac = ass.getLValue() |
        result = ass.getRValue() and
        not ass.(AssignOperation).hasExpandedAssignment()
      )
    }
  }

  import Cached
}

private import AssignableInternal

/**
 * An assignable definition.
 *
 * Either a direct non-tuple assignment (`AssignableDefinitions::AssignmentDefinition`),
 * a direct tuple assignment (`AssignableDefinitions::TupleAssignmentDefinition`),
 * an indirect `out`/`ref` assignment (`AssignableDefinitions::OutRefDefinition`),
 * a mutation update (`AssignableDefinitions::MutationDefinition`), a local variable
 * declaration without an initializer (`AssignableDefinitions::LocalVariableDefinition`),
 * an implicit parameter definition (`AssignableDefinitions::ImplicitParameterDefinition`),
 * an address-of definition (`AssignableDefinitions::AddressOfDefinition`), or a pattern
 * definition (`AssignableDefinitions::PatternDefinition`).
 */
class AssignableDefinition extends TAssignableDefinition {
  /**
   * DEPRECATED: Use `this.getExpr().getAControlFlowNode()` instead.
   *
   * Gets a control flow node that updates the targeted assignable when
   * reached.
   *
   * Multiple definitions may relate to the same control flow node. For example,
   * the definitions of `x` and `y` in `M(out x, out y)` and `(x, y) = (0, 1)`
   * relate to the same call to `M` and assignment node, respectively.
   */
  deprecated ControlFlow::Node getAControlFlowNode() {
    result = this.getExpr().getAControlFlowNode()
  }

  /**
   * Gets the underlying expression that updates the targeted assignable when
   * reached, if any.
   *
   * Not all definitions have an associated expression, for example implicit
   * parameter definitions.
   */
  final Expr getExpr() { result = getExpr(this) }

  /**
   * Gets the underlying element associated with this definition. This is either
   * an expression or a parameter.
   */
  Element getElement() { result = this.getExpr() }

  /** Gets the enclosing callable of this definition. */
  Callable getEnclosingCallable() { result = this.getExpr().getEnclosingCallable() }

  /**
   * Gets the assigned expression, if any. For example, the expression assigned
   * in `x = 0` is `0`. The value may not always exists, for example in assignments
   * via `out`/`ref` parameters.
   */
  Expr getSource() { none() }

  /** Gets the assignable being defined. */
  final Assignable getTarget() { result = getTarget(this) }

  /**
   * Gets the access used in the definition of the underlying assignable,
   * if any. Local variable declarations and implicit parameter definitions
   * are the only definitions without associated accesses.
   */
  final AssignableAccess getTargetAccess() { result = getTargetAccess(this) }

  /**
   * Holds if this definition is guaranteed to update the targeted assignable.
   * The only potentially uncertain definitions are `ref` assignments.
   */
  predicate isCertain() { any() }

  /**
   * Gets a first read of the same underlying assignable. That is, a read
   * that can be reached from this definition without passing through any other
   * reads, and which is guaranteed to read the value assigned in this
   * definition. Example:
   *
   * ```csharp
   * int Field;
   *
   * void SetField(int i) {
   *   this.Field = i;
   *   Use(this.Field);
   *   if (i > 0)
   *     this.Field = i - 1;
   *   else if (i < 0)
   *     SetField(1);
   *   Use(this.Field);
   *   Use(this.Field);
   * }
   * ```
   *
   * - The read of `i` on line 4 is first read of the implicit parameter definition
   *   on line 3.
   * - The read of `this.Field` on line 5 is a first read of the definition on line 4.
   *
   * Subsequent reads can be found by following the steps defined by
   * `AssignableRead.getANextRead()`.
   */
  pragma[nomagic]
  AssignableRead getAFirstRead() {
    forex(ControlFlow::Node cfn | cfn = result.getAControlFlowNode() |
      exists(Ssa::ExplicitDefinition def | result = def.getAFirstReadAtNode(cfn) |
        this = def.getADefinition()
      )
      or
      exists(Ssa::ImplicitParameterDefinition def | result = def.getAFirstReadAtNode(cfn) |
        this.(AssignableDefinitions::ImplicitParameterDefinition).getParameter() =
          def.getParameter()
      )
    )
  }

  /** Gets a textual representation of this assignable definition. */
  string toString() { none() }

  /** Gets the location of this assignable definition. */
  Location getLocation() { result = this.getExpr().getLocation() }
}

/** Provides different types of `AssignableDefinition`s. */
module AssignableDefinitions {
  /**
   * A non-tuple definition by direct assignment, for example `x = 0`.
   */
  class AssignmentDefinition extends AssignableDefinition, TAssignmentDefinition {
    Assignment a;

    AssignmentDefinition() { this = TAssignmentDefinition(a) }

    /** Gets the underlying assignment. */
    Assignment getAssignment() { result = a }

    override Expr getSource() {
      result = a.getRValue() and
      not a instanceof AssignOperation
    }

    override string toString() { result = a.toString() }
  }

  /**
   * A tuple definition by direct assignment, for example the definition of `x`
   * in `(x, y) = (0, 1)`.
   */
  class TupleAssignmentDefinition extends AssignableDefinition, TTupleAssignmentDefinition {
    AssignExpr ae;
    Expr leaf;

    TupleAssignmentDefinition() { this = TTupleAssignmentDefinition(ae, leaf) }

    /** Gets the underlying assignment. */
    AssignExpr getAssignment() { result = ae }

    /** Gets the leaf expression. */
    Expr getLeaf() { result = leaf }

    /**
     * Gets the evaluation order of this definition among the other definitions
     * in the compound tuple assignment. For example, in `(x, (y, z)) = ...` the
     * orders of the definitions of `x`, `y`, and `z` are 0, 1, and 2, respectively.
     */
    int getEvaluationOrder() {
      leaf =
        rank[result + 1](Expr leaf0 |
          exists(TTupleAssignmentDefinition(ae, leaf0))
        |
          leaf0 order by leaf0.getLocation().getStartLine(), leaf0.getLocation().getStartColumn()
        )
    }

    override Expr getSource() {
      result = getTupleSource(this) // need not exist
    }

    override string toString() { result = ae.toString() }
  }

  /** Holds if a node in basic block `bb` assigns to `ref` parameter `p` via definition `def`. */
  private predicate basicBlockRefParamDef(
    ControlFlow::BasicBlock bb, Parameter p, AssignableDefinition def
  ) {
    def = any(RefArg arg).getAnAnalyzableRefDef(p) and
    bb.getANode() = def.getExpr().getAControlFlowNode()
  }

  /**
   * Holds if `p` is an analyzable `ref` parameter and there is a path from the
   * entry point of `p`'s callable to basic block `bb` without passing through
   * any assignments to `p`.
   */
  pragma[nomagic]
  private predicate parameterReachesWithoutDef(Parameter p, ControlFlow::BasicBlock bb) {
    forall(AssignableDefinition def | basicBlockRefParamDef(bb, p, def) |
      isUncertainRefCall(def.getTargetAccess())
    ) and
    (
      any(RefArg arg).isAnalyzable(p) and
      p.getCallable().getEntryPoint() = bb.getFirstNode()
      or
      exists(ControlFlow::BasicBlock mid | parameterReachesWithoutDef(p, mid) |
        bb = mid.getASuccessor()
      )
    )
  }

  /**
   * Holds if the `ref` assignment to `aa` via call `c` is uncertain.
   */
  // Not in the cached module `Cached`, as that would introduce a dependency
  // on the CFG construction, and effectively collapse too many stages into one
  cached
  predicate isUncertainRefCall(RefArg arg) {
    arg.isPotentialAssignment() and
    exists(ControlFlow::BasicBlock bb, Parameter p | arg.isAnalyzable(p) |
      parameterReachesWithoutDef(p, bb) and
      bb.getLastNode() = p.getCallable().getExitPoint()
    )
  }

  /**
   * A definition via an `out`/`ref` argument in a call, for example
   * `M(out x, ref y)`.
   */
  class OutRefDefinition extends AssignableDefinition, TOutRefDefinition {
    AssignableAccess aa;

    OutRefDefinition() { this = TOutRefDefinition(aa) }

    /** Gets the underlying call. */
    Call getCall() { result.getAnArgument() = aa }

    private int getPosition() { aa = this.getCall().getArgument(result) }

    /**
     * Gets the index of this definition among the other definitions in the
     * `out`/`ref` assignment. For example, in `M(out x, ref y)` the index of
     * the definitions of `x` and `y` are 0 and 1, respectively.
     */
    int getIndex() {
      this =
        rank[result + 1](OutRefDefinition def |
          def.getCall() = this.getCall()
        |
          def order by def.getPosition()
        )
    }

    override predicate isCertain() { not isUncertainRefCall(this.getTargetAccess()) }

    override string toString() { result = aa.toString() }

    override Location getLocation() { result = aa.getLocation() }
  }

  /**
   * A definition by mutation, for example `x++`.
   */
  class MutationDefinition extends AssignableDefinition, TMutationDefinition {
    MutatorOperation mo;

    MutationDefinition() { this = TMutationDefinition(mo) }

    /** Gets the underlying mutator operation. */
    MutatorOperation getMutatorOperation() { result = mo }

    override string toString() { result = mo.toString() }
  }

  /**
   * A local variable definition without an initializer, for example `int i`.
   */
  class LocalVariableDefinition extends AssignableDefinition, TLocalVariableDefinition {
    LocalVariableDeclExpr lvde;

    LocalVariableDefinition() { this = TLocalVariableDefinition(lvde) }

    /** Gets the underlying local variable declaration. */
    LocalVariableDeclExpr getDeclaration() { result = lvde }

    override string toString() { result = lvde.toString() }
  }

  /**
   * An implicit parameter definition at the entry point of the
   * associated callable.
   */
  class ImplicitParameterDefinition extends AssignableDefinition, TImplicitParameterDefinition {
    Parameter p;

    ImplicitParameterDefinition() { this = TImplicitParameterDefinition(p) }

    /** Gets the underlying parameter. */
    Parameter getParameter() { result = p }

    deprecated override ControlFlow::Node getAControlFlowNode() {
      result = p.getCallable().getEntryPoint()
    }

    override Parameter getElement() { result = p }

    override Callable getEnclosingCallable() { result = p.getCallable() }

    override string toString() { result = p.toString() }

    override Location getLocation() { result = this.getTarget().getLocation() }
  }

  /**
   * An indirect address-of definition, for example `&x`.
   */
  class AddressOfDefinition extends AssignableDefinition, TAddressOfDefinition {
    AddressOfExpr aoe;

    AddressOfDefinition() { this = TAddressOfDefinition(aoe) }

    /** Gets the underlying address-of expression. */
    AddressOfExpr getAddressOf() { result = aoe }

    override string toString() { result = aoe.toString() }
  }

  /**
   * A local variable definition in a pattern, for example `x is int i`.
   */
  class PatternDefinition extends AssignableDefinition, TPatternDefinition {
    TopLevelPatternDecl tlpd;

    PatternDefinition() { this = TPatternDefinition(tlpd) }

    /** Gets the element matches against this pattern. */
    PatternMatch getMatch() { result = tlpd.getMatch() }

    /** Gets the underlying local variable declaration. */
    LocalVariableDeclExpr getDeclaration() { result = tlpd }

    override Expr getSource() { result = this.getMatch().getExpr() }

    override string toString() { result = this.getDeclaration().toString() }
  }

  /**
   * An initializer definition for a field or a property, for example
   * line 2 in
   *
   * ```csharp
   * class C {
   *   int Field = 0;
   * }
   * ```
   */
  class InitializerDefinition extends AssignmentDefinition {
    private Assignable fieldOrProp;

    InitializerDefinition() { this.getAssignment().getParent() = fieldOrProp }

    /** Gets the assignable (field or property) being initialized. */
    Assignable getAssignable() { result = fieldOrProp }
  }
}
