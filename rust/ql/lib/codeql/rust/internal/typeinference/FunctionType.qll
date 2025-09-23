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

pragma[nomagic]
predicate functionTypeAtPath(Function f, FunctionTypePosition pos, TypePath path, Type type) {
  type = pos.getTypeMention(f).resolveTypeAt(path)
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

private newtype TFunctionType =
  MkFunctionType(Function f, FunctionTypePosition pos, ImplOrTraitItemNode i) {
    f = i.getAnAssocItem() and
    exists(pos.getTypeMention(f))
  } or
  MkInheritedFunctionType(
    Function f, FunctionTypePosition pos, ImplOrTraitItemNode parent, ImplOrTraitItemNode i
  ) {
    exists(FunctionType inherited |
      inherited.appliesTo(f, pos, parent) and
      f = i.getASuccessor(_)
    |
      parent = i.(ImplItemNode).resolveTraitTy()
      or
      parent = i.(TraitItemNode).resolveABound()
    )
  }

/**
 * The type of a function at a given position, when viewed as a member of a given
 * trait or `impl` block.
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
class FunctionType extends TFunctionType {
  private predicate isFunctionType(Function f, FunctionTypePosition pos, ImplOrTraitItemNode i) {
    this = MkFunctionType(f, pos, i)
  }

  private predicate isInheritedFunctionType(
    Function f, FunctionTypePosition pos, ImplOrTraitItemNode parent, ImplOrTraitItemNode i
  ) {
    this = MkInheritedFunctionType(f, pos, parent, i)
  }

  /**
   * Holds if this function type applies to the function `f` at position `pos`,
   * when viewed as a member of the `impl` or trait item `i`.
   */
  predicate appliesTo(Function f, FunctionTypePosition pos, ImplOrTraitItemNode i) {
    this.isFunctionType(f, pos, i)
    or
    this.isInheritedFunctionType(f, pos, _, i)
  }

  pragma[nomagic]
  private Type getTypeAt0(TypePath path) {
    exists(Function f, FunctionTypePosition pos |
      this.isFunctionType(f, pos, _) and
      functionTypeAtPath(f, pos, path, result)
    )
    or
    exists(
      Function f, FunctionTypePosition pos, FunctionType parentType, ImplOrTraitItemNode parent,
      ImplOrTraitItemNode i
    |
      this.isInheritedFunctionType(f, pos, parent, i) and
      parentType.appliesTo(f, pos, parent)
    |
      result = parentType.getTypeAt0(path) and
      not result instanceof TSelfTypeParameter
      or
      exists(TypePath prefix, TypePath suffix |
        parentType.hasSelfTypeParameterAt(prefix) and
        result = resolveImplOrTraitType(i, suffix) and
        path = prefix.append(suffix)
      )
    )
  }

  pragma[nomagic]
  private predicate hasSelfTypeParameterAt(TypePath path) {
    this.getTypeAt0(path) = TSelfTypeParameter(_)
  }

  /**
   * Gets the type of this function at the given position and path.
   *
   * For functions belonging to a `trait`, we use the type of the trait itself instead
   * of the implicit `Self` type parameter, as otherwise any type will match.
   *
   * Calls should use `substituteLookupTraits` to map receiver types to the relevant
   * traits when matching.
   */
  Type getTypeAt(TypePath path) {
    exists(Type t | t = this.getTypeAt0(path) |
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
