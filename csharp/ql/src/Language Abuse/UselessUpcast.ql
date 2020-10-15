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

/** A static callable. */
class StaticCallable extends Callable {
  StaticCallable() { this.(Modifiable).isStatic() }
}

/** An instance callable, that is, a non-static callable. */
class InstanceCallable extends Callable {
  InstanceCallable() { not this instanceof StaticCallable }
}

/** A call to a static callable. */
class StaticCall extends Call {
  StaticCall() {
    this.getTarget() instanceof StaticCallable and
    not this = any(ExtensionMethodCall emc | not emc.isOrdinaryStaticCall())
  }
}

/** Holds `t` has instance callable `c` as a member, with name `name`. */
pragma[nomagic]
predicate hasInstanceCallable(ValueOrRefType t, InstanceCallable c, string name) {
  t.hasMember(c) and
  name = c.getName()
}

/** Holds if extension method `m` is a method on `t` with name `name`. */
pragma[nomagic]
predicate hasExtensionMethod(ValueOrRefType t, ExtensionMethod m, string name) {
  t.isImplicitlyConvertibleTo(m.getExtendedType()) and
  name = m.getName()
}

/** Holds `t` has static callable `c` as a member, with name `name`. */
pragma[noinline]
predicate hasStaticCallable(ValueOrRefType t, StaticCallable c, string name) {
  t.hasMember(c) and
  name = c.getName()
}

/** Gets the minimum number of arguments required to call `c`. */
int getMinimumArguments(Callable c) {
  result =
    count(Parameter p |
      p = c.getAParameter() and
      not p.hasDefaultValue()
    )
}

/** Gets the maximum number of arguments allowed to call `c`, if any. */
int getMaximumArguments(Callable c) {
  not c.getAParameter().isParams() and
  result = c.getNumberOfParameters()
}

private class ConstructorCall extends Call {
  ConstructorCall() {
    this instanceof ObjectCreation or
    this instanceof ConstructorInitializer
  }
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

  /** Holds if this upcast may be used to disambiguate the target of an instance call. */
  pragma[nomagic]
  private predicate isDisambiguatingInstanceCall(InstanceCallable other, int args) {
    exists(Call c, InstanceCallable target, ValueOrRefType t | this.isArgument(c, target) |
      t = c.(QualifiableExpr).getQualifier().getType() and
      hasInstanceCallable(t, other, target.getName()) and
      args = c.getNumberOfArguments() and
      other != target
    )
  }

  /** Holds if this upcast may be used to disambiguate the target of an extension method call. */
  pragma[nomagic]
  private predicate isDisambiguatingExtensionCall(ExtensionMethod other, int args) {
    exists(ExtensionMethodCall c, ExtensionMethod target, ValueOrRefType t |
      this.isArgument(c, target)
    |
      not c.isOrdinaryStaticCall() and
      t = target.getParameter(0).getType() and
      hasExtensionMethod(t, other, target.getName()) and
      args = c.getNumberOfArguments() and
      other != target
    )
  }

  pragma[nomagic]
  private predicate isDisambiguatingStaticCall0(
    StaticCall c, StaticCallable target, string name, ValueOrRefType t
  ) {
    this.isArgument(c, target) and
    name = target.getName() and
    (
      t = c.(QualifiableExpr).getQualifier().getType()
      or
      not c.(QualifiableExpr).hasQualifier() and
      t = target.getDeclaringType()
    )
  }

  /** Holds if this upcast may be used to disambiguate the target of a static call. */
  pragma[nomagic]
  private predicate isDisambiguatingStaticCall(StaticCallable other, int args) {
    exists(StaticCall c, StaticCallable target, ValueOrRefType t, string name |
      this.isDisambiguatingStaticCall0(c, target, name, t)
    |
      hasStaticCallable(t, other, name) and
      args = c.getNumberOfArguments() and
      other != target
    )
  }

  /** Holds if this upcast may be used to disambiguate the target of a constructor call. */
  pragma[nomagic]
  private predicate isDisambiguatingConstructorCall(Constructor other, int args) {
    exists(ConstructorCall cc, Constructor target, ValueOrRefType t | this.isArgument(cc, target) |
      t = target.getDeclaringType() and
      t.hasMember(other) and
      args = cc.getNumberOfArguments() and
      other != target
    )
  }

  /** Holds if this upcast may be used to disambiguate the target of a call. */
  private predicate isDisambiguatingCall() {
    exists(Callable other, int args |
      this.isDisambiguatingInstanceCall(other, args)
      or
      this.isDisambiguatingExtensionCall(other, args)
      or
      this.isDisambiguatingStaticCall(other, args)
      or
      this.isDisambiguatingConstructorCall(other, args)
    |
      args >= getMinimumArguments(other) and
      not args > getMaximumArguments(other)
    )
  }

  /** Holds if this is a useful upcast. */
  predicate isUseful() {
    this.isDisambiguatingCall()
    or
    this = any(Call c).(QualifiableExpr).getQualifier() and
    dest instanceof Interface
    or
    this = any(OperatorCall oc).getAnArgument()
    or
    this =
      any(Operation o |
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
    this = any(LocalVariableDeclAndInitExpr decl | decl.isImplicitlyTyped()).getInitializer()
    or
    exists(LambdaExpr c | c.canReturn(this))
  }
}

from ExplicitUpcast u, ValueOrRefType src, ValueOrRefType dest
where
  src = u.getSourceType() and
  dest = u.getTargetType() and
  not u.isUseful()
select u, "There is no need to upcast from $@ to $@ - the conversion can be done implicitly.", src,
  src.getName(), dest, dest.getName()
