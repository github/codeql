/**
 * Provides logic for identifying functions that are overloaded based on their
 * non-`self` parameter types. While Rust does not allow for overloading inside a single
 * `impl` block, it is still possible for a trait to have multiple implementations
 * that differ only in the types of non-`self` parameters.
 */

private import rust
private import codeql.rust.internal.PathResolution
private import codeql.rust.internal.Type
private import codeql.rust.internal.TypeMention
private import codeql.rust.internal.TypeInference
private import FunctionType

pragma[nomagic]
private Type resolveNonTypeParameterTypeAt(TypeMention tm, TypePath path) {
  result = tm.resolveTypeAt(path) and
  not result instanceof TypeParameter
}

bindingset[t1, t2]
private predicate typeMentionEqual(TypeMention t1, TypeMention t2) {
  forex(TypePath path, Type type | resolveNonTypeParameterTypeAt(t1, path) = type |
    resolveNonTypeParameterTypeAt(t2, path) = type
  )
}

pragma[nomagic]
private predicate implSiblingCandidate(
  Impl impl, TraitItemNode trait, Type rootType, TypeMention selfTy
) {
  trait = impl.(ImplItemNode).resolveTraitTy() and
  selfTy = impl.getSelfTy() and
  rootType = selfTy.resolveType()
}

/**
 * Holds if `impl1` and `impl2` are a sibling implementations of `trait`. We
 * consider implementations to be siblings if they implement the same trait for
 * the same type. In that case `Self` is the same type in both implementations,
 * and method calls to the implementations cannot be resolved unambiguously
 * based only on the receiver type.
 */
pragma[inline]
private predicate implSiblings(TraitItemNode trait, Impl impl1, Impl impl2) {
  exists(Type rootType, TypeMention selfTy1, TypeMention selfTy2 |
    impl1 != impl2 and
    implSiblingCandidate(impl1, trait, rootType, selfTy1) and
    implSiblingCandidate(impl2, trait, rootType, selfTy2) and
    // In principle the second conjunct below should be superflous, but we still
    // have ill-formed type mentions for types that we don't understand. For
    // those checking both directions restricts further. Note also that we check
    // syntactic equality, whereas equality up to renaming would be more
    // correct.
    typeMentionEqual(selfTy1, selfTy2) and
    typeMentionEqual(selfTy2, selfTy1)
  )
}

/**
 * Holds if `impl` is an implementation of `trait` and if another implementation
 * exists for the same type.
 */
pragma[nomagic]
private predicate implHasSibling(Impl impl, Trait trait) { implSiblings(trait, impl, _) }

/**
 * Holds if type parameter `tp` of `trait` occurs in the function `f` with the name
 * `functionName` at position `pos` and path `path`.
 *
 * Note that `pos` can also be the special `return` position, which is sometimes
 * needed to disambiguate associated function calls like `Default::default()`
 * (in this case, `tp` is the special `Self` type parameter).
 */
bindingset[trait]
pragma[inline_late]
predicate traitTypeParameterOccurrence(
  TraitItemNode trait, Function f, string functionName, FunctionPosition pos, TypePath path,
  TypeParameter tp
) {
  f = trait.getASuccessor(functionName) and
  tp = getAssocFunctionTypeAt(f, trait, pos, path) and
  tp = trait.(TraitTypeAbstraction).getATypeParameter()
}

/**
 * Holds if resolving the function `f` in `impl` with the name `functionName`
 * requires inspecting the type of applied _arguments_ at position `pos` in
 * order to determine whether it is the correct resolution.
 */
pragma[nomagic]
predicate functionResolutionDependsOnArgument(
  ImplItemNode impl, Function f, FunctionPosition pos, TypePath path, Type type
) {
  /*
   * As seen in the example below, when an implementation has a sibling for a
   * trait we find occurrences of a type parameter of the trait in a function
   * signature in the trait. We then find the type given in the implementation
   * at the same position, which is a position that might disambiguate the
   * function from its siblings.
   *
   * ```rust
   * trait MyTrait<T> {
   *     fn method(&self, value: Foo<T>) -> Self;
   * //                   ^^^^^^^^^^^^^ `pos` = 0
   * //                              ^ `path` = "T"
   * }
   * impl MyAdd<i64> for i64 {
   *     fn method(&self, value: Foo<i64>) -> Self { ... }
   * //                              ^^^ `type` = i64
   * }
   * ```
   *
   * Note that we only check the root type symbol at the position. If the type
   * at that position is a type constructor (for instance `Vec<..>`) then
   * inspecting the entire type tree could be necessary to disambiguate the
   * method. In that case we will still resolve several methods.
   */

  exists(TraitItemNode trait, string functionName |
    implHasSibling(impl, trait) and
    traitTypeParameterOccurrence(trait, _, functionName, pos, path, _) and
    type = getAssocFunctionTypeAt(f, impl, pos, path) and
    f = impl.getASuccessor(functionName) and
    pos.isPosition()
  )
}
