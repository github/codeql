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
 * ```csharp
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
 * ```csharp
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

pragma[nomagic]
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
 * ```csharp
 * interface I { void M(); }
 *
 * class A { public void M() { } }
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
 * Provides an implementation of Global Value Numbering for types
 * (see https://en.wikipedia.org/wiki/Global_value_numbering), where
 * types are considered equal modulo identity conversions and method
 * type parameters (at the same index).
 */
private module Gvn {
  private import semmle.code.csharp.Unification::Gvn as Unification

  private class MethodTypeParameter extends TypeParameter {
    MethodTypeParameter() { this = any(UnboundGenericMethod ugm).getATypeParameter() }
  }

  private class LeafType extends Type {
    LeafType() {
      not this instanceof Unification::GenericType and
      not this instanceof MethodTypeParameter and
      not this instanceof DynamicType
    }
  }

  private newtype TGvnType =
    TLeafGvnType(LeafType t) or
    TMethodTypeParameterGvnType(int i) { i = any(MethodTypeParameter p).getIndex() } or
    TConstructedGvnType(ConstructedGvnTypeList l)

  private newtype TConstructedGvnTypeList =
    TConstructedGvnTypeNil(Unification::CompoundTypeKind k) or
    TConstructedGvnTypeCons(GvnType head, ConstructedGvnTypeList tail) {
      gvnConstructedCons(_, _, _, head, tail)
    }

  private ConstructedGvnTypeList gvnConstructed(
    Unification::GenericType t, Unification::CompoundTypeKind k, int i
  ) {
    result = TConstructedGvnTypeNil(k) and
    i = -1 and
    k = Unification::getTypeKind(t)
    or
    exists(GvnType head, ConstructedGvnTypeList tail | gvnConstructedCons(t, k, i, head, tail) |
      result = TConstructedGvnTypeCons(head, tail)
    )
  }

  pragma[noinline]
  private GvnType gvnTypeArgument(Unification::GenericType t, int i) {
    result = getGlobalValueNumber(t.getArgument(i))
  }

  pragma[noinline]
  private predicate gvnConstructedCons(
    Unification::GenericType t, Unification::CompoundTypeKind k, int i, GvnType head,
    ConstructedGvnTypeList tail
  ) {
    tail = gvnConstructed(t, k, i - 1) and
    head = gvnTypeArgument(t, i)
  }

  /** Gets the global value number for a given type. */
  pragma[nomagic]
  GvnType getGlobalValueNumber(Type t) {
    result = TLeafGvnType(t)
    or
    t instanceof DynamicType and
    result = TLeafGvnType(any(ObjectType ot))
    or
    result = TMethodTypeParameterGvnType(t.(MethodTypeParameter).getIndex())
    or
    exists(ConstructedGvnTypeList l, Unification::CompoundTypeKind k, int i |
      l = gvnConstructed(t, k, i) and
      i = k.getNumberOfTypeParameters() - 1 and
      result = TConstructedGvnType(l)
    )
  }

  /** A global value number for a type. */
  class GvnType extends TGvnType {
    string toString() {
      exists(LeafType t | this = TLeafGvnType(t) | result = t.toString())
      or
      exists(int i | this = TMethodTypeParameterGvnType(i) | result = "M!" + i)
      or
      exists(ConstructedGvnTypeList l | this = TConstructedGvnType(l) | result = l.toString())
    }

    Location getLocation() { result instanceof EmptyLocation }
  }

  private class ConstructedGvnTypeList extends TConstructedGvnTypeList {
    Unification::CompoundTypeKind getKind() { this = gvnConstructed(_, result, _) }

    private int length() {
      this = TConstructedGvnTypeNil(_) and result = -1
      or
      exists(ConstructedGvnTypeList tail | this = TConstructedGvnTypeCons(_, tail) |
        result = tail.length() + 1
      )
    }

    private GvnType getArg(int i) {
      exists(GvnType head, ConstructedGvnTypeList tail |
        this = TConstructedGvnTypeCons(head, tail)
      |
        result = head and
        i = this.length()
        or
        result = tail.getArg(i)
      )
    }

    /**
     * Gets a textual representation of this constructed type, restricted
     * to the prefix `t` of the underlying source declaration type.
     *
     * The `toString()` calculation needs to be split up into prefixes, in
     * order to apply the type arguments correctly. For example, a source
     * declaration type `A<>.B.C<,>` applied to types `int, string, bool`
     * needs to be printed as `A<int>.B.C<string,bool>`.
     */
    language[monotonicAggregates]
    private string toStringConstructed(Unification::GenericType t) {
      t = this.getKind().getConstructedSourceDeclaration().getGenericDeclaringType*() and
      exists(int offset, int children, string name, string nameArgs |
        offset = t.getNumberOfDeclaringArguments() and
        children = t.getNumberOfArgumentsSelf() and
        name = Unification::getNameNested(t) and
        if children = 0
        then nameArgs = name
        else
          exists(string offsetArgs |
            offsetArgs =
              concat(int i |
                i in [offset .. offset + children - 1]
              |
                this.getArg(i).toString(), "," order by i
              ) and
            nameArgs = name.prefix(name.length() - children - 1) + "<" + offsetArgs + ">"
          )
      |
        offset = 0 and result = nameArgs
        or
        result = this.toStringConstructed(t.getGenericDeclaringType()) + "." + nameArgs
      )
    }

    language[monotonicAggregates]
    string toString() {
      exists(Unification::CompoundTypeKind k | k = this.getKind() |
        result = k.toStringBuiltin(this.getArg(0).toString())
        or
        result = this.toStringConstructed(k.getConstructedSourceDeclaration())
      )
    }

    Location getLocation() { result instanceof EmptyLocation }
  }
}
