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
    result = f.getRetType().getTypeRepr()
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
  MkAssocFunctionType(Function f, FunctionPosition pos, ImplOrTraitItemNode i) {
    f = i.getAnAssocItem() and
    exists(pos.getTypeMention(f))
  } or
  MkInheritedAssocFunctionType(
    Function f, FunctionPosition pos, TypeMention parentMention, ImplOrTraitItemNode parent,
    ImplOrTraitItemNode i
  ) {
    exists(AssocFunctionType inherited |
      inherited.appliesTo(f, pos, parent) and
      f = i.getASuccessor(_)
    |
      parent = i.(ImplItemNode).resolveTraitTy() and
      parentMention = i.(ImplItemNode).getTraitPath()
      or
      parent = i.(TraitItemNode).resolveBound(parentMention)
    )
  }

/**
 * The type of an associated function at a given position, when viewed as a member
 * of a given trait or `impl` block.
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
class AssocFunctionType extends TAssocFunctionType {
  private predicate isFunctionType(Function f, FunctionPosition pos, ImplOrTraitItemNode i) {
    this = MkAssocFunctionType(f, pos, i)
  }

  private predicate isInheritedFunctionType(
    Function f, FunctionPosition pos, TypeMention parentMention, ImplOrTraitItemNode parent,
    ImplOrTraitItemNode i
  ) {
    this = MkInheritedAssocFunctionType(f, pos, parentMention, parent, i)
  }

  /**
   * Holds if this function type applies to the function `f` at position `pos`,
   * when viewed as a member of the `impl` or trait item `i`.
   */
  predicate appliesTo(Function f, FunctionPosition pos, ImplOrTraitItemNode i) {
    this.isFunctionType(f, pos, i)
    or
    this.isInheritedFunctionType(f, pos, _, _, i)
  }

  /** Gets the type at the given path. */
  pragma[nomagic]
  Type getDeclaredTypeAt(TypePath path) {
    exists(Function f, FunctionPosition pos |
      this.isFunctionType(f, pos, _) and
      result = pos.getTypeMention(f).resolveTypeAt(path)
    )
    or
    exists(
      Function f, FunctionPosition pos, TypeMention parentMention, ImplOrTraitItemNode parent,
      AssocFunctionType parentType, ImplOrTraitItemNode i
    |
      this.isInheritedFunctionType(f, pos, parentMention, parent, i) and
      parentType.appliesTo(f, pos, parent)
    |
      result = parentType.getDeclaredTypeAt(path) and
      not result instanceof TypeParameter
      or
      exists(TypePath prefix, TypePath suffix | path = prefix.append(suffix) |
        parentType.hasSelfTypeParameterAt(prefix) and
        result = resolveImplOrTraitType(i, suffix)
        or
        exists(TypeParameter tp |
          tp = parentType.getTypeParameterAt(prefix) and
          result = parentMention.resolveTypeAt(TypePath::singleton(tp).appendInverse(suffix))
        )
      )
    )
  }

  pragma[nomagic]
  private TypeParameter getTypeParameterAt(TypePath path) { result = this.getDeclaredTypeAt(path) }

  pragma[nomagic]
  private predicate hasSelfTypeParameterAt(TypePath path) {
    this.getTypeParameterAt(path) = TSelfTypeParameter(_)
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
    exists(Type t | t = this.getDeclaredTypeAt(path) |
      not t instanceof SelfTypeParameter and
      result = t
      or
      result = TTrait(t.(SelfTypeParameter).getTrait())
    )
  }

  private TypeMention getTypeMention() {
    exists(Function f, FunctionPosition pos |
      this.appliesTo(f, pos, _) and
      result = pos.getTypeMention(f)
    )
  }

  string toString() { result = this.getTypeMention().toString() }

  Location getLocation() { result = this.getTypeMention().getLocation() }
}

/**
 * Holds if the type of the function `f` at position `pos` and path `path` inside
 * `i` is `type`.
 */
pragma[nomagic]
predicate assocFunctionTypeAt(
  Function f, ImplOrTraitItemNode i, FunctionPosition pos, TypePath path, Type type
) {
  exists(AssocFunctionType aft |
    aft.appliesTo(f, pos, i) and
    type = aft.getDeclaredTypeAt(path)
  )
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
    Type getTypeAt(TypePath path) { result = substituteLookupTraits(super.getTypeAt(path)) }
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
      cp = MkCallAndPos(call, pos) and
      call.hasTargetCand(abs, f) and
      toCheckRanked(abs, f, pos, rnk) and
      Input::toCheck(abs, f, pos, constraint)
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
