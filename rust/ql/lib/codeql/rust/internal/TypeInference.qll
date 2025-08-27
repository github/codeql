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
private import codeql.rust.elements.internal.CallImpl::Impl as CallImpl
private import codeql.rust.elements.internal.CallExprImpl::Impl as CallExprImpl

class Type = T::Type;

private newtype TTypeArgumentPosition =
  // method type parameters are matched by position instead of by type
  // parameter entity, to avoid extra recursion through method call resolution
  TMethodTypeArgumentPosition(int pos) {
    exists(any(MethodCallExpr mce).getGenericArgList().getTypeArg(pos))
  } or
  TTypeParamTypeArgumentPosition(TypeParam tp)

private module Input1 implements InputSig1<Location> {
  private import Type as T
  private import codeql.rust.elements.internal.generated.Raw
  private import codeql.rust.elements.internal.generated.Synth

  class Type = T::Type;

  class TypeParameter = T::TypeParameter;

  class TypeAbstraction = T::TypeAbstraction;

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
      rank[result](TypeParameter tp0, int kind, int id1, int id2 |
        tp0 instanceof ArrayTypeParameter and
        kind = 0 and
        id1 = 0 and
        id2 = 0
        or
        tp0 instanceof RefTypeParameter and
        kind = 0 and
        id1 = 0 and
        id2 = 1
        or
        tp0 instanceof SliceTypeParameter and
        kind = 0 and
        id1 = 0 and
        id2 = 2
        or
        kind = 1 and
        id1 = 0 and
        id2 =
          idOfTypeParameterAstNode([
              tp0.(DynTraitTypeParameter).getTypeParam().(AstNode),
              tp0.(DynTraitTypeParameter).getTypeAlias()
            ])
        or
        kind = 2 and
        id1 = idOfTypeParameterAstNode(tp0.(ImplTraitTypeParameter).getImplTraitTypeRepr()) and
        id2 = idOfTypeParameterAstNode(tp0.(ImplTraitTypeParameter).getTypeParam())
        or
        kind = 3 and
        id1 = 0 and
        exists(AstNode node | id2 = idOfTypeParameterAstNode(node) |
          node = tp0.(TypeParamTypeParameter).getTypeParam() or
          node = tp0.(AssociatedTypeTypeParameter).getTypeAlias() or
          node = tp0.(SelfTypeParameter).getTrait() or
          node = tp0.(ImplTraitTypeTypeParameter).getImplTraitTypeRepr()
        )
        or
        kind = 4 and
        id1 = tp0.(TupleTypeParameter).getTupleType().getArity() and
        id2 = tp0.(TupleTypeParameter).getIndex()
      |
        tp0 order by kind, id1, id2
      )
  }

  int getTypePathLimit() { result = 10 }
}

private import Input1

private module M1 = Make1<Location, Input1>;

private import M1

predicate getTypePathLimit = Input1::getTypePathLimit/0;

class TypePath = M1::TypePath;

module TypePath = M1::TypePath;

private module Input2 implements InputSig2 {
  private import TypeMention as TM

  class TypeMention = TM::TypeMention;

  TypeMention getABaseTypeMention(Type t) { none() }

  TypeMention getATypeParameterConstraint(TypeParameter tp) {
    result = tp.(TypeParamTypeParameter).getTypeParam().getATypeBound().getTypeRepr()
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
      constraint = trait.getATypeBound().getTypeRepr()
    )
    or
    // trait bounds on type parameters
    exists(TypeParam param |
      abs = param.getATypeBound() and
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
    or
    // a `dyn Trait` type implements `Trait`. See the comment on
    // `DynTypeBoundListMention` for further details.
    exists(DynTraitTypeRepr object |
      abs = object and
      condition = object.getTypeBoundList() and
      constraint = object.getTrait()
    )
  }
}

private module M2 = Make2<Input2>;

private import M2

module Consistency {
  import M2::Consistency

  predicate nonUniqueCertainType(AstNode n, TypePath path, Type t) {
    strictcount(CertainTypeInference::inferCertainType(n, path)) > 1 and
    t = CertainTypeInference::inferCertainType(n, path)
  }
}

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

/** Module for inferring certain type information. */
private module CertainTypeInference {
  pragma[nomagic]
  private predicate callResolvesTo(CallExpr ce, Path p, Function f) {
    p = CallExprImpl::getFunctionPath(ce) and
    f = resolvePath(p)
  }

  pragma[nomagic]
  private Type getCallExprType(
    CallExpr ce, Path p, CallExprBaseMatchingInput::FunctionDecl f, TypePath tp
  ) {
    callResolvesTo(ce, p, f) and
    result = f.getReturnType(tp)
  }

  pragma[nomagic]
  private Type getCertainCallExprType(CallExpr ce, Path p, TypePath tp) {
    forex(Function f | callResolvesTo(ce, p, f) | result = getCallExprType(ce, p, f, tp))
  }

  pragma[nomagic]
  private TypePath getPathToImplSelfTypeParam(TypeParam tp) {
    exists(ImplItemNode impl |
      tp = impl.getTypeParam(_) and
      TTypeParamTypeParameter(tp) = impl.(Impl).getSelfTy().(TypeMention).resolveTypeAt(result)
    )
  }

  pragma[nomagic]
  Type inferCertainCallExprType(CallExpr ce, TypePath path) {
    exists(Type ty, TypePath prefix, Path p | ty = getCertainCallExprType(ce, p, prefix) |
      exists(TypePath suffix, TypeParam tp |
        tp = ty.(TypeParamTypeParameter).getTypeParam() and
        path = prefix.append(suffix)
      |
        // For type parameters of the `impl` block we must resolve their
        // instantiation from the path. For instance, for `impl<A> for Foo<A>`
        // and the path `Foo<i64>::bar` we must resolve `A` to `i64`.
        exists(TypePath pathToTp |
          pathToTp = getPathToImplSelfTypeParam(tp) and
          result = p.getQualifier().(TypeMention).resolveTypeAt(pathToTp.appendInverse(suffix))
        )
        or
        // For type parameters of the function we must resolve their
        // instantiation from the path. For instance, for `fn bar<A>(a: A) -> A`
        // and the path `bar<i64>`, we must resolve `A` to `i64`.
        result =
          ce.(CallExprBaseMatchingInput::Access)
              .getTypeArgument(TTypeParamTypeArgumentPosition(tp), suffix)
      )
      or
      not ty instanceof TypeParameter and
      result = ty and
      path = prefix
    )
  }

  predicate certainTypeEquality(AstNode n1, TypePath prefix1, AstNode n2, TypePath prefix2) {
    prefix1.isEmpty() and
    prefix2.isEmpty() and
    (
      exists(Variable v | n1 = v.getAnAccess() |
        n2 = v.getPat().getName() or n2 = v.getParameter().(SelfParam)
      )
      or
      // A `let` statement with a type annotation is a coercion site and hence
      // is not a certain type equality.
      exists(LetStmt let | not let.hasTypeRepr() |
        let.getPat() = n1 and
        let.getInitializer() = n2
      )
      or
      exists(LetExpr let |
        let.getPat() = n1 and
        let.getScrutinee() = n2
      )
      or
      n1 = n2.(ParenExpr).getExpr()
    )
    or
    n1 =
      any(IdentPat ip |
        n2 = ip.getName() and
        prefix1.isEmpty() and
        if ip.isRef() then prefix2 = TypePath::singleton(TRefTypeParameter()) else prefix2.isEmpty()
      )
  }

  pragma[nomagic]
  private Type inferCertainTypeEquality(AstNode n, TypePath path) {
    exists(TypePath prefix1, AstNode n2, TypePath prefix2, TypePath suffix |
      result = inferCertainType(n2, prefix2.appendInverse(suffix)) and
      path = prefix1.append(suffix)
    |
      certainTypeEquality(n, prefix1, n2, prefix2)
      or
      certainTypeEquality(n2, prefix2, n, prefix1)
    )
  }

  /**
   * Holds if `n` has complete and certain type information and if `n` has the
   * resulting type at `path`.
   */
  pragma[nomagic]
  Type inferCertainType(AstNode n, TypePath path) {
    exists(TypeMention tm |
      tm = getTypeAnnotation(n) and
      result = tm.resolveTypeAt(path)
    )
    or
    result = inferCertainCallExprType(n, path)
    or
    result = inferCertainTypeEquality(n, path)
    or
    result = inferLiteralType(n, path, true)
    or
    result = inferRefNodeType(n) and
    path.isEmpty()
    or
    result = inferTupleRootType(n) and
    path.isEmpty()
    or
    result = inferAsyncBlockExprRootType(n) and
    path.isEmpty()
    or
    result = inferArrayExprType(n) and
    path.isEmpty()
    or
    result = inferCastExprType(n, path)
    or
    infersCertainTypeAt(n, path, result.getATypeParameter())
  }

  /**
   * Holds if `n` has complete and certain type information at the type path
   * `prefix.tp`. This entails that the type at `prefix` must be the type
   * that declares `tp`.
   */
  pragma[nomagic]
  private predicate infersCertainTypeAt(AstNode n, TypePath prefix, TypeParameter tp) {
    exists(TypePath path |
      exists(inferCertainType(n, path)) and
      path.isSnoc(prefix, tp)
    )
  }

  /**
   * Holds if `n` has complete and certain type information at _some_ type path.
   */
  pragma[nomagic]
  predicate hasInferredCertainType(AstNode n) { exists(inferCertainType(n, _)) }

  /**
   * Holds if `n` having type `t` at `path` conflicts with certain type information.
   */
  bindingset[n, path, t]
  pragma[inline_late]
  predicate certainTypeConflict(AstNode n, TypePath path, Type t) {
    inferCertainType(n, path) != t
    or
    // If we infer that `n` has _some_ type at `T1.T2....Tn`, and we also
    // know that `n` certainly has type `certainType` at `T1.T2...Ti`, `0 <= i < n`,
    // then it must be the case that `T(i+1)` is a type parameter of `certainType`,
    // otherwise there is a conflict.
    //
    // Below, `prefix` is `T1.T2...Ti` and `tp` is `T(i+1)`.
    exists(TypePath prefix, TypePath suffix, TypeParameter tp, Type certainType |
      path = prefix.appendInverse(suffix) and
      tp = suffix.getHead() and
      inferCertainType(n, prefix) = certainType and
      not certainType.getATypeParameter() = tp
    )
  }
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
  result instanceof UnitType
}

pragma[nomagic]
private Struct getRangeType(RangeExpr re) {
  re instanceof RangeFromExpr and
  result instanceof RangeFromStruct
  or
  re instanceof RangeToExpr and
  result instanceof RangeToStruct
  or
  re instanceof RangeFromToExpr and
  result instanceof RangeStruct
  or
  re instanceof RangeInclusiveExpr and
  result instanceof RangeInclusiveStruct
  or
  re instanceof RangeToInclusiveExpr and
  result instanceof RangeToInclusiveStruct
}

/**
 * Holds if the type tree of `n1` at `prefix1` should be equal to the type tree
 * of `n2` at `prefix2` and type information should propagate in both directions
 * through the type equality.
 */
private predicate typeEquality(AstNode n1, TypePath prefix1, AstNode n2, TypePath prefix2) {
  CertainTypeInference::certainTypeEquality(n1, prefix1, n2, prefix2)
  or
  prefix1.isEmpty() and
  prefix2.isEmpty() and
  (
    exists(LetStmt let |
      let.getPat() = n1 and
      let.getInitializer() = n2
    )
    or
    n1 = n2.(IfExpr).getABranch()
    or
    n1 = n2.(MatchExpr).getAnArm().getExpr()
    or
    exists(MatchExpr me |
      n1 = me.getScrutinee() and
      n2 = me.getAnArm().getPat()
    )
    or
    n1 = n2.(OrPat).getAPat()
    or
    n1 = n2.(ParenPat).getPat()
    or
    n1 = n2.(LiteralPat).getLiteral()
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
    or
    n1 = n2.(MacroPat).getMacroCall().getMacroCallExpansion()
  )
  or
  (
    n1 = n2.(RefExpr).getExpr() or
    n1 = n2.(RefPat).getPat()
  ) and
  prefix1.isEmpty() and
  prefix2 = TypePath::singleton(TRefTypeParameter())
  or
  exists(int i, int arity |
    prefix1.isEmpty() and
    prefix2 = TypePath::singleton(TTupleTypeParameter(arity, i))
  |
    arity = n2.(TupleExpr).getNumberOfFields() and
    n1 = n2.(TupleExpr).getField(i)
    or
    arity = n2.(TuplePat).getTupleArity() and
    n1 = n2.(TuplePat).getField(i)
  )
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
  or
  // an array list expression (`[1, 2, 3]`) has the type of the first (any) element
  n1.(ArrayListExpr).getExpr(_) = n2 and
  prefix1 = TypePath::singleton(TArrayTypeParameter()) and
  prefix2.isEmpty()
  or
  // an array repeat expression (`[1; 3]`) has the type of the repeat operand
  n1.(ArrayRepeatExpr).getRepeatOperand() = n2 and
  prefix1 = TypePath::singleton(TArrayTypeParameter()) and
  prefix2.isEmpty()
  or
  exists(Struct s |
    n2 = [n1.(RangeExpr).getStart(), n1.(RangeExpr).getEnd()] and
    prefix1 = TypePath::singleton(TTypeParamTypeParameter(s.getGenericParamList().getATypeParam())) and
    prefix2.isEmpty() and
    s = getRangeType(n1)
  )
  or
  exists(ClosureExpr ce, int index |
    n1 = ce and
    n2 = ce.getParam(index).getPat() and
    prefix1 = closureParameterPath(ce.getNumberOfParams(), index) and
    prefix2.isEmpty()
  )
  or
  n1.(ClosureExpr).getBody() = n2 and
  prefix1 = closureReturnPath() and
  prefix2.isEmpty()
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
    Type getTypeArgument(TypeArgumentPosition apos, TypePath path) { none() }

    AstNode getNodeAt(AccessPosition apos) {
      result = this.getFieldExpr(apos.asFieldPos()).getExpr()
      or
      result = this and
      apos.isStructPos()
    }

    Type getInferredType(AccessPosition apos, TypePath path) {
      result = inferType(this.getNodeAt(apos), path)
      or
      // The struct/enum type is supplied explicitly as a type qualifier, e.g.
      // `Foo<Bar>::Variant { ... }`.
      apos.isStructPos() and
      result = this.getPath().(TypeMention).resolveTypeAt(path)
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
private Type inferTupleRootType(AstNode n) {
  // `typeEquality` handles the non-root cases
  result = TTuple([n.(TupleExpr).getNumberOfFields(), n.(TuplePat).getTupleArity()])
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

/** Gets the explicit type qualifier of the call `ce`, if any. */
private Type getTypeQualifier(CallExpr ce, TypePath path) {
  exists(PathExpr pe, TypeMention tm |
    pe = ce.getFunction() and
    tm = pe.getPath().getQualifier() and
    result = tm.resolveTypeAt(path)
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

    Type getDeclaredType(DeclarationPosition dpos, TypePath path) {
      result = this.getParameterType(dpos, path)
      or
      dpos.isReturn() and
      result = this.getReturnType(path)
    }
  }

  abstract additional class TupleDeclaration extends Declaration {
    override Type getDeclaredType(DeclarationPosition dpos, TypePath path) {
      result = super.getDeclaredType(dpos, path)
      or
      dpos.isSelf() and
      result = this.getReturnType(path)
    }
  }

  private class TupleStructDecl extends TupleDeclaration, Struct {
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

  private class TupleVariantDecl extends TupleDeclaration, Variant {
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

  additional class FunctionDecl extends Declaration, Function {
    override TypeParameter getTypeParameter(TypeParameterPosition ppos) {
      typeParamMatchPosition(this.getGenericParamList().getATypeParam(), result, ppos)
      or
      exists(ImplOrTraitItemNode i | this = i.getAnAssocItem() |
        typeParamMatchPosition(i.getTypeParam(_), result, ppos)
        or
        ppos.isImplicit() and result = TSelfTypeParameter(i)
        or
        ppos.isImplicit() and
        result.(AssociatedTypeTypeParameter).getTrait() = i
      )
      or
      ppos.isImplicit() and
      this = result.(ImplTraitTypeTypeParameter).getFunction()
    }

    override Type getParameterType(DeclarationPosition dpos, TypePath path) {
      exists(Param p, int i |
        paramPos(this.getParamList(), p, i) and
        i = dpos.asPosition() and
        result = p.getTypeRepr().(TypeMention).resolveTypeAt(path)
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
      or
      // For associated functions, we may also need to match type arguments against
      // the `Self` type. For example, in
      //
      // ```rust
      // struct Foo<T>(T);
      //
      // impl<T : Default> Foo<T> {
      //   fn default() -> Self {
      //     Foo(Default::default())
      //   }
      // }
      //
      // Foo::<i32>::default();
      // ```
      //
      // we need to match `i32` against the type parameter `T` of the `impl` block.
      exists(ImplOrTraitItemNode i |
        this = i.getAnAssocItem() and
        dpos.isSelf() and
        not this.getParamList().hasSelfParam()
      |
        result = TSelfTypeParameter(i) and
        path.isEmpty()
        or
        result = resolveImplSelfType(i, path)
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
    TArgumentAccessPosition(ArgumentPosition pos, Boolean borrowed, Boolean certain) or
    TReturnAccessPosition()

  class AccessPosition extends TAccessPosition {
    ArgumentPosition getArgumentPosition() { this = TArgumentAccessPosition(result, _, _) }

    predicate isBorrowed(boolean certain) { this = TArgumentAccessPosition(_, true, certain) }

    predicate isReturn() { this = TReturnAccessPosition() }

    string toString() {
      exists(ArgumentPosition pos, boolean borrowed, boolean certain |
        this = TArgumentAccessPosition(pos, borrowed, certain) and
        result = pos + ":" + borrowed + ":" + certain
      )
      or
      this.isReturn() and
      result = "(return)"
    }
  }

  final class Access extends Call {
    pragma[nomagic]
    Type getTypeArgument(TypeArgumentPosition apos, TypePath path) {
      exists(TypeMention arg | result = arg.resolveTypeAt(path) |
        exists(Path p, int i |
          p = CallExprImpl::getFunctionPath(this) and
          arg = p.getSegment().getGenericArgList().getTypeArg(pragma[only_bind_into](i)) and
          apos.asTypeParam() = resolvePath(p).getTypeParam(pragma[only_bind_into](i))
        )
        or
        arg =
          this.(MethodCallExpr).getGenericArgList().getTypeArg(apos.asMethodTypeArgumentPosition())
      )
    }

    AstNode getNodeAt(AccessPosition apos) {
      exists(ArgumentPosition pos, boolean borrowed, boolean certain |
        apos = TArgumentAccessPosition(pos, borrowed, certain) and
        result = this.getArgument(pos)
      |
        if this.implicitBorrowAt(pos, _)
        then borrowed = true and this.implicitBorrowAt(pos, certain)
        else (
          borrowed = false and certain = true
        )
      )
      or
      result = this and apos.isReturn()
    }

    Type getInferredType(AccessPosition apos, TypePath path) {
      result = inferType(this.getNodeAt(apos), path)
      or
      // The `Self` type is supplied explicitly as a type qualifier, e.g. `Foo::<Bar>::baz()`
      apos = TArgumentAccessPosition(CallImpl::TSelfArgumentPosition(), false, false) and
      result = getTypeQualifier(this, path)
    }

    Declaration getTarget() {
      result = resolveMethodCallTarget(this) // mutual recursion; resolving method calls requires resolving types and vice versa
      or
      result = resolveFunctionCallTarget(this) // potential mutual recursion; resolving some associated function calls requires resolving types
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
    apos.isBorrowed(true) and
    pathAdj = TypePath::cons(TRefTypeParameter(), path) and
    tAdj = t
    or
    apos.isBorrowed(false) and
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
    or
    not apos.isBorrowed(_) and
    pathAdj = path and
    tAdj = t
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
    if
      apos.isBorrowed(true)
      or
      // The desugaring of the unary `*e` is `*Deref::deref(&e)` and the
      // desugaring of `a[b]` is `*Index::index(&a, b)`. To handle the deref
      // expression after the call we must strip a `&` from the type at the
      // return position.
      apos.isReturn() and
      (a instanceof DerefExpr or a instanceof IndexExpr)
    then path0.isCons(TRefTypeParameter(), path)
    else
      if apos.isBorrowed(false)
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
      else (
        not apos.isBorrowed(_) and
        path = path0
      )
  )
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

pragma[nomagic]
private Type getTupleFieldExprLookupType(FieldExpr fe, int pos) {
  exists(string name |
    result = getFieldExprLookupType(fe, name) and
    pos = name.toInt()
  )
}

pragma[nomagic]
private TupleTypeParameter resolveTupleTypeFieldExpr(FieldExpr fe) {
  exists(int arity, int i |
    TTuple(arity) = getTupleFieldExprLookupType(fe, i) and
    result = TTupleTypeParameter(arity, i)
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

  private newtype TDeclaration =
    TStructFieldDecl(StructField sf) or
    TTupleFieldDecl(TupleField tf) or
    TTupleTypeParameterDecl(TupleTypeParameter ttp)

  abstract class Declaration extends TDeclaration {
    TypeParameter getTypeParameter(TypeParameterPosition ppos) { none() }

    abstract Type getDeclaredType(DeclarationPosition dpos, TypePath path);

    abstract string toString();

    abstract Location getLocation();
  }

  abstract private class StructOrTupleFieldDecl extends Declaration {
    abstract AstNode getAstNode();

    abstract TypeRepr getTypeRepr();

    override Type getDeclaredType(DeclarationPosition dpos, TypePath path) {
      dpos.isSelf() and
      // no case for variants as those can only be destructured using pattern matching
      exists(Struct s | this.getAstNode() = [s.getStructField(_).(AstNode), s.getTupleField(_)] |
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

    override string toString() { result = this.getAstNode().toString() }

    override Location getLocation() { result = this.getAstNode().getLocation() }
  }

  private class StructFieldDecl extends StructOrTupleFieldDecl, TStructFieldDecl {
    private StructField sf;

    StructFieldDecl() { this = TStructFieldDecl(sf) }

    override AstNode getAstNode() { result = sf }

    override TypeRepr getTypeRepr() { result = sf.getTypeRepr() }
  }

  private class TupleFieldDecl extends StructOrTupleFieldDecl, TTupleFieldDecl {
    private TupleField tf;

    TupleFieldDecl() { this = TTupleFieldDecl(tf) }

    override AstNode getAstNode() { result = tf }

    override TypeRepr getTypeRepr() { result = tf.getTypeRepr() }
  }

  private class TupleTypeParameterDecl extends Declaration, TTupleTypeParameterDecl {
    private TupleTypeParameter ttp;

    TupleTypeParameterDecl() { this = TTupleTypeParameterDecl(ttp) }

    override Type getDeclaredType(DeclarationPosition dpos, TypePath path) {
      dpos.isSelf() and
      (
        result = ttp.getTupleType() and
        path.isEmpty()
        or
        result = ttp and
        path = TypePath::singleton(ttp)
      )
      or
      dpos.isField() and
      result = ttp and
      path.isEmpty()
    }

    override string toString() { result = ttp.toString() }

    override Location getLocation() { result = ttp.getLocation() }
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
      result =
        [
          TStructFieldDecl(resolveStructFieldExpr(this)).(TDeclaration),
          TTupleFieldDecl(resolveTupleFieldExpr(this)),
          TTupleTypeParameterDecl(resolveTupleTypeFieldExpr(this))
        ]
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

/** Gets the root type of the reference node `ref`. */
pragma[nomagic]
private Type inferRefNodeType(AstNode ref) {
  (
    ref = any(IdentPat ip | ip.isRef()).getName()
    or
    ref instanceof RefExpr
    or
    ref instanceof RefPat
  ) and
  result = TRefType()
}

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
private StructType getStrStruct() { result = TStruct(any(Builtins::Str s)) }

pragma[nomagic]
private Type inferLiteralType(LiteralExpr le, TypePath path, boolean certain) {
  path.isEmpty() and
  exists(Builtins::BuiltinType t | result = TStruct(t) |
    le instanceof CharLiteralExpr and
    t instanceof Builtins::Char and
    certain = true
    or
    le =
      any(NumberLiteralExpr ne |
        t.getName() = ne.getSuffix() and
        certain = true
        or
        // When a number literal has no suffix, the type may depend on the context.
        // For simplicity, we assume either `i32` or `f64`.
        not exists(ne.getSuffix()) and
        certain = false and
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
    t instanceof Builtins::Bool and
    certain = true
  )
  or
  le instanceof StringLiteralExpr and
  (
    path.isEmpty() and result = TRefType()
    or
    path = TypePath::singleton(TRefTypeParameter()) and
    result = getStrStruct()
  ) and
  certain = true
}

pragma[nomagic]
private TraitType getFutureTraitType() { result.getTrait() instanceof FutureTrait }

pragma[nomagic]
private AssociatedTypeTypeParameter getFutureOutputTypeParameter() {
  result.getTypeAlias() = any(FutureTrait ft).getOutputType()
}

pragma[nomagic]
private TraitType inferAsyncBlockExprRootType(AsyncBlockExpr abe) {
  // `typeEquality` handles the non-root case
  exists(abe) and
  result = getFutureTraitType()
}

final private class AwaitTarget extends Expr {
  AwaitTarget() { this = any(AwaitExpr ae).getExpr() }

  Type getTypeAt(TypePath path) { result = inferType(this, path) }
}

private module AwaitSatisfiesConstraintInput implements SatisfiesConstraintInputSig<AwaitTarget> {
  predicate relevantConstraint(AwaitTarget term, Type constraint) {
    exists(term) and
    constraint.(TraitType).getTrait() instanceof FutureTrait
  }
}

pragma[nomagic]
private Type inferAwaitExprType(AstNode n, TypePath path) {
  exists(TypePath exprPath |
    SatisfiesConstraint<AwaitTarget, AwaitSatisfiesConstraintInput>::satisfiesConstraintType(n.(AwaitExpr)
          .getExpr(), _, exprPath, result) and
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
 * Gets the root type of the array expression `ae`.
 */
pragma[nomagic]
private Type inferArrayExprType(ArrayExpr ae) { exists(ae) and result = TArrayType() }

/**
 * Gets the root type of the range expression `re`.
 */
pragma[nomagic]
private Type inferRangeExprType(RangeExpr re) { result = TStruct(getRangeType(re)) }

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
  // TODO: Method resolution to the `std::ops::Index` trait can handle the
  // `Index` instances for slices and arrays.
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

/**
 * A matching configuration for resolving types of struct patterns
 * like `let Foo { bar } = ...`.
 */
private module StructPatMatchingInput implements MatchingInputSig {
  class DeclarationPosition = StructExprMatchingInput::DeclarationPosition;

  class Declaration = StructExprMatchingInput::Declaration;

  class AccessPosition = DeclarationPosition;

  class Access extends StructPat {
    Type getTypeArgument(TypeArgumentPosition apos, TypePath path) { none() }

    AstNode getNodeAt(AccessPosition apos) {
      result = this.getPatField(apos.asFieldPos()).getPat()
      or
      result = this and
      apos.isStructPos()
    }

    Type getInferredType(AccessPosition apos, TypePath path) {
      result = inferType(this.getNodeAt(apos), path)
      or
      // The struct/enum type is supplied explicitly as a type qualifier, e.g.
      // `let Foo<Bar>::Variant { ... } = ...`.
      apos.isStructPos() and
      result = this.getPath().(TypeMention).resolveTypeAt(path)
    }

    Declaration getTarget() { result = resolvePath(this.getPath()) }
  }

  predicate accessDeclarationPositionMatch(AccessPosition apos, DeclarationPosition dpos) {
    apos = dpos
  }
}

private module StructPatMatching = Matching<StructPatMatchingInput>;

/**
 * Gets the type of `n` at `path`, where `n` is either a struct pattern or
 * a field pattern of a struct pattern.
 */
pragma[nomagic]
private Type inferStructPatType(AstNode n, TypePath path) {
  exists(StructPatMatchingInput::Access a, StructPatMatchingInput::AccessPosition apos |
    n = a.getNodeAt(apos) and
    result = StructPatMatching::inferAccessType(a, apos, path)
  )
}

/**
 * A matching configuration for resolving types of tuple struct patterns
 * like `let Some(x) = ...`.
 */
private module TupleStructPatMatchingInput implements MatchingInputSig {
  class DeclarationPosition = CallExprBaseMatchingInput::DeclarationPosition;

  class Declaration = CallExprBaseMatchingInput::TupleDeclaration;

  class AccessPosition = DeclarationPosition;

  class Access extends TupleStructPat {
    Type getTypeArgument(TypeArgumentPosition apos, TypePath path) { none() }

    AstNode getNodeAt(AccessPosition apos) {
      result = this.getField(apos.asPosition())
      or
      result = this and
      apos.isSelf()
    }

    Type getInferredType(AccessPosition apos, TypePath path) {
      result = inferType(this.getNodeAt(apos), path)
      or
      // The struct/enum type is supplied explicitly as a type qualifier, e.g.
      // `let Option::<Foo>::Some(x) = ...`.
      apos.isSelf() and
      result = this.getPath().(TypeMention).resolveTypeAt(path)
    }

    Declaration getTarget() { result = resolvePath(this.getPath()) }
  }

  predicate accessDeclarationPositionMatch(AccessPosition apos, DeclarationPosition dpos) {
    apos = dpos
  }
}

private module TupleStructPatMatching = Matching<TupleStructPatMatchingInput>;

/**
 * Gets the type of `n` at `path`, where `n` is either a tuple struct pattern or
 * a positional pattern of a tuple struct pattern.
 */
pragma[nomagic]
private Type inferTupleStructPatType(AstNode n, TypePath path) {
  exists(TupleStructPatMatchingInput::Access a, TupleStructPatMatchingInput::AccessPosition apos |
    n = a.getNodeAt(apos) and
    result = TupleStructPatMatching::inferAccessType(a, apos, path)
  )
}

final private class ForIterableExpr extends Expr {
  ForIterableExpr() { this = any(ForExpr fe).getIterable() }

  Type getTypeAt(TypePath path) { result = inferType(this, path) }
}

private module ForIterableSatisfiesConstraintInput implements
  SatisfiesConstraintInputSig<ForIterableExpr>
{
  predicate relevantConstraint(ForIterableExpr term, Type constraint) {
    exists(term) and
    exists(Trait t | t = constraint.(TraitType).getTrait() |
      // TODO: Remove the line below once we can handle the `impl<I: Iterator> IntoIterator for I` implementation
      t instanceof IteratorTrait or
      t instanceof IntoIteratorTrait
    )
  }
}

pragma[nomagic]
private AssociatedTypeTypeParameter getIteratorItemTypeParameter() {
  result.getTypeAlias() = any(IteratorTrait t).getItemType()
}

pragma[nomagic]
private AssociatedTypeTypeParameter getIntoIteratorItemTypeParameter() {
  result.getTypeAlias() = any(IntoIteratorTrait t).getItemType()
}

pragma[nomagic]
private Type inferForLoopExprType(AstNode n, TypePath path) {
  // type of iterable -> type of pattern (loop variable)
  exists(ForExpr fe, TypePath exprPath, AssociatedTypeTypeParameter tp |
    n = fe.getPat() and
    SatisfiesConstraint<ForIterableExpr, ForIterableSatisfiesConstraintInput>::satisfiesConstraintType(fe.getIterable(),
      _, exprPath, result) and
    exprPath.isCons(tp, path)
  |
    tp = getIntoIteratorItemTypeParameter()
    or
    // TODO: Remove once we can handle the `impl<I: Iterator> IntoIterator for I` implementation
    tp = getIteratorItemTypeParameter() and
    inferType(fe.getIterable()) != TArrayType()
  )
}

/**
 * An invoked expression, the target of a call that is either a local variable
 * or a non-path expression. This means that the expression denotes a
 * first-class function.
 */
final private class InvokedClosureExpr extends Expr {
  private CallExpr call;

  InvokedClosureExpr() {
    call.getFunction() = this and
    (not this instanceof PathExpr or this = any(Variable v).getAnAccess())
  }

  Type getTypeAt(TypePath path) { result = inferType(this, path) }

  CallExpr getCall() { result = call }
}

private module InvokedClosureSatisfiesConstraintInput implements
  SatisfiesConstraintInputSig<InvokedClosureExpr>
{
  predicate relevantConstraint(InvokedClosureExpr term, Type constraint) {
    exists(term) and
    constraint.(TraitType).getTrait() instanceof FnOnceTrait
  }
}

/** Gets the type of `ce` when viewed as an implementation of `FnOnce`. */
private Type invokedClosureFnTypeAt(InvokedClosureExpr ce, TypePath path) {
  SatisfiesConstraint<InvokedClosureExpr, InvokedClosureSatisfiesConstraintInput>::satisfiesConstraintType(ce,
    _, path, result)
}

/** Gets the path to a closure's return type. */
private TypePath closureReturnPath() {
  result = TypePath::singleton(TDynTraitTypeParameter(any(FnOnceTrait t).getOutputType()))
}

/** Gets the path to a closure with arity `arity`s `index`th parameter type. */
pragma[nomagic]
private TypePath closureParameterPath(int arity, int index) {
  result =
    TypePath::cons(TDynTraitTypeParameter(any(FnOnceTrait t).getTypeParam()),
      TypePath::singleton(TTupleTypeParameter(arity, index)))
}

/** Gets the path to the return type of the `FnOnce` trait. */
private TypePath fnReturnPath() {
  result = TypePath::singleton(TAssociatedTypeTypeParameter(any(FnOnceTrait t).getOutputType()))
}

/**
 * Gets the path to the parameter type of the `FnOnce` trait with arity `arity`
 * and index `index`.
 */
pragma[nomagic]
private TypePath fnParameterPath(int arity, int index) {
  result =
    TypePath::cons(TTypeParamTypeParameter(any(FnOnceTrait t).getTypeParam()),
      TypePath::singleton(TTupleTypeParameter(arity, index)))
}

pragma[nomagic]
private Type inferDynamicCallExprType(Expr n, TypePath path) {
  exists(InvokedClosureExpr ce |
    // Propagate the function's return type to the call expression
    exists(TypePath path0 | result = invokedClosureFnTypeAt(ce, path0) |
      n = ce.getCall() and
      path = path0.stripPrefix(fnReturnPath())
      or
      // Propagate the function's parameter type to the arguments
      exists(int index |
        n = ce.getCall().getArgList().getArg(index) and
        path = path0.stripPrefix(fnParameterPath(ce.getCall().getNumberOfArgs(), index))
      )
    )
    or
    // _If_ the invoked expression has the type of a closure, then we propagate
    // the surrounding types into the closure.
    exists(int arity, TypePath path0 |
      ce.getTypeAt(TypePath::nil()).(DynTraitType).getTrait() instanceof FnOnceTrait
    |
      // Propagate the type of arguments to the parameter types of closure
      exists(int index |
        n = ce and
        arity = ce.getCall().getNumberOfArgs() and
        result = inferType(ce.getCall().getArg(index), path0) and
        path = closureParameterPath(arity, index).append(path0)
      )
      or
      // Propagate the type of the call expression to the return type of the closure
      n = ce and
      arity = ce.getCall().getNumberOfArgs() and
      result = inferType(ce.getCall(), path0) and
      path = closureReturnPath().append(path0)
    )
  )
}

pragma[nomagic]
private Type inferClosureExprType(AstNode n, TypePath path) {
  exists(ClosureExpr ce |
    n = ce and
    path.isEmpty() and
    result = TDynTraitType(any(FnOnceTrait t))
    or
    n = ce and
    path = TypePath::singleton(TDynTraitTypeParameter(any(FnOnceTrait t).getTypeParam())) and
    result = TTuple(ce.getNumberOfParams())
    or
    // Propagate return type annotation to body
    n = ce.getBody() and
    result = ce.getRetType().getTypeRepr().(TypeMention).resolveTypeAt(path)
  )
}

pragma[nomagic]
private Type inferCastExprType(CastExpr ce, TypePath path) {
  result = ce.getTypeRepr().(TypeMention).resolveTypeAt(path)
}

final class MethodCall extends Call {
  MethodCall() { exists(this.getReceiver()) }

  private Type getReceiverTypeAt(TypePath path) {
    result = inferType(super.getReceiver(), path)
    or
    result = getTypeQualifier(this, path)
  }

  /** Gets the type of the receiver of the method call at `path`. */
  Type getTypeAt(TypePath path) {
    if
      this.receiverImplicitlyBorrowed() or
      this.(CallImpl::CallExprMethodCall).hasExplicitSelfBorrow()
    then
      exists(TypePath path0, Type t0 |
        t0 = this.getReceiverTypeAt(path0) and
        (
          path0.isCons(TRefTypeParameter(), path)
          or
          (
            not path0.isCons(TRefTypeParameter(), _) and
            not (path0.isEmpty() and result = TRefType())
            or
            // Ideally we should find all methods on reference types, but as
            // that currently causes a blowup we limit this to the `deref`
            // method in order to make dereferencing work.
            this.getMethodName() = "deref"
          ) and
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
    else result = this.getReceiverTypeAt(path)
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

pragma[nomagic]
private predicate isMethodCall(MethodCall mc, Type rootType, string name, int arity) {
  rootType = mc.getTypeAt(TypePath::nil()) and
  name = mc.getMethodName() and
  arity = mc.getNumberOfArguments()
}

private module IsInstantiationOfInput implements IsInstantiationOfInputSig<MethodCall> {
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

pragma[nomagic]
private Type resolveNonTypeParameterTypeAt(TypeMention tm, TypePath path) {
  result = tm.resolveTypeAt(path) and
  not result instanceof TypeParameter
}

bindingset[t1, t2]
private predicate typeMentionEqual(TypeMention t1, TypeMention t2) {
  forex(TypePath path, Type type | resolveNonTypeParameterTypeAt(t1, path) = type |
    resolveNonTypeParameterTypeAt(t2, path) = type
  )
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

pragma[nomagic]
private predicate functionTypeAtPath(Function f, int pos, TypePath path, Type type) {
  exists(TypeMention tm | type = tm.resolveTypeAt(path) |
    tm = f.getParam(pos).getTypeRepr()
    or
    pos = -1 and
    tm = f.getRetType().getTypeRepr()
  )
}

/**
 * Holds if type parameter `tp` of `trait` occurs in the function with the name
 * `functionName` at the `pos`th parameter at `path`.
 *
 * The special position `-1` refers to the return type of the function, which
 * is sometimes needed to disambiguate associated function calls like
 * `Default::default()` (in this case, `tp` is the special `Self` type parameter).
 */
bindingset[trait]
pragma[inline_late]
private predicate traitTypeParameterOccurrence(
  TraitItemNode trait, Function f, string functionName, int pos, TypePath path, TypeParameter tp
) {
  f = trait.getAssocItem(functionName) and
  functionTypeAtPath(f, pos, path, tp) and
  tp = trait.(TraitTypeAbstraction).getATypeParameter()
}

/**
 * Holds if resolving the function `f` in `impl` with the name `functionName`
 * requires inspecting the types of applied _arguments_ in order to determine
 * whether it is the correct resolution.
 */
pragma[nomagic]
private predicate functionResolutionDependsOnArgument(
  ImplItemNode impl, string functionName, Function f, int pos, TypePath path, Type type
) {
  /*
   * As seen in the example below, when an implementation has a sibling for a
   * trait we find occurrences of a type parameter of the trait in a function
   * signature in the trait. We then find the type given in the implementation
   * at the same position, which is a position that might disambiguate the
   * function from its siblings.
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
    traitTypeParameterOccurrence(trait, _, functionName, pos, path, _) and
    functionTypeAtPath(f, pos, path, type) and
    f = impl.getAssocItem(functionName) and
    pos >= 0
  )
}

/**
 * Holds if the method call `mc` has no inherent target, i.e., it does not
 * resolve to a method in an `impl` block for the type of the receiver.
 */
pragma[nomagic]
private predicate methodCallHasNoInherentTarget(MethodCall mc) {
  exists(Type rootType, string name, int arity |
    isMethodCall(mc, rootType, name, arity) and
    forall(Impl impl |
      methodCandidate(rootType, name, arity, impl) and
      not impl.hasTrait()
    |
      IsInstantiationOf<MethodCall, IsInstantiationOfInput>::isNotInstantiationOf(mc, impl, _)
    )
  )
}

pragma[nomagic]
private predicate methodCallHasImplCandidate(MethodCall mc, Impl impl) {
  IsInstantiationOf<MethodCall, IsInstantiationOfInput>::isInstantiationOf(mc, impl, _) and
  if impl.hasTrait() and not exists(mc.getTrait())
  then
    // inherent methods take precedence over trait methods, so only allow
    // trait methods when there are no matching inherent methods
    methodCallHasNoInherentTarget(mc)
  else any()
}

/** Gets a method from an `impl` block that matches the method call `mc`. */
pragma[nomagic]
private Function getMethodFromImpl(MethodCall mc) {
  exists(Impl impl, string name |
    methodCallHasImplCandidate(mc, impl) and
    name = mc.getMethodName() and
    result = getMethodSuccessor(impl, name)
  |
    not functionResolutionDependsOnArgument(impl, name, _, _, _, _)
    or
    exists(int pos, TypePath path, Type type |
      functionResolutionDependsOnArgument(impl, name, result, pos, pragma[only_bind_into](path),
        type) and
      inferType(mc.getPositionalArgument(pos), pragma[only_bind_into](path)) = type
    )
  )
}

bindingset[trait, name]
pragma[inline_late]
private Function getImplTraitMethod(ImplTraitReturnType trait, string name) {
  result = getMethodSuccessor(trait.getImplTraitTypeRepr(), name)
}

bindingset[traitObject, name]
pragma[inline_late]
private Function getDynTraitMethod(DynTraitType traitObject, string name) {
  result = getMethodSuccessor(traitObject.getTrait(), name)
}

pragma[nomagic]
private Function resolveMethodCallTarget(MethodCall mc) {
  // The method comes from an `impl` block targeting the type of the receiver.
  result = getMethodFromImpl(mc)
  or
  // The type of the receiver is a type parameter and the method comes from a
  // trait bound on the type parameter.
  result = getTypeParameterMethod(mc.getTypeAt(TypePath::nil()), mc.getMethodName())
  or
  // The type of the receiver is an `impl Trait` type.
  result = getImplTraitMethod(mc.getTypeAt(TypePath::nil()), mc.getMethodName())
  or
  // The type of the receiver is a trait object `dyn Trait` type.
  result = getDynTraitMethod(mc.getTypeAt(TypePath::nil()), mc.getMethodName())
}

pragma[nomagic]
private predicate assocFuncResolutionDependsOnArgument(Function f, Impl impl, int pos) {
  functionResolutionDependsOnArgument(impl, _, f, pos, _, _) and
  not f.getParamList().hasSelfParam()
}

private class FunctionCallExpr extends CallImpl::CallExprCall {
  ItemNode getResolvedFunction() { result = CallExprImpl::getResolvedFunction(this) }

  /**
   * Holds if the target of this call is ambigous, and type information is required
   * to disambiguate.
   */
  predicate isAmbigous() {
    this.hasTrait()
    or
    assocFuncResolutionDependsOnArgument(this.getResolvedFunction(), _, _)
  }

  /**
   * Gets a target candidate of this ambigous call, which belongs to `impl`.
   *
   * In order for the candidate to be a match, the argument type at `pos` must be
   * checked against the type of the function at the same position.
   *
   * `resolved` is the corresponding function resolved through path resolution.
   */
  pragma[nomagic]
  Function getAnAmbigousCandidate(ImplItemNode impl, int pos, Function resolved) {
    resolved = this.getResolvedFunction() and
    (
      exists(TraitItemNode trait |
        trait = this.getTrait() and
        result.implements(resolved) and
        result = impl.getAnAssocItem()
      |
        assocFuncResolutionDependsOnArgument(result, impl, pos)
        or
        exists(TypeParameter tp | traitTypeParameterOccurrence(trait, resolved, _, pos, _, tp) |
          pos >= 0
          or
          // We only check that the context of the call provides relevant type information
          // when no argument can
          not traitTypeParameterOccurrence(trait, resolved, _, any(int pos0 | pos0 >= 0), _, tp)
        )
      )
      or
      result = resolved and
      assocFuncResolutionDependsOnArgument(result, impl, pos)
    )
  }

  /**
   * Same as `getAnAmbigousCandidate`, ranks the positions to be checked.
   */
  Function getAnAmbigousCandidateRanked(ImplItemNode impl, int pos, Function f, int rnk) {
    pos = rank[rnk + 1](int pos0 | result = this.getAnAmbigousCandidate(impl, pos0, f) | pos0)
  }
}

private newtype TAmbigousAssocFunctionCallExpr =
  MkAmbigousAssocFunctionCallExpr(FunctionCallExpr call, Function resolved, int pos) {
    exists(call.getAnAmbigousCandidate(_, pos, resolved))
  }

private class AmbigousAssocFunctionCallExpr extends MkAmbigousAssocFunctionCallExpr {
  FunctionCallExpr call;
  Function resolved;
  int pos;

  AmbigousAssocFunctionCallExpr() { this = MkAmbigousAssocFunctionCallExpr(call, resolved, pos) }

  pragma[nomagic]
  Type getTypeAt(TypePath path) {
    result = inferType(call.(CallExpr).getArg(pos), path)
    or
    pos = -1 and
    result = inferType(call, path)
  }

  string toString() { result = call.toString() }

  Location getLocation() { result = call.getLocation() }
}

private module AmbigousAssocFuncIsInstantiationOfInput implements
  IsInstantiationOfInputSig<AmbigousAssocFunctionCallExpr>
{
  pragma[nomagic]
  predicate potentialInstantiationOf(
    AmbigousAssocFunctionCallExpr ce, TypeAbstraction impl, TypeMention constraint
  ) {
    exists(FunctionCallExpr call, Function resolved, Function cand, int pos |
      ce = MkAmbigousAssocFunctionCallExpr(call, resolved, pos) and
      cand = call.getAnAmbigousCandidate(impl, pos, resolved)
    |
      constraint = cand.getParam(pos).getTypeRepr()
      or
      pos = -1 and
      constraint = cand.getRetType().getTypeRepr()
    )
  }
}

/**
 * Gets the target of `call`, where resolution does not rely on type inference.
 */
pragma[nomagic]
private ItemNode resolveUnambigousFunctionCallTarget(FunctionCallExpr call) {
  result = call.getResolvedFunction() and
  not call.isAmbigous()
}

pragma[nomagic]
private Function resolveAmbigousFunctionCallTargetFromIndex(FunctionCallExpr call, int index) {
  exists(Impl impl, int pos, Function resolved |
    IsInstantiationOf<AmbigousAssocFunctionCallExpr, AmbigousAssocFuncIsInstantiationOfInput>::isInstantiationOf(MkAmbigousAssocFunctionCallExpr(call,
        resolved, pos), impl, _) and
    result = call.getAnAmbigousCandidateRanked(impl, pos, resolved, index)
  |
    index = 0
    or
    result = resolveAmbigousFunctionCallTargetFromIndex(call, index - 1)
  )
}

/**
 * Gets the target of `call`, where resolution relies on type inference.
 */
pragma[nomagic]
private Function resolveAmbigousFunctionCallTarget(FunctionCallExpr call) {
  result =
    resolveAmbigousFunctionCallTargetFromIndex(call,
      max(int index | result = call.getAnAmbigousCandidateRanked(_, _, _, index)))
}

pragma[inline]
private ItemNode resolveFunctionCallTarget(FunctionCallExpr call) {
  result = resolveUnambigousFunctionCallTarget(call)
  or
  result = resolveAmbigousFunctionCallTarget(call)
}

cached
private module Cached {
  private import codeql.rust.internal.CachedStages

  /** Holds if `receiver` is the receiver of a method call with an implicit dereference. */
  cached
  predicate receiverHasImplicitDeref(AstNode receiver) {
    exists(CallExprBaseMatchingInput::Access a, CallExprBaseMatchingInput::AccessPosition apos |
      apos.getArgumentPosition().isSelf() and
      apos.isBorrowed(_) and
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
      apos.isBorrowed(_) and
      receiver = a.getNodeAt(apos) and
      CallExprBaseMatching::inferAccessType(a, apos, TypePath::nil()) = TRefType() and
      inferType(receiver) != TRefType()
    )
  }

  /** Gets a function that `call` resolves to, if any. */
  cached
  Function resolveCallTarget(Call call) {
    result = resolveMethodCallTarget(call)
    or
    result = resolveFunctionCallTarget(call)
  }

  /**
   * Gets the struct field that the field expression `fe` resolves to, if any.
   */
  cached
  StructField resolveStructFieldExpr(FieldExpr fe) {
    exists(string name | result = getFieldExprLookupType(fe, name).getStructField(name))
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
    result = CertainTypeInference::inferCertainType(n, path)
    or
    // Don't propagate type information into a node which conflicts with certain
    // type information.
    (
      if CertainTypeInference::hasInferredCertainType(n)
      then not CertainTypeInference::certainTypeConflict(n, path, result)
      else any()
    ) and
    (
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
      result = inferTryExprType(n, path)
      or
      result = inferLiteralType(n, path, false)
      or
      result = inferAwaitExprType(n, path)
      or
      result = inferRangeExprType(n) and
      path.isEmpty()
      or
      result = inferIndexExprType(n, path)
      or
      result = inferForLoopExprType(n, path)
      or
      result = inferDynamicCallExprType(n, path)
      or
      result = inferClosureExprType(n, path)
      or
      result = inferStructPatType(n, path)
      or
      result = inferTupleStructPatType(n, path)
    )
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

  Function debugResolveCallTarget(Call c) {
    c = getRelevantLocatable() and
    result = resolveCallTarget(c)
  }

  predicate debugConditionSatisfiesConstraint(
    TypeAbstraction abs, TypeMention condition, TypeMention constraint
  ) {
    abs = getRelevantLocatable() and
    Input2::conditionSatisfiesConstraint(abs, condition, constraint)
  }

  predicate debugInferImplicitSelfType(SelfParam self, TypePath path, Type t) {
    self = getRelevantLocatable() and
    t = inferImplicitSelfType(self, path)
  }

  predicate debugInferCallExprBaseType(AstNode n, TypePath path, Type t) {
    n = getRelevantLocatable() and
    t = inferCallExprBaseType(n, path)
  }

  predicate debugTypeMention(TypeMention tm, TypePath path, Type type) {
    tm = getRelevantLocatable() and
    tm.resolveTypeAt(path) = type
  }

  Type debugInferAnnotatedType(AstNode n, TypePath path) {
    n = getRelevantLocatable() and
    result = inferAnnotatedType(n, path)
  }

  pragma[nomagic]
  private int countTypesAtPath(AstNode n, TypePath path, Type t) {
    t = inferType(n, path) and
    result = strictcount(Type t0 | t0 = inferType(n, path))
  }

  Type debugInferTypeForNodeAtLimit(AstNode n, TypePath path) {
    result = inferType(n, path) and
    exists(TypePath path0 | exists(inferType(n, path0)) and path0.length() >= getTypePathLimit())
  }

  predicate countTypesForNodeAtLimit(AstNode n, int c) {
    n = getRelevantLocatable() and
    c = strictcount(Type t, TypePath path | t = debugInferTypeForNodeAtLimit(n, path))
  }

  predicate maxTypes(AstNode n, TypePath path, Type t, int c) {
    c = countTypesAtPath(n, path, t) and
    c = max(countTypesAtPath(_, _, _))
  }

  pragma[nomagic]
  private predicate typePathLength(AstNode n, TypePath path, Type t, int len) {
    t = inferType(n, path) and
    len = path.length()
  }

  predicate maxTypePath(AstNode n, TypePath path, Type t, int len) {
    typePathLength(n, path, t, len) and
    len = max(int i | typePathLength(_, _, _, i))
  }

  pragma[nomagic]
  private int countTypePaths(AstNode n, TypePath path, Type t) {
    t = inferType(n, path) and
    result = strictcount(TypePath path0, Type t0 | t0 = inferType(n, path0))
  }

  predicate maxTypePaths(AstNode n, TypePath path, Type t, int c) {
    c = countTypePaths(n, path, t) and
    c = max(countTypePaths(_, _, _))
  }

  Type debugInferCertainType(AstNode n, TypePath path) {
    n = getRelevantLocatable() and
    result = CertainTypeInference::inferCertainType(n, path)
  }

  Type debugInferCertainNonUniqueType(AstNode n, TypePath path) {
    n = getRelevantLocatable() and
    Consistency::nonUniqueCertainType(n, path, result)
  }
}
