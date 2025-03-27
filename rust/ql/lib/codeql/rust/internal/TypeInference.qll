/** Provides functionality for inferring types. */

private import rust
private import PathResolution
private import Type
private import Type as T
private import TypeMention
private import codeql.typeinference.internal.TypeInference

class Type = T::Type;

private module Input1 implements InputSig1<Location> {
  private import Type as T
  private import codeql.rust.elements.internal.generated.Raw
  private import codeql.rust.elements.internal.generated.Synth

  class Type = T::Type;

  class TypeParameter = T::TypeParameter;

  private newtype TTypeArgumentPosition =
    // method type parameters are matched by position instead of by type
    // parameter entity, to avoid extra recursion through method call resolution
    TMethodTypeArgumentPosition(int pos) {
      exists(any(MethodCallExpr mce).getGenericArgList().getTypeArg(pos))
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

module TypePath = M1::TypePath;

private module Input2 implements InputSig2 {
  private import TypeMention as TM

  class TypeMention = TM::TypeMention;

  TypeMention getABaseTypeMention(Type t) { result = t.getABaseTypeMention() }
}

private module M2 = Make2<Input2>;

private import M2

module Consistency = M2::Consistency;

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
private Type inferAnnotatedType(AstNode n, TypePath path) {
  result = getTypeAnnotation(n).resolveTypeAt(path)
}

/**
 * Holds if the type of `n1` at `path1` is the same as the type of `n2` at
 * `path2` and type information should propagate in both directions through the
 * type equality.
 */
bindingset[path1]
bindingset[path2]
private predicate typeEquality(AstNode n1, TypePath path1, AstNode n2, TypePath path2) {
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
  n2 =
    any(PrefixExpr pe |
      pe.getOperatorName() = "*" and
      pe.getExpr() = n1 and
      path1 = TypePath::cons(TRefTypeParameter(), path2)
    )
  or
  n1 = n2.(ParenExpr).getExpr() and
  path1 = path2
  or
  n1 = n2.(BlockExpr).getStmtList().getTailExpr() and
  path1 = path2
  or
  n1 = n2.(IfExpr).getABranch() and
  path1 = path2
  or
  n1 = n2.(MatchExpr).getAnArm().getExpr() and
  path1 = path2
  or
  exists(BreakExpr break |
    break.getExpr() = n1 and
    break.getTarget() = n2.(LoopExpr) and
    path1 = path2
  )
}

pragma[nomagic]
private Type inferTypeEquality(AstNode n, TypePath path) {
  exists(AstNode n2, TypePath path2 | result = inferType(n2, path2) |
    typeEquality(n, path, n2, path2)
    or
    typeEquality(n2, path2, n, path)
  )
}

/**
 * Gets the type of the implicitly typed `self` parameter, taking into account
 * whether the parameter is passed by value or by reference.
 */
bindingset[self, suffix, t]
pragma[inline_late]
private Type getRefAdjustImplicitSelfType(SelfParam self, TypePath suffix, Type t, TypePath path) {
  not self.hasTypeRepr() and
  (
    if self.isRef()
    then
      // `fn f(&self, ...)`
      path.isEmpty() and
      result = TRefType()
      or
      path = TypePath::cons(TRefTypeParameter(), suffix) and
      result = t
    else (
      // `fn f(self, ...)`
      path = suffix and
      result = t
    )
  )
}

pragma[nomagic]
private Type inferImplSelfType(Impl i, TypePath path) {
  result = i.getSelfTy().(TypeReprMention).resolveTypeAt(path)
}

pragma[nomagic]
private Type inferTraitSelfType(Trait t, TypePath path) {
  result = TTrait(t) and
  path.isEmpty()
  or
  result = TTypeParamTypeParameter(t.getGenericParamList().getATypeParam()) and
  path = TypePath::singleton(result)
}

/** Gets the type at `path` of the implicitly typed `self` parameter. */
pragma[nomagic]
private Type inferImplicitSelfType(SelfParam self, TypePath path) {
  exists(ImplOrTraitItemNode i, Function f, TypePath suffix, Type t |
    f = i.getAnAssocItem() and
    self = f.getParamList().getSelfParam() and
    result = getRefAdjustImplicitSelfType(self, suffix, t, path)
  |
    t = inferImplSelfType(i, suffix)
    or
    t = inferTraitSelfType(i, suffix)
  )
}

/**
 * Gets any of the types mentioned in `path` that corresponds to the type
 * parameter `tp`.
 */
private TypeMention getExplicitTypeArgMention(Path path, TypeParam tp) {
  exists(int i |
    result = path.getPart().getGenericArgList().getTypeArg(pragma[only_bind_into](i)) and
    tp = resolvePath(path).getTypeParam(pragma[only_bind_into](i))
  )
  or
  result = getExplicitTypeArgMention(path.getQualifier(), tp)
}

/**
 * A matching configuration for resolving types of struct expressions
 * like `Foo { bar = baz }`.
 */
private module StructExprMatchingInput implements MatchingInputSig {
  private newtype TPos =
    TFieldPos(string name) { exists(any(Declaration decl).getField(name)) } or
    TStructPos()

  class DeclarationPosition extends TPos {
    string asFieldPos() { this = TFieldPos(result) }

    predicate isStructPos() { this = TStructPos() }

    string toString() {
      result = this.asFieldPos()
      or
      this.isStructPos() and
      result = "(struct)"
    }
  }

  abstract class Declaration extends AstNode {
    abstract TypeParam getATypeParam();

    final TypeParameter getTypeParameter(TypeParameterPosition ppos) {
      result.(TypeParamTypeParameter).getTypeParam() = ppos and
      ppos = this.getATypeParam()
    }

    abstract StructField getField(string name);

    Type getDeclaredType(DeclarationPosition dpos, TypePath path) {
      // type of a field
      exists(TypeReprMention tp |
        tp = this.getField(dpos.asFieldPos()).getTypeRepr() and
        result = tp.resolveTypeAt(path)
      )
      or
      // type parameter of the struct itself
      dpos.isStructPos() and
      result = this.getTypeParameter(_) and
      path = TypePath::singleton(result)
    }
  }

  private class StructDecl extends Declaration, Struct {
    StructDecl() { this.isStruct() }

    override TypeParam getATypeParam() { result = this.getGenericParamList().getATypeParam() }

    override StructField getField(string name) { result = this.getStructField(name) }

    override Type getDeclaredType(DeclarationPosition dpos, TypePath path) {
      result = super.getDeclaredType(dpos, path)
      or
      // type of the struct itself
      dpos.isStructPos() and
      path.isEmpty() and
      result = TStruct(this)
    }
  }

  private class StructVariantDecl extends Declaration, Variant {
    StructVariantDecl() { this.isStruct() }

    Enum getEnum() { result.getVariantList().getAVariant() = this }

    override TypeParam getATypeParam() {
      result = this.getEnum().getGenericParamList().getATypeParam()
    }

    override StructField getField(string name) { result = this.getStructField(name) }

    override Type getDeclaredType(DeclarationPosition dpos, TypePath path) {
      result = super.getDeclaredType(dpos, path)
      or
      // type of the enum itself
      dpos.isStructPos() and
      path.isEmpty() and
      result = TEnum(this.getEnum())
    }
  }

  class AccessPosition = DeclarationPosition;

  class Access extends StructExpr {
    Type getTypeArgument(TypeArgumentPosition apos, TypePath path) {
      result = getExplicitTypeArgMention(this.getPath(), apos.asTypeParam()).resolveTypeAt(path)
    }

    AstNode getNodeAt(AccessPosition apos) {
      result = this.getFieldExpr(apos.asFieldPos()).getExpr()
      or
      result = this and
      apos.isStructPos()
    }

    Type getInferredType(AccessPosition apos, TypePath path) {
      result = inferType(this.getNodeAt(apos), path)
    }

    Declaration getTarget() { result = resolvePath(this.getPath()) }
  }

  predicate accessDeclarationPositionMatch(AccessPosition apos, DeclarationPosition dpos) {
    apos = dpos
  }
}

private module StructExprMatching = Matching<StructExprMatchingInput>;

/**
 * Gets the type of `n` at `path`, where `n` is either a struct expression or
 * a field expression of a struct expression.
 */
pragma[nomagic]
private Type inferStructExprType(AstNode n, TypePath path) {
  exists(StructExprMatchingInput::Access a, StructExprMatchingInput::AccessPosition apos |
    n = a.getNodeAt(apos) and
    result = StructExprMatching::inferAccessType(a, apos, path)
  )
}

pragma[nomagic]
private Type inferPathExprType(PathExpr pe, TypePath path) {
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
      this.isSelf() and
      result = "self"
      or
      result = this.asPosition(_).toString()
      or
      this.isReturn() and
      result = "(return)"
    }
  }

  abstract class Declaration extends AstNode {
    abstract TypeParam getATypeParam();

    final TypeParameter getTypeParameter(TypeParameterPosition ppos) {
      result.(TypeParamTypeParameter).getTypeParam() = ppos and
      ppos = this.getATypeParam()
    }

    pragma[nomagic]
    abstract Type getParameterType(DeclarationPosition dpos, TypePath path);

    abstract Type getReturnType(TypePath path);

    final Type getDeclaredType(DeclarationPosition dpos, TypePath path) {
      result = this.getParameterType(dpos, path)
      or
      dpos.isReturn() and
      result = this.getReturnType(path)
    }
  }

  private class TupleStructDecl extends Declaration, Struct {
    TupleStructDecl() { this.isTuple() }

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
      path = TypePath::singleton(result)
    }
  }

  private class TupleVariantDecl extends Declaration, Variant {
    TupleVariantDecl() { this.isTuple() }

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
        path = TypePath::singleton(result)
      )
    }
  }

  pragma[nomagic]
  private Type inferAnnotatedTypeInclSelf(AstNode n, TypePath path) {
    result = getTypeAnnotation(n).resolveTypeAtInclSelf(path)
  }

  private class FunctionDecl extends Declaration, Function {
    override TypeParam getATypeParam() { result = this.getGenericParamList().getATypeParam() }

    override Type getParameterType(DeclarationPosition dpos, TypePath path) {
      exists(Param p, int i, boolean inMethod |
        paramPos(this.getParamList(), p, i, inMethod) and
        dpos = TPositionalDeclarationPosition(i, inMethod) and
        result = inferAnnotatedTypeInclSelf(p.getPat(), path)
      )
      or
      exists(SelfParam self |
        self = pragma[only_bind_into](this.getParamList().getSelfParam()) and
        dpos.isSelf()
      |
        // `self` parameter with type annotation
        result = inferAnnotatedTypeInclSelf(self, path)
        or
        // `self` parameter without type annotation
        result = inferImplicitSelfType(self, path)
        or
        // `self` parameter without type annotation should also have the special `Self` type
        result = getRefAdjustImplicitSelfType(self, TypePath::nil(), TSelfTypeParameter(), path)
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
      this.isSelf() and
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
      result = this.(MethodCallExpr).getGenericArgList().getTypeArg(i)
    }

    Type getTypeArgument(TypeArgumentPosition apos, TypePath path) {
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

    Type getInferredType(AccessPosition apos, TypePath path) {
      result = inferType(this.getNodeAt(apos), path)
    }

    Declaration getTarget() {
      result = CallExprImpl::getResolvedFunction(this)
      or
      result = resolveMethodCallExpr(this) // mutual recursion; resolving method calls requires resolving types and vice versa
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
    apos.isReturn() and
    dpos.isReturn()
  }

  bindingset[apos, target, path, t]
  pragma[inline_late]
  predicate adjustAccessType(
    AccessPosition apos, Declaration target, TypePath path, Type t, TypePath pathAdj, Type tAdj
  ) {
    if apos.isSelf()
    then
      exists(Type selfParamType |
        selfParamType = target.getParameterType(TSelfDeclarationPosition(), TypePath::nil())
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
            pathAdj = TypePath::singleton(TRefTypeParameter()) and
            tAdj = t
          else
            if path.isCons(TRefTypeParameter(), _)
            then
              pathAdj = path and
              tAdj = t
            else (
              // adjust for implicit borrow
              not (t = TRefType() and path.isEmpty()) and
              pathAdj = TypePath::cons(TRefTypeParameter(), path) and
              tAdj = t
            )
        else (
          // adjust for implicit deref
          path.isCons(TRefTypeParameter(), pathAdj) and
          tAdj = t
          or
          not path.isCons(TRefTypeParameter(), _) and
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
  additional Type inferReceiverType(AstNode n) {
    exists(Access a, AccessPosition apos |
      result = inferType(n) and
      n = a.getNodeAt(apos) and
      apos.isSelf()
    )
  }
}

private module CallExprBaseMatching = Matching<CallExprBaseMatchingInput>;

/**
 * Gets the type of `n` at `path`, where `n` is either a call or an
 * argument/receiver of a call.
 */
pragma[nomagic]
private Type inferCallExprBaseType(AstNode n, TypePath path) {
  exists(
    CallExprBaseMatchingInput::Access a, CallExprBaseMatchingInput::AccessPosition apos,
    TypePath path0
  |
    n = a.getNodeAt(apos) and
    result = CallExprBaseMatching::inferAccessType(a, apos, path0)
  |
    if apos.isSelf()
    then
      exists(Type receiverType | receiverType = CallExprBaseMatchingInput::inferReceiverType(n) |
        if receiverType = TRefType()
        then
          path = path0 and
          path0.isCons(TRefTypeParameter(), _)
          or
          // adjust for implicit deref
          not path0.isCons(TRefTypeParameter(), _) and
          not (path0.isEmpty() and result = TRefType()) and
          path = TypePath::cons(TRefTypeParameter(), path0)
        else (
          not path0.isCons(TRefTypeParameter(), _) and
          not (path0.isEmpty() and result = TRefType()) and
          path = path0
          or
          // adjust for implicit borrow
          path0.isCons(TRefTypeParameter(), path)
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
      exists(Struct s | s.getStructField(_) = this or s.getTupleField(_) = this |
        result = TStruct(s) and
        path.isEmpty()
        or
        result = TTypeParamTypeParameter(s.getGenericParamList().getATypeParam()) and
        path = TypePath::singleton(result)
      )
      or
      dpos.isField() and
      result = this.getTypeRepr().(TypeReprMention).resolveTypeAt(path)
    }
  }

  private class StructFieldDecl extends Declaration instanceof StructField {
    override TypeRepr getTypeRepr() { result = StructField.super.getTypeRepr() }
  }

  private class TupleFieldDecl extends Declaration instanceof TupleField {
    override TypeRepr getTypeRepr() { result = TupleField.super.getTypeRepr() }
  }

  class AccessPosition = DeclarationPosition;

  class Access extends FieldExpr {
    Type getTypeArgument(TypeArgumentPosition apos, TypePath path) { none() }

    AstNode getNodeAt(AccessPosition apos) {
      result = this.getExpr() and
      apos.isSelf()
      or
      result = this and
      apos.isField()
    }

    Type getInferredType(AccessPosition apos, TypePath path) {
      result = inferType(this.getNodeAt(apos), path)
    }

    Declaration getTarget() {
      // mutual recursion; resolving fields requires resolving types and vice versa
      result = [resolveStructFieldExpr(this).(AstNode), resolveTupleFieldExpr(this)]
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
      path.isCons(TRefTypeParameter(), pathAdj) and
      tAdj = t
      or
      not path.isCons(TRefTypeParameter(), _) and
      not (t = TRefType() and path.isEmpty()) and
      pathAdj = path and
      tAdj = t
    else (
      pathAdj = path and
      tAdj = t
    )
  }

  pragma[nomagic]
  additional Type inferReceiverType(AstNode n) {
    exists(Access a, AccessPosition apos |
      result = inferType(n) and
      n = a.getNodeAt(apos) and
      apos.isSelf()
    )
  }
}

private module FieldExprMatching = Matching<FieldExprMatchingInput>;

/**
 * Gets the type of `n` at `path`, where `n` is either a field expression or
 * the receiver of field expression call.
 */
pragma[nomagic]
private Type inferFieldExprType(AstNode n, TypePath path) {
  exists(
    FieldExprMatchingInput::Access a, FieldExprMatchingInput::AccessPosition apos, TypePath path0
  |
    n = a.getNodeAt(apos) and
    result = FieldExprMatching::inferAccessType(a, apos, path0)
  |
    if apos.isSelf()
    then
      exists(Type receiverType | receiverType = FieldExprMatchingInput::inferReceiverType(n) |
        if receiverType = TRefType()
        then
          // adjust for implicit deref
          not path0.isCons(TRefTypeParameter(), _) and
          not (path0.isEmpty() and result = TRefType()) and
          path = TypePath::cons(TRefTypeParameter(), path0)
        else path = path0
      )
    else path = path0
  )
}

/**
 * Gets the type of `n` at `path`, where `n` is either a reference expression
 * `& x` or an expression `x` inside a reference expression `& x`.
 */
pragma[nomagic]
private Type inferRefExprType(Expr e, TypePath path) {
  exists(RefExpr re |
    e = re and
    path.isEmpty() and
    result = TRefType()
    or
    e = re and
    exists(TypePath exprPath | result = inferType(re.getExpr(), exprPath) |
      if exprPath.isCons(TRefTypeParameter(), _)
      then
        // `&x` simply means `x` when `x` already has reference type
        path = exprPath
      else (
        path = TypePath::cons(TRefTypeParameter(), exprPath) and
        not (exprPath.isEmpty() and result = TRefType())
      )
    )
    or
    e = re.getExpr() and
    exists(TypePath exprPath, TypePath refPath, Type exprType |
      result = inferType(re, exprPath) and
      exprPath = TypePath::cons(TRefTypeParameter(), refPath) and
      exprType = inferType(e)
    |
      if exprType = TRefType()
      then
        // `&x` simply means `x` when `x` already has reference type
        path = exprPath
      else path = refPath
    )
  )
}

cached
private module Cached {
  private import codeql.rust.internal.CachedStages

  pragma[inline]
  private Type getLookupType(AstNode n) {
    exists(Type t |
      t = inferType(n) and
      if t = TRefType()
      then
        // for reference types, lookup members in the type being referenced
        result = inferType(n, TypePath::singleton(TRefTypeParameter()))
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
   * Gets the struct field that the field expression `fe` resolves to, if any.
   */
  cached
  StructField resolveStructFieldExpr(FieldExpr fe) {
    exists(string name | result = getFieldExprLookupType(fe, name).getStructField(name))
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
   * Gets a type at `path` that `n` infers to, if any.
   *
   * The type inference implementation works by computing all possible types, so
   * the result is not necessarily unique. For example, in
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
  Type inferType(AstNode n, TypePath path) {
    Stages::TypeInference::backref() and
    result = inferAnnotatedType(n, path)
    or
    result = inferTypeEquality(n, path)
    or
    result = inferImplicitSelfType(n, path)
    or
    result = inferStructExprType(n, path)
    or
    result = inferPathExprType(n, path)
    or
    result = inferCallExprBaseType(n, path)
    or
    result = inferFieldExprType(n, path)
    or
    result = inferRefExprType(n, path)
  }
}

import Cached

/**
 * Gets a type that `n` infers to, if any.
 */
Type inferType(AstNode n) { result = inferType(n, TypePath::nil()) }
