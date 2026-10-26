private import rust
private import codeql.rust.elements.internal.generated.Raw
private import codeql.rust.elements.internal.generated.Synth
private import Type

/**
 * A type abstraction. I.e., a place in the program where type variables are
 * introduced.
 *
 * Example:
 * ```rust
 * impl<A, B> Foo<A, B> { }
 * //  ^^^^^^ a type abstraction
 * ```
 */
abstract class TypeAbstraction extends AstNode {
  abstract TypeParameter getATypeParameter();
}

final class ImplTypeAbstraction extends TypeAbstraction, Impl {
  override TypeParamTypeParameter getATypeParameter() {
    result.getTypeParam() = this.getGenericParamList().getATypeParam()
  }
}

private predicate idDynTraitTypeRepr(Raw::DynTraitTypeRepr x, Raw::DynTraitTypeRepr y) { x = y }

private predicate idOfDynTraitTypeRepr(Raw::DynTraitTypeRepr x, int y) =
  equivalenceRelation(idDynTraitTypeRepr/2)(x, y)

private int idOfDynTraitTypeRepr(DynTraitTypeRepr node) {
  idOfDynTraitTypeRepr(Synth::convertAstNodeToRaw(node), result)
}

/** Holds if `dt` is the (arbitrarily chosen) canonical dyn trait type abstraction for `trait`. */
private predicate canonicalDynTraitTypeAbstraction(DynTraitTypeRepr dt) {
  exists(Trait trait |
    dt = min(DynTraitTypeRepr d | d.getTrait() = trait | d order by idOfDynTraitTypeRepr(d))
  )
}

final class DynTypeAbstraction extends TypeAbstraction, DynTraitTypeRepr {
  DynTypeAbstraction() {
    // We pick a "canonical" `dyn Trait` in order to avoid including multiple
    // entries in `conditionSatisfiesConstraint` with the exact same effect when
    // `dyn Trait` occurs multiple times for the same trait.
    canonicalDynTraitTypeAbstraction(this)
  }

  override TypeParameter getATypeParameter() {
    result = any(DynTraitTypeParameter tp | tp.getTrait() = this.getTrait()).getTraitTypeParameter()
  }
}

final class TraitTypeAbstraction extends TypeAbstraction, Trait {
  override TypeParameter getATypeParameter() {
    result.(TypeParamTypeParameter).getTypeParam() = this.getGenericParamList().getATypeParam()
    or
    result.(AssociatedTypeTypeParameter).getTrait() = this
    or
    result.(SelfTypeParameter).getTrait() = this
  }
}

final class TypeBoundTypeAbstraction extends TypeAbstraction, TypeBound {
  override TypeParameter getATypeParameter() { none() }
}

final class SelfTypeBoundTypeAbstraction extends TypeAbstraction, Name {
  SelfTypeBoundTypeAbstraction() { any(TraitTypeAbstraction trait).getName() = this }

  override TypeParameter getATypeParameter() { none() }
}

final class ImplTraitTypeReprAbstraction extends TypeAbstraction, ImplTraitTypeRepr {
  override TypeParamTypeParameter getATypeParameter() {
    exists(TImplTraitTypeParameter(this, result.getTypeParam()))
  }
}
