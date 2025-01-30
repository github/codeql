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

    /** Gets the `i`th tuple field belonging to this type, if any. */
    pragma[nomagic]
    abstract TupleField getTupleField(int i);

    /** Gets the `i`th type parameter of this type, if any. */
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

  abstract class StructOrEnumType extends Type {
    abstract ItemNode asItemNode();

    final override Function getMethod(string name) {
      result = this.asItemNode().getASuccessor(name) and
      exists(ImplOrTraitItemNode impl | result = impl.getAnAssocItem() |
        impl instanceof Trait
        or
        impl.(ImplItemNode).isUnconstrained()
      )
    }

    final override TypeMentions::ImplMention getABaseTypeMention() {
      this.asItemNode() = result.resolveSelfTy() and
      result.isUnconstrained()
    }
  }

  /** A struct type. */
  class StructType extends StructOrEnumType, TStruct {
    private Struct struct;

    StructType() { this = TStruct(struct) }

    override ItemNode asItemNode() { result = struct }

    override RecordField getRecordField(string name) { result = struct.getRecordField(name) }

    override TupleField getTupleField(int i) { result = struct.getTupleField(i) }

    override TypeParameter getTypeParameter(int i) {
      result = TTypeParamTypeParameter(struct.getGenericParamList().getTypeParam(i))
    }

    override string toString() { result = struct.toString() }

    override Location getLocation() { result = struct.getLocation() }
  }

  /** An enum type. */
  class EnumType extends StructOrEnumType, TEnum {
    private Enum enum;

    EnumType() { this = TEnum(enum) }

    override ItemNode asItemNode() { result = enum }

    override RecordField getRecordField(string name) { none() }

    override TupleField getTupleField(int i) { none() }

    override TypeParameter getTypeParameter(int i) {
      result = TTypeParamTypeParameter(enum.getGenericParamList().getTypeParam(i))
    }

    override string toString() { result = enum.toString() }

    override Location getLocation() { result = enum.getLocation() }
  }

  /** A trait type. */
  class TraitType extends Type, TTrait {
    private Trait trait;

    TraitType() { this = TTrait(trait) }

    override Function getMethod(string name) { result = trait.(ItemNode).getASuccessor(name) }

    override RecordField getRecordField(string name) { none() }

    override TupleField getTupleField(int i) { none() }

    override TypeParameter getTypeParameter(int i) {
      result = TTypeParamTypeParameter(trait.getGenericParamList().getTypeParam(i))
      or
      result = TSelfTypeParameter() and
      i = -1
    }

    pragma[nomagic]
    private TypeReprMention getABoundMention() {
      result = trait.getTypeBoundList().getABound().getTypeRepr()
    }

    override TypeMention getABaseTypeMention() { result = this.getABoundMention() }

    override string toString() { result = trait.toString() }

    override Location getLocation() { result = trait.getLocation() }
  }

  /**
   * An `impl` block type.
   *
   * Although `impl` blocks are not really types, we treat them as such in order
   * to be able to match type parameters from structs (or enums) with type
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
   * allowing us match `i64` with `T2`, and hence infer that the return type of `g`
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
      or
      result = TSelfTypeParameter() and
      i = -1
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

  /**
   * A reference type.
   *
   * Reference types like `& i64` are modeled as normal generic types
   * with a single type argument.
   */
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

  /** A type parameter from source code. */
  class TypeParamTypeParameter extends TypeParameter, TTypeParamTypeParameter {
    private TypeParam typeParam;

    TypeParamTypeParameter() { this = TTypeParamTypeParameter(typeParam) }

    TypeParam getTypeParam() { result = typeParam }

    override int getPosition() { result = typeParam.getPosition() }

    override Function getMethod(string name) { result = typeParam.(ItemNode).getASuccessor(name) }

    override string toString() { result = typeParam.toString() }

    override Location getLocation() { result = typeParam.getLocation() }
  }

  /** A reference type parameter. */
  class RefTypeParameter extends TypeParameter, TRefTypeParameter {
    override int getPosition() { result = 0 }

    override Function getMethod(string name) { none() }

    override string toString() { result = "&T" }

    override Location getLocation() { result instanceof EmptyLocation }
  }

  /** An implicit `Self` type parameter. */
  class SelfTypeParameter extends TypeParameter, TSelfTypeParameter {
    override int getPosition() { result = 0 }

    override Function getMethod(string name) { none() }

    override string toString() { result = "(Self)" }

    override Location getLocation() { result instanceof EmptyLocation }
  }
}

import Types

private module Input1 implements InputSig1<Location> {
  private import codeql.rust.elements.internal.generated.Raw
  private import codeql.rust.elements.internal.generated.Synth

  class Type = Types::Type;

  class TypeParameter = Types::TypeParameter;

  private newtype TTypeArgumentPosition =
    // method type parameters are matched by position instead of by type
    // parameter entity, to avoid extra recursion through method call resolution
    TMethodTypeArgumentPosition(int pos) {
      exists(any(MethodCallExpr mce).getGenericArgList().getTypeArgument(pos))
    } or
    TTypeParamTypeArgumentPosition(TypeParam tp)

  class TypeArgumentPosition extends TTypeArgumentPosition {
    int asMethodTypeArgumentPosition() { this = TMethodTypeArgumentPosition(result) }

    TypeParam asTypeParam() { this = TTypeParamTypeArgumentPosition(result) }

    string toString() {
      result = this.asMethodTypeArgumentPosition().toString()
      or
      result = this.asTypeParam().toString()
    }
  }

  class TypeParameterPosition = TypeParam;

  bindingset[apos]
  bindingset[ppos]
  predicate typeArgumentParameterPositionMatch(TypeArgumentPosition apos, TypeParameterPosition ppos) {
    apos.asTypeParam() = ppos
    or
    apos.asMethodTypeArgumentPosition() = ppos.getPosition()
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
        tp0 instanceof SelfTypeParameter and
        kind = 0 and
        id = 1
        or
        id = idOf(tp0.(TypeParamTypeParameter).getTypeParam()) and
        kind = 1
      |
        tp0 order by kind, id
      )
  }
}

private import Input1

private module M1 = Make1<Location, Input1>;

private import M1

class TypePath = M1::TypePath;

private module TypeMentions {
  /** An AST node that may mention a type. */
  abstract class TypeMention extends AstNode {
    /** Gets the `i`th type argument mention, if any. */
    abstract TypeMention getTypeArgument(int i);

    /** Gets the type that this node resolves to, if any. */
    abstract Type resolveType();

    /** Gets the sub mention at `path`. */
    pragma[nomagic]
    private TypeMention getMentionAt(TypePath path) {
      path.isEmpty() and
      result = this
      or
      exists(int i, TypeParameter tp, TypeMention arg, TypePath suffix |
        arg = this.getTypeArgument(pragma[only_bind_into](i)) and
        result = arg.getMentionAt(suffix) and
        path = typePath(tp).append(suffix) and
        tp = this.resolveType().getTypeParameter(pragma[only_bind_into](i))
      )
    }

    /** Gets the type that the sub mention at `path` resolves to, if any. */
    Type resolveTypeAt(TypePath path) { result = this.getMentionAt(path).resolveType() }

    /**
     * Like `resolveTypeAt`, but also resolves `Self` mentions to the implicit
     * `Self` type parameter.
     *
     * This is only needed when resolving types for calls to methods; inside the
     * methods themselves, `Self` only resolves to the relevant trait or type
     * being implemented.
     */
    final Type resolveTypeAtInclSelf(TypePath path) {
      result = this.resolveTypeAt(path)
      or
      exists(TypeMention tm, ImplOrTraitItemNode node |
        tm = this.getMentionAt(path) and
        result = TSelfTypeParameter()
      |
        tm = node.getASelfPath()
        or
        tm.(PathTypeRepr).getPath() = node.getASelfPath()
      )
    }
  }

  class TypeReprMention extends TypeMention, TypeRepr {
    TypeReprMention() { not this instanceof InferTypeRepr }

    override TypeReprMention getTypeArgument(int i) {
      result = this.(ArrayTypeRepr).getElementTypeRepr() and
      i = 0
      or
      result = this.(RefTypeRepr).getTypeRepr() and
      i = 0
      or
      result = this.(PathTypeRepr).getPath().(PathMention).getTypeArgument(i)
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
    override TypeMention getTypeArgument(int i) {
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
      exists(ImplOrTraitItemNode node | this = node.getASelfPath() |
        result = node.(ImplItemNode).getSelfPath().getPart().getGenericArgList().getTypeArgument(i)
        or
        result = node.(Trait).getGenericParamList().getTypeParam(i)
      )
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

  // Used to represent implicit `Self` type arguments in traits and `impl` blocks,
  // see `PathMention` for details.
  private class TypeParamMention extends TypeMention, TypeParam {
    override TypeReprMention getTypeArgument(int i) { none() }

    override Type resolveType() { result = TTypeParamTypeParameter(this) }
  }

  /**
   * Holds if the `i`th type argument of `selfPath`, belonging to `impl`, resolves
   * to type parameter `tp`.
   *
   * Example:
   *
   * ```rust
   * impl<T> Foo<T> for Bar<T> { ... }
   * //      ^^^^^^ selfPath
   * //   ^         tp
   * ```
   */
  pragma[nomagic]
  private predicate isImplSelfTypeParam(
    ImplItemNode impl, PathMention selfPath, int i, TypeParameter tp
  ) {
    exists(PathMention path |
      selfPath = impl.getSelfPath() and
      path = selfPath.getPart().getGenericArgList().getTypeArgument(i).(PathTypeRepr).getPath() and
      tp = path.resolveType()
    )
  }

  class ImplMention extends TypeMention, ImplItemNode {
    override TypeReprMention getTypeArgument(int i) { none() }

    override Type resolveType() { result = TImpl(this) }

    override Type resolveTypeAt(TypePath path) {
      result = TImpl(this) and
      path.isEmpty()
      or
      // For example, in
      //
      // ```rust
      // struct S<T1>(T1);
      //
      // impl<T2> S<T2> { ... }
      // ```
      //
      // We get that the type path "0" resolves to `T1` for the `impl` block,
      // which is considered a base type mention of `S`.
      exists(PathMention selfPath, TypeParameter tp, int i |
        isImplSelfTypeParam(this, selfPath, pragma[only_bind_into](i), tp) and
        result = selfPath.resolveType().getTypeParameter(pragma[only_bind_into](i)) and
        path = typePath(tp)
      )
    }
  }
}

private import TypeMentions

private module Input2 implements InputSig2 {
  class TypeMention = TypeMentions::TypeMention;

  TypeMention getABaseTypeMention(Type t) { result = t.getABaseTypeMention() }
}

private import Input2
import Make2<Input2>

/** Gets the type annotation that applies to `n`, if any. */
private TypeMention getTypeAnnotation(AstNode n) {
  exists(LetStmt let |
    n = let.getPat() and
    result = let.getTypeRepr()
  )
  or
  result = n.(SelfParam).getTypeRepr()
  or
  exists(Param p |
    n = p.getPat() and
    result = p.getTypeRepr()
  )
  or
  exists(Function f |
    result = f.getRetType().getTypeRepr() and
    n = f.getBody()
  )
}

/** Gets the type of `n`, which has an explicit type annotation. */
pragma[nomagic]
private Type resolveAnnotatedType(AstNode n, TypePath path) {
  result = getTypeAnnotation(n).resolveTypeAt(path)
}

/**
 * Holds if the type of `n1` at `path1` is the same as the type of `n2` at `path2`.
 */
bindingset[path1]
bindingset[path2]
private predicate typeSymRule(AstNode n1, TypePath path1, AstNode n2, TypePath path2) {
  exists(Variable v |
    path1 = path2 and
    n1 = v.getAnAccess()
  |
    n2 = v.getPat()
    or
    n2 = v.getParameter().(SelfParam)
  )
  or
  exists(LetStmt let |
    let.getPat() = n1 and
    let.getInitializer() = n2 and
    path1 = path2
  )
  or
  n2 = n1.(RefExpr).getExpr() and
  path1 = typePath(TRefTypeParameter()).append(path2)
  or
  n2 =
    any(PrefixExpr pe |
      pe.getOperatorName() = "*" and
      pe.getExpr() = n1 and
      path1 = typePath(TRefTypeParameter()).append(path2)
    )
  or
  n1 = n2.(ParenExpr).getExpr() and
  path1 = path2
  or
  n1 = n2.(BlockExpr).getStmtList().getTailExpr() and
  path1 = path2
}

pragma[nomagic]
private Type resolveTypeSym(AstNode n, TypePath path) {
  exists(AstNode n2, TypePath path2 | result = resolveType(n2, path2) |
    typeSymRule(n, path, n2, path2)
    or
    typeSymRule(n2, path2, n, path)
  )
}

bindingset[i, suffix, t]
pragma[inline_late]
private Type getRefAdjustSelfType(
  ImplOrTraitItemNode i, SelfParam self, TypePath suffix, Type t, TypePath path
) {
  exists(Function f |
    f = i.getAnAssocItem() and
    self = f.getParamList().getSelfParam()
  |
    if self.isRef()
    then
      // `fn f(&self, ...)`
      path.isEmpty() and
      result = TRefType()
      or
      path = typePath(TRefTypeParameter()).append(suffix) and
      result = t
    else (
      // `fn f(self, ...)`
      path = suffix and
      result = t
    )
  )
}

pragma[nomagic]
private Type resolveImplSelfType(Impl i, TypePath path) {
  result = i.getSelfTy().(TypeReprMention).resolveTypeAt(path)
}

pragma[nomagic]
private Type resolveTraitSelfType(Trait t, TypePath path) {
  result = TTrait(t) and
  path.isEmpty()
  or
  result = TTypeParamTypeParameter(t.getGenericParamList().getATypeParam()) and
  path = typePath(result)
}

/** Gets the type at `path` of the implicitly typed `self` parameter. */
pragma[nomagic]
private Type resolveImplicitSelfType(SelfParam self, TypePath path) {
  exists(ImplOrTraitItemNode i, TypePath suffix, Type t |
    t = resolveImplSelfType(i, suffix)
    or
    t = resolveTraitSelfType(i, suffix)
  |
    result = getRefAdjustSelfType(i, self, suffix, t, path)
  )
}

private TypeMention getExplicitTypeArgMention(Path path, TypeParam tp) {
  exists(int i |
    result = path.getPart().getGenericArgList().getTypeArgument(pragma[only_bind_into](i)) and
    tp = resolvePath(path).getTypeParam(pragma[only_bind_into](i))
  )
  or
  result = getExplicitTypeArgMention(path.getQualifier(), tp)
}

/**
 * A matching configuration for resolving types of record expressions
 * like `Foo { bar = baz }`.
 */
private module RecordExprMatchingInput implements MatchingInputSig {
  private newtype TPos =
    TFieldPos(string name) { exists(any(Declaration decl).getField(name)) } or
    TRecordPos()

  class DeclarationPosition extends TPos {
    string asFieldPos() { this = TFieldPos(result) }

    predicate isRecordPos() { this = TRecordPos() }

    string toString() {
      result = this.asFieldPos()
      or
      this.isRecordPos() and
      result = "(record)"
    }
  }

  abstract class Declaration extends AstNode {
    abstract TypeParam getATypeParam();

    final TypeParameter getTypeParameter(TypeParameterPosition ppos) {
      result.(TypeParamTypeParameter).getTypeParam() = ppos and
      ppos = this.getATypeParam()
    }

    abstract RecordField getField(string name);

    Type getDeclaredType(DeclarationPosition dpos, TypePath path) {
      // type of a field
      exists(TypeReprMention tp |
        tp = this.getField(dpos.asFieldPos()).getTypeRepr() and
        result = tp.resolveTypeAt(path)
      )
      or
      // type parameter of the record itself
      dpos.isRecordPos() and
      result = this.getTypeParameter(_) and
      path = typePath(result)
    }
  }

  private class StructDecl extends Declaration, Struct {
    override TypeParam getATypeParam() { result = this.getGenericParamList().getATypeParam() }

    override RecordField getField(string name) { result = this.getRecordField(name) }

    override Type getDeclaredType(DeclarationPosition dpos, TypePath path) {
      result = super.getDeclaredType(dpos, path)
      or
      // type of the record itself
      dpos.isRecordPos() and
      path.isEmpty() and
      result = TStruct(this)
    }
  }

  private class VariantDecl extends Declaration, Variant {
    Enum getEnum() { result.getVariantList().getAVariant() = this }

    override TypeParam getATypeParam() {
      result = this.getEnum().getGenericParamList().getATypeParam()
    }

    override RecordField getField(string name) { result = this.getRecordField(name) }

    override Type getDeclaredType(DeclarationPosition dpos, TypePath path) {
      result = super.getDeclaredType(dpos, path)
      or
      // type of the record itself
      dpos.isRecordPos() and
      path.isEmpty() and
      result = TEnum(this.getEnum())
    }
  }

  class AccessPosition = DeclarationPosition;

  class Access extends RecordExpr {
    Type getExplicitTypeArgument(TypeArgumentPosition apos, TypePath path) {
      result = getExplicitTypeArgMention(this.getPath(), apos.asTypeParam()).resolveTypeAt(path)
    }

    AstNode getNodeAt(AccessPosition apos) {
      result = this.getFieldExpr(apos.asFieldPos()).getExpr()
      or
      result = this and
      apos.isRecordPos()
    }

    Type getResolvedType(AccessPosition apos, TypePath path) {
      result = resolveType(this.getNodeAt(apos), path)
    }

    Declaration getTarget() { result = resolvePath(this.getPath()) }
  }

  predicate accessDeclarationPositionMatch(AccessPosition apos, DeclarationPosition dpos) {
    apos = dpos
  }
}

private module RecordExprMatching = Matching<RecordExprMatchingInput>;

/**
 * Gets the type of `n` at `path`, where `n` is either a record expression or
 * a field expression of a record expression.
 */
private Type resolveRecordExprType(AstNode n, TypePath path) {
  exists(RecordExprMatchingInput::Access a, RecordExprMatchingInput::AccessPosition apos |
    n = a.getNodeAt(apos) and
    result = RecordExprMatching::resolveAccessType(a, apos, path)
  )
}

pragma[nomagic]
private Type resolvePathExprType(PathExpr pe, TypePath path) {
  // nullary struct/variant constructors
  not exists(CallExpr ce | pe = ce.getFunction()) and
  path.isEmpty() and
  exists(ItemNode i | i = resolvePath(pe.getPath()) |
    result = TEnum(i.(Variant).getEnum())
    or
    result = TStruct(i)
  )
}

/**
 * A matching configuration for resolving types of call expressions
 * like `foo::bar(baz)` and `foo.bar(baz)`.
 */
private module CallExprBaseMatchingInput implements MatchingInputSig {
  private predicate paramPos(ParamList pl, Param p, int pos, boolean inMethod) {
    p = pl.getParam(pos) and
    if pl.hasSelfParam() then inMethod = true else inMethod = false
  }

  private newtype TDeclarationPosition =
    TSelfDeclarationPosition() or
    TPositionalDeclarationPosition(int pos, boolean inMethod) { paramPos(_, _, pos, inMethod) } or
    TReturnDeclarationPosition()

  class DeclarationPosition extends TDeclarationPosition {
    predicate isSelf() { this = TSelfDeclarationPosition() }

    int asPosition(boolean inMethod) { this = TPositionalDeclarationPosition(result, inMethod) }

    predicate isReturn() { this = TReturnDeclarationPosition() }

    string toString() {
      this = TSelfDeclarationPosition() and
      result = "self"
      or
      result = this.asPosition(_).toString()
      or
      this = TReturnDeclarationPosition() and
      result = "(return)"
    }
  }

  abstract class Declaration extends AstNode {
    abstract TypeParam getATypeParam();

    final TypeParameter getTypeParameter(TypeParameterPosition ppos) {
      result.(TypeParamTypeParameter).getTypeParam() = ppos and
      ppos = this.getATypeParam()
    }

    abstract Type getParameterType(DeclarationPosition dpos, TypePath path);

    abstract Type getReturnType(TypePath path);

    final Type getDeclaredType(DeclarationPosition dpos, TypePath path) {
      result = this.getParameterType(dpos, path)
      or
      dpos = TReturnDeclarationPosition() and
      result = this.getReturnType(path)
    }
  }

  private class StructDecl extends Declaration, Struct {
    override TypeParam getATypeParam() { result = this.getGenericParamList().getATypeParam() }

    override Type getParameterType(DeclarationPosition dpos, TypePath path) {
      exists(int pos |
        result = this.getTupleField(pos).getTypeRepr().(TypeReprMention).resolveTypeAt(path) and
        dpos = TPositionalDeclarationPosition(pos, false)
      )
    }

    override Type getReturnType(TypePath path) {
      result = TStruct(this) and
      path.isEmpty()
      or
      result = TTypeParamTypeParameter(this.getGenericParamList().getATypeParam()) and
      path = typePath(result)
    }
  }

  private class VariantDecl extends Declaration, Variant {
    override TypeParam getATypeParam() {
      result = this.getEnum().getGenericParamList().getATypeParam()
    }

    override Type getParameterType(DeclarationPosition dpos, TypePath path) {
      exists(int p |
        result = this.getTupleField(p).getTypeRepr().(TypeReprMention).resolveTypeAt(path) and
        dpos = TPositionalDeclarationPosition(p, false)
      )
    }

    override Type getReturnType(TypePath path) {
      exists(Enum enum | enum = this.getEnum() |
        result = TEnum(enum) and
        path.isEmpty()
        or
        result = TTypeParamTypeParameter(enum.getGenericParamList().getATypeParam()) and
        path = typePath(result)
      )
    }
  }

  pragma[nomagic]
  private Type resolveAnnotatedTypeInclSelf(AstNode n, TypePath path) {
    result = getTypeAnnotation(n).resolveTypeAtInclSelf(path)
  }

  private class FunctionDecl extends Declaration, Function {
    override TypeParam getATypeParam() { result = this.getGenericParamList().getATypeParam() }

    override Type getParameterType(DeclarationPosition dpos, TypePath path) {
      exists(Param p, int i, boolean inMethod |
        paramPos(this.getParamList(), p, i, inMethod) and
        dpos = TPositionalDeclarationPosition(i, inMethod) and
        result = resolveAnnotatedTypeInclSelf(p.getPat(), path)
      )
      or
      exists(SelfParam self |
        self = pragma[only_bind_into](this.getParamList().getSelfParam()) and
        dpos.isSelf()
      |
        // `self` parameter with type annotation
        result = resolveAnnotatedTypeInclSelf(self, path)
        or
        // `self` parameter without type annotation
        result = resolveImplicitSelfType(self, path)
        or
        exists(Trait i, TypePath suffix, Type t |
          t = TSelfTypeParameter() and
          suffix.isEmpty() and
          result = getRefAdjustSelfType(i, self, suffix, t, path)
        )
      )
    }

    override Type getReturnType(TypePath path) {
      result = this.getRetType().getTypeRepr().(TypeReprMention).resolveTypeAtInclSelf(path)
    }
  }

  private predicate argPos(CallExprBase call, Expr e, int pos, boolean isMethodCall) {
    exists(ArgList al |
      e = al.getArg(pos) and
      call.getArgList() = al and
      if call instanceof MethodCallExpr then isMethodCall = true else isMethodCall = false
    )
  }

  private newtype TAccessPosition =
    TSelfAccessPosition() or
    TPositionalAccessPosition(int pos, boolean isMethodCall) { argPos(_, _, pos, isMethodCall) } or
    TReturnAccessPosition()

  class AccessPosition extends TAccessPosition {
    predicate isSelf() { this = TSelfAccessPosition() }

    int asPosition(boolean isMethodCall) { this = TPositionalAccessPosition(result, isMethodCall) }

    predicate isReturn() { this = TReturnAccessPosition() }

    string toString() {
      this = TSelfAccessPosition() and
      result = "self"
      or
      result = this.asPosition(_).toString()
      or
      this.isReturn() and
      result = "(return)"
    }
  }

  private import codeql.rust.elements.internal.CallExprImpl::Impl as CallExprImpl

  class Access extends CallExprBase {
    private TypeReprMention getMethodTypeArg(int i) {
      result = this.(MethodCallExpr).getGenericArgList().getTypeArgument(i)
    }

    Type getExplicitTypeArgument(TypeArgumentPosition apos, TypePath path) {
      exists(TypeMention arg | result = arg.resolveTypeAt(path) |
        arg = getExplicitTypeArgMention(CallExprImpl::getFunctionPath(this), apos.asTypeParam())
        or
        arg = this.getMethodTypeArg(apos.asMethodTypeArgumentPosition())
      )
    }

    AstNode getNodeAt(AccessPosition apos) {
      exists(int p, boolean isMethodCall |
        argPos(this, result, p, isMethodCall) and
        apos = TPositionalAccessPosition(p, isMethodCall)
      )
      or
      result = this.(MethodCallExpr).getReceiver() and
      apos = TSelfAccessPosition()
      or
      result = this and
      apos = TReturnAccessPosition()
    }

    Type getResolvedType(AccessPosition apos, TypePath path) {
      result = resolveType(this.getNodeAt(apos), path)
    }

    Declaration getTarget() {
      result =
        [
          CallExprImpl::getResolvedFunction(this).(AstNode),
          this.(CallExpr).getStruct(),
          this.(CallExpr).getVariant(),
          // mutual recursion; resolving method calls requires resolving types and vice versa
          resolveMethodCallExpr(this)
        ]
    }
  }

  predicate accessDeclarationPositionMatch(AccessPosition apos, DeclarationPosition dpos) {
    apos.isSelf() and
    dpos.isSelf()
    or
    exists(int pos, boolean isMethodCall | pos = apos.asPosition(isMethodCall) |
      pos = 0 and
      isMethodCall = false and
      dpos.isSelf()
      or
      isMethodCall = false and
      pos = dpos.asPosition(true) + 1
      or
      pos = dpos.asPosition(isMethodCall)
    )
    or
    apos = TReturnAccessPosition() and
    dpos = TReturnDeclarationPosition()
  }

  bindingset[apos, target, path, t]
  pragma[inline_late]
  predicate adjustAccessType(
    AccessPosition apos, Declaration target, TypePath path, Type t, TypePath pathAdj, Type tAdj
  ) {
    if apos.isSelf()
    then
      exists(Type selfParamType |
        selfParamType = target.getParameterType(TSelfDeclarationPosition(), "")
      |
        if selfParamType = TRefType()
        then
          if t != TRefType() and path.isEmpty()
          then
            // adjust for implicit borrow
            pathAdj.isEmpty() and
            tAdj = TRefType()
            or
            // adjust for implicit borrow
            pathAdj = typePath(TRefTypeParameter()) and
            tAdj = t
          else
            if path.startsWith(TRefTypeParameter(), _)
            then
              pathAdj = path and
              tAdj = t
            else (
              // adjust for implicit borrow
              not (t = TRefType() and path.isEmpty()) and
              pathAdj = typePath(TRefTypeParameter()).append(path) and
              tAdj = t
            )
        else (
          // adjust for implicit deref
          path.startsWith(TRefTypeParameter(), pathAdj) and
          tAdj = t
          or
          not path.startsWith(TRefTypeParameter(), _) and
          not (t = TRefType() and path.isEmpty()) and
          pathAdj = path and
          tAdj = t
        )
      )
    else (
      pathAdj = path and
      tAdj = t
    )
  }

  pragma[nomagic]
  additional Type resolveReceiverType(AstNode n) {
    exists(Access a, AccessPosition apos |
      result = resolveType(n) and
      n = a.getNodeAt(apos) and
      apos.isSelf()
    )
  }
}

private module CallExprBaseMatching = Matching<CallExprBaseMatchingInput>;

pragma[nomagic]
private Type resolveCallExprBaseType(AstNode n, TypePath path) {
  exists(
    CallExprBaseMatchingInput::Access a, CallExprBaseMatchingInput::AccessPosition apos,
    TypePath path0
  |
    n = a.getNodeAt(apos) and
    result = CallExprBaseMatching::resolveAccessType(a, apos, path0)
  |
    if apos.isSelf()
    then
      exists(Type receiverType | receiverType = CallExprBaseMatchingInput::resolveReceiverType(n) |
        if receiverType = TRefType()
        then
          path = path0 and
          path0.startsWith(TRefTypeParameter(), _)
          or
          // adjust for implicit deref
          not path0.startsWith(TRefTypeParameter(), _) and
          not (path0.isEmpty() and result = TRefType()) and
          path = typePath(TRefTypeParameter()).append(path0)
        else (
          not path0.startsWith(TRefTypeParameter(), _) and
          not (path0.isEmpty() and result = TRefType()) and
          path = path0
          or
          // adjust for implicit borrow
          path0.startsWith(TRefTypeParameter(), path)
        )
      )
    else path = path0
  )
}

/**
 * A matching configuration for resolving types of field expressions
 * like `x.field`.
 */
private module FieldExprMatchingInput implements MatchingInputSig {
  private newtype TDeclarationPosition =
    TSelfDeclarationPosition() or
    TFieldPos()

  class DeclarationPosition extends TDeclarationPosition {
    predicate isSelf() { this = TSelfDeclarationPosition() }

    predicate isField() { this = TFieldPos() }

    string toString() {
      this.isSelf() and
      result = "self"
      or
      this.isField() and
      result = "(field)"
    }
  }

  abstract class Declaration extends AstNode {
    TypeParameter getTypeParameter(TypeParameterPosition ppos) { none() }

    abstract TypeRepr getTypeRepr();

    Type getDeclaredType(DeclarationPosition dpos, TypePath path) {
      dpos.isSelf() and
      // no case for variants as those can only be destructured using pattern matching
      exists(Struct s | s.getRecordField(_) = this or s.getTupleField(_) = this |
        result = TStruct(s) and
        path.isEmpty()
        or
        result = TTypeParamTypeParameter(s.getGenericParamList().getATypeParam()) and
        path = typePath(result)
      )
      or
      dpos.isField() and
      result = this.getTypeRepr().(TypeReprMention).resolveTypeAt(path)
    }
  }

  private class RecordFieldDecl extends Declaration instanceof RecordField {
    override TypeRepr getTypeRepr() { result = RecordField.super.getTypeRepr() }
  }

  private class TupleFieldDecl extends Declaration instanceof TupleField {
    override TypeRepr getTypeRepr() { result = TupleField.super.getTypeRepr() }
  }

  class AccessPosition = DeclarationPosition;

  class Access extends FieldExpr {
    Type getExplicitTypeArgument(TypeArgumentPosition apos, TypePath path) { none() }

    AstNode getNodeAt(AccessPosition apos) {
      result = this.getExpr() and
      apos.isSelf()
      or
      result = this and
      apos.isField()
    }

    Type getResolvedType(AccessPosition apos, TypePath path) {
      result = resolveType(this.getNodeAt(apos), path)
    }

    Declaration getTarget() {
      // mutual recursion; resolving fields requires resolving types and vice versa
      result = [resolveRecordFieldExpr(this).(AstNode), resolveTupleFieldExpr(this)]
    }
  }

  predicate accessDeclarationPositionMatch(AccessPosition apos, DeclarationPosition dpos) {
    apos = dpos
  }

  bindingset[apos, target, path, t]
  pragma[inline_late]
  predicate adjustAccessType(
    AccessPosition apos, Declaration target, TypePath path, Type t, TypePath pathAdj, Type tAdj
  ) {
    exists(target) and
    if apos.isSelf()
    then
      // adjust for implicit deref
      path.startsWith(TRefTypeParameter(), pathAdj) and
      tAdj = t
      or
      not path.startsWith(TRefTypeParameter(), _) and
      not (t = TRefType() and path.isEmpty()) and
      pathAdj = path and
      tAdj = t
    else (
      pathAdj = path and
      tAdj = t
    )
  }

  pragma[nomagic]
  additional Type resolveReceiverType(AstNode n) {
    exists(Access a, AccessPosition apos |
      result = resolveType(n) and
      n = a.getNodeAt(apos) and
      apos.isSelf()
    )
  }
}

private module FieldExprMatching = Matching<FieldExprMatchingInput>;

private Type resolveFieldExprType(AstNode n, TypePath path) {
  exists(
    FieldExprMatchingInput::Access a, FieldExprMatchingInput::AccessPosition apos, TypePath path0
  |
    n = a.getNodeAt(apos) and
    result = FieldExprMatching::resolveAccessType(a, apos, path0)
  |
    if apos.isSelf()
    then
      exists(Type receiverType | receiverType = FieldExprMatchingInput::resolveReceiverType(n) |
        if receiverType = TRefType()
        then
          // adjust for implicit deref
          not path0.startsWith(TRefTypeParameter(), _) and
          not (path0.isEmpty() and result = TRefType()) and
          path = typePath(TRefTypeParameter()).append(path0)
        else path = path0
      )
    else path = path0
  )
}

pragma[nomagic]
private Type resolveRefExprType(RefExpr re, TypePath path) {
  exists(re) and
  path.isEmpty() and
  result = TRefType()
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
    TRefType() or // todo: add mut?
    TTypeParamTypeParameter(TypeParam t) or
    TRefTypeParameter() or
    TSelfTypeParameter()

  cached
  module Public {
    pragma[inline]
    private Type getLookupType(AstNode n) {
      exists(Type t |
        t = resolveType(n) and
        if t = TRefType()
        then
          // for reference types, lookup members in the type being referenced
          result = resolveType(n, typePath(TRefTypeParameter()))
        else result = t
      )
    }

    pragma[nomagic]
    private Type getMethodCallExprLookupType(MethodCallExpr mce, string name) {
      result = getLookupType(mce.getReceiver()) and
      name = mce.getNameRef().getText()
    }

    /**
     * Gets a method that the method call `mce` resolves to, if any.
     */
    cached
    Function resolveMethodCallExpr(MethodCallExpr mce) {
      exists(string name | result = getMethodCallExprLookupType(mce, name).getMethod(name))
    }

    pragma[nomagic]
    private Type getFieldExprLookupType(FieldExpr fe, string name) {
      result = getLookupType(fe.getExpr()) and
      name = fe.getNameRef().getText()
    }

    /**
     * Gets the record field that the field expression `fe` resolves to, if any.
     */
    cached
    RecordField resolveRecordFieldExpr(FieldExpr fe) {
      exists(string name | result = getFieldExprLookupType(fe, name).getRecordField(name))
    }

    pragma[nomagic]
    private Type getTupleFieldExprLookupType(FieldExpr fe, int pos) {
      exists(string name |
        result = getFieldExprLookupType(fe, name) and
        pos = name.toInt()
      )
    }

    /**
     * Gets the tuple field that the field expression `fe` resolves to, if any.
     */
    cached
    TupleField resolveTupleFieldExpr(FieldExpr fe) {
      exists(int i | result = getTupleFieldExprLookupType(fe, i).getTupleField(i))
    }

    /**
     * Gets a type at `path` that `n` resolves to, if any.
     *
     * The type inference implementation works by computing all possible types, so
     * the result is not necessarilly unique. For example, in
     *
     * ```rust
     * trait MyTrait {
     *     fn foo(&self) -> &Self;
     *
     *     fn bar(&self) -> &Self {
     *        self.foo()
     *     }
     * }
     *
     * struct MyStruct;
     *
     * impl MyTrait for MyStruct {
     *     fn foo(&self) -> &MyStruct {
     *         self
     *     }
     * }
     *
     * fn baz() {
     *     let x = MyStruct;
     *     x.bar();
     * }
     * ```
     *
     * the type inference engine will roughly make the following deductions:
     *
     * 1. `MyStruct` has type `MyStruct`.
     * 2. `x` has type `MyStruct` (via 1.).
     * 3. The return type of `bar` is `&Self`.
     * 3. `x.bar()` has type `&MyStruct` (via 2 and 3, by matching the implicit `Self`
     *    type parameter with `MyStruct`.).
     * 4. The return type of `bar` is `&MyTrait`.
     * 5. `x.bar()` has type `&MyTrait` (via 2 and 4).
     */
    cached
    Type resolveType(AstNode n, TypePath path) {
      result = resolveAnnotatedType(n, path)
      or
      result = resolveTypeSym(n, path)
      or
      result = resolveImplicitSelfType(n, path)
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
}

private import Cached
import Cached::Public

/**
 * Gets a type that `n` resolves to, if any.
 */
Type resolveType(AstNode n) { result = resolveType(n, "") }
