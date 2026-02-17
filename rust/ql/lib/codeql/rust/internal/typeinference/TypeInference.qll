/** Provides functionality for inferring types. */

private import codeql.util.Boolean
private import codeql.util.Option
private import rust
private import codeql.rust.internal.PathResolution
private import Type
private import TypeAbstraction
private import TypeAbstraction as TA
private import Type as T
private import TypeMention
private import codeql.rust.internal.typeinference.DerefChain
private import FunctionType
private import FunctionOverloading as FunctionOverloading
private import BlanketImplementation as BlanketImplementation
private import codeql.rust.elements.internal.VariableImpl::Impl as VariableImpl
private import codeql.rust.internal.CachedStages
private import codeql.typeinference.internal.TypeInference
private import codeql.rust.frameworks.stdlib.Stdlib
private import codeql.rust.frameworks.stdlib.Builtins as Builtins
private import codeql.rust.elements.internal.CallExprImpl::Impl as CallExprImpl

class Type = T::Type;

private newtype TTypeArgumentPosition =
  // method type parameters are matched by position instead of by type
  // parameter entity, to avoid extra recursion through method call resolution
  TMethodTypeArgumentPosition(int pos) {
    exists(any(MethodCallExpr mce).getGenericArgList().getTypeArg(pos))
  } or
  TTypeParamTypeArgumentPosition(TypeParam tp)

private module Input implements InputSig1<Location>, InputSig2<PreTypeMention> {
  private import Type as T
  private import codeql.rust.elements.internal.generated.Raw
  private import codeql.rust.elements.internal.generated.Synth

  class Type = T::Type;

  class TypeParameter = T::TypeParameter;

  class TypeAbstraction = TA::TypeAbstraction;

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
        kind = 1 and
        id1 = idOfTypeParameterAstNode(tp0.(DynTraitTypeParameter).getTrait()) and
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
        id1 = idOfTypeParameterAstNode(tp0.(AssociatedTypeTypeParameter).getTrait()) and
        id2 = idOfTypeParameterAstNode(tp0.(AssociatedTypeTypeParameter).getTypeAlias())
        or
        kind = 4 and
        id1 = idOfTypeParameterAstNode(tp0.(TypeParamAssociatedTypeTypeParameter).getTypeParam()) and
        id2 = idOfTypeParameterAstNode(tp0.(TypeParamAssociatedTypeTypeParameter).getTypeAlias())
        or
        kind = 5 and
        id1 = 0 and
        exists(AstNode node | id2 = idOfTypeParameterAstNode(node) |
          node = tp0.(TypeParamTypeParameter).getTypeParam() or
          node = tp0.(SelfTypeParameter).getTrait() or
          node = tp0.(ImplTraitTypeTypeParameter).getImplTraitTypeRepr()
        )
      |
        tp0 order by kind, id1, id2
      )
  }

  int getTypePathLimit() { result = 10 }

  PreTypeMention getABaseTypeMention(Type t) { none() }

  Type getATypeParameterConstraint(TypeParameter tp, TypePath path) {
    exists(TypeMention tm | result = tm.getTypeAt(path) |
      tm = tp.(TypeParamTypeParameter).getTypeParam().getATypeBound().getTypeRepr() or
      tm = tp.(SelfTypeParameter).getTrait() or
      tm =
        tp.(ImplTraitTypeTypeParameter)
            .getImplTraitTypeRepr()
            .getTypeBoundList()
            .getABound()
            .getTypeRepr()
    )
  }

  /**
   * Use the constraint mechanism in the shared type inference library to
   * support traits. In Rust `constraint` is always a trait.
   *
   * See the documentation of `conditionSatisfiesConstraint` in the shared type
   * inference module for more information.
   */
  predicate conditionSatisfiesConstraint(
    TypeAbstraction abs, PreTypeMention condition, PreTypeMention constraint, boolean transitive
  ) {
    // `impl` blocks implementing traits
    transitive = false and
    exists(Impl impl |
      abs = impl and
      condition = impl.getSelfTy() and
      constraint = impl.getTrait()
    )
    or
    transitive = true and
    (
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
    )
  }
}

private import Input

private module M1 = Make1<Location, Input>;

import M1

predicate getTypePathLimit = Input::getTypePathLimit/0;

predicate getTypeParameterId = Input::getTypeParameterId/1;

class TypePath = M1::TypePath;

module TypePath = M1::TypePath;

private module M2 = Make2<PreTypeMention, Input>;

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
      strictcount(impl.(Impl).getSelfTy().(TypeMention).getTypeAt(selfTypePath)) > 1
    )
  }
}

/** A function without a `self` parameter. */
private class NonMethodFunction extends Function {
  NonMethodFunction() { not this.hasSelfParam() }
}

private module ImplOrTraitItemNodeOption = Option<ImplOrTraitItemNode>;

private class ImplOrTraitItemNodeOption = ImplOrTraitItemNodeOption::Option;

private class FunctionDeclaration extends Function {
  private ImplOrTraitItemNodeOption parent;

  FunctionDeclaration() {
    not this = any(ImplOrTraitItemNode i).getAnAssocItem() and parent.isNone()
    or
    this = parent.asSome().getASuccessor(_)
  }

  /** Holds if this function is associated with `i`. */
  predicate isAssoc(ImplOrTraitItemNode i) { i = parent.asSome() }

  /** Holds if this is a free function. */
  predicate isFree() { parent.isNone() }

  /** Holds if this function is valid for `i`. */
  predicate isFor(ImplOrTraitItemNodeOption i) { i = parent }

  /**
   * Holds if this function is valid for `i`. If `i` is a trait or `impl` block then
   * this function must be declared directly inside `i`.
   */
  predicate isDirectlyFor(ImplOrTraitItemNodeOption i) {
    i.isNone() and
    this.isFree()
    or
    this = i.asSome().getAnAssocItem()
  }

  TypeParam getTypeParam(ImplOrTraitItemNodeOption i) {
    i = parent and
    result = [this.getGenericParamList().getATypeParam(), i.asSome().getTypeParam(_)]
  }

  TypeParameter getTypeParameter(ImplOrTraitItemNodeOption i, TypeParameterPosition ppos) {
    typeParamMatchPosition(this.getTypeParam(i), result, ppos)
    or
    // For every `TypeParam` of this function, any associated types accessed on
    // the type parameter are also type parameters.
    ppos.isImplicit() and
    result.(TypeParamAssociatedTypeTypeParameter).getTypeParam() = this.getTypeParam(i)
    or
    i = parent and
    (
      ppos.isImplicit() and result = TSelfTypeParameter(i.asSome())
      or
      ppos.isImplicit() and result.(AssociatedTypeTypeParameter).getTrait() = i.asSome()
      or
      ppos.isImplicit() and this = result.(ImplTraitTypeTypeParameter).getFunction()
    )
  }

  pragma[nomagic]
  Type getParameterTypeInclNonMethodSelf(
    ImplOrTraitItemNodeOption i, FunctionPosition pos, TypePath path
  ) {
    i = parent and
    (
      not pos.isReturn() and
      result = getAssocFunctionTypeInclNonMethodSelfAt(this, i.asSome(), pos, path)
      or
      i.isNone() and
      result = this.getParam(pos.asPosition()).getTypeRepr().(TypeMention).getTypeAt(path)
    )
  }

  private Type resolveRetType(ImplOrTraitItemNodeOption i, TypePath path) {
    i = parent and
    (
      result =
        getAssocFunctionTypeAt(this, i.asSome(), any(FunctionPosition pos | pos.isReturn()), path)
      or
      i.isNone() and
      result = getReturnTypeMention(this).getTypeAt(path)
    )
  }

  Type getReturnType(ImplOrTraitItemNodeOption i, TypePath path) {
    if this.isAsync()
    then
      i = parent and
      path.isEmpty() and
      result = getFutureTraitType()
      or
      exists(TypePath suffix |
        result = this.resolveRetType(i, suffix) and
        path = TypePath::cons(getDynFutureOutputTypeParameter(), suffix)
      )
    else result = this.resolveRetType(i, path)
  }

  string toStringExt(ImplOrTraitItemNode i) {
    i = parent.asSome() and
    if this = i.getAnAssocItem()
    then result = this.toString()
    else
      result = this + " [" + [i.(Impl).getSelfTy().toString(), i.(Trait).getName().toString()] + "]"
  }
}

pragma[nomagic]
private TypeMention getCallExprTypeMentionArgument(CallExpr ce, TypeArgumentPosition apos) {
  exists(Path p, int i | p = CallExprImpl::getFunctionPath(ce) |
    apos.asTypeParam() = resolvePath(p).getTypeParam(pragma[only_bind_into](i)) and
    result = getPathTypeArgument(p, pragma[only_bind_into](i))
  )
}

pragma[nomagic]
private Type getCallExprTypeArgument(CallExpr ce, TypeArgumentPosition apos, TypePath path) {
  result = getCallExprTypeMentionArgument(ce, apos).getTypeAt(path)
  or
  // Handle constructions that use `Self(...)` syntax
  exists(Path p, TypePath path0 |
    p = CallExprImpl::getFunctionPath(ce) and
    result = p.(TypeMention).getTypeAt(path0) and
    path0.isCons(TTypeParamTypeParameter(apos.asTypeParam()), path)
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
}

/** Gets the type of `n`, which has an explicit type annotation. */
pragma[nomagic]
private Type inferAnnotatedType(AstNode n, TypePath path) {
  result = getTypeAnnotation(n).getTypeAt(path)
  or
  result = n.(ShorthandSelfParameterMention).getTypeAt(path)
}

pragma[nomagic]
private Type inferFunctionBodyType(AstNode n, TypePath path) {
  exists(Function f |
    n = f.getFunctionBody() and
    result = getReturnTypeMention(f).getTypeAt(path) and
    not exists(ImplTraitReturnType i | i.getFunction() = f |
      result = i or result = i.getATypeParameter()
    )
  )
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
  private Type getCallExprType(CallExpr ce, Path p, FunctionDeclaration f, TypePath path) {
    exists(ImplOrTraitItemNodeOption i |
      callResolvesTo(ce, p, f) and
      result = f.getReturnType(i, path) and
      f.isDirectlyFor(i)
    )
  }

  pragma[nomagic]
  private Type getCertainCallExprType(CallExpr ce, Path p, TypePath tp) {
    forex(Function f | callResolvesTo(ce, p, f) | result = getCallExprType(ce, p, f, tp))
  }

  pragma[nomagic]
  private TypePath getPathToImplSelfTypeParam(TypeParam tp) {
    exists(ImplItemNode impl |
      tp = impl.getTypeParam(_) and
      TTypeParamTypeParameter(tp) = impl.(Impl).getSelfTy().(TypeMention).getTypeAt(result)
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
          result = p.getQualifier().(TypeMention).getTypeAt(pathToTp.appendInverse(suffix))
        )
        or
        // For type parameters of the function we must resolve their
        // instantiation from the path. For instance, for `fn bar<A>(a: A) -> A`
        // and the path `bar<i64>`, we must resolve `A` to `i64`.
        result = getCallExprTypeArgument(ce, TTypeParamTypeArgumentPosition(tp), suffix)
      )
      or
      not ty instanceof TypeParameter and
      result = ty and
      path = prefix
    )
  }

  private Type inferCertainStructExprType(StructExpr se, TypePath path) {
    result = se.getPath().(TypeMention).getTypeAt(path)
  }

  private Type inferCertainStructPatType(StructPat sp, TypePath path) {
    result = sp.getPath().(TypeMention).getTypeAt(path)
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
        if ip.isRef()
        then
          exists(boolean isMutable | if ip.isMut() then isMutable = true else isMutable = false |
            prefix2 = TypePath::singleton(getRefTypeParameter(isMutable))
          )
        else prefix2.isEmpty()
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
  cached
  Type inferCertainType(AstNode n, TypePath path) {
    result = inferAnnotatedType(n, path) and
    Stages::TypeInferenceStage::ref()
    or
    result = inferFunctionBodyType(n, path)
    or
    result = inferCertainCallExprType(n, path)
    or
    result = inferCertainTypeEquality(n, path)
    or
    result = inferLiteralType(n, path, true)
    or
    result = inferRefPatType(n) and
    path.isEmpty()
    or
    result = inferRefExprType(n) and
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
    result = TDataType(t)
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
  n2 =
    any(RefExpr re |
      n1 = re.getExpr() and
      prefix1.isEmpty() and
      prefix2 = TypePath::singleton(inferRefExprType(re).getPositionalTypeParameter(0))
    )
  or
  n2 =
    any(RefPat rp |
      n1 = rp.getPat() and
      prefix1.isEmpty() and
      exists(boolean isMutable | if rp.isMut() then isMutable = true else isMutable = false |
        prefix2 = TypePath::singleton(getRefTypeParameter(isMutable))
      )
    )
  or
  exists(int i, int arity |
    prefix1.isEmpty() and
    prefix2 = TypePath::singleton(getTupleTypeParameter(arity, i))
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
      prefix1 = TypePath::singleton(getDynFutureOutputTypeParameter()) and
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
  prefix1 = TypePath::singleton(getArrayTypeParameter()) and
  prefix2.isEmpty()
  or
  // an array repeat expression (`[1; 3]`) has the type of the repeat operand
  n1.(ArrayRepeatExpr).getRepeatOperand() = n2 and
  prefix1 = TypePath::singleton(getArrayTypeParameter()) and
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
 * upper bound (LUB) coercion][1] to infer the type of `parent` from the type of
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
  prefix = TypePath::singleton(getArrayTypeParameter())
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
private predicate typeEqualityAsymmetric(AstNode n1, TypePath prefix1, AstNode n2, TypePath prefix2) {
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
  or
  // When `n2` is `*n1` propagate type information from a raw pointer type
  // parameter at `n1`. The other direction is handled in
  // `inferDereferencedExprPtrType`.
  n1 = n2.(DerefExpr).getExpr() and
  prefix1 = TypePath::singleton(getPtrTypeParameter()) and
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
    or
    typeEqualityAsymmetric(n2, prefix2, n, prefix1)
  )
}

/**
 * A matching configuration for resolving types of struct expressions
 * like `Foo { bar = baz }`.
 *
 * This also includes nullary struct expressions like `None`.
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
    final TypeParameter getTypeParameter(TypeParameterPosition ppos) {
      typeParamMatchPosition(this.getTypeItem().getGenericParamList().getATypeParam(), result, ppos)
    }

    abstract StructField getField(string name);

    abstract TypeItem getTypeItem();

    Type getDeclaredType(DeclarationPosition dpos, TypePath path) {
      // type of a field
      exists(TypeMention tp |
        tp = this.getField(dpos.asFieldPos()).getTypeRepr() and
        result = tp.getTypeAt(path)
      )
      or
      // type parameter of the struct itself
      dpos.isStructPos() and
      result = this.getTypeParameter(_) and
      path = TypePath::singleton(result)
      or
      // type of the struct or enum itself
      dpos.isStructPos() and
      path.isEmpty() and
      result = TDataType(this.getTypeItem())
    }
  }

  private class StructDecl extends Declaration, Struct {
    StructDecl() { this.isStruct() or this.isUnit() }

    override StructField getField(string name) { result = this.getStructField(name) }

    override TypeItem getTypeItem() { result = this }
  }

  private class StructVariantDecl extends Declaration, Variant {
    StructVariantDecl() { this.isStruct() or this.isUnit() }

    override StructField getField(string name) { result = this.getStructField(name) }

    override TypeItem getTypeItem() { result = this.getEnum() }
  }

  class AccessPosition = DeclarationPosition;

  abstract class Access extends AstNode {
    pragma[nomagic]
    abstract AstNode getNodeAt(AccessPosition apos);

    pragma[nomagic]
    Type getInferredType(AccessPosition apos, TypePath path) {
      result = inferType(this.getNodeAt(apos), path)
    }

    pragma[nomagic]
    abstract Path getStructPath();

    pragma[nomagic]
    Declaration getTarget() { result = resolvePath(this.getStructPath()) }

    pragma[nomagic]
    Type getTypeArgument(TypeArgumentPosition apos, TypePath path) {
      // Handle constructions that use `Self {...}` syntax
      exists(TypeMention tm, TypePath path0 |
        tm = this.getStructPath() and
        result = tm.getTypeAt(path0) and
        path0.isCons(TTypeParamTypeParameter(apos.asTypeParam()), path)
      )
    }

    /**
     * Holds if the return type of this struct expression at `path` may have to
     * be inferred from the context.
     */
    pragma[nomagic]
    predicate hasUnknownTypeAt(DeclarationPosition pos, TypePath path) {
      exists(Declaration d, TypeParameter tp |
        d = this.getTarget() and
        pos.isStructPos() and
        tp = d.getDeclaredType(pos, path) and
        not exists(DeclarationPosition fieldPos |
          not fieldPos.isStructPos() and
          tp = d.getDeclaredType(fieldPos, _)
        ) and
        // check that no explicit type arguments have been supplied for `tp`
        not exists(TypeArgumentPosition tapos |
          exists(this.getTypeArgument(tapos, _)) and
          TTypeParamTypeParameter(tapos.asTypeParam()) = tp
        )
      )
    }
  }

  private class StructExprAccess extends Access, StructExpr {
    override Type getTypeArgument(TypeArgumentPosition apos, TypePath path) {
      result = super.getTypeArgument(apos, path)
      or
      exists(TypePath suffix |
        suffix.isCons(TTypeParamTypeParameter(apos.asTypeParam()), path) and
        result = CertainTypeInference::inferCertainType(this, suffix)
      )
    }

    override AstNode getNodeAt(AccessPosition apos) {
      result = this.getFieldExpr(apos.asFieldPos()).getExpr()
      or
      result = this and
      apos.isStructPos()
    }

    override Path getStructPath() { result = this.getPath() }
  }

  /**
   * A potential nullary struct/variant construction such as `None`.
   */
  private class PathExprAccess extends Access, PathExpr {
    PathExprAccess() { not exists(CallExpr ce | this = ce.getFunction()) }

    override AstNode getNodeAt(AccessPosition apos) {
      result = this and
      apos.isStructPos()
    }

    override Path getStructPath() { result = this.getPath() }
  }

  predicate accessDeclarationPositionMatch(AccessPosition apos, DeclarationPosition dpos) {
    apos = dpos
  }
}

private module StructExprMatching = Matching<StructExprMatchingInput>;

pragma[nomagic]
private Type inferStructExprType0(AstNode n, boolean isReturn, TypePath path) {
  exists(StructExprMatchingInput::Access a, StructExprMatchingInput::AccessPosition apos |
    n = a.getNodeAt(apos) and
    if apos.isStructPos() then isReturn = true else isReturn = false
  |
    result = StructExprMatching::inferAccessType(a, apos, path)
    or
    a.hasUnknownTypeAt(apos, path) and
    result = TUnknownType()
  )
}

/**
 * Gets the type of `n` at `path`, where `n` is either a struct expression or
 * a field expression of a struct expression.
 */
private predicate inferStructExprType =
  ContextTyping::CheckContextTyping<inferStructExprType0/3>::check/2;

pragma[nomagic]
private TupleType inferTupleRootType(AstNode n) {
  // `typeEquality` handles the non-root cases
  result.getArity() = [n.(TupleExpr).getNumberOfFields(), n.(TuplePat).getTupleArity()]
}

pragma[nomagic]
private Path getCallExprPathQualifier(CallExpr ce) {
  result = CallExprImpl::getFunctionPath(ce).getQualifier()
}

/**
 * Gets the type qualifier of function call `ce`, if any.
 *
 * For example, the type qualifier of `Foo::<i32>::default()` is `Foo::<i32>`,
 * but only when `Foo` is not a trait. The type qualifier of `<Foo as Bar>::baz()`
 * is `Foo`.
 *
 * `isDefaultTypeArg` indicates whether the returned type is a default type
 * argument, for example in `Vec::new()` the default type for the type parameter
 * `A` of `Vec` is `Global`.
 */
pragma[nomagic]
private Type getCallExprTypeQualifier(CallExpr ce, TypePath path, boolean isDefaultTypeArg) {
  exists(Path p, TypeMention tm |
    p = getCallExprPathQualifier(ce) and
    tm = [p.(AstNode), p.getSegment().getTypeRepr()]
  |
    result = tm.getTypeAt(path) and
    not resolvePath(tm) instanceof Trait and
    isDefaultTypeArg = false
    or
    exists(TypeParameter tp, TypePath suffix |
      result =
        tm.(NonAliasPathTypeMention).getDefaultTypeForTypeParameterInNonAnnotationAt(tp, suffix) and
      path = TypePath::cons(tp, suffix) and
      isDefaultTypeArg = true
    )
  )
}

/**
 * Gets the trait qualifier of function call `ce`, if any.
 *
 * For example, the trait qualifier of `Default::<i32>::default()` is `Default`.
 */
pragma[nomagic]
private Trait getCallExprTraitQualifier(CallExpr ce) {
  exists(PathExt qualifierPath |
    qualifierPath = getCallExprPathQualifier(ce) and
    result = resolvePath(qualifierPath) and
    // When the qualifier is `Self` and resolves to a trait, it's inside a
    // trait method's default implementation. This is not a dispatch whose
    // target is inferred from the type of the receiver, but should always
    // resolve to the function in the trait block as path resolution does.
    not qualifierPath.isUnqualified("Self")
  )
}

/**
 * Provides functionality related to context-based typing of calls.
 */
private module ContextTyping {
  /**
   * Holds if the return type of the function `f` inside `i` at `path` is type
   * parameter `tp`, and `tp` does not appear in the type of any parameter of
   * `f`.
   *
   * In this case, the context in which `f` is called may be needed to infer
   * the instantiation of `tp`.
   *
   * This covers functions like `Default::default` and `Vec::new`.
   */
  pragma[nomagic]
  private predicate assocFunctionReturnContextTypedAt(
    ImplOrTraitItemNode i, Function f, FunctionPosition pos, TypePath path, TypeParameter tp
  ) {
    pos.isReturn() and
    tp = getAssocFunctionTypeAt(f, i, pos, path) and
    not exists(FunctionPosition nonResPos | not nonResPos.isReturn() |
      tp = getAssocFunctionTypeAt(f, i, nonResPos, _)
      or
      // `Self` types in traits implicitly mention all type parameters of the trait
      getAssocFunctionTypeAt(f, i, nonResPos, _) = TSelfTypeParameter(i)
    )
  }

  /**
   * A call where the type of the result may have to be inferred from the
   * context in which the call appears, for example a call like
   * `Default::default()`.
   */
  abstract class ContextTypedCallCand extends AstNode {
    abstract Type getTypeArgument(TypeArgumentPosition apos, TypePath path);

    private predicate hasTypeArgument(TypeArgumentPosition apos) {
      exists(this.getTypeArgument(apos, _))
    }

    /**
     * Holds if this call resolves to `target` inside `i`, and the return type
     * at `pos` and `path` may have to be inferred from the context.
     */
    bindingset[this, i, target]
    predicate hasUnknownTypeAt(
      ImplOrTraitItemNode i, Function target, FunctionPosition pos, TypePath path
    ) {
      exists(TypeParameter tp |
        assocFunctionReturnContextTypedAt(i, target, pos, path, tp) and
        // check that no explicit type arguments have been supplied for `tp`
        not exists(TypeArgumentPosition tapos | this.hasTypeArgument(tapos) |
          exists(int j |
            j = tapos.asMethodTypeArgumentPosition() and
            tp = TTypeParamTypeParameter(target.getGenericParamList().getTypeParam(j))
          )
          or
          TTypeParamTypeParameter(tapos.asTypeParam()) = tp
        ) and
        not (
          tp instanceof TSelfTypeParameter and
          exists(getCallExprTypeQualifier(this, _, _))
        )
      )
    }
  }

  pragma[nomagic]
  private predicate hasUnknownTypeAt(AstNode n, TypePath path) {
    inferType(n, path) = TUnknownType()
  }

  pragma[nomagic]
  private predicate hasUnknownType(AstNode n) { hasUnknownTypeAt(n, _) }

  signature Type inferCallTypeSig(AstNode n, boolean isReturn, TypePath path);

  /**
   * Given a predicate `inferCallType` for inferring the type of a call at a given
   * position, this module exposes the predicate `check`, which wraps the input
   * predicate and checks that types are only propagated into arguments when they
   * are context-typed.
   */
  module CheckContextTyping<inferCallTypeSig/3 inferCallType> {
    pragma[nomagic]
    private Type inferCallTypeFromContextCand(AstNode n, TypePath prefix, TypePath path) {
      result = inferCallType(n, false, path) and
      hasUnknownType(n) and
      prefix = path.getAPrefix()
    }

    pragma[nomagic]
    Type check(AstNode n, TypePath path) {
      result = inferCallType(n, true, path)
      or
      exists(TypePath prefix |
        result = inferCallTypeFromContextCand(n, prefix, path) and
        hasUnknownTypeAt(n, prefix)
      )
    }
  }
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

private newtype TBorrowKind =
  TNoBorrowKind() or
  TSomeBorrowKind(Boolean isMutable)

private class BorrowKind extends TBorrowKind {
  predicate isNoBorrow() { this = TNoBorrowKind() }

  predicate isSharedBorrow() { this = TSomeBorrowKind(false) }

  predicate isMutableBorrow() { this = TSomeBorrowKind(true) }

  RefType getRefType() {
    exists(boolean isMutable |
      this = TSomeBorrowKind(isMutable) and
      result = getRefType(isMutable)
    )
  }

  string toString() {
    this.isNoBorrow() and
    result = ""
    or
    this.isMutableBorrow() and
    result = "&mut"
    or
    this.isSharedBorrow() and
    result = "&"
  }
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
   * if `m` has a `&self` parameter, then `strippedTypePath` is `getRefSharedTypeParameter()`
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
    mc =
      any(MethodCall mc0 |
        exists(string name, int arity |
          mc0.hasNameAndArity(name, arity) and
          methodTraitInfo(name, arity, trait)
        |
          not mc0.hasTrait()
          or
          trait = mc0.getTrait()
        )
      )
  }

  private module MethodTraitIsVisible = TraitIsVisible<methodCallTraitCandidate/2>;

  private predicate methodCallVisibleTraitCandidate = MethodTraitIsVisible::traitIsVisible/2;

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
      i.(ImplItemNode).resolveTraitTy() = mc.getTrait()
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
      impl.resolveTraitTy() = mc.getTrait()
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

    abstract Expr getArg(ArgumentPosition pos);

    abstract predicate supportsAutoDerefAndBorrow();

    /** Gets the trait targeted by this call, if any. */
    abstract Trait getTrait();

    /** Holds if this call targets a trait. */
    predicate hasTrait() { exists(this.getTrait()) }

    AstNode getNodeAt(FunctionPosition apos) {
      result = this.getArg(apos.asArgumentPosition())
      or
      result = this and apos.isReturn()
    }

    Type getArgumentTypeAt(ArgumentPosition pos, TypePath path) {
      result = inferType(this.getArg(pos), path)
    }

    private Type getReceiverTypeAt(TypePath path) {
      result = this.getArgumentTypeAt(any(ArgumentPosition pos | pos.isSelf()), path)
    }

    /**
     * Same as `getACandidateReceiverTypeAt`, but without borrows.
     */
    pragma[nomagic]
    Type getACandidateReceiverTypeAtNoBorrow(DerefChain derefChain, TypePath path) {
      result = this.getReceiverTypeAt(path) and
      derefChain.isEmpty()
      or
      exists(DerefImplItemNode impl, DerefChain suffix |
        result = ImplicitDeref::getDereferencedCandidateReceiverType(this, impl, suffix, path) and
        derefChain = DerefChain::cons(impl, suffix)
      )
    }

    /**
     * Holds if the method inside `i` with matching name and arity can be ruled
     * out as a target of this call, because the candidate receiver type represented
     * by `derefChain` and `borrow` is incompatible with the `self` parameter type.
     *
     * The types are incompatible because they disagree on a concrete type somewhere
     * inside `root`.
     */
    pragma[nomagic]
    private predicate hasIncompatibleTarget(
      ImplOrTraitItemNode i, DerefChain derefChain, BorrowKind borrow, Type root
    ) {
      exists(TypePath path |
        ReceiverIsInstantiationOfSelfParam::argIsNotInstantiationOf(MkMethodCallCand(this,
            derefChain, borrow), i, _, path) and
        path.isCons(root.getATypeParameter(), _)
      )
    }

    /**
     * Holds if the method inside blanket-like implementation `impl` with matching name
     * and arity can be ruled out as a target of this call, either because the candidate
     * receiver type represented by `derefChain` and `borrow` is incompatible with the `self`
     * parameter type, or because the blanket constraint is not satisfied.
     */
    pragma[nomagic]
    private predicate hasIncompatibleBlanketLikeTarget(
      ImplItemNode impl, DerefChain derefChain, BorrowKind borrow
    ) {
      ReceiverIsNotInstantiationOfBlanketLikeSelfParam::argIsNotInstantiationOf(MkMethodCallCand(this,
          derefChain, borrow), impl, _, _)
      or
      ReceiverSatisfiesBlanketLikeConstraint::dissatisfiesBlanketConstraint(MkMethodCallCand(this,
          derefChain, borrow), impl)
    }

    /**
     * Same as `getACandidateReceiverTypeAt`, but excludes pseudo types `!` and `unknown`.
     */
    pragma[nomagic]
    Type getANonPseudoCandidateReceiverTypeAt(
      DerefChain derefChain, BorrowKind borrow, TypePath path
    ) {
      result = this.getACandidateReceiverTypeAt(derefChain, borrow, path) and
      result != TNeverType() and
      result != TUnknownType()
    }

    pragma[nomagic]
    private Type getComplexStrippedType(
      DerefChain derefChain, BorrowKind borrow, TypePath strippedTypePath
    ) {
      result = this.getANonPseudoCandidateReceiverTypeAt(derefChain, borrow, strippedTypePath) and
      isComplexRootStripped(strippedTypePath, result)
    }

    bindingset[derefChain, borrow, strippedTypePath, strippedType]
    private predicate hasNoCompatibleNonBlanketLikeTargetCheck(
      DerefChain derefChain, BorrowKind borrow, TypePath strippedTypePath, Type strippedType
    ) {
      forall(ImplOrTraitItemNode i |
        methodCallNonBlanketCandidate(this, _, i, _, strippedTypePath, strippedType)
      |
        this.hasIncompatibleTarget(i, derefChain, borrow, strippedType)
      )
    }

    bindingset[derefChain, borrow, strippedTypePath, strippedType]
    private predicate hasNoCompatibleTargetCheck(
      DerefChain derefChain, BorrowKind borrow, TypePath strippedTypePath, Type strippedType
    ) {
      this.hasNoCompatibleNonBlanketLikeTargetCheck(derefChain, borrow, strippedTypePath,
        strippedType) and
      forall(ImplItemNode i | methodCallBlanketLikeCandidate(this, _, i, _, _, _) |
        this.hasIncompatibleBlanketLikeTarget(i, derefChain, borrow)
      )
    }

    bindingset[derefChain, borrow, strippedTypePath, strippedType]
    private predicate hasNoCompatibleNonBlanketTargetCheck(
      DerefChain derefChain, BorrowKind borrow, TypePath strippedTypePath, Type strippedType
    ) {
      this.hasNoCompatibleNonBlanketLikeTargetCheck(derefChain, borrow, strippedTypePath,
        strippedType) and
      forall(ImplItemNode i |
        methodCallBlanketLikeCandidate(this, _, i, _, _, _) and not i.isBlanketImplementation()
      |
        this.hasIncompatibleBlanketLikeTarget(i, derefChain, borrow)
      )
    }

    // forex using recursion
    pragma[nomagic]
    private predicate hasNoCompatibleTargetNoBorrowToIndex(
      DerefChain derefChain, TypePath strippedTypePath, Type strippedType, int n
    ) {
      (
        this.supportsAutoDerefAndBorrow()
        or
        // needed for the `hasNoCompatibleTarget` check in
        // `ReceiverSatisfiesBlanketLikeConstraintInput::hasBlanketCandidate`
        derefChain.isEmpty()
      ) and
      strippedType = this.getComplexStrippedType(derefChain, TNoBorrowKind(), strippedTypePath) and
      n = -1
      or
      this.hasNoCompatibleTargetNoBorrowToIndex(derefChain, strippedTypePath, strippedType, n - 1) and
      exists(Type t | t = getNthLookupType(strippedType, n) |
        this.hasNoCompatibleTargetCheck(derefChain, TNoBorrowKind(), strippedTypePath, t)
      )
    }

    /**
     * Holds if the candidate receiver type represented by `derefChain` does not
     * have a matching method target.
     */
    pragma[nomagic]
    predicate hasNoCompatibleTargetNoBorrow(DerefChain derefChain) {
      exists(Type strippedType |
        this.hasNoCompatibleTargetNoBorrowToIndex(derefChain, _, strippedType,
          getLastLookupTypeIndex(strippedType))
      )
    }

    // forex using recursion
    pragma[nomagic]
    private predicate hasNoCompatibleNonBlanketTargetNoBorrowToIndex(
      DerefChain derefChain, TypePath strippedTypePath, Type strippedType, int n
    ) {
      (
        this.supportsAutoDerefAndBorrow()
        or
        // needed for the `hasNoCompatibleTarget` check in
        // `ReceiverSatisfiesBlanketLikeConstraintInput::hasBlanketCandidate`
        derefChain.isEmpty()
      ) and
      strippedType = this.getComplexStrippedType(derefChain, TNoBorrowKind(), strippedTypePath) and
      n = -1
      or
      this.hasNoCompatibleNonBlanketTargetNoBorrowToIndex(derefChain, strippedTypePath,
        strippedType, n - 1) and
      exists(Type t | t = getNthLookupType(strippedType, n) |
        this.hasNoCompatibleNonBlanketTargetCheck(derefChain, TNoBorrowKind(), strippedTypePath, t)
      )
    }

    /**
     * Holds if the candidate receiver type represented by `derefChain` does not have
     * a matching non-blanket method target.
     */
    pragma[nomagic]
    predicate hasNoCompatibleNonBlanketTargetNoBorrow(DerefChain derefChain) {
      exists(Type strippedType |
        this.hasNoCompatibleNonBlanketTargetNoBorrowToIndex(derefChain, _, strippedType,
          getLastLookupTypeIndex(strippedType))
      )
    }

    // forex using recursion
    pragma[nomagic]
    private predicate hasNoCompatibleTargetSharedBorrowToIndex(
      DerefChain derefChain, TypePath strippedTypePath, Type strippedType, int n
    ) {
      this.hasNoCompatibleTargetNoBorrow(derefChain) and
      strippedType =
        this.getComplexStrippedType(derefChain, TSomeBorrowKind(false), strippedTypePath) and
      n = -1
      or
      this.hasNoCompatibleTargetSharedBorrowToIndex(derefChain, strippedTypePath, strippedType,
        n - 1) and
      exists(Type t | t = getNthLookupType(strippedType, n) |
        this.hasNoCompatibleNonBlanketLikeTargetCheck(derefChain, TSomeBorrowKind(false),
          strippedTypePath, t)
      )
    }

    /**
     * Holds if the candidate receiver type represented by `derefChain`, followed
     * by a shared borrow, does not have a matching method target.
     */
    pragma[nomagic]
    predicate hasNoCompatibleTargetSharedBorrow(DerefChain derefChain) {
      exists(Type strippedType |
        this.hasNoCompatibleTargetSharedBorrowToIndex(derefChain, _, strippedType,
          getLastLookupTypeIndex(strippedType))
      )
    }

    // forex using recursion
    pragma[nomagic]
    private predicate hasNoCompatibleTargetMutBorrowToIndex(
      DerefChain derefChain, TypePath strippedTypePath, Type strippedType, int n
    ) {
      this.hasNoCompatibleTargetSharedBorrow(derefChain) and
      strippedType =
        this.getComplexStrippedType(derefChain, TSomeBorrowKind(true), strippedTypePath) and
      n = -1
      or
      this.hasNoCompatibleTargetMutBorrowToIndex(derefChain, strippedTypePath, strippedType, n - 1) and
      exists(Type t | t = getNthLookupType(strippedType, n) |
        this.hasNoCompatibleNonBlanketLikeTargetCheck(derefChain, TSomeBorrowKind(true),
          strippedTypePath, t)
      )
    }

    /**
     * Holds if the candidate receiver type represented by `derefChain`, followed
     * by a `mut` borrow, does not have a matching method target.
     */
    pragma[nomagic]
    predicate hasNoCompatibleTargetMutBorrow(DerefChain derefChain) {
      exists(Type strippedType |
        this.hasNoCompatibleTargetMutBorrowToIndex(derefChain, _, strippedType,
          getLastLookupTypeIndex(strippedType))
      )
    }

    // forex using recursion
    pragma[nomagic]
    private predicate hasNoCompatibleNonBlanketTargetSharedBorrowToIndex(
      DerefChain derefChain, TypePath strippedTypePath, Type strippedType, int n
    ) {
      this.hasNoCompatibleTargetNoBorrow(derefChain) and
      strippedType =
        this.getComplexStrippedType(derefChain, TSomeBorrowKind(false), strippedTypePath) and
      n = -1
      or
      this.hasNoCompatibleNonBlanketTargetSharedBorrowToIndex(derefChain, strippedTypePath,
        strippedType, n - 1) and
      exists(Type t | t = getNthLookupType(strippedType, n) |
        this.hasNoCompatibleNonBlanketTargetCheck(derefChain, TSomeBorrowKind(false),
          strippedTypePath, t)
      )
    }

    /**
     * Holds if the candidate receiver type represented by `derefChain`, followed
     * by a shared borrow, does not have a matching non-blanket method target.
     */
    pragma[nomagic]
    predicate hasNoCompatibleNonBlanketTargetSharedBorrow(DerefChain derefChain) {
      exists(Type strippedType |
        this.hasNoCompatibleNonBlanketTargetSharedBorrowToIndex(derefChain, _, strippedType,
          getLastLookupTypeIndex(strippedType))
      )
    }

    // forex using recursion
    pragma[nomagic]
    private predicate hasNoCompatibleNonBlanketTargetMutBorrowToIndex(
      DerefChain derefChain, TypePath strippedTypePath, Type strippedType, int n
    ) {
      this.hasNoCompatibleNonBlanketTargetSharedBorrow(derefChain) and
      strippedType =
        this.getComplexStrippedType(derefChain, TSomeBorrowKind(true), strippedTypePath) and
      n = -1
      or
      this.hasNoCompatibleNonBlanketTargetMutBorrowToIndex(derefChain, strippedTypePath,
        strippedType, n - 1) and
      exists(Type t | t = getNthLookupType(strippedType, n) |
        this.hasNoCompatibleNonBlanketTargetCheck(derefChain, TSomeBorrowKind(true),
          strippedTypePath, t)
      )
    }

    /**
     * Holds if the candidate receiver type represented by `derefChain`, followed
     * by a `mut` borrow, does not have a matching non-blanket method target.
     */
    pragma[nomagic]
    predicate hasNoCompatibleNonBlanketTargetMutBorrow(DerefChain derefChain) {
      exists(Type strippedType |
        this.hasNoCompatibleNonBlanketTargetMutBorrowToIndex(derefChain, _, strippedType,
          getLastLookupTypeIndex(strippedType))
      )
    }

    /**
     * Gets a [candidate receiver type][1] of this method call at `path`.
     *
     * The type is obtained by repeatedly dereferencing the receiver expression's type,
     * as long as the method cannot be resolved in an earlier candidate type, and possibly
     * applying a borrow at the end.
     *
     * The parameter `derefChain` encodes the sequence of dereferences, and `borrows` indicates
     * whether a borrow has been applied.
     *
     * [1]: https://doc.rust-lang.org/reference/expressions/method-call-expr.html#r-expr.method.candidate-receivers
     */
    pragma[nomagic]
    Type getACandidateReceiverTypeAt(DerefChain derefChain, BorrowKind borrow, TypePath path) {
      result = this.getACandidateReceiverTypeAtNoBorrow(derefChain, path) and
      borrow.isNoBorrow()
      or
      exists(RefType rt |
        // first try shared borrow
        this.supportsAutoDerefAndBorrow() and
        this.hasNoCompatibleTargetNoBorrow(derefChain) and
        borrow.isSharedBorrow()
        or
        // then try mutable borrow
        this.hasNoCompatibleTargetSharedBorrow(derefChain) and
        borrow.isMutableBorrow()
      |
        rt = borrow.getRefType() and
        (
          path.isEmpty() and
          result = rt
          or
          exists(TypePath suffix |
            result = this.getACandidateReceiverTypeAtNoBorrow(derefChain, suffix) and
            path = TypePath::cons(rt.getPositionalTypeParameter(0), suffix)
          )
        )
      )
    }

    /**
     * Gets a method that this call resolves to after having applied a sequence of
     * dereferences and possibly a borrow on the receiver type, encoded in `derefChain`
     * and `borrow`.
     */
    pragma[nomagic]
    Method resolveCallTarget(ImplOrTraitItemNode i, DerefChain derefChain, BorrowKind borrow) {
      exists(MethodCallCand mcc |
        mcc = MkMethodCallCand(this, derefChain, borrow) and
        result = mcc.resolveCallTarget(i)
      )
    }

    /**
     * Holds if the argument `arg` of this call has been implicitly dereferenced
     * and borrowed according to `derefChain` and `borrow`, in order to be able to
     * resolve the call target.
     */
    predicate argumentHasImplicitDerefChainBorrow(Expr arg, DerefChain derefChain, BorrowKind borrow) {
      exists(this.resolveCallTarget(_, derefChain, borrow)) and
      arg = this.getArg(any(ArgumentPosition pos | pos.isSelf())) and
      not (derefChain.isEmpty() and borrow.isNoBorrow())
    }
  }

  private class MethodCallMethodCallExpr extends MethodCall instanceof MethodCallExpr {
    pragma[nomagic]
    override predicate hasNameAndArity(string name, int arity) {
      name = super.getIdentifier().getText() and
      arity = super.getArgList().getNumberOfArgs()
    }

    override Expr getArg(ArgumentPosition pos) {
      result = MethodCallExpr.super.getSyntacticArgument(pos)
    }

    override predicate supportsAutoDerefAndBorrow() { any() }

    override Trait getTrait() { none() }
  }

  private class MethodCallIndexExpr extends MethodCall instanceof IndexExpr {
    private predicate isInMutableContext() {
      // todo: does not handle all cases yet
      VariableImpl::assignmentOperationDescendant(_, this)
    }

    pragma[nomagic]
    override predicate hasNameAndArity(string name, int arity) {
      (if this.isInMutableContext() then name = "index_mut" else name = "index") and
      arity = 1
    }

    override Expr getArg(ArgumentPosition pos) {
      pos.isSelf() and
      result = super.getBase()
      or
      pos.asPosition() = 0 and
      result = super.getIndex()
    }

    override predicate supportsAutoDerefAndBorrow() { any() }

    override Trait getTrait() {
      if this.isInMutableContext()
      then result instanceof IndexMutTrait
      else result instanceof IndexTrait
    }
  }

  private class MethodCallCallExpr extends MethodCall instanceof CallExpr {
    MethodCallCallExpr() {
      exists(getCallExprPathQualifier(this)) and
      // even if a method cannot be resolved by path resolution, it may still
      // be possible to resolve a blanket implementation (so not `forex`)
      forall(ItemNode i | i = CallExprImpl::getResolvedFunction(this) | i instanceof Method)
    }

    bindingset[this, f]
    pragma[inline_late]
    private predicate hasTypeQualifiedCandidateFilter(Function f, ImplItemNode impl) {
      f = impl.getAnAssocItem()
      or
      exists(TraitItemNode trait |
        f = trait.getAnAssocItem() and
        methodCallVisibleTraitCandidate(this, trait) and
        impl.resolveTraitTy() = trait
      )
    }

    /**
     * Holds if this call has a type qualifier, and we are able to resolve,
     * using path resolution, the method to a member of `impl` or the trait
     * being implemented by `impl` (when this call os of the kind
     * `<Foo as Bar>::f()`).
     *
     * When this is the case, we still want to check that the type qualifier
     * is an instance of the type being implemented, which is done in
     * `TypeQualifierIsInstantiationOfImplSelfInput`.
     */
    pragma[nomagic]
    predicate hasTypeQualifiedCandidate(ImplItemNode impl) {
      exists(Function f |
        exists(getCallExprTypeQualifier(this, _, _)) and
        f = CallExprImpl::getResolvedFunction(this) and
        this.hasTypeQualifiedCandidateFilter(f, impl)
      )
    }

    pragma[nomagic]
    override predicate hasNameAndArity(string name, int arity) {
      name = CallExprImpl::getFunctionPath(this).getText() and
      arity = super.getArgList().getNumberOfArgs() - 1
    }

    override Expr getArg(ArgumentPosition pos) {
      pos.isSelf() and
      result = super.getSyntacticPositionalArgument(0)
      or
      result = super.getSyntacticPositionalArgument(pos.asPosition() + 1)
    }

    // needed for `TypeQualifierIsInstantiationOfImplSelfInput`
    Type getTypeAt(TypePath path) {
      result = substituteLookupTraits(getCallExprTypeQualifier(this, path, _))
    }

    pragma[nomagic]
    predicate hasNoInherentTarget() {
      // `_` is fine below, because auto-deref/borrow is not supported
      MkMethodCallCand(this, _, _).(MethodCallCand).hasNoInherentTarget()
    }

    override predicate supportsAutoDerefAndBorrow() { none() }

    override Trait getTrait() { result = getCallExprTraitQualifier(this) }
  }

  final class MethodCallOperation extends MethodCall instanceof Operation {
    pragma[nomagic]
    override predicate hasNameAndArity(string name, int arity) {
      super.isOverloaded(_, name, _) and
      arity = super.getNumberOfOperands() - 1
    }

    override Expr getArg(ArgumentPosition pos) {
      pos.isSelf() and
      result = super.getOperand(0)
      or
      result = super.getOperand(pos.asPosition() + 1)
    }

    private predicate implicitBorrowAt(ArgumentPosition pos, boolean isMutable) {
      exists(int borrows | super.isOverloaded(_, _, borrows) |
        pos.isSelf() and
        borrows >= 1 and
        if this instanceof CompoundAssignmentExpr then isMutable = true else isMutable = false
        or
        pos.asPosition() = 0 and
        borrows = 2 and
        isMutable = false
      )
    }

    override Type getArgumentTypeAt(ArgumentPosition pos, TypePath path) {
      exists(boolean isMutable, RefType rt |
        this.implicitBorrowAt(pos, isMutable) and
        rt = getRefType(isMutable)
      |
        result = rt and
        path.isEmpty()
        or
        exists(TypePath path0 |
          result = inferType(this.getArg(pos), path0) and
          path = TypePath::cons(rt.getPositionalTypeParameter(0), path0)
        )
      )
      or
      not this.implicitBorrowAt(pos, _) and
      result = inferType(this.getArg(pos), path)
    }

    override predicate argumentHasImplicitDerefChainBorrow(
      Expr arg, DerefChain derefChain, BorrowKind borrow
    ) {
      exists(ArgumentPosition pos, boolean isMutable |
        this.implicitBorrowAt(pos, isMutable) and
        arg = this.getArg(pos) and
        derefChain = DerefChain::nil() and
        borrow = TSomeBorrowKind(isMutable)
      )
    }

    override predicate supportsAutoDerefAndBorrow() { none() }

    override Trait getTrait() { super.isOverloaded(result, _, _) }
  }

  pragma[nomagic]
  private Method getMethodSuccessor(ImplOrTraitItemNode i, string name, int arity) {
    result = i.getASuccessor(name) and
    arity = result.getParamList().getNumberOfParams()
  }

  private newtype TMethodCallCand =
    MkMethodCallCand(MethodCall mc, DerefChain derefChain, BorrowKind borrow) {
      exists(mc.getACandidateReceiverTypeAt(derefChain, borrow, _))
    }

  /** A method call with a dereference chain and a potential borrow. */
  private class MethodCallCand extends MkMethodCallCand {
    MethodCall mc_;
    DerefChain derefChain;
    BorrowKind borrow;

    MethodCallCand() { this = MkMethodCallCand(mc_, derefChain, borrow) }

    MethodCall getMethodCall() { result = mc_ }

    Type getTypeAt(TypePath path) {
      result =
        substituteLookupTraits(mc_.getANonPseudoCandidateReceiverTypeAt(derefChain, borrow, path))
    }

    pragma[nomagic]
    predicate hasNoCompatibleNonBlanketTarget() {
      mc_.hasNoCompatibleNonBlanketTargetSharedBorrow(derefChain) and
      borrow.isSharedBorrow()
      or
      mc_.hasNoCompatibleNonBlanketTargetMutBorrow(derefChain) and
      borrow.isMutableBorrow()
      or
      mc_.hasNoCompatibleNonBlanketTargetNoBorrow(derefChain) and
      borrow.isNoBorrow()
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
      ReceiverIsNotInstantiationOfInherentSelfParam::argIsNotInstantiationOf(this, impl, _, _)
    }

    /**
     * Holds if this method call has no inherent target, i.e., it does not
     * resolve to a method in an `impl` block for the type of the receiver.
     */
    pragma[nomagic]
    predicate hasNoInherentTarget() {
      mc_.hasTrait()
      or
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
    private predicate typeQualifierIsInstantiationOf(ImplItemNode i) {
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
    Method resolveCallTarget(ImplOrTraitItemNode i) {
      result = this.resolveCallTargetCand(i) and
      not FunctionOverloading::functionResolutionDependsOnArgument(i, result, _, _)
      or
      MethodArgsAreInstantiationsOf::argsAreInstantiationsOf(this, i, result)
    }

    string toString() {
      result = mc_.toString() + " [" + derefChain.toString() + "; " + borrow + "]"
    }

    Location getLocation() { result = mc_.getLocation() }
  }

  /**
   * Provides logic for resolving implicit `Deref::deref` calls.
   */
  private module ImplicitDeref {
    private newtype TMethodCallDerefCand =
      MkMethodCallDerefCand(MethodCall mc, DerefChain derefChain) {
        mc.supportsAutoDerefAndBorrow() and
        mc.hasNoCompatibleTargetMutBorrow(derefChain) and
        exists(mc.getACandidateReceiverTypeAtNoBorrow(derefChain, TypePath::nil()))
      }

    /** A method call with a dereference chain. */
    private class MethodCallDerefCand extends MkMethodCallDerefCand {
      MethodCall mc;
      DerefChain derefChain;

      MethodCallDerefCand() { this = MkMethodCallDerefCand(mc, derefChain) }

      Type getTypeAt(TypePath path) {
        result = substituteLookupTraits(mc.getACandidateReceiverTypeAtNoBorrow(derefChain, path)) and
        result != TNeverType() and
        result != TUnknownType()
      }

      string toString() { result = mc.toString() + " [" + derefChain.toString() + "]" }

      Location getLocation() { result = mc.getLocation() }
    }

    private module MethodCallSatisfiesDerefConstraintInput implements
      SatisfiesConstraintInputSig<MethodCallDerefCand>
    {
      pragma[nomagic]
      predicate relevantConstraint(MethodCallDerefCand mc, Type constraint) {
        exists(mc) and
        constraint.(TraitType).getTrait() instanceof DerefTrait
      }
    }

    private module MethodCallSatisfiesDerefConstraint =
      SatisfiesConstraint<MethodCallDerefCand, MethodCallSatisfiesDerefConstraintInput>;

    pragma[nomagic]
    private AssociatedTypeTypeParameter getDerefTargetTypeParameter() {
      result.getTypeAlias() = any(DerefTrait ft).getTargetType()
    }

    /**
     * Gets the type of the receiver of `mc` at `path` after applying the implicit
     * dereference inside `impl`, following the existing dereference chain `derefChain`.
     */
    pragma[nomagic]
    Type getDereferencedCandidateReceiverType(
      MethodCall mc, DerefImplItemNode impl, DerefChain derefChain, TypePath path
    ) {
      exists(MethodCallDerefCand mcc, TypePath exprPath |
        mcc = MkMethodCallDerefCand(mc, derefChain) and
        MethodCallSatisfiesDerefConstraint::satisfiesConstraintTypeThrough(mcc, impl, _, exprPath,
          result) and
        exprPath.isCons(getDerefTargetTypeParameter(), path)
      )
    }
  }

  private module ReceiverSatisfiesBlanketLikeConstraintInput implements
    BlanketImplementation::SatisfiesBlanketConstraintInputSig<MethodCallCand>
  {
    pragma[nomagic]
    predicate hasBlanketCandidate(
      MethodCallCand mcc, ImplItemNode impl, TypePath blanketPath, TypeParam blanketTypeParam
    ) {
      exists(MethodCall mc, BorrowKind borrow |
        mcc = MkMethodCallCand(mc, _, borrow) and
        methodCallBlanketLikeCandidate(mc, _, impl, _, blanketPath, blanketTypeParam) and
        // Only apply blanket implementations when no other implementations are possible;
        // this is to account for codebases that use the (unstable) specialization feature
        // (https://rust-lang.github.io/rfcs/1210-impl-specialization.html), as well as
        // cases where our blanket implementation filtering is not precise enough.
        (mcc.hasNoCompatibleNonBlanketTarget() or not impl.isBlanketImplementation())
      |
        borrow.isNoBorrow()
        or
        blanketPath.getHead() = borrow.getRefType().getPositionalTypeParameter(0)
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
    IsInstantiationOfInputSig<MethodCallCallExpr, TypeMention>
  {
    pragma[nomagic]
    private predicate potentialInstantiationOf0(
      MethodCallCallExpr ce, ImplItemNode impl, TypeMention constraint
    ) {
      ce.hasTypeQualifiedCandidate(impl) and
      constraint = impl.getSelfPath()
    }

    pragma[nomagic]
    predicate potentialInstantiationOf(
      MethodCallCallExpr ce, TypeAbstraction abs, TypeMention constraint
    ) {
      potentialInstantiationOf0(ce, abs, constraint) and
      if abs.(Impl).hasTrait()
      then
        // inherent methods take precedence over trait methods, so only allow
        // trait methods when there are no matching inherent methods
        ce.hasNoInherentTarget()
      else any()
    }

    predicate relevantConstraint(TypeMention constraint) {
      potentialInstantiationOf0(_, _, constraint)
    }
  }

  private module TypeQualifierIsInstantiationOfImplSelf =
    IsInstantiationOf<MethodCallCallExpr, TypeMention, TypeQualifierIsInstantiationOfImplSelfInput>;

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
    predicate toCheck(ImplOrTraitItemNode i, Function f, TypeParameter traitTp, FunctionPosition pos) {
      FunctionOverloading::functionResolutionDependsOnArgument(i, f, traitTp, pos)
    }

    class Call extends MethodCallCand {
      Type getArgType(FunctionPosition pos, TypePath path) {
        result = mc_.getArgumentTypeAt(pos.asArgumentPosition(), path)
        or
        pos.isReturn() and
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

  private class MethodDeclaration extends Method, FunctionDeclaration { }

  private newtype TDeclaration =
    TMethodFunctionDeclaration(ImplOrTraitItemNode i, MethodDeclaration m) { m.isAssoc(i) }

  final class Declaration extends TMethodFunctionDeclaration {
    ImplOrTraitItemNode parent;
    ImplOrTraitItemNodeOption someParent;
    MethodDeclaration m;

    Declaration() {
      this = TMethodFunctionDeclaration(parent, m) and
      someParent.asSome() = parent
    }

    predicate isMethod(ImplOrTraitItemNode i, Method method) {
      this = TMethodFunctionDeclaration(i, method)
    }

    TypeParameter getTypeParameter(TypeParameterPosition ppos) {
      result = m.getTypeParameter(someParent, ppos)
    }

    Type getDeclaredType(DeclarationPosition dpos, TypePath path) {
      result = m.getParameterTypeInclNonMethodSelf(someParent, dpos, path)
      or
      dpos.isReturn() and
      result = m.getReturnType(someParent, path)
    }

    string toString() { result = m.toStringExt(parent) }

    Location getLocation() { result = m.getLocation() }
  }

  class AccessEnvironment = string;

  bindingset[derefChain, borrow]
  private AccessEnvironment encodeDerefChainBorrow(DerefChain derefChain, BorrowKind borrow) {
    result = derefChain + ";" + borrow
  }

  bindingset[derefChainBorrow]
  additional predicate decodeDerefChainBorrow(
    string derefChainBorrow, DerefChain derefChain, BorrowKind borrow
  ) {
    exists(int i |
      i = derefChainBorrow.indexOf(";") and
      derefChain = derefChainBorrow.prefix(i) and
      borrow.toString() = derefChainBorrow.suffix(i + 1)
    )
  }

  final private class MethodCallFinal = MethodResolution::MethodCall;

  class Access extends MethodCallFinal, ContextTyping::ContextTypedCallCand {
    Access() {
      // handled in the `OperationMatchingInput` module
      not this instanceof Operation
    }

    pragma[nomagic]
    override Type getTypeArgument(TypeArgumentPosition apos, TypePath path) {
      result =
        this.(MethodCallExpr)
            .getGenericArgList()
            .getTypeArg(apos.asMethodTypeArgumentPosition())
            .(TypeMention)
            .getTypeAt(path)
      or
      result = getCallExprTypeArgument(this, apos, path)
    }

    pragma[nomagic]
    private Type getInferredSelfType(AccessPosition apos, string derefChainBorrow, TypePath path) {
      exists(DerefChain derefChain, BorrowKind borrow |
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
        result instanceof RefType
        or
        exists(TypePath suffix |
          result = inferType(this.getNodeAt(apos), suffix) and
          path = TypePath::cons(getRefTypeParameter(_), suffix)
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

    Method getTarget(ImplOrTraitItemNode i, string derefChainBorrow) {
      exists(DerefChain derefChain, BorrowKind borrow |
        derefChainBorrow = encodeDerefChainBorrow(derefChain, borrow) and
        result = this.resolveCallTarget(i, derefChain, borrow) // mutual recursion; resolving method calls requires resolving types and vice versa
      )
    }

    Declaration getTarget(string derefChainBorrow) {
      exists(ImplOrTraitItemNode i, Method m |
        m = this.getTarget(i, derefChainBorrow) and
        result = TMethodFunctionDeclaration(i, m)
      )
    }

    /**
     * Holds if the return type of this call at `path` may have to be inferred
     * from the context.
     */
    pragma[nomagic]
    predicate hasUnknownTypeAt(string derefChainBorrow, FunctionPosition pos, TypePath path) {
      exists(ImplOrTraitItemNode i |
        this.hasUnknownTypeAt(i, this.getTarget(i, derefChainBorrow), pos, path)
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
    (
      result = MethodCallMatching::inferAccessType(a, derefChainBorrow, apos, path0)
      or
      a.hasUnknownTypeAt(derefChainBorrow, apos, path0) and
      result = TUnknownType()
    )
  |
    if
      // index expression `x[i]` desugars to `*x.index(i)`, so we must account for
      // the implicit deref
      apos.isReturn() and
      a instanceof IndexExpr
    then path0.isCons(getRefTypeParameter(_), path)
    else path = path0
  )
}

pragma[nomagic]
private Type inferMethodCallTypeNonSelf(AstNode n, boolean isReturn, TypePath path) {
  exists(MethodCallMatchingInput::AccessPosition apos |
    result = inferMethodCallType0(_, apos, n, _, path) and
    not apos.isSelf() and
    if apos.isReturn() then isReturn = true else isReturn = false
  )
}

/**
 * Gets the type of `n` at `path` after applying `derefChain`, where `n` is the
 * `self` argument of a method call.
 *
 * The predicate recursively pops the head of `derefChain` until it becomes
 * empty, at which point the inferred type can be applied back to `n`.
 */
pragma[nomagic]
private Type inferMethodCallTypeSelf(AstNode n, DerefChain derefChain, TypePath path) {
  exists(
    MethodCallMatchingInput::AccessPosition apos, string derefChainBorrow, BorrowKind borrow,
    TypePath path0
  |
    result = inferMethodCallType0(_, apos, n, derefChainBorrow, path0) and
    apos.isSelf() and
    MethodCallMatchingInput::decodeDerefChainBorrow(derefChainBorrow, derefChain, borrow)
  |
    borrow.isNoBorrow() and
    path = path0
    or
    // adjust for implicit borrow
    exists(TypePath prefix |
      prefix = TypePath::singleton(borrow.getRefType().getPositionalTypeParameter(0)) and
      path0 = prefix.appendInverse(path)
    )
  )
  or
  // adjust for implicit deref
  exists(
    DerefChain derefChain0, Type t0, TypePath path0, DerefImplItemNode impl, Type selfParamType,
    TypePath selfPath
  |
    t0 = inferMethodCallTypeSelf(n, derefChain0, path0) and
    derefChain0.isCons(impl, derefChain) and
    selfParamType = impl.resolveSelfTypeAt(selfPath)
  |
    result = selfParamType and
    path = selfPath and
    not result instanceof TypeParameter
    or
    exists(TypePath pathToTypeParam, TypePath suffix |
      impl.targetHasTypeParameterAt(pathToTypeParam, selfParamType) and
      path0 = pathToTypeParam.appendInverse(suffix) and
      result = t0 and
      path = selfPath.append(suffix)
    )
  )
}

private Type inferMethodCallTypePreCheck(AstNode n, boolean isReturn, TypePath path) {
  result = inferMethodCallTypeNonSelf(n, isReturn, path)
  or
  result = inferMethodCallTypeSelf(n, DerefChain::nil(), path) and
  isReturn = false
}

/**
 * Gets the type of `n` at `path`, where `n` is either a method call or an
 * argument/receiver of a method call.
 */
private predicate inferMethodCallType =
  ContextTyping::CheckContextTyping<inferMethodCallTypePreCheck/3>::check/2;

/**
 * Provides logic for resolving calls to non-method items. This includes
 * "calls" to tuple variants and tuple structs.
 */
private module NonMethodResolution {
  pragma[nomagic]
  private predicate traitFunctionResolutionDependsOnArgument0(
    TraitItemNode trait, NonMethodFunction traitFunction, FunctionPosition pos, ImplItemNode impl,
    NonMethodFunction implFunction, TypePath path, TypeParameter traitTp
  ) {
    implFunction = impl.getAnAssocItem() and
    implFunction.implements(traitFunction) and
    FunctionOverloading::traitTypeParameterOccurrence(trait, traitFunction, _, pos, path, traitTp) and
    (
      traitTp = TSelfTypeParameter(trait)
      or
      FunctionOverloading::functionResolutionDependsOnArgument(impl, implFunction, traitTp, pos)
    )
  }

  /**
   * Holds if resolving the function `implFunction` in `impl` requires inspecting
   * the type of applied _arguments_ or possibly knowing the return type.
   *
   * `traitTp` is a type parameter of the trait being implemented by `impl`, and
   * we need to check that the type of `f` corresponding to `traitTp` is satisfied
   * at any one of the positions `pos` in which that type occurs in `f` (at `path`).
   *
   * As for method resolution, we always check the type being implemented (corresponding
   * to `traitTp` being the special `Self` type parameter).
   */
  pragma[nomagic]
  private predicate traitFunctionResolutionDependsOnArgument(
    TraitItemNode trait, NonMethodFunction traitFunction, FunctionPosition pos, ImplItemNode impl,
    NonMethodFunction implFunction, TypePath path, TypeParameter traitTp
  ) {
    traitFunctionResolutionDependsOnArgument0(trait, traitFunction, pos, impl, implFunction, path,
      traitTp) and
    // Exclude functions where we cannot resolve all relevant type mentions; this allows
    // for blanket implementations to be applied in those cases
    forall(TypeParameter traitTp0 |
      traitFunctionResolutionDependsOnArgument0(trait, traitFunction, _, impl, implFunction, _,
        traitTp0)
    |
      exists(FunctionPosition pos0, TypePath path0 |
        traitFunctionResolutionDependsOnArgument0(trait, traitFunction, pos0, impl, implFunction,
          path0, traitTp0) and
        exists(getAssocFunctionTypeInclNonMethodSelfAt(implFunction, impl, pos0, path0))
      )
    )
  }

  /**
   * Holds if `f` inside `i` either implements trait function `traitFunction` inside `trait`
   * or is equal to `traitFunction`, and the type of `f` at `pos` and `path` is `t`, which
   * corresponds to the `Self` type parameter of `trait`.
   */
  pragma[nomagic]
  private predicate traitFunctionHasSelfType(
    TraitItemNode trait, NonMethodFunction traitFunction, FunctionPosition pos, TypePath path,
    Type t, ImplOrTraitItemNode i, NonMethodFunction f
  ) {
    exists(ImplItemNode impl, NonMethodFunction implFunction, AssocFunctionType aft |
      traitFunctionResolutionDependsOnArgument(trait, traitFunction, pos, impl, implFunction, path,
        TSelfTypeParameter(trait)) and
      aft.appliesTo(f, i, pos) and
      t = aft.getTypeAt(path)
    |
      i = trait and
      f = traitFunction
      or
      i = impl and
      f = implFunction and
      not BlanketImplementation::isBlanketLike(i, _, _)
    )
  }

  pragma[nomagic]
  private predicate functionResolutionDependsOnArgument(
    ImplItemNode impl, NonMethodFunction f, FunctionPosition pos, TypeParameter tp
  ) {
    traitFunctionResolutionDependsOnArgument(_, _, pos, impl, f, _, tp)
    or
    // For inherent implementations of generic types, we also need to check the type being
    // implemented. We arbitrarily choose the first type parameter of the type being implemented
    // to represent this case.
    f = impl.getAnAssocItem() and
    not impl.(Impl).hasTrait() and
    tp = TTypeParamTypeParameter(impl.resolveSelfTy().getTypeParam(0)) and
    pos.isSelf()
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
    fc =
      any(NonMethodCall nmc |
        exists(string name, int arity |
          nmc.hasNameAndArity(name, arity) and
          functionInfoBlanketLikeRelevantPos(_, name, arity, _, trait, _, _, _, _)
        |
          not nmc.hasTrait()
          or
          trait = nmc.getTrait()
        )
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
     * Gets the associated function that this function call resolves to using path
     * resolution, if any.
     */
    pragma[nomagic]
    NonMethodFunction getPathResolutionResolved(ImplOrTraitItemNode i) {
      result = this.getPathResolutionResolved() and
      result = i.getAnAssocItem()
    }

    /**
     * Gets the blanket function that this call may resolve to, if any.
     */
    pragma[nomagic]
    NonMethodFunction resolveCallTargetBlanketCand(ImplItemNode impl) {
      exists(string name |
        this.hasNameAndArity(pragma[only_bind_into](name), _) and
        ArgIsInstantiationOfBlanketParam::argIsInstantiationOf(MkCallAndBlanketPos(this, _), impl, _) and
        result = impl.getASuccessor(pragma[only_bind_into](name))
      )
    }

    /** Gets the trait targeted by this call, if any. */
    Trait getTrait() { result = getCallExprTraitQualifier(this) }

    /** Holds if this call targets a trait. */
    predicate hasTrait() { exists(this.getTrait()) }

    AstNode getNodeAt(FunctionPosition pos) {
      result = this.getSyntacticArgument(pos.asArgumentPosition())
      or
      result = this and pos.isReturn()
    }

    Type getTypeAt(FunctionPosition pos, TypePath path) {
      result = inferType(this.getNodeAt(pos), path)
    }

    pragma[nomagic]
    NonMethodFunction resolveCallTargetNonBlanketCand(ImplItemNode i) {
      not this.hasTrait() and
      result = this.getPathResolutionResolved(i) and
      not exists(this.resolveCallTargetViaPathResolution()) and
      functionResolutionDependsOnArgument(i, result, _, _)
    }

    pragma[nomagic]
    predicate resolveCallTargetBlanketLikeCand(
      ImplItemNode impl, FunctionPosition pos, TypePath blanketPath, TypeParam blanketTypeParam
    ) {
      exists(string name, int arity, Trait trait, AssocFunctionType t |
        this.hasNameAndArity(name, arity) and
        exists(this.getTypeAt(pos, blanketPath)) and
        functionInfoBlanketLikeRelevantPos(_, name, arity, impl, trait, pos, t, blanketPath,
          blanketTypeParam) and
        BlanketTraitIsVisible::traitIsVisible(this, trait)
      |
        not this.hasTrait()
        or
        trait = this.getTrait()
      )
    }

    pragma[nomagic]
    predicate hasTraitResolved(TraitItemNode trait, NonMethodFunction resolved) {
      resolved = this.getPathResolutionResolved() and
      trait = this.getTrait()
    }

    /**
     * Holds if this call has no compatible non-blanket target, and it has some
     * candidate blanket target.
     */
    pragma[nomagic]
    predicate hasNoCompatibleNonBlanketTarget() {
      this.resolveCallTargetBlanketLikeCand(_, _, _, _) and
      not exists(this.resolveCallTargetViaPathResolution()) and
      forall(ImplOrTraitItemNode i, Function f | f = this.resolveCallTargetNonBlanketCand(i) |
        NonMethodArgsAreInstantiationsOfNonBlanket::argsAreNotInstantiationsOf(this, i, f)
      ) and
      (
        not this.hasTraitResolved(_, _)
        or
        exists(
          TraitItemNode trait, NonMethodFunction resolved, FunctionPosition pos, TypePath path,
          Type t
        |
          this.(NonMethodArgsAreInstantiationsOfNonBlanketInput::Call)
              .hasTraitResolvedSelfType(trait, resolved, pos, path, t)
        |
          forall(ImplOrTraitItemNode i, Function f |
            traitFunctionHasSelfType(trait, resolved, pos, path, t, i, f)
          |
            NonMethodArgsAreInstantiationsOfNonBlanket::argsAreNotInstantiationsOf(this, i, f)
          )
        )
      )
    }

    /**
     * Gets the target of this call, which can be resolved using only path resolution.
     */
    pragma[nomagic]
    ItemNode resolveCallTargetViaPathResolution() {
      not this.hasTrait() and
      result = this.getPathResolutionResolved() and
      not functionResolutionDependsOnArgument(_, result, _, _)
    }

    /**
     * Gets the target of this call, which can be resolved using type inference.
     */
    pragma[nomagic]
    NonMethodFunction resolveCallTargetViaTypeInference(ImplOrTraitItemNode i) {
      result = this.resolveCallTargetBlanketCand(i) and
      not FunctionOverloading::functionResolutionDependsOnArgument(_, result, _, _)
      or
      NonMethodArgsAreInstantiationsOfBlanket::argsAreInstantiationsOf(this, i, result)
      or
      NonMethodArgsAreInstantiationsOfNonBlanket::argsAreInstantiationsOf(this, i, result)
    }
  }

  private newtype TCallAndBlanketPos =
    MkCallAndBlanketPos(NonMethodCall fc, FunctionPosition pos) {
      fc.resolveCallTargetBlanketLikeCand(_, pos, _, _)
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
        fc.resolveCallTargetBlanketLikeCand(impl, pos, blanketPath, blanketTypeParam) and
        // Only apply blanket implementations when no other implementations are possible;
        // this is to account for codebases that use the (unstable) specialization feature
        // (https://rust-lang.github.io/rfcs/1210-impl-specialization.html), as well as
        // cases where our blanket implementation filtering is not precise enough.
        (fc.hasNoCompatibleNonBlanketTarget() or not impl.isBlanketImplementation())
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

  private Type getArgType(
    NonMethodCall call, FunctionPosition pos, TypePath path, boolean isDefaultTypeArg
  ) {
    result = inferType(call.getNodeAt(pos), path) and
    isDefaultTypeArg = false
    or
    result = getCallExprTypeQualifier(call, path, isDefaultTypeArg) and
    pos.isSelf()
  }

  private module NonMethodArgsAreInstantiationsOfBlanketInput implements
    ArgsAreInstantiationsOfInputSig
  {
    predicate toCheck(ImplOrTraitItemNode i, Function f, TypeParameter tp, FunctionPosition pos) {
      functionResolutionDependsOnArgument(i, f, pos, tp)
    }

    final class Call extends NonMethodCall {
      Type getArgType(FunctionPosition pos, TypePath path) {
        result = getArgType(this, pos, path, false)
      }

      predicate hasTargetCand(ImplOrTraitItemNode i, Function f) {
        f = this.resolveCallTargetBlanketCand(i)
      }
    }
  }

  private module NonMethodArgsAreInstantiationsOfBlanket =
    ArgsAreInstantiationsOf<NonMethodArgsAreInstantiationsOfBlanketInput>;

  private module NonMethodArgsAreInstantiationsOfNonBlanketInput implements
    ArgsAreInstantiationsOfInputSig
  {
    predicate toCheck(ImplOrTraitItemNode i, Function f, TypeParameter traitTp, FunctionPosition pos) {
      functionResolutionDependsOnArgument(i, f, pos, traitTp)
      or
      // Also match against the trait function itself
      FunctionOverloading::traitTypeParameterOccurrence(i, f, _, pos, _, traitTp) and
      traitTp = TSelfTypeParameter(i)
    }

    class Call extends NonMethodCall {
      Type getArgType(FunctionPosition pos, TypePath path) {
        result = getArgType(this, pos, path, _)
      }

      /**
       * Holds if this call is of the form `Trait::function(args)`, and the type at `pos` and
       * `path` matches the `Self` type parameter of `Trait`.
       */
      pragma[nomagic]
      predicate hasTraitResolvedSelfType(
        TraitItemNode trait, NonMethodFunction function, FunctionPosition pos, TypePath path, Type t
      ) {
        this.hasTraitResolved(trait, function) and
        FunctionOverloading::traitTypeParameterOccurrence(trait, function, _, pos, path,
          TSelfTypeParameter(trait)) and
        t = substituteLookupTraits(this.getArgType(pos, path)) and
        t != TUnknownType()
      }

      predicate hasTargetCand(ImplOrTraitItemNode i, Function f) {
        f = this.resolveCallTargetNonBlanketCand(i)
        or
        exists(
          TraitItemNode trait, NonMethodFunction resolved, FunctionPosition pos, TypePath path,
          Type t
        |
          this.hasTraitResolvedSelfType(trait, resolved, pos, path, t) and
          traitFunctionHasSelfType(trait, resolved, pos, path, t, i, f)
        )
      }
    }
  }

  private module NonMethodArgsAreInstantiationsOfNonBlanket =
    ArgsAreInstantiationsOf<NonMethodArgsAreInstantiationsOfNonBlanketInput>;
}

abstract private class TupleLikeConstructor extends Addressable {
  final TypeParameter getTypeParameter(TypeParameterPosition ppos) {
    typeParamMatchPosition(this.getTypeItem().getGenericParamList().getATypeParam(), result, ppos)
  }

  abstract TypeItem getTypeItem();

  abstract TupleField getTupleField(int i);

  Type getReturnType(TypePath path) {
    result = TDataType(this.getTypeItem()) and
    path.isEmpty()
    or
    result = TTypeParamTypeParameter(this.getTypeItem().getGenericParamList().getATypeParam()) and
    path = TypePath::singleton(result)
  }

  Type getDeclaredType(FunctionPosition pos, TypePath path) {
    result = this.getParameterType(pos, path)
    or
    pos.isReturn() and
    result = this.getReturnType(path)
    or
    pos.isSelf() and
    result = this.getReturnType(path)
  }

  Type getParameterType(FunctionPosition pos, TypePath path) {
    result = this.getTupleField(pos.asPosition()).getTypeRepr().(TypeMention).getTypeAt(path)
  }
}

private class TupleLikeStruct extends TupleLikeConstructor instanceof Struct {
  TupleLikeStruct() { this.isTuple() }

  override TypeItem getTypeItem() { result = this }

  override TupleField getTupleField(int i) { result = Struct.super.getTupleField(i) }
}

private class TupleLikeVariant extends TupleLikeConstructor instanceof Variant {
  TupleLikeVariant() { this.isTuple() }

  override TypeItem getTypeItem() { result = super.getEnum() }

  override TupleField getTupleField(int i) { result = Variant.super.getTupleField(i) }
}

/**
 * A matching configuration for resolving types of calls like
 * `foo::bar(baz)` where the target is not a method.
 *
 * This also includes "calls" to tuple variants and tuple structs such
 * as `Result::Ok(42)`.
 */
private module NonMethodCallMatchingInput implements MatchingInputSig {
  import FunctionPositionMatchingInput

  private class NonMethodFunctionDeclaration extends NonMethodFunction, FunctionDeclaration { }

  private newtype TDeclaration =
    TNonMethodFunctionDeclaration(ImplOrTraitItemNodeOption i, NonMethodFunctionDeclaration f) {
      f.isFor(i)
    } or
    TTupleLikeConstructorDeclaration(TupleLikeConstructor tc)

  abstract class Declaration extends TDeclaration {
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

    abstract string toString();

    abstract Location getLocation();
  }

  private class NonMethodFunctionDecl extends Declaration, TNonMethodFunctionDeclaration {
    private ImplOrTraitItemNodeOption i;
    private NonMethodFunctionDeclaration f;

    NonMethodFunctionDecl() { this = TNonMethodFunctionDeclaration(i, f) }

    override TypeParameter getTypeParameter(TypeParameterPosition ppos) {
      result = f.getTypeParameter(i, ppos)
    }

    override Type getParameterType(DeclarationPosition dpos, TypePath path) {
      result = f.getParameterTypeInclNonMethodSelf(i, dpos, path)
    }

    override Type getReturnType(TypePath path) { result = f.getReturnType(i, path) }

    override string toString() {
      i.isNone() and result = f.toString()
      or
      result = f.toStringExt(i.asSome())
    }

    override Location getLocation() { result = f.getLocation() }
  }

  private class TupleLikeConstructorDeclaration extends Declaration,
    TTupleLikeConstructorDeclaration
  {
    TupleLikeConstructor tc;

    TupleLikeConstructorDeclaration() { this = TTupleLikeConstructorDeclaration(tc) }

    override TypeParameter getTypeParameter(TypeParameterPosition ppos) {
      result = tc.getTypeParameter(ppos)
    }

    override Type getParameterType(DeclarationPosition dpos, TypePath path) {
      result = tc.getParameterType(dpos, path)
    }

    override Type getReturnType(TypePath path) { result = tc.getReturnType(path) }

    override string toString() { result = tc.toString() }

    override Location getLocation() { result = tc.getLocation() }
  }

  class Access extends NonMethodResolution::NonMethodCall, ContextTyping::ContextTypedCallCand {
    pragma[nomagic]
    override Type getTypeArgument(TypeArgumentPosition apos, TypePath path) {
      result = getCallExprTypeArgument(this, apos, path)
    }

    pragma[nomagic]
    Type getInferredType(AccessPosition apos, TypePath path) {
      apos.isSelf() and
      result = getCallExprTypeQualifier(this, path, false)
      or
      result = inferType(this.getNodeAt(apos), path)
    }

    pragma[inline]
    Declaration getTarget() {
      exists(ImplOrTraitItemNodeOption i, NonMethodFunctionDeclaration f |
        result = TNonMethodFunctionDeclaration(i, f)
      |
        f = this.resolveCallTargetViaTypeInference(i.asSome()) // mutual recursion; resolving some associated function calls requires resolving types
        or
        f = this.resolveCallTargetViaPathResolution() and
        f.isDirectlyFor(i)
      )
      or
      exists(ItemNode i | i = this.resolveCallTargetViaPathResolution() |
        result = TTupleLikeConstructorDeclaration(i)
      )
    }

    /**
     * Holds if the return type of this call at `path` may have to be inferred
     * from the context.
     */
    pragma[nomagic]
    predicate hasUnknownTypeAt(FunctionPosition pos, TypePath path) {
      exists(ImplOrTraitItemNodeOption i, NonMethodFunctionDeclaration f |
        TNonMethodFunctionDeclaration(i, f) = this.getTarget() and
        this.hasUnknownTypeAt(i.asSome(), f, pos, path)
      )
      or
      forex(ImplOrTraitItemNode i, NonMethodFunctionDeclaration f |
        f = this.getPathResolutionResolved(i)
      |
        this.hasUnknownTypeAt(i, f, pos, path)
      )
      or
      // Tuple declarations, such as `Result::Ok(...)`, may also be context typed
      exists(TupleLikeConstructor tc, TypeParameter tp |
        tc = this.resolveCallTargetViaPathResolution() and
        pos.isReturn() and
        tp = tc.getReturnType(path) and
        not tp = tc.getParameterType(_, _) and
        // check that no explicit type arguments have been supplied for `tp`
        not exists(TypeArgumentPosition tapos |
          exists(this.getTypeArgument(tapos, _)) and
          TTypeParamTypeParameter(tapos.asTypeParam()) = tp
        )
      )
    }
  }
}

private module NonMethodCallMatching = Matching<NonMethodCallMatchingInput>;

pragma[nomagic]
private Type inferNonMethodCallType0(AstNode n, boolean isReturn, TypePath path) {
  exists(NonMethodCallMatchingInput::Access a, NonMethodCallMatchingInput::AccessPosition apos |
    n = a.getNodeAt(apos) and
    if apos.isReturn() then isReturn = true else isReturn = false
  |
    result = NonMethodCallMatching::inferAccessType(a, apos, path)
    or
    a.hasUnknownTypeAt(apos, path) and
    result = TUnknownType()
  )
}

private predicate inferNonMethodCallType =
  ContextTyping::CheckContextTyping<inferNonMethodCallType0/3>::check/2;

/**
 * A matching configuration for resolving types of operations like `a + b`.
 */
private module OperationMatchingInput implements MatchingInputSig {
  private import codeql.rust.elements.internal.OperationImpl::Impl as OperationImpl
  import FunctionPositionMatchingInput

  class Declaration extends MethodCallMatchingInput::Declaration {
    private Method getSelfOrImpl() {
      result = m
      or
      m.implements(result)
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
    private predicate derefsReturn() { this.getSelfOrImpl() = any(DerefTrait t).getDerefFunction() }

    Type getDeclaredType(DeclarationPosition dpos, TypePath path) {
      exists(TypePath path0 |
        result = super.getDeclaredType(dpos, path0) and
        if
          this.borrowsAt(dpos)
          or
          dpos.isReturn() and this.derefsReturn()
        then path0.isCons(getRefTypeParameter(_), path)
        else path0 = path
      )
    }
  }

  class Access extends MethodResolution::MethodCallOperation {
    Type getTypeArgument(TypeArgumentPosition apos, TypePath path) { none() }

    pragma[nomagic]
    Type getInferredType(AccessPosition apos, TypePath path) {
      result = inferType(this.getNodeAt(apos), path)
    }

    Declaration getTarget() {
      exists(ImplOrTraitItemNode i |
        result.isMethod(i, this.resolveCallTarget(i, _, _)) // mutual recursion
      )
    }
  }
}

private module OperationMatching = Matching<OperationMatchingInput>;

pragma[nomagic]
private Type inferOperationType0(AstNode n, boolean isReturn, TypePath path) {
  exists(OperationMatchingInput::Access a, OperationMatchingInput::AccessPosition apos |
    n = a.getNodeAt(apos) and
    result = OperationMatching::inferAccessType(a, apos, path) and
    if apos.isReturn() then isReturn = true else isReturn = false
  )
}

private predicate inferOperationType =
  ContextTyping::CheckContextTyping<inferOperationType0/3>::check/2;

pragma[nomagic]
private Type getFieldExprLookupType(FieldExpr fe, string name, DerefChain derefChain) {
  exists(TypePath path |
    result = inferType(fe.getContainer(), path) and
    name = fe.getIdentifier().getText() and
    isComplexRootStripped(path, result)
  |
    // TODO: Support full derefence chains as for method calls
    path.isEmpty() and
    derefChain = DerefChain::nil()
    or
    exists(DerefImplItemNode impl, TypeParamTypeParameter tp |
      tp = impl.getFirstSelfTypeParameter() and
      path.getHead() = tp and
      derefChain = DerefChain::singleton(impl)
    )
  )
}

pragma[nomagic]
private Type getTupleFieldExprLookupType(FieldExpr fe, int pos, DerefChain derefChain) {
  exists(string name |
    result = getFieldExprLookupType(fe, name, derefChain) and
    pos = name.toInt()
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
    TTupleFieldDecl(TupleField tf)

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
        result = TDataType(s) and
        path.isEmpty()
        or
        result = TTypeParamTypeParameter(s.getGenericParamList().getATypeParam()) and
        path = TypePath::singleton(result)
      )
      or
      dpos.isField() and
      result = this.getTypeRepr().(TypeMention).getTypeAt(path)
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
          path0.isCons(getRefTypeParameter(_), path)
          or
          not path0.isCons(getRefTypeParameter(_), _) and
          not (result instanceof RefType and path0.isEmpty()) and
          path = path0
        else path = path0
      )
    }

    Declaration getTarget() {
      // mutual recursion; resolving fields requires resolving types and vice versa
      result =
        [
          TStructFieldDecl(resolveStructFieldExpr(this, _)).(TDeclaration),
          TTupleFieldDecl(resolveTupleFieldExpr(this, _))
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
        if receiverType instanceof RefType
        then
          // adjust for implicit deref
          not path0.isCons(getRefTypeParameter(_), _) and
          not (path0.isEmpty() and result instanceof RefType) and
          path = TypePath::cons(getRefTypeParameter(_), path0)
        else path = path0
      )
    else path = path0
  )
}

/** Gets the root type of the reference expression `ref`. */
pragma[nomagic]
private Type inferRefExprType(RefExpr ref) {
  if ref.isRaw()
  then
    ref.isMut() and result instanceof PtrMutType
    or
    ref.isConst() and result instanceof PtrConstType
  else
    if ref.isMut()
    then result instanceof RefMutType
    else result instanceof RefSharedType
}

/** Gets the root type of the reference node `ref`. */
pragma[nomagic]
private Type inferRefPatType(AstNode ref) {
  exists(boolean isMut |
    ref =
      any(IdentPat ip |
        ip.isRef() and
        if ip.isMut() then isMut = true else isMut = false
      ).getName()
    or
    ref = any(RefPat rp | if rp.isMut() then isMut = true else isMut = false)
  |
    result = getRefType(isMut)
  )
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
private StructType getStrStruct() { result = TDataType(any(Builtins::Str s)) }

pragma[nomagic]
private Type inferLiteralType(LiteralExpr le, TypePath path, boolean certain) {
  path.isEmpty() and
  exists(Builtins::BuiltinType t | result = TDataType(t) |
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
    path.isEmpty() and result instanceof RefSharedType
    or
    path = TypePath::singleton(getRefTypeParameter(false)) and
    result = getStrStruct()
  ) and
  certain = true
}

pragma[nomagic]
private DynTraitType getFutureTraitType() { result.getTrait() instanceof FutureTrait }

pragma[nomagic]
private AssociatedTypeTypeParameter getFutureOutputTypeParameter() {
  result = getAssociatedTypeTypeParameter(any(FutureTrait ft).getOutputType())
}

pragma[nomagic]
private DynTraitTypeParameter getDynFutureOutputTypeParameter() {
  result.getTraitTypeParameter() = getFutureOutputTypeParameter()
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
    path = TypePath::singleton(getDynFutureOutputTypeParameter()) and
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
  pragma[nomagic]
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
private Type inferArrayExprType(ArrayExpr ae) { exists(ae) and result instanceof ArrayType }

/**
 * Gets the root type of the range expression `re`.
 */
pragma[nomagic]
private Type inferRangeExprType(RangeExpr re) { result = TDataType(getRangeType(re)) }

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
    TDataType(t) = inferType(ie.getIndex()) and
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
    exprPath.isCons(getArrayTypeParameter(), path)
    or
    exists(TypePath path0 |
      exprPath.isCons(getRefTypeParameter(_), path0) and
      path0.isCons(getSliceTypeParameter(), path)
    )
  )
}

pragma[nomagic]
private Type getInferredDerefType(DerefExpr de, TypePath path) { result = inferType(de, path) }

pragma[nomagic]
private PtrType getInferredDerefExprPtrType(DerefExpr de) { result = inferType(de.getExpr()) }

/**
 * Gets the inferred type of `n` at `path` when `n` occurs in a dereference
 * expression `*n` and when `n` is known to have a raw pointer type.
 *
 * The other direction is handled in `typeEqualityAsymmetric`.
 */
private Type inferDereferencedExprPtrType(AstNode n, TypePath path) {
  exists(DerefExpr de, PtrType type, TypePath suffix |
    de.getExpr() = n and
    type = getInferredDerefExprPtrType(de) and
    result = getInferredDerefType(de, suffix) and
    path = TypePath::cons(type.getPositionalTypeParameter(0), suffix)
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
      result = this.getPath().(TypeMention).getTypeAt(path)
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

  class Declaration = TupleLikeConstructor;

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
      result = this.getPath().(TypeMention).getTypeAt(path)
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
  result = getAssociatedTypeTypeParameter(any(IteratorTrait t).getItemType())
}

pragma[nomagic]
private AssociatedTypeTypeParameter getIntoIteratorItemTypeParameter() {
  result = getAssociatedTypeTypeParameter(any(IntoIteratorTrait t).getItemType())
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
    inferType(fe.getIterable()) != getArrayTypeParameter()
  )
}

/**
 * An invoked expression, the target of a call that is either a local variable
 * or a non-path expression. This means that the expression denotes a
 * first-class function.
 */
final private class InvokedClosureExpr extends Expr {
  private CallExprImpl::DynamicCallExpr call;

  InvokedClosureExpr() { call.getFunction() = this }

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

/**
 * Gets the root type of a closure.
 *
 * We model closures as `dyn Fn` trait object types. A closure might implement
 * only `Fn`, `FnMut`, or `FnOnce`. But since `Fn` is a subtrait of the others,
 * giving closures the type `dyn Fn` works well in practice -- even if not
 * entirely accurate.
 */
private DynTraitType closureRootType() {
  result = TDynTraitType(any(FnTrait t)) // always exists because of the mention in `builtins/mentions.rs`
}

/** Gets the path to a closure's return type. */
private TypePath closureReturnPath() {
  result =
    TypePath::singleton(TDynTraitTypeParameter(any(FnTrait t), any(FnOnceTrait t).getOutputType()))
}

/** Gets the path to a closure with arity `arity`'s `index`th parameter type. */
pragma[nomagic]
private TypePath closureParameterPath(int arity, int index) {
  result =
    TypePath::cons(TDynTraitTypeParameter(_, any(FnTrait t).getTypeParam()),
      TypePath::singleton(getTupleTypeParameter(arity, index)))
}

/** Gets the path to the return type of the `FnOnce` trait. */
private TypePath fnReturnPath() {
  result = TypePath::singleton(getAssociatedTypeTypeParameter(any(FnOnceTrait t).getOutputType()))
}

/**
 * Gets the path to the parameter type of the `FnOnce` trait with arity `arity`
 * and index `index`.
 */
pragma[nomagic]
private TypePath fnParameterPath(int arity, int index) {
  result =
    TypePath::cons(TTypeParamTypeParameter(any(FnOnceTrait t).getTypeParam()),
      TypePath::singleton(getTupleTypeParameter(arity, index)))
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
        n = ce.getCall().getSyntacticPositionalArgument(index) and
        path =
          path0.stripPrefix(fnParameterPath(ce.getCall().getArgList().getNumberOfArgs(), index))
      )
    )
    or
    // _If_ the invoked expression has the type of a closure, then we propagate
    // the surrounding types into the closure.
    exists(int arity, TypePath path0 | ce.getTypeAt(TypePath::nil()) = closureRootType() |
      // Propagate the type of arguments to the parameter types of closure
      exists(int index, ArgList args |
        n = ce and
        args = ce.getCall().getArgList() and
        arity = args.getNumberOfArgs() and
        result = inferType(args.getArg(index), path0) and
        path = closureParameterPath(arity, index).append(path0)
      )
      or
      // Propagate the type of the call expression to the return type of the closure
      n = ce and
      arity = ce.getCall().getArgList().getNumberOfArgs() and
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
    result = closureRootType()
    or
    n = ce and
    path = TypePath::singleton(TDynTraitTypeParameter(_, any(FnTrait t).getTypeParam())) and
    result.(TupleType).getArity() = ce.getNumberOfParams()
    or
    // Propagate return type annotation to body
    n = ce.getClosureBody() and
    result = ce.getRetType().getTypeRepr().(TypeMention).getTypeAt(path)
  )
}

pragma[nomagic]
private Type inferCastExprType(CastExpr ce, TypePath path) {
  result = ce.getTypeRepr().(TypeMention).getTypeAt(path)
}

cached
private module Cached {
  /** Holds if `n` is implicitly dereferenced and/or borrowed. */
  cached
  predicate implicitDerefChainBorrow(Expr e, DerefChain derefChain, boolean borrow) {
    exists(BorrowKind bk |
      any(MethodResolution::MethodCall mc).argumentHasImplicitDerefChainBorrow(e, derefChain, bk) and
      if bk.isNoBorrow() then borrow = false else borrow = true
    )
    or
    e =
      any(FieldExpr fe |
        exists(resolveStructFieldExpr(fe, derefChain))
        or
        exists(resolveTupleFieldExpr(fe, derefChain))
      ).getContainer() and
    not derefChain.isEmpty() and
    borrow = false
  }

  /**
   * Gets an item (function or tuple struct/variant) that `call` resolves to, if
   * any.
   *
   * The parameter `dispatch` is `true` if and only if the resolved target is a
   * trait item because a precise target could not be determined from the
   * types (for instance in the presence of generics or `dyn` types)
   */
  cached
  Addressable resolveCallTarget(InvocationExpr call, boolean dispatch) {
    dispatch = false and
    result = call.(NonMethodResolution::NonMethodCall).resolveCallTargetViaPathResolution()
    or
    exists(ImplOrTraitItemNode i |
      i instanceof TraitItemNode and dispatch = true
      or
      i instanceof ImplItemNode and dispatch = false
    |
      result = call.(MethodResolution::MethodCall).resolveCallTarget(i, _, _) or
      result = call.(NonMethodResolution::NonMethodCall).resolveCallTargetViaTypeInference(i)
    )
  }

  /**
   * Gets the struct field that the field expression `fe` resolves to, if any.
   */
  cached
  StructField resolveStructFieldExpr(FieldExpr fe, DerefChain derefChain) {
    exists(string name, DataType ty |
      ty = getFieldExprLookupType(fe, pragma[only_bind_into](name), derefChain)
    |
      result = ty.(StructType).getTypeItem().getStructField(pragma[only_bind_into](name)) or
      result = ty.(UnionType).getTypeItem().getStructField(pragma[only_bind_into](name))
    )
  }

  /**
   * Gets the tuple field that the field expression `fe` resolves to, if any.
   */
  cached
  TupleField resolveTupleFieldExpr(FieldExpr fe, DerefChain derefChain) {
    exists(int i |
      result =
        getTupleFieldExprLookupType(fe, pragma[only_bind_into](i), derefChain)
            .(StructType)
            .getTypeItem()
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
      result = inferDereferencedExprPtrType(n, path)
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

  Addressable debugResolveCallTarget(InvocationExpr c, boolean dispatch) {
    c = getRelevantLocatable() and
    result = resolveCallTarget(c, dispatch)
  }

  predicate debugConditionSatisfiesConstraint(
    TypeAbstraction abs, TypeMention condition, TypeMention constraint, boolean transitive
  ) {
    abs = getRelevantLocatable() and
    Input::conditionSatisfiesConstraint(abs, condition, constraint, transitive)
  }

  predicate debugInferShorthandSelfType(ShorthandSelfParameterMention self, TypePath path, Type t) {
    self = getRelevantLocatable() and
    t = self.getTypeAt(path)
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
    tm.getTypeAt(path) = type
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
