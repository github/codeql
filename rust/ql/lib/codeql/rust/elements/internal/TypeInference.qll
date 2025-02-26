/** Provides functionality for inferring types. */

private import rust
private import PathResolution
private import TypeInferenceShared

/** Provides classes representing types without type arguments. */
private module Types {
  /** A type without type arguments. */
  abstract class Type extends TType {
    /** Gets the method `name` belonging to this type, if any. */
    pragma[nomagic]
    abstract Function getMethod(string name);

    /** Gets the record field `name` belonging to this type, if any. */
    pragma[nomagic]
    abstract RecordField getRecordField(string name);

    /** Gets the tuple field `i` belonging to this type, if any. */
    pragma[nomagic]
    abstract TupleField getTupleField(int i);

    /** Gets the `i`th type parameter of this type. */
    abstract TypeParameter getTypeParameter(int i);

    /** Gets a type parameter of this type. */
    final TypeParameter getATypeParameter() { result = this.getTypeParameter(_) }

    /**
     * Gets an AST node that mentions a base type of this type, if any.
     *
     * Although Rust doesn't have traditional OOP-style inheritance, we model trait
     * bounds and `impl` blocks as base types. Example:
     *
     * ```rust
     * trait T1 {}
     *
     * trait T2 {}
     *
     * trait T3 : T1, T2 {} // `T1` and `T2` are base type mention of `T3`
     * ```
     */
    abstract TypeMention getABaseTypeMention();

    /** Gets a textual representation of this type. */
    abstract string toString();

    /** Gets the location of this type. */
    abstract Location getLocation();
  }

  /** A struct type. */
  class StructType extends Type, TStruct {
    private Struct struct;

    StructType() { this = TStruct(struct) }

    override Function getMethod(string name) { result = struct.(ItemNode).getASuccessor(name) }

    override RecordField getRecordField(string name) { result = struct.getRecordField(name) }

    override TupleField getTupleField(int i) { result = struct.getTupleField(i) }

    override TypeParameter getTypeParameter(int i) {
      result = TTypeParamTypeParameter(struct.getGenericParamList().getTypeParam(i))
    }

    override TypeMention getABaseTypeMention() { struct = result.(ImplItemNode).resolveSelfTy() }

    override string toString() { result = struct.toString() }

    override Location getLocation() { result = struct.getLocation() }
  }

  /** An enum type. */
  class EnumType extends Type, TEnum {
    private Enum enum;

    EnumType() { this = TEnum(enum) }

    override Function getMethod(string name) { result = enum.(ItemNode).getASuccessor(name) }

    override RecordField getRecordField(string name) { none() }

    override TupleField getTupleField(int i) { none() }

    override TypeParameter getTypeParameter(int i) {
      result = TTypeParamTypeParameter(enum.getGenericParamList().getTypeParam(i))
    }

    override TypeMention getABaseTypeMention() { enum = result.(ImplItemNode).resolveSelfTy() }

    override string toString() { result = enum.toString() }

    override Location getLocation() { result = enum.getLocation() }
  }

  /** An trait type. */
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
    private TypeReprMention getABound() {
      result = trait.(Trait).getTypeBoundList().getABound().getTypeRepr()
    }

    override TypeMention getABaseTypeMention() { result = this.getABound() }

    override string toString() { result = trait.toString() }

    override Location getLocation() { result = trait.getLocation() }
  }

  /**
   * An `impl` block type.
   *
   * Although `impl` blocks are not really types, but we treat them as such in
   * order to be able to match type parameters from structs (or enums) with type
   * parameters from `impl` blocks. For example, in
   *
   * ```rust
   * struct S<T1>(T1);
   *
   * impl<T2> S<T2> {
   *   fn id(self) -> S<T2> { self }
   * }
   *
   * let x : S(i64) = S(42);
   * x.id();
   * ```
   *
   * we pretend that the `impl` block is a base type mention of the struct `S`,
   * with type argument `T1`. This means that from knowing that `x` has type
   * `S(i64)`, we can first match `i64` with `T1`, and then by matching `T1` with
   * `T2`, we can match `i64` with `T2`.
   *
   * `impl` blocks can also have base type mentions, namely the trait that they
   * implement (if any). Example:
   *
   * ```rust
   * struct S<T1>(T1);
   *
   * trait Trait<T2> {
   *   fn f(self) -> T2;
   *
   *   fn g(self) -> T2 { self.f() }
   * }
   *
   * impl<T3> Trait<T3> for S<T3> { // `Trait<T3>` is a base type mention of this `impl` block
   *   fn f(self) -> T3 {
   *     match self {
   *       S(x) => x
   *     }
   *   }
   * }
   *
   * let x : S(i64) = S(42);
   * x.g();
   * ```
   *
   * In this case we can match `i64` with `T1`, `T1` with `T3`, and `T3` with `T2`,
   * allowing us match `i64` with `T3`, and hence infer that the return type of `g`
   * is `i64`.
   */
  class ImplType extends Type, TImpl {
    private Impl impl;

    ImplType() { this = TImpl(impl) }

    override Function getMethod(string name) { result = impl.(ItemNode).getASuccessor(name) }

    override RecordField getRecordField(string name) { none() }

    override TupleField getTupleField(int i) { none() }

    override TypeParameter getTypeParameter(int i) {
      result = TTypeParamTypeParameter(impl.getGenericParamList().getTypeParam(i))
    }

    override TypeMention getABaseTypeMention() { result = impl.getTrait() }

    override string toString() { result = impl.toString() }

    override Location getLocation() { result = impl.getLocation() }
  }

  /** An array type. */
  class ArrayType extends Type, TArrayType {
    ArrayType() { this = TArrayType() }

    override Function getMethod(string name) { none() }

    override RecordField getRecordField(string name) { none() }

    override TupleField getTupleField(int i) { none() }

    override TypeParameter getTypeParameter(int i) {
      none() // todo
    }

    override TypeMention getABaseTypeMention() { none() }

    override string toString() { result = "[]" }

    override Location getLocation() { result instanceof EmptyLocation }
  }

  /** A reference type. */
  class RefType extends Type, TRefType {
    RefType() { this = TRefType() }

    override Function getMethod(string name) { none() }

    override RecordField getRecordField(string name) { none() }

    override TupleField getTupleField(int i) { none() }

    override TypeParameter getTypeParameter(int i) {
      result = TRefTypeParameter() and
      i = 0
    }

    override TypeMention getABaseTypeMention() { none() }

    override string toString() { result = "&" }

    override Location getLocation() { result instanceof EmptyLocation }
  }

  /** A type parameter. */
  abstract class TypeParameter extends Type {
    abstract int getPosition();

    override TypeMention getABaseTypeMention() { none() }

    override RecordField getRecordField(string name) { none() }

    override TupleField getTupleField(int i) { none() }

    override TypeParameter getTypeParameter(int i) { none() }
  }

  class TypeParamTypeParameter extends TypeParameter, TTypeParamTypeParameter {
    private TypeParam typeParam;

    TypeParamTypeParameter() { this = TTypeParamTypeParameter(typeParam) }

    TypeParam getTypeParam() { result = typeParam }

    override int getPosition() { result = typeParam.getPosition() }

    override Function getMethod(string name) { result = typeParam.(ItemNode).getASuccessor(name) }

    override string toString() { result = typeParam.toString() }

    override Location getLocation() { result = typeParam.getLocation() }
  }

  class RefTypeParameter extends TypeParameter, TRefTypeParameter {
    override int getPosition() { result = 0 }

    override Function getMethod(string name) { none() }

    override string toString() { result = "&T" }

    override Location getLocation() { result instanceof EmptyLocation }
  }
}

import Types

private module Input1 implements InputSig1<Location> {
  private import rust as Rust
  private import codeql.rust.elements.internal.generated.Raw
  private import codeql.rust.elements.internal.generated.Synth

  class Type = Types::Type;

  class TypeParameter = Types::TypeParameter;

  private newtype TTypeArgPos =
    TMethodTypeArgPos(int pos) {
      exists(any(MethodCallExpr mce).getGenericArgList().getTypeArgument(pos))
    } or
    TTypeParamTypeArgPos(TypeParam tp)

  class TypeArgPos extends TTypeArgPos {
    int asMethodTypeArgPos() { this = TMethodTypeArgPos(result) }

    TypeParam asTypeParam() { this = TTypeParamTypeArgPos(result) }

    string toString() {
      result = this.asMethodTypeArgPos().toString()
      or
      result = this.asTypeParam().toString()
    }
  }

  class TypeParamPos = TypeParam;

  bindingset[apos]
  bindingset[ppos]
  predicate typeParamArgPosMatch(TypeParamPos ppos, TypeArgPos apos) {
    apos.asTypeParam() = ppos
    or
    apos.asMethodTypeArgPos() = ppos.getPosition()
  }

  private predicate id(Raw::TypeParam x, Raw::TypeParam y) { x = y }

  private predicate idOfRaw(Raw::TypeParam x, int y) = equivalenceRelation(id/2)(x, y)

  private int idOf(TypeParam node) { idOfRaw(Synth::convertAstNodeToRaw(node), result) }

  int getTypeParameterId(TypeParameter tp) {
    tp =
      rank[result](TypeParameter tp0, int kind, int id |
        tp0 instanceof RefTypeParameter and
        kind = 0 and
        id = 0
        or
        id = idOf(tp0.(TypeParamTypeParameter).getTypeParam()) and
        kind = 1
      |
        tp0 order by kind, id
      )
  }

  class Expr = Rust::Expr;
}

private import Input1
import Make1<Location, Input1>

private module TypeMentions {
  /** An AST node that may mention a type. */
  abstract class TypeMention extends AstNode {
    /** Gets the `i`th type argument, if any. */
    abstract TypeMention getTypeReprArgument(int i);

    /** Gets the type that this node resolves to. */
    abstract Type resolveType();

    /** Gets the node at `path`. */
    pragma[nomagic]
    private TypeMention getMentionAt(TypePath path) {
      path.isEmpty() and
      result = this
      or
      exists(int i, TypeParameter tp, TypeMention arg, TypePath suffix |
        arg = this.getTypeReprArgument(pragma[only_bind_into](i)) and
        result = arg.getMentionAt(suffix) and
        path = typePath(tp).append(suffix) and
        tp = this.resolveType().getTypeParameter(pragma[only_bind_into](i))
      )
    }

    /** Gets the type that the sub mention at `path` resolves to. */
    Type resolveTypeAt(TypePath path) { result = this.getMentionAt(path).resolveType() }
  }

  class TypeReprMention extends TypeMention, TypeRepr {
    override TypeReprMention getTypeReprArgument(int i) {
      result = this.(ArrayTypeRepr).getElementTypeRepr() and
      i = 0
      or
      result = this.(RefTypeRepr).getTypeRepr() and
      i = 0
      or
      result = this.(PathTypeRepr).getPath().(PathMention).getTypeReprArgument(i)
    }

    override Type resolveType() {
      this instanceof ArrayTypeRepr and
      result = TArrayType()
      or
      this instanceof RefTypeRepr and
      result = TRefType()
      or
      result = this.(PathTypeRepr).getPath().(PathMention).resolveType()
    }
  }

  private class PathMention extends TypeMention, Path {
    override TypeMention getTypeReprArgument(int i) {
      result = this.getPart().getGenericArgList().getTypeArgument(i)
      or
      // `Self` paths inside traits and `impl` blocks have implicit type arguments
      // that are the type parameters of the trait or impl. For example, in
      //
      // ```rust
      // impl Foo<T> {
      //   fn m(self) -> Self {
      //     self
      //   }
      // }
      // ```
      //
      // the `Self` return type is shorthand for `Foo<T>`.
      isUnqualifiedSelfPath(this) and
      exists(ItemNode node | node = unqualifiedPathLookup(this) |
        result = node.(ImplItemNode).getSelfPath().getPart().getGenericArgList().getTypeArgument(i)
        or
        result = node.(Trait).getGenericParamList().getTypeParam(i)
      )
    }

    pragma[nomagic]
    predicate isImplTypeParam(ImplItemNode impl, PathMention selfPath, int i) {
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
        result = TTypeParamTypeParameter(i)
        or
        result = i.(TypeAlias).getTypeRepr().(TypeReprMention).resolveType()
      )
    }
  }

  private class TypeParamMention extends TypeMention, TypeParam {
    override TypeReprMention getTypeReprArgument(int i) { none() }

    override Type resolveType() { result = TTypeParamTypeParameter(this) }
  }

  private class ImplMention extends TypeMention, Impl {
    override TypeReprMention getTypeReprArgument(int i) { none() }

    override Type resolveType() { result = TImpl(this) }

    override Type resolveTypeAt(TypePath path) {
      result = TImpl(this) and
      path.isEmpty()
      or
      exists(PathMention selfPath, PathMention p | selfPath = this.(ImplItemNode).getSelfPath() |
        exists(int i |
          p.isImplTypeParam(this, selfPath, i) and
          result = selfPath.resolveType().getTypeParameter(i) and
          path = typePath(p.resolveType())
        )
      )
    }
  }
}

private import TypeMentions

private module Input2 implements InputSig2 {
  class TypeMention = TypeMentions::TypeMention;

  TypeMention getABaseTypeMention(Type t) { result = t.getABaseTypeMention() }

  Type resolveExprType(Expr e, TypePath path) { result = resolveType(e, path) }

  additional TypeReprMention getExplicitTypeArg(Path path, TypeParam tp) {
    exists(int i |
      result = path.getPart().getGenericArgList().getTypeArgument(i) and
      tp = resolvePath(path).getTypeParam(i)
    )
    or
    exists(ImplItemNode i, Function f, TypeParam mid |
      result = getExplicitTypeArg(path.getQualifier(), mid) and
      f = resolvePath(path) and
      f = i.getAnAssocItem()
    )
  }
}

private import Input2
import Make2<Input2>

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

private Type resolveVariableType(AstNode n, TypePath path) {
  exists(TypeReprMention t | letStmtTyped(_, n, t) or selfParamTyped(n, t) or paramTyped(_, n, t) |
    result = t.resolveTypeAt(path)
  )
  or
  // todo: use `Name` node instead of `pat`
  exists(Variable v, AstNode pat, VariableAccess va |
    pat = [v.getPat().(AstNode), v.getSelfParam()] and
    va = v.getAnAccess()
  |
    result = resolveType(pat, path) and
    n = va
    or
    result = resolveType(va, path) and
    n = pat
  )
}

pragma[nomagic]
private Type resolveImplSelfType(Impl i, TypePath path) {
  result = i.getSelfTy().(TypeReprMention).resolveTypeAt(path) and
  not result instanceof ImplType
}

pragma[nomagic]
private Type resolveTraitSelfType(Trait t, TypePath path) {
  result = TTrait(t) and
  path.isEmpty()
  or
  exists(TypeParameter tp |
    tp = TTypeParamTypeParameter(t.getGenericParamList().getATypeParam()) and
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
    abstract TypeParam getATypeParam();

    TypeParameter getTypeParameter(TypeParamPos ppos) {
      result.(TypeParamTypeParameter).getTypeParam() = ppos and
      ppos = this.getATypeParam()
    }

    abstract RecordField getField(string name);
  }

  private class StructDecl extends Decl, Struct {
    override TypeParam getATypeParam() { result = this.getGenericParamList().getATypeParam() }

    override RecordField getField(string name) { result = this.getRecordField(name) }
  }

  private class VariantDecl extends Decl, Variant {
    Enum getEnum() { result.getVariantList().getAVariant() = this }

    override TypeParam getATypeParam() {
      result = this.getEnum().getGenericParamList().getATypeParam()
    }

    override RecordField getField(string name) { result = this.getRecordField(name) }
  }

  class Access extends RecordExpr {
    Type getExplicitTypeArgument(TypeArgPos apos, TypePath path) {
      result = getExplicitTypeArg(this.getPath(), apos.asTypeParam()).resolveTypeAt(path)
    }
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

  Expr getArg(Access a, ArgPos pos) {
    result = a.getFieldExpr(pos.asFieldPos()).getExpr()
    or
    result = a and
    pos = TDeclPos()
  }

  predicate parameterType(Decl decl, ParamPos pos, TypePath path, Type t) {
    exists(TypeReprMention tp | tp = decl.getField(pos.asFieldPos()).getTypeRepr() |
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
      t = decl.getTypeParameter(_) and
      path = typePath(t)
    )
  }
}

private module RecordFieldMatching = Matching<RecordFieldMatchingInput>;

private Type resolveRecordExprType(AstNode n, TypePath path) {
  result = RecordFieldMatching::resolveArgType(n, _, _, path)
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
    predicate isSelf() { this = TSelfArgPos() }

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
    abstract TypeParam getATypeParam();

    TypeParameter getTypeParameter(TypeParamPos ppos) {
      result.(TypeParamTypeParameter).getTypeParam() = ppos and
      ppos = this.getATypeParam()
    }

    abstract Type getParameterType(ParamPos pos, TypePath path);

    abstract Type getReturnType(TypePath path);
  }

  private class StructDecl extends Decl, Struct {
    override TypeParam getATypeParam() { result = this.getGenericParamList().getATypeParam() }

    override Type getParameterType(ParamPos pos, TypePath path) {
      exists(int p |
        result = this.getTupleField(p).getTypeRepr().(TypeReprMention).resolveTypeAt(path) and
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

    override TypeParam getATypeParam() {
      result = this.getEnum().getGenericParamList().getATypeParam()
    }

    override Type getParameterType(ParamPos pos, TypePath path) {
      exists(int p |
        result = this.getTupleField(p).getTypeRepr().(TypeReprMention).resolveTypeAt(path) and
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
    override TypeParam getATypeParam() { result = this.getGenericParamList().getATypeParam() }

    override Type getParameterType(ParamPos pos, TypePath path) {
      exists(TypeReprMention tp, Param p, int i, boolean inMethod |
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
        exists(TypeReprMention tp |
          selfParamTyped(this.getParamList().getSelfParam(), tp) and
          result = tp.resolveTypeAt(path)
        )
      )
    }

    override Type getReturnType(TypePath path) {
      result = this.getRetType().getTypeRepr().(TypeReprMention).resolveTypeAt(path)
    }
  }

  class Access extends CallExprBase {
    private Path getPath() { result = this.(CallExpr).getFunction().(PathExpr).getPath() }

    Function getResolvedFunction() { result = resolvePath(this.getPath()) }

    private TypeReprMention getMethodTypeArg(int i) {
      result = this.(MethodCallExpr).getGenericArgList().getTypeArgument(i)
    }

    Type getExplicitTypeArgument(TypeArgPos apos, TypePath path) {
      exists(TypeReprMention arg | result = arg.resolveTypeAt(path) |
        arg = getExplicitTypeArg(this.getPath(), apos.asTypeParam())
        or
        arg = this.getMethodTypeArg(apos.asMethodTypeArgPos())
      )
      // result = this.getTypeArg(i).resolveTypeAt(path)
    }
  }

  predicate target(Access a, Decl target) {
    target = a.getResolvedFunction()
    or
    target = resolveMethodCallExpr(a) // a.getStaticTarget()
    or
    target = a.(CallExpr).getStruct()
    or
    target = a.(CallExpr).getVariant()
  }

  Expr getArg(Access a, ArgPos pos) {
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
private Type resolveReceiverType(AstNode n) {
  exists(FunctionMatchingInput::ArgPos apos |
    result = resolveType(n) and
    n = FunctionMatchingInput::getArg(_, apos) and
    apos.isSelf()
  )
}

pragma[nomagic]
private Type resolveCallExprBaseType(AstNode n, TypePath path) {
  exists(FunctionMatchingInput::ArgPos apos, FunctionMatchingInput::ParamPos ppos |
    result = FunctionMatching::resolveArgType(n, apos, ppos, path) and
    (
      not ppos.isSelf()
      or
      not apos.isSelf()
      or
      ppos.isSelf() and
      not (result = TRefType() and path.isEmpty()) and
      not path.startsWith(TRefTypeParameter(), _)
      or
      resolveReceiverType(n) = TRefType()
    )
    or
    // method call with implicit borrow
    ppos.isSelf() and
    result =
      FunctionMatching::resolveArgType(n, apos, ppos, typePath(TRefTypeParameter()).append(path)) and
    resolveReceiverType(n) != TRefType()
  )
}

private module FieldExprMatchingInput implements MatchingInputSig {
  abstract class Decl extends AstNode {
    TypeParameter getTypeParameter(TypeParamPos ppos) { none() }

    abstract TypeRepr getTypeRepr();
  }

  private class RecordFieldDecl extends Decl instanceof RecordField {
    override TypeRepr getTypeRepr() { result = RecordField.super.getTypeRepr() }
  }

  private class TupleFieldDecl extends Decl instanceof TupleField {
    override TypeRepr getTypeRepr() { result = TupleField.super.getTypeRepr() }
  }

  class Access extends FieldExpr {
    Type getExplicitTypeArgument(TypeArgPos apos, TypePath path) { none() }
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

  Expr getArg(Access a, ArgPos pos) {
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
    t = decl.getTypeRepr().(TypeReprMention).resolveTypeAt(path)
  }
}

private module FieldExprMatching = Matching<FieldExprMatchingInput>;

private Type resolveFieldExprType(AstNode n, TypePath path) {
  exists(FieldExprMatchingInput::ArgPos apos |
    result = FieldExprMatching::resolveArgType(n, apos, _, path) and
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

pragma[nomagic]
private Type resolveRefExprTypeInv(Expr e, TypePath path) {
  exists(RefExpr re |
    result = resolveType(re, typePath(TRefTypeParameter()).append(path)) and
    e = re.getExpr()
  )
}

cached
private module Cached {
  cached
  newtype TType =
    TStruct(Struct s) or
    TEnum(Enum e) or
    TTrait(Trait t) or
    TImpl(Impl i) or
    TArrayType() or // todo: add size?
    TRefType() or // todo: add mut, lifetime?
    TTypeParamTypeParameter(TypeParam t) or
    TRefTypeParameter()

  cached
  module Public {
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
      or
      result = resolveRefExprTypeInv(n, path)
    }
  }
}

private import Cached
import Cached::Public

Type resolveType(AstNode n) { result = resolveType(n, "") }
