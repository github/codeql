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
pragma[nomagic]
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

pragma[noinline]
private predicate hasMemberCompatibleWithInterfaceMember(ValueOrRefType t, Virtualizable m) {
  m = getACompatibleInterfaceMember(t.getAMember())
}

/**
 * Gets an interface member whose signature matches `m`'s
 * signature, and where `m` can potentially be accessed when
 * the interface member is accessed.
 */
pragma[nomagic]
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

pragma[nomagic]
private Virtualizable getACompatibleExplicitInterfaceMember(Virtualizable m, ValueOrRefType declType) {
  result = getACompatibleInterfaceMemberAux(m) and
  declType = m.getDeclaringType() and
  m.implementsExplicitInterface()
}

pragma[nomagic]
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
  getACompatibleInterfaceAccessorAux(result, d.getDeclaringType(), d.getName()) and
  not d instanceof Indexer and
  d.isPublic()
}

pragma[noinline]
private predicate getACompatibleInterfaceAccessorAux(
  DeclarationWithAccessors d, ValueOrRefType t, string name
) {
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
  result.getASubType*().getABaseInterface+() = i and
  not result instanceof Interface
}

private Indexer getACompatibleInterfaceIndexer0(Indexer i, int j) {
  result = getACompatibleInterfaceIndexerCandidate(i) and
  convIdentity(i.getType(), result.getType()) and
  j = -1
  or
  result = getACompatibleInterfaceIndexer0(i, j - 1) and
  convIdentity(i.getParameter(j).getType(), result.getParameter(j).getType())
}

/**
 * Gets an interface indexer whose signature matches `i`'s
 * signature, and where `i` can potentially be accessed when
 * the interface indexer is accessed.
 */
private Indexer getACompatibleInterfaceIndexer(Indexer i) {
  result = getACompatibleInterfaceIndexer0(i, i.getNumberOfParameters() - 1)
}

private Indexer getACompatibleInterfaceIndexerCandidate(Indexer i) {
  getACompatibleInterfaceIndexerAux(result, i.getDeclaringType()) and
  i.isPublic()
}

pragma[noinline]
private predicate getACompatibleInterfaceIndexerAux(Indexer i, ValueOrRefType t) {
  t = getAPossibleImplementor(i.getDeclaringType())
}

private Method getACompatibleInterfaceMethod0(Method m, int i) {
  result = getAnInterfaceMethodCandidate(m) and
  i = -1
  or
  result = getACompatibleInterfaceMethod0(m, i - 1) and
  exists(Type t1, Type t2 |
    t1 = getArgumentOrReturnType(m, i) and
    t2 = getArgumentOrReturnType(result, i)
  |
    Gvn::getGlobalValueNumber(t1) = Gvn::getGlobalValueNumber(t2)
  )
}

private Method getACompatibleInterfaceMethod(Method m) {
  result = getACompatibleInterfaceMethod0(m, m.getNumberOfParameters())
}

/**
 * Gets an interface method that may potentially be implemented by `m`.
 *
 * That is, a method with the same name, same number of parameters, and declared
 * in a type that is a possible implementor type for the interface type.
 */
private Method getAnInterfaceMethodCandidate(Method m) {
  getAPotentialInterfaceMethodAux(result, m.getDeclaringType(), m.getName(),
    m.getNumberOfParameters()) and
  m.isPublic()
}

pragma[nomagic]
private predicate getAPotentialInterfaceMethodAux(
  Method m, ValueOrRefType t, string name, int params
) {
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
 * INTERNAL: Do not use.
 *
 * Provides an implementation of Global Value Numbering for types
 * (see https://en.wikipedia.org/wiki/Global_value_numbering), where
 * types are considered equal modulo identity conversions and method
 * type parameters (at the same index).
 */
module Gvn {
  private newtype TCompoundTypeKind =
    TPointerTypeKind() or
    TNullableTypeKind() or
    TArrayTypeKind(int dim, int rnk) {
      exists(ArrayType at | dim = at.getDimension() and rnk = at.getRank())
    } or
    TConstructedType(UnboundGenericType ugt)

  /** A type kind for a compound type. */
  class CompoundTypeKind extends TCompoundTypeKind {
    int getNumberOfTypeParameters() {
      this = TPointerTypeKind() and result = 1
      or
      this = TNullableTypeKind() and result = 1
      or
      this = TArrayTypeKind(_, _) and result = 1
      or
      exists(UnboundGenericType ugt | this = TConstructedType(ugt) |
        result = ugt.getNumberOfTypeParameters()
      )
    }

    string toString() {
      this = TPointerTypeKind() and result = "*"
      or
      this = TNullableTypeKind() and result = "?"
      or
      exists(int dim, int rnk | this = TArrayTypeKind(dim, rnk) |
        result = "[" + dim + ", " + rnk + "]"
      )
      or
      exists(UnboundGenericType ugt | this = TConstructedType(ugt) |
        result = ugt.getNameWithoutBrackets()
      )
    }

    Location getLocation() { result instanceof EmptyLocation }
  }

  /** Gets the type kind for type `t`, if any. */
  CompoundTypeKind getTypeKind(Type t) {
    result = TPointerTypeKind() and t instanceof PointerType
    or
    result = TNullableTypeKind() and t instanceof NullableType
    or
    t = any(ArrayType at | result = TArrayTypeKind(at.getDimension(), at.getRank()))
    or
    result = TConstructedType(t.(ConstructedType).getUnboundGeneric())
  }

  private class MethodTypeParameter extends TypeParameter {
    MethodTypeParameter() { this = any(UnboundGenericMethod ugm).getATypeParameter() }
  }

  private class LeafType extends Type {
    LeafType() {
      not exists(this.getAChild()) and
      not this instanceof MethodTypeParameter
    }
  }

  private predicate id(LeafType t, int i) = equivalenceRelation(convIdentity/2)(t, i)

  private newtype TGvnType =
    TLeafGvnType(int i) { id(_, i) } or
    TMethodTypeParameterGvnType(int i) { i = any(MethodTypeParameter p).getIndex() } or
    TConstructedGvnType(TConstructedGvnType0 t)

  private newtype TConstructedGvnType0 =
    TConstructedGvnTypeNil(CompoundTypeKind k) or
    TConstructedGvnTypeCons(TGvnType head, TConstructedGvnType0 tail) {
      gvnConstructedCons(_, _, head, tail)
    }

  private TConstructedGvnType0 gvnConstructed(Type t, int i) {
    result = TConstructedGvnTypeNil(getTypeKind(t)) and i = -1
    or
    exists(TGvnType head, TConstructedGvnType0 tail | gvnConstructedCons(t, i, head, tail) |
      result = TConstructedGvnTypeCons(head, tail)
    )
  }

  pragma[noinline]
  private TGvnType gvnTypeChild(Type t, int i) { result = getGlobalValueNumber(t.getChild(i)) }

  pragma[noinline]
  private predicate gvnConstructedCons(Type t, int i, TGvnType head, TConstructedGvnType0 tail) {
    tail = gvnConstructed(t, i - 1) and
    head = gvnTypeChild(t, i)
  }

  /** Gets the global value number for a given type. */
  GvnType getGlobalValueNumber(Type t) {
    result = TLeafGvnType(any(int i | id(t, i)))
    or
    result = TMethodTypeParameterGvnType(t.(MethodTypeParameter).getIndex())
    or
    result = TConstructedGvnType(gvnConstructed(t, getTypeKind(t).getNumberOfTypeParameters() - 1))
  }

  /** A global value number for a type. */
  class GvnType extends TGvnType {
    string toString() {
      exists(int i | this = TLeafGvnType(i) | result = i.toString())
      or
      exists(int i | this = TMethodTypeParameterGvnType(i) | result = "M!" + i)
      or
      exists(GvnConstructedType t | this = TConstructedGvnType(t) | result = t.toString())
    }

    Location getLocation() { result instanceof EmptyLocation }
  }

  /** A global value number for a constructed type. */
  class GvnConstructedType extends TConstructedGvnType0 {
    private CompoundTypeKind getKind() {
      this = TConstructedGvnTypeNil(result)
      or
      exists(GvnConstructedType tail | this = TConstructedGvnTypeCons(_, tail) |
        result = tail.getKind()
      )
    }

    private GvnType getArg(int i) {
      this = TConstructedGvnTypeCons(result, TConstructedGvnTypeNil(_)) and
      i = 0
      or
      exists(GvnConstructedType tail | this = TConstructedGvnTypeCons(result, tail) |
        exists(tail.getArg(i - 1))
      )
    }

    language[monotonicAggregates]
    string toString() {
      exists(CompoundTypeKind k | k = this.getKind() |
        result = k + "<" +
            concat(int i |
              i in [0 .. k.getNumberOfTypeParameters() - 1]
            |
              this.getArg(i).toString(), ", "
            ) + ">"
      )
    }

    Location getLocation() { result instanceof EmptyLocation }
  }
}
