private import rust
private import codeql.rust.internal.TypeInference
private import codeql.rust.internal.PathResolution
private import codeql.rust.internal.Type
private import codeql.rust.internal.TypeMention
private import codeql.rust.elements.Call

private newtype TFunctionPosition =
  TArgumentFunctionPosition(ArgumentPosition pos) or
  TReturnFunctionPosition()

/**
 * A position of a type related to a function.
 *
 * Either `self`, `return`, or a positional parameter index.
 */
class FunctionPosition extends TFunctionPosition {
  predicate isSelf() { this.asArgumentPosition().isSelf() }

  int asPosition() { result = this.asArgumentPosition().asPosition() }

  predicate isPosition() { exists(this.asPosition()) }

  ArgumentPosition asArgumentPosition() { this = TArgumentFunctionPosition(result) }

  predicate isReturn() { this = TReturnFunctionPosition() }

  /** Gets the corresponding position when `f` is invoked via a function call. */
  bindingset[f]
  FunctionPosition getFunctionCallAdjusted(Function f) {
    this.isReturn() and
    result = this
    or
    if f.hasSelfParam()
    then
      this.isSelf() and result.asPosition() = 0
      or
      result.asPosition() = this.asPosition() + 1
    else result = this
  }

  TypeMention getTypeMention(Function f) {
    this.isSelf() and
    result = getSelfParamTypeMention(f.getSelfParam())
    or
    result = f.getParam(this.asPosition()).getTypeRepr()
    or
    this.isReturn() and
    result = getReturnTypeMention(f)
  }

  string toString() {
    result = this.asArgumentPosition().toString()
    or
    this.isReturn() and
    result = "(return)"
  }
}

/**
 * A helper module for implementing `Matching(WithEnvironment)InputSig` with
 * `DeclarationPosition = AccessPosition = FunctionPosition`.
 */
module FunctionPositionMatchingInput {
  class DeclarationPosition = FunctionPosition;

  class AccessPosition = DeclarationPosition;

  predicate accessDeclarationPositionMatch(AccessPosition apos, DeclarationPosition dpos) {
    apos = dpos
  }
}

private newtype TAssocFunctionType =
  /** An associated function `f` that should be specialized for `i` at `pos`. */
  MkAssocFunctionType(Function f, ImplOrTraitItemNode i, FunctionPosition pos) {
    f = i.getASuccessor(_) and exists(pos.getTypeMention(f))
  }

bindingset[condition, constraint, tp]
private Type getTraitConstraintTypeAt(
  TypeMention condition, TypeMention constraint, TypeParameter tp, TypePath path
) {
  BaseTypes::conditionSatisfiesConstraintTypeAt(_, condition, constraint,
    TypePath::singleton(tp).appendInverse(path), result)
}

/**
 * Gets if the type of the function `f` when specialized for `i` at position
 * `pos` at path `path`
 */
pragma[nomagic]
Type getAssocFunctionTypeAt(Function f, ImplOrTraitItemNode i, FunctionPosition pos, TypePath path) {
  exists(MkAssocFunctionType(f, i, pos)) and
  (
    // No specialization needed when the function is directly in the trait or
    // impl block or the declared type is not a type parameter
    (i.getAnAssocItem() = f or not result instanceof TypeParameter) and
    result = pos.getTypeMention(f).resolveTypeAt(path)
    or
    not i.getAnAssocItem() = f and
    exists(TypePath prefix, TypePath suffix, TypeParameter tp |
      path = prefix.append(suffix) and
      tp = pos.getTypeMention(f).resolveTypeAt(prefix)
    |
      if tp = TSelfTypeParameter(_)
      then result = resolveImplOrTraitType(i, suffix)
      else
        exists(TraitItemNode trait, TypeMention condition, TypeMention constraint |
          trait.getAnAssocItem() = f and
          BaseTypes::rootTypesSatisfaction(_, TTrait(trait), _, condition, constraint) and
          result = getTraitConstraintTypeAt(condition, constraint, tp, suffix)
        |
          condition = i.(Trait) or condition = i.(Impl).getSelfTy()
        )
    )
  )
}

/**
 * The type of an associated function at a given position, when its implicit
 * `Self` type parameter is specialized to a given trait or `impl` block.
 *
 * Example:
 *
 * ```rust
 * trait T1 {
 *   fn m1(self);              // self1
 *
 *   fn m2(self) { ... }       // self2
 * }
 *
 * trait T2 : T1 {
 *   fn m3(self);              // self3
 * }
 *
 * impl T2 for X {
 *   fn m1(self) { ... }       // self4
 *
 *   fn m3(self) { ... }       // self5
 * }
 * ```
 *
 * param   | `impl` or trait | type
 * ------- | --------------- | ----
 * `self1` | `trait T1`      | `T1`
 * `self1` | `trait T2`      | `T2`
 * `self2` | `trait T1`      | `T1`
 * `self2` | `trait T2`      | `T2`
 * `self2` | `impl T2 for X` | `X`
 * `self3` | `trait T2`      | `T2`
 * `self4` | `impl T2 for X` | `X`
 * `self5` | `impl T2 for X` | `X`
 */
class AssocFunctionType extends MkAssocFunctionType {
  /**
   * Holds if this function type applies to the function `f` at position `pos`,
   * when viewed as a member of the `impl` or trait item `i`.
   */
  predicate appliesTo(Function f, ImplOrTraitItemNode i, FunctionPosition pos) {
    this = MkAssocFunctionType(f, i, pos)
  }

  /**
   * Gets the type at the given path.
   *
   * For functions belonging to a trait, we use the type of the trait itself instead
   * of the implicit `Self` type parameter, as otherwise any type will match.
   *
   * Calls should use `substituteLookupTraits` to map receiver types to the relevant
   * traits when matching.
   */
  Type getTypeAt(TypePath path) {
    exists(Function f, FunctionPosition pos, ImplOrTraitItemNode i, Type t |
      this.appliesTo(f, i, pos) and
      t = getAssocFunctionTypeAt(f, i, pos, path)
    |
      not t instanceof SelfTypeParameter and
      result = t
      or
      result = TTrait(t.(SelfTypeParameter).getTrait())
    )
  }

  private TypeMention getTypeMention() {
    exists(Function f, FunctionPosition pos |
      this.appliesTo(f, _, pos) and
      result = pos.getTypeMention(f)
    )
  }

  string toString() { result = this.getTypeMention().toString() }

  Location getLocation() { result = this.getTypeMention().getLocation() }
}

private Trait getALookupTrait(Type t) {
  result = t.(TypeParamTypeParameter).getTypeParam().(TypeParamItemNode).resolveABound()
  or
  result = t.(SelfTypeParameter).getTrait()
  or
  result = t.(ImplTraitType).getImplTraitTypeRepr().(ImplTraitTypeReprItemNode).resolveABound()
  or
  result = t.(DynTraitType).getTrait()
}

/**
 * Gets the type obtained by substituting in relevant traits in which to do function
 * lookup, or `t` itself when no such trait exist.
 */
bindingset[t]
Type substituteLookupTraits(Type t) {
  not exists(getALookupTrait(t)) and
  result = t
  or
  result = TTrait(getALookupTrait(t))
}

/**
 * A wrapper around `IsInstantiationOf` which ensures to substitute in lookup
 * traits when checking whether argument types are instantiations of function
 * types.
 */
module ArgIsInstantiationOf<
  HasTypeTreeSig Arg, IsInstantiationOfInputSig<Arg, AssocFunctionType> Input>
{
  final private class ArgFinal = Arg;

  private class ArgSubst extends ArgFinal {
    Type getTypeAt(TypePath path) {
      result = substituteLookupTraits(super.getTypeAt(path)) and
      not result = TNeverType()
    }
  }

  private module IsInstantiationOfInput implements
    IsInstantiationOfInputSig<ArgSubst, AssocFunctionType>
  {
    pragma[nomagic]
    predicate potentialInstantiationOf(
      ArgSubst arg, TypeAbstraction abs, AssocFunctionType constraint
    ) {
      Input::potentialInstantiationOf(arg, abs, constraint)
    }

    predicate relevantConstraint(AssocFunctionType constraint) {
      Input::relevantConstraint(constraint)
    }
  }

  private module ArgSubstIsInstantiationOf =
    IsInstantiationOf<ArgSubst, AssocFunctionType, IsInstantiationOfInput>;

  predicate argIsInstantiationOf(Arg arg, ImplOrTraitItemNode i, AssocFunctionType constraint) {
    ArgSubstIsInstantiationOf::isInstantiationOf(arg, i, constraint)
  }

  predicate argIsNotInstantiationOf(Arg arg, ImplOrTraitItemNode i, AssocFunctionType constraint) {
    ArgSubstIsInstantiationOf::isNotInstantiationOf(arg, i, constraint)
  }
}

/**
 * Provides the input for `ArgsAreInstantiationsOf`.
 */
signature module ArgsAreInstantiationsOfInputSig {
  /**
   * Holds if types need to be matched against the type `t` at position `pos` of
   * `f` inside `i`.
   */
  predicate toCheck(ImplOrTraitItemNode i, Function f, FunctionPosition pos, AssocFunctionType t);

  /** A call whose argument types are to be checked. */
  class Call {
    string toString();

    Location getLocation();

    Type getArgType(FunctionPosition pos, TypePath path);

    predicate hasTargetCand(ImplOrTraitItemNode i, Function f);
  }
}

/**
 * Provides logic for checking that a set of arguments have types that are
 * instantiations of the types at the corresponding positions in a function
 * type.
 */
module ArgsAreInstantiationsOf<ArgsAreInstantiationsOfInputSig Input> {
  pragma[nomagic]
  private predicate toCheckRanked(ImplOrTraitItemNode i, Function f, FunctionPosition pos, int rnk) {
    Input::toCheck(i, f, pos, _) and
    pos =
      rank[rnk + 1](FunctionPosition pos0, int j |
        Input::toCheck(i, f, pos0, _) and
        (
          j = pos0.asPosition()
          or
          pos0.isSelf() and j = -1
          or
          pos0.isReturn() and j = -2
        )
      |
        pos0 order by j
      )
  }

  private newtype TCallAndPos =
    MkCallAndPos(Input::Call call, FunctionPosition pos) { exists(call.getArgType(pos, _)) }

  /** A call tagged with a position. */
  private class CallAndPos extends MkCallAndPos {
    Input::Call call;
    FunctionPosition pos;

    CallAndPos() { this = MkCallAndPos(call, pos) }

    Input::Call getCall() { result = call }

    FunctionPosition getPos() { result = pos }

    Location getLocation() { result = call.getLocation() }

    Type getTypeAt(TypePath path) { result = call.getArgType(pos, path) }

    string toString() { result = call.toString() + " [arg " + pos + "]" }
  }

  private module ArgIsInstantiationOfInput implements
    IsInstantiationOfInputSig<CallAndPos, AssocFunctionType>
  {
    pragma[nomagic]
    private predicate potentialInstantiationOf0(
      CallAndPos cp, Input::Call call, FunctionPosition pos, int rnk, Function f,
      TypeAbstraction abs, AssocFunctionType constraint
    ) {
      cp = MkCallAndPos(call, pragma[only_bind_into](pos)) and
      call.hasTargetCand(abs, f) and
      toCheckRanked(abs, f, pragma[only_bind_into](pos), rnk) and
      Input::toCheck(abs, f, pragma[only_bind_into](pos), constraint)
    }

    pragma[nomagic]
    predicate potentialInstantiationOf(
      CallAndPos cp, TypeAbstraction abs, AssocFunctionType constraint
    ) {
      exists(Input::Call call, int rnk, Function f |
        potentialInstantiationOf0(cp, call, _, rnk, f, abs, constraint)
      |
        rnk = 0
        or
        argsAreInstantiationsOfFromIndex(call, abs, f, rnk - 1)
      )
    }

    predicate relevantConstraint(AssocFunctionType constraint) {
      Input::toCheck(_, _, _, constraint)
    }
  }

  private module ArgIsInstantiationOfFromIndex =
    ArgIsInstantiationOf<CallAndPos, ArgIsInstantiationOfInput>;

  pragma[nomagic]
  private predicate argsAreInstantiationsOfFromIndex(
    Input::Call call, ImplOrTraitItemNode i, Function f, int rnk
  ) {
    exists(FunctionPosition pos |
      ArgIsInstantiationOfFromIndex::argIsInstantiationOf(MkCallAndPos(call, pos), i, _) and
      call.hasTargetCand(i, f) and
      toCheckRanked(i, f, pos, rnk)
    )
  }

  /**
   * Holds if all arguments of `call` have types that are instantiations of the
   * types of the corresponding parameters of `f` inside `i`.
   */
  pragma[nomagic]
  predicate argsAreInstantiationsOf(Input::Call call, ImplOrTraitItemNode i, Function f) {
    exists(int rnk |
      argsAreInstantiationsOfFromIndex(call, i, f, rnk) and
      rnk = max(int r | toCheckRanked(i, f, _, r))
    )
  }
}
