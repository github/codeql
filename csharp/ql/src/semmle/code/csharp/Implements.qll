/**
 * INTERNAL: Do not use.
 *
 * Provides logic for determining interface member implementations.
 *
 * Do not use the predicates in this library directly; use the methods
 * of the class `Virtualizable` instead.
 */
import csharp
private import Conversion
private import dispatch.Dispatch

/**
 * INTERNAL: Do not use.
 *
 * Holds if member `m1` implements interface member `m2`.
 *
 * The type `t` is a type that implements the interface type in which
 * `m2` is declared, in such a way that `m1` is the implementation of
 * `m2`.
 *
 * Example:
 *
 * ```
 * interface I { void M(); }
 *
 * class A { public void M() { } }
 *
 * class B : A, I { }
 *
 * class C : A, I { new public void M() }
 * ```
 *
 * In the example above, the following (and nothing else) holds:
 * `implements(A.M, I.M, B)` and `implements(C.M, I.M, C)`.
 */
cached
predicate implements(Virtualizable m1, Virtualizable m2, ValueOrRefType t) {
  exists(Interface i |
    i = m2.getDeclaringType() and
    t.getABaseInterface+() = i and
    m2 = getAnImplementedInterfaceMemberForSubType(m1, t)
  )
}

/**
 * Gets a compatible interface member for member `m`, where `t` is
 * a (transitive, reflexive) sub type of `m`'s declaring type, and
 * no conflicting member (that is, another member that also has the
 * result as a compatible interface member) exists between `t` and
 * `m`'s declaring type.
 *
 * Example:
 *
 * ```
 * interface I { void M(); }
 *
 * class A { public void M() { } }
 *
 * class B : A, I { }
 *
 * class C : A, I { new public void M() }
 * ```
 *
 * `I.M()` is compatible with `A.M()` for types `A` and `B`, but not
 * for type `C`, because `C.M()` conflicts.
 */
private Virtualizable getAnImplementedInterfaceMemberForSubType(Virtualizable m, ValueOrRefType t) {
  result = getACompatibleInterfaceMember(m) and
  t = m.getDeclaringType()
  or
  exists(ValueOrRefType mid |
    result = getAnImplementedInterfaceMemberForSubType(m, mid) and
    t.getBaseClass() = mid and
    not hasMemberCompatibleWithInterfaceMember(t, result)
  )
}

pragma [noinline] // predicate folding for proper join order
private predicate hasMemberCompatibleWithInterfaceMember(ValueOrRefType t, Virtualizable m) {
  m = getACompatibleInterfaceMember(t.getAMember())
}

/**
 * Gets an interface member whose signature matches `m`'s
 * signature, and where `m` can potentially be accessed when
 * the interface member is accessed.
 */
private Virtualizable getACompatibleInterfaceMember(Virtualizable m) {
  result = getACompatibleInterfaceMemberAux(m) and
  (
    // If there is both an implicit and an explicit compatible member
    // in the same type, then the explicit implementation must be used
    not result = getACompatibleExplicitInterfaceMember(_, m.getDeclaringType())
    or
    result = getACompatibleExplicitInterfaceMember(m, m.getDeclaringType())
  )
}

private Virtualizable getACompatibleExplicitInterfaceMember(Virtualizable m, ValueOrRefType declType) {
  result = getACompatibleInterfaceMemberAux(m) and
  declType = m.getDeclaringType() and
  m.implementsExplicitInterface()
}

private Virtualizable getACompatibleInterfaceMemberAux(Virtualizable m) {
  result = getACompatibleInterfaceAccessor(m) or
  result = getACompatibleInterfaceIndexer(m) or
  result = getACompatibleInterfaceMethod(m)
}

/**
 * Gets an interface declaration with accessors, not including
 * indexers, whose signature matches `d`'s signature, and where
 * `d` can potentially be accessed when the interface declaration
 * is accessed.
 */
private DeclarationWithAccessors getACompatibleInterfaceAccessor(DeclarationWithAccessors d) {
  result = getACompatibleInterfaceAccessorCandidate(d) and
  convIdentity(d.getType(), result.getType())
}

private DeclarationWithAccessors getACompatibleInterfaceAccessorCandidate(DeclarationWithAccessors d) {
  getACompatibleInterfaceAccessorAux(result, d.getDeclaringType(), d.getName())
  and
  not d instanceof Indexer
  and
  d.isPublic()
}

pragma [noinline] // predicate folding for proper join-order
private predicate getACompatibleInterfaceAccessorAux(DeclarationWithAccessors d, ValueOrRefType t, string name) {
  t = getAPossibleImplementor(d.getDeclaringType()) and
  name = d.getName()
}

/**
 * Gets a class or struct that may implement (parts of) the members
 * of the interface `i`. Note that the class or struct need not be a
 * sub type of the interface in the inheritance hierarchy:
 *
 * ```
 * interface I { void M() }
 *
 * class A { public void M() }
 *
 * class B { }
 *
 * class C : B, I { }
 * ```
 *
 * All classes `A`, `B`, and `C` may implement some of the members
 * of `I` (in this example, though, only `A` actually does), even
 * though only `C` is a sub type of `I`.
 */
pragma[nomagic]
ValueOrRefType getAPossibleImplementor(Interface i) {
  result.getASubType*().getABaseInterface+() = i
  and
  not result instanceof Interface
}

/**
 * Gets an interface indexer whose signature matches `i`'s
 * signature, and where `i` can potentially be accessed when
 * the interface indexer is accessed.
 */
private Indexer getACompatibleInterfaceIndexer(Indexer i) {
  result = getACompatibleInterfaceIndexerCandidate(i)
  and
  convIdentity(i.getType(), result.getType())
  and
  forex(int j |
    j in [0 .. i.getNumberOfParameters() - 1] |
    convIdentity(i.getParameter(j).getType(), result.getParameter(j).getType())
  )
}

private Indexer getACompatibleInterfaceIndexerCandidate(Indexer i) {
  getACompatibleInterfaceIndexerAux(result, i.getDeclaringType())
  and
  i.isPublic()
}

pragma [noinline] // predicate folding for proper join-order
private predicate getACompatibleInterfaceIndexerAux(Indexer i, ValueOrRefType t) {
  t = getAPossibleImplementor(i.getDeclaringType())
}

private Method getACompatibleInterfaceMethod(Method m) {
  result = getAnInterfaceMethodCandidate(m)
  and
  forex(int i |
    i in [0 .. m.getNumberOfParameters()] |
    exists(Type t1, Type t2 |
      t1 = getArgumentOrReturnType(m, i) and
      t2 = getArgumentOrReturnType(result, i) |
      convIdentity(t1, t2) or
      // In the case where both `m` and `result` are unbound generic methods,
      // we need to do check for structural equality modulo the method type
      // parameters
      structurallyCompatible(m, result, t1, t2)
    )
  )
}

/**
 * Gets an interface method that may potentially be implemented by `m`.
 *
 * That is, a method with the same name, same number of parameters, and declared
 * in a type that is a possible implementor type for the interface type.
 */
private Method getAnInterfaceMethodCandidate(Method m) {
  getAPotentialInterfaceMethodAux(result, m.getDeclaringType(), m.getName(), m.getNumberOfParameters())
  and
  m.isPublic()
}

pragma [nomagic] // predicate folding for proper join-order
private predicate getAPotentialInterfaceMethodAux(Method m, ValueOrRefType t, string name, int params) {
  t = getAPossibleImplementor(m.getDeclaringType()) and
  name = m.getName() and
  params = m.getNumberOfParameters()
}

private Type getArgumentOrReturnType(Method m, int i) {
  i = 0 and result = m.getReturnType()
  or
  result = m.getParameter(i - 1).getType()
}

/**
 * Holds if `m2` is an interface method candidate for `m1`
 * (`m2 = getAnInterfaceMethodCandidate(m1)`), both `m1` and `m2` are
 * unbound generic methods, `t1` is a structural sub term of a
 * parameter type of `m1`, `t2` is a structural sub term of a parameter
 * (at the same index) type of `m2`, and `t1` and `t2` are compatible.
 *
 * Here, compatibility means that the two types are structurally equal
 * modulo identity conversions and method type parameters.
 */
private predicate structurallyCompatible(UnboundGenericMethod m1, UnboundGenericMethod m2, Type t1, Type t2) {
  candidateTypes(m1, m2, t1, t2) and
  (
    // Base case: identity convertible
    convIdentity(t1, t2)
    or
    // Base case: method type parameter (at same index)
    exists(int i |
      structurallyCompatibleTypeParameter(m1, m2, i, t1, m2.getTypeParameter(i))
    )
    or
    // Recursive case
    (
      (
        t1 instanceof PointerType and t2 instanceof PointerType
        or
        t1 instanceof NullableType and t2 instanceof NullableType
        or
        t1.(ArrayType).hasSameShapeAs((ArrayType)t2)
        or
        t1.(ConstructedType).getUnboundGeneric() = t2.(ConstructedType).getUnboundGeneric()
      )
      and
      structurallyCompatibleChildren(m1, m2, t1, t2, t1.getNumberOfChildren() - 1)
    )
  )
}

// Predicate folding to force joining on `candidateTypes` first
pragma [nomagic] // to prevent `private#structurallyCompatibleTypeParameter#fbbfb`
private predicate structurallyCompatibleTypeParameter(UnboundGenericMethod m1, UnboundGenericMethod m2, int i, Type t1, Type t2) {
  candidateTypes(m1, m2, t1, t2) and
  t1 = m1.getTypeParameter(i)
}

/**
 * Holds if the `i+1` first children of types `x` and `y` are compatible.
 */
private predicate structurallyCompatibleChildren(UnboundGenericMethod m1, UnboundGenericMethod m2, Type t1, Type t2, int i) {
  exists(Type t3, Type t4 |
    i = 0 and
    candidateChildren(t1, t2, i, t3, t4) and
    structurallyCompatible(m1, m2, t3, t4)
  )
  or
  exists(Type t3, Type t4 |
    structurallyCompatibleChildren(m1, m2, t1, t2, i - 1) and
    candidateChildren(t1, t2, i, t3, t4) and
    structurallyCompatible(m1, m2, t3, t4)
  )
}

// manual magic predicate used to enumerate types relevant for structural comparison
private predicate candidateTypes(UnboundGenericMethod m1, UnboundGenericMethod m2, Type t1, Type t2) {
  m2 = getAnInterfaceMethodCandidate(m1)
  and
  (
    exists(int i |
      t1 = getArgumentOrReturnType(m1, i) and
      t2 = getArgumentOrReturnType(m2, i)
    )
    or
    exists(Type t3, Type t4, int j |
      candidateTypes(m1, m2, t3, t4) and
      t1 = t3.getChild(j) and
      t2 = t4.getChild(j)
    )
  )
}

pragma [noinline] // predicate folding for proper join-order
private predicate candidateChildren(Type t1, Type t2, int i, Type t3, Type t4) {
  candidateTypes(_, _, t1, t2) and
  t3 = t1.getChild(i) and
  t4 = t2.getChild(i)
}
