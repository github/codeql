/**
 * INTERNAL: Do not use.
 *
 * Provides logic for resolving viable run-time target callables
 * (non-delegate calls only).
 */

import csharp
private import RuntimeCallable
private import OverridableCallable
private import semmle.code.csharp.Conversion
private import semmle.code.csharp.dataflow.internal.Steps
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.system.Reflection

/** A call. */
class DispatchCall extends Internal::TDispatchCall {
  /** Gets a textual representation of this call. */
  string toString() { result = getCall().toString() }

  /** Gets the location of this call. */
  Location getLocation() { result = getCall().getLocation() }

  /** Gets the underlying expression of this call. */
  Expr getCall() { result = Internal::getCall(this) }

  /** Gets the `i`th argument of this call. */
  Expr getArgument(int i) { result = Internal::getArgument(this, i) }

  /** Gets the qualifier of this call, if any. */
  Expr getQualifier() { result = Internal::getQualifier(this) }

  /** Gets a static (compile-time) target of this call. */
  Callable getAStaticTarget() { result = Internal::getAStaticTarget(this) }

  /** Gets a dynamic (run-time) target of this call, if any. */
  RuntimeCallable getADynamicTarget() { result = Internal::getADynamicTarget(this) }
}

/** Internal implementation details. */
private module Internal {
  private import semmle.code.csharp.Implements

  cached
  private module Cached {
    /** Internal representation of calls. */
    cached
    newtype TDispatchCall =
      TDispatchMethodCall(MethodCall mc) {
        not isReflectionCall(mc, _, _, _, _) and
        not mc.isLateBound()
      } or
      TDispatchAccessorCall(AccessorCall ac) or
      TDispatchReflectionCall(MethodCall mc, string name, Expr object, Expr qualifier, int args) {
        isReflectionCall(mc, name, object, qualifier, args)
      } or
      TDispatchDynamicMethodCall(DynamicMethodCall dmc) or
      TDispatchDynamicOperatorCall(DynamicOperatorCall doc) or
      TDispatchDynamicMemberAccess(DynamicMemberAccess dma) or
      TDispatchDynamicElementAccess(DynamicElementAccess dea) or
      TDispatchDynamicEventAccess(
        AssignArithmeticOperation aao, DynamicMemberAccess dma, string name
      ) {
        isPotentialEventCall(aao, dma, name)
      } or
      TDispatchDynamicObjectCreation(DynamicObjectCreation doc) or
      TDispatchStaticCall(Call c) {
        c = any(ObjectCreation oc | not oc.isLateBound())
        or
        c instanceof ConstructorInitializer
        or
        c = any(OperatorCall oc | not oc.isLateBound())
        or
        c instanceof LocalFunctionCall
      }

    cached
    Expr getCall(DispatchCall dc) { result = dc.(DispatchCallImpl).getCall() }

    cached
    Expr getArgument(DispatchCall dc, int i) { result = dc.(DispatchCallImpl).getArgument(i) }

    cached
    Expr getQualifier(DispatchCall dc) { result = dc.(DispatchCallImpl).getQualifier() }

    cached
    RuntimeCallable getADynamicTarget(DispatchCall dc) {
      result = dc.(DispatchCallImpl).getADynamicTarget()
    }
  }
  import Cached

  Callable getAStaticTarget(DispatchCall dc) { result = dc.(DispatchCallImpl).getAStaticTarget() }

  /**
   * Holds if `mc` is a reflection call to a method named `name`, where
   * `object` is the object on which to invoke the method (`null` if a
   * static method is invoked) and `qualifier` is the qualifier of the
   * reflection call.
   */
  private predicate isReflectionCall(
    MethodCall mc, string name, Expr object, Expr qualifier, int args
  ) {
    exists(SystemTypeClass stc |
      mc.getTarget() = stc.getInvokeMemberMethod() and
      mc.getArgument(0).getValue() = name and
      args = 4 and
      object = mc.getArgument(3) and
      qualifier = mc.getQualifier()
      or
      exists(MethodCall mc2 |
        mc2 = getAMethodCallArgSource(mc.getQualifier()) and
        mc2.getTarget() = stc.getGetMethodMethod() and
        mc2.getArgument(0).getValue() = name and
        object = mc.getArgument(0) and
        qualifier = mc2.getQualifier() and
        exists(SystemReflectionMethodBaseClass srmbc |
          mc.getTarget() = srmbc.getInvokeMethod1() and args = 3
          or
          mc.getTarget() = srmbc.getInvokeMethod2() and args = 1
        )
      )
    )
  }

  private class MethodCallArg extends Expr {
    MethodCallArg() {
      this = any(MethodCall mc).getQualifier() or
      this = any(MethodCall mc).getAnArgument()
    }
  }

  /**
   * Gets a source for expression `e`, which is an argument in a method call,
   * using simple data flow.
   */
  private Expr getAMethodCallArgSource(MethodCallArg e) {
    Steps::stepOpen*(result, e) and
    not Steps::stepOpen(_, result)
  }

  /**
   * Holds if `aao` is a `+=` or `-=` assignment that may potentially be
   * a call to an event accessor using `dynamic` types. `dma` is the
   * potential event access and `name` is the name of the relevant event
   * accessor.
   */
  private predicate isPotentialEventCall(
    AssignArithmeticOperation aao, DynamicMemberAccess dma, string name
  ) {
    exists(DynamicOperatorCall doc, AssignExpr ae |
      ae = aao.getExpandedAssignment() and
      dma = ae.getLValue() and
      doc = ae.getRValue()
    |
      aao instanceof AssignAddExpr and
      name = "add_" + dma.getLateBoundTargetName()
      or
      aao instanceof AssignSubExpr and
      name = "remove_" + dma.getLateBoundTargetName()
    )
  }

  /** A call. */
  abstract private class DispatchCallImpl extends TDispatchCall {
    /** Gets a textual representation of this call. */
    string toString() { none() }

    /** Gets the underlying expression of this call. */
    abstract Expr getCall();

    /** Gets the `i`th argument of this call. */
    abstract Expr getArgument(int i);

    /** Gets the number of arguments of this call. */
    int getNumberOfArguments() { result = count(int i | exists(getArgument(i))) }

    /** Gets the qualifier of this call, if any. */
    abstract Expr getQualifier();

    /** Gets a static (compile-time) target of this call. */
    abstract Callable getAStaticTarget();

    /** Gets a dynamic (run-time) target of this call, if any. */
    abstract RuntimeCallable getADynamicTarget();

    /**
     * Holds if the qualifier of this call has type `qualifierType`.
     * `isExactType` indicates whether the type is exact, that is, whether
     * the qualifier is guaranteed not to be a subtype of `qualifierType`.
     */
    predicate hasQualifierType(Type qualifierType, boolean isExactType) {
      exists(Type trackedType | trackedType = getAPossibleType(this.getQualifier(), isExactType) |
        qualifierType = trackedType and
        not qualifierType instanceof TypeParameter
        or
        qualifierType = trackedType.(TypeParameter).getAnUltimatelySuppliedType()
      )
    }

    /**
     * Gets a non-exact (see `hasQualifierType()`) qualifier type of this call
     * that does not contain type parameters.
     */
    private TypeWithoutTypeParameters getANonExactQualifierTypeWithoutTypeParameters() {
      exists(Type qualifierType | hasQualifierType(qualifierType, false) |
        // Qualifier type contains no type parameters: use it
        result = qualifierType
        or
        // Qualifier type is a constructed type where all type arguments are type
        // parameters: use the unbound generic type
        exists(ConstructedType ct |
          ct = qualifierType and
          forex(Type arg | arg = ct.getATypeArgument() | arg instanceof TypeParameter) and
          result = ct.getUnboundGeneric()
        )
        or
        // Qualifier type is a constructed type where some (but not all) type arguments
        // are type parameters: consider all potential instantiations
        result = qualifierType.(QualifierTypeWithTypeParameters).getAPotentialInstance()
      )
    }

    /**
     * Gets a non-exact (see `hasQualifierType()`) qualifier type of this call.
     */
    ValueOrRefType getANonExactQualifierType() {
      exists(TypeWithoutTypeParameters t |
        t = this.getANonExactQualifierTypeWithoutTypeParameters()
      |
        result.(ConstructedType).getUnboundGeneric() = t
        or
        not t instanceof UnboundGenericType and
        result = t
      )
    }
  }

  private class DynamicFieldOrProperty extends Assignable {
    DynamicFieldOrProperty() {
      (
        this instanceof Field or
        this instanceof Property
      ) and
      this.getName() = any(DynamicMemberAccess dma).getLateBoundTargetName()
    }

    predicate isMemberOf(string name, ValueOrRefType t) {
      name = this.getName() and t.hasMember(this)
    }
  }

  private class TypeWithDynamicFieldOrProperty extends ValueOrRefType {
    DynamicFieldOrProperty fp;

    TypeWithDynamicFieldOrProperty() { fp.isMemberOf(_, this) }

    predicate isImplicitlyConvertibleTo(string name, Type t) {
      name = fp.getName() and
      this.isImplicitlyConvertibleTo(t)
    }
  }

  pragma[noinline]
  private predicate isPossibleDynamicMemberAccessQualifierType(
    DynamicMemberAccess dma, string name, TypeWithDynamicFieldOrProperty t
  ) {
    exists(Type qt, boolean isExact |
      qt = getAPossibleType(dma.getQualifier(), isExact) and
      name = dma.getLateBoundTargetName()
    |
      isExact = true and t = qt
      or
      isExact = false and t.isImplicitlyConvertibleTo(name, qt)
    )
  }

  /**
   * Gets a possible type for expression `e`. Simple flow is used to track the
   * origin of `e`, and in case `e` is a dynamic member access, only types
   * corresponding to the type of a relevant field or property are included.
   */
  private Type getAPossibleType(Expr e, boolean isExact) {
    exists(DynamicFieldOrProperty fp, string name, TypeWithDynamicFieldOrProperty t |
      isPossibleDynamicMemberAccessQualifierType(e, name, t) and
      fp.isMemberOf(name, t)
    |
      result = fp.getType() and
      isExact = false
    )
    or
    not e instanceof DynamicMemberAccess and
    result = getASourceType(e, isExact)
  }

  /**
   * Provides the predicate `getASourceType()` for finding all relevant source
   * types for a given expression.
   */
  private module SimpleTypeDataFlow {
    /**
     * Holds if type `t` may be imprecise, that is, an expression of type `t` may
     * in fact have a more precise type.
     */
    private predicate typeMayBeImprecise(Type t) {
      t.containsTypeParameters()
      or
      t.getAChild*() instanceof DynamicType
      or
      exists(Type other | other != t |
        not other instanceof DynamicType and
        other.isImplicitlyConvertibleTo(t)
      )
    }

    private predicate downCast(Cast c) {
      exists(Type fromType, Type toType |
        fromType = c.getExpr().getType() and
        toType = c.getType() and
        not fromType.isImplicitlyConvertibleTo(toType) and
        not toType instanceof DynamicType
      )
    }

    private predicate stepExpr0(Expr succ, Expr pred) {
      Steps::stepOpen(pred, succ)
      or
      exists(Assignable a |
        a instanceof Field or
        a instanceof Property
      |
        succ.(AssignableRead) = a.getAnAccess() and
        pred = a.getAnAssignedValue() and
        a = any(Modifiable m | not m.isEffectivelyPublic())
      )
    }

    private predicate stepExpr(Expr succ, Expr pred) {
      stepExpr0(succ, pred) and
      // Do not step through down casts
      not downCast(succ) and
      // Only step when we may learn more about the actual type
      typeMayBeImprecise(succ.getType())
    }

    private predicate stepTC(Expr succ, Expr pred) = fastTC(stepExpr/2)(succ, pred)

    private class Source extends Expr {
      Source() { not stepExpr(this, _) }
    }

    private class Sink extends Expr {
      Sink() {
        this = any(DynamicMemberAccess dma | dma instanceof Sink).getQualifier()
        or
        this = any(AccessorCall ac).getAnArgument()
        or
        this = any(DispatchReflectionOrDynamicCall c).getArgument(_)
        or
        this = any(MethodCall mc | mc.getTarget() = any(SystemObjectClass c).getGetTypeMethod())
              .getQualifier()
        or
        this = any(DispatchCallImpl c).getQualifier()
      }

      Source getASource() { stepTC(this, result) }
    }

    /** Holds if the expression `e` has an exact type. */
    private predicate hasExactType(Expr e) {
      e instanceof ObjectCreation or
      e instanceof BaseAccess
    }

    /** Gets a source type for expression `e`, using simple data flow. */
    Type getASourceType(Sink e, boolean isExact) {
      exists(Source s |
        s = e.getASource() or
        s = e
      |
        result = s.getType() and
        if hasExactType(s) then isExact = true else isExact = false
      )
    }
  }
  private import SimpleTypeDataFlow

  /**
   * An ordinary method call.
   *
   * The set of viable targets is determined by taking virtual dispatch
   * into account.
   */
  private class DispatchMethodCall extends DispatchCallImpl, TDispatchMethodCall {
    override MethodCall getCall() { this = TDispatchMethodCall(result) }

    override Expr getArgument(int i) {
      exists(Call call, Parameter p | call = this.getCall() |
        p = call.getTarget().getParameter(i) and
        result = call.getArgumentForParameter(p)
      )
    }

    override Expr getQualifier() { result = getCall().getQualifier() }

    override Method getAStaticTarget() { result = getCall().getTarget() }

    override RuntimeMethod getADynamicTarget() {
      result = getViableInherited()
      or
      result = getAViableOverrider()
      or
      // Simple case: target method cannot be overridden
      result = getAStaticTarget() and
      not result instanceof OverridableMethod
    }

    /**
     * Gets the (unique) instance method inherited by (or defined in) the
     * qualifier type of this call that overrides (or equals) the static
     * target of this call.
     *
     * Example:
     *
     * ```
     * class A {
     *   public virtual void M() { }
     * }
     *
     * class B : A {
     *   public override void M() { }
     * }
     *
     * class C : B { }
     *
     * class D {
     *   void CallM() {
     *     A x = new A();
     *     x.M();
     *     x = new B();
     *     x.M();
     *     x = new C();
     *     x.M();
     *   }
     * }
     * ```
     *
     * The static target is `A.M` in all three calls on lines 14, 16, and 18,
     * but the methods inherited by the actual qualifier types are `A.M`,
     * `B.M`, and `B.M`, respectively.
     */
    private RuntimeInstanceMethod getViableInherited() {
      exists(NonConstructedOverridableMethod m, Type qualifierType, SourceDeclarationType t |
        getAStaticTarget() = m.getAConstructingMethodOrSelf() and
        hasQualifierType(qualifierType, _) and
        t = qualifierType.getSourceDeclaration() and
        result = m.getInherited(t)
      )
    }

    /**
     * Gets an instance method that is defined in a subtype of the qualifier
     * type of this call, and which overrides the static target of this call.
     *
     * Example:
     *
     * ```
     * class A {
     *   public virtual void M() { }
     * }
     *
     * class B : A {
     *   public override void M() { }
     * }
     *
     * class C : B {
     *   public override void M() { }
     * }
     *
     * class D {
     *   void CallM() {
     *     A x = new A();
     *     x.M();
     *     x = new B();
     *     x.M();
     *     x = new C();
     *     x.M();
     *   }
     * }
     * ```
     *
     * The static target is `A.M` in all three calls on lines 16, 18, and 20,
     * but the methods overriding the static targets in subtypes of the actual
     * qualifier types are `B.M` and `C.M`, `C.M`, and none, respectively.
     */
    private RuntimeInstanceMethod getAViableOverrider() {
      exists(ValueOrRefType t, NonConstructedOverridableMethod m |
        t = this.getANonExactQualifierType() and
        this.getAStaticTarget() = m.getAConstructingMethodOrSelf() and
        result = m.getAnOverrider(t)
      )
    }
  }

  /** A non-constructed overridable method. */
  private class NonConstructedOverridableMethod extends OverridableMethod, NonConstructedMethod { }

  /**
   * A call to an accessor.
   *
   * The set of viable targets is determined by taking virtual dispatch
   * into account.
   */
  private class DispatchAccessorCall extends DispatchCallImpl, TDispatchAccessorCall {
    override AccessorCall getCall() { this = TDispatchAccessorCall(result) }

    override Expr getArgument(int i) { result = getCall().getArgument(i) }

    override Expr getQualifier() { result = getCall().(MemberAccess).getQualifier() }

    override Accessor getAStaticTarget() { result = getCall().getTarget() }

    override RuntimeAccessor getADynamicTarget() {
      result = getADynamicTargetCandidate() and
      // Calls to accessors may have `dynamic` expression arguments,
      // so we need to check that the types match
      forall(Type argumentType, int i | hasDynamicArg(i, argumentType) |
        argumentType.isImplicitlyConvertibleTo(result.getParameter(i).getType())
      )
    }

    private RuntimeAccessor getADynamicTargetCandidate() {
      result = getViableInherited()
      or
      result = getAViableOverrider()
      or
      // Simple case: target accessor cannot be overridden
      result = getAStaticTarget() and
      not result instanceof OverridableAccessor
    }

    private predicate hasDynamicArg(int i, Type argumentType) {
      exists(Expr argument |
        argument = getArgument(i) and
        argument.stripImplicitCasts().getType() instanceof DynamicType and
        argumentType = getAPossibleType(argument, _)
      )
    }

    /**
     * Gets the (unique) accessor inherited by (or defined in) the qualifier
     * type of this call that overrides (or equals) the static target of this
     * call.
     *
     * Example:
     *
     * ```
     * class A {
     *   public virtual int P { get => 0; }
     * }
     *
     * class B : A {
     *   public override int P { get => 1; }
     * }
     *
     * class C : B { }
     *
     * class D {
     *   void CallM() {
     *     A x = new A();
     *     x.P;
     *     x = new B();
     *     x.P;
     *     x = new C();
     *     x.P;
     *   }
     * }
     * ```
     *
     * The static target is `A.get_P` in all three calls on lines 14, 16, and 18,
     * but the accessors inherited by the actual qualifier types are `A.get_P`,
     * `B.get_P`, and `B.get_P`, respectively.
     */
    private RuntimeAccessor getViableInherited() {
      exists(OverridableAccessor a, SourceDeclarationType t |
        this.getAStaticTarget() = a and
        this.hasQualifierTypeSourceDecl(t) and
        result = a.getInherited(t)
      )
    }

    pragma[noinline]
    private predicate hasQualifierTypeSourceDecl(SourceDeclarationType t) {
      exists(Type qualifierType |
        this.hasQualifierType(qualifierType, _) and
        t = qualifierType.getSourceDeclaration()
      )
    }

    /**
     * Gets an accessor that is defined in a subtype of the qualifier type of
     * this call, and which overrides the static target of this call.
     *
     * Example:
     *
     * ```
     * class A {
     *   public virtual int P { get => 0; }
     * }
     *
     * class B : A {
     *   public override int P { get => 1; }
     * }
     *
     * class C : B {
     *   public override int P { get => 2; }
     * }
     *
     * class D {
     *   void CallM() {
     *     A x = new A();
     *     x.P;
     *     x = new B();
     *     x.P;
     *     x = new C();
     *     x.P;
     *   }
     * }
     * ```
     *
     * The static target is `A.get_P` in all three calls on lines 16, 18, and 20,
     * but the accessors overriding the static targets in subtypes of the actual
     * qualifier types are `B.get_P` and `C.get_P`, `C.get_P`, and none,
     * respectively.
     */
    private RuntimeAccessor getAViableOverrider() {
      exists(ValueOrRefType t | t = this.getANonExactQualifierType() |
        result = this.getAStaticTarget().(OverridableAccessor).getAnOverrider(t)
      )
    }
  }

  /** An internal helper class for comparing two types modulo type parameters. */
  abstract private class StructurallyComparedModuloTypeParameters extends Type {
    /** Gets a candidate for comparison against this type. */
    abstract Type getACandidate();

    /**
     * Holds if this type equals the type `t` modulo type parameters.
     *
     * Equality modulo type parameters is a weaker form of type unifiability.
     * That is, if constructed types `s` and `t` are unifiable, then `s` and
     * `t` are equal modulo type parameters, but the converse does not
     * necessarily hold. (For example, `C<int, string, T, T[]>` and
     * `C<T, T, int, string[]>` are equal modulo type parameters, but not
     * unifiable.)
     */
    predicate equalsModuloTypeParameters(Type t) {
      t = getACandidate() and
      sameModuloTypeParameters(this, t)
    }

    /**
     * Gets a potential instantiation of this type.
     *
     * A potential instantiation is a type without type parameters that
     * is the result of replacing all type parameters in this type with
     * non-type parameters. Note: the same type parameter may be replaced
     * by different types at different positions. For example,
     * `C<int, string>` is considered a potential instantiation of `C<T, T>`.
     */
    TypeWithoutTypeParameters getAPotentialInstance() { equalsModuloTypeParameters(result) }
  }

  private Type candidateInternal(Type t) {
    result = t.(StructurallyComparedModuloTypeParameters).getACandidate()
    or
    exists(Type parent, Type uncle, int i |
      uncle = candidateInternal(parent) and
      t = parent.getChild(i) and
      result = uncle.getChild(i)
    )
  }

  /** Holds if types `x` and `y` are equal modulo type parameters. */
  private predicate sameModuloTypeParameters(Type x, Type y) {
    y = candidateInternal(x) and
    (
      x = y
      or
      x instanceof TypeParameter
      or
      y instanceof TypeParameter
      or
      // All of the children must be structurally equal
      sameChildrenModuloTypeParameters(x, y, x.getNumberOfChildren() - 1)
    )
  }

  pragma[noinline]
  private Type candidateInternalKind(Type t, Gvn::CompoundTypeKind k) {
    result = candidateInternal(t) and
    k = Gvn::getTypeKind(t)
  }

  /**
   * Holds if the `i+1` first children of types `x` and `y` are equal
   * modulo type parameters.
   */
  pragma[nomagic]
  private predicate sameChildrenModuloTypeParameters(Type x, Type y, int i) {
    i = -1 and
    y = candidateInternalKind(x, Gvn::getTypeKind(y))
    or
    sameChildrenModuloTypeParameters(x, y, i - 1) and
    sameModuloTypeParameters(x.getChild(i), y.getChild(i))
  }

  /**
   * A qualifier type containing type parameters for which at
   * least one of the type arguments is *not* a type parameter.
   */
  private class QualifierTypeWithTypeParameters extends StructurallyComparedModuloTypeParameters {
    QualifierTypeWithTypeParameters() {
      containsTypeParameters() and
      any(DispatchCallImpl dc).hasQualifierType(this, false) and
      exists(Type arg | arg = getAChild() | not arg instanceof TypeParameter)
    }

    override ConstructedType getACandidate() {
      not result.containsTypeParameters() and
      this.(ConstructedType).getUnboundGeneric() = result.getUnboundGeneric()
    }
  }

  /** A reflection-based call or a call using dynamic types. */
  abstract private class DispatchReflectionOrDynamicCall extends DispatchCallImpl {
    /** Gets the name of the callable being called in this call. */
    abstract string getName();

    /**
     * Gets a potential qualifier type of this call.
     *
     * For reflection/dynamic calls, unless the type of the qualifier is exact,
     * all subtypes of the qualifier type must be considered relevant. Example:
     *
     * ```
     * class A {
     *   public void M() { Console.WriteLine("A"); }
     * }
     *
     * class B : A {
     *   new public void M() { Console.WriteLine("B"); }
     * }
     *
     * class C {
     *   void InvokeMDyn(A x) { ((dynamic) x).M(); }
     *
     *   void CallM() {
     *     InvokeMDyn(new A()); // prints "A"
     *     InvokeMDyn(new B()); // prints "B"
     *   }
     * }
     * ```
     *
     * In `InvokeMDyn()` on line 10, the (non-exact) type of `x` is `A`, but
     * if we only consider methods that override the method `M` in `A`, then
     * `B.M` will not be included (`M` is not a virtual method). Consequently,
     * we must include `B` as a possible qualifier type as well.
     *
     * This predicate only returns a type when `hasUnknownQualifierType()`
     * does not hold.
     */
    private RefType getAQualifierType() {
      // Exact qualifier type
      this.hasQualifierType(result, true)
      or
      // Non-exact qualifier type
      exists(Type qualifierType | this.hasNonExactQualifierType(qualifierType) |
        result = getANonExactQualifierSubType(qualifierType)
      )
    }

    private predicate hasNonExactQualifierType(Type qualifierType) {
      this.hasQualifierType(qualifierType, false)
    }

    /**
     * Holds if the qualifier type is unknown (it is either `object` or
     * `dynamic`).
     */
    private predicate hasUnknownQualifierType() {
      exists(Type qualifierType | this.hasNonExactQualifierType(qualifierType) |
        isUnknownType(qualifierType)
      )
    }

    // The set of static targets is all callables with matching
    // names and number of parameters. This set is further reduced in
    // `getADynamicTarget()` by taking type information into account.
    override Callable getAStaticTarget() {
      result = getACallableWithMatchingName() and
      exists(int minArgs |
        minArgs = count(Parameter p |
            p = result.getAParameter() and
            not p.hasDefaultValue() and
            not p.isParams()
          ) and
        getNumberOfArguments() >= minArgs and
        (result.(Method).hasParams() or getNumberOfArguments() <= result.getNumberOfParameters())
      )
    }

    private RuntimeCallable getACallableWithMatchingName() {
      result.(Operator).getFunctionName() = getName()
      or
      not result instanceof Operator and
      result.getName() = getName()
    }

    // A callable is viable if the following conditions are all satisfied:
    //
    // 1. It is a viable candidate (see `getADynamicTargetCandidate()`).
    // 2. The argument types are compatible with the parameter types. Here,
    //    type compatibility means that an argument type must be implicitly
    //    convertible to a type that equals the corresponding parameter type
    //    modulo type parameters. For example, an argument type `int` is
    //    compatible with a parameter type `IEquatable<T>`, because `int` is
    //    implicitly convertible to `IEquatable<int>`, which equals
    //    `IEquatable<T>` modulo type parameters. Note that potential type
    //    parameter constraints are not taken into account, nor is the
    //    possibility of matching a given type parameter with multiple,
    //    conflicting types (for example, `Tuple<int, string>` is considered
    //    compatible with `Tuple<T, T>`).
    override RuntimeCallable getADynamicTarget() {
      result = this.getADynamicTarget(this.getNumberOfArguments() - 1)
    }

    private RuntimeCallable getADynamicTarget(int i) {
      i = -1 and
      result = this.getADynamicTargetCandidate()
      or
      result = this.getADynamicTarget(i - 1) and
      exists(Type parameterType, Type argumentType |
        parameterType = this.getAParameterType(result, i) and
        argumentType = getAPossibleType(this.getArgument(i), _)
      |
        argumentType.isImplicitlyConvertibleTo(parameterType)
        or
        argumentType instanceof NullType and
        result.getParameter(i).isOut() and
        parameterType instanceof SimpleType
        or
        reflectionOrDynamicArgEqualsParamModuloTypeParameters(argumentType, parameterType)
      )
      or
      result = this.getADynamicTarget(i - 1) and
      exists(Type parameterType, Type t | parameterType = this.getAParameterType(result, i) |
        this.argumentConvConstExpr(i, t) and
        t.isImplicitlyConvertibleTo(parameterType)
      )
    }

    private Type getAParameterType(RuntimeCallable c, int i) {
      exists(this.getArgument(i)) and
      c = this.getADynamicTargetCandidate() and
      (
        result = c.getParameter(i).getType()
        or
        i >= c.getNumberOfParameters() - 1 and
        result = c.(Method).getParamsType()
      )
    }

    pragma[noinline]
    private predicate argumentConvConstExpr(int i, Type t) {
      convConstantExpr(this.getArgument(i), t)
    }

    /**
     * Gets a candidate for a viable run-time callable.
     *
     * A candidate must fulfill the following conditions:
     *
     * - It has the right name.
     * - It is an instance method defined in (a subtype of) the type of
     *   the qualifier, it is an instance accessor defined in (a subtype
     *   of) the type of the qualifier, or it is an operator defined in the
     *   type of one of the arguments.
     */
    RuntimeCallable getADynamicTargetCandidate() {
      result = getAStaticTarget() and
      (
        result = getADynamicTargetCandidateInstanceMethod(this.getAQualifierType())
        or
        result instanceof RuntimeInstanceMethod and
        this.hasUnknownQualifierType()
        or
        result = getADynamicTargetCandidateInstanceAccessor(this.getAQualifierType())
        or
        result instanceof RuntimeInstanceAccessor and
        this.hasUnknownQualifierType()
        or
        result = getADynamicTargetCandidateOperator()
      )
    }

    pragma[noinline]
    private RuntimeOperator getADynamicTargetCandidateOperator() {
      result = getAStaticTarget() and
      result.getDeclaringType() = result.getAParameter().getType()
    }
  }

  pragma[noinline]
  private RuntimeInstanceMethod getADynamicTargetCandidateInstanceMethod(RefType qualifierType) {
    exists(DispatchReflectionOrDynamicCall c |
      result = c.getAStaticTarget() and
      qualifierType.hasMethod(result)
    )
  }

  pragma[noinline]
  private RuntimeInstanceAccessor getADynamicTargetCandidateInstanceAccessor(RefType qualifierType) {
    exists(DispatchReflectionOrDynamicCall c |
      result = c.getAStaticTarget() and
      qualifierType.hasCallable(result)
    )
  }

  private predicate isUnknownType(RefType t) {
    t instanceof DynamicType or
    t instanceof ObjectType
  }

  pragma[noinline]
  private RefType getANonExactQualifierSubType(Type qualifierType) {
    isRelevantReflectionOrDynamicQualifierType(result) and
    result.isImplicitlyConvertibleTo(qualifierType) and
    not isUnknownType(qualifierType) and
    not result instanceof NullType // null types are implicitly convertible to all types, but not actual subtypes
  }

  pragma[noinline]
  private predicate isRelevantReflectionOrDynamicQualifierType(RefType rt) {
    rt.hasCallable(any(DispatchReflectionOrDynamicCall c).getAStaticTarget())
  }

  private predicate reflectionOrDynamicArgEqualsParamModuloTypeParameters(
    Type argumentType, Type parameterType
  ) {
    exists(Type t | reflectionOrDynamicArgumentTypeIsImplicitlyConvertibleTo(argumentType, t) |
      t
          .(ReflectionOrDynamicCallArgumentWithTypeParameters)
          .equalsModuloTypeParameters(parameterType)
    )
  }

  pragma[noinline]
  private predicate reflectionOrDynamicArgumentTypeIsImplicitlyConvertibleTo(
    Type argumentType, Type t
  ) {
    isReflectionOrDynamicArgumentType(argumentType) and
    argumentType.isImplicitlyConvertibleTo(t)
  }

  pragma[noinline]
  private predicate isReflectionOrDynamicArgumentType(Type t) {
    exists(DispatchReflectionOrDynamicCall c | t = getAPossibleType(c.getArgument(_), _))
  }

  /**
   * Holds if `argType` is the argument type of a reflection-based call
   * or a call using dynamic types, where either `argType` contains
   * type parameters, or the relevant parameter type `paramType` of a
   * potential run-time target contains type parameters.
   */
  private predicate isReflectionOrDynamicCallArgumentWithTypeParameters(Type argType, Type paramType) {
    exists(DispatchReflectionOrDynamicCall call, Parameter p, int i, int j |
      p = call.getADynamicTargetCandidate().getParameter(i) and
      (
        if p.isParams()
        then (
          j >= i and
          paramType = p.getType().(ArrayType).getElementType()
        ) else (
          i = j and
          paramType = p.getType()
        )
      ) and
      argType = getAPossibleType(call.getArgument(j), _)
    |
      argType.containsTypeParameters()
      or
      paramType.containsTypeParameters()
    )
  }

  /**
   * A type that is the argument type of a reflection-based call or a call using
   * dynamic types, where either the type or the relevant parameter type of a
   * potential run-time target contains type parameters.
   */
  private class ReflectionOrDynamicCallArgumentWithTypeParameters extends StructurallyComparedModuloTypeParameters {
    ReflectionOrDynamicCallArgumentWithTypeParameters() {
      isReflectionOrDynamicCallArgumentWithTypeParameters(this, _)
    }

    override Type getACandidate() {
      isReflectionOrDynamicCallArgumentWithTypeParameters(this, result)
    }
  }

  /** A call using reflection. */
  private class DispatchReflectionCall extends DispatchReflectionOrDynamicCall,
    TDispatchReflectionCall {
    override MethodCall getCall() { this = TDispatchReflectionCall(result, _, _, _, _) }

    override string getName() { this = TDispatchReflectionCall(_, result, _, _, _) }

    override Expr getQualifier() {
      this = TDispatchReflectionCall(_, _, result, _, _) and
      not result instanceof NullLiteral
    }

    /** Gets the type containing the static callable being called, if any. */
    private ValueOrRefType getStaticType() {
      exists(Expr object, Expr qualifier |
        this = TDispatchReflectionCall(_, _, object, qualifier, _) and
        object instanceof NullLiteral and
        (
          result = getAMethodCallArgSource(qualifier).(TypeofExpr).getTypeAccess().getType()
          or
          exists(MethodCall mc |
            mc = getAMethodCallArgSource(qualifier) and
            mc.getTarget() = any(SystemObjectClass c).getGetTypeMethod() and
            result = getAPossibleType(mc.getQualifier(), _)
          )
        )
      )
    }

    override RuntimeCallable getADynamicTargetCandidate() {
      result = DispatchReflectionOrDynamicCall.super.getADynamicTargetCandidate()
      or
      // Static callables can be called using reflection as well
      result = getAStaticTarget() and
      result.getDeclaringType() = getStaticType() and
      result.(Modifiable).isStatic()
    }

    // Does not take named arguments into account
    override Expr getArgument(int i) {
      exists(int args, ArrayCreation ac |
        this = TDispatchReflectionCall(_, _, _, _, args) and
        ac = getAMethodCallArgSource(getCall().getArgument(args)) and
        result = ac.getInitializer().getElement(i)
      )
    }
  }

  /** A method call using dynamic types. */
  private class DispatchDynamicMethodCall extends DispatchReflectionOrDynamicCall,
    TDispatchDynamicMethodCall {
    override DynamicMethodCall getCall() { this = TDispatchDynamicMethodCall(result) }

    override string getName() { result = getCall().getLateBoundTargetName() }

    override Expr getQualifier() { result = getCall().getQualifier() }

    override RuntimeMethod getADynamicTargetCandidate() {
      if exists(getCall().getTarget())
      then
        // static method call
        result = getCall().getTarget()
      else result = DispatchReflectionOrDynamicCall.super.getADynamicTargetCandidate()
    }

    // Does not take named arguments into account
    override Expr getArgument(int i) { result = getCall().getArgument(i) }
  }

  /** An operator call using dynamic types. */
  private class DispatchDynamicOperatorCall extends DispatchReflectionOrDynamicCall,
    TDispatchDynamicOperatorCall {
    override DynamicOperatorCall getCall() { this = TDispatchDynamicOperatorCall(result) }

    override string getName() {
      exists(Operator o |
        o.getName() = getCall().getLateBoundTargetName() and
        result = o.getFunctionName()
      )
    }

    override Expr getQualifier() { none() }

    override Expr getArgument(int i) { result = getCall().getArgument(i) }
  }

  /** A (potential) call to a property accessor using dynamic types. */
  private class DispatchDynamicMemberAccess extends DispatchReflectionOrDynamicCall,
    TDispatchDynamicMemberAccess {
    override DynamicMemberAccess getCall() { this = TDispatchDynamicMemberAccess(result) }

    override string getName() {
      exists(DynamicMemberAccess dma | dma = this.getCall() |
        result = "get_" + dma.(DynamicMemberRead).getLateBoundTargetName()
        or
        result = "set_" + dma.(DynamicMemberWrite).getLateBoundTargetName()
      )
    }

    override Expr getQualifier() { result = this.getCall().getQualifier() }

    override Expr getArgument(int i) {
      exists(DynamicMemberAccess dma | dma = this.getCall() |
        // Only calls to setters have an argument
        i = 0 and
        exists(AssignableDefinition def | def.getTargetAccess() = dma | result = def.getSource())
      )
    }
  }

  /** A (potential) call to an indexer accessor using dynamic types. */
  private class DispatchDynamicElementAccess extends DispatchReflectionOrDynamicCall,
    TDispatchDynamicElementAccess {
    override DynamicElementAccess getCall() { this = TDispatchDynamicElementAccess(result) }

    override string getName() {
      exists(DynamicElementAccess dea | dea = this.getCall() |
        dea instanceof DynamicElementRead and result = "get_Item"
        or
        dea instanceof DynamicElementWrite and result = "set_Item"
      )
    }

    override Expr getQualifier() { result = this.getCall().getQualifier() }

    override Expr getArgument(int i) {
      exists(DynamicElementAccess dea | dea = this.getCall() |
        result = dea.getIndex(i)
        or
        // Calls to setters have an extra argument
        i = count(dea.getAnIndex()) and
        exists(AssignableDefinition def | def.getTargetAccess() = dea | result = def.getSource())
      )
    }
  }

  /** A (potential) call to an event accessor using dynamic types. */
  private class DispatchDynamicEventAccess extends DispatchReflectionOrDynamicCall,
    TDispatchDynamicEventAccess {
    override AssignArithmeticOperation getCall() {
      this = TDispatchDynamicEventAccess(result, _, _)
    }

    override string getName() { this = TDispatchDynamicEventAccess(_, _, result) }

    override Expr getQualifier() {
      result = any(DynamicMemberAccess dma | this = TDispatchDynamicEventAccess(_, dma, _))
            .getQualifier()
    }

    override Expr getArgument(int i) { i = 0 and result = getCall().getRValue() }
  }

  /** A call to a constructor using dynamic types. */
  private class DispatchDynamicObjectCreation extends DispatchReflectionOrDynamicCall,
    TDispatchDynamicObjectCreation {
    override DynamicObjectCreation getCall() { this = TDispatchDynamicObjectCreation(result) }

    override string getName() { none() }

    override Expr getQualifier() { none() }

    override Expr getArgument(int i) { result = getCall().getArgument(i) }

    override RuntimeCallable getADynamicTargetCandidate() { result = getCall().getTarget() }
  }

  /** A call where the target can be resolved statically. */
  private class DispatchStaticCall extends DispatchCallImpl, TDispatchStaticCall {
    override Call getCall() { this = TDispatchStaticCall(result) }

    override Expr getQualifier() { none() }

    override Expr getArgument(int i) {
      exists(Call call, Parameter p | call = this.getCall() |
        p = call.getTarget().getParameter(i) and
        result = call.getArgumentForParameter(p)
      )
    }

    override Callable getAStaticTarget() { result = getCall().getTarget() }

    override RuntimeCallable getADynamicTarget() { result = getCall().getTarget() }
  }
}
