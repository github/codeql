import csharp

/**
 * INTERNAL: Do not use.
 *
 * Provides functionality for performing simple data flow analysis.
 * This library is used by the dispatch library, which in turn is used by the
 * SSA library, so we cannot make use of the SSA library in this library.
 * Instead, this library relies on a self-contained, minimalistic SSA-like
 * implementation.
 */
module Steps {
  private import semmle.code.csharp.dataflow.internal.BaseSSA

  /**
   * Gets a read that is guaranteed to read the value assigned at definition `def`.
   */
  private AssignableRead getARead(AssignableDefinition def) {
    result = BaseSsa::getARead(def, _)
    or
    exists(LocalScopeVariable v | def.getTarget() = v |
      result = v.getAnAccess() and
      strictcount(AssignableDefinition def0 | def0.getTarget() = v) = 1
    )
    or
    exists(Field f |
      def.getTarget() = f and
      result = f.getAnAccess() and
      strictcount(AssignableDefinition def0 | def0.getTarget() = f) = 1
    |
      f.isReadOnly() or
      f.isConst() or
      isEffectivelyInternalOrPrivate(f)
    )
  }

  /**
   * Holds if callable `c` is effectively private or internal (either directly
   * or because one of `c`'s enclosing types is).
   */
  private predicate isEffectivelyInternalOrPrivateCallable(Callable c) {
    isEffectivelyInternalOrPrivate(c) or
    c instanceof LocalFunction
  }

  /**
   * Holds if modifiable `m` is effectively private or internal (either directly
   * or because one of `m`'s enclosing types is).
   */
  private predicate isEffectivelyInternalOrPrivate(Modifiable m) { not m.isEffectivelyPublic() }

  private predicate flowIn(Parameter p, Expr pred, AssignableRead succ) {
    exists(AssignableDefinitions::ImplicitParameterDefinition def, Call c | succ = getARead(def) |
      pred = getArgumentForOverridderParameter(c, p) and
      p.getSourceDeclaration() = def.getParameter()
    )
  }

  private Expr getArgumentForOverridderParameter(Call call, Parameter p) {
    exists(Parameter base, Callable callable | result = call.getArgumentForParameter(base) |
      base = callable.getAParameter() and
      isOverriderParameter(callable, p, base.getPosition())
    )
  }

  pragma[noinline]
  private predicate isOverriderParameter(Callable c, Parameter p, int i) {
    (
      p = c.getAParameter() or
      p = c.(Method).getAnOverrider+().getAParameter() or
      p = c.(Method).getAnUltimateImplementor().getAParameter()
    ) and
    i = p.getPosition()
  }

  /**
   * Holds if there is data flow from `pred` to `succ`, under a closed-world
   * assumption. For example, there is flow from `0` on line 3 to `i` on line
   * 8 and from `1` on line 4 to `i` on line 12 in
   *
   * ```csharp
   * public class C {
   *   public void A() {
   *     B(0);
   *     C(1);
   *   }
   *
   *   private void B(int i) {
   *     System.Console.WriteLine(i);
   *   }
   *
   *   public virtual void C(int i) {
   *     System.Console.WriteLine(i);
   *   }
   * }
   * ```
   */
  predicate stepClosed(Expr pred, Expr succ) {
    stepOpen(pred, succ) or
    flowIn(_, pred, succ)
  }

  /**
   * Holds if there is data flow from `pred` to `succ`, under an open-world
   * assumption. For example, there is flow from `0` on line 3 to `i` on line
   * 8 (but not from `1` on line 4 to `i` on line 12 because `C` is virtual)
   * in
   *
   * ```csharp
   * public class C {
   *   public void A() {
   *     B(0);
   *     C(1);
   *   }
   *
   *   private void B(int i) {
   *     System.Console.WriteLine(i);
   *   }
   *
   *   public virtual void C(int i) {
   *     System.Console.WriteLine(i);
   *   }
   * }
   * ```
   */
  predicate stepOpen(Expr pred, Expr succ) {
    exists(AssignableDefinition def | succ = getARead(def) | pred = def.getSource())
    or
    exists(Parameter p | flowIn(p, pred, succ) |
      isEffectivelyInternalOrPrivateCallable(p.getCallable())
    )
    or
    pred = succ.(CastExpr).getExpr()
  }
}
