/**
 * @name Useless upcast
 * @description Casting an expression is normally not needed when there exists an implicit conversion.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/useless-upcast
 * @tags maintainability
 *       language-features
 *       external/cwe/cwe-561
 */

import csharp

/** A callable that is not an extension method. */
private class NonExtensionMethod extends Callable {
  NonExtensionMethod() {
    not this instanceof ExtensionMethod
  }
}

/** Holds if non-extension callable `c` is a member of type `t` with name `name`. */
pragma [noinline]
private predicate hasCallable(ValueOrRefType t, NonExtensionMethod c, string name) {
  t.hasMember(c) and
  name = c.getName()
}

/** Holds if extension method `m` is a method on `t` with name `name`. */
pragma [noinline]
private predicate hasExtensionMethod(ValueOrRefType t, ExtensionMethod m, string name) {
  t.isImplicitlyConvertibleTo(m.getExtendedType()) and
  name = m.getName()
}

/** An explicit upcast. */
class ExplicitUpcast extends ExplicitCast {
  ValueOrRefType src;
  ValueOrRefType dest;

  ExplicitUpcast() {
    src = this.getSourceType() and
    dest = this.getTargetType() and
    (src instanceof RefType or src instanceof Struct) and
    src.isImplicitlyConvertibleTo(dest) and
    src != dest // Handled by `cs/useless-cast-to-self`
  }

  /** Holds if this upcast is the argument of a call to `target`. */
  private predicate isArgument(Call c, Callable target) {
    exists(Parameter p |
      this = p.getAnAssignedArgument() and
      p.getType() = this.getType() and
      c.getAnArgument() = this and
      target = c.getTarget()
    )
  }

  pragma [noinline]
  private predicate isDisambiguatingNonExtensionMethod0(NonExtensionMethod target, ValueOrRefType t) {
    exists(Call c |
      this.isArgument(c, target) |
      t = c.(QualifiableExpr).getQualifier().getType()
      or
      not exists(c.(QualifiableExpr).getQualifier()) and
      t = target.getDeclaringType()
    )
  }

  /**
   * Holds if this upcast may be used to affect call resolution in a non-extension
   * method call.
   */
  private predicate isDisambiguatingNonExtensionMethodCall() {
    exists(NonExtensionMethod target, NonExtensionMethod other, ValueOrRefType t |
      this.isDisambiguatingNonExtensionMethod0(target, t) |
      hasCallable(t, other, target.getName()) and
      other != target
    )
  }

  /**
   * Holds if this upcast may be used to affect call resolution in an extension
   * method call.
   */
  private predicate isDisambiguatingExtensionMethodCall() {
    exists(Call c, ExtensionMethod target, ExtensionMethod other, ValueOrRefType t |
      this.isArgument(c, target) |
      t = c.getArgument(0).getType() and
      hasExtensionMethod(t, other, target.getName()) and
      other != target
    )
  }

  /** Holds if this is a useful upcast. */
  predicate isUseful() {
    this.isDisambiguatingNonExtensionMethodCall()
    or
    this.isDisambiguatingExtensionMethodCall()
    or
    this = any(Call c).(QualifiableExpr).getQualifier() and
    dest instanceof Interface
    or
    this = any(OperatorCall oc).getAnArgument()
    or
    this = any(Operation o |
      not o instanceof Assignment and
      not o instanceof UnaryBitwiseOperation and
      not o instanceof SizeofExpr and
      not o instanceof PointerIndirectionExpr and
      not o instanceof AddressOfExpr and
      not o instanceof UnaryLogicalOperation and
      not o instanceof BinaryBitwiseOperation and
      not o instanceof LogicalAndExpr and
      not o instanceof LogicalOrExpr
    ).getAnOperand()
    or
    this = any(LocalVariableDeclAndInitExpr decl |
      decl.isImplicitlyTyped()
    ).getInitializer()
    or
    exists(LambdaExpr c | c.canReturn(this))
  }
}

from ExplicitUpcast u, ValueOrRefType src, ValueOrRefType dest
where src = u.getSourceType()
  and dest = u.getTargetType()
  and not u.isUseful()
select u, "There is no need to upcast from $@ to $@ - the conversion can be done implicitly.",
  src, src.getName(),
  dest, dest.getName()
