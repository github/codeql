/** Provides functionality for inferring types. */

private import codeql.util.Boolean
private import rust
private import PathResolution
private import Type
private import Type as T
private import TypeMention
private import typeinference.FunctionType
private import typeinference.FunctionOverloading as FunctionOverloading
private import typeinference.BlanketImplementation as BlanketImplementation
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

import M1

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

import M2

module Consistency {
  import M2::Consistency

  private Type inferCertainTypeAdj(AstNode n, TypePath path) {
    result = CertainTypeInference::inferCertainType(n, path) and
    not result = TNeverType()
  }

  predicate nonUniqueCertainType(AstNode n, TypePath path, Type t) {
    strictcount(inferCertainTypeAdj(n, path)) > 1 and
    t = inferCertainTypeAdj(n, path) and
    // Suppress the inconsistency if `n` is a self parameter and the type
    // mention for the self type has multiple types for a path.
    not exists(ImplItemNode impl, TypePath selfTypePath |
      n = impl.getAnAssocItem().(Function).getSelfParam() and
      strictcount(impl.(Impl).getSelfTy().(TypeMention).resolveTypeAt(selfTypePath)) > 1
    )
  }
}

/** A method, that is, a function with a `self` parameter. */
private class Method extends Function {
  Method() { this.hasSelfParam() }
}

/** A function without a `self` parameter. */
private class NonMethodFunction extends Function {
  NonMethodFunction() { not this.hasSelfParam() }
}

pragma[nomagic]
private TypeMention getCallExprTypeArgument(CallExpr ce, TypeArgumentPosition apos) {
  exists(Path p, int i |
    p = CallExprImpl::getFunctionPath(ce) and
    result = p.getSegment().getGenericArgList().getTypeArg(pragma[only_bind_into](i)) and
    apos.asTypeParam() = resolvePath(p).getTypeParam(pragma[only_bind_into](i))
  )
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
    result = getReturnTypeMention(f) and
    n = f.getFunctionBody()
  )
}

/** Gets the type of `n`, which has an explicit type annotation. */
pragma[nomagic]
private Type inferAnnotatedType(AstNode n, TypePath path) {
  result = getTypeAnnotation(n).resolveTypeAt(path)
  or
  result = n.(ShorthandSelfParameterMention).resolveTypeAt(path)
}

/**
 * Holds if `me` is a call to the `panic!` macro.
 *
 * `panic!` needs special treatment, because it expands to a block expression
 * that looks like it should have type `()` instead of the correct `!` type.
 */
pragma[nomagic]
private predicate isPanicMacroCall(MacroExpr me) {
  me.getMacroCall().resolveMacro().(MacroRules).getName().getText() = "panic"
}

/** Module for inferring certain type information. */
module CertainTypeInference {
  pragma[nomagic]
  private predicate callResolvesTo(CallExpr ce, Path p, Function f) {
    p = CallExprImpl::getFunctionPath(ce) and
    f = resolvePath(p)
  }

  pragma[nomagic]
  private Type getCallExprType(CallExpr ce, Path p, Function f, TypePath tp) {
    callResolvesTo(ce, p, f) and
    result =
      [
        f.(MethodCallMatchingInput::Declaration).getReturnType(tp),
        f.(NonMethodCallMatchingInput::Declaration).getReturnType(tp)
      ]
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
          getCallExprTypeArgument(ce, TTypeParamTypeArgumentPosition(tp)).resolveTypeAt(suffix)
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
    result = inferBlockExprType(n, path)
    or
    result = inferArrayExprType(n) and
    path.isEmpty()
    or
    result = inferCastExprType(n, path)
    or
    exprHasUnitType(n) and
    path.isEmpty() and
    result instanceof UnitType
    or
    isPanicMacroCall(n) and
    path.isEmpty() and
    result instanceof NeverType
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

private predicate bodyReturns(Expr body, Expr e) {
  exists(ReturnExpr re, Callable c |
    e = re.getExpr() and
    c = re.getEnclosingCallable() and
    body = c.getBody()
  )
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
    n2 =
      any(MatchExpr me |
        n1 = me.getAnArm().getExpr() and
        me.getNumberOfArms() = 1
      )
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
    n1 = n2.(MacroExpr).getMacroCall().getMacroCallExpansion() and
    not isPanicMacroCall(n2)
    or
    n1 = n2.(MacroPat).getMacroCall().getMacroCallExpansion()
    or
    bodyReturns(n1, n2) and
    strictcount(Expr e | bodyReturns(n1, e)) = 1
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
  // an array list expression with only one element (such as `[1]`) has type from that element
  n1 =
    any(ArrayListExpr ale |
      ale.getAnExpr() = n2 and
      ale.getNumberOfExprs() = 1
    ) and
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
  n1.(ClosureExpr).getClosureBody() = n2 and
  prefix1 = closureReturnPath() and
  prefix2.isEmpty()
}

/**
 * Holds if `child` is a child of `parent`, and the Rust compiler applies [least
 * upper bound (LUB) coercion](1) to infer the type of `parent` from the type of
 * `child`.
 *
 * In this case, we want type information to only flow from `child` to `parent`,
 * to avoid (a) either having to model LUB coercions, or (b) risk combinatorial
 * explosion in inferred types.
 *
 * [1]: https://doc.rust-lang.org/reference/type-coercions.html#r-coerce.least-upper-bound
 */
private predicate lubCoercion(AstNode parent, AstNode child, TypePath prefix) {
  child = parent.(IfExpr).getABranch() and
  prefix.isEmpty()
  or
  parent =
    any(MatchExpr me |
      child = me.getAnArm().getExpr() and
      me.getNumberOfArms() > 1
    ) and
  prefix.isEmpty()
  or
  parent =
    any(ArrayListExpr ale |
      child = ale.getAnExpr() and
      ale.getNumberOfExprs() > 1
    ) and
  prefix = TypePath::singleton(TArrayTypeParameter())
  or
  bodyReturns(parent, child) and
  strictcount(Expr e | bodyReturns(parent, e)) > 1 and
  prefix.isEmpty()
}

/**
 * Holds if the type tree of `n1` at `prefix1` should be equal to the type tree
 * of `n2` at `prefix2`, but type information should only propagate from `n1` to
 * `n2`.
 */
private predicate typeEqualityNonSymmetric(
  AstNode n1, TypePath prefix1, AstNode n2, TypePath prefix2
) {
  lubCoercion(n2, n1, prefix2) and
  prefix1.isEmpty()
  or
  exists(AstNode mid, TypePath prefixMid, TypePath suffix |
    typeEquality(n1, prefixMid, mid, prefix2) or
    typeEquality(mid, prefix2, n1, prefixMid)
  |
    lubCoercion(mid, n2, suffix) and
    not lubCoercion(mid, n1, _) and
    prefix1 = prefixMid.append(suffix)
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
    or
    typeEqualityNonSymmetric(n2, prefix2, n, prefix1)
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
private Path getCallExprPathQualifier(CallExpr ce) {
  result = CallExprImpl::getFunctionPath(ce).getQualifier()
}

/**
 * Gets the type qualifier of function call `ce`, if any.
 *
 * For example, the type qualifier of `Foo::<i32>::default()` is `Foo::<i32>`,
 * but only when `Foo` is not a trait.
 */
pragma[nomagic]
private Type getCallExprTypeQualifier(CallExpr ce, TypePath path) {
  exists(TypeMention tm |
    tm = getCallExprPathQualifier(ce) and
    result = tm.resolveTypeAt(path) and
    not resolvePath(tm) instanceof Trait
  )
}

/**
 * Holds if function `f` with the name `name` and the arity `arity` exists in
 * `i`, and the type at position `pos` is `t`.
 */
pragma[nomagic]
private predicate assocFunctionInfo(
  Function f, string name, int arity, ImplOrTraitItemNode i, FunctionPosition pos,
  AssocFunctionType t
) {
  f = i.getASuccessor(name) and
  arity = f.getParamList().getNumberOfParams() and
  t.appliesTo(f, i, pos)
}

/**
 * Holds if function `f` with the name `name` and the arity `arity` exists in
 * blanket (like) implementation `impl` of `trait`, and the type at position
 * `pos` is `t`.
 *
 * `blanketPath` points to the type `blanketTypeParam` inside `t`, which
 * is the type parameter used in the blanket implementation.
 */
pragma[nomagic]
private predicate functionInfoBlanketLike(
  Function f, string name, int arity, ImplItemNode impl, Trait trait, FunctionPosition pos,
  AssocFunctionType t, TypePath blanketPath, TypeParam blanketTypeParam
) {
  exists(TypePath blanketSelfPath |
    assocFunctionInfo(f, name, arity, impl, pos, t) and
    TTypeParamTypeParameter(blanketTypeParam) = t.getTypeAt(blanketPath) and
    blanketPath = any(string s) + blanketSelfPath and
    BlanketImplementation::isBlanketLike(impl, blanketSelfPath, blanketTypeParam) and
    trait = impl.resolveTraitTy()
  )
}

/**
 * Holds if the type path `path` pointing to `type` is stripped of any leading
 * complex root type allowed for `self` parameters, such as `&`, `Box`, `Rc`,
 * `Arc`, and `Pin`.
 *
 * We strip away the complex root type for performance reasons only, which will
 * allow us to construct a much smaller set of candidate call targets (otherwise,
 * for example _a lot_ of methods have a `self` parameter with a `&` root type).
 */
bindingset[path, type]
private predicate isComplexRootStripped(TypePath path, Type type) {
  (
    path.isEmpty() and
    not validSelfType(type)
    or
    exists(TypeParameter tp |
      complexSelfRoot(_, tp) and
      path = TypePath::singleton(tp) and
      exists(type)
    )
  ) and
  type != TNeverType()
}

/**
 * Provides logic for resolving calls to methods.
 *
 * When resolving a method call, a list of [candidate receiver types][1] is constructed
 *
 * > by repeatedly dereferencing the receiver expression's type, adding each type
 * > encountered to the list, then finally attempting an unsized coercion at the end,
 * > and adding the result type if that is successful.
 * >
 * > Then, for each candidate `T`, add `&T` and `&mut T` to the list immediately after `T`.
 *
 * We do not currently model unsized coercions, and we do not yet model the `Deref` trait,
 * instead we limit dereferencing to standard dereferencing and the fact that `String`
 * dereferences to `str`.
 *
 * Instead of constructing the full list of candidate receiver types
 *
 * ```
 * T1, &T1, &mut T1, ..., Tn, &Tn, &mut Tn
 * ```
 *
 * we recursively compute a set of candidates, only adding a new candidate receiver type
 * to the set when we can rule out that the method cannot be found for the current
 * candidate:
 *
 * ```text
 * forall method:
 *   not current_candidate matches method
 * ```
 *
 * Care must be taken to ensure that the `not current_candidate matches method` check is
 * monotonic, which we achieve using the monotonic `isNotInstantiationOf` predicate.
 *
 * [1]: https://doc.rust-lang.org/reference/expressions/method-call-expr.html#r-expr.method.candidate-receivers
 */
private module MethodResolution {
  /**
   * Holds if method `m` with the name `name` and the arity `arity` exists in
   * `i`, and the type of the `self` parameter is `selfType`.
   *
   * `strippedTypePath` points to the type `strippedType` inside `selfType`,
   * which is the (possibly complex-stripped) root type of `selfType`. For example,
   * if `m` has a `&self` parameter, then `strippedTypePath` is `TRefTypeParameter()`
   * and `strippedType` is the type inside the reference.
   */
  pragma[nomagic]
  private predicate methodInfo(
    Method m, string name, int arity, ImplOrTraitItemNode i, AssocFunctionType selfType,
    TypePath strippedTypePath, Type strippedType
  ) {
    exists(FunctionPosition pos |
      assocFunctionInfo(m, name, arity, i, pos, selfType) and
      strippedType = selfType.getTypeAt(strippedTypePath) and
      isComplexRootStripped(strippedTypePath, strippedType) and
      pos.isSelf()
    )
  }

  pragma[nomagic]
  private predicate methodInfoTypeParam(
    Method m, string name, int arity, ImplOrTraitItemNode i, AssocFunctionType selfType,
    TypePath strippedTypePath, TypeParam tp
  ) {
    methodInfo(m, name, arity, i, selfType, strippedTypePath, TTypeParamTypeParameter(tp))
  }

  /**
   * Same as `methodInfo`, but restricted to non-blanket implementations, and
   * allowing for any `strippedType` when the corresponding type inside `m` is
   * a type parameter.
   */
  pragma[inline]
  private predicate methodInfoNonBlanket(
    Method m, string name, int arity, ImplOrTraitItemNode i, AssocFunctionType selfType,
    TypePath strippedTypePath, Type strippedType
  ) {
    (
      methodInfo(m, name, arity, i, selfType, strippedTypePath, strippedType) or
      methodInfoTypeParam(m, name, arity, i, selfType, strippedTypePath, _)
    ) and
    not BlanketImplementation::isBlanketLike(i, _, _)
  }

  /**
   * Holds if method `m` with the name `name` and the arity `arity` exists in
   * blanket (like) implementation `impl` of `trait`, and the type of the `self`
   * parameter is `selfType`.
   *
   * `blanketPath` points to the type `blanketTypeParam` inside `selfType`, which
   * is the type parameter used in the blanket implementation.
   */
  pragma[nomagic]
  private predicate methodInfoBlanketLike(
    Method m, string name, int arity, ImplItemNode impl, Trait trait, AssocFunctionType selfType,
    TypePath blanketPath, TypeParam blanketTypeParam
  ) {
    exists(FunctionPosition pos |
      functionInfoBlanketLike(m, name, arity, impl, trait, pos, selfType, blanketPath,
        blanketTypeParam) and
      pos.isSelf()
    )
  }

  pragma[nomagic]
  private predicate methodTraitInfo(string name, int arity, Trait trait) {
    exists(ImplItemNode i |
      methodInfo(_, name, arity, i, _, _, _) and
      trait = i.resolveTraitTy()
    )
    or
    methodInfo(_, name, arity, trait, _, _, _)
  }

  pragma[nomagic]
  private predicate methodCallTraitCandidate(Element mc, Trait trait) {
    exists(string name, int arity |
      mc.(MethodCall).hasNameAndArity(name, arity) and
      methodTraitInfo(name, arity, trait)
    |
      not mc.(Call).hasTrait()
      or
      trait = mc.(Call).getTrait()
    )
  }

  private module MethodTraitIsVisible = TraitIsVisible<methodCallTraitCandidate/2>;

  private predicate methodCallVisibleTraitCandidate(MethodCall mc, Trait trait) {
    MethodTraitIsVisible::traitIsVisible(mc, trait)
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
   * `strippedTypePath` points to the type `strippedType` inside `selfType`,
   * which is the (possibly complex-stripped) root type of `selfType`.
   *
   * This predicate only checks for matching method names and arities, and whether
   * the trait being implemented by `i` (when `i` is not a trait itself) is visible
   * at `mc`.
   */
  bindingset[mc, strippedTypePath, strippedType]
  pragma[inline_late]
  private predicate methodCallNonBlanketCandidate(
    MethodCall mc, Method m, ImplOrTraitItemNode i, AssocFunctionType self,
    TypePath strippedTypePath, Type strippedType
  ) {
    exists(string name, int arity |
      mc.hasNameAndArity(name, arity) and
      methodInfoNonBlanket(m, name, arity, i, self, strippedTypePath, strippedType)
    |
      i =
        any(Impl impl |
          not impl.hasTrait()
          or
          methodCallVisibleImplTraitCandidate(mc, impl)
        )
      or
      methodCallVisibleTraitCandidate(mc, i)
      or
      i.(ImplItemNode).resolveTraitTy() = mc.(Call).getTrait()
    )
  }

  /**
   * Holds if method call `mc` may target a method in blanket (like) implementation
   * `impl` with `self` parameter having type `selfType`.
   *
   * `blanketPath` points to the type `blanketTypeParam` inside `selfType`, which
   * is the type parameter used in the blanket implementation.
   *
   * This predicate only checks for matching method names and arities, and whether
   * the trait being implemented by `i` (when `i` is not a trait itself) is visible
   * at `mc`.
   */
  bindingset[mc]
  pragma[inline_late]
  private predicate methodCallBlanketLikeCandidate(
    MethodCall mc, Method m, ImplItemNode impl, AssocFunctionType self, TypePath blanketPath,
    TypeParam blanketTypeParam
  ) {
    exists(string name, int arity |
      mc.hasNameAndArity(name, arity) and
      methodInfoBlanketLike(m, name, arity, impl, _, self, blanketPath, blanketTypeParam)
    |
      methodCallVisibleImplTraitCandidate(mc, impl)
      or
      impl.resolveTraitTy() = mc.(Call).getTrait()
    )
  }

  /**
   * A (potential) method call.
   *
   * This is either:
   *
   * 1. `MethodCallMethodCallExpr`: an actual method call, `x.m()`;
   * 2. `MethodCallIndexExpr`: an index expression, `x[i]`, which is [syntactic sugar][1]
   *    for `*x.index(i)`;
   * 3. `MethodCallCallExpr`: a qualified function call, `Q::m(x)`, where `m` is a method;
   *    or
   * 4. `MethodCallOperation`: an operation expression, `x + y`, which is syntactic sugar
   *    for `Add::add(x, y)`.
   *
   * Note that only in case 1 and 2 is auto-dereferencing and borrowing allowed.
   *
   * Note also that only case 4 is a _potential_ method call; in all other cases, we are
   * guaranteed that the target is a method.
   *
   * [1]: https://doc.rust-lang.org/std/ops/trait.Index.html
   */
  abstract class MethodCall extends Expr {
    abstract predicate hasNameAndArity(string name, int arity);

    abstract Expr getArgument(ArgumentPosition pos);

    abstract predicate supportsAutoDerefAndBorrow();

    AstNode getNodeAt(FunctionPosition apos) {
      result = this.getArgument(apos.asArgumentPosition())
      or
      result = this and apos.isReturn()
    }

    Type getArgumentTypeAt(ArgumentPosition pos, TypePath path) {
      result = inferType(this.getArgument(pos), path)
    }

    private Type getReceiverTypeAt(TypePath path) {
      result = this.getArgumentTypeAt(any(ArgumentPosition pos | pos.isSelf()), path)
    }

    /**
     * Same as `getACandidateReceiverTypeAt`, but without borrows.
     */
    pragma[nomagic]
    private Type getACandidateReceiverTypeAtNoBorrow(string derefChain, TypePath path) {
      result = this.getReceiverTypeAt(path) and
      derefChain = ""
      or
      this.supportsAutoDerefAndBorrow() and
      exists(TypePath path0, Type t0, string derefChain0 |
        this.hasNoCompatibleTargetBorrow(derefChain0) and
        t0 = this.getACandidateReceiverTypeAtNoBorrow(derefChain0, path0)
      |
        path0.isCons(TRefTypeParameter(), path) and
        result = t0 and
        derefChain = derefChain0 + ".ref"
        or
        path0.isEmpty() and
        path = path0 and
        t0 = getStringStruct() and
        result = getStrStruct() and
        derefChain = derefChain0 + ".str"
      )
    }

    /**
     * Holds if the method inside `i` with matching name and arity can be ruled
     * out as a target of this call, because the candidate receiver type represented
     * by `derefChain` and `borrow` is incompatible with the `self` parameter type.
     */
    pragma[nomagic]
    private predicate hasIncompatibleTarget(ImplOrTraitItemNode i, string derefChain, boolean borrow) {
      ReceiverIsInstantiationOfSelfParam::argIsNotInstantiationOf(MkMethodCallCand(this, derefChain,
          borrow), i, _)
    }

    /**
     * Holds if the method inside blanket-like implementation `impl` with matching name
     * and arity can be ruled out as a target of this call, either because the candidate
     * receiver type represented by `derefChain` and `borrow` is incompatible with the `self`
     * parameter type, or because the blanket constraint is not satisfied.
     */
    pragma[nomagic]
    private predicate hasIncompatibleBlanketLikeTarget(
      ImplItemNode impl, string derefChain, boolean borrow
    ) {
      ReceiverIsNotInstantiationOfBlanketLikeSelfParam::argIsNotInstantiationOf(MkMethodCallCand(this,
          derefChain, borrow), impl, _)
      or
      ReceiverSatisfiesBlanketLikeConstraint::dissatisfiesBlanketConstraint(MkMethodCallCand(this,
          derefChain, borrow), impl)
    }

    /**
     * Same as `getACandidateReceiverTypeAt`, but with traits substituted in for types
     * with trait bounds.
     */
    pragma[nomagic]
    Type getACandidateReceiverTypeAtSubstituteLookupTraits(
      string derefChain, boolean borrow, TypePath path
    ) {
      result = substituteLookupTraits(this.getACandidateReceiverTypeAt(derefChain, borrow, path))
    }

    pragma[nomagic]
    private Type getComplexStrippedType(string derefChain, boolean borrow, TypePath strippedTypePath) {
      result =
        this.getACandidateReceiverTypeAtSubstituteLookupTraits(derefChain, borrow, strippedTypePath) and
      isComplexRootStripped(strippedTypePath, result)
    }

    bindingset[derefChain, borrow, strippedTypePath, strippedType]
    private predicate hasNoCompatibleNonBlanketLikeTargetCheck(
      string derefChain, boolean borrow, TypePath strippedTypePath, Type strippedType
    ) {
      forall(ImplOrTraitItemNode i |
        methodCallNonBlanketCandidate(this, _, i, _, strippedTypePath, strippedType)
      |
        this.hasIncompatibleTarget(i, derefChain, borrow)
      )
    }

    bindingset[derefChain, borrow, strippedTypePath, strippedType]
    private predicate hasNoCompatibleTargetCheck(
      string derefChain, boolean borrow, TypePath strippedTypePath, Type strippedType
    ) {
      this.hasNoCompatibleNonBlanketLikeTargetCheck(derefChain, borrow, strippedTypePath,
        strippedType) and
      forall(ImplItemNode i | methodCallBlanketLikeCandidate(this, _, i, _, _, _) |
        this.hasIncompatibleBlanketLikeTarget(i, derefChain, borrow)
      )
    }

    bindingset[derefChain, borrow, strippedTypePath, strippedType]
    private predicate hasNoCompatibleNonBlanketTargetCheck(
      string derefChain, boolean borrow, TypePath strippedTypePath, Type strippedType
    ) {
      this.hasNoCompatibleNonBlanketLikeTargetCheck(derefChain, borrow, strippedTypePath,
        strippedType) and
      forall(ImplItemNode i |
        methodCallBlanketLikeCandidate(this, _, i, _, _, _) and not i.isBlanketImplementation()
      |
        this.hasIncompatibleBlanketLikeTarget(i, derefChain, borrow)
      )
    }

    /**
     * Holds if the candidate receiver type represented by `derefChain` does not
     * have a matching method target.
     */
    pragma[nomagic]
    predicate hasNoCompatibleTargetNoBorrow(string derefChain) {
      (
        this.supportsAutoDerefAndBorrow()
        or
        // needed for the `hasNoCompatibleTarget` check in
        // `ReceiverSatisfiesBlanketLikeConstraintInput::hasBlanketCandidate`
        derefChain = ""
      ) and
      exists(TypePath strippedTypePath, Type strippedType |
        not derefChain.matches("%.ref") and // no need to try a borrow if the last thing we did was a deref
        strippedType = this.getComplexStrippedType(derefChain, false, strippedTypePath) and
        this.hasNoCompatibleTargetCheck(derefChain, false, strippedTypePath, strippedType)
      )
    }

    /**
     * Holds if the candidate receiver type represented by `derefChain` does not have
     * a matching non-blanket method target.
     */
    pragma[nomagic]
    predicate hasNoCompatibleNonBlanketTargetNoBorrow(string derefChain) {
      (
        this.supportsAutoDerefAndBorrow()
        or
        // needed for the `hasNoCompatibleTarget` check in
        // `ReceiverSatisfiesBlanketLikeConstraintInput::hasBlanketCandidate`
        derefChain = ""
      ) and
      exists(TypePath strippedTypePath, Type strippedType |
        not derefChain.matches("%.ref") and // no need to try a borrow if the last thing we did was a deref
        strippedType = this.getComplexStrippedType(derefChain, false, strippedTypePath) and
        this.hasNoCompatibleNonBlanketTargetCheck(derefChain, false, strippedTypePath, strippedType)
      )
    }

    /**
     * Holds if the candidate receiver type represented by `derefChain`, followed
     * by a borrow, does not have a matching method target.
     */
    pragma[nomagic]
    predicate hasNoCompatibleTargetBorrow(string derefChain) {
      exists(TypePath strippedTypePath, Type strippedType |
        this.hasNoCompatibleTargetNoBorrow(derefChain) and
        strippedType = this.getComplexStrippedType(derefChain, true, strippedTypePath) and
        this.hasNoCompatibleNonBlanketLikeTargetCheck(derefChain, true, strippedTypePath,
          strippedType)
      )
    }

    /**
     * Holds if the candidate receiver type represented by `derefChain`, followed
     * by a borrow, does not have a matching non-blanket method target.
     */
    pragma[nomagic]
    predicate hasNoCompatibleNonBlanketTargetBorrow(string derefChain) {
      exists(TypePath strippedTypePath, Type strippedType |
        this.hasNoCompatibleTargetNoBorrow(derefChain) and
        strippedType = this.getComplexStrippedType(derefChain, true, strippedTypePath) and
        this.hasNoCompatibleNonBlanketTargetCheck(derefChain, true, strippedTypePath, strippedType)
      )
    }

    /**
     * Gets a [candidate receiver type][1] of this method call at `path`.
     *
     * The type is obtained by repeatedly dereferencing the receiver expression's type,
     * as long as the method cannot be resolved in an earlier candidate type, and possibly
     * applying a borrow at the end.
     *
     * The string `derefChain` encodes the sequence of dereferences, and `borrows` indicates
     * whether a borrow has been applied.
     *
     * [1]: https://doc.rust-lang.org/reference/expressions/method-call-expr.html#r-expr.method.candidate-receivers
     */
    pragma[nomagic]
    Type getACandidateReceiverTypeAt(string derefChain, boolean borrow, TypePath path) {
      result = this.getACandidateReceiverTypeAtNoBorrow(derefChain, path) and
      borrow = false
      or
      this.supportsAutoDerefAndBorrow() and
      this.hasNoCompatibleTargetNoBorrow(derefChain) and
      borrow = true and
      (
        path.isEmpty() and
        result = TRefType()
        or
        exists(TypePath suffix |
          result = this.getACandidateReceiverTypeAtNoBorrow(derefChain, suffix) and
          path = TypePath::cons(TRefTypeParameter(), suffix)
        )
      )
    }

    /**
     * Gets a method that this call resolves to after having applied a sequence of
     * dereferences and possibly a borrow on the receiver type, encoded in the string
     * `derefChain` and the Boolean `borrow`.
     */
    pragma[nomagic]
    Method resolveCallTarget(string derefChain, boolean borrow) {
      exists(MethodCallCand mcc |
        mcc = MkMethodCallCand(this, derefChain, borrow) and
        result = mcc.resolveCallTarget()
      )
    }

    predicate receiverHasImplicitDeref(AstNode receiver) {
      exists(this.resolveCallTarget(".ref", false)) and
      receiver = this.getArgument(CallImpl::TSelfArgumentPosition())
    }

    predicate receiverHasImplicitBorrow(AstNode receiver) {
      exists(this.resolveCallTarget("", true)) and
      receiver = this.getArgument(CallImpl::TSelfArgumentPosition())
    }
  }

  private class MethodCallMethodCallExpr extends MethodCall instanceof MethodCallExpr {
    pragma[nomagic]
    override predicate hasNameAndArity(string name, int arity) {
      name = super.getIdentifier().getText() and
      arity = super.getArgList().getNumberOfArgs()
    }

    override Expr getArgument(ArgumentPosition pos) {
      pos.isSelf() and
      result = MethodCallExpr.super.getReceiver()
      or
      result = super.getArgList().getArg(pos.asPosition())
    }

    override predicate supportsAutoDerefAndBorrow() { any() }
  }

  private class MethodCallIndexExpr extends MethodCall, IndexExpr {
    pragma[nomagic]
    override predicate hasNameAndArity(string name, int arity) {
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

    override predicate supportsAutoDerefAndBorrow() { any() }
  }

  private class MethodCallCallExpr extends MethodCall, CallExpr {
    MethodCallCallExpr() {
      exists(getCallExprPathQualifier(this)) and
      // even if a method cannot be resolved by path resolution, it may still
      // be possible to resolve a blanket implementation (so not `forex`)
      forall(ItemNode i | i = CallExprImpl::getResolvedFunction(this) | i instanceof Method)
    }

    /**
     * Holds if this call has a type qualifier, and we are able to resolve,
     * using path resolution, the method to a member of `impl`.
     *
     * When this is the case, we still want to check that the type qualifier
     * is an instance of the type being implemented, which is done in
     * `TypeQualifierIsInstantiationOfImplSelfInput`.
     */
    pragma[nomagic]
    predicate hasTypeQualifiedCandidate(ImplItemNode impl) {
      exists(getCallExprTypeQualifier(this, _)) and
      CallExprImpl::getResolvedFunction(this) = impl.getASuccessor(_)
    }

    pragma[nomagic]
    override predicate hasNameAndArity(string name, int arity) {
      name = CallExprImpl::getFunctionPath(this).getText() and
      arity = this.getArgList().getNumberOfArgs() - 1
    }

    override Expr getArgument(ArgumentPosition pos) {
      pos.isSelf() and
      result = this.getArg(0)
      or
      result = this.getArgList().getArg(pos.asPosition() + 1)
    }

    // needed for `TypeQualifierIsInstantiationOfImplSelfInput`
    Type getTypeAt(TypePath path) {
      result = substituteLookupTraits(getCallExprTypeQualifier(this, path))
    }

    override predicate supportsAutoDerefAndBorrow() { none() }
  }

  final class MethodCallOperation extends MethodCall, Operation {
    pragma[nomagic]
    override predicate hasNameAndArity(string name, int arity) {
      name = this.(Call).getMethodName() and
      arity = this.getNumberOfOperands() - 1
    }

    override Expr getArgument(ArgumentPosition pos) { result = this.(Call).getArgument(pos) }

    override Type getArgumentTypeAt(ArgumentPosition pos, TypePath path) {
      if this.(Call).implicitBorrowAt(pos, true)
      then
        result = TRefType() and
        path.isEmpty()
        or
        exists(TypePath path0 |
          result = inferType(this.getArgument(pos), path0) and
          path = TypePath::cons(TRefTypeParameter(), path0)
        )
      else result = inferType(this.getArgument(pos), path)
    }

    override predicate receiverHasImplicitBorrow(AstNode receiver) {
      exists(ArgumentPosition pos |
        this.(Call).implicitBorrowAt(pos, true) and
        receiver = this.getArgument(pos)
      )
    }

    override predicate supportsAutoDerefAndBorrow() { none() }
  }

  pragma[nomagic]
  private Method getMethodSuccessor(ImplOrTraitItemNode i, string name, int arity) {
    result = i.getASuccessor(name) and
    arity = result.getParamList().getNumberOfParams()
  }

  private newtype TMethodCallCand =
    MkMethodCallCand(MethodCall mc, string derefChain, boolean borrow) {
      exists(mc.getACandidateReceiverTypeAt(derefChain, borrow, _))
    }

  /** A method call with a dereference chain and a potential borrow. */
  private class MethodCallCand extends MkMethodCallCand {
    MethodCall mc_;
    string derefChain;
    boolean borrow;

    MethodCallCand() { this = MkMethodCallCand(mc_, derefChain, borrow) }

    MethodCall getMethodCall() { result = mc_ }

    Type getTypeAt(TypePath path) {
      result = mc_.getACandidateReceiverTypeAtSubstituteLookupTraits(derefChain, borrow, path) and
      not result = TNeverType()
    }

    pragma[nomagic]
    predicate hasNoCompatibleNonBlanketTarget() {
      mc_.hasNoCompatibleNonBlanketTargetBorrow(derefChain) and
      borrow = true
      or
      mc_.hasNoCompatibleNonBlanketTargetNoBorrow(derefChain) and
      borrow = false
    }

    pragma[nomagic]
    predicate hasSignature(
      MethodCall mc, TypePath strippedTypePath, Type strippedType, string name, int arity
    ) {
      strippedType = this.getTypeAt(strippedTypePath) and
      isComplexRootStripped(strippedTypePath, strippedType) and
      mc = mc_ and
      mc.hasNameAndArity(name, arity)
    }

    /**
     * Holds if the inherent method inside `impl` with matching name and arity can be
     * ruled out as a candidate for this call.
     */
    pragma[nomagic]
    private predicate hasIncompatibleInherentTarget(Impl impl) {
      ReceiverIsNotInstantiationOfInherentSelfParam::argIsNotInstantiationOf(this, impl, _)
    }

    /**
     * Holds if this method call has no inherent target, i.e., it does not
     * resolve to a method in an `impl` block for the type of the receiver.
     */
    pragma[nomagic]
    predicate hasNoInherentTarget() {
      exists(TypePath strippedTypePath, Type strippedType, string name, int arity |
        this.hasSignature(_, strippedTypePath, strippedType, name, arity) and
        forall(Impl i |
          methodInfoNonBlanket(_, name, arity, i, _, strippedTypePath, strippedType) and
          not i.hasTrait()
        |
          this.hasIncompatibleInherentTarget(i)
        )
      )
    }

    pragma[nomagic]
    private predicate typeQualifierIsInstantiationOf(ImplOrTraitItemNode i) {
      TypeQualifierIsInstantiationOfImplSelf::isInstantiationOf(mc_, i, _)
    }

    pragma[nomagic]
    private predicate argIsInstantiationOf(ImplOrTraitItemNode i, string name, int arity) {
      (
        ReceiverIsInstantiationOfSelfParam::argIsInstantiationOf(this, i, _)
        or
        this.typeQualifierIsInstantiationOf(i)
      ) and
      mc_.hasNameAndArity(name, arity)
    }

    pragma[nomagic]
    Method resolveCallTargetCand(ImplOrTraitItemNode i) {
      exists(string name, int arity |
        this.argIsInstantiationOf(i, name, arity) and
        result = getMethodSuccessor(i, name, arity)
      )
    }

    /** Gets a method that matches this method call. */
    pragma[nomagic]
    Method resolveCallTarget() {
      exists(ImplOrTraitItemNode i |
        result = this.resolveCallTargetCand(i) and
        not FunctionOverloading::functionResolutionDependsOnArgument(i, _, _, _, _)
      )
      or
      MethodArgsAreInstantiationsOf::argsAreInstantiationsOf(this, _, result)
    }

    predicate hasNoBorrow() { borrow = false }

    string toString() { result = mc_.toString() + " [" + derefChain + "; " + borrow + "]" }

    Location getLocation() { result = mc_.getLocation() }
  }

  private module ReceiverSatisfiesBlanketLikeConstraintInput implements
    BlanketImplementation::SatisfiesBlanketConstraintInputSig<MethodCallCand>
  {
    pragma[nomagic]
    predicate hasBlanketCandidate(
      MethodCallCand mcc, ImplItemNode impl, TypePath blanketPath, TypeParam blanketTypeParam
    ) {
      exists(MethodCall mc |
        mc = mcc.getMethodCall() and
        methodCallBlanketLikeCandidate(mc, _, impl, _, blanketPath, blanketTypeParam) and
        // Only apply blanket implementations when no other implementations are possible;
        // this is to account for codebases that use the (unstable) specialization feature
        // (https://rust-lang.github.io/rfcs/1210-impl-specialization.html)
        (mcc.hasNoCompatibleNonBlanketTarget() or not impl.isBlanketImplementation())
      |
        mcc.hasNoBorrow()
        or
        blanketPath.getHead() = TRefTypeParameter()
      )
    }
  }

  private module ReceiverSatisfiesBlanketLikeConstraint =
    BlanketImplementation::SatisfiesBlanketConstraint<MethodCallCand,
      ReceiverSatisfiesBlanketLikeConstraintInput>;

  /**
   * A configuration for matching the type of a receiver against the type of
   * a `self` parameter.
   */
  private module ReceiverIsInstantiationOfSelfParamInput implements
    IsInstantiationOfInputSig<MethodCallCand, AssocFunctionType>
  {
    pragma[nomagic]
    additional predicate potentialInstantiationOf0(
      MethodCallCand mcc, ImplOrTraitItemNode i, AssocFunctionType selfType
    ) {
      exists(
        MethodCall mc, Method m, string name, int arity, TypePath strippedTypePath,
        Type strippedType
      |
        mcc.hasSignature(mc, strippedTypePath, strippedType, name, arity)
      |
        methodCallNonBlanketCandidate(mc, m, i, selfType, strippedTypePath, strippedType)
        or
        methodCallBlanketLikeCandidate(mc, m, i, selfType, _, _) and
        ReceiverSatisfiesBlanketLikeConstraint::satisfiesBlanketConstraint(mcc, i)
      )
    }

    pragma[nomagic]
    predicate potentialInstantiationOf(
      MethodCallCand mcc, TypeAbstraction abs, AssocFunctionType constraint
    ) {
      potentialInstantiationOf0(mcc, abs, constraint) and
      if abs.(Impl).hasTrait()
      then
        // inherent methods take precedence over trait methods, so only allow
        // trait methods when there are no matching inherent methods
        mcc.hasNoInherentTarget()
      else any()
    }

    predicate relevantConstraint(AssocFunctionType constraint) {
      methodInfo(_, _, _, _, constraint, _, _)
    }
  }

  private module ReceiverIsInstantiationOfSelfParam =
    ArgIsInstantiationOf<MethodCallCand, ReceiverIsInstantiationOfSelfParamInput>;

  /**
   * A configuration for anti-matching the type of a receiver against the type of
   * a `self` parameter belonging to a blanket (like) implementation.
   */
  private module ReceiverIsNotInstantiationOfBlanketLikeSelfParamInput implements
    IsInstantiationOfInputSig<MethodCallCand, AssocFunctionType>
  {
    pragma[nomagic]
    predicate potentialInstantiationOf(
      MethodCallCand mcc, TypeAbstraction abs, AssocFunctionType constraint
    ) {
      methodCallBlanketLikeCandidate(mcc.getMethodCall(), _, abs, constraint, _, _) and
      if abs.(Impl).hasTrait()
      then
        // inherent methods take precedence over trait methods, so only allow
        // trait methods when there are no matching inherent methods
        mcc.hasNoInherentTarget()
      else any()
    }
  }

  private module ReceiverIsNotInstantiationOfBlanketLikeSelfParam =
    ArgIsInstantiationOf<MethodCallCand, ReceiverIsNotInstantiationOfBlanketLikeSelfParamInput>;

  /**
   * A configuration for matching the type qualifier of a method call
   * against the type being implemented in an `impl` block. For example,
   * in `Foo::<Bar>::m(x)`, we check that the type `Foo<Bar>` is an
   * instance of the type being implemented.
   */
  private module TypeQualifierIsInstantiationOfImplSelfInput implements
    IsInstantiationOfInputSig<MethodCallCallExpr, TypeMentionTypeTree>
  {
    pragma[nomagic]
    private predicate potentialInstantiationOf0(
      MethodCallCallExpr ce, ImplItemNode impl, TypeMentionTypeTree constraint
    ) {
      ce.hasTypeQualifiedCandidate(impl) and
      constraint = impl.getSelfPath()
    }

    pragma[nomagic]
    predicate potentialInstantiationOf(
      MethodCallCallExpr ce, TypeAbstraction abs, TypeMentionTypeTree constraint
    ) {
      potentialInstantiationOf0(ce, abs, constraint) and
      if abs.(Impl).hasTrait()
      then
        // inherent methods take precedence over trait methods, so only allow
        // trait methods when there are no matching inherent methods
        MkMethodCallCand(ce, _, _).(MethodCallCand).hasNoInherentTarget()
      else any()
    }

    predicate relevantConstraint(TypeMentionTypeTree constraint) {
      potentialInstantiationOf0(_, _, constraint)
    }
  }

  private module TypeQualifierIsInstantiationOfImplSelf =
    IsInstantiationOf<MethodCallCallExpr, TypeMentionTypeTree,
      TypeQualifierIsInstantiationOfImplSelfInput>;

  /**
   * A configuration for anti-matching the type of a receiver against the type of
   * a `self` parameter in an inherent method.
   */
  private module ReceiverIsNotInstantiationOfInherentSelfParamInput implements
    IsInstantiationOfInputSig<MethodCallCand, AssocFunctionType>
  {
    pragma[nomagic]
    predicate potentialInstantiationOf(
      MethodCallCand mcc, TypeAbstraction abs, AssocFunctionType constraint
    ) {
      ReceiverIsInstantiationOfSelfParamInput::potentialInstantiationOf0(mcc, abs, constraint) and
      abs = any(Impl i | not i.hasTrait())
    }
  }

  private module ReceiverIsNotInstantiationOfInherentSelfParam =
    ArgIsInstantiationOf<MethodCallCand, ReceiverIsNotInstantiationOfInherentSelfParamInput>;

  /**
   * A configuration for matching the types of positional arguments against the
   * types of parameters, when needed to disambiguate the call.
   */
  private module MethodArgsAreInstantiationsOfInput implements ArgsAreInstantiationsOfInputSig {
    predicate toCheck(ImplOrTraitItemNode i, Function f, FunctionPosition pos, AssocFunctionType t) {
      exists(TypePath path, Type t0 |
        FunctionOverloading::functionResolutionDependsOnArgument(i, f, pos, path, t0) and
        t.appliesTo(f, i, pos) and
        // for now, we do not handle ambiguous targets when one of the types it iself
        // a type parameter; we should be checking the constraints on that type parameter
        // in this case
        not t0 instanceof TypeParameter
      )
    }

    class Call extends MethodCallCand {
      Type getArgType(FunctionPosition pos, TypePath path) {
        result = inferType(mc_.getNodeAt(pos), path)
      }

      predicate hasTargetCand(ImplOrTraitItemNode i, Function f) {
        f = this.resolveCallTargetCand(i)
      }
    }
  }

  private module MethodArgsAreInstantiationsOf =
    ArgsAreInstantiationsOf<MethodArgsAreInstantiationsOfInput>;
}

/**
 * A matching configuration for resolving types of method call expressions
 * like `foo.bar(baz)`.
 */
private module MethodCallMatchingInput implements MatchingWithEnvironmentInputSig {
  import FunctionPositionMatchingInput

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
        i = dpos.asPosition() and
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
      result = getReturnTypeMention(this).resolveTypeAt(path)
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

  class AccessEnvironment = string;

  bindingset[derefChain, borrow]
  private AccessEnvironment encodeDerefChainBorrow(string derefChain, boolean borrow) {
    exists(string suffix | if borrow = true then suffix = "borrow" else suffix = "" |
      result = derefChain + ";" + suffix
    )
  }

  final private class MethodCallFinal = MethodResolution::MethodCall;

  class Access extends MethodCallFinal {
    Access() {
      // handled in the `OperationMatchingInput` module
      not this instanceof Operation
    }

    pragma[nomagic]
    Type getTypeArgument(TypeArgumentPosition apos, TypePath path) {
      exists(TypeMention arg | result = arg.resolveTypeAt(path) |
        arg =
          this.(MethodCallExpr).getGenericArgList().getTypeArg(apos.asMethodTypeArgumentPosition())
        or
        arg = getCallExprTypeArgument(this, apos)
      )
    }

    pragma[nomagic]
    private Type getInferredSelfType(AccessPosition apos, string derefChainBorrow, TypePath path) {
      exists(string derefChain, boolean borrow |
        result = this.getACandidateReceiverTypeAt(derefChain, borrow, path) and
        derefChainBorrow = encodeDerefChainBorrow(derefChain, borrow) and
        apos.isSelf()
      )
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
        not apos.isSelf() and
        result = inferType(this.getNodeAt(apos), path)
      )
    }

    bindingset[derefChainBorrow]
    Type getInferredType(string derefChainBorrow, AccessPosition apos, TypePath path) {
      result = this.getInferredSelfType(apos, derefChainBorrow, path)
      or
      result = this.getInferredNonSelfType(apos, path)
    }

    Declaration getTarget(string derefChainBorrow) {
      exists(string derefChain, boolean borrow |
        derefChainBorrow = encodeDerefChainBorrow(derefChain, borrow) and
        result = this.resolveCallTarget(derefChain, borrow) // mutual recursion; resolving method calls requires resolving types and vice versa
      )
    }
  }
}

private module MethodCallMatching = MatchingWithEnvironment<MethodCallMatchingInput>;

pragma[nomagic]
private Type inferMethodCallType0(
  MethodCallMatchingInput::Access a, MethodCallMatchingInput::AccessPosition apos, AstNode n,
  string derefChainBorrow, TypePath path
) {
  exists(TypePath path0 |
    n = a.getNodeAt(apos) and
    result = MethodCallMatching::inferAccessType(a, derefChainBorrow, apos, path0)
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
private Type inferMethodCallType(AstNode n, TypePath path) {
  exists(
    MethodCallMatchingInput::Access a, MethodCallMatchingInput::AccessPosition apos,
    string derefChainBorrow, TypePath path0
  |
    result = inferMethodCallType0(a, apos, n, derefChainBorrow, path0)
  |
    (
      not apos.isSelf()
      or
      derefChainBorrow = ";"
    ) and
    path = path0
    or
    // adjust for implicit deref
    apos.isSelf() and
    derefChainBorrow = ".ref;" and
    path = TypePath::cons(TRefTypeParameter(), path0)
    or
    // adjust for implicit borrow
    apos.isSelf() and
    derefChainBorrow = ";borrow" and
    path0.isCons(TRefTypeParameter(), path)
  )
}

/**
 * Provides logic for resolving calls to non-method items. This includes
 * "calls" to tuple variants and tuple structs.
 */
private module NonMethodResolution {
  /**
   * Holds if the associated function `implFunction` at `impl` implements
   * `traitFunction`, which belongs to `trait`, and resolving the function
   * `implFunction` requires inspecting the type at position `pos` in order
   * to determine whether it is the correct resolution.
   *
   * `type` is the type at `pos` of `implFunction` which mathces a type parameter of
   * `traitFunction` at `pos`.
   */
  pragma[nomagic]
  private predicate traitFunctionDependsOnPos(
    TraitItemNode trait, NonMethodFunction traitFunction, FunctionPosition pos, Type type,
    ImplItemNode impl, NonMethodFunction implFunction
  ) {
    exists(TypePath path |
      type = getAssocFunctionTypeAt(implFunction, impl, pos, path) and
      implFunction.implements(traitFunction) and
      FunctionOverloading::traitTypeParameterOccurrence(trait, traitFunction, _, pos, path, _)
    |
      if pos.isReturn()
      then
        // We only check that the context of the call provides relevant type information
        // when no argument can
        not exists(FunctionPosition pos0 |
          FunctionOverloading::traitTypeParameterOccurrence(trait, traitFunction, _, pos0, _, _) and
          not pos0.isReturn()
          or
          FunctionOverloading::functionResolutionDependsOnArgument(impl, implFunction, pos0, _, _)
        )
      else any()
    )
  }

  pragma[nomagic]
  private predicate functionInfoBlanketLikeRelevantPos(
    NonMethodFunction f, string name, int arity, ImplItemNode impl, Trait trait,
    FunctionPosition pos, AssocFunctionType t, TypePath blanketPath, TypeParam blanketTypeParam
  ) {
    functionInfoBlanketLike(f, name, arity, impl, trait, pos, t, blanketPath, blanketTypeParam) and
    (
      if pos.isReturn()
      then
        // We only check that the context of the call provides relevant type information
        // when no argument can
        not exists(FunctionPosition pos0 |
          functionInfoBlanketLike(f, name, arity, impl, trait, pos0, _, _, _) and
          not pos0.isReturn()
        )
      else any()
    )
  }

  pragma[nomagic]
  private predicate blanketLikeCallTraitCandidate(Element fc, Trait trait) {
    exists(string name, int arity |
      fc.(NonMethodCall).hasNameAndArity(name, arity) and
      functionInfoBlanketLikeRelevantPos(_, name, arity, _, trait, _, _, _, _)
    |
      not fc.(Call).hasTrait()
      or
      trait = fc.(Call).getTrait()
    )
  }

  private module BlanketTraitIsVisible = TraitIsVisible<blanketLikeCallTraitCandidate/2>;

  /** A (potential) non-method call, `f(x)`. */
  final class NonMethodCall extends CallExpr {
    NonMethodCall() {
      // even if a function cannot be resolved by path resolution, it may still
      // be possible to resolve a blanket implementation (so not `forex`)
      forall(Function f | f = CallExprImpl::getResolvedFunction(this) |
        f instanceof NonMethodFunction
      )
    }

    pragma[nomagic]
    predicate hasNameAndArity(string name, int arity) {
      name = CallExprImpl::getFunctionPath(this).getText() and
      arity = this.getArgList().getNumberOfArgs()
    }

    /**
     * Gets the item that this function call resolves to using path resolution,
     * if any.
     */
    private ItemNode getPathResolutionResolved() {
      result = CallExprImpl::getResolvedFunction(this) and
      not result.(Function).hasSelfParam()
    }

    /**
     * Gets the blanket function that this call may resolve to, if any.
     */
    pragma[nomagic]
    private NonMethodFunction resolveCallTargetBlanketCand(ImplItemNode impl) {
      exists(string name |
        this.hasNameAndArity(pragma[only_bind_into](name), _) and
        ArgIsInstantiationOfBlanketParam::argIsInstantiationOf(MkCallAndBlanketPos(this, _), impl, _) and
        result = impl.getASuccessor(pragma[only_bind_into](name))
      )
    }

    pragma[nomagic]
    NonMethodFunction resolveAssocCallTargetCand(ImplItemNode i) {
      not this.(Call).hasTrait() and
      result = this.getPathResolutionResolved() and
      result = i.getASuccessor(_)
      or
      result = this.resolveCallTargetBlanketCand(i)
    }

    AstNode getNodeAt(FunctionPosition pos) {
      result = this.getArg(pos.asPosition())
      or
      result = this and pos.isReturn()
    }

    Type getTypeAt(FunctionPosition pos, TypePath path) {
      result = inferType(this.getNodeAt(pos), path)
    }

    pragma[nomagic]
    predicate resolveCallTargetBlanketLikeCandidate(
      ImplItemNode impl, FunctionPosition pos, TypePath blanketPath, TypeParam blanketTypeParam
    ) {
      exists(string name, int arity, Trait trait, AssocFunctionType t |
        this.hasNameAndArity(name, arity) and
        exists(this.getTypeAt(pos, blanketPath)) and
        functionInfoBlanketLikeRelevantPos(_, name, arity, impl, trait, pos, t, blanketPath,
          blanketTypeParam) and
        BlanketTraitIsVisible::traitIsVisible(this, trait)
      )
    }

    pragma[nomagic]
    predicate hasTraitResolved(TraitItemNode trait, NonMethodFunction resolved) {
      resolved = this.getPathResolutionResolved() and
      trait = this.(Call).getTrait()
    }

    pragma[nomagic]
    private NonMethodFunction resolveCallTargetRec() {
      result = this.resolveCallTargetBlanketCand(_) and
      not FunctionOverloading::functionResolutionDependsOnArgument(_, result, _, _, _)
      or
      NonMethodArgsAreInstantiationsOf::argsAreInstantiationsOf(this, _, result)
    }

    pragma[nomagic]
    ItemNode resolveCallTargetNonRec() {
      not this.(Call).hasTrait() and
      result = this.getPathResolutionResolved() and
      not FunctionOverloading::functionResolutionDependsOnArgument(_, result, _, _, _)
    }

    pragma[inline]
    ItemNode resolveCallTarget() {
      result = this.resolveCallTargetNonRec()
      or
      result = this.resolveCallTargetRec()
    }
  }

  private newtype TCallAndBlanketPos =
    MkCallAndBlanketPos(NonMethodCall fc, FunctionPosition pos) {
      fc.resolveCallTargetBlanketLikeCandidate(_, pos, _, _)
    }

  /** A call tagged with a position. */
  private class CallAndBlanketPos extends MkCallAndBlanketPos {
    NonMethodCall fc;
    FunctionPosition pos;

    CallAndBlanketPos() { this = MkCallAndBlanketPos(fc, pos) }

    Location getLocation() { result = fc.getLocation() }

    Type getTypeAt(TypePath path) { result = fc.getTypeAt(pos, path) }

    string toString() { result = fc.toString() + " [arg " + pos + "]" }
  }

  private module ArgSatisfiesBlanketConstraintInput implements
    BlanketImplementation::SatisfiesBlanketConstraintInputSig<CallAndBlanketPos>
  {
    pragma[nomagic]
    predicate hasBlanketCandidate(
      CallAndBlanketPos fcp, ImplItemNode impl, TypePath blanketPath, TypeParam blanketTypeParam
    ) {
      exists(NonMethodCall fc, FunctionPosition pos |
        fcp = MkCallAndBlanketPos(fc, pos) and
        fc.resolveCallTargetBlanketLikeCandidate(impl, pos, blanketPath, blanketTypeParam)
      )
    }
  }

  private module ArgSatisfiesBlanketConstraint =
    BlanketImplementation::SatisfiesBlanketConstraint<CallAndBlanketPos,
      ArgSatisfiesBlanketConstraintInput>;

  /**
   * A configuration for matching the type of an argument against the type of
   * a parameter that mentions a satisfied blanket type parameter.
   */
  private module ArgIsInstantiationOfBlanketParamInput implements
    IsInstantiationOfInputSig<CallAndBlanketPos, AssocFunctionType>
  {
    pragma[nomagic]
    predicate potentialInstantiationOf(
      CallAndBlanketPos fcp, TypeAbstraction abs, AssocFunctionType constraint
    ) {
      exists(FunctionPosition pos |
        ArgSatisfiesBlanketConstraint::satisfiesBlanketConstraint(fcp, abs) and
        fcp = MkCallAndBlanketPos(_, pos) and
        functionInfoBlanketLikeRelevantPos(_, _, _, abs, _, pos, constraint, _, _)
      )
    }

    predicate relevantConstraint(AssocFunctionType constraint) {
      functionInfoBlanketLikeRelevantPos(_, _, _, _, _, _, constraint, _, _)
    }
  }

  private module ArgIsInstantiationOfBlanketParam =
    ArgIsInstantiationOf<CallAndBlanketPos, ArgIsInstantiationOfBlanketParamInput>;

  private module NonMethodArgsAreInstantiationsOfInput implements ArgsAreInstantiationsOfInputSig {
    predicate toCheck(ImplOrTraitItemNode i, Function f, FunctionPosition pos, AssocFunctionType t) {
      t.appliesTo(f, i, pos) and
      (
        exists(Type t0 |
          // for now, we do not handle ambiguous targets when one of the types it iself
          // a type parameter; we should be checking the constraints on that type parameter
          // in this case
          not t0 instanceof TypeParameter
        |
          FunctionOverloading::functionResolutionDependsOnArgument(i, f, pos, _, t0)
          or
          traitFunctionDependsOnPos(_, _, pos, t0, i, f)
        )
        or
        // match against the trait function itself
        exists(Trait trait |
          FunctionOverloading::traitTypeParameterOccurrence(trait, f, _, pos, _,
            TSelfTypeParameter(trait))
        )
      )
    }

    class Call extends NonMethodCall {
      Type getArgType(FunctionPosition pos, TypePath path) {
        result = inferType(this.getNodeAt(pos), path)
      }

      predicate hasTargetCand(ImplOrTraitItemNode i, Function f) {
        f = this.resolveAssocCallTargetCand(i)
        or
        exists(TraitItemNode trait, NonMethodFunction resolved, ImplItemNode i1, Function f1 |
          this.hasTraitResolved(trait, resolved) and
          traitFunctionDependsOnPos(trait, resolved, _, _, i1, f1)
        |
          f = f1 and
          i = i1
          or
          f = resolved and
          i = trait
        )
      }
    }
  }

  private module NonMethodArgsAreInstantiationsOf =
    ArgsAreInstantiationsOf<NonMethodArgsAreInstantiationsOfInput>;
}

/**
 * A matching configuration for resolving types of calls like
 * `foo::bar(baz)` where the target is not a method.
 */
private module NonMethodCallMatchingInput implements MatchingInputSig {
  import FunctionPositionMatchingInput

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

  private class NonMethodFunctionDecl extends Declaration, NonMethodFunction instanceof MethodCallMatchingInput::Declaration
  {
    override TypeParameter getTypeParameter(TypeParameterPosition ppos) {
      result = MethodCallMatchingInput::Declaration.super.getTypeParameter(ppos)
    }

    override Type getParameterType(DeclarationPosition dpos, TypePath path) {
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
      exists(FunctionPosition fpos |
        result = MethodCallMatchingInput::Declaration.super.getParameterType(fpos, path) and
        dpos = fpos.getFunctionCallAdjusted(this)
      )
    }

    override Type getReturnType(TypePath path) {
      result = MethodCallMatchingInput::Declaration.super.getReturnType(path)
    }
  }

  class Access extends NonMethodResolution::NonMethodCall {
    pragma[nomagic]
    Type getTypeArgument(TypeArgumentPosition apos, TypePath path) {
      result = getCallExprTypeArgument(this, apos).resolveTypeAt(path)
    }

    pragma[nomagic]
    Type getInferredType(AccessPosition apos, TypePath path) {
      apos.isSelf() and
      result = getCallExprTypeQualifier(this, path)
      or
      result = inferType(this.getNodeAt(apos), path)
    }

    Declaration getTarget() {
      result = this.resolveCallTarget() // potential mutual recursion; resolving some associated function calls requires resolving types
    }
  }
}

private module NonMethodCallMatching = Matching<NonMethodCallMatchingInput>;

pragma[nomagic]
private Type inferNonMethodCallType(AstNode n, TypePath path) {
  exists(NonMethodCallMatchingInput::Access a, NonMethodCallMatchingInput::AccessPosition apos |
    n = a.getNodeAt(apos) and
    result = NonMethodCallMatching::inferAccessType(a, apos, path)
  )
}

/**
 * A matching configuration for resolving types of operations like `a + b`.
 */
private module OperationMatchingInput implements MatchingInputSig {
  private import codeql.rust.elements.internal.OperationImpl as OperationImpl
  import FunctionPositionMatchingInput

  class Declaration extends MethodCallMatchingInput::Declaration {
    private Method getSelfOrImpl() {
      result = this
      or
      this.implements(result)
    }

    pragma[nomagic]
    private predicate borrowsAt(DeclarationPosition pos) {
      exists(TraitItemNode t, string path, string method |
        this.getSelfOrImpl() = t.getAssocItem(method) and
        path = t.getCanonicalPath(_) and
        exists(int borrows | OperationImpl::isOverloaded(_, _, path, method, borrows) |
          pos.isSelf() and borrows >= 1
          or
          pos.asPosition() = 0 and
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
    private predicate derefsReturn() { this.getSelfOrImpl() = any(DerefTrait t).getDerefFunction() }

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

  class Access extends MethodResolution::MethodCallOperation {
    Type getTypeArgument(TypeArgumentPosition apos, TypePath path) { none() }

    pragma[nomagic]
    Type getInferredType(AccessPosition apos, TypePath path) {
      result = inferType(this.getNodeAt(apos), path)
    }

    Declaration getTarget() {
      result = this.resolveCallTarget(_, _) // mutual recursion
    }
  }
}

private module OperationMatching = Matching<OperationMatchingInput>;

pragma[nomagic]
private Type inferOperationType(AstNode n, TypePath path) {
  exists(OperationMatchingInput::Access a, OperationMatchingInput::AccessPosition apos |
    n = a.getNodeAt(apos) and
    result = OperationMatching::inferAccessType(a, apos, path)
  )
}

pragma[nomagic]
private Type getFieldExprLookupType(FieldExpr fe, string name) {
  exists(TypePath path |
    result = inferType(fe.getContainer(), path) and
    name = fe.getIdentifier().getText() and
    isComplexRootStripped(path, result)
  )
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
 * A matching configuration for resolving types of field expressions like `x.field`.
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
private StructType getStringStruct() { result = TStruct(any(StringStruct s)) }

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
predicate isUnitBlockExpr(BlockExpr be) {
  not be.getStmtList().hasTailExpr() and
  not be = any(Callable c).getBody() and
  not be.hasLabel()
}

pragma[nomagic]
private Type inferBlockExprType(BlockExpr be, TypePath path) {
  // `typeEquality` handles the non-root case
  if be instanceof AsyncBlockExpr
  then (
    path.isEmpty() and
    result = getFutureTraitType()
    or
    isUnitBlockExpr(be) and
    path = TypePath::singleton(getFutureOutputTypeParameter()) and
    result instanceof UnitType
  ) else (
    isUnitBlockExpr(be) and
    path.isEmpty() and
    result instanceof UnitType
  )
}

pragma[nomagic]
private predicate exprHasUnitType(Expr e) {
  e = any(IfExpr ie | not ie.hasElse())
  or
  e instanceof WhileExpr
  or
  e instanceof ForExpr
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
    exprPath.isCons(TTypeParamTypeParameter(any(Vec v).getElementTypeParam()), path)
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
  import FunctionPositionMatchingInput

  class Declaration = NonMethodCallMatchingInput::TupleDeclaration;

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
    n = ce.getClosureBody() and
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
    any(MethodResolution::MethodCall mc).receiverHasImplicitDeref(receiver)
  }

  /** Holds if `receiver` is the receiver of a method call with an implicit borrow. */
  cached
  predicate receiverHasImplicitBorrow(AstNode receiver) {
    any(MethodResolution::MethodCall mc).receiverHasImplicitBorrow(receiver)
  }

  /** Gets an item (function or tuple struct/variant) that `call` resolves to, if any. */
  cached
  Addressable resolveCallTarget(Call call) {
    result = call.(MethodResolution::MethodCall).resolveCallTarget(_, _)
    or
    result = call.(NonMethodResolution::NonMethodCall).resolveCallTarget()
  }

  /**
   * Gets the struct field that the field expression `fe` resolves to, if any.
   */
  cached
  StructField resolveStructFieldExpr(FieldExpr fe) {
    exists(string name, Type ty | ty = getFieldExprLookupType(fe, pragma[only_bind_into](name)) |
      result = ty.(StructType).getStruct().getStructField(pragma[only_bind_into](name)) or
      result = ty.(UnionType).getUnion().getStructField(pragma[only_bind_into](name))
    )
  }

  /**
   * Gets the tuple field that the field expression `fe` resolves to, if any.
   */
  cached
  TupleField resolveTupleFieldExpr(FieldExpr fe) {
    exists(int i |
      result =
        getTupleFieldExprLookupType(fe, pragma[only_bind_into](i))
            .(StructType)
            .getStruct()
            .getTupleField(pragma[only_bind_into](i))
    )
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
      result = inferMethodCallType(n, path)
      or
      result = inferNonMethodCallType(n, path)
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
      filepath.matches("%/sqlx.rs") and
      startline = [56 .. 60]
    )
  }

  Type debugInferType(AstNode n, TypePath path) {
    n = getRelevantLocatable() and
    result = inferType(n, path)
  }

  Addressable debugResolveCallTarget(Call c) {
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

  predicate debugInferMethodCallType(AstNode n, TypePath path, Type t) {
    n = getRelevantLocatable() and
    t = inferMethodCallType(n, path)
  }

  predicate debugInferNonMethodCallType(AstNode n, TypePath path, Type t) {
    n = getRelevantLocatable() and
    t = inferNonMethodCallType(n, path)
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

  pragma[nomagic]
  private predicate atLimit(AstNode n) {
    exists(TypePath path0 | exists(inferType(n, path0)) and path0.length() >= getTypePathLimit())
  }

  Type debugInferTypeForNodeAtLimit(AstNode n, TypePath path) {
    result = inferType(n, path) and
    atLimit(n)
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
