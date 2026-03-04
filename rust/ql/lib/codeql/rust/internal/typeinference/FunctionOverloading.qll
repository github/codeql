/**
 * Provides logic for identifying functions that are overloaded based on their
 * non-`self` parameter types. While Rust does not allow for overloading inside a single
 * `impl` block, it is still possible for a trait to have multiple implementations
 * that differ only in the types of non-`self` parameters.
 */

private import rust
private import codeql.rust.internal.PathResolution
private import Type
private import TypeAbstraction
private import TypeMention
private import TypeInference
private import FunctionType

pragma[nomagic]
private Type resolveNonTypeParameterTypeAt(TypeMention tm, TypePath path) {
  result = tm.getTypeAt(path) and
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
  rootType = selfTy.getType()
}

pragma[nomagic]
private predicate blanketImplSiblingCandidate(ImplItemNode impl, Trait trait) {
  impl.isBlanketImplementation() and
  trait = impl.resolveTraitTy()
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
  impl1 != impl2 and
  (
    exists(Type rootType, TypeMention selfTy1, TypeMention selfTy2 |
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
    or
    blanketImplSiblingCandidate(impl1, trait) and
    blanketImplSiblingCandidate(impl2, trait)
  )
}

/**
 * Holds if `impl` is an implementation of `trait` and if another implementation
 * exists for the same type.
 */
pragma[nomagic]
private predicate implHasSibling(ImplItemNode impl, Trait trait) { implSiblings(trait, impl, _) }

/**
 * Holds if `f` is a function declared inside `trait`, and the type of `f` at
 * `pos` and `path` is `traitTp`, which is a type parameter of `trait`.
 */
pragma[nomagic]
predicate traitTypeParameterOccurrence(
  TraitItemNode trait, Function f, string functionName, FunctionPosition pos, TypePath path,
  TypeParameter traitTp
) {
  f = trait.getAssocItem(functionName) and
  traitTp = getAssocFunctionTypeAt(f, trait, pos, path) and
  traitTp = trait.(TraitTypeAbstraction).getATypeParameter()
}

pragma[nomagic]
private predicate functionResolutionDependsOnArgumentCand(
  ImplItemNode impl, Function f, string functionName, TypeParameter traitTp, FunctionPosition pos,
  TypePath path
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

  exists(TraitItemNode trait |
    implHasSibling(impl, trait) and
    traitTypeParameterOccurrence(trait, _, functionName, pos, path, traitTp) and
    f = impl.getASuccessor(functionName) and
    not pos.isSelfOrTypeQualifier()
  )
}

private predicate functionResolutionDependsOnPositionalArgumentCand(
  ImplItemNode impl, Function f, string functionName, TypeParameter traitTp
) {
  exists(FunctionPosition pos |
    functionResolutionDependsOnArgumentCand(impl, f, functionName, traitTp, pos, _) and
    pos.isPosition()
  )
}

pragma[nomagic]
private Type getAssocFunctionNonTypeParameterTypeAt(
  ImplItemNode impl, Function f, FunctionPosition pos, TypePath path
) {
  result = getAssocFunctionTypeAt(f, impl, pos, path) and
  not result instanceof TypeParameter
}

/**
 * Holds if `f` inside `impl` has a sibling implementation inside `sibling`, where
 * those two implementations agree on the instantiation of `traitTp`, which occurs
 * in a positional position inside `f`.
 */
pragma[nomagic]
private predicate hasEquivalentPositionalSibling(
  ImplItemNode impl, ImplItemNode sibling, Function f, TypeParameter traitTp
) {
  exists(string functionName, FunctionPosition pos, TypePath path |
    functionResolutionDependsOnArgumentCand(impl, f, functionName, traitTp, pos, path) and
    pos.isPosition()
  |
    exists(Function f1 |
      implSiblings(_, impl, sibling) and
      f1 = sibling.getASuccessor(functionName)
    |
      forall(TypePath path0, Type t |
        t = getAssocFunctionNonTypeParameterTypeAt(impl, f, pos, path0) and
        path = path0.getAPrefix()
      |
        t = getAssocFunctionNonTypeParameterTypeAt(sibling, f1, pos, path0)
      ) and
      forall(TypePath path0, Type t |
        t = getAssocFunctionNonTypeParameterTypeAt(sibling, f1, pos, path0) and
        path = path0.getAPrefix()
      |
        t = getAssocFunctionNonTypeParameterTypeAt(impl, f, pos, path0)
      )
    )
  )
}

/**
 * Holds if resolving the function `f` in `impl` requires inspecting the type
 * of applied _arguments_ or possibly knowing the return type.
 *
 * `traitTp` is a type parameter of the trait being implemented by `impl`, and
 * we need to check that the type of `f` corresponding to `traitTp` is satisfied
 * at any one of the positions `pos` in which that type occurs in `f`.
 *
 * Type parameters that only occur in return positions are only included when
 * all other type parameters that occur in a positional position are insufficient
 * to disambiguate.
 *
 * Example:
 *
 * ```rust
 * trait Trait1<T1> {
 *   fn f(self, x: T1) -> T1;
 * }
 *
 * impl Trait1<i32> for i32 {
 *   fn f(self, x: i32) -> i32 { 0 } // f1
 * }
 *
 * impl Trait1<i64> for i32 {
 *   fn f(self, x: i64) -> i64 { 0 } // f2
 * }
 * ```
 *
 * The type for `T1` above occurs in both a positional position and a return position
 * in `f`, so both may be used to disambiguate between `f1` and `f2`. That is, `f(0i32)`
 * is sufficient to resolve to `f1`, and so is `let y: i64 = f(Default::default())`.
 */
pragma[nomagic]
predicate functionResolutionDependsOnArgument(
  ImplItemNode impl, Function f, TypeParameter traitTp, FunctionPosition pos
) {
  exists(string functionName |
    functionResolutionDependsOnArgumentCand(impl, f, functionName, traitTp, pos, _)
  |
    if functionResolutionDependsOnPositionalArgumentCand(impl, f, functionName, traitTp)
    then any()
    else
      // `traitTp` only occurs in return position; check that it is indeed needed for disambiguation
      exists(ImplItemNode sibling |
        implSiblings(_, impl, sibling) and
        forall(TypeParameter otherTraitTp |
          functionResolutionDependsOnPositionalArgumentCand(impl, f, functionName, otherTraitTp)
        |
          hasEquivalentPositionalSibling(impl, sibling, f, otherTraitTp)
        )
      )
  )
}
