/**
 * Provides classes for working with assignables.
 */

import csharp

/**
 * An assignable, that is, an element that can be assigned to. Either a
 * variable (`Variable`), a property (`Property`), an indexer (`Indexer`),
 * or an event (`Event`).
 */
class Assignable extends Declaration, @assignable {
  /** Gets the type of this assignable. */
  Type getType() { none() }

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
class AssignableMember extends Member, Assignable {
  override AssignableMemberAccess getAnAccess() {
    result = Assignable.super.getAnAccess()
  }
}

/**
 * An access to an assignable that is also a member. Either a field access
 * (`FieldAccess`), a property access (`PropertyAccess`), an indexer access
 * (`IndexerAccess`), or an event access (`EventAccess`).
 */
class AssignableMemberAccess extends MemberAccess, AssignableAccess {
  override AssignableMember getTarget() {
    result = AssignableAccess.super.getTarget()
  }
}

/**
 * An access to an assignable that reads the underlying value. Either a
 * variable read (`VariableRead`), a property read (`PropertyRead`), an
 * indexer read (`IndexerRead`), or an event read (`EventRead`).
 *
 * For example, the last occurrence of `Length` in
 *
 * ```
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
    )
    and
    not this = any(NameOfExpr noe).getAChildExpr*()
  }

  /**
   * Gets a next read of the same underlying assignable. That is, a read
   * that can be reached from this read without passing through any other reads,
   * and which is guaranteed to read the same value. Example:
   *
   * ```
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
  AssignableRead getANextRead() {
    Ssa::Internal::adjacentReadPairSameVar(this, result)
  }

  /**
   * Gets a reachable read of the same underlying assignable. That is, a read
   * that can be reached from this read, and which is guaranteed to read the
   * same value.
   *
   * This is the transitive closure of `getANextRead()`.
   */
  AssignableRead getAReachableRead() {
    result = this.getANextRead+()
  }

  /**
   * Gets a next uncertain read of the same underlying assignable. That is,
   * a read that can be reached from this read without passing through any other
   * reads, and which *may* read the same value. Example:
   *
   * ```
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
   * - The read of `this.Field` on line 10 is next to the read on line 5.
   *   (This is the only truly uncertain read.)
   * - The read of `this.Field` on line 11 is next to the read on line 10.
   */
  deprecated
  AssignableRead getANextUncertainRead() {
    Ssa::Internal::adjacentReadPair(this, result)
  }

  /**
   * Gets a next uncertain read of the same underlying assignable. That is,
   * a read that can be reached from this read, and which *may* read the same
   * value.
   *
   * This is the transitive closure of `getANextUncertainRead()`.
   */
  deprecated
  AssignableRead getAReachableUncertainRead() {
    result = this.getANextUncertainRead+()
  }
}

/**
 * An access to an assignable that updates the underlying value. Either a
 * variable write (`VariableWrite`), a property write (`PropertyWrite`),
 * an indexer write (`IndexerWrite`), or an event write (`EventWrite`).
 *
 * For example, the last occurrence of `Length` in
 *
 * ```
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
  AssignableWrite() {
    exists(AssignableDefinition def |
      def.getTargetAccess() = this
    )
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
    exists(TupleExpr l, TupleExpr r, int i |
      tupleAssignmentPair(ae, l, r) |
      left = l.getArgument(i) and
      right = r.getArgument(i)
    )
  }

  /**
   * Holds if the `ref` assignment to `aa` via call `c` is relevant.
   */
  private predicate isRelevantRefCall(Call c, AssignableAccess aa) {
    c.getAnArgument() = aa and
    aa.isRefArgument() and
    (isNonAnalyzableRefCall(c, aa, _) or exists(getAnAnalyzableRefDef(c, aa, _)))
  }

  private Callable getRefCallTarget(Call c, AssignableAccess aa, Parameter p) {
    exists(Parameter parg |
      c.getAnArgument() = aa and
      aa.isRefArgument() and
      getArgumentForParameter(c, parg) = aa and
      p = parg.getSourceDeclaration() and
      result.getAParameter() = p
    )
  }

  /**
   * A verbatim copy of `Call.getArgumentForParameter()` specialized to
   * `MethodCall`/`ObjectCreation` (needed to avoid too conservative negative
   * recursion error).
   */
  private Expr getArgumentForParameter(Call c, Parameter p) {
    exists(Callable callable |
      p = callable.getAParameter() |
      callable = c.(MethodCall).getTarget() or
      callable = c.(ObjectCreation).getTarget()
    )
    and
    (
      // Appears in the positional part of the call
      result = c.getArgument(p.getPosition()) and
      not exists(result.getExplicitArgumentName())
      or
      // Appears in the named part of the call
      result = getExplicitArgument(c, p.getName())
    )
  }

  pragma [noinline] // predicate folding to get proper join-order
  private Expr getExplicitArgument(Call c, string name) {
    result = c.getAnArgument() and
    result.getExplicitArgumentName() = name
  }

  /**
   * Holds if the `ref` assignment to `aa` via parameter `p` is analyzable. That is,
   * the target callable is non-overridable and from source.
   */
  private predicate isAnalyzableRefCall(Call c, AssignableAccess aa, Parameter p) {
    exists(Callable callable |
      callable = getRefCallTarget(c, aa, p) |
      not callable.(Virtualizable).isOverridableOrImplementable() and
      callable.hasBody()
    )
  }

  /**
   * Holds if the `ref` assignment to `aa` via parameter `p` is *not* analyzable.
   * Equivalent with `not isAnalyzableRefCall(mc, aa, p)`, but avoids negative
   * recursion.
   */
  private predicate isNonAnalyzableRefCall(Call c, AssignableAccess aa, Parameter p) {
    exists(Callable callable |
      callable = getRefCallTarget(c, aa, p) |
      callable.(Virtualizable).isOverridableOrImplementable() or
      not callable.hasBody()
    )
  }

  /**
   * Gets an assignment to parameter `p`, where the `ref` assignment to `aa` via
   * parameter `p` is analyzable.
   */
  private AssignableDefinition getAnAnalyzableRefDef(Call c, AssignableAccess aa, Parameter p) {
    isAnalyzableRefCall(c, aa, p) and
    result.getTarget() = p and
    not result = TImplicitParameterDefinition(_)
  }

  /**
   * Holds if `p` is an analyzable `ref` parameter and there is a path from the
   * entry point of `p`'s callable to basic block `bb` without passing through
   * any assignments to `p`.
   */
  private predicate parameterReachesWithoutDef(Parameter p, ControlFlow::BasicBlock bb) {
    not basicBlockRefParamDef(bb, p)
    and
    (
      isAnalyzableRefCall(_, _, p) and
      p.getCallable().getEntryPoint() = bb.getFirstNode()
      or
      exists(ControlFlow::BasicBlock mid |
        parameterReachesWithoutDef(p, mid) |
        bb = mid.getASuccessor()
      )
    )
  }

  /** Holds if a node in basic block `bb` assigns to `ref` parameter `p`. */
  private predicate basicBlockRefParamDef(ControlFlow::BasicBlock bb, Parameter p) {
    bb.getANode() = getAnAnalyzableRefDef(_, _, p).getAControlFlowNode()
  }

  private cached module Cached {
    cached newtype TAssignableDefinition =
      TAssignmentDefinition(Assignment a) {
        not a.getLValue() instanceof TupleExpr
      }
      or
      TTupleAssignmentDefinition(AssignExpr ae, Expr leaf) {
        tupleAssignmentDefinition(ae, leaf)
      }
      or
      TOutRefDefinition(AssignableAccess aa) {
        aa.isOutArgument()
        or
        isRelevantRefCall(_, aa)
      }
      or
      TMutationDefinition(MutatorOperation mo)
      or
      TLocalVariableDefinition(LocalVariableDeclExpr lvde) {
        not lvde.hasInitializer() and
        not exists(getTupleSource(TTupleAssignmentDefinition(_, lvde))) and
        not lvde = any(IsPatternExpr ipe).getVariableDeclExpr() and
        not lvde = any(TypeCase tc).getVariableDeclExpr()
      }
      or
      TImplicitParameterDefinition(Parameter p) {
        exists(Callable c |
          p = c.getAParameter() |
          c.hasBody() or
          c.(Constructor).hasInitializer()
        )
      }
      or
      TAddressOfDefinition(AddressOfExpr aoe)
      or
      TIsPatternDefinition(IsPatternExpr ipe)
      or
      TTypeCasePatternDefinition(TypeCase tc)
      or
      TInitializer(Assignable a, Expr e) {
        e = a.(Field).getInitializer() or
        e = a.(Property).getInitializer()
      }

    /**
     * Gets the source expression assigned in tuple definition `def`, if any.
     */
    cached Expr getTupleSource(TTupleAssignmentDefinition def) {
      exists(AssignExpr ae, Expr leaf |
        def = TTupleAssignmentDefinition(ae, leaf) |
        tupleAssignmentPair(ae, leaf, result)
      )
    }

    /**
     * Holds if the `ref` assignment to `aa` via call `c` is uncertain.
     */
    cached predicate isUncertainRefCall(Call c, AssignableAccess aa) {
      isRelevantRefCall(c, aa)
      and
      exists(ControlFlow::BasicBlock bb, Parameter p |
        isAnalyzableRefCall(c, aa, p) |
        parameterReachesWithoutDef(p, bb) and
        bb.getLastNode() = p.getCallable().getExitPoint()
      )
    }

    // Not defined by dispatch in order to avoid too conservative negative recursion error
    cached Assignable getTarget(AssignableDefinition def) {
      result = def.getTargetAccess().getTarget()
      or
      exists(Expr leaf |
        def = TTupleAssignmentDefinition(_, leaf) |
        result = leaf.(LocalVariableDeclExpr).getVariable()
      )
      or
      def = any(AssignableDefinitions::ImplicitParameterDefinition p |
        result = p.getParameter()
      )
      or
      def = any(AssignableDefinitions::LocalVariableDefinition decl |
        result = decl.getDeclaration().getVariable()
      )
      or
      def = any(AssignableDefinitions::IsPatternDefinition is |
        result = is.getDeclaration().getVariable()
      )
      or
      def = any(AssignableDefinitions::TypeCasePatternDefinition case |
        result = case.getDeclaration().getVariable()
      )
      or
      def = any(AssignableDefinitions::InitializerDefinition init |
        result = init.getAssignable()
      )
    }

    // Not defined by dispatch in order to avoid too conservative negative recursion error
    cached AssignableAccess getTargetAccess(AssignableDefinition def) {
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
     * Gets the argument for the implicit `value` parameter in the accessor call
     * `ac`, if any.
     */
    cached Expr getAccessorCallValueArgument(AccessorCall ac) {
      exists(AssignExpr ae |
        tupleAssignmentDefinition(ae, ac) |
        tupleAssignmentPair(ae, ac, result)
      )
      or
      exists(Assignment a |
        ac = a.getLValue() |
        result = a.getRValue() and
        not a.(AssignOperation).hasExpandedAssignment()
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
 * an address-of definition (`AssignableDefinitions::AddressOfDefinition`), an `is` pattern
 * definition (`AssignableDefinitions::IsPatternDefinition`), or a type case pattern
 * definition (`AssignableDefinitions::TypeCasePatternDefinition`).
 */
class AssignableDefinition extends TAssignableDefinition {
  /**
   * Gets a control flow node that updates the targeted assignable when
   * reached.
   *
   * Multiple definitions may relate to the same control flow node. For example,
   * the definitions of `x` and `y` in `M(out x, out y)` and `(x, y) = (0, 1)`
   * relate to the same call to `M` and assignment node, respectively.
   */
  ControlFlow::Node getAControlFlowNode() {
    result = this.getExpr().getAControlFlowNode()
  }

  /**
   * Gets the underlying expression that updates the targeted assignable when
   * reached, if any.
   *
   * Not all definitions have an associated expression, for example implicit
   * parameter definitions.
   */
  Expr getExpr() { none() }

  /** DEPRECATED: Use `getAControlFlowNode()` instead. */
  deprecated
  ControlFlow::Node getControlFlowNode() { result = this.getAControlFlowNode() }

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
   * ```
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
  AssignableRead getAFirstRead() {
    exists(Ssa::ExplicitDefinition def |
      def.getADefinition() = this |
      result = def.getAFirstRead()
    )
  }

  /**
   * Gets a reachable read of the same underlying assignable. That is, a read
   * that can be reached from this definition, and which is guaranteed to read
   * the value assigned in this definition.
   *
   * This is the equivalent with `getAFirstRead().getANextRead*()`.
   */
  AssignableRead getAReachableRead() {
    result = this.getAFirstRead().getANextRead*()
  }

  /**
   * Gets a first uncertain read of the same underlying assignable. That is,
   * a read that can be reached from this definition without passing through any
   * other reads, and which *may* read the value assigned in this definition.
   * Example:
   *
   * ```
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
   * - The read of `i` on line 4 is a first read of the implicit parameter definition
   *   on line 3.
   * - The read of `this.Field` on line 5 is a first read of the definition on line 4.
   * - The read of `this.Field` on line 10 is a first read of the definition on
   *   line 7. (This is the only truly uncertain read.)
   *
   * Subsequent uncertain reads can be found by following the steps defined by
   * `AssignableRead.getANextUncertainRead()`.
   */
  deprecated
  AssignableRead getAFirstUncertainRead() {
    exists(Ssa::ExplicitDefinition def |
      def.getADefinition() = this |
      result = def.getAFirstUncertainRead()
    )
  }

  /**
   * Gets a reachable uncertain read of the same underlying assignable. That is,
   * a read that can be reached from this definition, and which *may* read the
   * value assigned in this definition.
   *
   * This is the equivalent with `getAFirstUncertainRead().getANextUncertainRead*()`.
   */
  deprecated
  AssignableRead getAReachableUncertainRead() {
    result = this.getAFirstUncertainRead().getANextUncertainRead*()
  }

  /** Gets a textual representation of this assignable definition. */
  string toString() { none() }

  /** Gets the location of this assignable definition. */
  Location getLocation() {
    result = this.getExpr().getLocation()
  }
}

/** Provides different types of `AssignableDefinition`s. */
module AssignableDefinitions {
  /**
   * A non-tuple definition by direct assignment, for example `x = 0`.
   */
  class AssignmentDefinition extends AssignableDefinition, TAssignmentDefinition {
    Assignment a;

    AssignmentDefinition() {
      this = TAssignmentDefinition(a)
    }

    /** Gets the underlying assignment. */
    Assignment getAssignment() {
      result = a
    }

    override Expr getExpr() { result = a }

    override Expr getSource() {
      result = a.getRValue() and
      not a instanceof AssignOperation
    }

    override string toString() {
      result = a.toString()
    }
  }

  /**
   * A tuple definition by direct assignment, for example the definition of `x`
   * in `(x, y) = (0, 1)`.
   */
  class TupleAssignmentDefinition extends AssignableDefinition, TTupleAssignmentDefinition {
    AssignExpr ae;
    Expr leaf;

    TupleAssignmentDefinition() {
      this = TTupleAssignmentDefinition(ae, leaf)
    }

    /** Gets the underlying assignment. */
    AssignExpr getAssignment() {
      result = ae
    }

    /**
     * Gets the evaluation order of this definition among the other definitions
     * in the compound tuple assignment. For example, in `(x, (y, z)) = ...` the
     * orders of the definitions of `x`, `y`, and `z` are 0, 1, and 2, respectively.
     */
    int getEvaluationOrder() {
      leaf = rank[result + 1](Expr leaf0 |
        exists(TTupleAssignmentDefinition(ae, leaf0)) |
        leaf0 order by leaf0.getLocation().getStartLine(), leaf0.getLocation().getStartColumn()
      )
    }

    override Expr getExpr() { result = ae }

    override Expr getSource() {
      result = getTupleSource(this) // need not exist
    }

    override string toString() {
      result = ae.toString()
    }
  }

  /**
   * A definition via an `out`/`ref` argument in a call, for example
   * `M(out x, ref y)`.
   */
  class OutRefDefinition extends AssignableDefinition, TOutRefDefinition {
    AssignableAccess aa;

    OutRefDefinition() {
      this = TOutRefDefinition(aa)
    }

    /** Gets the underlying call. */
    Call getCall() {
      result.getAnArgument() = aa
    }

    /**
     * Gets the index of this definition among the other definitions in the
     * `out`/`ref` assignment. For example, in `M(out x, ref y)` the index of
     * the definitions of `x` and `y` are 0 and 1, respectively.
     */
    int getIndex() {
      exists(ControlFlow::BasicBlock bb, int i |
        bb.getNode(i).getElement() = aa |
        i = rank[result + 1](int j, OutRefDefinition def |
          bb.getNode(j).getElement() = def.getTargetAccess() and
          this.getCall() = def.getCall()
          |
          j
        )
      )
    }

    override Expr getExpr() { result = this.getCall() }

    override predicate isCertain() {
      not isUncertainRefCall(this.getCall(), this.getTargetAccess())
    }

    override string toString() {
      result = aa.toString()
    }

    override Location getLocation() {
      result = aa.getLocation()
    }
  }

  /**
   * A definition by mutation, for example `x++`.
   */
  class MutationDefinition extends AssignableDefinition, TMutationDefinition {
    MutatorOperation mo;

    MutationDefinition() {
      this = TMutationDefinition(mo)
    }

    /** Gets the underlying mutator operation. */
    MutatorOperation getMutatorOperation() {
      result = mo
    }

    override Expr getExpr() { result = mo }

    override string toString() {
      result = mo.toString()
    }
  }

  /**
   * A local variable definition without an initializer, for example `int i`.
   */
  class LocalVariableDefinition extends AssignableDefinition, TLocalVariableDefinition {
    LocalVariableDeclExpr lvde;

    LocalVariableDefinition() {
      this = TLocalVariableDefinition(lvde)
    }

    /** Gets the underlying local variable declaration. */
    LocalVariableDeclExpr getDeclaration() {
      result = lvde
    }

    override Expr getExpr() { result = lvde }

    override string toString() {
      result = lvde.toString()
    }
  }

  /**
   * An implicit parameter definition at the entry point of the
   * associated callable.
   */
  class ImplicitParameterDefinition extends AssignableDefinition, TImplicitParameterDefinition {
    Parameter p;

    ImplicitParameterDefinition() {
      this = TImplicitParameterDefinition(p)
    }

    /** Gets the underlying parameter. */
    Parameter getParameter() {
      result = p
    }

    override ControlFlow::Node getAControlFlowNode() {
      result = p.getCallable().getEntryPoint()
    }

    override Callable getEnclosingCallable() {
      result = p.getCallable()
    }

    override string toString() {
      result = p.toString()
    }

    override Location getLocation() {
      result = this.getTarget().getLocation()
    }
  }

  /**
   * An indirect address-of definition, for example `&x`.
   */
  class AddressOfDefinition extends AssignableDefinition, TAddressOfDefinition {
    AddressOfExpr aoe;

    AddressOfDefinition() {
      this = TAddressOfDefinition(aoe)
    }

    /** Gets the underlying address-of expression. */
    AddressOfExpr getAddressOf() {
      result = aoe
    }

    override Expr getExpr() { result = aoe }

    override string toString() {
      result = aoe.toString()
    }
  }

  /**
   * A local variable definition in an `is` pattern, for example `x is int i`.
   */
  class IsPatternDefinition extends AssignableDefinition, TIsPatternDefinition {
    IsPatternExpr ipe;

    IsPatternDefinition() {
      this = TIsPatternDefinition(ipe)
    }

    /** Gets the underlying local variable declaration. */
    LocalVariableDeclExpr getDeclaration() {
      result = ipe.getVariableDeclExpr()
    }

    override Expr getExpr() { result = this.getDeclaration() }

    override Expr getSource() {
      result = ipe.getExpr()
    }

    override string toString() {
      result = this.getDeclaration().toString()
    }
  }

  /**
   * A local variable definition in a type `case` pattern, for example
   * line 2 in
   *
   * ```
   * switch(p) {
   *   case string s:
   *     break;
   *   ...
   * }
   * ```
   */
  class TypeCasePatternDefinition extends AssignableDefinition, TTypeCasePatternDefinition {
    TypeCase tc;

    TypeCasePatternDefinition() {
      this = TTypeCasePatternDefinition(tc)
    }

    /** Gets the underlying local variable declaration. */
    LocalVariableDeclExpr getDeclaration() {
      result = tc.getVariableDeclExpr()
    }

    override Expr getExpr() { result = this.getDeclaration() }

    override Expr getSource() {
      result = any(SwitchStmt ss | ss.getATypeCase() = tc).getCondition()
    }

    override string toString() {
      result = this.getDeclaration().toString()
    }
  }

  /**
   * An initializer definition for a field or a property, for example
   * line 2 in
   *
   * ```
   * class C {
   *   int Field = 0;
   * }
   * ```
   */
  class InitializerDefinition extends AssignableDefinition, TInitializer {
    Assignable a;
    Expr e;

    InitializerDefinition() {
      this = TInitializer(a, e)
    }

    /** Gets the assignable (field or property) being initialized. */
    Assignable getAssignable() {
      result = a
    }

    override Expr getSource() {
      result = e
    }

    override string toString() {
      result = e.toString()
    }

    override Location getLocation() {
      result = e.getLocation()
    }
  }
}
