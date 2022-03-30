/**
 * Provides the module `Ssa` for working with static single assignment (SSA) form.
 */

import csharp

/**
 * Provides classes for working with static single assignment (SSA) form.
 */
module Ssa {
  private import internal.SsaImpl as SsaImpl

  /**
   * A variable that can be SSA converted.
   *
   * Either a local scope variable (`SourceVariables::LocalScopeSourceVariable`)
   * or a fully qualified field or property (`SourceVariables::FieldOrPropSourceVariable`),
   * `q.fp1.fp2....fpn`, where the base qualifier `q` is either `this`, a local
   * scope variable, or a type in case `fp1` is static.
   */
  class SourceVariable extends SsaImpl::TSourceVariable {
    /**
     * Gets the assignable corresponding to this source variable. Either
     * a local scope variable, a field, or a property.
     */
    Assignable getAssignable() { none() }

    /** Gets an access to this source variable. */
    AssignableAccess getAnAccess() { result = SsaImpl::getAnAccess(this) }

    /** Gets a definition of this source variable. */
    AssignableDefinition getADefinition() {
      result.getTargetAccess() = this.getAnAccess()
      or
      // Local variable declaration without initializer
      not exists(result.getTargetAccess()) and
      this =
        any(SourceVariables::LocalScopeSourceVariable v |
          result.getTarget() = v.getAssignable() and
          result.getEnclosingCallable() = v.getEnclosingCallable()
        )
    }

    /**
     * Holds if this variable is captured by a nested callable.
     */
    predicate isCaptured() { this.getAssignable().(LocalScopeVariable).isCaptured() }

    /** Gets the callable in which this source variable is defined. */
    Callable getEnclosingCallable() { none() }

    /** Gets a textual representation of this source variable. */
    string toString() { none() }

    /** Gets the location of this source variable. */
    Location getLocation() { none() }

    /** Gets the type of this source variable. */
    Type getType() { result = this.getAssignable().getType() }

    /** Gets the qualifier of this source variable, if any. */
    SourceVariable getQualifier() { none() }

    /**
     * Gets an SSA definition that has this variable as its underlying
     * source variable.
     */
    Definition getAnSsaDefinition() { result.getSourceVariable() = this }
  }

  /** Provides different types of `SourceVariable`s. */
  module SourceVariables {
    /** A local scope variable. */
    class LocalScopeSourceVariable extends SourceVariable, SsaImpl::TLocalVar {
      override LocalScopeVariable getAssignable() { this = SsaImpl::TLocalVar(_, result) }

      override Callable getEnclosingCallable() { this = SsaImpl::TLocalVar(result, _) }

      override string toString() { result = this.getAssignable().getName() }

      override Location getLocation() { result = this.getAssignable().getLocation() }
    }

    /** A fully qualified field or property. */
    class FieldOrPropSourceVariable extends SourceVariable {
      FieldOrPropSourceVariable() {
        this = SsaImpl::TPlainFieldOrProp(_, _) or
        this = SsaImpl::TQualifiedFieldOrProp(_, _, _)
      }

      override Assignable getAssignable() {
        this = SsaImpl::TPlainFieldOrProp(_, result) or
        this = SsaImpl::TQualifiedFieldOrProp(_, _, result)
      }

      /**
       * Gets the first access to this field or property in terms of source
       * code location. This is used as the representative location.
       */
      private AssignableAccess getFirstAccess() {
        result =
          min(this.getAnAccess() as a
            order by
              a.getLocation().getStartLine(), a.getLocation().getStartColumn()
          )
      }

      override Location getLocation() { result = this.getFirstAccess().getLocation() }
    }

    /** A plain field or property. */
    class PlainFieldOrPropSourceVariable extends FieldOrPropSourceVariable,
      SsaImpl::TPlainFieldOrProp {
      override Callable getEnclosingCallable() { this = SsaImpl::TPlainFieldOrProp(result, _) }

      override string toString() {
        exists(Assignable f, string prefix |
          f = this.getAssignable() and
          result = prefix + "." + this.getAssignable()
        |
          if f.(Modifiable).isStatic()
          then prefix = f.getDeclaringType().getQualifiedName()
          else prefix = "this"
        )
      }
    }

    /** A qualified field or property. */
    class QualifiedFieldOrPropSourceVariable extends FieldOrPropSourceVariable,
      SsaImpl::TQualifiedFieldOrProp {
      override Callable getEnclosingCallable() {
        this = SsaImpl::TQualifiedFieldOrProp(result, _, _)
      }

      override SourceVariable getQualifier() { this = SsaImpl::TQualifiedFieldOrProp(_, result, _) }

      override string toString() { result = this.getQualifier() + "." + this.getAssignable() }
    }
  }

  private string getSplitString(Definition def) {
    exists(ControlFlow::BasicBlock bb, int i, ControlFlow::Node cfn |
      def.definesAt(_, bb, i) and
      result = cfn.(ControlFlow::Nodes::ElementNode).getSplitsString()
    |
      cfn = bb.getNode(i)
      or
      not exists(bb.getNode(i)) and
      cfn = bb.getFirstNode()
    )
  }

  private string getToStringPrefix(Definition def) {
    result = "[" + getSplitString(def) + "] "
    or
    not exists(getSplitString(def)) and
    result = ""
  }

  /**
   * A static single assignment (SSA) definition. Either an explicit variable
   * definition (`ExplicitDefinition`), an implicit variable definition
   * (`ImplicitDefinition`), or a phi node (`PhiNode`).
   */
  class Definition extends SsaImpl::Definition {
    final override SourceVariable getSourceVariable() {
      result = SsaImpl::Definition.super.getSourceVariable()
    }

    /**
     * Gets the control flow node of this SSA definition, if any. Phi nodes are
     * examples of SSA definitions without a control flow node, as they are
     * modeled at index `-1` in the relevant basic block.
     */
    final ControlFlow::Node getControlFlowNode() {
      exists(ControlFlow::BasicBlock bb, int i | this.definesAt(_, bb, i) | result = bb.getNode(i))
    }

    /**
     * Holds is this SSA definition is live at the end of basic block `bb`.
     * That is, this definition reaches the end of basic block `bb`, at which
     * point it is still live, without crossing another SSA definition of the
     * same source variable.
     */
    final predicate isLiveAtEndOfBlock(ControlFlow::BasicBlock bb) {
      SsaImpl::isLiveAtEndOfBlock(this, bb)
    }

    /**
     * Gets a read of the source variable underlying this SSA definition that
     * can be reached from this SSA definition without passing through any
     * other SSA definitions. Example:
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
     * - The reads of `i` on lines 4, 6, 7, and 8 can be reached from the explicit
     *   SSA definition (wrapping an implicit entry definition) on line 3.
     * - The read of `this.Field` on line 5 can be reached from the explicit SSA
     *   definition on line 4.
     * - The reads of `this.Field` on lines 10 and 11 can be reached from the phi
     *   node between lines 9 and 10.
     */
    final AssignableRead getARead() { result = this.getAReadAtNode(_) }

    /**
     * Gets a read of the source variable underlying this SSA definition at
     * control flow node `cfn` that can be reached from this SSA definition
     * without passing through any other SSA definitions. Example:
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
     * - The reads of `i` on lines 4, 6, 7, and 8 can be reached from the implicit
     *   entry definition on line 3.
     * - The read of `this.Field` on line 5 can be reached from the explicit SSA
     *   definition on line 4.
     * - The reads of `this.Field` on lines 10 and 11 can be reached from the phi
     *   node between lines 9 and 10.
     */
    final AssignableRead getAReadAtNode(ControlFlow::Node cfn) {
      result = SsaImpl::getAReadAtNode(this, cfn)
    }

    /**
     * Gets a read of the source variable underlying this SSA definition that
     * can be reached from this SSA definition without passing through any
     * other SSA definition or read. Example:
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
     * - The read of `i` on line 4 can be reached from the explicit SSA
     *   definition (wrapping an implicit entry definition) on line 3.
     * - The reads of `i` on lines 6 and 7 are not the first reads of any SSA
     *   definition.
     * - The read of `this.Field` on line 5 can be reached from the explicit SSA
     *   definition on line 4.
     * - The read of `this.Field` on line 10 can be reached from the phi node
     *   between lines 9 and 10.
     * - The read of `this.Field` on line 11 is not the first read of any SSA
     *   definition.
     *
     * Subsequent reads can be found by following the steps defined by
     * `AssignableRead.getANextRead()`.
     */
    final AssignableRead getAFirstRead() { result = this.getAFirstReadAtNode(_) }

    /**
     * Gets a read of the source variable underlying this SSA definition at
     * control flow node `cfn` that can be reached from this SSA definition
     * without passing through any other SSA definition or read. Example:
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
     * - The read of `i` on line 4 can be reached from the explicit SSA
     *   definition (wrapping an implicit entry definition) on line 3.
     * - The reads of `i` on lines 6 and 7 are not the first reads of any SSA
     *   definition.
     * - The read of `this.Field` on line 5 can be reached from the explicit SSA
     *   definition on line 4.
     * - The read of `this.Field` on line 10 can be reached from the phi node
     *   between lines 9 and 10.
     * - The read of `this.Field` on line 11 is not the first read of any SSA
     *   definition.
     *
     * Subsequent reads can be found by following the steps defined by
     * `AssignableRead.getANextRead()`.
     */
    final AssignableRead getAFirstReadAtNode(ControlFlow::Node cfn) {
      SsaImpl::firstReadSameVar(this, cfn) and
      result.getAControlFlowNode() = cfn
    }

    /**
     * Gets a last read of the source variable underlying this SSA definition.
     * That is, a read that can reach the end of the enclosing callable, or
     * another SSA definition for the source variable, without passing through
     * any other read. Example:
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
     * - The reads of `i` on lines 7 and 8 are the last reads for the implicit
     *   parameter definition on line 3.
     * - The read of `this.Field` on line 5 is a last read of the definition on
     *   line 4.
     * - The read of `this.Field` on line 11 is a last read of the phi node
     *   between lines 9 and 10.
     */
    final AssignableRead getALastRead() { result = this.getALastReadAtNode(_) }

    /**
     * Gets a last read of the source variable underlying this SSA definition at
     * control flow node `cfn`. That is, a read that can reach the end of the
     * enclosing callable, or another SSA definition for the source variable,
     * without passing through any other read. Example:
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
     * - The reads of `i` on lines 7 and 8 are the last reads for the implicit
     *   parameter definition on line 3.
     * - The read of `this.Field` on line 5 is a last read of the definition on
     *   line 4.
     * - The read of `this.Field` on line 11 is a last read of the phi node
     *   between lines 9 and 10.
     */
    final AssignableRead getALastReadAtNode(ControlFlow::Node cfn) {
      SsaImpl::lastReadSameVar(this, cfn) and
      result.getAControlFlowNode() = cfn
    }

    /**
     * Gets an SSA definition whose value can flow to this one in one step. This
     * includes inputs to phi nodes and the prior definitions of uncertain writes.
     */
    private Definition getAPhiInputOrPriorDefinition() {
      result = this.(PhiNode).getAnInput() or
      result = this.(UncertainDefinition).getPriorDefinition()
    }

    /**
     * Gets a definition that ultimately defines this SSA definition and is
     * not itself a phi node. Example:
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
     * - The explicit SSA definition (wrapping an implicit entry definition) of `i`
     *   on line 3 is defined in terms of itself.
     * - The explicit SSA definitions of `this.Field` on lines 4 and 7 are defined
     *   in terms of themselves.
     * - The implicit SSA definition of `this.Field` on line 9 is defined in terms
     *   of itself and the explicit definition on line 4.
     * - The phi node between lines 9 and 10 is defined in terms of the explicit
     *   definition on line 4, the explicit definition on line 7, and the implicit
     *   definition on line 9.
     */
    final Definition getAnUltimateDefinition() {
      result = this.getAPhiInputOrPriorDefinition*() and
      not result instanceof PhiNode
    }

    /**
     * Gets the syntax element associated with this SSA definition, if any.
     * This is either an expression, for example `x = 0`, a parameter, or a
     * callable. Phi nodes have no associated syntax element.
     */
    Element getElement() { result = this.getControlFlowNode().getElement() }

    /** Gets the callable to which this SSA definition belongs. */
    final Callable getEnclosingCallable() {
      result = this.getSourceVariable().getEnclosingCallable()
    }

    /**
     * Holds if this SSA definition assigns to `out`/`ref` parameter `p`, and the
     * parameter may remain unchanged throughout the rest of the enclosing callable.
     */
    final predicate isLiveOutRefParameterDefinition(Parameter p) {
      SsaImpl::isLiveOutRefParameterDefinition(this, p)
    }

    /** Gets the location of this SSA definition. */
    Location getLocation() { none() }
  }

  /**
   * An SSA definition that corresponds to an explicit assignable definition.
   */
  class ExplicitDefinition extends Definition, SsaImpl::WriteDefinition {
    SourceVariable sv;
    AssignableDefinition ad;

    ExplicitDefinition() { SsaImpl::explicitDefinition(this, sv, ad) }

    /**
     * Gets an underlying assignable definition. The result is always unique,
     * except for pathological `out`/`ref` assignments like `M(out x, out x)`,
     * where there may be more than one underlying definition.
     */
    final AssignableDefinition getADefinition() { result = SsaImpl::getADefinition(this) }

    /**
     * Holds if this definition updates a captured local scope variable, and the updated
     * value may be read from the implicit entry definition `def` using one or more calls
     * (as indicated by `additionalCalls`), starting from call `c`.
     *
     * Example:
     *
     * ```csharp
     * class C {
     *   void M1() {
     *     int i = 0;
     *     void M2() => System.Console.WriteLine(i);
     *     i = 1;
     *     M2();
     *   }
     * }
     * ```
     *
     * If this definition is the update of `i` on line 5, then the value may be read inside
     * `M2` via the call on line 6.
     */
    final predicate isCapturedVariableDefinitionFlowIn(
      ImplicitEntryDefinition def, ControlFlow::Nodes::ElementNode c, boolean additionalCalls
    ) {
      SsaImpl::isCapturedVariableDefinitionFlowIn(this, def, c, additionalCalls)
    }

    /**
     * Holds if this definition updates a captured local scope variable, and the updated
     * value may be read from the implicit call definition `cdef` using one or more calls
     * (as indicated by `additionalCalls`).
     *
     * Example:
     *
     * ```csharp
     * class C {
     *   void M1() {
     *     int i = 0;
     *     void M2() { i = 2; };
     *     M2();
     *     System.Console.WriteLine(i);
     *   }
     * }
     * ```
     *
     * If this definition is the update of `i` on line 4, then the value may be read outside
     * of `M2` via the call on line 5.
     */
    final predicate isCapturedVariableDefinitionFlowOut(
      ImplicitCallDefinition cdef, boolean additionalCalls
    ) {
      SsaImpl::isCapturedVariableDefinitionFlowOut(this, cdef, additionalCalls)
    }

    override Element getElement() { result = ad.getElement() }

    override string toString() {
      if this.getADefinition() instanceof AssignableDefinitions::ImplicitParameterDefinition
      then result = getToStringPrefix(this) + "SSA param(" + this.getSourceVariable() + ")"
      else result = getToStringPrefix(this) + "SSA def(" + this.getSourceVariable() + ")"
    }

    override Location getLocation() { result = ad.getLocation() }
  }

  /**
   * An SSA definition that does not correspond to an explicit variable definition.
   * Either an implicit initialization of a variable at the beginning of a callable
   * (`ImplicitEntryDefinition`), an implicit definition via a call
   * (`ImplicitCallDefinition`), or an implicit definition where the qualifier is
   * updated (`ImplicitQualifierDefinition`).
   */
  class ImplicitDefinition extends Definition, SsaImpl::WriteDefinition {
    ImplicitDefinition() {
      exists(ControlFlow::BasicBlock bb, SourceVariable v, int i | this.definesAt(v, bb, i) |
        SsaImpl::implicitEntryDefinition(bb, v) and
        i = -1
        or
        SsaImpl::updatesNamedFieldOrProp(bb, i, _, v, _)
        or
        SsaImpl::updatesCapturedVariable(bb, i, _, v, _, _)
        or
        SsaImpl::variableWriteQualifier(bb, i, v, _)
      )
    }
  }

  /**
   * An SSA definition representing the implicit initialization of a variable
   * at the beginning of a callable. Either the variable is a local scope variable
   * captured by the callable, or a field or property accessed inside the callable.
   */
  class ImplicitEntryDefinition extends ImplicitDefinition {
    ImplicitEntryDefinition() {
      exists(ControlFlow::BasicBlock bb, SourceVariable v |
        this.definesAt(v, bb, -1) and
        SsaImpl::implicitEntryDefinition(bb, v)
      )
    }

    /** Gets the callable that this entry definition belongs to. */
    final Callable getCallable() { result = this.getBasicBlock().getCallable() }

    override Callable getElement() { result = this.getCallable() }

    override string toString() {
      if this.getSourceVariable().getAssignable() instanceof LocalScopeVariable
      then result = getToStringPrefix(this) + "SSA capture def(" + this.getSourceVariable() + ")"
      else result = getToStringPrefix(this) + "SSA entry def(" + this.getSourceVariable() + ")"
    }

    override Location getLocation() { result = this.getCallable().getLocation() }
  }

  /**
   * An SSA definition representing the potential definition of a variable
   * via a call.
   */
  class ImplicitCallDefinition extends ImplicitDefinition {
    private Call c;

    ImplicitCallDefinition() {
      exists(ControlFlow::BasicBlock bb, SourceVariable v, int i | this.definesAt(v, bb, i) |
        SsaImpl::updatesNamedFieldOrProp(bb, i, c, v, _)
        or
        SsaImpl::updatesCapturedVariable(bb, i, c, v, _, _)
      )
    }

    /** Gets the underlying call. */
    final Call getCall() { result = c }

    /**
     * Gets one of the definitions that may contribute to this implicit
     * call definition. That is, a definition that can be reached from
     * the target of this call following zero or more additional calls,
     * and which targets the same assignable as this SSA definition.
     */
    final AssignableDefinition getAPossibleDefinition() {
      exists(Callable setter | SsaImpl::updatesNamedFieldOrProp(_, _, this.getCall(), _, setter) |
        result.getEnclosingCallable() = setter and
        result.getTarget() = this.getSourceVariable().getAssignable()
      )
      or
      SsaImpl::updatesCapturedVariable(_, _, this.getCall(), _, result, _) and
      result.getTarget() = this.getSourceVariable().getAssignable()
    }

    override string toString() {
      result = getToStringPrefix(this) + "SSA call def(" + this.getSourceVariable() + ")"
    }

    override Location getLocation() { result = this.getCall().getLocation() }
  }

  /**
   * An SSA definition representing the potential definition of a variable
   * via an SSA definition for the qualifier.
   */
  class ImplicitQualifierDefinition extends ImplicitDefinition, SsaImpl::WriteDefinition {
    private Definition q;

    ImplicitQualifierDefinition() {
      exists(
        ControlFlow::BasicBlock bb, int i, SourceVariables::QualifiedFieldOrPropSourceVariable v
      |
        this.definesAt(v, bb, i)
      |
        SsaImpl::variableWriteQualifier(bb, i, v, _) and
        q.definesAt(v.getQualifier(), bb, i)
      )
    }

    /** Gets the SSA definition for the qualifier. */
    final Definition getQualifierDefinition() { result = q }

    override string toString() {
      result = getToStringPrefix(this) + "SSA qualifier def(" + this.getSourceVariable() + ")"
    }

    override Location getLocation() { result = this.getQualifierDefinition().getLocation() }
  }

  /**
   * An SSA phi node, that is, a pseudo definition for a variable at a point
   * in the flow graph where otherwise two or more definitions for the variable
   * would be visible.
   */
  class PhiNode extends Definition, SsaImpl::PhiNode {
    /**
     * Gets an input of this phi node. Example:
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
     * - The phi node for `this.Field` between lines 9 and 10 has the explicit
     *   definition on line 4, the explicit definition on line 7, and the implicit
     *   call definition on line 9 as inputs.
     */
    final Definition getAnInput() { this.hasInputFromBlock(result, _) }

    /** Holds if `inp` is an input to this phi node along the edge originating in `bb`. */
    predicate hasInputFromBlock(Definition inp, ControlFlow::BasicBlock bb) {
      inp = SsaImpl::phiHasInputFromBlock(this, bb)
    }

    override string toString() {
      result = getToStringPrefix(this) + "SSA phi(" + this.getSourceVariable() + ")"
    }

    /*
     * The location of a phi node is the same as the location of the first node
     * in the basic block in which it is defined.
     *
     * Strictly speaking, the node is *before* the first node, but such a location
     * does not exist in the source program.
     */

    override Location getLocation() { result = this.getBasicBlock().getFirstNode().getLocation() }
  }

  /**
   * An SSA definition that represents an uncertain update of the underlying
   * assignable. Either an explicit update that is uncertain (`ref` assignments
   * need not be certain), an implicit non-local update via a call, or an
   * uncertain update of the qualifier.
   */
  class UncertainDefinition extends Definition, SsaImpl::UncertainWriteDefinition {
    /**
     * Gets the immediately preceding definition. Since this update is uncertain,
     * the value from the preceding definition might still be valid.
     */
    Definition getPriorDefinition() { result = SsaImpl::uncertainWriteDefinitionInput(this) }
  }
}
