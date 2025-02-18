/** Provides functionality for inferring types. */

private import rust
private import PathResolution

/** Gets the singleton type path `i`. */
bindingset[i]
private TypePath typePath(int i) { result = i.toString() }

bindingset[s]
private predicate decodeTypePathComponent(string s, int i) { i = s.toInt() }

/**
 * A path into a type.
 *
 * Paths are represented in left-to-right order, for example, a path `0.1` into the
 * type `C1<C2<A,B>,C3<C,D>>` points at the type `B`.
 *
 * Type paths are used to represent constructed types without using a `newtype`, which
 * makes it practically feasible to do type inference in mutual recursion with call
 * resolution.
 *
 * As an example, the type above can be represented by the following set of tuples
 *
 * `TypePath` | `Type`
 * ---------- | ------
 * `""`       | ``C1``
 * `"0"`      | ``C2``
 * `"0.0"`    | `A`
 * `"0.1"`    | `B`
 * `"1"`      | ``C3``
 * `"1.0"`    | `C`
 * `"1.1"`    | `D`
 */
class TypePath extends string {
  bindingset[this]
  TypePath() { exists(this) }

  predicate isEmpty() { this = "" }

  /** Gets the path obtained by appending `suffix` onto this path. */
  bindingset[suffix, result]
  bindingset[this, result]
  bindingset[this, suffix]
  TypePath append(TypePath suffix) {
    if this.isEmpty()
    then result = suffix
    else
      if suffix.isEmpty()
      then result = this
      else result = this + "." + suffix
  }

  /** Holds if this path starts with `prefix`, followed by `i`. */
  bindingset[this]
  predicate endsWith(TypePath prefix, int i) {
    decodeTypePathComponent(this, i) and
    prefix.isEmpty()
    or
    exists(int last |
      last = max(this.indexOf(".")) and
      prefix = this.prefix(last) and
      decodeTypePathComponent(this.suffix(last + 1), i)
    )
  }

  /** Holds if this path starts with `i`, followed by `suffix`. */
  bindingset[this]
  predicate startsWith(int i, TypePath suffix) {
    decodeTypePathComponent(this, i) and
    suffix.isEmpty()
    or
    exists(int first |
      first = min(this.indexOf(".")) and
      suffix = this.suffix(first + 1) and
      decodeTypePathComponent(this.prefix(first), i)
    )
  }
}

private predicate letStmtTyped(LetStmt let, Pat pat, TypeRepr t) {
  pat = let.getPat() and
  t = let.getTypeRepr() and
  not t instanceof InferTypeRepr
}

private predicate selfParamTyped(SelfParam p, TypeRepr t) {
  t = p.getTypeRepr() and
  not t instanceof InferTypeRepr
}

private predicate paramTyped(Param p, Pat pat, TypeRepr t) {
  pat = p.getPat() and
  t = p.getTypeRepr() and
  not t instanceof InferTypeRepr
}

private predicate isTargetTyped(AstNode n) {
  exists(Variable v |
    n = v.getPat() and
    not letStmtTyped(_, n, _) and
    not paramTyped(_, n, _)
  )
  or
  n = any(SelfParam self | not selfParamTyped(self, _))
  or
  exists(n) and
  1 = 2 // todo
}

// todo: add more cases
private newtype TType =
  TStruct(Struct s) or
  TEnum(Enum e) or
  TTrait(Trait t) or
  TArrayType() or // todo: add size?
  TRefType() or // todo: add mut, lifetime?
  TTypeParameter(TypeParam t)

/** A type without type arguments. */
abstract class Type extends TType {
  pragma[nomagic]
  abstract Function getMethod(string name);

  pragma[nomagic]
  abstract RecordField getRecordField(string name);

  pragma[nomagic]
  abstract TupleField getTupleField(int i);

  abstract TypeRepr getABaseType();

  abstract string toString();

  abstract Location getLocation();
}

class StructType extends Type, TStruct {
  private Struct struct;

  StructType() { this = TStruct(struct) }

  override Function getMethod(string name) {
    // todo: assumes all `impl` blocks are in scope
    exists(ImplItemNode i |
      struct = i.resolveSelfTy() and
      result = i.getASuccessor(name) and
      // todo: generics are not supported
      not i.getSelfPath().getPart().hasGenericArgList()
    )
  }

  override RecordField getRecordField(string name) { result = struct.getRecordField(name) }

  override TupleField getTupleField(int i) { result = struct.getTupleField(i) }

  override TypeRepr getABaseType() {
    exists(ImplItemNode i |
      struct = i.resolveSelfTy() and
      result = i.(Impl).getTrait()
    )
  }

  override string toString() { result = struct.toString() }

  override Location getLocation() { result = struct.getLocation() }
}

class EnumType extends Type, TEnum {
  private Enum enum;

  EnumType() { this = TEnum(enum) }

  override Function getMethod(string name) {
    // todo: assumes all `impl` blocks are in scope
    exists(ImplItemNode i |
      enum = i.resolveSelfTy() and
      result = i.getASuccessor(name) and
      // todo: generics are not supported
      not i.getSelfPath().getPart().hasGenericArgList()
    )
  }

  override RecordField getRecordField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeRepr getABaseType() {
    exists(ImplItemNode i |
      enum = i.resolveSelfTy() and
      result = i.(Impl).getTrait()
    )
  }

  override string toString() { result = enum.toString() }

  override Location getLocation() { result = enum.getLocation() }
}

class TraitType extends Type, TTrait {
  private TraitItemNode trait;

  TraitType() { this = TTrait(trait) }

  override Function getMethod(string name) {
    result = trait.getASuccessor(name)
    or
    result = this.getABound().resolveType().getMethod(name)
  }

  override RecordField getRecordField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  pragma[nomagic]
  private TypeRepr_ getABound() {
    result = trait.(Trait).getTypeBoundList().getABound().getTypeRepr()
  }

  override TypeRepr getABaseType() { result = this.getABound() }

  override string toString() { result = trait.toString() }

  override Location getLocation() { result = trait.getLocation() }
}

class ArrayType extends Type, TArrayType {
  ArrayType() { this = TArrayType() }

  override Function getMethod(string name) { none() }

  override RecordField getRecordField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeRepr getABaseType() { none() }

  override string toString() { result = "[]" }

  override Location getLocation() { result instanceof EmptyLocation }
}

class RefType extends Type, TRefType {
  RefType() { this = TRefType() }

  override Function getMethod(string name) { none() }

  override RecordField getRecordField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeRepr getABaseType() { none() }

  override string toString() { result = "&" }

  override Location getLocation() { result instanceof EmptyLocation }
}

class TypeParameter extends Type, TTypeParameter {
  private TypeParam typeParam;

  TypeParameter() { this = TTypeParameter(typeParam) }

  TypeParam getTypeParam() { result = typeParam }

  pragma[nomagic]
  private TypeRepr_ getABound() { result = typeParam.getTypeBoundList().getABound().getTypeRepr() }

  int getPosition() { typeParam = any(GenericParamList l).getTypeParam(result) }

  override Function getMethod(string name) {
    result = this.getABound().resolveTypeAt("").getMethod(name)
  }

  override RecordField getRecordField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeRepr getABaseType() { none() }

  override string toString() { result = typeParam.toString() }

  override Location getLocation() { result = typeParam.getLocation() }
}

/** A `TypeRepr` or a `Path`. */
abstract private class TypeReprOrPath extends AstNode {
  /** Gets the `i`th type argument, if any. */
  abstract TypeRepr_ getTypeReprArgument(int i);

  /** Gets the type that this node resolves to. */
  abstract Type resolveType();

  /** Gets the node at `path`. */
  private TypeReprOrPath getTypeReprAt(TypePath path) {
    path.isEmpty() and
    result = this
    or
    exists(int i, TypeReprOrPath arg, TypePath suffix |
      arg = this.getTypeReprArgument(i) and
      result = arg.getTypeReprAt(suffix) and
      path = typePath(i).append(suffix)
    )
  }

  /** Gets the type that the sub node at `path` resolves to. */
  Type resolveTypeAt(TypePath path) { result = this.getTypeReprAt(path).resolveType() }
}

private class TypeRepr_ extends TypeReprOrPath, TypeRepr {
  override TypeRepr_ getTypeReprArgument(int i) {
    result = this.(ArrayTypeRepr).getElementTypeRepr() and
    i = 0
    or
    result = this.(RefTypeRepr).getTypeRepr() and
    i = 0
    or
    result = this.(PathTypeRepr).getPath().(Path_).getTypeReprArgument(i)
  }

  override Type resolveType() {
    this instanceof ArrayTypeRepr and
    result = TArrayType()
    or
    this instanceof RefTypeRepr and
    result = TRefType()
    or
    result = this.(PathTypeRepr).getPath().(Path_).resolveType()
  }
}

private class Path_ extends TypeReprOrPath, Path {
  override TypeRepr_ getTypeReprArgument(int i) {
    result = this.getPart().getGenericArgList().getTypeArgument(i)
  }

  override Type resolveType() {
    exists(ItemNode i | i = resolvePath(this) |
      result = TStruct(i)
      or
      result = TEnum(i)
      or
      result = TTrait(i)
      or
      result = TTypeParameter(i)
      or
      result = i.(TypeAlias).getTypeRepr().(TypeRepr_).resolveType()
    )
  }
}

/** Provides logic for computing base types. */
private module BaseTypes {
  /**
   * Holds if `base` is a (transitive) base type mention of `sub`, and `tp`
   * (belonging to `sub`) is mentioned (implicitly) at `path` inside `base`.
   * For example, in
   *
   * ```csharp
   * class C<T1> { }
   *
   * class Base<T2> { }
   *
   * class Mid<T3> : Base<C<T3>> { }
   *
   * class Sub<T4> : Mid<C<T4>> { }
   * ```
   *
   * - `T3` is mentioned at `0.0` for immediate base type `Base` of `Mid`,
   * - `T4` is mentioned at `0.0` for immediate base type `Mid` of `Sub`, and
   * - `T4` is mentioned at `0.0.0` for transitive base type `Base` of `Sub`.
   */
  pragma[nomagic]
  private predicate baseTypeMentionHasTypeParameterAt(
    Type sub, TypeRepr base, TypePath path, TypeParameter tp
  ) {
    exists(TypeRepr_ immediateBase, TypePath pathToTypeParam |
      immediateBase = sub.getABaseType() and
      tp = immediateBase.resolveTypeAt(pathToTypeParam)
    |
      // immediate base class
      base = immediateBase and
      path = pathToTypeParam
      or
      // transitive base class
      exists(TypePath prefix, TypePath suffix, int i |
        baseTypeMentionHasTypeParameterAt0(immediateBase.resolveType(), base, prefix, i) and
        pathToTypeParam.startsWith(i, suffix) and
        path = prefix.append(suffix)
      )
    )
  }

  pragma[nomagic]
  private predicate baseTypeMentionHasTypeParameterAt0(Type sub, TypeRepr base, TypePath path, int i) {
    exists(TypeParameter tp |
      baseTypeMentionHasTypeParameterAt(sub, base, path, tp) and
      i = tp.getPosition()
    )
  }

  /**
   * Holds if `base` is a (transitive) base type mention of `sub`, and
   * non-type-parameter `t` is mentioned (implicitly) at `path` inside `base`.
   * For example, in
   *
   * ```csharp
   * class C<T1> { }
   *
   * class Base<T2> { }
   *
   * class Mid<T3> : Base<C<T3>> { }
   *
   * class Sub<T4> : Mid<C<T4>> { }
   * ```
   *
   * - `C` is mentioned at `0` for immediate base type `Base` of `Mid`,
   * - `C` is mentioned at `0` for immediate base type `Mid` of `Sub`, and
   * - `C` is mentioned at `0` and `0.0` for transitive base type `Base` of `Sub`.
   */
  pragma[nomagic]
  private predicate baseTypeMentionHasNonTypeParameterAt(
    Type sub, TypeRepr_ base, TypePath path, Type t
  ) {
    not t instanceof TypeParameter and
    exists(TypeRepr_ immediateBase |
      pragma[only_bind_into](immediateBase) = pragma[only_bind_into](sub).getABaseType()
    |
      base = immediateBase and
      t = base.resolveTypeAt(path)
      or
      baseTypeMentionHasNonTypeParameterAt(immediateBase.resolveType(), base, path, t)
      or
      exists(TypePath path0, TypePath prefix, TypePath suffix, int i |
        baseTypeMentionHasTypeParameterAt0(immediateBase.resolveType(), base, prefix, i) and
        t = immediateBase.resolveTypeAt(path0) and
        path0.startsWith(i, suffix) and
        path = prefix.append(suffix)
      )
    )
  }

  signature module BaseTypeAtInputSig {
    class Node;

    Type resolveType(Node n, TypePath path);
  }

  module NodeHasBaseTypeAt<BaseTypeAtInputSig Input> {
    pragma[nomagic]
    private Type resolveRootType(Input::Node n) { result = Input::resolveType(n, "") }

    pragma[nomagic]
    private Type resolveTypeAt(Input::Node n, int i, TypePath suffix) {
      exists(TypePath path0, TypeParameter tp |
        result = Input::resolveType(n, path0) and
        i = tp.getPosition() and
        path0.startsWith(i, suffix)
      )
    }

    /**
     * Holds if `base` is a (transitive) base type mention of the type of `n`, and
     * `t` is mentioned (implicitly) at `path` inside `base`. For example, in
     *
     * ```csharp
     * class C<T1> { }
     *
     * class Base<T2> { }
     *
     * class Mid<T3> : Base<C<T3>> { }
     *
     * class Sub<T4> : Mid<C<T4>> { }
     *
     * new Sub<int>();
     * ```
     *
     * for the node `new Sub<int>()`:
     *
     * - `C` is mentioned at `0` for immediate base type `Mid`,
     * - `int` is mentioned at `0.1` for immediate base type `Mid`,
     * - `C` is mentioned at `0` and `0.0` for transitive base type `Base`, and
     * - `int` is mentioned at `0.0.1` for transitive base type `Base`.
     */
    pragma[nomagic]
    predicate hasBaseType(Input::Node n, TypeRepr base, TypePath path, Type t) {
      exists(Type sub | sub = resolveRootType(n) |
        baseTypeMentionHasNonTypeParameterAt(sub, base, path, t)
        or
        exists(TypePath prefix, TypePath suffix, int i |
          baseTypeMentionHasTypeParameterAt0(sub, base, prefix, i) and
          t = resolveTypeAt(n, i, suffix) and
          path = prefix.append(suffix)
        )
      )
    }
  }
}

private import BaseTypes

private signature module MatchingInputSig {
  class Decl {
    string toString();

    Location getLocation();

    TypeParameter getTypeParameter(int i);
  }

  class Access {
    string toString();

    Location getLocation();

    Type getTypeArgument(int i, TypePath path);

    predicate noExplicitTypeArguments();
  }

  bindingset[this]
  class Pos {
    bindingset[this]
    string toString();
  }

  Pos getReturnPos();

  predicate target(Access a, Decl target);

  predicate argumentType(Access a, Pos pos, TypePath path, Type t);

  predicate argumentIsTargetTyped(Access a, Pos pos);

  predicate argumentIsNotTargetTyped(Access a, Pos pos);

  predicate parameterType(Decl decl, Pos pos, TypePath path, Type t);

  predicate declType(Decl decl, TypePath path, Type t);
}

private module Matching<MatchingInputSig Input> {
  private import Input

  pragma[nomagic]
  private predicate argumentType0(Access a, Pos pos, TypePath path, Type t) {
    argumentType(a, pos, path, t) and
    argumentIsNotTargetTyped(a, pos)
  }

  pragma[nomagic]
  private predicate argumentTypeAt(Access a, Pos pos, Decl target, TypePath path, Type t) {
    target(a, target) and
    argumentType0(a, pos, path, t)
  }

  pragma[nomagic]
  private predicate argumentTypeMatchAt(Access a, Pos pos, Decl target, TypePath path, TypePath end) {
    exists(Type match |
      argumentTypeAt(a, pos, target, path, match) and
      path.endsWith(end, _) and
      parameterType(target, pos, path, match)
    )
  }

  /**
   * Holds if the type `t` at `path` of `a` at position `pos` matches the type parameter
   * of `target` at the same position, possibly except the types at `toMatch`.
   *
   * There is an actual match when `toMatch` is empty.
   */
  pragma[nomagic]
  private predicate typeMatch(
    Access a, Pos pos, Decl target, TypePath path, Type t, TypeParameter tp, TypePath toMatch
  ) {
    a.noExplicitTypeArguments() and
    exists(TypePath pathToTypeParam |
      argumentTypeAt(a, pos, target, pathToTypeParam.append(path), t) and
      parameterType(target, pos, pathToTypeParam, tp) and
      if pathToTypeParam.isEmpty()
      then toMatch.isEmpty()
      else (
        pathToTypeParam.endsWith(toMatch, _) and
        exists(Type match |
          argumentTypeAt(a, pos, target, "", match) and
          parameterType(target, pos, "", match)
        )
      )
    )
    or
    exists(TypePath toMatch0 |
      typeMatch(a, pos, target, path, t, tp, toMatch0) and
      argumentTypeMatchAt(a, pos, target, toMatch0, toMatch)
    )
  }

  predicate declType(Decl decl, Pos at, TypePath path, Type t) {
    declType(decl, path, t) and
    at = getReturnPos()
    or
    parameterType(decl, at, path, t)
  }

  private module BaseTypeAtInput implements BaseTypeAtInputSig {
    private newtype TNode =
      MkNode(Access a, Pos pos) {
        exists(Decl target |
          argumentTypeAt(a, pos, target, _, _) and
          declType(target, _, _, any(TypeParameter tp))
        )
      }

    additional Node mkNode(Access a, Pos pos) { result = MkNode(a, pos) }

    class Node extends MkNode {
      Access getAccess() { this = MkNode(result, _) }

      Pos getPos() { this = MkNode(_, result) }

      string toString() { result = this.getAccess().toString() + ", " + this.getPos().toString() }

      Location getLocation() { result = this.getAccess().getLocation() }
    }

    Type resolveType(Node n, TypePath path) {
      exists(Access a, Pos pos |
        n = MkNode(a, pos) and
        argumentType(a, pos, path, result)
      )
    }
  }

  // pragma[nomagic]
  // private predicate arrayTypeAt(Access a, int pos, Type base, TypePath path, Type t) {
  //   exists(UnboundType::TsUnboundArrayType at |
  //     at.getRank() = 1 and
  //     argumentType(a, pos, "", at)
  //   |
  //     BaseTypes::arrayBaseTypeHasTypeParameterAt(base, path) and
  //     argumentType(a, pos, "0", t)
  //     or
  //     BaseTypes::arrayBaseTypeHasNonTypeParameterAt(base, path, t)
  //   )
  // }
  pragma[nomagic]
  private predicate argumentBaseTypeAt(
    Access a, Pos pos, Decl target, Type base, TypePath path, Type t
  ) {
    exists(TypeRepr_ tm |
      target(a, target) and
      NodeHasBaseTypeAt<BaseTypeAtInput>::hasBaseType(BaseTypeAtInput::mkNode(a, pos), tm, path, t) and
      base = tm.resolveType()
    )
    // or
    // target(a, target) and
    // arrayTypeAt(a, pos, base, path, t)
  }

  pragma[nomagic]
  private predicate parameterBaseType(Decl decl, Pos pos, Type base, TypePath path, Type t) {
    parameterType(decl, pos, path, t) and
    parameterType(decl, pos, "", base)
  }

  /**
   * Holds if the (transitive) base type `t` at `path` (which is somewhere inside `base`)
   * of `a` at position `pos` matches the type parameter of `target` at the same position,
   * possibly except the types at `toMatch`.
   *
   * There is an actual match when `toMatch` is empty.
   */
  pragma[nomagic]
  private predicate baseTypeMatch(
    Access a, Pos pos, Decl target, Type base, TypePath path, Type t, TypeParameter tp,
    TypePath toMatch
  ) {
    a.noExplicitTypeArguments() and
    exists(TypePath pathToTypeParam |
      argumentBaseTypeAt(a, pos, target, base, pathToTypeParam.append(path), t) and
      parameterBaseType(target, pos, base, pathToTypeParam, tp) and
      // do not allow `pathToTypeParam` to be empty in this case, as we will match
      // against the actual type and not one of the base types
      pathToTypeParam.endsWith(toMatch, _)
    )
    or
    exists(TypePath toMatch0, Type match |
      baseTypeMatch(a, pos, target, base, path, t, tp, toMatch0) and
      toMatch0.endsWith(toMatch, _) and
      argumentBaseTypeAt(a, pos, target, base, toMatch0, match) and
      parameterBaseType(target, pos, base, toMatch0, match)
    )
  }

  pragma[nomagic]
  private predicate explicitTypeMatch(Access a, Decl target, TypePath path, Type t, TypeParameter tp) {
    exists(int i |
      t = a.getTypeArgument(pragma[only_bind_into](i), path) and
      target(a, target) and
      tp = target.getTypeParameter(pragma[only_bind_into](i))
    )
  }

  pragma[nomagic]
  private predicate implicitTypeMatch(Access a, Decl target, TypePath path, Type t, TypeParameter tp) {
    typeMatch(a, _, target, path, t, tp, "")
    or
    baseTypeMatch(a, _, target, _, path, t, tp, "")
  }

  pragma[inline]
  private predicate typeMatch(Access a, Decl target, TypePath path, Type t, TypeParameter tp) {
    explicitTypeMatch(a, target, path, t, tp)
    or
    implicitTypeMatch(a, target, path, t, tp)
  }

  pragma[nomagic]
  Type resolveAccess(Access a, Pos at, TypePath path) {
    exists(Decl target, TypePath prefix, TypeParameter tp, TypePath suffix |
      declType(target, pragma[only_bind_into](at), prefix, tp) and
      typeMatch(a, target, suffix, result, tp) and
      path = prefix.append(suffix)
    |
      at = getReturnPos()
      or
      argumentIsTargetTyped(a, pragma[only_bind_into](at))
    )
  }
}

private Type resolveVariableType(AstNode n, TypePath path) {
  exists(TypeRepr_ t | letStmtTyped(_, n, t) or selfParamTyped(n, t) or paramTyped(_, n, t) |
    result = t.resolveTypeAt(path)
  )
  or
  exists(Variable v |
    result = resolveType([v.getPat().(AstNode), v.getSelfParam()], path) and
    n = v.getAnAccess()
  )
}

pragma[nomagic]
private Type resolveImplSelfType(Impl i, TypePath path) {
  result = i.getSelfTy().(TypeRepr_).resolveTypeAt(path)
}

pragma[nomagic]
private Type resolveTraitSelfType(Trait t, TypePath path) {
  result = TTrait(t) and
  path.isEmpty()
  or
  exists(int i |
    result = TTypeParameter(t.getGenericParamList().getTypeParam(i)) and
    path = typePath(i)
  )
}

pragma[nomagic]
private Type resolveTargetTyped(AstNode n, TypePath path) {
  isTargetTyped(n) and
  (
    exists(LetStmt let |
      let.getPat() = n and
      result = resolveType(let.getInitializer(), path)
    )
    or
    exists(ItemNode i, FunctionItemNode f, SelfParam p, TypePath suffix, Type res |
      n = p and
      (
        res = resolveImplSelfType(i, suffix)
        or
        res = resolveTraitSelfType(i, suffix)
      ) and
      f.getImmediateParent() = i and
      p = f.(Function).getParamList().getSelfParam()
    |
      if p.isRef()
      then
        path.isEmpty() and
        result = TRefType()
        or
        path = typePath(0).append(suffix) and
        result = res
      else (
        path = suffix and
        result = res
      )
    )
  )
}

private module RecordFieldMatchingInput implements MatchingInputSig {
  abstract class Decl extends AstNode {
    abstract TypeParameter getTypeParameter(int i);

    abstract RecordField getField(string name);
  }

  private class StructDecl extends Decl, Struct {
    override TypeParameter getTypeParameter(int i) {
      result.getTypeParam() = this.getGenericParamList().getTypeParam(i)
    }

    override RecordField getField(string name) { result = this.getRecordField(name) }
  }

  private class VariantDecl extends Decl, Variant {
    Enum getEnum() { result.getVariantList().getAVariant() = this }

    override TypeParameter getTypeParameter(int i) {
      result.getTypeParam() = this.getEnum().getGenericParamList().getTypeParam(i)
    }

    override RecordField getField(string name) { result = this.getRecordField(name) }
  }

  class Access extends RecordExpr {
    // RecordExpr getRecordExpr(string name) { this = result.getFieldExpr(name) }
    private TypeRepr_ getTypeArg(int i) {
      result = this.getPath().getPart().getGenericArgList().getTypeArgument(i)
    }

    Type getTypeArgument(int i, TypePath path) { result = this.getTypeArg(i).resolveTypeAt(path) }

    predicate noExplicitTypeArguments() { not exists(this.getTypeArg(_)) }
  }

  predicate target(Access a, Decl target) { target = resolvePath(a.getPath()) }

  class Pos = string;

  Pos getReturnPos() { result = "(return)" }

  private AstNode getExplicitArgument(Access a, Pos pos) { result = a.getFieldExpr(pos).getExpr() }

  private predicate explicitArgumentType(Access a, Pos pos, TypePath path, Type t) {
    t = resolveType(getExplicitArgument(a, pos), path)
  }

  // private predicate implicitThis(Access a, int pos, TypePath path, Type t) {
  //   a instanceof TsExplicitOrdinaryMethodCall and
  //   exists(TsMethodDeclaration md |
  //     md = a.getEnclosingMethodDecl() and
  //     a.getFunction() instanceof TsUnqualifiedMemberAccess and
  //     pos = -1 and
  //     t = resolveThisInMethodDecl(md, path)
  //   )
  // }
  predicate argumentType(Access a, Pos pos, TypePath path, Type t) {
    explicitArgumentType(a, pos, path, t)
    // or
    // implicitThis(a, pos, path, t)
  }

  pragma[nomagic]
  predicate argumentIsTargetTyped(Access a, Pos pos) { isTargetTyped(getExplicitArgument(a, pos)) }

  pragma[nomagic]
  predicate argumentIsNotTargetTyped(Access a, Pos pos) {
    exists(AstNode arg |
      arg = getExplicitArgument(a, pos) and
      not isTargetTyped(arg)
    )
    // or
    // implicitThis(a, pos, _, _)
  }

  predicate parameterType(Decl decl, Pos pos, TypePath path, Type t) {
    exists(TypeRepr_ tp | tp = decl.getField(pos).getTypeRepr() | t = tp.resolveTypeAt(path))
  }

  pragma[nomagic]
  predicate declType(Decl decl, TypePath path, Type t) {
    t = TStruct(decl) and
    path.isEmpty()
    or
    exists(int i |
      t = decl.getTypeParameter(i) and
      path = typePath(i)
    )
  }
}

private module RecordFieldMatching = Matching<RecordFieldMatchingInput>;

private Type resolveRecordExprType(RecordExpr re, TypePath path) {
  result = re.getPath().(Path_).resolveTypeAt(path)
  or
  // result = resolveFunctionReturnType(call.getStaticTarget(), path)
  result = RecordFieldMatching::resolveAccess(re, "(return)", path)
}

// private Type resolveRecordExprType(RecordExpr re, TypePath path) {
//   result = re.getPath().(Path_).resolveTypeAt(path)
// }
private module FunctionMatchingInput implements MatchingInputSig {
  class Pos = int;

  Pos getReturnPos() { result = -2 }

  class Decl extends Function {
    TypeParameter getTypeParameter(int i) {
      result.getTypeParam() = this.getGenericParamList().getTypeParam(i)
    }
  }

  class Access extends CallExprBase {
    private TypeRepr_ getTypeArg(int i) {
      result =
        this.(CallExpr)
            .getFunction()
            .(PathExpr)
            .getPath()
            .getPart()
            .getGenericArgList()
            .getTypeArgument(i)
      or
      result = this.(MethodCallExpr).getGenericArgList().getTypeArgument(i)
    }

    Type getTypeArgument(int i, TypePath path) { result = this.getTypeArg(i).resolveTypeAt(path) }

    predicate noExplicitTypeArguments() { not exists(this.getTypeArg(_)) }
  }

  predicate target(Access a, Decl target) { target = a.getStaticTarget() }

  private AstNode getExplicitArgument(Access a, int pos) {
    exists(int offset, Decl target |
      result = a.getArgList().getArg(pos + offset) and
      target(a, target)
    |
      if target.getParamList().hasSelfParam() and not a instanceof MethodCallExpr
      then offset = 1
      else offset = 0
    )
    or
    // result = a.(CallExpr).getFunction()
    // or
    result = a.(MethodCallExpr).getReceiver() and
    pos = -1
  }

  private predicate explicitArgumentType(Access a, int pos, TypePath path, Type t) {
    t = resolveType(getExplicitArgument(a, pos), path)
  }

  // private predicate implicitThis(Access a, int pos, TypePath path, Type t) {
  //   a instanceof TsExplicitOrdinaryMethodCall and
  //   exists(TsMethodDeclaration md |
  //     md = a.getEnclosingMethodDecl() and
  //     a.getFunction() instanceof TsUnqualifiedMemberAccess and
  //     pos = -1 and
  //     t = resolveThisInMethodDecl(md, path)
  //   )
  // }
  predicate argumentType(Access a, int pos, TypePath path, Type t) {
    explicitArgumentType(a, pos, path, t)
    // or
    // implicitThis(a, pos, path, t)
  }

  pragma[nomagic]
  predicate argumentIsTargetTyped(Access a, int pos) { isTargetTyped(a.getArgList().getArg(pos)) }

  pragma[nomagic]
  predicate argumentIsNotTargetTyped(Access a, int pos) {
    exists(AstNode arg |
      arg = getExplicitArgument(a, pos) and
      not isTargetTyped(arg)
    )
    // or
    // implicitThis(a, pos, _, _)
  }

  predicate parameterType(Decl decl, int pos, TypePath path, Type t) {
    exists(TypeRepr_ tp |
      paramTyped(decl.getParamList().getParam(pos), _, tp)
      or
      selfParamTyped(decl.getParamList().getSelfParam(), tp) and
      pos = -1
    |
      t = tp.resolveTypeAt(path)
    )
    or
    exists(SelfParam self |
      self = decl.getParamList().getSelfParam() and
      pos = -1 and
      t = resolveTargetTyped(self, path)
    )
  }

  pragma[nomagic]
  predicate declType(Decl decl, TypePath path, Type t) {
    t = decl.getRetType().getTypeRepr().(TypeRepr_).resolveTypeAt(path)
  }
}

private module FunctionMatching = Matching<FunctionMatchingInput>;

pragma[nomagic]
private Type resolveFunctionReturnType(Function f, TypePath path) {
  result = f.getRetType().getTypeRepr().(TypeRepr_).resolveTypeAt(path) and
  not result instanceof TypeParameter
}

pragma[nomagic]
private Type resolvePathExprType(PathExpr pe, TypePath path) {
  exists(ItemNode i | i = resolvePath(pe.getPath()) |
    result = resolveFunctionReturnType(i, path)
    or
    exists(Enum e |
      i = e.getVariantList().getAVariant() and
      result = TEnum(e) and
      path.isEmpty()
    )
  )
  or
  result = pe.getPath().(Path_).resolveTypeAt(path) and
  path.isEmpty()
}

pragma[nomagic]
private Type resolveCallExprType(CallExpr ce, TypePath path) {
  result = resolvePathExprType(ce.getFunction(), path)
  or
  result = FunctionMatching::resolveAccess(ce, -2, path)
}

pragma[nomagic]
Function resolveMethodCallExpr(MethodCallExpr mce) {
  exists(Type t, string name |
    t = resolveType(mce.getReceiver()) and
    name = mce.getNameRef().getText() and
    if t = TRefType()
    then
      // for reference types, lookup the method in the type being referenced
      result = resolveType(mce.getReceiver(), "0").getMethod(name)
    else result = t.getMethod(name)
  )
}

pragma[nomagic]
private Type resolveMethodCallExprType(MethodCallExpr mce, TypePath path) {
  exists(Function f |
    f = resolveMethodCallExpr(mce) and
    result = resolveFunctionReturnType(f, path)
  )
  or
  result = FunctionMatching::resolveAccess(mce, -2, path)
}

private module FieldExprMatchingInput implements MatchingInputSig {
  abstract class Decl extends AstNode {
    TypeParameter getTypeParameter(int i) { none() }

    abstract TypeRepr getTypeRepr();
  }

  private class RecordFieldDecl extends Decl instanceof RecordField {
    override TypeRepr getTypeRepr() { result = RecordField.super.getTypeRepr() }
  }

  private class TupleFieldDecl extends Decl instanceof TupleField {
    override TypeRepr getTypeRepr() { result = TupleField.super.getTypeRepr() }
  }

  class Access extends FieldExpr {
    Type getTypeArgument(int i, TypePath path) { none() }

    predicate noExplicitTypeArguments() { any() }
  }

  predicate target(Access a, Decl target) {
    exists(Type t, Type lookupType, string name |
      t = resolveType(a.getExpr()) and
      name = a.getNameRef().getText() and
      if t = TRefType()
      then
        // for reference types, lookup the field in the type being referenced
        lookupType = resolveType(a.getExpr(), "0")
      else lookupType = t
    |
      target = lookupType.getRecordField(name)
      or
      target = lookupType.getTupleField(name.toInt())
    )
  }

  class Pos = int;

  Pos getReturnPos() { result = -2 }

  private AstNode getExplicitArgument(Access a, Pos pos) { result = a.getExpr() and pos = -1 }

  private predicate explicitArgumentType(Access a, Pos pos, TypePath path, Type t) {
    t = resolveType(getExplicitArgument(a, pos), path)
  }

  predicate argumentType(Access a, Pos pos, TypePath path, Type t) {
    explicitArgumentType(a, pos, path, t)
    // or
    // implicitThis(a, pos, path, t)
  }

  pragma[nomagic]
  predicate argumentIsTargetTyped(Access a, Pos pos) { isTargetTyped(getExplicitArgument(a, pos)) }

  pragma[nomagic]
  predicate argumentIsNotTargetTyped(Access a, Pos pos) {
    exists(AstNode arg |
      arg = getExplicitArgument(a, pos) and
      not isTargetTyped(arg)
    )
    // or
    // implicitThis(a, pos, _, _)
  }

  predicate parameterType(Decl decl, Pos pos, TypePath path, Type t) {
    pos = -1 and
    exists(Struct s | s.getRecordField(_) = decl or s.getTupleField(_) = decl |
      t = TStruct(s) and
      path.isEmpty()
      or
      exists(int i |
        t = TTypeParameter(s.getGenericParamList().getTypeParam(i)) and
        path = typePath(i)
      )
    )
  }

  pragma[nomagic]
  predicate declType(Decl decl, TypePath path, Type t) {
    t = decl.getTypeRepr().(TypeRepr_).resolveTypeAt(path)
  }
}

private module FieldExprMatching = Matching<FieldExprMatchingInput>;

private Type resolveFieldExprType(FieldExpr fe, TypePath path) {
  result = resolveFieldExprType0(fe, path)
  or
  // result = resolveFunctionReturnType(call.getStaticTarget(), path)
  result = FieldExprMatching::resolveAccess(fe, -2, path)
}

pragma[nomagic]
RecordField resolveRecordFieldExpr(FieldExpr fe) {
  exists(Type t, string name |
    t = resolveType(fe.getExpr()) and
    name = fe.getNameRef().getText() and
    if t = TRefType()
    then
      // for reference types, lookup the method in the type being referenced
      result = resolveType(fe.getExpr(), "0").getRecordField(name)
    else result = t.getRecordField(name)
  )
}

pragma[nomagic]
TupleField resolveTupleFieldExpr(FieldExpr fe) {
  exists(Type t, int i |
    t = resolveType(fe.getExpr()) and
    i = fe.getNameRef().getText().toInt() and
    if t = TRefType()
    then
      // for reference types, lookup the method in the type being referenced
      result = resolveType(fe.getExpr(), "0").getTupleField(i)
    else result = t.getTupleField(i)
  )
}

pragma[nomagic]
private Type resolveFieldExprType0(FieldExpr fe, TypePath path) {
  exists(RecordField f |
    f = resolveRecordFieldExpr(fe) and
    result = f.getTypeRepr().(TypeRepr_).resolveTypeAt(path) and
    not result instanceof TypeParameter
  )
  or
  exists(TupleField f |
    f = resolveTupleFieldExpr(fe) and
    result = f.getTypeRepr().(TypeRepr_).resolveTypeAt(path) and
    not result instanceof TypeParameter
  )
}

pragma[nomagic]
private Type resolveRefExprType(RefExpr re, TypePath path) {
  exists(re) and
  path.isEmpty() and
  result = TRefType()
  or
  exists(TypePath suffix |
    result = resolveType(re.getExpr(), suffix) and
    path = typePath(0).append(suffix)
  )
}

Type resolveType(AstNode n, TypePath path) {
  result = resolveVariableType(n, path)
  or
  result = resolveTargetTyped(n, path)
  or
  result = resolveRecordExprType(n, path)
  or
  result = resolvePathExprType(n, path)
  or
  result = resolveCallExprType(n, path)
  or
  result = resolveMethodCallExprType(n, path)
  or
  result = resolveFieldExprType(n, path)
  or
  result = resolveRefExprType(n, path)
}

Type resolveType(AstNode n) { result = resolveType(n, "") }
