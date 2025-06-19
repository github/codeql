/** Provides functionality for inferring types. */

private import codeql.util.Boolean
private import rust
private import PathResolution
private import Type
private import Type as T
private import TypeMention
private import codeql.typeinference.internal.TypeInference
private import codeql.rust.frameworks.stdlib.Stdlib
private import codeql.rust.frameworks.stdlib.Builtins as Builtins
private import codeql.rust.elements.Call

class Type = T::Type;

private module Input1 implements InputSig1<Location> {
  private import Type as T
  private import codeql.rust.elements.internal.generated.Raw
  private import codeql.rust.elements.internal.generated.Synth

  class Type = T::Type;

  class TypeParameter = T::TypeParameter;

  class TypeAbstraction = T::TypeAbstraction;

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

  private newtype TTypeParameterPosition =
    TTypeParamTypeParameterPosition(TypeParam tp) or
    TImplicitTypeParameterPosition()

  class TypeParameterPosition extends TTypeParameterPosition {
    TypeParam asTypeParam() { this = TTypeParamTypeParameterPosition(result) }

    /**
     * Holds if this is the implicit type parameter position used to represent
     * parameters that are never passed explicitly as arguments.
     */
    predicate isImplicit() { this = TImplicitTypeParameterPosition() }

    string toString() {
      result = this.asTypeParam().toString()
      or
      result = "Implicit" and this.isImplicit()
    }
  }

  /** Holds if `typeParam`, `param` and `ppos` all concern the same `TypeParam`. */
  additional predicate typeParamMatchPosition(
    TypeParam typeParam, TypeParamTypeParameter param, TypeParameterPosition ppos
  ) {
    typeParam = param.getTypeParam() and typeParam = ppos.asTypeParam()
  }

  bindingset[apos]
  bindingset[ppos]
  predicate typeArgumentParameterPositionMatch(TypeArgumentPosition apos, TypeParameterPosition ppos) {
    apos.asTypeParam() = ppos.asTypeParam()
    or
    apos.asMethodTypeArgumentPosition() = ppos.asTypeParam().getPosition()
  }

  int getTypeParameterId(TypeParameter tp) {
    tp =
      rank[result](TypeParameter tp0, int kind, int id |
        tp0 instanceof ArrayTypeParameter and
        kind = 0 and
        id = 0
        or
        tp0 instanceof RefTypeParameter and
        kind = 0 and
        id = 1
        or
        tp0 instanceof SliceTypeParameter and
        kind = 0 and
        id = 2
        or
        kind = 1 and
        exists(AstNode node | id = idOfTypeParameterAstNode(node) |
          node = tp0.(TypeParamTypeParameter).getTypeParam() or
          node = tp0.(AssociatedTypeTypeParameter).getTypeAlias() or
          node = tp0.(SelfTypeParameter).getTrait() or
          node = tp0.(ImplTraitTypeTypeParameter).getImplTraitTypeRepr()
        )
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

  TypeMention getABaseTypeMention(Type t) { none() }

  TypeMention getATypeParameterConstraint(TypeParameter tp) {
    result = tp.(TypeParamTypeParameter).getTypeParam().getTypeBoundList().getABound().getTypeRepr()
    or
    result = tp.(SelfTypeParameter).getTrait()
    or
    result =
      tp.(ImplTraitTypeTypeParameter)
          .getImplTraitTypeRepr()
          .getTypeBoundList()
          .getABound()
          .getTypeRepr()
  }

  /**
   * Use the constraint mechanism in the shared type inference library to
   * support traits. In Rust `constraint` is always a trait.
   *
   * See the documentation of `conditionSatisfiesConstraint` in the shared type
   * inference module for more information.
   */
  predicate conditionSatisfiesConstraint(
    TypeAbstraction abs, TypeMention condition, TypeMention constraint
  ) {
    // `impl` blocks implementing traits
    exists(Impl impl |
      abs = impl and
      condition = impl.getSelfTy() and
      constraint = impl.getTrait()
    )
    or
    // supertraits
    exists(Trait trait |
      abs = trait and
      condition = trait and
      constraint = trait.getTypeBoundList().getABound().getTypeRepr()
    )
    or
    // trait bounds on type parameters
    exists(TypeParam param |
      abs = param.getTypeBoundList().getABound() and
      condition = param and
      constraint = abs.(TypeBound).getTypeRepr()
    )
    or
    // the implicit `Self` type parameter satisfies the trait
    exists(SelfTypeParameterMention self |
      abs = self and
      condition = self and
      constraint = self.getTrait()
    )
    or
    exists(ImplTraitTypeRepr impl |
      abs = impl and
      condition = impl and
      constraint = impl.getTypeBoundList().getABound().getTypeRepr()
    )
  }
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

private Type inferLogicalOperationType(AstNode n, TypePath path) {
  exists(Builtins::BuiltinType t, BinaryLogicalOperation be |
    n = [be, be.getLhs(), be.getRhs()] and
    path.isEmpty() and
    result = TStruct(t) and
    t instanceof Builtins::Bool
  )
}

private Type inferAssignmentOperationType(AstNode n, TypePath path) {
  n instanceof AssignmentOperation and
  path.isEmpty() and
  result = TUnit()
}

/**
 * Holds if the type tree of `n1` at `prefix1` should be equal to the type tree
 * of `n2` at `prefix2` and type information should propagate in both directions
 * through the type equality.
 */
private predicate typeEquality(AstNode n1, TypePath prefix1, AstNode n2, TypePath prefix2) {
  prefix1.isEmpty() and
  prefix2.isEmpty() and
  (
    exists(Variable v | n1 = v.getAnAccess() |
      n2 = v.getPat()
      or
      n2 = v.getParameter().(SelfParam)
    )
    or
    exists(LetStmt let |
      let.getPat() = n1 and
      let.getInitializer() = n2
    )
    or
    n1 = n2.(ParenExpr).getExpr()
    or
    n1 = n2.(IfExpr).getABranch()
    or
    n1 = n2.(MatchExpr).getAnArm().getExpr()
    or
    exists(BreakExpr break |
      break.getExpr() = n1 and
      break.getTarget() = n2.(LoopExpr)
    )
    or
    exists(AssignmentExpr be |
      n1 = be.getLhs() and
      n2 = be.getRhs()
    )
    or
    n1 = n2.(MacroExpr).getMacroCall().getMacroCallExpansion()
  )
  or
  n1 = n2.(RefExpr).getExpr() and
  prefix1.isEmpty() and
  prefix2 = TypePath::singleton(TRefTypeParameter())
  or
  n1 = n2.(DerefExpr).getExpr() and
  prefix1 = TypePath::singleton(TRefTypeParameter()) and
  prefix2.isEmpty()
  or
  exists(BlockExpr be |
    n1 = be and
    n2 = be.getStmtList().getTailExpr() and
    if be.isAsync()
    then
      prefix1 = TypePath::singleton(getFutureOutputTypeParameter()) and
      prefix2.isEmpty()
    else (
      prefix1.isEmpty() and
      prefix2.isEmpty()
    )
  )
}

pragma[nomagic]
private Type inferTypeEquality(AstNode n, TypePath path) {
  exists(TypePath prefix1, AstNode n2, TypePath prefix2, TypePath suffix |
    result = inferType(n2, prefix2.appendInverse(suffix)) and
    path = prefix1.append(suffix)
  |
    typeEquality(n, prefix1, n2, prefix2)
    or
    typeEquality(n2, prefix2, n, prefix1)
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
private Type resolveImplSelfType(Impl i, TypePath path) {
  result = i.getSelfTy().(TypeMention).resolveTypeAt(path)
}

/** Gets the type at `path` of the implicitly typed `self` parameter. */
pragma[nomagic]
private Type inferImplicitSelfType(SelfParam self, TypePath path) {
  exists(ImplOrTraitItemNode i, Function f, TypePath suffix, Type t |
    f = i.getAnAssocItem() and
    self = f.getParamList().getSelfParam() and
    result = getRefAdjustImplicitSelfType(self, suffix, t, path)
  |
    t = resolveImplSelfType(i, suffix)
    or
    t = TSelfTypeParameter(i) and suffix.isEmpty()
  )
}

/**
 * Gets any of the types mentioned in `path` that corresponds to the type
 * parameter `tp`.
 */
private TypeMention getExplicitTypeArgMention(Path path, TypeParam tp) {
  exists(int i |
    result = path.getSegment().getGenericArgList().getTypeArg(pragma[only_bind_into](i)) and
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
      typeParamMatchPosition(this.getATypeParam(), result, ppos)
    }

    abstract StructField getField(string name);

    Type getDeclaredType(DeclarationPosition dpos, TypePath path) {
      // type of a field
      exists(TypeMention tp |
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
  private predicate paramPos(ParamList pl, Param p, int pos) { p = pl.getParam(pos) }

  private newtype TDeclarationPosition =
    TArgumentDeclarationPosition(ArgumentPosition pos) or
    TReturnDeclarationPosition()

  class DeclarationPosition extends TDeclarationPosition {
    predicate isSelf() { this.asArgumentPosition().isSelf() }

    int asPosition() { result = this.asArgumentPosition().asPosition() }

    ArgumentPosition asArgumentPosition() { this = TArgumentDeclarationPosition(result) }

    predicate isReturn() { this = TReturnDeclarationPosition() }

    string toString() {
      result = this.asArgumentPosition().toString()
      or
      this.isReturn() and
      result = "(return)"
    }
  }

  abstract class Declaration extends AstNode {
    abstract TypeParameter getTypeParameter(TypeParameterPosition ppos);

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

    override TypeParameter getTypeParameter(TypeParameterPosition ppos) {
      typeParamMatchPosition(this.getGenericParamList().getATypeParam(), result, ppos)
    }

    override Type getParameterType(DeclarationPosition dpos, TypePath path) {
      exists(int pos |
        result = this.getTupleField(pos).getTypeRepr().(TypeMention).resolveTypeAt(path) and
        pos = dpos.asPosition()
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

    override TypeParameter getTypeParameter(TypeParameterPosition ppos) {
      typeParamMatchPosition(this.getEnum().getGenericParamList().getATypeParam(), result, ppos)
    }

    override Type getParameterType(DeclarationPosition dpos, TypePath path) {
      exists(int pos |
        result = this.getTupleField(pos).getTypeRepr().(TypeMention).resolveTypeAt(path) and
        pos = dpos.asPosition()
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

  private class FunctionDecl extends Declaration, Function {
    override TypeParameter getTypeParameter(TypeParameterPosition ppos) {
      typeParamMatchPosition(this.getGenericParamList().getATypeParam(), result, ppos)
      or
      exists(TraitItemNode trait | this = trait.getAnAssocItem() |
        typeParamMatchPosition(trait.getTypeParam(_), result, ppos)
        or
        ppos.isImplicit() and result = TSelfTypeParameter(trait)
        or
        ppos.isImplicit() and
        result.(AssociatedTypeTypeParameter).getTrait() = trait
      )
      or
      ppos.isImplicit() and
      this = result.(ImplTraitTypeTypeParameter).getFunction()
    }

    override Type getParameterType(DeclarationPosition dpos, TypePath path) {
      exists(Param p, int i |
        paramPos(this.getParamList(), p, i) and
        i = dpos.asPosition() and
        result = inferAnnotatedType(p.getPat(), path)
      )
      or
      exists(SelfParam self |
        self = pragma[only_bind_into](this.getParamList().getSelfParam()) and
        dpos.isSelf()
      |
        result = inferAnnotatedType(self, path) // `self` parameter with type annotation
        or
        result = inferImplicitSelfType(self, path) // `self` parameter without type annotation
      )
    }

    private Type resolveRetType(TypePath path) {
      result = this.getRetType().getTypeRepr().(TypeMention).resolveTypeAt(path)
    }

    override Type getReturnType(TypePath path) {
      if this.isAsync()
      then
        path.isEmpty() and
        result = getFutureTraitType()
        or
        exists(TypePath suffix |
          result = this.resolveRetType(suffix) and
          path = TypePath::cons(getFutureOutputTypeParameter(), suffix)
        )
      else result = this.resolveRetType(path)
    }
  }

  private newtype TAccessPosition =
    TArgumentAccessPosition(ArgumentPosition pos, Boolean borrowed) or
    TReturnAccessPosition()

  class AccessPosition extends TAccessPosition {
    ArgumentPosition getArgumentPosition() { this = TArgumentAccessPosition(result, _) }

    predicate isBorrowed() { this = TArgumentAccessPosition(_, true) }

    predicate isReturn() { this = TReturnAccessPosition() }

    string toString() {
      exists(ArgumentPosition pos, boolean borrowed |
        this = TArgumentAccessPosition(pos, borrowed) and
        result = pos + ":" + borrowed
      )
      or
      this.isReturn() and
      result = "(return)"
    }
  }

  private import codeql.rust.elements.internal.CallExprImpl::Impl as CallExprImpl

  final class Access extends Call {
    Type getTypeArgument(TypeArgumentPosition apos, TypePath path) {
      exists(TypeMention arg | result = arg.resolveTypeAt(path) |
        arg = getExplicitTypeArgMention(CallExprImpl::getFunctionPath(this), apos.asTypeParam())
        or
        arg =
          this.(MethodCallExpr).getGenericArgList().getTypeArg(apos.asMethodTypeArgumentPosition())
      )
    }

    AstNode getNodeAt(AccessPosition apos) {
      exists(ArgumentPosition pos, boolean borrowed |
        apos = TArgumentAccessPosition(pos, borrowed) and
        result = this.getArgument(pos) and
        if this.implicitBorrowAt(pos) then borrowed = true else borrowed = false
      )
      or
      result = this and apos.isReturn()
    }

    Type getInferredType(AccessPosition apos, TypePath path) {
      result = inferType(this.getNodeAt(apos), path)
    }

    Declaration getTarget() {
      result = inferMethodCallTarget(this) // mutual recursion; resolving method calls requires resolving types and vice versa
      or
      result = CallExprImpl::getResolvedFunction(this)
    }
  }

  predicate accessDeclarationPositionMatch(AccessPosition apos, DeclarationPosition dpos) {
    apos.getArgumentPosition() = dpos.asArgumentPosition()
    or
    apos.isReturn() and dpos.isReturn()
  }

  bindingset[apos, target, path, t]
  pragma[inline_late]
  predicate adjustAccessType(
    AccessPosition apos, Declaration target, TypePath path, Type t, TypePath pathAdj, Type tAdj
  ) {
    if apos.isBorrowed()
    then
      exists(Type selfParamType |
        selfParamType =
          target
              .getParameterType(TArgumentDeclarationPosition(apos.getArgumentPosition()),
                TypePath::nil())
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
    result = CallExprBaseMatching::inferAccessType(a, apos, path0) and
    if apos.isBorrowed()
    then
      exists(Type argType | argType = inferType(n) |
        if argType = TRefType()
        then
          path = path0 and
          path0.isCons(TRefTypeParameter(), _)
          or
          // adjust for implicit deref
          not path0.isCons(TRefTypeParameter(), _) and
          not (path0.isEmpty() and result = TRefType()) and
          path = TypePath::cons(TRefTypeParameter(), path0)
        else (
          not (
            argType.(StructType).asItemNode() instanceof StringStruct and
            result.(StructType).asItemNode() instanceof Builtins::Str
          ) and
          (
            not path0.isCons(TRefTypeParameter(), _) and
            not (path0.isEmpty() and result = TRefType()) and
            path = path0
            or
            // adjust for implicit borrow
            path0.isCons(TRefTypeParameter(), path)
          )
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
      result = this.getTypeRepr().(TypeMention).resolveTypeAt(path)
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
      result = this.getContainer() and
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
      exists(Type receiverType | receiverType = inferType(n) |
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

/** Gets the root type of the reference expression `re`. */
pragma[nomagic]
private Type inferRefExprType(RefExpr re) { exists(re) and result = TRefType() }

pragma[nomagic]
private Type inferTryExprType(TryExpr te, TypePath path) {
  exists(TypeParam tp, TypePath path0 |
    result = inferType(te.getExpr(), path0) and
    path0.isCons(TTypeParamTypeParameter(tp), path)
  |
    tp = any(ResultEnum r).getGenericParamList().getGenericParam(0)
    or
    tp = any(OptionEnum o).getGenericParamList().getGenericParam(0)
  )
}

pragma[nomagic]
private StructType inferLiteralType(LiteralExpr le) {
  exists(Builtins::BuiltinType t | result = TStruct(t) |
    le instanceof CharLiteralExpr and
    t instanceof Builtins::Char
    or
    le instanceof StringLiteralExpr and
    t instanceof Builtins::Str
    or
    le =
      any(NumberLiteralExpr ne |
        t.getName() = ne.getSuffix()
        or
        not exists(ne.getSuffix()) and
        (
          ne instanceof IntegerLiteralExpr and
          t instanceof Builtins::I32
          or
          ne instanceof FloatLiteralExpr and
          t instanceof Builtins::F64
        )
      )
    or
    le instanceof BooleanLiteralExpr and
    t instanceof Builtins::Bool
  )
}

pragma[nomagic]
private TraitType getFutureTraitType() { result.getTrait() instanceof FutureTrait }

pragma[nomagic]
private AssociatedTypeTypeParameter getFutureOutputTypeParameter() {
  result.getTypeAlias() = any(FutureTrait ft).getOutputType()
}

/**
 * A matching configuration for resolving types of `.await` expressions.
 */
private module AwaitExprMatchingInput implements MatchingInputSig {
  private newtype TDeclarationPosition =
    TSelfDeclarationPosition() or
    TOutputPos()

  class DeclarationPosition extends TDeclarationPosition {
    predicate isSelf() { this = TSelfDeclarationPosition() }

    predicate isOutput() { this = TOutputPos() }

    string toString() {
      this.isSelf() and
      result = "self"
      or
      this.isOutput() and
      result = "(output)"
    }
  }

  private class BuiltinsAwaitFile extends File {
    BuiltinsAwaitFile() {
      this.getBaseName() = "await.rs" and
      this.getParentContainer() instanceof Builtins::BuiltinsFolder
    }
  }

  class Declaration extends Function {
    Declaration() {
      this.getFile() instanceof BuiltinsAwaitFile and
      this.getName().getText() = "await_type_matching"
    }

    TypeParameter getTypeParameter(TypeParameterPosition ppos) {
      typeParamMatchPosition(this.getGenericParamList().getATypeParam(), result, ppos)
    }

    Type getDeclaredType(DeclarationPosition dpos, TypePath path) {
      dpos.isSelf() and
      result = this.getParam(0).getTypeRepr().(TypeMention).resolveTypeAt(path)
      or
      dpos.isOutput() and
      result = this.getRetType().getTypeRepr().(TypeMention).resolveTypeAt(path)
    }
  }

  class AccessPosition = DeclarationPosition;

  class Access extends AwaitExpr {
    Type getTypeArgument(TypeArgumentPosition apos, TypePath path) { none() }

    AstNode getNodeAt(AccessPosition apos) {
      result = this.getExpr() and
      apos.isSelf()
      or
      result = this and
      apos.isOutput()
    }

    Type getInferredType(AccessPosition apos, TypePath path) {
      result = inferType(this.getNodeAt(apos), path)
    }

    Declaration getTarget() { exists(this) and exists(result) }
  }

  predicate accessDeclarationPositionMatch(AccessPosition apos, DeclarationPosition dpos) {
    apos = dpos
  }
}

pragma[nomagic]
private TraitType inferAsyncBlockExprRootType(AsyncBlockExpr abe) {
  // `typeEquality` handles the non-root case
  exists(abe) and
  result = getFutureTraitType()
}

private module AwaitExprMatching = Matching<AwaitExprMatchingInput>;

pragma[nomagic]
private Type inferAwaitExprType(AstNode n, TypePath path) {
  exists(AwaitExprMatchingInput::Access a, AwaitExprMatchingInput::AccessPosition apos |
    n = a.getNodeAt(apos) and
    result = AwaitExprMatching::inferAccessType(a, apos, path)
  )
  or
  // This case is needed for `async` functions and blocks, where we assign
  // the type `Future<Output = T>` directly instead of `impl Future<Output = T>`
  //
  // TODO: It would be better if we could handle this in the shared library
  exists(TypePath exprPath |
    result = inferType(n.(AwaitExpr).getExpr(), exprPath) and
    exprPath.isCons(getFutureOutputTypeParameter(), path)
  )
}

private class Vec extends Struct {
  Vec() { this.getCanonicalPath() = "alloc::vec::Vec" }

  TypeParamTypeParameter getElementTypeParameter() {
    result.getTypeParam() = this.getGenericParamList().getTypeParam(0)
  }
}

/**
 * According to [the Rust reference][1]: _"array and slice-typed expressions
 * can be indexed with a `usize` index ... For other types an index expression
 * `a[b]` is equivalent to *std::ops::Index::index(&a, b)"_.
 *
 * The logic below handles array and slice indexing, but for other types it is
 * currently limited to `Vec`.
 *
 * [1]: https://doc.rust-lang.org/reference/expressions/array-expr.html#r-expr.array.index
 */
pragma[nomagic]
private Type inferIndexExprType(IndexExpr ie, TypePath path) {
  // TODO: Should be implemented as method resolution, using the special
  // `std::ops::Index` trait.
  exists(TypePath exprPath, Builtins::BuiltinType t |
    TStruct(t) = inferType(ie.getIndex()) and
    (
      // also allow `i32`, since that is currently the type that we infer for
      // integer literals like `0`
      t instanceof Builtins::I32
      or
      t instanceof Builtins::Usize
    ) and
    result = inferType(ie.getBase(), exprPath)
  |
    exprPath.isCons(any(Vec v).getElementTypeParameter(), path)
    or
    exprPath.isCons(any(ArrayTypeParameter tp), path)
    or
    exists(TypePath path0 |
      exprPath.isCons(any(RefTypeParameter tp), path0) and
      path0.isCons(any(SliceTypeParameter tp), path)
    )
  )
}

final class MethodCall extends Call {
  MethodCall() {
    exists(this.getReceiver()) and
    // We want the method calls that don't have a path to a concrete method in
    // an impl block. We need to exclude calls like `MyType::my_method(..)`.
    (this instanceof CallExpr implies exists(this.getTrait()))
  }

  /** Gets the type of the receiver of the method call at `path`. */
  Type getTypeAt(TypePath path) {
    if this.receiverImplicitlyBorrowed()
    then
      exists(TypePath path0, Type t0 |
        t0 = inferType(super.getReceiver(), path0) and
        (
          path0.isCons(TRefTypeParameter(), path)
          or
          path = path0
        )
      |
        result = t0
        or
        // We do not yet model the `Deref` trait, so we hard-code the fact that
        // `String` dereferences to `str` here. This allows us e.g. to resolve
        // `x.parse::<usize>()` to the function `<core::str>::parse` when `x` has
        // type `String`.
        //
        // See also https://doc.rust-lang.org/reference/expressions/method-call-expr.html#r-expr.method.autoref-deref
        path.isEmpty() and
        t0.(StructType).asItemNode() instanceof StringStruct and
        result.(StructType).asItemNode() instanceof Builtins::Str
      )
    else result = inferType(super.getReceiver(), path)
  }
}

/**
 * Holds if a method for `type` with the name `name` and the arity `arity`
 * exists in `impl`.
 */
pragma[nomagic]
private predicate methodCandidate(Type type, string name, int arity, Impl impl) {
  type = impl.getSelfTy().(TypeMention).resolveType() and
  exists(Function f |
    f = impl.(ImplItemNode).getASuccessor(name) and
    f.getParamList().hasSelfParam() and
    arity = f.getParamList().getNumberOfParams()
  )
}

/**
 * Holds if a method for `type` for `trait` with the name `name` and the arity
 * `arity` exists in `impl`.
 */
pragma[nomagic]
private predicate methodCandidateTrait(Type type, Trait trait, string name, int arity, Impl impl) {
  trait = resolvePath(impl.(ImplItemNode).getTraitPath()) and
  methodCandidate(type, name, arity, impl)
}

private module IsInstantiationOfInput implements IsInstantiationOfInputSig<MethodCall> {
  pragma[nomagic]
  private predicate isMethodCall(MethodCall mc, Type rootType, string name, int arity) {
    rootType = mc.getTypeAt(TypePath::nil()) and
    name = mc.getMethodName() and
    arity = mc.getNumberOfArguments()
  }

  pragma[nomagic]
  predicate potentialInstantiationOf(MethodCall mc, TypeAbstraction impl, TypeMention constraint) {
    exists(Type rootType, string name, int arity |
      isMethodCall(mc, rootType, name, arity) and
      constraint = impl.(ImplTypeAbstraction).getSelfTy()
    |
      methodCandidateTrait(rootType, mc.getTrait(), name, arity, impl)
      or
      not exists(mc.getTrait()) and
      methodCandidate(rootType, name, arity, impl)
    )
  }

  predicate relevantTypeMention(TypeMention constraint) {
    exists(Impl impl | methodCandidate(_, _, _, impl) and constraint = impl.getSelfTy())
  }
}

bindingset[item, name]
pragma[inline_late]
private Function getMethodSuccessor(ItemNode item, string name) {
  result = item.getASuccessor(name)
}

bindingset[tp, name]
pragma[inline_late]
private Function getTypeParameterMethod(TypeParameter tp, string name) {
  result = getMethodSuccessor(tp.(TypeParamTypeParameter).getTypeParam(), name)
  or
  result = getMethodSuccessor(tp.(SelfTypeParameter).getTrait(), name)
  or
  result = getMethodSuccessor(tp.(ImplTraitTypeTypeParameter).getImplTraitTypeRepr(), name)
}

bindingset[t1, t2]
private predicate typeMentionEqual(TypeMention t1, TypeMention t2) {
  forex(TypePath path, Type type | t1.resolveTypeAt(path) = type | t2.resolveTypeAt(path) = type)
}

pragma[nomagic]
private predicate implSiblingCandidate(
  Impl impl, TraitItemNode trait, Type rootType, TypeMention selfTy
) {
  trait = impl.(ImplItemNode).resolveTraitTy() and
  // If `impl` has an expansion from a macro attribute, then it's been
  // superseded by the output of the expansion (and usually the expansion
  // contains the same `impl` block so considering both would give spurious
  // siblings).
  not exists(impl.getAttributeMacroExpansion()) and
  // We use this for resolving methods, so exclude traits that do not have methods.
  exists(Function f | f = trait.getASuccessor(_) and f.getParamList().hasSelfParam()) and
  selfTy = impl.getSelfTy() and
  rootType = selfTy.resolveType()
}

/**
 * Holds if `impl1` and `impl2` are a sibling implementations of `trait`. We
 * consider implementations to be siblings if they implement the same trait for
 * the same type. In that case `Self` is the same type in both implementations,
 * and method calls to the implementations cannot be resolved unambiguously
 * based only on the receiver type.
 */
pragma[inline]
private predicate implSiblings(TraitItemNode trait, Impl impl1, Impl impl2) {
  exists(Type rootType, TypeMention selfTy1, TypeMention selfTy2 |
    impl1 != impl2 and
    implSiblingCandidate(impl1, trait, rootType, selfTy1) and
    implSiblingCandidate(impl2, trait, rootType, selfTy2) and
    // In principle the second conjunct below should be superflous, but we still
    // have ill-formed type mentions for types that we don't understand. For
    // those checking both directions restricts further. Note also that we check
    // syntactic equality, whereas equality up to renaming would be more
    // correct.
    typeMentionEqual(selfTy1, selfTy2) and
    typeMentionEqual(selfTy2, selfTy1)
  )
}

/**
 * Holds if `impl` is an implementation of `trait` and if another implementation
 * exists for the same type.
 */
pragma[nomagic]
private predicate implHasSibling(Impl impl, Trait trait) { implSiblings(trait, impl, _) }

/**
 * Holds if a type parameter of `trait` occurs in the method with the name
 * `methodName` at the `pos`th parameter at `path`.
 */
bindingset[trait]
pragma[inline_late]
private predicate traitTypeParameterOccurrence(
  TraitItemNode trait, string methodName, int pos, TypePath path
) {
  exists(Function f | f = trait.getASuccessor(methodName) |
    f.getParam(pos).getTypeRepr().(TypeMention).resolveTypeAt(path) =
      trait.(TraitTypeAbstraction).getATypeParameter()
  )
}

bindingset[f, pos, path]
pragma[inline_late]
private predicate methodTypeAtPath(Function f, int pos, TypePath path, Type type) {
  f.getParam(pos).getTypeRepr().(TypeMention).resolveTypeAt(path) = type
}

/**
 * Holds if resolving the method `f` in `impl` with the name `methodName`
 * requires inspecting the types of applied _arguments_ in order to determine
 * whether it is the correct resolution.
 */
pragma[nomagic]
private predicate methodResolutionDependsOnArgument(
  Impl impl, string methodName, Function f, int pos, TypePath path, Type type
) {
  /*
   * As seen in the example below, when an implementation has a sibling for a
   * trait we find occurrences of a type parameter of the trait in a method
   * signature in the trait. We then find the type given in the implementation
   * at the same position, which is a position that might disambiguate the
   * method from its siblings.
   *
   * ```rust
   * trait MyTrait<T> {
   *     fn method(&self, value: Foo<T>) -> Self;
   * //                   ^^^^^^^^^^^^^ `pos` = 0
   * //                              ^ `path` = "T"
   * }
   * impl MyAdd<i64> for i64 {
   *     fn method(&self, value: Foo<i64>) -> Self { ... }
   * //                              ^^^ `type` = i64
   * }
   * ```
   *
   * Note that we only check the root type symbol at the position. If the type
   * at that position is a type constructor (for instance `Vec<..>`) then
   * inspecting the entire type tree could be necessary to disambiguate the
   * method. In that case we will still resolve several methods.
   */

  exists(TraitItemNode trait |
    implHasSibling(impl, trait) and
    traitTypeParameterOccurrence(trait, methodName, pos, path) and
    methodTypeAtPath(getMethodSuccessor(impl, methodName), pos, path, type) and
    f = getMethodSuccessor(impl, methodName)
  )
}

/** Gets a method from an `impl` block that matches the method call `mc`. */
private Function getMethodFromImpl(MethodCall mc) {
  exists(Impl impl |
    IsInstantiationOf<MethodCall, IsInstantiationOfInput>::isInstantiationOf(mc, impl, _) and
    result = getMethodSuccessor(impl, mc.getMethodName())
  |
    not methodResolutionDependsOnArgument(impl, _, _, _, _, _) and
    result = getMethodSuccessor(impl, mc.getMethodName())
    or
    exists(int pos, TypePath path, Type type |
      methodResolutionDependsOnArgument(impl, mc.getMethodName(), result, pos, path, type) and
      inferType(mc.getPositionalArgument(pos), path) = type
    )
  )
}

bindingset[trait, name]
pragma[inline_late]
private Function getTraitMethod(ImplTraitReturnType trait, string name) {
  result = getMethodSuccessor(trait.getImplTraitTypeRepr(), name)
}

/**
 * Gets a method that the method call `mc` resolves to based on type inference,
 * if any.
 */
private Function inferMethodCallTarget(MethodCall mc) {
  // The method comes from an `impl` block targeting the type of the receiver.
  result = getMethodFromImpl(mc)
  or
  // The type of the receiver is a type parameter and the method comes from a
  // trait bound on the type parameter.
  result = getTypeParameterMethod(mc.getTypeAt(TypePath::nil()), mc.getMethodName())
  or
  // The type of the receiver is an `impl Trait` type.
  result = getTraitMethod(mc.getTypeAt(TypePath::nil()), mc.getMethodName())
}

cached
private module Cached {
  private import codeql.rust.internal.CachedStages

  /** Holds if `receiver` is the receiver of a method call with an implicit dereference. */
  cached
  predicate receiverHasImplicitDeref(AstNode receiver) {
    exists(CallExprBaseMatchingInput::Access a, CallExprBaseMatchingInput::AccessPosition apos |
      apos.getArgumentPosition().isSelf() and
      apos.isBorrowed() and
      receiver = a.getNodeAt(apos) and
      inferType(receiver) = TRefType() and
      CallExprBaseMatching::inferAccessType(a, apos, TypePath::nil()) != TRefType()
    )
  }

  /** Holds if `receiver` is the receiver of a method call with an implicit borrow. */
  cached
  predicate receiverHasImplicitBorrow(AstNode receiver) {
    exists(CallExprBaseMatchingInput::Access a, CallExprBaseMatchingInput::AccessPosition apos |
      apos.getArgumentPosition().isSelf() and
      apos.isBorrowed() and
      receiver = a.getNodeAt(apos) and
      CallExprBaseMatching::inferAccessType(a, apos, TypePath::nil()) = TRefType() and
      inferType(receiver) != TRefType()
    )
  }

  private predicate isInherentImplFunction(Function f) {
    f = any(Impl impl | not impl.hasTrait()).(ImplItemNode).getAnAssocItem()
  }

  private predicate isTraitImplFunction(Function f) {
    f = any(Impl impl | impl.hasTrait()).(ImplItemNode).getAnAssocItem()
  }

  private Function resolveMethodCallTargetFrom(MethodCall mc, boolean fromSource) {
    result = inferMethodCallTarget(mc) and
    (if result.fromSource() then fromSource = true else fromSource = false) and
    (
      // prioritize inherent implementation methods first
      isInherentImplFunction(result)
      or
      not isInherentImplFunction(inferMethodCallTarget(mc)) and
      (
        // then trait implementation methods
        isTraitImplFunction(result)
        or
        not isTraitImplFunction(inferMethodCallTarget(mc)) and
        (
          // then trait methods with default implementations
          result.hasBody()
          or
          // and finally trait methods without default implementations
          not inferMethodCallTarget(mc).hasBody()
        )
      )
    )
  }

  /** Gets a method that the method call `mc` resolves to, if any. */
  cached
  Function resolveMethodCallTarget(MethodCall mc) {
    // Functions in source code also gets extracted as library code, due to
    // this duplication we prioritize functions from source code.
    result = resolveMethodCallTargetFrom(mc, true)
    or
    not exists(resolveMethodCallTargetFrom(mc, true)) and
    result = resolveMethodCallTargetFrom(mc, false)
  }

  pragma[inline]
  private Type inferRootTypeDeref(AstNode n) {
    result = inferType(n) and
    result != TRefType()
    or
    // for reference types, lookup members in the type being referenced
    result = inferType(n, TypePath::singleton(TRefTypeParameter()))
  }

  pragma[nomagic]
  private Type getFieldExprLookupType(FieldExpr fe, string name) {
    result = inferRootTypeDeref(fe.getContainer()) and name = fe.getIdentifier().getText()
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
    Stages::TypeInferenceStage::ref() and
    result = inferAnnotatedType(n, path)
    or
    result = inferLogicalOperationType(n, path)
    or
    result = inferAssignmentOperationType(n, path)
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
    result = inferRefExprType(n) and
    path.isEmpty()
    or
    result = inferTryExprType(n, path)
    or
    result = inferLiteralType(n) and
    path.isEmpty()
    or
    result = inferAsyncBlockExprRootType(n) and
    path.isEmpty()
    or
    result = inferAwaitExprType(n, path)
    or
    result = inferIndexExprType(n, path)
  }
}

import Cached

/**
 * Gets a type that `n` infers to, if any.
 */
Type inferType(AstNode n) { result = inferType(n, TypePath::nil()) }

/** Provides predicates for debugging the type inference implementation. */
private module Debug {
  private Locatable getRelevantLocatable() {
    exists(string filepath, int startline, int startcolumn, int endline, int endcolumn |
      result.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) and
      filepath.matches("%/sqlx.rs") and
      startline = [56 .. 60]
    )
  }

  Type debugInferType(AstNode n, TypePath path) {
    n = getRelevantLocatable() and
    result = inferType(n, path)
  }

  Function debugResolveMethodCallTarget(Call mce) {
    mce = getRelevantLocatable() and
    result = resolveMethodCallTarget(mce)
  }

  predicate debugTypeMention(TypeMention tm, TypePath path, Type type) {
    tm = getRelevantLocatable() and
    tm.resolveTypeAt(path) = type
  }

  pragma[nomagic]
  private int countTypes(AstNode n, TypePath path, Type t) {
    t = inferType(n, path) and
    result = strictcount(Type t0 | t0 = inferType(n, path))
  }

  predicate maxTypes(AstNode n, TypePath path, Type t, int c) {
    c = countTypes(n, path, t) and
    c = max(countTypes(_, _, _))
  }
}
