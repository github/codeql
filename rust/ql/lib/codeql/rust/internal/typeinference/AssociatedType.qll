/**
 * Provides classes and helper predicates for associated types.
 */

private import rust
private import codeql.rust.internal.PathResolution
private import TypeMention
private import Type
private import TypeInference

/** An associated type, that is, a type alias in a trait block. */
final class AssocType extends TypeAlias {
  Trait trait;

  AssocType() { this = trait.getAssocItemList().getAnAssocItem() }

  Trait getTrait() { result = trait }

  string getText() { result = this.getName().getText() }
}

/** Gets an associated type of `trait` or of a supertrait of `trait`. */
AssocType getTraitAssocType(Trait trait) { result.getTrait() = trait.getSupertrait*() }

/** Holds if `path` is of the form `<type as trait>::name` */
pragma[nomagic]
predicate pathTypeAsTraitAssoc(Path path, TypeRepr typeRepr, Path traitPath, string name) {
  exists(PathSegment segment |
    segment = path.getQualifier().getSegment() and
    typeRepr = segment.getTypeRepr() and
    traitPath = segment.getTraitTypeRepr().getPath() and
    name = path.getText()
  )
}

/**
 * Holds if `assoc` is accessed on `tp` in `path`.
 *
 * That is, this is the case when `path` is of the form `<tp as
 * Trait>::AssocType` or `tp::AssocType`; and `AssocType` resolves to `assoc`.
 */
predicate tpAssociatedType(TypeParam tp, AssocType assoc, Path path) {
  resolvePath(path.getQualifier()) = tp and
  resolvePath(path) = assoc
  or
  exists(PathTypeRepr typeRepr, Path traitPath, string name |
    pathTypeAsTraitAssoc(path, typeRepr, traitPath, name) and
    tp = resolvePath(typeRepr.getPath()) and
    assoc = resolvePath(traitPath).(TraitItemNode).getAssocItem(name)
  )
}

/**
 * Holds if `bound` is a type bound for `tp` that gives rise to `assoc` being
 * present for `tp`.
 */
predicate tpBoundAssociatedType(
  TypeParam tp, TypeBound bound, Path path, TraitItemNode trait, AssocType assoc
) {
  bound = tp.getATypeBound() and
  path = bound.getTypeRepr().(PathTypeRepr).getPath() and
  trait = resolvePath(path) and
  assoc = getTraitAssocType(trait)
}
