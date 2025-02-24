/** Provides functionality for inferring types. */

private import rust
private import PathResolution

private int getTypeParameterRank(TypeParameter tp) {
  tp =
    rank[result + 1](TypeParameter tp0, int kind, string filepath, int startline, int startcolumn,
      int endline, int endcolumn |
      tp0.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) and
      (
        tp0 instanceof RefTypeParameter and
        kind = 0
        or
        tp0 instanceof TypeParamTypeParameter and
        kind = 1
      )
    |
      tp0 order by kind, filepath, startline, startcolumn, endline, endcolumn
    )
}

/** Gets the singleton type path `i`. */
bindingset[tp]
private TypePath typePath(TypeParameter tp) { result = getTypeParameterRank(tp).toString() }

bindingset[s]
private predicate decodeTypePathComponent(string s, TypeParameter tp) {
  getTypeParameterRank(tp) = s.toInt()
}

final private class String = string;

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
class TypePath extends String {
  bindingset[this]
  TypePath() { exists(this) }

  bindingset[this]
  private TypeParameter getTypeParameter(int i) {
    exists(string s |
      s = this.splitAt(".", i) and
      decodeTypePathComponent(s, result)
    )
  }

  bindingset[this]
  string toString() {
    // result = super.toString()
    result =
      concat(int i, TypeParameter tp |
        tp = this.getTypeParameter(i)
      |
        tp.getPosition().toString(), "." order by i
        // tp.toString(), "." order by i
      )
  }

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
  predicate endsWith(TypePath prefix, TypeParameter i) {
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
  predicate startsWith(TypeParameter i, TypePath suffix) {
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
  TImpl(Impl i) or
  TArrayType() or // todo: add size?
  TRefType() or // todo: add mut, lifetime?
  TTypeParamTypeParameter(TypeParam t) or
  TRefTypeParameter()

/** A type without type arguments. */
abstract class Type extends TType {
  pragma[nomagic]
  abstract Function getMethod(string name);

  pragma[nomagic]
  abstract RecordField getRecordField(string name);

  pragma[nomagic]
  abstract TupleField getTupleField(int i);

  abstract TypeParameter getTypeParameter(int i);

  abstract TypeReprOrPath getABaseType();

  abstract string toString();

  abstract Location getLocation();
}

class StructType extends Type, TStruct {
  private Struct struct;

  StructType() { this = TStruct(struct) }

  override Function getMethod(string name) { result = struct.(ItemNode).getASuccessor(name) }

  override RecordField getRecordField(string name) { result = struct.getRecordField(name) }

  override TupleField getTupleField(int i) { result = struct.getTupleField(i) }

  override TypeParameter getTypeParameter(int i) {
    result = TTypeParamTypeParameter(struct.getGenericParamList().getTypeParam(i))
  }

  override TypeReprOrPath getABaseType() {
    exists(ImplItemNode i |
      struct = i.resolveSelfTy() and
      result = i
      // result = i.(Impl).getTrait()
    )
  }

  override string toString() { result = struct.toString() }

  override Location getLocation() { result = struct.getLocation() }
}

class EnumType extends Type, TEnum {
  private Enum enum;

  EnumType() { this = TEnum(enum) }

  override Function getMethod(string name) { result = enum.(ItemNode).getASuccessor(name) }

  override RecordField getRecordField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeParameter getTypeParameter(int i) {
    result = TTypeParamTypeParameter(enum.getGenericParamList().getTypeParam(i))
  }

  override TypeReprOrPath getABaseType() {
    exists(ImplItemNode i |
      enum = i.resolveSelfTy() and
      result = i
    )
  }

  override string toString() { result = enum.toString() }

  override Location getLocation() { result = enum.getLocation() }
}

class TraitType extends Type, TTrait {
  private Trait trait;

  TraitType() { this = TTrait(trait) }

  override Function getMethod(string name) { result = trait.(ItemNode).getASuccessor(name) }

  override RecordField getRecordField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeParameter getTypeParameter(int i) {
    result = TTypeParamTypeParameter(trait.getGenericParamList().getTypeParam(i))
  }

  pragma[nomagic]
  private TypeRepr_ getABound() {
    result = trait.(Trait).getTypeBoundList().getABound().getTypeRepr()
  }

  override TypeReprOrPath getABaseType() { result = this.getABound() }

  override string toString() { result = trait.toString() }

  override Location getLocation() { result = trait.getLocation() }
}

class ImplType extends Type, TImpl {
  private Impl impl;

  ImplType() { this = TImpl(impl) }

  override Function getMethod(string name) { result = impl.(ItemNode).getASuccessor(name) }

  override RecordField getRecordField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeParameter getTypeParameter(int i) {
    result = TTypeParamTypeParameter(impl.getGenericParamList().getTypeParam(i))
  }

  override TypeReprOrPath getABaseType() { result = impl.getTrait() }

  override string toString() { result = impl.toString() }

  override Location getLocation() { result = impl.getLocation() }
}

class ArrayType extends Type, TArrayType {
  ArrayType() { this = TArrayType() }

  override Function getMethod(string name) { none() }

  override RecordField getRecordField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeParameter getTypeParameter(int i) {
    none() // todo
  }

  override TypeReprOrPath getABaseType() { none() }

  override string toString() { result = "[]" }

  override Location getLocation() { result instanceof EmptyLocation }
}

class RefType extends Type, TRefType {
  RefType() { this = TRefType() }

  override Function getMethod(string name) { none() }

  override RecordField getRecordField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeParameter getTypeParameter(int i) {
    result = TRefTypeParameter() and
    i = 0
  }

  override TypeReprOrPath getABaseType() { none() }

  override string toString() { result = "&" }

  override Location getLocation() { result instanceof EmptyLocation }
}

abstract class TypeParameter extends Type {
  abstract int getPosition();

  override TypeReprOrPath getABaseType() { none() }

  override RecordField getRecordField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeParameter getTypeParameter(int i) { none() }
}

private class TypeParamTypeParameter extends TypeParameter, TTypeParamTypeParameter {
  private TypeParam typeParam;

  TypeParamTypeParameter() { this = TTypeParamTypeParameter(typeParam) }

  TypeParam getTypeParam() { result = typeParam }

  override int getPosition() { typeParam = any(GenericParamList l).getTypeParam(result) }

  override Function getMethod(string name) { result = typeParam.(ItemNode).getASuccessor(name) }

  override string toString() { result = typeParam.toString() }

  override Location getLocation() { result = typeParam.getLocation() }
}

private class RefTypeParameter extends TypeParameter, TRefTypeParameter {
  override int getPosition() { result = 0 }

  override Function getMethod(string name) { none() }

  override string toString() { result = "&T" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/** A `TypeRepr` or a `Path`. */
abstract private class TypeReprOrPath extends AstNode {
  /** Gets the `i`th type argument, if any. */
  abstract TypeReprOrPath getTypeReprArgument(int i);

  /** Gets the type that this node resolves to. */
  abstract Type resolveType();

  /** Gets the node at `path`. */
  pragma[nomagic]
  private TypeReprOrPath getTypeReprAt(TypePath path) {
    path.isEmpty() and
    result = this
    or
    exists(int i, TypeParameter tp, TypeReprOrPath arg, TypePath suffix |
      arg = this.getTypeReprArgument(pragma[only_bind_into](i)) and
      result = arg.getTypeReprAt(suffix) and
      path = typePath(tp).append(suffix) and
      tp = this.resolveType().getTypeParameter(pragma[only_bind_into](i))
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
  override TypeReprOrPath getTypeReprArgument(int i) {
    result = this.getPart().getGenericArgList().getTypeArgument(i)
    or
    // todo
    isUnqualifiedSelfPath(this) and
    exists(ItemNode node | node = unqualifiedPathLookup(this) |
      result = node.(ImplItemNode).getSelfPath().getPart().getGenericArgList().getTypeArgument(i)
      or
      result = node.(Trait).getGenericParamList().getTypeParam(i)
    )
  }

  pragma[nomagic]
  predicate isImplTypeParam(ImplItemNode impl, Path_ selfPath, int i) {
    selfPath = impl.getSelfPath() and
    this = selfPath.getPart().getGenericArgList().getTypeArgument(i).(PathTypeRepr).getPath() and
    resolvePath(this) instanceof TypeParam
  }

  override Type resolveType() {
    exists(ItemNode i | i = resolvePath(this) |
      result = TStruct(i)
      or
      result = TEnum(i)
      or
      result = TTrait(i)
      or
      result = TTypeParamTypeParameter(i) //and
      or
      // not this.isImplTypeParam(_, _, _) // todo: no effect?
      result = i.(TypeAlias).getTypeRepr().(TypeRepr_).resolveType()
      // or
      // exists(ImplItemNode impl, int j, Struct selfType |
      //   i = impl.(Impl).getGenericParamList().getTypeParam(_) and
      //   selfType = impl.resolveSelfTy() and
      //   this =
      //     impl.getSelfPath()
      //         .getPart()
      //         .getGenericArgList()
      //         .getTypeArgument(j)
      //         .(PathTypeRepr)
      //         .getPath() and
      //   result = TTypeParamTypeParameter(selfType.getGenericParamList().getTypeParam(j))
      // )
    )
    // or
    // exists(ImplItemNode impl, Path_ selfPath | selfPath = impl.getSelfPath() |
    //   result = TImpl(impl) and
    //   this = selfPath
    //   or
    //   exists(int i |
    //     this.isImplTypeParam(impl, selfPath, i) and
    //     result = selfPath.resolveType().getTypeParameter(i)
    //     // result =
    //     //   TTypeParamTypeParameter(resolvePath(selfPath)
    //     //         .(Struct)
    //     //         .getGenericParamList()
    //     //         .getTypeParam(i))
    //   )
    // )
    // or
    // exists(ImplItemNode i |
    //   result = TImpl(i) and
    //   this = i.getSelfPath()
    // )
  }
}

private class TypeParam_ extends TypeReprOrPath, TypeParam {
  override TypeRepr_ getTypeReprArgument(int i) { none() }

  override Type resolveType() { result = TTypeParamTypeParameter(this) }
}

private class Impl_ extends TypeReprOrPath, Impl {
  override TypeRepr_ getTypeReprArgument(int i) {
    none()
    // result = this.(ImplItemNode).getSelfPath().getPart().getGenericArgList().getTypeArgument(i)
  }

  override Type resolveType() { result = TImpl(this) }

  override Type resolveTypeAt(TypePath path) {
    result = TImpl(this) and
    path.isEmpty()
    or
    exists(Path_ selfPath, Path_ p | selfPath = this.(ImplItemNode).getSelfPath() |
      exists(int i |
        p.isImplTypeParam(this, selfPath, i) and
        result = selfPath.resolveType().getTypeParameter(i) and
        path = typePath(p.resolveType())
        // result =
        //   TTypeParamTypeParameter(resolvePath(selfPath)
        //         .(Struct)
        //         .getGenericParamList()
        //         .getTypeParam(i))
      )
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
    Type sub, TypeReprOrPath base, TypePath path, TypeParameter tp
  ) {
    exists(TypeReprOrPath immediateBase, TypePath pathToTypeParam |
      tp = sub.getTypeParameter(_) and // todo?
      immediateBase = sub.getABaseType() and
      tp = immediateBase.resolveTypeAt(pathToTypeParam)
    |
      // immediate base class
      base = immediateBase and
      path = pathToTypeParam
      or
      // transitive base class
      exists(TypePath prefix, TypePath suffix, TypeParameter i |
        baseTypeMentionHasTypeParameterAt(immediateBase.resolveType(), base, prefix, i) and
        pathToTypeParam.startsWith(i, suffix) and
        path = prefix.append(suffix)
      )
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
    Type sub, TypeReprOrPath base, TypePath path, Type t
  ) {
    not t instanceof TypeParameter and
    exists(TypeReprOrPath immediateBase |
      pragma[only_bind_into](immediateBase) = pragma[only_bind_into](sub).getABaseType()
    |
      base = immediateBase and
      t = base.resolveTypeAt(path)
      or
      baseTypeMentionHasNonTypeParameterAt(immediateBase.resolveType(), base, path, t)
      or
      exists(TypePath path0, TypePath prefix, TypePath suffix, TypeParameter i |
        baseTypeMentionHasTypeParameterAt(immediateBase.resolveType(), base, prefix, i) and
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
    private Type resolveTypeAt(Input::Node n, TypeParameter i, TypePath suffix) {
      exists(TypePath path0, TypeParameter tp |
        result = Input::resolveType(n, path0) and
        i = tp and // .getPosition() and
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
    predicate hasBaseType(Input::Node n, TypeReprOrPath base, TypePath path, Type t) {
      exists(Type sub | sub = resolveRootType(n) |
        baseTypeMentionHasNonTypeParameterAt(sub, base, path, t)
        or
        exists(TypePath prefix, TypePath suffix, TypeParameter i |
          baseTypeMentionHasTypeParameterAt(sub, base, prefix, i) and
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
  }

  bindingset[this]
  class ArgPos {
    bindingset[this]
    string toString();
  }

  bindingset[this]
  class ParamPos {
    bindingset[this]
    string toString();
  }

  bindingset[apos]
  bindingset[ppos]
  predicate paramArgPosMatch(ParamPos ppos, ArgPos apos);

  predicate target(Access a, Decl target);

  AstNode getArg(Access a, ArgPos pos);

  predicate parameterType(Decl decl, ParamPos pos, TypePath path, Type t);
}

private module Matching<MatchingInputSig Input> {
  private import Input

  pragma[nomagic]
  predicate argumentType(Access a, ArgPos pos, TypePath path, Type t) {
    exists(AstNode arg |
      arg = getArg(a, pos) and
      t = resolveType(arg, path)
    )
  }

  pragma[nomagic]
  private predicate argumentTypeAt(Access a, ArgPos pos, Decl target, TypePath path, Type t) {
    target(a, target) and
    argumentType(a, pos, path, t)
  }

  pragma[nomagic]
  private predicate argumentTypeMatchAt(
    Access a, ArgPos apos, Decl target, ParamPos ppos, TypePath path, TypePath end
  ) {
    exists(Type match |
      argumentTypeAt(a, apos, target, path, match) and
      path.endsWith(end, _) and
      parameterType(target, ppos, path, match) and
      paramArgPosMatch(ppos, apos)
    )
  }

  bindingset[a, target, tp]
  pragma[inline_late]
  private predicate noExplicitTypeArgument(Access a, Decl target, TypeParameter tp) {
    not exists(int i |
      exists(a.getTypeArgument(pragma[only_bind_into](i), _)) and
      tp = target.getTypeParameter(pragma[only_bind_into](i))
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
    Access a, ArgPos apos, Decl target, ParamPos ppos, TypePath path, Type t, TypeParameter tp,
    TypePath toMatch
  ) {
    exists(TypePath pathToTypeParam |
      argumentTypeAt(a, apos, target, pathToTypeParam.append(path), t) and
      parameterType(target, ppos, pathToTypeParam, tp) and
      noExplicitTypeArgument(a, target, tp) and
      paramArgPosMatch(ppos, apos) and
      if pathToTypeParam.isEmpty()
      then toMatch.isEmpty()
      else (
        pathToTypeParam.endsWith(toMatch, _) and
        exists(Type match |
          argumentTypeAt(a, apos, target, "", match) and
          parameterType(target, ppos, "", match)
        )
      )
    )
    or
    exists(TypePath toMatch0 |
      typeMatch(a, apos, target, ppos, path, t, tp, toMatch0) and
      argumentTypeMatchAt(a, apos, target, ppos, toMatch0, toMatch)
    )
  }

  predicate declType(Decl decl, ParamPos at, TypePath path, Type t) {
    parameterType(decl, at, path, t)
  }

  private module BaseTypeAtInput implements BaseTypeAtInputSig {
    private newtype TNode =
      MkNode(Access a, ArgPos pos) {
        exists(Decl target |
          argumentTypeAt(a, pos, target, _, _) and
          declType(target, _, _, any(TypeParameter tp))
        )
      }

    additional Node mkNode(Access a, ArgPos pos) { result = MkNode(a, pos) }

    class Node extends MkNode {
      Access getAccess() { this = MkNode(result, _) }

      ArgPos getPos() { this = MkNode(_, result) }

      string toString() { result = this.getAccess().toString() + ", " + this.getPos().toString() }

      Location getLocation() { result = this.getAccess().getLocation() }
    }

    Type resolveType(Node n, TypePath path) {
      exists(Access a, ArgPos pos |
        n = MkNode(a, pos) and
        argumentType(a, pos, path, result)
      )
    }
  }

  pragma[nomagic]
  private predicate argumentBaseTypeAt(
    Access a, ArgPos pos, Decl target, Type base, TypePath path, Type t
  ) {
    exists(TypeReprOrPath tm |
      target(a, target) and
      NodeHasBaseTypeAt<BaseTypeAtInput>::hasBaseType(BaseTypeAtInput::mkNode(a, pos), tm, path, t) and
      base = tm.resolveType()
    )
  }

  pragma[nomagic]
  private predicate parameterBaseType(Decl decl, ParamPos pos, Type base, TypePath path, Type t) {
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
    Access a, ArgPos apos, Decl target, ParamPos ppos, Type base, TypePath path, Type t,
    TypeParameter tp, TypePath toMatch
  ) {
    exists(TypePath pathToTypeParam |
      argumentBaseTypeAt(a, apos, target, base, pathToTypeParam.append(path), t) and
      parameterBaseType(target, ppos, base, pathToTypeParam, tp) and
      noExplicitTypeArgument(a, target, tp) and
      paramArgPosMatch(ppos, apos) and
      // do not allow `pathToTypeParam` to be empty in this case, as we will match
      // against the actual type and not one of the base types
      pathToTypeParam.endsWith(toMatch, _)
    )
    or
    exists(TypePath toMatch0, Type match |
      baseTypeMatch(a, apos, target, ppos, base, path, t, tp, toMatch0) and
      toMatch0.endsWith(toMatch, _) and
      argumentBaseTypeAt(a, apos, target, base, toMatch0, match) and
      parameterBaseType(target, ppos, base, toMatch0, match)
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
  private predicate implicitTypeMatch(
    Access a, Decl target, TypePath path, Type t, TypeParameter tp, boolean isBase
  ) {
    typeMatch(a, _, target, _, path, t, tp, "") and
    isBase = false
    or
    baseTypeMatch(a, _, target, _, _, path, t, tp, "") and
    isBase = true
  }

  pragma[inline]
  private predicate typeMatch(
    Access a, Decl target, TypePath path, Type t, TypeParameter tp, boolean isBase
  ) {
    explicitTypeMatch(a, target, path, t, tp) and
    isBase = false
    or
    implicitTypeMatch(a, target, path, t, tp, isBase)
  }

  pragma[nomagic]
  private Type resolveAccess(Access a, ArgPos apos, ParamPos ppos, TypePath path, boolean isBase) {
    paramArgPosMatch(ppos, apos) and
    (
      exists(Decl target, TypePath prefix, TypeParameter tp, TypePath suffix |
        declType(target, pragma[only_bind_into](ppos), prefix, tp) and
        typeMatch(a, target, suffix, result, tp, isBase) and
        path = prefix.append(suffix)
      )
      or
      exists(Decl target |
        declType(target, pragma[only_bind_into](ppos), path, result) and
        target(a, target) and
        isBase = false and
        not result instanceof TypeParameter
      )
    )
  }

  pragma[nomagic]
  Type resolveArgType(AstNode arg, ParamPos ppos, TypePath path, boolean isBase) {
    exists(Access a, ArgPos apos |
      arg = getArg(a, apos) and
      result = resolveAccess(a, apos, ppos, path, isBase)
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
  result = i.getSelfTy().(TypeRepr_).resolveTypeAt(path) and
  not result instanceof ImplType
}

pragma[nomagic]
private Type resolveTraitSelfType(Trait t, TypePath path) {
  result = TTrait(t) and
  path.isEmpty()
  or
  exists(TypeParameter tp |
    tp = TTypeParamTypeParameter(t.getGenericParamList().getTypeParam(_)) and
    path = typePath(tp) and
    result = tp
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
        path = typePath(TRefTypeParameter()).append(suffix) and
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
    override TypeParamTypeParameter getTypeParameter(int i) {
      result.getTypeParam() = this.getGenericParamList().getTypeParam(i)
    }

    override RecordField getField(string name) { result = this.getRecordField(name) }
  }

  private class VariantDecl extends Decl, Variant {
    Enum getEnum() { result.getVariantList().getAVariant() = this }

    override TypeParamTypeParameter getTypeParameter(int i) {
      result.getTypeParam() = this.getEnum().getGenericParamList().getTypeParam(i)
    }

    override RecordField getField(string name) { result = this.getRecordField(name) }
  }

  class Access extends RecordExpr {
    private TypeRepr_ getTypeArg(int i) {
      result = this.getPath().getPart().getGenericArgList().getTypeArgument(i)
    }

    Type getTypeArgument(int i, TypePath path) { result = this.getTypeArg(i).resolveTypeAt(path) }
  }

  predicate target(Access a, Decl target) { target = resolvePath(a.getPath()) }

  private newtype TPos =
    TFieldPos(string name) { exists(any(Decl decl).getField(name)) } or
    TDeclPos()

  class ArgPos extends TPos {
    string asFieldPos() { this = TFieldPos(result) }

    string toString() {
      result = this.asFieldPos()
      or
      this = TDeclPos() and
      result = "(decl)"
    }
  }

  class ParamPos = ArgPos;

  predicate paramArgPosMatch(ParamPos ppos, ArgPos apos) { apos = ppos }

  AstNode getArg(Access a, ArgPos pos) {
    result = a.getFieldExpr(pos.asFieldPos()).getExpr()
    or
    result = a and
    pos = TDeclPos()
  }

  predicate parameterType(Decl decl, ParamPos pos, TypePath path, Type t) {
    exists(TypeRepr_ tp | tp = decl.getField(pos.asFieldPos()).getTypeRepr() |
      t = tp.resolveTypeAt(path)
    )
    or
    pos = TDeclPos() and
    (
      t = TStruct(decl) and
      path.isEmpty()
      or
      t = TEnum(decl.(VariantDecl).getEnum()) and
      path.isEmpty()
      or
      exists(int i |
        t = decl.getTypeParameter(i) and
        path = typePath(t)
      )
    )
  }
}

private module RecordFieldMatching = Matching<RecordFieldMatchingInput>;

private Type resolveRecordExprType(AstNode n, TypePath path) {
  result = RecordFieldMatching::resolveArgType(n, _, path, _)
}

pragma[nomagic]
private Type resolvePathExprType(PathExpr pe, TypePath path) {
  not exists(CallExpr ce | pe = ce.getFunction()) and
  path.isEmpty() and
  exists(ItemNode i | i = resolvePath(pe.getPath()) |
    result = TEnum(i.(Variant).getEnum())
    or
    result = TStruct(i)
  )
}

private module FunctionMatchingInput implements MatchingInputSig {
  private import codeql.util.Boolean

  private predicate positionalParamPos(ParamList pl, Param p, int pos, boolean inMethod) {
    p = pl.getParam(pos) and
    if pl.hasSelfParam() then inMethod = true else inMethod = false
  }

  private newtype TParamPos =
    TSelfParamPos() or
    TPositionalParamPos(int pos, Boolean inMethod) { positionalParamPos(_, _, pos, inMethod) } or
    TReturnParamPos()

  class ParamPos extends TParamPos {
    predicate isSelf() { this = TSelfParamPos() }

    predicate isReturn() { this = TReturnParamPos() }

    string toString() {
      this = TSelfParamPos() and
      result = "self"
      or
      this = TReturnParamPos() and
      result = "(return)"
      or
      exists(int pos, Boolean inMethod |
        this = TPositionalParamPos(pos, inMethod) and
        result = pos.toString()
      )
    }
  }

  private predicate argPos(CallExprBase call, Expr e, int pos, boolean inMethod) {
    exists(ArgList al |
      e = al.getArg(pos) and
      call.getArgList() = al and
      if call instanceof MethodCallExpr then inMethod = true else inMethod = false
    )
  }

  private newtype TArgPos =
    TSelfArgPos() or
    TPositionalArgPos(int pos, Boolean inMethod) { argPos(_, _, pos, inMethod) } or
    TReturnArgPos()

  class ArgPos extends TArgPos {
    string toString() {
      this = TSelfArgPos() and
      result = "self"
      or
      exists(int pos, Boolean inMethod |
        this = TPositionalArgPos(pos, inMethod) and
        result = pos.toString()
      )
      or
      this = TReturnArgPos() and
      result = "(return)"
    }
  }

  predicate paramArgPosMatch(ParamPos ppos, ArgPos apos) {
    ppos = TSelfParamPos() and
    (
      apos = TSelfArgPos()
      or
      apos = TPositionalArgPos(0, false)
    )
    or
    exists(int pos |
      ppos = TPositionalParamPos(pos, false) and
      apos = TPositionalArgPos(pos, false)
    )
    or
    exists(int pos | ppos = TPositionalParamPos(pos, true) |
      apos = TPositionalArgPos(pos, true)
      or
      apos = TPositionalArgPos(pos + 1, false)
    )
    or
    ppos = TReturnParamPos() and apos = TReturnArgPos()
  }

  abstract class Decl extends AstNode {
    abstract TypeParameter getTypeParameter(int i);

    abstract Type getParameterType(ParamPos pos, TypePath path);

    abstract Type getReturnType(TypePath path);
  }

  private class StructDecl extends Decl, Struct {
    override TypeParamTypeParameter getTypeParameter(int i) {
      result.getTypeParam() = this.getGenericParamList().getTypeParam(i)
    }

    override Type getParameterType(ParamPos pos, TypePath path) {
      exists(int p |
        result = this.getTupleField(p).getTypeRepr().(TypeRepr_).resolveTypeAt(path) and
        pos = TPositionalParamPos(p, false)
      )
    }

    override Type getReturnType(TypePath path) {
      result = TStruct(this) and
      path.isEmpty()
      or
      exists(int i |
        result = TTypeParamTypeParameter(this.getGenericParamList().getTypeParam(i)) and
        path = typePath(result)
      )
    }
  }

  private class VariantDecl extends Decl, Variant {
    Enum getEnum() { result.getVariantList().getAVariant() = this }

    override TypeParamTypeParameter getTypeParameter(int i) {
      result.getTypeParam() = this.getEnum().getGenericParamList().getTypeParam(i)
    }

    override Type getParameterType(ParamPos pos, TypePath path) {
      exists(int p |
        result = this.getTupleField(p).getTypeRepr().(TypeRepr_).resolveTypeAt(path) and
        pos = TPositionalParamPos(p, false)
      )
    }

    override Type getReturnType(TypePath path) {
      exists(Enum enum | enum = this.getEnum() |
        result = TEnum(enum) and
        path.isEmpty()
        or
        exists(int i |
          result = TTypeParamTypeParameter(enum.getGenericParamList().getTypeParam(i)) and
          path = typePath(result)
        )
      )
    }
  }

  private class FunctionDecl extends Decl, Function {
    override TypeParamTypeParameter getTypeParameter(int i) {
      result.getTypeParam() = this.getGenericParamList().getTypeParam(i)
    }

    override Type getParameterType(ParamPos pos, TypePath path) {
      exists(TypeRepr_ tp, Param p, int i, boolean inMethod |
        positionalParamPos(this.getParamList(), p, i, inMethod) and
        pos = TPositionalParamPos(i, inMethod) and
        paramTyped(p, _, tp) and
        result = tp.resolveTypeAt(path)
      )
      or
      exists(SelfParam self |
        self = this.getParamList().getSelfParam() and
        pos = TSelfParamPos()
      |
        result = resolveTargetTyped(self, path)
        or
        exists(TypeRepr_ tp |
          selfParamTyped(this.getParamList().getSelfParam(), tp) and
          result = tp.resolveTypeAt(path)
        )
      )
    }

    override Type getReturnType(TypePath path) {
      result = this.getRetType().getTypeRepr().(TypeRepr_).resolveTypeAt(path)
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
  }

  predicate target(Access a, Decl target) {
    target = a.getStaticTarget()
    or
    target = a.(CallExpr).getStruct()
    or
    target = a.(CallExpr).getVariant()
  }

  AstNode getArg(Access a, ArgPos pos) {
    exists(int p, boolean inMethod |
      argPos(a, result, p, inMethod) and
      pos = TPositionalArgPos(p, inMethod)
    )
    or
    result = a.(MethodCallExpr).getReceiver() and
    pos = TSelfArgPos()
    or
    result = a and
    pos = TReturnArgPos()
  }

  predicate parameterType(Decl decl, ParamPos pos, TypePath path, Type t) {
    t = decl.getParameterType(pos, path)
    or
    pos = TReturnParamPos() and
    t = decl.getReturnType(path)
  }
}

private module FunctionMatching = Matching<FunctionMatchingInput>;

pragma[nomagic]
private Type resolveCallExprBaseType(AstNode n, TypePath path) {
  exists(FunctionMatchingInput::ParamPos ppos, boolean isBase |
    result = FunctionMatching::resolveArgType(n, ppos, path, isBase)
  )
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
  }

  predicate target(Access a, Decl target) {
    target = resolveRecordFieldExpr(a)
    or
    target = resolveTupleFieldExpr(a)
  }

  private newtype TParamPos =
    TSelfParamPos() or
    TReturnPos()

  class ParamPos extends TParamPos {
    predicate isSelf() { this = TSelfParamPos() }

    predicate isReturn() { this = TReturnPos() }

    string toString() {
      this = TSelfParamPos() and
      result = "self"
      or
      this = TReturnPos() and
      result = "(return)"
    }
  }

  class ArgPos = ParamPos;

  predicate paramArgPosMatch(ParamPos ppos, ArgPos apos) { apos = ppos }

  AstNode getArg(Access a, ArgPos pos) {
    result = a.getExpr() and pos = TSelfParamPos()
    or
    result = a and
    pos = TReturnPos()
  }

  predicate parameterType(Decl decl, ParamPos pos, TypePath path, Type t) {
    pos = TSelfParamPos() and
    exists(Struct s | s.getRecordField(_) = decl or s.getTupleField(_) = decl |
      t = TStruct(s) and
      path.isEmpty()
      or
      exists(int i |
        t = TTypeParamTypeParameter(s.getGenericParamList().getTypeParam(i)) and
        path = typePath(t)
      )
    )
    or
    pos = TReturnPos() and
    t = decl.getTypeRepr().(TypeRepr_).resolveTypeAt(path)
  }
}

private module FieldExprMatching = Matching<FieldExprMatchingInput>;

private Type resolveFieldExprType(AstNode n, TypePath path) {
  exists(FieldExprMatchingInput::ArgPos apos |
    result = FieldExprMatching::resolveArgType(n, apos, path, _) and
    apos.isReturn()
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
    path = typePath(TRefTypeParameter()).append(suffix)
  )
}

cached
private module Cached {
  pragma[inline]
  private Type getLookupType(AstNode n) {
    exists(Type t |
      t = resolveType(n) and
      if t = TRefType()
      then
        // for reference types, lookup members in the type being referenced
        result = resolveType(n, "0")
      else result = t
    )
  }

  cached
  Function resolveMethodCallExpr(MethodCallExpr mce) {
    exists(Type t, string name |
      t = getLookupType(mce.getReceiver()) and
      name = mce.getNameRef().getText() and
      result = t.getMethod(name)
    )
  }

  cached
  RecordField resolveRecordFieldExpr(FieldExpr fe) {
    exists(Type t, string name |
      t = getLookupType(fe.getExpr()) and
      name = fe.getNameRef().getText() and
      result = t.getRecordField(name)
    )
  }

  cached
  TupleField resolveTupleFieldExpr(FieldExpr fe) {
    exists(Type t, int i |
      t = getLookupType(fe.getExpr()) and
      i = fe.getNameRef().getText().toInt() and
      result = t.getTupleField(i)
    )
  }

  cached
  Type resolveType(AstNode n, TypePath path) {
    result = resolveVariableType(n, path)
    or
    result = resolveTargetTyped(n, path)
    or
    result = resolveRecordExprType(n, path)
    or
    result = resolvePathExprType(n, path)
    or
    result = resolveCallExprBaseType(n, path)
    or
    result = resolveFieldExprType(n, path)
    or
    result = resolveRefExprType(n, path)
  }
}

import Cached

Type resolveType(AstNode n) { result = resolveType(n, "") }
