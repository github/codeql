private import rust
private import codeql.rust.internal.PathResolution
private import Type
private import TypeAbstraction
private import TypeMention
private import TypeInference

private newtype TFunctionPosition =
  TArgumentFunctionPosition(ArgumentPosition pos) { not pos.isSelf() } or
  TReturnFunctionPosition()

/**
 * A function-call adjusted position of a type related to a function.
 *
 * Either `return` or a positional parameter index, where `self` is translated
 * to position `0` and subsequent positional parameters at index `i` are
 * translated to position `i + 1`.
 *
 * Function-call adjusted positions are needed when resolving calls of the
 * form `Foo::f(x_1, ..., x_n)`, where we do not know up front whether `f` is a
 * method or a non-method, and hence we need to be able to match `x_1` against
 * both a potential `self` parameter and a potential first positional parameter
 * (and `x_2, ... x_n` against all subsequent positional parameters).
 */
class FunctionPosition extends TFunctionPosition {
  int asPosition() { result = this.asArgumentPosition().asPosition() }

  predicate isPosition() { exists(this.asPosition()) }

  ArgumentPosition asArgumentPosition() { this = TArgumentFunctionPosition(result) }

  predicate isTypeQualifier() { this.asArgumentPosition().isTypeQualifier() }

  predicate isReturn() { this = TReturnFunctionPosition() }

  TypeMention getTypeMention(Function f) {
    (
      if f instanceof Method
      then
        result = f.getParam(this.asPosition() - 1).getTypeRepr()
        or
        result = getSelfParamTypeMention(f.getSelfParam()) and
        this.asPosition() = 0
      else result = f.getParam(this.asPosition()).getTypeRepr()
    )
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
  /** An associated function `f` in `parent` should be specialized for `i` at `pos`. */
  MkAssocFunctionType(
    ImplOrTraitItemNode parent, Function f, ImplOrTraitItemNode i, FunctionPosition pos
  ) {
    parent.getAnAssocItem() = f and
    i.getASuccessor(_) = f and
    // When `f` is not directly in `i`, the `parent` should be satisfiable
    // through `i`. This ensures that `parent` is either a supertrait of `i` or
    // `i` in an `impl` block implementing `parent`.
    (parent = i or BaseTypes::rootTypesSatisfaction(_, TTrait(parent), i, _, _)) and
    // We always include the type qualifier position, even for non-methods, where it is used
    // to match type qualifiers against the `impl` or trait type, such as in `Vec::new`.
    (exists(pos.getTypeMention(f)) or pos.isTypeQualifier())
  }

bindingset[abs, constraint, tp]
pragma[inline_late]
private Type getTraitConstraintTypeAt(
  TypeAbstraction abs, TypeMention constraint, TypeParameter tp, TypePath path
) {
  BaseTypes::conditionSatisfiesConstraintTypeAt(abs, _, constraint,
    TypePath::singleton(tp).appendInverse(path), result)
}

/**
 * Gets if the type of the function `f` when specialized for `i` at position
 * `pos` at path `path`
 */
pragma[nomagic]
Type getAssocFunctionTypeAt(Function f, ImplOrTraitItemNode i, FunctionPosition pos, TypePath path) {
  exists(ImplOrTraitItemNode parent | exists(MkAssocFunctionType(parent, f, i, pos)) |
    // No specialization needed when the function is directly in the trait or
    // impl block or the declared type is not a type parameter
    (parent = i or not result instanceof TypeParameter) and
    result = pos.getTypeMention(f).getTypeAt(path)
    or
    exists(TypePath prefix, TypePath suffix, TypeParameter tp, TypeMention constraint |
      BaseTypes::rootTypesSatisfaction(_, TTrait(parent), i, _, constraint) and
      path = prefix.append(suffix) and
      tp = pos.getTypeMention(f).getTypeAt(prefix) and
      if tp = TSelfTypeParameter(_)
      then result = resolveImplOrTraitType(i, suffix)
      else result = getTraitConstraintTypeAt(i, constraint, tp, suffix)
    )
  )
  or
  f = i.getASuccessor(_) and
  pos.isTypeQualifier() and
  result = resolveImplOrTraitType(i, path)
}

/**
 * The type of an associated function at a given position, when its implicit
 * `Self` type parameter is specialized to a given trait or `impl` block.
 *
 * Example:
 *
 * ```rust
 * trait T1 {
 *   fn m1(self);              // T1::m1
 *
 *   fn m2(self) { ... }       // T1::m2
 * }
 *
 * trait T2 : T1 {
 *   fn m3(self);              // T2::m3
 * }
 *
 * impl T1 for X {
 *   fn m1(self) { ... }       // X::m1
 * }
 *
 * impl T2 for X {
 *   fn m3(self) { ... }       // X::m3
 * }
 * ```
 *
 * f        | `impl` or trait | pos    | type
 * -------- | --------------- | ------ | ----
 * `T1::m1` | `trait T1`      | `self` | `T1`
 * `T1::m1` | `trait T2`      | `self` | `T2`
 * `T1::m2` | `trait T1`      | `self` | `T1`
 * `T1::m2` | `trait T2`      | `self` | `T2`
 * `T1::m2` | `impl T1 for X` | `self` | `X`
 * `T2::m3` | `trait T2`      | `self` | `T2`
 * `X::m1`  | `impl T1 for X` | `self` | `X`
 * `X::m3`  | `impl T2 for X` | `self` | `X`
 */
class AssocFunctionType extends MkAssocFunctionType {
  /**
   * Holds if this function type applies to the function `f` at position `pos`,
   * when viewed as a member of the `impl` or trait item `i`.
   */
  predicate appliesTo(Function f, ImplOrTraitItemNode i, FunctionPosition pos) {
    this = MkAssocFunctionType(_, f, i, pos)
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

  private AstNode getIdentifyingNode() {
    exists(Function f, ImplOrTraitItemNode i, FunctionPosition pos | this.appliesTo(f, i, pos) |
      result = pos.getTypeMention(f)
      or
      pos.isTypeQualifier() and
      result = [i.(Impl).getSelfTy().(AstNode), i.(Trait).getName()]
    )
  }

  string toString() { result = this.getIdentifyingNode().toString() }

  Location getLocation() { result = this.getIdentifyingNode().getLocation() }
}

pragma[nomagic]
private Trait getALookupTrait(Type t) {
  result = t.(TypeParamTypeParameter).getTypeParam().(TypeParamItemNode).resolveABound()
  or
  result = t.(SelfTypeParameter).getTrait()
  or
  result = t.(ImplTraitType).getImplTraitTypeRepr().(ImplTraitTypeReprItemNode).resolveABound()
  or
  result = t.(DynTraitType).getTrait()
}

pragma[nomagic]
private Trait getAdditionalLookupTrait(ItemNode i, Type t) {
  result =
    t.(TypeParamTypeParameter)
        .getTypeParam()
        .(TypeParamItemNode)
        .resolveAdditionalBound(i.getImmediateParent*())
}

bindingset[n, t]
pragma[inline_late]
Trait getALookupTrait(AstNode n, Type t) {
  result = getALookupTrait(t)
  or
  result = getAdditionalLookupTrait(any(ItemNode i | n = i.getADescendant()), t)
}

bindingset[i, t]
pragma[inline_late]
private Type substituteLookupTraits0(ItemNode i, Type t) {
  not exists(getALookupTrait(t)) and
  not exists(getAdditionalLookupTrait(i, t)) and
  result = t
  or
  result = TTrait(getALookupTrait(t))
  or
  result = TTrait(getAdditionalLookupTrait(i, t))
}

/**
 * Gets the type obtained by substituting in relevant traits in which to do function
 * lookup, or `t` itself when no such trait exists, in the context of AST node `n`.
 */
bindingset[n, t]
pragma[inline_late]
Type substituteLookupTraits(AstNode n, Type t) {
  result = substituteLookupTraits0(any(ItemNode i | n = i.getADescendant()), t)
}

pragma[nomagic]
private Type getNthLookupType(Type t, int n) {
  not exists(getALookupTrait(t)) and
  result = t and
  n = 0
  or
  result =
    TTrait(rank[n + 1](Trait trait, int i |
        trait = getALookupTrait(t) and
        i = idOfTypeParameterAstNode(trait)
      |
        trait order by i
      ))
}

/**
 * Gets the `n`th `substituteLookupTraits` type for `t`, per some arbitrary order,
 * in the context of AST node `node`.
 */
bindingset[node, t]
pragma[inline_late]
Type getNthLookupType(AstNode node, Type t, int n) {
  exists(ItemNode i | node = i.getADescendant() |
    if exists(getAdditionalLookupTrait(i, t))
    then
      result =
        TTrait(rank[n + 1](Trait trait, int j |
            trait = [getALookupTrait(t), getAdditionalLookupTrait(i, t)] and
            j = idOfTypeParameterAstNode(trait)
          |
            trait order by j
          ))
    else result = getNthLookupType(t, n)
  )
}

pragma[nomagic]
private int getLastLookupTypeIndex(Type t) { result = max(int n | exists(getNthLookupType(t, n))) }

/**
 * Gets the index of the last `substituteLookupTraits` type for `t`,
 * in the context of AST node `node`.
 */
bindingset[node, t]
pragma[inline_late]
int getLastLookupTypeIndex(AstNode node, Type t) {
  if exists(getAdditionalLookupTrait(node, t))
  then result = max(int n | exists(getNthLookupType(node, t, n)))
  else result = getLastLookupTypeIndex(t)
}

signature class ArgSig {
  /** Gets the type of this argument at `path`. */
  Type getTypeAt(TypePath path);

  /** Gets the enclosing item node of this argument. */
  ItemNode getEnclosingItemNode();

  /** Gets a textual representation of this argument. */
  string toString();

  /** Gets the location of this argument. */
  Location getLocation();
}

/**
 * A wrapper around `IsInstantiationOf` which ensures to substitute in lookup
 * traits when checking whether argument types are instantiations of function
 * types.
 */
module ArgIsInstantiationOf<ArgSig Arg, IsInstantiationOfInputSig<Arg, AssocFunctionType> Input> {
  final private class ArgFinal = Arg;

  private class ArgSubst extends ArgFinal {
    Type getTypeAt(TypePath path) {
      result = substituteLookupTraits0(this.getEnclosingItemNode(), super.getTypeAt(path)) and
      not result = TNeverType() and
      not result = TUnknownType()
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

  predicate argIsNotInstantiationOf(
    Arg arg, ImplOrTraitItemNode i, AssocFunctionType constraint, TypePath path
  ) {
    ArgSubstIsInstantiationOf::isNotInstantiationOf(arg, i, constraint, path)
  }
}

/**
 * Provides the input for `ArgsAreInstantiationsOf`.
 */
signature module ArgsAreInstantiationsOfInputSig {
  /**
   * Holds if `f` inside `i` needs to have the type corresponding to type parameter
   * `tp` checked.
   *
   * `tp` is a type parameter of the trait being implemented by `f` or the trait to which
   * `f` belongs.
   *
   * `pos` is one of the function-call adjusted positions in `f` in which the relevant
   * type occurs.
   */
  predicate toCheck(ImplOrTraitItemNode i, Function f, TypeParameter tp, FunctionPosition pos);

  /** A call whose argument types are to be checked. */
  class Call {
    string toString();

    Location getLocation();

    ItemNode getEnclosingItemNode();

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
  private predicate toCheckRanked(
    ImplOrTraitItemNode i, Function f, TypeParameter tp, FunctionPosition pos, int rnk
  ) {
    Input::toCheck(i, f, tp, pos) and
    tp =
      rank[rnk + 1](TypeParameter tp0, int j |
        Input::toCheck(i, f, tp0, _) and
        j = getTypeParameterId(tp0)
      |
        tp0 order by j
      )
  }

  pragma[nomagic]
  private predicate toCheck(
    ImplOrTraitItemNode i, Function f, TypeParameter tp, FunctionPosition pos, AssocFunctionType t
  ) {
    Input::toCheck(i, f, tp, pos) and
    t.appliesTo(f, i, pos)
  }

  private newtype TCallAndPos =
    MkCallAndPos(Input::Call call, FunctionPosition pos) { exists(call.getArgType(pos, _)) }

  /** A call tagged with a function-call adjusted position. */
  private class CallAndPos extends MkCallAndPos {
    Input::Call call;
    FunctionPosition pos;

    CallAndPos() { this = MkCallAndPos(call, pos) }

    Input::Call getCall() { result = call }

    FunctionPosition getPos() { result = pos }

    ItemNode getEnclosingItemNode() { result = call.getEnclosingItemNode() }

    Location getLocation() { result = call.getLocation() }

    Type getTypeAt(TypePath path) { result = call.getArgType(pos, path) }

    string toString() { result = call.toString() + " [arg " + pos + "]" }
  }

  pragma[nomagic]
  private predicate potentialInstantiationOf0(
    CallAndPos cp, Input::Call call, TypeParameter tp, FunctionPosition pos, Function f,
    TypeAbstraction abs, AssocFunctionType constraint
  ) {
    cp = MkCallAndPos(call, pragma[only_bind_into](pos)) and
    call.hasTargetCand(abs, f) and
    toCheck(abs, f, tp, pragma[only_bind_into](pos), constraint)
  }

  private module ArgIsInstantiationOfToIndexInput implements
    IsInstantiationOfInputSig<CallAndPos, AssocFunctionType>
  {
    pragma[nomagic]
    predicate potentialInstantiationOf(
      CallAndPos cp, TypeAbstraction abs, AssocFunctionType constraint
    ) {
      exists(Input::Call call, TypeParameter tp, FunctionPosition pos, int rnk, Function f |
        potentialInstantiationOf0(cp, call, tp, pos, f, abs, constraint) and
        toCheckRanked(abs, f, tp, pos, rnk)
      |
        rnk = 0
        or
        argsAreInstantiationsOfToIndex(call, abs, f, rnk - 1)
      )
    }

    predicate relevantConstraint(AssocFunctionType constraint) { toCheck(_, _, _, _, constraint) }
  }

  private module ArgIsInstantiationOfToIndex =
    ArgIsInstantiationOf<CallAndPos, ArgIsInstantiationOfToIndexInput>;

  pragma[nomagic]
  private predicate argIsInstantiationOf(
    Input::Call call, ImplOrTraitItemNode i, Function f, int rnk
  ) {
    exists(FunctionPosition pos |
      ArgIsInstantiationOfToIndex::argIsInstantiationOf(MkCallAndPos(call, pos), i, _) and
      toCheckRanked(i, f, _, pos, rnk)
    )
  }

  pragma[nomagic]
  private predicate argsAreInstantiationsOfToIndex(
    Input::Call call, ImplOrTraitItemNode i, Function f, int rnk
  ) {
    argIsInstantiationOf(call, i, f, rnk) and
    call.hasTargetCand(i, f) and
    (
      rnk = 0
      or
      argsAreInstantiationsOfToIndex(call, i, f, rnk - 1)
    )
  }

  /**
   * Holds if all arguments of `call` have types that are instantiations of the
   * types of the corresponding parameters of `f` inside `i`.
   *
   * TODO: Check type parameter constraints as well.
   */
  pragma[nomagic]
  predicate argsAreInstantiationsOf(Input::Call call, ImplOrTraitItemNode i, Function f) {
    exists(int rnk |
      argsAreInstantiationsOfToIndex(call, i, f, rnk) and
      rnk = max(int r | toCheckRanked(i, f, _, _, r))
    )
  }

  private module ArgsAreNotInstantiationOfInput implements
    IsInstantiationOfInputSig<CallAndPos, AssocFunctionType>
  {
    pragma[nomagic]
    predicate potentialInstantiationOf(
      CallAndPos cp, TypeAbstraction abs, AssocFunctionType constraint
    ) {
      potentialInstantiationOf0(cp, _, _, _, _, abs, constraint)
    }

    predicate relevantConstraint(AssocFunctionType constraint) { toCheck(_, _, _, _, constraint) }
  }

  private module ArgsAreNotInstantiationOf =
    ArgIsInstantiationOf<CallAndPos, ArgsAreNotInstantiationOfInput>;

  pragma[nomagic]
  private predicate argsAreNotInstantiationsOf0(
    Input::Call call, FunctionPosition pos, ImplOrTraitItemNode i
  ) {
    ArgsAreNotInstantiationOf::argIsNotInstantiationOf(MkCallAndPos(call, pos), i, _, _)
  }

  /**
   * Holds if _some_ argument of `call` has a type that is not an instantiation of the
   * type of the corresponding parameter of `f` inside `i`.
   *
   * TODO: Check type parameter constraints as well.
   */
  pragma[nomagic]
  predicate argsAreNotInstantiationsOf(Input::Call call, ImplOrTraitItemNode i, Function f) {
    exists(FunctionPosition pos |
      argsAreNotInstantiationsOf0(call, pos, i) and
      call.hasTargetCand(i, f) and
      Input::toCheck(i, f, _, pos)
    )
  }
}
