private import rust
private import codeql.rust.internal.TypeInference
private import codeql.rust.internal.PathResolution
private import codeql.rust.internal.Type
private import codeql.rust.internal.TypeMention
private import codeql.rust.elements.Call

private newtype TFunctionTypePosition =
  TArgumentFunctionTypePosition(ArgumentPosition pos) or
  TReturnFunctionTypePosition()

/**
 * A position of a type related to a function.
 *
 * Either `self`, `return`, or a positional parameter index.
 */
class FunctionTypePosition extends TFunctionTypePosition {
  predicate isSelf() { this.asArgumentPosition().isSelf() }

  int asPositional() { result = this.asArgumentPosition().asPosition() }

  predicate isPositional() { exists(this.asPositional()) }

  ArgumentPosition asArgumentPosition() { this = TArgumentFunctionTypePosition(result) }

  predicate isReturn() { this = TReturnFunctionTypePosition() }

  /** Gets the corresponding position when `f` is invoked via a function call. */
  bindingset[f]
  FunctionTypePosition getFunctionCallAdjusted(Function f) {
    this.isReturn() and
    result = this
    or
    if f.hasSelfParam()
    then
      this.isSelf() and result.asPositional() = 0
      or
      result.asPositional() = this.asPositional() + 1
    else result = this
  }

  TypeMention getTypeMention(Function f) {
    this.isSelf() and
    result = getSelfParamTypeMention(f.getSelfParam())
    or
    result = f.getParam(this.asPositional()).getTypeRepr()
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
 * `DeclarationPosition = AccessPosition = FunctionTypePosition`.
 */
module FunctionTypePositionMatchingInput {
  class DeclarationPosition = FunctionTypePosition;

  class AccessPosition = DeclarationPosition;

  predicate accessDeclarationPositionMatch(AccessPosition apos, DeclarationPosition dpos) {
    apos = dpos
  }
}

private newtype TAssocFunctionType =
  MkAssocFunctionType(Function f, FunctionTypePosition pos, ImplOrTraitItemNode i) {
    f = i.getAnAssocItem() and
    exists(pos.getTypeMention(f))
  } or
  MkInheritedAssocFunctionType(
    Function f, FunctionTypePosition pos, TypeMention parentMention, ImplOrTraitItemNode parent,
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
  private predicate isFunctionType(Function f, FunctionTypePosition pos, ImplOrTraitItemNode i) {
    this = MkAssocFunctionType(f, pos, i)
  }

  private predicate isInheritedFunctionType(
    Function f, FunctionTypePosition pos, TypeMention parentMention, ImplOrTraitItemNode parent,
    ImplOrTraitItemNode i
  ) {
    this = MkInheritedAssocFunctionType(f, pos, parentMention, parent, i)
  }

  /**
   * Holds if this function type applies to the function `f` at position `pos`,
   * when viewed as a member of the `impl` or trait item `i`.
   */
  predicate appliesTo(Function f, FunctionTypePosition pos, ImplOrTraitItemNode i) {
    this.isFunctionType(f, pos, i)
    or
    this.isInheritedFunctionType(f, pos, _, _, i)
  }

  /** Gets the type at the given path. */
  pragma[nomagic]
  Type getDeclaredTypeAt(TypePath path) {
    exists(Function f, FunctionTypePosition pos |
      this.isFunctionType(f, pos, _) and
      result = pos.getTypeMention(f).resolveTypeAt(path)
    )
    or
    exists(
      Function f, FunctionTypePosition pos, TypeMention parentMention, ImplOrTraitItemNode parent,
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
          parentType.hasTypeParameterAt(prefix, tp) and
          result = parentMention.resolveTypeAt(TypePath::singleton(tp).appendInverse(suffix))
        )
      )
    )
  }

  pragma[nomagic]
  private predicate hasTypeParameterAt(TypePath path, TypeParameter tp) {
    this.getDeclaredTypeAt(path) = tp
  }

  pragma[nomagic]
  private predicate hasSelfTypeParameterAt(TypePath path) {
    this.hasTypeParameterAt(path, TSelfTypeParameter(_))
  }

  /**
   * Gets the type at the given path.
   *
   * For functions belonging to a `trait`, we use the type of the trait itself instead
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

  private AstNode getReportingNode() {
    exists(Function f, FunctionTypePosition pos | this.appliesTo(f, pos, _) |
      pos.isSelf() and
      exists(SelfParam self | self = f.getSelfParam() |
        result = self.getTypeRepr()
        or
        not self.hasTypeRepr() and
        result = self
      )
      or
      result = f.getParam(pos.asPositional()).getTypeRepr()
      or
      pos.isReturn() and
      result = f.getRetType().getTypeRepr()
    )
  }

  string toString() { result = this.getReportingNode().toString() }

  Location getLocation() { result = this.getReportingNode().getLocation() }
}

/**
 * Holds if the type of the function `f` at position `pos` and path `path` inside
 * `i` is `type`.
 */
pragma[nomagic]
predicate assocFunctionTypeAtPath(
  Function f, ImplOrTraitItemNode i, FunctionTypePosition pos, TypePath path, Type type
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
  predicate toCheck(ImplOrTraitItemNode i, Function f, FunctionTypePosition pos, AssocFunctionType t);

  /** A call whose argument types are to be checked. */
  class Call {
    string toString();

    Location getLocation();

    Type getArgType(FunctionTypePosition pos, TypePath path);

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
  private predicate toCheckRanked(
    ImplOrTraitItemNode i, Function f, FunctionTypePosition pos, int rnk
  ) {
    Input::toCheck(i, f, pos, _) and
    pos =
      rank[rnk + 1](FunctionTypePosition pos0, int j |
        Input::toCheck(i, f, pos0, _) and
        (
          j = pos0.asPositional()
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
    MkCallAndPos(Input::Call call, FunctionTypePosition pos) { exists(call.getArgType(pos, _)) }

  /** A call tagged with a position. */
  private class CallAndPos extends MkCallAndPos {
    Input::Call call;
    FunctionTypePosition pos;

    CallAndPos() { this = MkCallAndPos(call, pos) }

    Input::Call getCall() { result = call }

    FunctionTypePosition getPos() { result = pos }

    Location getLocation() { result = call.getLocation() }

    Type getTypeAt(TypePath path) { result = call.getArgType(pos, path) }

    string toString() { result = call.toString() + " [arg " + pos + "]" }
  }

  private module ArgIsInstantiationOfInput implements
    IsInstantiationOfInputSig<CallAndPos, AssocFunctionType>
  {
    pragma[nomagic]
    private predicate potentialInstantiationOf0(
      CallAndPos cp, Input::Call call, FunctionTypePosition pos, int rnk, Function f,
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
    exists(FunctionTypePosition pos |
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
