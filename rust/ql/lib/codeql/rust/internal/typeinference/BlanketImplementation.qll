/**
 * Provides logic for checking argument types against constraints of
 * [blanket implementations][1].
 *
 * [1]: https://doc.rust-lang.org/book/ch10-02-traits.html#using-trait-bounds-to-conditionally-implement-methods
 */

private import rust
private import codeql.rust.internal.PathResolution
private import codeql.rust.internal.Type
private import codeql.rust.internal.TypeMention
private import codeql.rust.internal.TypeInference

/**
 * Holds if `traitBound` is the first non-trivial trait bound of `tp`.
 */
pragma[nomagic]
private predicate hasFirstNonTrivialTraitBound(TypeParamItemNode tp, Trait traitBound) {
  traitBound =
    min(Trait trait, int i |
      trait = tp.resolveBound(i) and
      // Exclude traits that are known to not narrow things down very much.
      not trait.getName().getText() =
        [
          "Sized", "Clone",
          // The auto traits
          "Send", "Sync", "Unpin", "UnwindSafe", "RefUnwindSafe"
        ]
    |
      trait order by i
    )
}

/**
 * Holds if `i` is a blanket-like implementation, meaning either an actual
 * blanket implementation, or an implementation for a type like `&` where
 * we want to check against the trait bounds of the blanket type parameter.
 *
 * `blanketSelfPath` points to the type parameter `blanketTypeParam` inside the
 * self type of `i` (`blanketSelfPath` is empty for actual blanket implementations).
 */
pragma[nomagic]
predicate isBlanketLike(ImplItemNode i, TypePath blanketSelfPath, TypeParam blanketTypeParam) {
  blanketTypeParam = i.getBlanketImplementationTypeParam() and
  blanketSelfPath.isEmpty()
  or
  exists(TypeMention tm, Type root, TypeParameter tp |
    tm = i.(Impl).getSelfTy() and
    complexSelfRoot(root, tp) and
    tm.resolveType() = root and
    tm.resolveTypeAt(blanketSelfPath) = TTypeParamTypeParameter(blanketTypeParam) and
    blanketSelfPath = TypePath::singleton(tp) and
    hasFirstNonTrivialTraitBound(blanketTypeParam, _)
  )
}

signature module SatisfiesBlanketConstraintInputSig<HasTypeTreeSig ArgumentType> {
  /**
   * Holds if a call with argument type `at` may potentially target a function belonging
   * to blanket implementation `impl` with type parameter `blanketTypeParam`.
   *
   * `blanketPath` points to the type `blanketTypeParam` inside the type of the parameter
   * at the matching position.
   */
  predicate hasBlanketCandidate(
    ArgumentType at, ImplItemNode impl, TypePath blanketPath, TypeParam blanketTypeParam
  );
}

module SatisfiesBlanketConstraint<
  HasTypeTreeSig ArgumentType, SatisfiesBlanketConstraintInputSig<ArgumentType> Input>
{
  private predicate hasBlanketCandidate(
    ArgumentType at, ImplItemNode impl, TypePath blanketPath, TypeParam blanketTypeParam
  ) {
    Input::hasBlanketCandidate(at, impl, blanketPath, blanketTypeParam) and
    exists(at.getTypeAt(blanketPath))
  }

  private newtype TArgumentTypeAndBlanketOffset =
    MkArgumentTypeAndBlanketOffset(ArgumentType at, TypePath blanketPath) {
      hasBlanketCandidate(at, _, blanketPath, _)
    }

  private class ArgumentTypeAndBlanketOffset extends MkArgumentTypeAndBlanketOffset {
    ArgumentType at;
    TypePath blanketPath;

    ArgumentTypeAndBlanketOffset() { this = MkArgumentTypeAndBlanketOffset(at, blanketPath) }

    Location getLocation() { result = at.getLocation() }

    Type getTypeAt(TypePath path) {
      result = at.getTypeAt(blanketPath.appendInverse(path)) and
      not result = TNeverType()
    }

    string toString() { result = at.toString() + " [blanket at " + blanketPath.toString() + "]" }
  }

  private module SatisfiesBlanketConstraintInput implements
    SatisfiesConstraintInputSig<ArgumentTypeAndBlanketOffset>
  {
    pragma[nomagic]
    additional predicate relevantConstraint(
      ArgumentTypeAndBlanketOffset ato, ImplItemNode impl, Trait traitBound
    ) {
      exists(ArgumentType at, TypePath blanketPath, TypeParam blanketTypeParam |
        ato = MkArgumentTypeAndBlanketOffset(at, blanketPath) and
        hasBlanketCandidate(at, impl, blanketPath, blanketTypeParam) and
        hasFirstNonTrivialTraitBound(blanketTypeParam, traitBound)
      )
    }

    pragma[nomagic]
    predicate relevantConstraint(ArgumentTypeAndBlanketOffset ato, Type constraint) {
      relevantConstraint(ato, _, constraint.(TraitType).getTrait())
    }

    predicate useUniversalConditions() { none() }
  }

  private module SatisfiesBlanketConstraint =
    SatisfiesConstraint<ArgumentTypeAndBlanketOffset, SatisfiesBlanketConstraintInput>;

  /**
   * Holds if the argument type `at` satisfies the first non-trivial blanket
   * constraint of `impl`.
   */
  pragma[nomagic]
  predicate satisfiesBlanketConstraint(ArgumentType at, ImplItemNode impl) {
    exists(ArgumentTypeAndBlanketOffset ato, Trait traitBound |
      ato = MkArgumentTypeAndBlanketOffset(at, _) and
      SatisfiesBlanketConstraintInput::relevantConstraint(ato, impl, traitBound) and
      SatisfiesBlanketConstraint::satisfiesConstraintType(ato, TTrait(traitBound), _, _)
    )
  }

  /**
   * Holds if the argument type `at` does _not_ satisfy the first non-trivial blanket
   * constraint of `impl`.
   */
  pragma[nomagic]
  predicate dissatisfiesBlanketConstraint(ArgumentType at, ImplItemNode impl) {
    exists(ArgumentTypeAndBlanketOffset ato, Trait traitBound |
      ato = MkArgumentTypeAndBlanketOffset(at, _) and
      SatisfiesBlanketConstraintInput::relevantConstraint(ato, impl, traitBound) and
      SatisfiesBlanketConstraint::dissatisfiesConstraint(ato, TTrait(traitBound))
    )
  }
}
