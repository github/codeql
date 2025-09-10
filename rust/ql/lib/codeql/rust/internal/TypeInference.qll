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
        tp0 instanceof PtrTypeParameter and
        kind = 0 and
        id1 = 0 and
        id2 = 3
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
    t = CertainTypeInference::inferCertainType(n, path) and
    // Suppress the inconsistency if `n` is a self parameter and the type
    // mention for the self type has multiple types for a path.
    not exists(ImplItemNode impl, TypePath selfTypePath |
      n = impl.getAnAssocItem().(Function).getSelfParam() and
      strictcount(impl.(Impl).getSelfTy().(TypeMention).resolveTypeAt(selfTypePath)) > 1
    )
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
  or
  result = n.(ShorthandSelfParameterMention).resolveTypeAt(path)
}

/** Module for inferring certain type information. */
module CertainTypeInference {
  pragma[nomagic]
  private predicate callResolvesTo(CallExpr ce, Path p, Function f) {
    p = CallExprImpl::getFunctionPath(ce) and
    f = resolvePath(p)
  }

  pragma[nomagic]
  private Type getCallExprType(
    CallExpr ce, Path p, FunctionCallMatchingInput::FunctionDecl f, TypePath tp
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
  private Type inferCertainCallExprType(CallExpr ce, TypePath path) {
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
          ce.(FunctionCallMatchingInput::Access)
              .getTypeArgument(TTypeParamTypeArgumentPosition(tp), suffix)
      )
      or
      not ty instanceof TypeParameter and
      result = ty and
      path = prefix
    )
  }

  private Type inferCertainStructExprType(StructExpr se, TypePath path) {
    result = se.getPath().(TypeMention).resolveTypeAt(path)
  }

  private Type inferCertainStructPatType(StructPat sp, TypePath path) {
    result = sp.getPath().(TypeMention).resolveTypeAt(path)
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
      exists(LetStmt let |
        not let.hasTypeRepr() and
        // Due to "binding modes" the type of the pattern is not necessarily the
        // same as the type of the initializer. The pattern being an identifier
        // pattern is sufficient to ensure that this is not the case.
        let.getPat().(IdentPat) = n1 and
        let.getInitializer() = n2
      )
      or
      exists(LetExpr let |
        // Similarly as for let statements, we need to rule out binding modes
        // changing the type.
        let.getPat().(IdentPat) = n1 and
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
    result = inferAnnotatedType(n, path)
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
    result = inferLogicalOperationType(n, path)
    or
    result = inferCertainStructExprType(n, path)
    or
    result = inferCertainStructPatType(n, path)
    or
    result = inferRangeExprType(n) and
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
  exists(Builtins::Bool t, BinaryLogicalOperation be |
    n = [be, be.getLhs(), be.getRhs()] and
    path.isEmpty() and
    result = TStruct(t)
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
  re instanceof RangeFullExpr and
  result instanceof RangeFullStruct
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
    exists(LetExpr let |
      n1 = let.getScrutinee() and
      n2 = let.getPat()
    )
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
      exists(TypePath suffix |
        suffix.isCons(TTypeParamTypeParameter(apos.asTypeParam()), path) and
        result = CertainTypeInference::inferCertainType(this, suffix)
      )
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

pragma[nomagic]
private TypeMention getSelfParamTypeMention(SelfParam self) {
  result = self.(ShorthandSelfParameterMention)
  or
  result = self.getTypeRepr()
}

private newtype TFunctionTypePosition =
  TArgumentFunctionTypePosition(ArgumentPosition pos) or
  TReturnFunctionTypePosition()

/**
 * A position inside a function where the function can have a type.
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
 * Provides logic for identifying functions that are overloaded based on their
 * argument types. While Rust does not allow for overloading inside a single
 * `impl` block, it is still possible for a trait to have multiple implementations
 * that differ only in the types of non-`self` arguments.
 */
private module FunctionOverloading {
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

  /**
   * Holds if type parameter `tp` of `trait` occurs in the function `f` with the name
   * `functionName` at position `pos` and path `path`.
   *
   * Note that `pos` can also be the special `return` position, which is sometimes
   * needed to disambiguate associated function calls like `Default::default()`
   * (in this case, `tp` is the special `Self` type parameter).
   */
  bindingset[trait]
  pragma[inline_late]
  predicate traitTypeParameterOccurrence(
    TraitItemNode trait, Function f, string functionName, FunctionTypePosition pos, TypePath path,
    TypeParameter tp
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
  predicate functionResolutionDependsOnArgument(
    ImplItemNode impl, Function f, FunctionTypePosition pos, TypePath path, Type type
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

    exists(TraitItemNode trait, string functionName |
      implHasSibling(impl, trait) and
      traitTypeParameterOccurrence(trait, _, functionName, pos, path, _) and
      functionTypeAtPath(f, pos, path, type) and
      f = impl.getASuccessor(functionName) and
      not pos.isReturn()
    )
  }
}

private Trait getATraitBound(Type t) {
  result = t.(TypeParamTypeParameter).getTypeParam().(TypeParamItemNode).resolveABound()
  or
  result = t.(SelfTypeParameter).getTrait()
  or
  result = t.(ImplTraitType).getImplTraitTypeRepr().(ImplTraitTypeReprItemNode).resolveABound()
  or
  result = t.(DynTraitType).getTrait()
}

bindingset[t]
private Type substituteTraitBounds(Type t) {
  not exists(getATraitBound(t)) and
  result = t
  or
  result = TTrait(getATraitBound(t))
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
 * The type of a function at a given position, when viewed as a member of given
 * trait or `impl` block.
 *
 * Example:
 *
 * ```rust
 * trait T1 {
 *   fn m1(self);              // self1
 *
 *   fn m2(self) { m1(self); } // self2
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
private class FunctionType extends TFunctionType {
  private predicate asFunctionType(Function f, FunctionTypePosition pos, ImplOrTraitItemNode i) {
    this = MkFunctionType(f, pos, i)
  }

  private predicate asInheritedFunctionType(
    Function f, FunctionTypePosition pos, ImplOrTraitItemNode parent, ImplOrTraitItemNode i
  ) {
    this = MkInheritedFunctionType(f, pos, parent, i)
  }

  /**
   * Holds if this function type applies to the function `f` at position `pos`,
   * when viewed as a member of the `impl` or trait item `i`.
   */
  predicate appliesTo(Function f, FunctionTypePosition pos, ImplOrTraitItemNode i) {
    this.asFunctionType(f, pos, i)
    or
    this.asInheritedFunctionType(f, pos, _, i)
  }

  pragma[nomagic]
  private Type getTypeAt0(TypePath path) {
    exists(Function f, FunctionTypePosition pos |
      this.asFunctionType(f, pos, _) and
      functionTypeAtPath(f, pos, path, result)
    )
    or
    exists(
      Function f, FunctionTypePosition pos, FunctionType parentType, ImplOrTraitItemNode parent,
      ImplOrTraitItemNode i
    |
      this.asInheritedFunctionType(f, pos, parent, i) and
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
   * Calls will use `getATraitBound` to map receiver types to the relevant
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
      result = f.getSelfParam()
      or
      result = f.getParam(pos.asPositional())
      or
      pos.isReturn() and
      result = f.getRetType().getTypeRepr()
    )
  }

  string toString() { result = this.getReportingNode().toString() }

  Location getLocation() { result = this.getReportingNode().getLocation() }
}

bindingset[item, name]
pragma[inline_late]
private Function getMethodSuccessor(ItemNode item, string name, int arity) {
  result = item.getASuccessor(name) and
  arity = result.getParamList().getNumberOfParams()
}

/** Provides logic for resolving method calls. */
private module MethodCallResolution {
  /**
   * Holds if method `f` with the name `name` and the arity `arity` exists in
   * `i`, and the type of the `self` parameter is `selfType`.
   *
   * `rootType` is the root type of `selfType`, and `selfRootPath` points to
   * `selfRootType` inside `selfType`, where `selfRootType` is either the type
   * being implemented, when `i` is an `impl`, or the trait itself when `i` is
   * a trait.
   */
  pragma[nomagic]
  predicate methodInfo(
    Function f, string name, int arity, ImplOrTraitItemNode i, FunctionType selfType, Type rootType,
    TypePath selfRootPath, Type selfRootType
  ) {
    exists(FunctionTypePosition pos |
      f = i.getASuccessor(name) and
      arity = f.getParamList().getNumberOfParams() and
      rootType = selfType.getTypeAt(TypePath::nil()) and
      selfType.appliesTo(f, pos, i) and
      pos.isSelf() and
      selfType.getTypeAt(selfRootPath) = selfRootType and
      not i.(ImplItemNode).isBlanket()
    |
      selfRootType = i.(Impl).getSelfTy().(TypeMention).resolveType()
      or
      selfRootType = TTrait(i)
    )
  }

  pragma[nomagic]
  private predicate traitMethodInfo(string name, int arity, Trait trait) {
    exists(ImplItemNode i |
      methodInfo(_, name, arity, i, _, _, _, _) and
      trait = i.resolveTraitTy()
    )
  }

  pragma[nomagic]
  private predicate methodCallTraitCandidate(Element mc, Trait trait) {
    exists(string name, int arity |
      mc.(MethodCall).isMethodCall(name, arity) and
      traitMethodInfo(name, arity, trait)
    )
  }

  private predicate methodCallVisibleTraitCandidate(MethodCall mc, Trait trait) {
    TraitIsVisible<methodCallTraitCandidate/2>::traitIsVisible(mc, trait)
  }

  bindingset[mc, impl]
  pragma[inline_late]
  private predicate methodCallVisibleImplTraitCandidate(MethodCall mc, ImplItemNode impl) {
    methodCallVisibleTraitCandidate(mc, impl.resolveTraitTy())
  }

  /**
   * Holds if method call `mc` may target a method in `i` with `self` parameter having
   * type `selfType`.
   *
   * `rootType` is the root type of `selfType`, and `selfRootPath` points to
   * `selfRootType` inside `selfType`, where `selfRootType` is either the type
   * being implemented, when `i` is an `impl`, or the trait itself when `i` is
   * a trait.
   *
   * This predicate only checks for matching method names and arities, and whether
   * the trait being implemented by `i` (when `i` is not a trait itself) is visible
   * at `mc`.
   */
  pragma[inline]
  private predicate methodCallCandidate(
    MethodCall mc, ImplOrTraitItemNode i, FunctionType self, Type rootType, TypePath selfRootPath,
    Type selfRootType
  ) {
    exists(string name, int arity |
      mc.isMethodCall(name, arity) and
      methodInfo(_, name, arity, i, self, rootType, selfRootPath, selfRootType)
    |
      not i.(Impl).hasTrait()
      or
      methodCallVisibleImplTraitCandidate(mc, i)
      or
      mc instanceof IndexExpr and
      i.(ImplItemNode).resolveTraitTy() instanceof IndexTrait
    )
  }

  /**
   * A method call.
   *
   * This is either an actual method call, `x.m()`, or an index expression, `x[i]`
   * (which is [syntactic sugar][1] for `*x.index(i)`).
   *
   * When resolving a method call, a list of [candidate receiver types][2] is constructed
   *
   * > by repeatedly dereferencing the receiver expression's type, adding each type
   * > encountered to the list, then finally attempting an unsized coercion at the end,
   * > and adding the result type if that is successful.
   * >
   * > Then, for each candidate `T`, add `&T` and `&mut T` to the list immediately after `T`.
   *
   * We do not currently model unsized coercions, and we do not yet model the `Deref` trait,
   * instead we limit dereferencing to standard dereferencing and the fact that `String`
   * dereferences to `str` .
   *
   * [1]: https://doc.rust-lang.org/std/ops/trait.Index.html
   * [2]: https://doc.rust-lang.org/reference/expressions/method-call-expr.html#r-expr.method.candidate-receivers
   */
  abstract class MethodCall extends Expr {
    abstract predicate isMethodCall(string name, int arity);

    abstract Expr getArgument(ArgumentPosition pos);

    Expr getReceiver() { result = this.getArgument(any(ArgumentPosition pos | pos.isSelf())) }

    private Type getReceiverTypeAt(TypePath path) { result = inferType(this.getReceiver(), path) }

    /**
     * Same as `getACandidateReceiverTypeAt`, but without borrows.
     */
    pragma[nomagic]
    private Type getACandidateReceiverTypeAtNoBorrow(TypePath path, string derefChain) {
      result = this.getReceiverTypeAt(path) and
      derefChain = ""
      or
      exists(TypePath path0, Type t0, string derefChain0 |
        this.noCandidateReceiverTypeAt(derefChain0) and
        t0 = this.getACandidateReceiverTypeAtNoBorrow(path0, derefChain0)
      |
        path0.isCons(TRefTypeParameter(), path) and
        result = t0 and
        derefChain = derefChain0 + ".ref"
        or
        path0.isEmpty() and
        path = path0 and
        t0.(StructType).asItemNode() instanceof StringStruct and
        result.(StructType).asItemNode() instanceof Builtins::Str and
        derefChain = derefChain0 + ".str"
      )
    }

    /**
     * Holds if the method inside `i` with matching name and arity can be ruled out
     * as a candidate for the receiver type represented by `derefChainBorrow`.
     */
    pragma[nomagic]
    private predicate isNotCandidate(ImplOrTraitItemNode i, string derefChainBorrow) {
      IsInstantiationOf<MethodCallCand, FunctionType, MethodCallIsInstantiationOfInput>::isNotInstantiationOf(MkMethodCallCand(this,
          derefChainBorrow), i, _)
      or
      exists(Type rootType, TypePath selfRootPath, Type selfRootType |
        rootType = this.getACandidateReceiverTypeAtSubstituteTraitBounds(derefChainBorrow) and
        methodCallCandidate(this, i, _, rootType, selfRootPath, selfRootType) and
        selfRootType !=
          this.getACandidateReceiverTypeAtSubstituteTraitBounds(selfRootPath, derefChainBorrow)
      )
    }

    /**
     * Holds if the candidate receiver type represented by `derefChain` does not
     * have a matching method target.
     */
    pragma[nomagic]
    private predicate noCandidateReceiverTypeAtNoBorrow(string derefChain) {
      exists(Type rootType, string derefChainBorrow |
        derefChainBorrow = derefChain + ";" and
        not derefChain.matches("%.ref") and // no need to try a borrow if the last thing we did was a deref
        rootType = this.getACandidateReceiverTypeAtSubstituteTraitBounds(derefChainBorrow)
      |
        forall(ImplOrTraitItemNode i | methodCallCandidate(this, i, _, rootType, _, _) |
          this.isNotCandidate(i, derefChainBorrow)
        )
      )
    }

    pragma[nomagic]
    private predicate hasRefCandidate(ImplOrTraitItemNode i) {
      methodCallCandidate(this, i, _, TRefType(), _, _)
    }

    /**
     * Holds if the candidate receiver type represented by `derefChain;borrow` does not
     * have a matching method target.
     */
    pragma[nomagic]
    private predicate noCandidateReceiverTypeAt(string derefChain) {
      exists(string derefChainBorrow |
        derefChainBorrow = derefChain + ";borrow" and
        this.noCandidateReceiverTypeAtNoBorrow(derefChain)
      |
        forall(ImplOrTraitItemNode i | this.hasRefCandidate(i) |
          this.isNotCandidate(i, derefChainBorrow)
        )
      )
    }

    /**
     * Gets a [candidate receiver type][1] of this method call at `path`.
     *
     * The type is obtained by repeatedly dereferencing the receiver expression's type,
     * as long as the method cannot be resolved in an earlier candidate type, and possibly
     * applying a borrow at the end.
     *
     * The string `derefChainBorrow` encodes the sequences of dereferences and whether a
     * borrow has been applied.
     *
     * [1]: https://doc.rust-lang.org/reference/expressions/method-call-expr.html#r-expr.method.candidate-receivers
     */
    pragma[nomagic]
    Type getACandidateReceiverTypeAt(TypePath path, string derefChainBorrow) {
      exists(string derefChain |
        result = this.getACandidateReceiverTypeAtNoBorrow(path, derefChain) and
        derefChainBorrow = derefChain + ";"
        or
        this.noCandidateReceiverTypeAtNoBorrow(derefChain) and
        derefChainBorrow = derefChain + ";borrow" and
        (
          path.isEmpty() and
          result = TRefType()
          or
          exists(TypePath suffix |
            result = this.getACandidateReceiverTypeAtNoBorrow(suffix, derefChain) and
            path = TypePath::cons(TRefTypeParameter(), suffix)
          )
        )
      )
    }

    /**
     * Same as `getACandidateReceiverTypeAt`, but with traits substituted in for types
     * with trait bounds.
     */
    pragma[nomagic]
    Type getACandidateReceiverTypeAtSubstituteTraitBounds(TypePath path, string derefChainBorrow) {
      result = substituteTraitBounds(this.getACandidateReceiverTypeAt(path, derefChainBorrow))
    }

    pragma[nomagic]
    private Type getACandidateReceiverTypeAtSubstituteTraitBounds(string derefChainBorrow) {
      result =
        this.getACandidateReceiverTypeAtSubstituteTraitBounds(TypePath::nil(), derefChainBorrow)
    }

    /**
     * Gets a method that this call resolves to after having applied a sequence of
     * dereferences and possibly a borrow on the receiver type, encoded in the string
     * `derefChainBorrow`.
     */
    pragma[nomagic]
    Function resolveCallTarget(string derefChainBorrow) {
      result = MkMethodCallCand(this, derefChainBorrow).(MethodCallCand).resolveCallTarget()
    }

    predicate receiverHasImplicitDeref(AstNode receiver) {
      exists(this.resolveCallTarget(".ref;")) and
      receiver = this.getArgument(CallImpl::TSelfArgumentPosition())
    }

    predicate receiverHasImplicitBorrow(AstNode receiver) {
      exists(this.resolveCallTarget(";borrow")) and
      receiver = this.getArgument(CallImpl::TSelfArgumentPosition())
    }
  }

  private class MethodCallMethodCallExpr extends MethodCall instanceof MethodCallExpr {
    pragma[nomagic]
    override predicate isMethodCall(string name, int arity) {
      name = super.getIdentifier().getText() and
      arity = super.getArgList().getNumberOfArgs()
    }

    override Expr getArgument(ArgumentPosition pos) {
      pos.isSelf() and
      result = MethodCallExpr.super.getReceiver()
      or
      result = super.getArgList().getArg(pos.asPosition())
    }
  }

  private class MethodCallIndexExpr extends MethodCall, IndexExpr {
    pragma[nomagic]
    override predicate isMethodCall(string name, int arity) {
      name = "index" and
      arity = 1
    }

    override Expr getArgument(ArgumentPosition pos) {
      pos.isSelf() and
      result = this.getBase()
      or
      pos.asPosition() = 0 and
      result = this.getIndex()
    }
  }

  private newtype TMethodCallCand =
    MkMethodCallCand(MethodCall mc, string derefChainBorrow) {
      exists(mc.getACandidateReceiverTypeAt(_, derefChainBorrow))
    }

  /** A method call tagged with a candidate receiver type. */
  private class MethodCallCand extends MkMethodCallCand {
    MethodCall mc_;
    string derefChainBorrow;

    MethodCallCand() { this = MkMethodCallCand(mc_, derefChainBorrow) }

    MethodCall getMethodCall() { result = mc_ }

    Type getTypeAt(TypePath path) {
      result = mc_.getACandidateReceiverTypeAtSubstituteTraitBounds(path, derefChainBorrow)
    }

    pragma[nomagic]
    predicate isMethodCall(MethodCall mc, TypePath path, Type type, string name, int arity) {
      type = this.getTypeAt(path) and
      mc = mc_ and
      mc.isMethodCall(name, arity)
    }

    /**
     * Holds if the inherent method inside `i` with matching name and arity can be
     * ruled out as a candidate for this call.
     */
    pragma[nomagic]
    private predicate isNotInherentCandidate(Impl impl) {
      IsInstantiationOf<MethodCallCand, FunctionType, MethodCallIsNotInstantiationOfInput>::isNotInstantiationOf(this,
        impl, _)
    }

    /**
     * Holds if this method call has no inherent target, i.e., it does not
     * resolve to a method in an `impl` block for the type of the receiver.
     */
    pragma[nomagic]
    private predicate hasNoInherentTarget() {
      exists(Type rootType, string name, int arity |
        this.isMethodCall(_, TypePath::nil(), rootType, name, arity) and
        forall(Impl i, FunctionType self, TypePath selfRootPath, Type selfRootType |
          methodInfo(_, name, arity, i, self, rootType, selfRootPath, selfRootType) and
          not i.hasTrait()
        |
          this.isNotInherentCandidate(i)
        )
      )
    }

    pragma[nomagic]
    private Function resolveCallTargetCand(ImplOrTraitItemNode i) {
      exists(string name |
        IsInstantiationOf<MethodCallCand, FunctionType, MethodCallIsInstantiationOfInput>::isInstantiationOf(this,
          i, _) and
        mc_.isMethodCall(name, _) and
        result = getMethodSuccessor(i, name, _) and
        if i.(Impl).hasTrait()
        then
          // inherent methods take precedence over trait methods, so only allow
          // trait methods when there are no matching inherent methods
          this.hasNoInherentTarget()
        else any()
      )
    }

    pragma[nomagic]
    private Type inferPositionalArgumentType(FunctionTypePosition pos, TypePath path) {
      pos.isPositional() and
      result = substituteTraitBounds(inferType(mc_.getArgument(pos.asArgumentPosition()), path))
    }

    pragma[nomagic]
    private Function resolveAmbigousCallTargetCand(
      FunctionTypePosition pos, TypePath path, Type type
    ) {
      exists(ImplOrTraitItemNode i |
        result = this.resolveCallTargetCand(i) and
        FunctionOverloading::functionResolutionDependsOnArgument(i, result, pos, path, type)
      )
    }

    /** Gets a method that matches this method call. */
    pragma[nomagic]
    Function resolveCallTarget() {
      exists(ImplOrTraitItemNode i |
        result = this.resolveCallTargetCand(i) and
        not exists(FunctionTypePosition pos |
          FunctionOverloading::functionResolutionDependsOnArgument(i, _, pos, _, _) and
          pos.isPositional()
        )
      )
      or
      exists(FunctionTypePosition pos, TypePath path, Type type |
        result = this.resolveAmbigousCallTargetCand(pos, path, type) and
        type = this.inferPositionalArgumentType(pos, path)
      )
    }

    string toString() { result = mc_.toString() + " [" + derefChainBorrow + "]" }

    Location getLocation() { result = mc_.getLocation() }
  }

  /**
   * A configuration for matching the type of a receiver against the type of
   * a `self` parameter.
   */
  private module MethodCallIsInstantiationOfInput implements
    IsInstantiationOfInputSig<MethodCallCand, FunctionType>
  {
    pragma[nomagic]
    predicate potentialInstantiationOf(
      MethodCallCand mcc, TypeAbstraction abs, FunctionType constraint
    ) {
      exists(MethodCall mc, string name, int arity, TypePath selfRootPath, Type selfRootType |
        mcc.isMethodCall(mc, selfRootPath, selfRootType, name, arity) and
        methodCallCandidate(mc, abs, constraint, _, selfRootPath, selfRootType)
      )
    }

    predicate relevantTypeMention(FunctionType constraint) {
      methodInfo(_, _, _, _, constraint, _, _, _)
    }
  }

  /**
   * A configuration for anti-matching the type of a receiver against the type of
   * a `self` parameter in an inherent method.
   */
  private module MethodCallIsNotInstantiationOfInput implements
    IsInstantiationOfInputSig<MethodCallCand, FunctionType>
  {
    pragma[nomagic]
    predicate potentialInstantiationOf(
      MethodCallCand mcc, TypeAbstraction abs, FunctionType constraint
    ) {
      abs = any(Impl i | not i.hasTrait()) and
      exists(MethodCall mc, string name, int arity, Type rootType |
        mcc.isMethodCall(mc, TypePath::nil(), rootType, name, arity) and
        methodCallCandidate(mc, abs, constraint, rootType, _, _)
      )
    }

    predicate relevantTypeMention(FunctionType constraint) {
      methodInfo(_, _, _, _, constraint, _, _, _)
    }
  }
}

/**
 * A matching configuration for resolving types of method call expressions
 * like `foo.bar(baz)`.
 */
private module MethodCallMatchingInput implements MatchingWithEnvironmentInputSig {
  class DeclarationPosition = FunctionTypePosition;

  final class Declaration extends Function {
    TypeParameter getTypeParameter(TypeParameterPosition ppos) {
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

    pragma[nomagic]
    Type getParameterType(DeclarationPosition dpos, TypePath path) {
      exists(Param p, int i |
        p = this.getParam(i) and
        i = dpos.asPositional() and
        result = p.getTypeRepr().(TypeMention).resolveTypeAt(path)
      )
      or
      dpos.isSelf() and
      exists(SelfParam self |
        self = pragma[only_bind_into](this.getSelfParam()) and
        result = getSelfParamTypeMention(self).resolveTypeAt(path)
      )
    }

    private Type resolveRetType(TypePath path) {
      result = this.getRetType().getTypeRepr().(TypeMention).resolveTypeAt(path)
    }

    pragma[nomagic]
    Type getReturnType(TypePath path) {
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

    Type getDeclaredType(DeclarationPosition dpos, TypePath path) {
      result = this.getParameterType(dpos, path)
      or
      dpos.isReturn() and
      result = this.getReturnType(path)
    }
  }

  class AccessPosition = DeclarationPosition;

  class AccessEnvironment = string;

  final private class MethodCallFinal = MethodCallResolution::MethodCall;

  class Access extends MethodCallFinal {
    pragma[nomagic]
    Type getTypeArgument(TypeArgumentPosition apos, TypePath path) {
      exists(TypeMention arg |
        result = arg.resolveTypeAt(path) and
        arg =
          this.(MethodCallExpr).getGenericArgList().getTypeArg(apos.asMethodTypeArgumentPosition())
      )
    }

    AstNode getNodeAt(AccessPosition apos) {
      result = this.getArgument(apos.asArgumentPosition())
      or
      result = this and apos.isReturn()
    }

    pragma[nomagic]
    private Type getInferredSelfType(AccessEnvironment state, TypePath path) {
      result = this.getACandidateReceiverTypeAt(path, state)
    }

    pragma[nomagic]
    Type getInferredNonSelfType(AccessPosition apos, TypePath path) {
      if
        // index expression `x[i]` desugars to `*x.index(i)`, so we must account for
        // the implicit deref
        apos.isReturn() and
        this instanceof IndexExpr
      then
        path.isEmpty() and
        result = TRefType()
        or
        exists(TypePath suffix |
          result = inferType(this.getNodeAt(apos), suffix) and
          path = TypePath::cons(TRefTypeParameter(), suffix)
        )
      else (
        not apos.asArgumentPosition().isSelf() and
        result = inferType(this.getNodeAt(apos), path)
      )
    }

    pragma[nomagic]
    Type getInferredType(AccessEnvironment state, AccessPosition apos, TypePath path) {
      apos.asArgumentPosition().isSelf() and
      result = this.getInferredSelfType(state, path)
      or
      result = this.getInferredNonSelfType(apos, path) and
      exists(this.getTarget(state))
    }

    Declaration getTarget(AccessEnvironment state) {
      result = this.resolveCallTarget(state) // mutual recursion; resolving method calls requires resolving types and vice versa
    }
  }

  predicate accessDeclarationPositionMatch(AccessPosition apos, DeclarationPosition dpos) {
    apos = dpos
  }
}

private module MethodCallMatching = MatchingWithEnvironment<MethodCallMatchingInput>;

pragma[nomagic]
private Type inferMethodCallExprType0(
  MethodCallMatchingInput::Access a, MethodCallMatchingInput::AccessPosition apos, AstNode n,
  string state, TypePath path
) {
  exists(TypePath path0 |
    n = a.getNodeAt(apos) and
    result = MethodCallMatching::inferAccessType(a, state, apos, path0)
  |
    if
      // index expression `x[i]` desugars to `*x.index(i)`, so we must account for
      // the implicit deref
      apos.isReturn() and
      a instanceof IndexExpr
    then path0.isCons(TRefTypeParameter(), path)
    else path = path0
  )
}

/**
 * Gets the type of `n` at `path`, where `n` is either a method call or an
 * argument/receiver of a method call.
 */
pragma[nomagic]
private Type inferMethodCallExprType(AstNode n, TypePath path) {
  exists(
    MethodCallMatchingInput::Access a, MethodCallMatchingInput::AccessPosition apos, string state,
    TypePath path0
  |
    result = inferMethodCallExprType0(a, apos, n, state, path0)
  |
    (
      not apos.asArgumentPosition().isSelf()
      or
      state = ";"
    ) and
    path = path0
    or
    // adjust for implicit deref
    apos.asArgumentPosition().isSelf() and
    state = ".ref;" and
    path = TypePath::cons(TRefTypeParameter(), path0)
    or
    // adjust for implicit borrow
    apos.asArgumentPosition().isSelf() and
    state = ";borrow" and
    path0.isCons(TRefTypeParameter(), path)
  )
}

/** Provides logic for resolving function calls. */
private module FunctionCallResolution {
  private import FunctionOverloading

  bindingset[trait, resolved, result]
  pragma[inline_late]
  Function assocTraitFunctionDependsOnArgument(
    TraitItemNode trait, Function resolved, FunctionTypePosition pos, TypePath path, Type type
  ) {
    not resolved.hasSelfParam() and
    functionTypeAtPath(result, pos, path, type) and
    traitTypeParameterOccurrence(trait, resolved, _, pos, _, _) and
    (
      not pos.isReturn()
      or
      // We only check that the context of the call provides relevant type information
      // when no argument can
      not exists(FunctionTypePosition pos0 |
        traitTypeParameterOccurrence(trait, resolved, _, pos0, _, _) and
        not pos0.isReturn()
      )
    )
  }

  /** A function call, `f(x)`. */
  final class FunctionCall extends CallExpr {
    private ItemNode getPathResolutionResolvedFunction() {
      result = CallExprImpl::getResolvedFunction(this)
    }

    ItemNode getPathResolutionResolvedFunctionOrImplementation(ItemNode resolved) {
      resolved = this.getPathResolutionResolvedFunction() and
      (
        result = resolved
        or
        result.(AssocItem).implements(resolved)
      )
    }

    pragma[nomagic]
    Type getTypeAt(TypePath path) {
      result = substituteTraitBounds(inferType(this.getArg(0), path))
    }

    pragma[nomagic]
    private Function getACandidateTraitMethod() {
      exists(TraitItemNode trait, ImplOrTraitItemNode i, FunctionType self, Function resolved |
        FunctionMethodCallIsInstantiationOfInput::potentialInstantiationOf(this, trait, i, self,
          resolved, result) and
        IsInstantiationOf<FunctionCall, FunctionType, FunctionMethodCallIsInstantiationOfInput>::isInstantiationOf(this,
          i, self)
      )
    }

    pragma[nomagic]
    private Function getAnAmbigousCandidate(FunctionTypePosition pos, TypePath path, Type type) {
      exists(TraitItemNode trait, Function resolved |
        result = this.getPathResolutionResolvedFunctionOrImplementation(resolved) and
        trait = this.(Call).getTrait() and
        result = assocTraitFunctionDependsOnArgument(trait, resolved, pos, path, type)
      )
      or
      (
        result = this.getACandidateTraitMethod()
        or
        not this.(Call).hasTrait() and
        result = this.getPathResolutionResolvedFunction()
      ) and
      functionResolutionDependsOnArgument(_, result, pos, path, type)
    }

    pragma[nomagic]
    private Type inferArgumentType(FunctionTypePosition pos, TypePath path) {
      result = substituteTraitBounds(inferType(this.getArg(pos.asPositional()), path))
      or
      pos.isReturn() and
      result = substituteTraitBounds(inferType(this, path))
    }

    /**
     * Gets the target of `call`, where resolution relies on type inference.
     */
    pragma[nomagic]
    private Function resolveAmbigousFunctionCallTarget() {
      exists(FunctionTypePosition pos, TypePath path, Type type |
        result = this.getAnAmbigousCandidate(pos, path, type) and
        type = this.inferArgumentType(pos, path)
      )
    }

    /**
     * Gets the target of this call, where resolution does not rely on type inference.
     */
    pragma[nomagic]
    private ItemNode resolveUnambigousFunctionCallTarget() {
      (
        result = this.getACandidateTraitMethod()
        or
        not this.(Call).hasTrait() and
        result = this.getPathResolutionResolvedFunction()
      ) and
      not functionResolutionDependsOnArgument(_, result, _, _, _)
    }

    ItemNode resolveCallTarget() {
      result = this.resolveUnambigousFunctionCallTarget()
      or
      result = this.resolveAmbigousFunctionCallTarget()
    }
  }

  private module FunctionMethodCallIsInstantiationOfInput implements
    IsInstantiationOfInputSig<FunctionCall, FunctionType>
  {
    pragma[nomagic]
    additional predicate potentialInstantiationOf(
      FunctionCall call, TraitItemNode trait, ImplOrTraitItemNode i, FunctionType self,
      Function resolved, Function f
    ) {
      exists(TypePath selfRootPath, Type selfRootType |
        f = call.getPathResolutionResolvedFunctionOrImplementation(resolved) and
        trait = call.(Call).getTrait() and
        MethodCallResolution::methodInfo(f, _, _, i, self, _, selfRootPath, selfRootType) and
        call.getTypeAt(selfRootPath) = selfRootType
      )
    }

    pragma[nomagic]
    predicate potentialInstantiationOf(
      FunctionCall call, TypeAbstraction abs, FunctionType constraint
    ) {
      potentialInstantiationOf(call, _, abs, constraint, _, _)
    }

    predicate relevantTypeMention(FunctionType constraint) {
      MethodCallResolution::methodInfo(_, _, _, _, constraint, _, _, _)
    }
  }
}

/**
 * A matching configuration for resolving types of function calls
 * like `foo::bar(baz)`.
 */
private module FunctionCallMatchingInput implements MatchingInputSig {
  class DeclarationPosition = FunctionTypePosition;

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
        pos = dpos.asPositional()
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
        pos = dpos.asPositional()
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
      // todo: update
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
      dpos.isSelf() and
      exists(ImplOrTraitItemNode i |
        this = i.getAnAssocItem() and
        result = resolveImplOrTraitType(i, path)
      )
      or
      exists(Param p, int i |
        p = this.getParam(i) and
        result = p.getTypeRepr().(TypeMention).resolveTypeAt(path) and
        if this.hasSelfParam() then dpos.asPositional() = i + 1 else dpos.asPositional() = i
      )
      or
      dpos.asPositional() = 0 and
      exists(SelfParam self |
        self = pragma[only_bind_into](this.getSelfParam()) and
        result = getSelfParamTypeMention(self).resolveTypeAt(path)
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

  class AccessPosition = DeclarationPosition;

  class Access extends FunctionCallResolution::FunctionCall {
    pragma[nomagic]
    Type getTypeArgument(TypeArgumentPosition apos, TypePath path) {
      exists(TypeMention arg | result = arg.resolveTypeAt(path) |
        exists(Path p, int i |
          p = CallExprImpl::getFunctionPath(this) and
          arg = p.getSegment().getGenericArgList().getTypeArg(pragma[only_bind_into](i)) and
          apos.asTypeParam() = resolvePath(p).getTypeParam(pragma[only_bind_into](i))
        )
      )
    }

    AstNode getNodeAt(AccessPosition apos) {
      exists(ArgumentPosition pos |
        pos = apos.asArgumentPosition() and
        result = this.getArg(pos.asPosition())
      )
      or
      result = this and apos.isReturn()
    }

    /**
     * Gets the type qualifier of this function call, if any.
     *
     * For example, the type qualifier of `Foo::<Bar>::baz()` is `Foo::<Bar>`,
     * but only when `Foo` is not a trait.
     */
    pragma[nomagic]
    private Type getQualifierType(TypePath path) {
      exists(PathExpr pe, TypeMention tm |
        pe = this.getFunction() and
        tm = pe.getPath().getQualifier() and
        result = tm.resolveTypeAt(path) and
        not resolvePath(tm) instanceof Trait
      )
    }

    pragma[nomagic]
    Type getInferredType(AccessPosition apos, TypePath path) {
      apos.asArgumentPosition().isSelf() and
      result = this.getQualifierType(path)
      or
      result = inferType(this.getNodeAt(apos), path)
    }

    Declaration getTarget() {
      result = this.resolveCallTarget() // potential mutual recursion; resolving some associated function calls requires resolving types
    }
  }

  predicate accessDeclarationPositionMatch(AccessPosition apos, DeclarationPosition dpos) {
    apos = dpos
  }
}

private module FunctionCallMatching = Matching<FunctionCallMatchingInput>;

pragma[nomagic]
private Type inferCallExprType(AstNode n, TypePath path) {
  exists(FunctionCallMatchingInput::Access a, FunctionCallMatchingInput::AccessPosition apos |
    n = a.getNodeAt(apos) and
    result = FunctionCallMatching::inferAccessType(a, apos, path)
  )
}

/** Provides logic for resolving operations. */
private module OperationResolution {
  /** An operation, `x + y`. */
  final class Op extends Operation {
    pragma[nomagic]
    private Type getTypeAt0(TypePath path) {
      if this.(Call).implicitBorrowAt(any(ArgumentPosition pos | pos.isSelf()), true)
      then
        result = TRefType() and
        path.isEmpty()
        or
        exists(TypePath path0 |
          result = inferType(this.getOperand(0), path0) and
          path = TypePath::cons(TRefTypeParameter(), path0)
        )
      else result = inferType(this.getOperand(0), path)
    }

    pragma[nomagic]
    Type getTypeAt(TypePath path) { result = substituteTraitBounds(this.getTypeAt0(path)) }

    pragma[nomagic]
    predicate isOperation(TypePath path, Type type, Trait trait, string name, int arity) {
      name = this.(Call).getMethodName() and
      arity = this.(Call).getNumberOfArguments() and
      type = this.getTypeAt(path) and
      trait = this.(Call).getTrait()
    }

    pragma[nomagic]
    private predicate hasImplCandidate(ImplOrTraitItemNode i) {
      IsInstantiationOf<Op, FunctionType, OperationIsInstantiationOfInput>::isInstantiationOf(this,
        i, _)
    }

    /** Gets a method from an `impl` block that matches the method call `mc`. */
    pragma[nomagic]
    Function resolveCallTarget() {
      exists(ImplOrTraitItemNode i, string name |
        this.hasImplCandidate(i) and
        name = this.(Call).getMethodName() and
        result = getMethodSuccessor(i, name, _)
      |
        not FunctionOverloading::functionResolutionDependsOnArgument(i, result,
          any(FunctionTypePosition pos | pos.isPositional()), _, _)
        or
        exists(FunctionTypePosition pos, TypePath path, Type type |
          FunctionOverloading::functionResolutionDependsOnArgument(i, result, pos,
            pragma[only_bind_into](path), type) and
          inferType(this.getOperand(pos.asPositional() + 1), pragma[only_bind_into](path)) = type
        )
      )
    }
  }

  private module OperationIsInstantiationOfInput implements
    IsInstantiationOfInputSig<Op, FunctionType>
  {
    pragma[nomagic]
    private predicate methodInfo(
      TypeAbstraction abs, FunctionType constraint, Trait trait, string name, int arity,
      TypePath selfRootPath, Type selfRootType
    ) {
      MethodCallResolution::methodInfo(_, name, arity, abs, constraint, _, selfRootPath,
        selfRootType) and
      (
        trait = abs.(ImplItemNode).resolveTraitTy()
        or
        trait = abs
      )
    }

    pragma[nomagic]
    predicate potentialInstantiationOf(Op op, TypeAbstraction abs, FunctionType constraint) {
      exists(Trait trait, string name, int arity, TypePath selfRootPath, Type selfRootType |
        op.isOperation(selfRootPath, selfRootType, trait, name, arity) and
        methodInfo(abs, constraint, trait, name, arity, selfRootPath, selfRootType)
      )
    }

    predicate relevantTypeMention(FunctionType constraint) {
      MethodCallResolution::methodInfo(_, _, _, _, constraint, _, _, _)
    }
  }
}

/**
 * A matching configuration for resolving types of operations
 * like `a + b`.
 */
private module OperationMatchingInput implements MatchingInputSig {
  private import codeql.rust.elements.internal.OperationImpl as OperationImpl

  class DeclarationPosition = FunctionTypePosition;

  class Declaration extends MethodCallMatchingInput::Declaration {
    pragma[nomagic]
    private predicate borrowsAt(DeclarationPosition pos) {
      // todo: cleanup
      exists(TraitItemNode t, Function f, string path, string method |
        (
          f = this
          or
          this.implements(f)
        ) and
        f = t.getAssocItem(method) and
        path = t.getCanonicalPath(_)
      |
        exists(int borrows | OperationImpl::isOverloaded(_, _, path, method, borrows) |
          pos.isSelf() and borrows >= 1
          or
          pos.asPositional() = 0 and
          borrows >= 2
        )
      )
    }

    pragma[nomagic]
    private Type getParameterType(DeclarationPosition dpos, TypePath path) {
      exists(TypePath path0 |
        result = super.getParameterType(dpos, path0) and
        if this.borrowsAt(dpos) then path0.isCons(TRefTypeParameter(), path) else path0 = path
      )
    }

    pragma[nomagic]
    private predicate derefsReturn() {
      exists(Function f |
        (
          f = this
          or
          this.implements(f)
        ) and
        (
          f = any(DerefTrait t).getDerefFunction()
          or
          f = any(IndexTrait t).getIndexFunction()
        )
      )
    }

    pragma[nomagic]
    private Type getReturnType(TypePath path) {
      exists(TypePath path0 |
        result = super.getReturnType(path0) and
        if this.derefsReturn() then path0.isCons(TRefTypeParameter(), path) else path0 = path
      )
    }

    Type getDeclaredType(DeclarationPosition dpos, TypePath path) {
      result = this.getParameterType(dpos, path)
      or
      dpos.isReturn() and
      result = this.getReturnType(path)
    }
  }

  class AccessPosition = MethodCallMatchingInput::AccessPosition;

  class Access extends OperationResolution::Op {
    Type getTypeArgument(TypeArgumentPosition apos, TypePath path) { none() }

    AstNode getNodeAt(AccessPosition apos) {
      exists(ArgumentPosition pos | pos = apos.asArgumentPosition() |
        result = this.getOperand(0) and
        pos.isSelf()
        or
        result = this.getOperand(pos.asPosition() + 1)
      )
      or
      result = this and apos.isReturn()
    }

    pragma[nomagic]
    Type getInferredType(AccessPosition apos, TypePath path) {
      result = inferType(this.getNodeAt(apos), path)
    }

    Declaration getTarget() {
      result = this.resolveCallTarget() // mutual recursion
    }
  }

  predicate accessDeclarationPositionMatch =
    MethodCallMatchingInput::accessDeclarationPositionMatch/2;
}

private module OperationMatching = Matching<OperationMatchingInput>;

pragma[nomagic]
private Type inferOperationType(AstNode n, TypePath path) {
  exists(OperationMatchingInput::Access a, OperationMatchingInput::AccessPosition apos |
    n = a.getNodeAt(apos) and
    result = OperationMatching::inferAccessType(a, apos, path)
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
      exists(TypePath path0 | result = inferType(this.getNodeAt(apos), path0) |
        if apos.isSelf()
        then
          // adjust for implicit deref
          path0.isCons(TRefTypeParameter(), path)
          or
          not path0.isCons(TRefTypeParameter(), _) and
          not (result = TRefType() and path0.isEmpty()) and
          path = path0
        else path = path0
      )
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
    // todo: remove?
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
  class DeclarationPosition = FunctionCallMatchingInput::DeclarationPosition;

  class Declaration = FunctionCallMatchingInput::TupleDeclaration;

  class AccessPosition = DeclarationPosition;

  class Access extends TupleStructPat {
    Type getTypeArgument(TypeArgumentPosition apos, TypePath path) { none() }

    AstNode getNodeAt(AccessPosition apos) {
      result = this.getField(apos.asPositional())
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

cached
private module Cached {
  private import codeql.rust.internal.CachedStages

  /** Holds if `receiver` is the receiver of a method call with an implicit dereference. */
  cached
  predicate receiverHasImplicitDeref(AstNode receiver) {
    exists(MethodCallResolution::MethodCall mc | mc.receiverHasImplicitDeref(receiver))
  }

  /** Holds if `receiver` is the receiver of a method call with an implicit borrow. */
  cached
  predicate receiverHasImplicitBorrow(AstNode receiver) {
    exists(MethodCallResolution::MethodCall mc | mc.receiverHasImplicitBorrow(receiver))
    or
    exists(OperationResolution::Op op |
      op.(Call).implicitBorrowAt(CallImpl::TSelfArgumentPosition(), true) and
      receiver = op.getOperand(0)
    )
  }

  /** Gets a function that `call` resolves to, if any. */
  cached
  Function resolveCallTarget(Call call) {
    result = call.(MethodCallResolution::MethodCall).resolveCallTarget(_)
    or
    result = call.(FunctionCallResolution::FunctionCall).resolveCallTarget()
    or
    result = call.(OperationResolution::Op).resolveCallTarget()
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
      result = inferAssignmentOperationType(n, path)
      or
      result = inferTypeEquality(n, path)
      or
      result = inferStructExprType(n, path)
      or
      result = inferPathExprType(n, path)
      or
      result = inferMethodCallExprType(n, path)
      or
      result = inferCallExprType(n, path)
      or
      result = inferOperationType(n, path)
      or
      result = inferFieldExprType(n, path)
      or
      result = inferTryExprType(n, path)
      or
      result = inferLiteralType(n, path, false)
      or
      result = inferAwaitExprType(n, path)
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
  Locatable getRelevantLocatable() {
    exists(string filepath, int startline, int startcolumn, int endline, int endcolumn |
      result.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) and
      // filepath.matches("%/crates/wdk-macros/src/lib.rs") and
      // endline = [255 .. 256]
      filepath.matches("%/main.rs") and
      startline = 286
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

  predicate debugInferShorthandSelfType(ShorthandSelfParameterMention self, TypePath path, Type t) {
    self = getRelevantLocatable() and
    t = self.resolveTypeAt(path)
  }

  predicate debuginferMethodCallExprType(AstNode n, TypePath path, Type t) {
    n = getRelevantLocatable() and
    t = inferMethodCallExprType(n, path)
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
  // predicate debugisMethodCall(MethodCall mc, Type rootType, string name, int arity) {
  //   mc = getRelevantLocatable() and
  //   isMethodCall(mc, rootType, name, arity)
  // }
  // predicate debugMethodCallHasImplCandidate(MethodCall mc, Impl impl) {
  //   mc = getRelevantLocatable() and
  //   methodCallHasImplCandidate(mc, impl)
  // }
}
