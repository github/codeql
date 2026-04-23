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

private module Input1 implements InputSig1<Location> {
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
}

private import Input1

private module M1 = Make1<Location, Input1>;

import M1

predicate getTypePathLimit = Input1::getTypePathLimit/0;

predicate getTypeParameterId = Input1::getTypeParameterId/1;

class TypePath = M1::TypePath;

module TypePath = M1::TypePath;

/**
 * Provides shared logic for implementing `InputSig2<PreTypeMention>` and
 * `InputSig2<TypeMention>`.
 */
private module Input2Common {
  AstNode getATypeParameterConstraint(TypeParameter tp) {
    result = tp.(TypeParamTypeParameter).getTypeParam().getATypeBound().getTypeRepr() or
    result = tp.(SelfTypeParameter).getTrait() or
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
    TypeAbstraction abs, AstNode condition, AstNode constraint, boolean transitive
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

  predicate typeParameterIsFunctionallyDetermined(TypeParameter tp) {
    tp instanceof AssociatedTypeTypeParameter
  }
}

private module PreInput2 implements InputSig2<PreTypeMention> {
  PreTypeMention getABaseTypeMention(Type t) { none() }

  PreTypeMention getATypeParameterConstraint(TypeParameter tp) {
    result = Input2Common::getATypeParameterConstraint(tp)
  }

  predicate conditionSatisfiesConstraint(
    TypeAbstraction abs, PreTypeMention condition, PreTypeMention constraint, boolean transitive
  ) {
    Input2Common::conditionSatisfiesConstraint(abs, condition, constraint, transitive)
  }

  predicate typeAbstractionHasAmbiguousConstraintAt(
    TypeAbstraction abs, Type constraint, TypePath path
  ) {
    FunctionOverloading::preImplHasAmbiguousSiblingAt(abs, constraint.(TraitType).getTrait(), path)
  }

  predicate typeParameterIsFunctionallyDetermined =
    Input2Common::typeParameterIsFunctionallyDetermined/1;
}

/** Provides an instantiation of the shared type inference library for `PreTypeMention`s. */
module PreM2 = Make2<PreTypeMention, PreInput2>;

private module Input2 implements InputSig2<TypeMention> {
  TypeMention getABaseTypeMention(Type t) { none() }

  TypeMention getATypeParameterConstraint(TypeParameter tp) {
    result = Input2Common::getATypeParameterConstraint(tp)
  }

  predicate conditionSatisfiesConstraint(
    TypeAbstraction abs, TypeMention condition, TypeMention constraint, boolean transitive
  ) {
    Input2Common::conditionSatisfiesConstraint(abs, condition, constraint, transitive)
  }

  predicate typeAbstractionHasAmbiguousConstraintAt(
    TypeAbstraction abs, Type constraint, TypePath path
  ) {
    FunctionOverloading::implHasAmbiguousSiblingAt(abs, constraint.(TraitType).getTrait(), path)
  }

  predicate typeParameterIsFunctionallyDetermined =
    Input2Common::typeParameterIsFunctionallyDetermined/1;
}

private import Input2

private module M2 = Make2<TypeMention, Input2>;

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
  Type getParameterType(ImplOrTraitItemNodeOption i, FunctionPosition pos, TypePath path) {
    i = parent and
    (
      not pos.isReturn() and
      result = getAssocFunctionTypeAt(this, i.asSome(), pos, path)
      or
      i.isNone() and
      result = this.getParam(pos.asPosition()).getTypeRepr().(TypeMention).getTypeAt(path)
    )
  }

  private Type resolveRetType(ImplOrTraitItemNodeOption i, TypePath path) {
    i = parent and
    (
      result =
        getAssocFunctionTypeAt(this, i.asSome(), any(FunctionPosition ret | ret.isReturn()), path)
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

private class AssocFunctionDeclaration extends FunctionDeclaration {
  AssocFunctionDeclaration() { this.isAssoc(_) }
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

// Due to "binding modes" the type of the pattern is not necessarily the
// same as the type of the initializer. However, when the pattern is an
// identifier pattern, its type is guaranteed to be the same as the type of the
// initializer.
private predicate identLetStmt(LetStmt let, IdentPat lhs, Expr rhs) {
  let.getPat() = lhs and
  let.getInitializer() = rhs
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

/** Gets the path to a closure's `index`th parameter type, where the arity is `arity`. */
pragma[nomagic]
private TypePath closureParameterPath(int arity, int index) {
  result =
    TypePath::cons(TDynTraitTypeParameter(_, any(FnTrait t).getTypeParam()),
      TypePath::singleton(getTupleTypeParameter(arity, index)))
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
        identLetStmt(let, n1, n2)
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
    or
    exists(CallExprImpl::DynamicCallExpr dce, TupleType tt, int i |
      n1 = dce.getArgList() and
      tt.getArity() = dce.getNumberOfSyntacticArguments() and
      n2 = dce.getSyntacticPositionalArgument(i) and
      prefix1 = TypePath::singleton(tt.getPositionalTypeParameter(i)) and
      prefix2.isEmpty()
    )
    or
    exists(ClosureExpr ce, int index |
      n1 = ce and
      n2 = ce.getParam(index).getPat() and
      prefix1 = closureParameterPath(ce.getNumberOfParams(), index) and
      prefix2.isEmpty()
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
    n instanceof ClosureExpr and
    path.isEmpty() and
    result = closureRootType()
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
   * Holds if `n` has complete and certain type information at `path`.
   */
  pragma[nomagic]
  predicate hasInferredCertainType(AstNode n, TypePath path) { exists(inferCertainType(n, path)) }

  /**
   * Holds if `n` having type `t` at `path` conflicts with certain type information
   * at `prefix`.
   */
  bindingset[n, prefix, path, t]
  pragma[inline_late]
  predicate certainTypeConflict(AstNode n, TypePath prefix, TypePath path, Type t) {
    inferCertainType(n, path) != t
    or
    // If we infer that `n` has _some_ type at `T1.T2....Tn`, and we also
    // know that `n` certainly has type `certainType` at `T1.T2...Ti`, `0 <= i < n`,
    // then it must be the case that `T(i+1)` is a type parameter of `certainType`,
    // otherwise there is a conflict.
    //
    // Below, `prefix` is `T1.T2...Ti` and `tp` is `T(i+1)`.
    exists(TypePath suffix, TypeParameter tp, Type certainType |
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
  or
  parent = any(ClosureExpr ce | not ce.hasRetType() and ce.getClosureBody() = child) and
  prefix = closureReturnPath()
  or
  exists(Struct s |
    child = [parent.(RangeExpr).getStart(), parent.(RangeExpr).getEnd()] and
    prefix = TypePath::singleton(TTypeParamTypeParameter(s.getGenericParamList().getATypeParam())) and
    s = getRangeType(parent)
  )
}

private Type inferUnknownTypeFromAnnotation(AstNode n, TypePath path) {
  inferType(n, path) = TUnknownType() and
  // Normally, these are coercion sites, but in case a type is unknown we
  // allow for type information to flow from the type annotation.
  exists(TypeMention tm | result = tm.getTypeAt(path) |
    tm = any(LetStmt let | identLetStmt(let, _, n)).getTypeRepr()
    or
    tm = any(ClosureExpr ce | n = ce.getBody()).getRetType().getTypeRepr()
    or
    tm = getReturnTypeMention(any(Function f | n = f.getBody()))
  )
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

pragma[nomagic]
private predicate nonAssocFunction(ItemNode i) { not i instanceof AssocFunctionDeclaration }

/**
 * A call expression that can only resolve to something that is not an associated
 * function, and hence does not need type inference for resolution.
 */
private class NonAssocCallExpr extends CallExpr {
  NonAssocCallExpr() {
    forex(ItemNode i | i = CallExprImpl::getResolvedFunction(this) | nonAssocFunction(i))
  }

  /**
   * Gets the target of this call, which can be resolved using only path resolution.
   */
  ItemNode resolveCallTargetViaPathResolution() { result = CallExprImpl::getResolvedFunction(this) }

  pragma[nomagic]
  Type getTypeArgument(TypeArgumentPosition apos, TypePath path) {
    result = getCallExprTypeArgument(this, apos, path)
  }

  AstNode getNodeAt(FunctionPosition pos) {
    result = this.getSyntacticArgument(pos.asArgumentPosition())
    or
    result = this and pos.isReturn()
  }

  pragma[nomagic]
  Type getInferredType(FunctionPosition pos, TypePath path) {
    pos.isTypeQualifier() and
    result = getCallExprTypeQualifier(this, path, false)
    or
    result = inferType(this.getNodeAt(pos), path)
  }
}

/**
 * Provides functionality related to context-based typing of calls.
 */
private module ContextTyping {
  /**
   * Holds if `f` mentions type parameter `tp` at some non-return position,
   * possibly via a constraint on another mentioned type parameter.
   */
  pragma[nomagic]
  private predicate assocFunctionMentionsTypeParameterAtNonRetPos(
    ImplOrTraitItemNode i, Function f, TypeParameter tp
  ) {
    exists(FunctionPosition nonRetPos |
      not nonRetPos.isReturn() and
      not nonRetPos.isTypeQualifier() and
      tp = getAssocFunctionTypeAt(f, i, nonRetPos, _)
    )
    or
    exists(TypeParameter mid |
      assocFunctionMentionsTypeParameterAtNonRetPos(i, f, mid) and
      tp = getATypeParameterConstraint(mid).getTypeAt(_)
    )
  }

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
    not assocFunctionMentionsTypeParameterAtNonRetPos(i, f, tp)
  }

  /**
   * A call where the type of the result may have to be inferred from the
   * context in which the call appears, for example a call like
   * `Default::default()`.
   */
  abstract class ContextTypedCallCand extends AstNode {
    abstract Type getTypeArgument(TypeArgumentPosition apos, TypePath path);

    predicate hasTypeArgument(TypeArgumentPosition apos) { exists(this.getTypeArgument(apos, _)) }

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

  newtype FunctionPositionKind =
    SelfKind() or
    ReturnKind() or
    PositionalKind()

  signature Type inferCallTypeSig(AstNode n, FunctionPositionKind kind, TypePath path);

  /**
   * Given a predicate `inferCallType` for inferring the type of a call at a given
   * position, this module exposes the predicate `check`, which wraps the input
   * predicate and checks that types are only propagated into arguments when they
   * are context-typed.
   */
  module CheckContextTyping<inferCallTypeSig/3 inferCallType> {
    pragma[nomagic]
    private Type inferCallNonReturnType(
      AstNode n, FunctionPositionKind kind, TypePath prefix, TypePath path
    ) {
      result = inferCallType(n, kind, path) and
      hasUnknownType(n) and
      kind != ReturnKind() and
      prefix = path.getAPrefix()
    }

    pragma[nomagic]
    Type check(AstNode n, TypePath path) {
      result = inferCallType(n, ReturnKind(), path)
      or
      exists(FunctionPositionKind kind, TypePath prefix |
        result = inferCallNonReturnType(n, kind, prefix, path) and
        hasUnknownTypeAt(n, prefix)
      |
        // Never propagate type information directly into the receiver, since its type
        // must already have been known in order to resolve the call
        if kind = SelfKind() then not prefix.isEmpty() else any()
      )
    }
  }
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
 * Provides logic for resolving calls to associated functions.
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
private module AssocFunctionResolution {
  /**
   * Holds if function `f` with the name `name` and the arity `arity` exists in
   * `i`, and the type at function-call adjusted position `pos` is `t`.
   */
  pragma[nomagic]
  private predicate assocFunctionInfo(
    Function f, string name, int arity, ImplOrTraitItemNode i, FunctionPosition pos,
    AssocFunctionType t
  ) {
    f = i.getASuccessor(name) and
    arity = f.getNumberOfParamsInclSelf() and
    t.appliesTo(f, i, pos)
  }

  /**
   * Holds if the non-method trait function `f` mentions the implicit `Self` type
   * parameter at position `pos`.
   */
  pragma[nomagic]
  private predicate traitSelfTypeParameterOccurrence(
    TraitItemNode trait, NonMethodFunction f, FunctionPosition pos
  ) {
    FunctionOverloading::traitTypeParameterOccurrence(trait, f, _, pos, _, TSelfTypeParameter(trait))
  }

  /**
   * Holds if the non-method function `f` implements a trait function that mentions
   * the implicit `Self` type parameter at position `pos`.
   */
  pragma[nomagic]
  private predicate traitImplSelfTypeParameterOccurrence(
    ImplItemNode impl, NonMethodFunction f, FunctionPosition pos
  ) {
    exists(NonMethodFunction traitFunction |
      f = impl.getAnAssocItem() and
      f.implements(traitFunction) and
      traitSelfTypeParameterOccurrence(_, traitFunction, pos)
    )
  }

  private module TypeOption = Option<Type>;

  private class TypeOption = TypeOption::Option;

  /**
   * Holds if function `f` with the name `name` and the arity `arity` exists in
   * `i`, and the type at function-call adjusted position `selfPos` is `selfType`.
   *
   * `selfPos` is a position relevant for call resolution: either a position
   * corresponding to the `self` parameter of `f` (if present); a type qualifier
   * position; or a position where the implicit `Self` type parameter of some trait
   * is mentioned in some non-method function `f_trait`, and either `f = f_trait`
   * or `f` implements `f_trait`.
   *
   * `strippedTypePath` points to the type `strippedType` inside `selfType`, which
   * is the (possibly complex-stripped) root type of `selfType`. For example, if
   * `f` has a `&self` parameter, then `strippedTypePath` is `getRefSharedTypeParameter()`
   * and `strippedType` is the type inside the reference.
   *
   * `implType` is the type being implemented by `i` (`None` when `i` is a trait).
   *
   * `trait` is the trait being implemented by `i` or `i` itself (`None` when `i` is inherent).
   *
   * `isMethod` indicates whether `f` is a method.
   */
  pragma[nomagic]
  private predicate assocFunctionInfo(
    Function f, string name, int arity, FunctionPosition selfPos, ImplOrTraitItemNode i,
    AssocFunctionType selfType, TypePath strippedTypePath, Type strippedType, TypeOption implType,
    TypeOption trait, boolean isMethod
  ) {
    assocFunctionInfo(f, name, arity, i, selfPos, selfType) and
    strippedType = selfType.getTypeAt(strippedTypePath) and
    (
      isComplexRootStripped(strippedTypePath, strippedType)
      or
      selfPos.isTypeQualifier() and strippedTypePath.isEmpty()
    ) and
    (
      f instanceof Method and
      selfPos.asPosition() = 0
      or
      selfPos.isTypeQualifier()
      or
      traitSelfTypeParameterOccurrence(i, f, selfPos)
      or
      traitImplSelfTypeParameterOccurrence(i, f, selfPos)
    ) and
    (
      implType.asSome() = resolveImplSelfTypeAt(i, TypePath::nil())
      or
      i instanceof Trait and
      implType.isNone()
    ) and
    (
      trait.asSome() =
        [
          TTrait(i).(Type),
          TTrait(i.(ImplItemNode).resolveTraitTy()).(Type)
        ]
      or
      i.(Impl).isInherent() and trait.isNone()
    ) and
    if f instanceof Method then isMethod = true else isMethod = false
  }

  /**
   * Holds if function `f` with the name `name` and the arity `arity` exists in
   * blanket (like) implementation `impl`, and the type at function-call adjusted
   * position `selfPos` is `selfType`.
   *
   * `selfPos` is a position relevant for call resolution: either a position
   * corresponding to the `self` parameter of `f` (if present); a type qualifier
   * position; or a position where the implicit `Self` type parameter of some trait
   * is mentioned in some non-method function `f_trait`, and `f` implements `f_trait`.
   *
   * `blanketPath` points to the type `blanketTypeParam` inside `selfType`, which
   * is the type parameter used in the blanket implementation.
   *
   * `implType` is the type being implemented by `i`.
   *
   * `trait` is the trait being implemented by `i`.
   *
   * `isMethod` indicates whether `f` is a method.
   */
  pragma[nomagic]
  private predicate assocFunctionInfoBlanketLike(
    Function f, string name, int arity, ImplItemNode impl, TypeOption implType, TypeOption trait,
    FunctionPosition selfPos, AssocFunctionType selfType, TypePath blanketPath,
    TypeParam blanketTypeParam, boolean isMethod
  ) {
    exists(TypePath blanketSelfPath |
      assocFunctionInfo(f, name, arity, selfPos, impl, selfType, _, _, implType, trait, isMethod) and
      TTypeParamTypeParameter(blanketTypeParam) = selfType.getTypeAt(blanketPath) and
      blanketPath = any(string s) + blanketSelfPath and
      BlanketImplementation::isBlanketLike(impl, blanketSelfPath, blanketTypeParam)
    )
  }

  pragma[nomagic]
  private predicate assocFunctionTraitInfo(string name, int arity, Trait trait) {
    exists(ImplItemNode i |
      assocFunctionInfo(_, name, arity, i, _, _) and
      trait = i.resolveTraitTy()
    )
    or
    assocFunctionInfo(_, name, arity, trait, _, _)
  }

  pragma[nomagic]
  private predicate assocFunctionCallTraitCandidate(Element afc, Trait trait) {
    afc =
      any(AssocFunctionCall afc0 |
        exists(string name, int arity |
          afc0.hasNameAndArity(name, arity) and
          assocFunctionTraitInfo(name, arity, trait) and
          // we only need to check visibility of traits that are not mentioned explicitly
          not afc0.hasATrait()
        )
      )
  }

  private module AssocFunctionTraitIsVisible = TraitIsVisible<assocFunctionCallTraitCandidate/2>;

  bindingset[afc, impl]
  pragma[inline_late]
  private predicate callVisibleImplTraitCandidate(AssocFunctionCall afc, ImplItemNode impl) {
    AssocFunctionTraitIsVisible::traitIsVisible(afc, impl.resolveTraitTy())
  }

  /**
   * Checks that the explicit type qualifier of a call (if any), `typeQualifier`,
   * matches the type being implemented by the target, `implType`.
   */
  bindingset[implType]
  private predicate callTypeQualifierCheck(TypeOption implType, TypeOption typeQualifier) {
    typeQualifier = [implType, TypeOption::none_()]
  }

  /**
   * Checks that the explicit trait qualifier of a call (if any), `traitQualifier`,
   * matches the trait being implemented by the target (or in which the target is defined),
   * `trait`, and that when a receiver is present in the call, the target is a method.
   */
  bindingset[trait, isMethod]
  pragma[inline_late]
  private predicate callTraitQualifierAndReceiverCheck(
    TypeOption trait, Boolean isMethod, TypeOption traitQualifier, boolean hasReceiver
  ) {
    traitQualifier = [trait, TypeOption::none_()] and
    hasReceiver = [isMethod, false]
  }

  bindingset[implType, trait, isMethod]
  private predicate callCheck(
    TypeOption implType, TypeOption trait, Boolean isMethod, TypeOption typeQualifier,
    TypeOption traitQualifier, boolean hasReceiver
  ) {
    callTypeQualifierCheck(implType, typeQualifier) and
    callTraitQualifierAndReceiverCheck(trait, isMethod, traitQualifier, hasReceiver)
  }

  pragma[nomagic]
  private predicate assocFunctionInfoNonBlanketLikeCheck(
    Function f, string name, int arity, FunctionPosition selfPos, ImplOrTraitItemNode i,
    AssocFunctionType selfType, TypePath strippedTypePath, Type strippedType,
    TypeOption typeQualifier, TypeOption traitQualifier, boolean hasReceiver
  ) {
    exists(TypeOption implType, TypeOption trait, boolean isMethod |
      assocFunctionInfo(f, name, arity, selfPos, i, selfType, strippedTypePath, strippedType,
        implType, trait, isMethod) and
      not BlanketImplementation::isBlanketLike(i, _, _) and
      callCheck(implType, trait, isMethod, typeQualifier, traitQualifier, hasReceiver)
    )
  }

  pragma[nomagic]
  private predicate assocFunctionInfoNonBlanketLikeTypeParamCheck(
    Function f, string name, int arity, FunctionPosition selfPos, ImplOrTraitItemNode i,
    AssocFunctionType selfType, TypePath strippedTypePath, TypeOption typeQualifier,
    TypeOption traitQualifier, boolean hasReceiver
  ) {
    assocFunctionInfoNonBlanketLikeCheck(f, name, arity, selfPos, i, selfType, strippedTypePath,
      TTypeParamTypeParameter(_), typeQualifier, traitQualifier, hasReceiver)
  }

  /**
   * Holds if call `afc` may target function `f` in `i` with type `selfType` at
   * function-call adjusted position `selfPos`.
   *
   * `strippedTypePath` points to the type `strippedType` inside `selfType`,
   * which is the (possibly complex-stripped) root type of `selfType`.
   */
  bindingset[afc, strippedTypePath, strippedType]
  pragma[inline_late]
  private predicate nonBlanketLikeCandidate(
    AssocFunctionCall afc, Function f, FunctionPosition selfPos, ImplOrTraitItemNode i,
    AssocFunctionType selfType, TypePath strippedTypePath, Type strippedType
  ) {
    exists(
      string name, int arity, TypeOption typeQualifier, TypeOption traitQualifier,
      boolean hasReceiver
    |
      afc.hasSyntacticInfo(name, arity, typeQualifier, traitQualifier, hasReceiver) and
      if not afc.hasATrait() and i.(Impl).hasTrait()
      then callVisibleImplTraitCandidate(afc, i)
      else any()
    |
      assocFunctionInfoNonBlanketLikeCheck(f, name, arity, selfPos, i, selfType, strippedTypePath,
        strippedType, typeQualifier, traitQualifier, hasReceiver)
      or
      assocFunctionInfoNonBlanketLikeTypeParamCheck(f, name, arity, selfPos, i, selfType,
        strippedTypePath, typeQualifier, traitQualifier, hasReceiver)
    )
  }

  bindingset[name, arity, typeQualifier, traitQualifier, hasReceiver]
  pragma[inline_late]
  private predicate assocFunctionInfoBlanketLikeCheck(
    Function f, string name, int arity, FunctionPosition selfPos, ImplItemNode impl,
    AssocFunctionType selfType, TypePath blanketPath, TypeParam blanketTypeParam,
    TypeOption typeQualifier, TypeOption traitQualifier, boolean hasReceiver
  ) {
    exists(TypeOption implType, TypeOption trait, boolean isMethod |
      assocFunctionInfoBlanketLike(f, name, arity, impl, implType, trait, selfPos, selfType,
        blanketPath, blanketTypeParam, isMethod) and
      callTraitQualifierAndReceiverCheck(trait, isMethod, traitQualifier, hasReceiver) and
      if impl.isBlanketImplementation()
      then any()
      else callTypeQualifierCheck(implType, typeQualifier)
    )
  }

  /**
   * Holds if call `afc` may target function `f` in blanket (like) implementation
   * `impl` with type `selfType` at function-call adjusted position `selfPos`.
   *
   * `blanketPath` points to the type `blanketTypeParam` inside `selfType`, which
   * is the type parameter used in the blanket implementation.
   */
  bindingset[afc]
  pragma[inline_late]
  private predicate blanketLikeCandidate(
    AssocFunctionCall afc, Function f, FunctionPosition selfPos, ImplItemNode impl,
    AssocFunctionType self, TypePath blanketPath, TypeParam blanketTypeParam
  ) {
    exists(
      string name, int arity, TypeOption typeQualifier, TypeOption traitQualifier,
      boolean hasReceiver
    |
      afc.hasSyntacticInfo(name, arity, typeQualifier, traitQualifier, hasReceiver) and
      assocFunctionInfoBlanketLikeCheck(f, name, arity, selfPos, impl, self, blanketPath,
        blanketTypeParam, typeQualifier, traitQualifier, hasReceiver)
    |
      if not afc.hasATrait() then callVisibleImplTraitCandidate(afc, impl) else any()
    )
  }

  /**
   * A (potential) call to an associated function.
   *
   * This is either:
   *
   * 1. `MethodCallExprAssocFunctionCall`: a method call, `x.m()`;
   * 2. `IndexExprAssocFunctionCall`: an index expression, `x[i]`, which is [syntactic sugar][1]
   *    for `*x.index(i)`;
   * 3. `CallExprAssocFunctionCall`: a qualified function call, `Q::f(x)`; or
   * 4. `OperationAssocFunctionCall`: an operation expression, `x + y`, which is syntactic sugar
   *    for `Add::add(x, y)`.
   * 5. `DynamicAssocFunctionCall`: a call to a closure, `c(x)`, which is syntactic sugar for
   *    `c.call_once(x)`, `c.call_mut(x)`, or `c.call(x)`.
   *
   * Note that only in case 1 and 2 is auto-dereferencing and borrowing allowed.
   *
   * Note also that only case 3 is a _potential_ call; in all other cases, we are guaranteed that
   * the target is an associated function (in fact, a method).
   *
   * [1]: https://doc.rust-lang.org/std/ops/trait.Index.html
   */
  abstract class AssocFunctionCall extends Expr {
    /**
     * Holds if this call targets a function named `name` with `arity` parameters
     * (including `self`).
     */
    pragma[nomagic]
    abstract predicate hasNameAndArity(string name, int arity);

    abstract AstNode getNonReturnNodeAt(FunctionPosition pos);

    AstNode getNodeAt(FunctionPosition pos) {
      result = this.getNonReturnNodeAt(pos)
      or
      result = this and pos.isReturn()
    }

    /** Holds if this call has a receiver and hence must target a method. */
    abstract predicate hasReceiver();

    abstract predicate supportsAutoDerefAndBorrow();

    /** Gets the trait targeted by this call, if any. */
    abstract Trait getTrait();

    /** Holds if this call targets a trait. */
    predicate hasTrait() { exists(this.getTrait()) }

    Trait getATrait() {
      result = this.getTrait()
      or
      result = getALookupTrait(this, getCallExprTypeQualifier(this, TypePath::nil(), _))
    }

    predicate hasATrait() { exists(this.getATrait()) }

    private Type getNonTypeParameterTypeQualifier() {
      result = getCallExprTypeQualifier(this, TypePath::nil(), _) and
      not result instanceof TypeParameter
    }

    /**
     * Holds if this call has the given purely syntactic information, that is,
     * information that does not rely on type inference.
     */
    pragma[nomagic]
    predicate hasSyntacticInfo(
      string name, int arity, TypeOption typeQualifier, TypeOption traitQualifier,
      boolean hasReceiver
    ) {
      this.hasNameAndArity(name, arity) and
      (if this.hasReceiver() then hasReceiver = true else hasReceiver = false) and
      (
        typeQualifier.asSome() = this.getNonTypeParameterTypeQualifier()
        or
        not exists(this.getNonTypeParameterTypeQualifier()) and
        typeQualifier.isNone()
      ) and
      (
        traitQualifier.asSome() = TTrait(this.getATrait())
        or
        not this.hasATrait() and
        traitQualifier.isNone()
      )
    }

    Type getTypeAt(FunctionPosition pos, TypePath path) {
      result = inferType(this.getNodeAt(pos), path)
    }

    /**
     * Holds if `selfPos` is a potentially relevant function-call adjusted position
     * for resolving this call.
     *
     * Only holds when we don't know for sure that the target is a method (in those
     * cases we rely on the receiver only).
     */
    pragma[nomagic]
    private predicate isRelevantSelfPos(FunctionPosition selfPos) {
      not this.hasReceiver() and
      exists(TypePath strippedTypePath, Type strippedType |
        strippedType = substituteLookupTraits(this, this.getTypeAt(selfPos, strippedTypePath)) and
        strippedType != TNeverType() and
        strippedType != TUnknownType()
      |
        nonBlanketLikeCandidate(this, _, selfPos, _, _, strippedTypePath, strippedType)
        or
        blanketLikeCandidate(this, _, selfPos, _, _, strippedTypePath, _)
      )
    }

    predicate hasReceiverAtPos(FunctionPosition pos) { this.hasReceiver() and pos.asPosition() = 0 }

    pragma[nomagic]
    private predicate hasIncompatibleArgsTarget(
      ImplOrTraitItemNode i, FunctionPosition selfPos, DerefChain derefChain, BorrowKind borrow,
      AssocFunctionType selfType
    ) {
      SelfArgIsInstantiationOf::argIsInstantiationOf(this, i, selfPos, derefChain, borrow, selfType) and
      OverloadedCallArgsAreInstantiationsOf::argsAreNotInstantiationsOf(this, i)
    }

    /**
     * Holds if the function inside `i` with matching name and arity can be ruled
     * out as a target of this call, because the candidate receiver type represented
     * by `derefChain` and `borrow` is incompatible with the type at function-call
     * adjusted position `selfPos`.
     *
     * The types are incompatible because they disagree on a concrete type somewhere
     * inside `root`.
     */
    pragma[nomagic]
    predicate hasIncompatibleTarget(
      ImplOrTraitItemNode i, FunctionPosition selfPos, DerefChain derefChain, BorrowKind borrow,
      Type root
    ) {
      exists(AssocFunctionType selfType | root = selfType.getTypeAt(TypePath::nil()) |
        this.hasIncompatibleArgsTarget(i, selfPos, derefChain, borrow, selfType)
        or
        SelfArgIsInstantiationOf::argIsNotInstantiationOf(this, i, selfPos, derefChain, borrow,
          selfType)
      )
    }

    /**
     * Holds if the function inside blanket-like implementation `impl` with matching name
     * and arity can be ruled out as a target of this call, either because the candidate
     * receiver type represented by `derefChain` and `borrow` is incompatible with the type
     * at function-call adjusted position `selfPos`, or because the blanket constraint
     * is not satisfied.
     */
    pragma[nomagic]
    predicate hasIncompatibleBlanketLikeTarget(
      ImplItemNode impl, FunctionPosition selfPos, DerefChain derefChain, BorrowKind borrow
    ) {
      SelfArgIsNotInstantiationOfBlanketLike::argIsNotInstantiationOf(MkAssocFunctionCallCand(this,
          selfPos, derefChain, borrow), impl, _, _)
      or
      ArgSatisfiesBlanketLikeConstraint::dissatisfiesBlanketConstraint(MkAssocFunctionCallCand(this,
          selfPos, derefChain, borrow), impl)
    }

    pragma[nomagic]
    private predicate hasNoInherentTargetCheck(
      FunctionPosition selfPos, DerefChain derefChain, BorrowKind borrow
    ) {
      MkAssocFunctionCallCand(this, selfPos, derefChain, borrow)
          .(AssocFunctionCallCand)
          .hasNoInherentTargetCheck()
    }

    pragma[nomagic]
    private predicate hasNoInherentTargetTypeQualifierCheck() {
      exists(FunctionPosition typeQualifierPos |
        typeQualifierPos.isTypeQualifier() and
        this.hasNoInherentTargetCheck(typeQualifierPos, DerefChain::nil(), TNoBorrowKind())
      )
    }

    pragma[nomagic]
    predicate hasNoInherentTarget(FunctionPosition selfPos, DerefChain derefChain, BorrowKind borrow) {
      this.hasNoInherentTargetCheck(selfPos, derefChain, borrow) and
      if exists(this.getNonTypeParameterTypeQualifier()) and not selfPos.isTypeQualifier()
      then
        // If this call is of the form `Foo::bar(x)` and we are resolving with respect to the type
        // of `x`, then we additionally need to check that the type qualifier does not give rise
        // to an inherent target
        this.hasNoInherentTargetTypeQualifierCheck()
      else any()
    }

    /**
     * Same as `getSelfTypeAt`, but excludes pseudo types `!` and `unknown`.
     */
    pragma[nomagic]
    Type getANonPseudoSelfTypeAt(
      FunctionPosition selfPos, DerefChain derefChain, BorrowKind borrow, TypePath path
    ) {
      result = this.getSelfTypeAt(selfPos, derefChain, borrow, path) and
      result != TNeverType() and
      result != TUnknownType()
    }

    pragma[nomagic]
    Type getComplexStrippedSelfType(
      FunctionPosition selfPos, DerefChain derefChain, BorrowKind borrow, TypePath strippedTypePath
    ) {
      result = this.getANonPseudoSelfTypeAt(selfPos, derefChain, borrow, strippedTypePath) and
      (
        isComplexRootStripped(strippedTypePath, result)
        or
        selfPos.isTypeQualifier() and strippedTypePath.isEmpty()
      )
    }

    /**
     * Holds if the candidate receiver type represented by `derefChain` and `borrow`
     * does not have a matching call target at function-call adjusted position `selfPos`.
     */
    predicate hasNoCompatibleTarget(
      FunctionPosition selfPos, DerefChain derefChain, BorrowKind borrow
    ) {
      NoCompatibleTarget::hasNoCompatibleTarget(this, selfPos, derefChain, borrow)
    }

    /**
     * Holds if the candidate receiver type represented by `derefChain` and `borrow`
     * does not have a matching non-blanket call target at function-call adjusted
     * position `selfPos`.
     */
    predicate hasNoCompatibleNonBlanketTarget(
      FunctionPosition selfPos, DerefChain derefChain, BorrowKind borrow
    ) {
      NoCompatibleTarget::hasNoCompatibleNonBlanketTarget(this, selfPos, derefChain, borrow)
    }

    /**
     * Same as `getSelfTypeAt`, but without borrows.
     */
    pragma[nomagic]
    Type getSelfTypeAtNoBorrow(FunctionPosition selfPos, DerefChain derefChain, TypePath path) {
      result = this.getTypeAt(selfPos, path) and
      derefChain.isEmpty() and
      (
        this.hasReceiverAtPos(selfPos)
        or
        selfPos.isTypeQualifier()
        or
        this.isRelevantSelfPos(selfPos)
      )
      or
      exists(DerefImplItemNode impl, DerefChain suffix |
        result =
          ImplicitDeref::getDereferencedCandidateReceiverType(this, selfPos, impl, suffix, path) and
        derefChain = DerefChain::cons(impl, suffix)
      )
    }

    /**
     * Holds if this call may have an implicit borrow of kind `borrow` at
     * function-call adjusted position `selfPos` with the given `derefChain`.
     */
    pragma[nomagic]
    predicate hasImplicitBorrowCand(
      FunctionPosition selfPos, DerefChain derefChain, BorrowKind borrow
    ) {
      exists(BorrowKind prev | this.hasNoCompatibleTarget(selfPos, derefChain, prev) |
        // first try shared borrow
        prev.isNoBorrow() and
        borrow.isSharedBorrow()
        or
        // then try mutable borrow
        prev.isSharedBorrow() and
        borrow.isMutableBorrow()
      )
    }

    /**
     * Gets the type of this call at function-call adjusted position `selfPos` and
     * type path `path`.
     *
     * In case this call supports auto-dereferencing and borrowing and `selfPos` is
     * position 0 (corresponding to the receiver), the result is a
     * [candidate receiver type][1]:
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
    Type getSelfTypeAt(
      FunctionPosition selfPos, DerefChain derefChain, BorrowKind borrow, TypePath path
    ) {
      result = this.getSelfTypeAtNoBorrow(selfPos, derefChain, path) and
      borrow.isNoBorrow()
      or
      exists(RefType rt |
        this.hasImplicitBorrowCand(selfPos, derefChain, borrow) and
        rt = borrow.getRefType()
      |
        path.isEmpty() and
        result = rt
        or
        exists(TypePath suffix |
          result = this.getSelfTypeAtNoBorrow(selfPos, derefChain, suffix) and
          path = TypePath::cons(rt.getPositionalTypeParameter(0), suffix)
        )
      )
    }

    /**
     * Gets a function that this call resolves to after having applied a sequence of
     * dereferences and possibly a borrow on the receiver type at `selfPos`, encoded
     * in `derefChain` and `borrow`.
     */
    pragma[nomagic]
    AssocFunctionDeclaration resolveCallTarget(
      ImplOrTraitItemNode i, FunctionPosition selfPos, DerefChain derefChain, BorrowKind borrow
    ) {
      exists(AssocFunctionCallCand afcc |
        afcc = MkAssocFunctionCallCand(this, selfPos, derefChain, borrow) and
        result = afcc.resolveCallTarget(i)
      )
    }

    /**
     * Holds if the argument `arg` of this call has been implicitly dereferenced
     * and borrowed according to `derefChain` and `borrow`, in order to be able to
     * resolve the call target.
     */
    predicate argumentHasImplicitDerefChainBorrow(Expr arg, DerefChain derefChain, BorrowKind borrow) {
      exists(FunctionPosition selfAdj |
        this.hasReceiverAtPos(selfAdj) and
        exists(this.resolveCallTarget(_, selfAdj, derefChain, borrow)) and
        arg = this.getNodeAt(selfAdj) and
        not (derefChain.isEmpty() and borrow.isNoBorrow())
      )
    }
  }

  private class MethodCallExprAssocFunctionCall extends AssocFunctionCall instanceof MethodCallExpr {
    override predicate hasNameAndArity(string name, int arity) {
      name = super.getIdentifier().getText() and
      arity = super.getNumberOfSyntacticArguments()
    }

    override predicate hasReceiver() { any() }

    override Expr getNonReturnNodeAt(FunctionPosition pos) {
      result = super.getReceiver() and
      pos.asPosition() = 0
      or
      result = super.getPositionalArgument(pos.asPosition() - 1)
    }

    override predicate supportsAutoDerefAndBorrow() { any() }

    override Trait getTrait() { none() }
  }

  private class IndexExprAssocFunctionCall extends AssocFunctionCall, IndexExpr {
    private predicate isInMutableContext() {
      // todo: does not handle all cases yet
      VariableImpl::assignmentOperationDescendant(_, this)
    }

    override predicate hasNameAndArity(string name, int arity) {
      (if this.isInMutableContext() then name = "index_mut" else name = "index") and
      arity = 2
    }

    override predicate hasReceiver() { any() }

    override Expr getNonReturnNodeAt(FunctionPosition pos) {
      pos.asPosition() = 0 and
      result = this.getBase()
      or
      pos.asPosition() = 1 and
      result = this.getIndex()
    }

    override predicate supportsAutoDerefAndBorrow() { any() }

    override Trait getTrait() {
      if this.isInMutableContext()
      then result instanceof IndexMutTrait
      else result instanceof IndexTrait
    }
  }

  private class CallExprAssocFunctionCall extends AssocFunctionCall, CallExpr {
    CallExprAssocFunctionCall() {
      exists(getCallExprPathQualifier(this)) and
      // even if a target cannot be resolved by path resolution, it may still
      // be possible to resolve a blanket implementation (so not `forex`)
      forall(ItemNode i | i = CallExprImpl::getResolvedFunction(this) |
        i instanceof AssocFunctionDeclaration
      )
    }

    override predicate hasNameAndArity(string name, int arity) {
      name = CallExprImpl::getFunctionPath(this).getText() and
      arity = this.getNumberOfSyntacticArguments()
    }

    override predicate hasReceiver() { none() }

    override Expr getNonReturnNodeAt(FunctionPosition pos) {
      result = this.getSyntacticPositionalArgument(pos.asPosition())
    }

    override Type getTypeAt(FunctionPosition pos, TypePath path) {
      result = super.getTypeAt(pos, path)
      or
      pos.isTypeQualifier() and
      result = getCallExprTypeQualifier(this, path, _)
    }

    override predicate supportsAutoDerefAndBorrow() { none() }

    override Trait getTrait() { result = getCallExprTraitQualifier(this) }
  }

  final class OperationAssocFunctionCall extends AssocFunctionCall, Operation {
    override predicate hasNameAndArity(string name, int arity) {
      this.isOverloaded(_, name, _) and
      arity = this.getNumberOfOperands()
    }

    override predicate hasReceiver() { any() }

    override Expr getNonReturnNodeAt(FunctionPosition pos) {
      result = this.getOperand(pos.asPosition())
    }

    private predicate implicitBorrowAt(FunctionPosition pos, boolean isMutable) {
      exists(int borrows | this.isOverloaded(_, _, borrows) |
        pos.asPosition() = 0 and
        borrows >= 1 and
        if this instanceof CompoundAssignmentExpr then isMutable = true else isMutable = false
        or
        pos.asPosition() = 1 and
        borrows = 2 and
        isMutable = false
      )
    }

    override Type getTypeAt(FunctionPosition pos, TypePath path) {
      exists(boolean isMutable, RefType rt |
        this.implicitBorrowAt(pos, isMutable) and
        rt = getRefType(isMutable)
      |
        result = rt and
        path.isEmpty()
        or
        exists(TypePath path0 |
          result = inferType(this.getNodeAt(pos), path0) and
          path = TypePath::cons(rt.getPositionalTypeParameter(0), path0)
        )
      )
      or
      not this.implicitBorrowAt(pos, _) and
      result = inferType(this.getNodeAt(pos), path)
    }

    override predicate argumentHasImplicitDerefChainBorrow(
      Expr arg, DerefChain derefChain, BorrowKind borrow
    ) {
      exists(FunctionPosition pos, boolean isMutable |
        this.implicitBorrowAt(pos, isMutable) and
        arg = this.getNodeAt(pos) and
        derefChain = DerefChain::nil() and
        borrow = TSomeBorrowKind(isMutable)
      )
    }

    override predicate supportsAutoDerefAndBorrow() { none() }

    override Trait getTrait() { this.isOverloaded(result, _, _) }
  }

  private class DynamicAssocFunctionCall extends AssocFunctionCall instanceof CallExprImpl::DynamicCallExpr
  {
    pragma[nomagic]
    override predicate hasNameAndArity(string name, int arity) {
      name = "call_once" and // todo: handle call_mut and call
      arity = 2 // args are passed in a tuple
    }

    override predicate hasReceiver() { any() }

    override AstNode getNonReturnNodeAt(FunctionPosition pos) {
      pos.asPosition() = 0 and
      result = super.getFunction()
      or
      pos.asPosition() = 1 and
      result = super.getArgList()
    }

    override predicate supportsAutoDerefAndBorrow() { any() }

    override Trait getTrait() { result instanceof AnyFnTrait }
  }

  /**
   * Provides logic for efficiently checking that there are no compatible call
   * targets for a given candidate receiver type.
   *
   * For calls with non-blanket target candidates, we need to check:
   *
   * ```text
   * forall types `t` where `t` is a lookup type for the given candidate receiver type:
   *   forall non-blanket candidates `c` matching `t`:
   *     check that `c` is not a compatible target
   * ```
   *
   * Instead of implementing the above using `forall`, we apply the standard trick
   * of using ranked recursion.
   */
  private module NoCompatibleTarget {
    private import codeql.rust.elements.internal.generated.Raw
    private import codeql.rust.elements.internal.generated.Synth

    private class RawImplOrTrait = @impl or @trait;

    private predicate id(RawImplOrTrait x, RawImplOrTrait y) { x = y }

    private predicate idOfRaw(RawImplOrTrait x, int y) = equivalenceRelation(id/2)(x, y)

    private int idOfImplOrTraitItemNode(ImplOrTraitItemNode i) {
      idOfRaw(Synth::convertAstNodeToRaw(i), result)
    }

    /**
     * Holds if `t` is the `n`th lookup type for the candidate receiver type
     * represented by `derefChain` and `borrow` at function-call adjusted position
     * `selfPos` of `afc`.
     *
     * There are no compatible non-blanket-like candidates for lookup types `0` to `n - 1`.
     */
    pragma[nomagic]
    private predicate noCompatibleNonBlanketLikeTargetCandNthLookupType(
      AssocFunctionCall afc, FunctionPosition selfPos, DerefChain derefChain, BorrowKind borrow,
      TypePath strippedTypePath, Type strippedType, int n, Type t
    ) {
      (
        (
          (
            afc.supportsAutoDerefAndBorrow() and
            afc.hasReceiverAtPos(selfPos)
            or
            // needed for the `hasNoCompatibleNonBlanketTarget` check in
            // `ArgSatisfiesBlanketLikeConstraintInput::hasBlanketCandidate`
            exists(ImplItemNode i |
              derefChain.isEmpty() and
              blanketLikeCandidate(afc, _, selfPos, i, _, _, _) and
              i.isBlanketImplementation()
            )
          ) and
          borrow.isNoBorrow()
          or
          afc.hasImplicitBorrowCand(selfPos, derefChain, borrow)
        ) and
        strippedType = afc.getComplexStrippedSelfType(selfPos, derefChain, borrow, strippedTypePath) and
        n = 0
        or
        hasNoCompatibleNonBlanketLikeTargetForNthLookupType(afc, selfPos, derefChain, borrow,
          strippedTypePath, strippedType, n - 1)
      ) and
      t = getNthLookupType(afc, strippedType, n)
    }

    pragma[nomagic]
    private ImplOrTraitItemNode getKthNonBlanketLikeCandidateForNthLookupType(
      AssocFunctionCall afc, FunctionPosition selfPos, DerefChain derefChain, BorrowKind borrow,
      TypePath strippedTypePath, Type strippedType, int n, Type t, int k
    ) {
      noCompatibleNonBlanketLikeTargetCandNthLookupType(afc, selfPos, derefChain, borrow,
        strippedTypePath, strippedType, n, t) and
      result =
        rank[k + 1](ImplOrTraitItemNode i, int id |
          nonBlanketLikeCandidate(afc, _, selfPos, i, _, strippedTypePath, t) and
          id = idOfImplOrTraitItemNode(i)
        |
          i order by id
        )
    }

    pragma[nomagic]
    private int getLastNonBlanketLikeCandidateForNthLookupType(
      AssocFunctionCall afc, FunctionPosition selfPos, DerefChain derefChain, BorrowKind borrow,
      TypePath strippedTypePath, Type strippedType, int n
    ) {
      exists(Type t |
        noCompatibleNonBlanketLikeTargetCandNthLookupType(afc, selfPos, derefChain, borrow,
          strippedTypePath, strippedType, n, t) and
        result =
          count(ImplOrTraitItemNode i |
              nonBlanketLikeCandidate(afc, _, selfPos, i, _, strippedTypePath, t)
            ) - 1
      )
    }

    pragma[nomagic]
    private predicate hasNoCompatibleNonBlanketLikeTargetForNthLookupTypeToIndex(
      AssocFunctionCall afc, FunctionPosition selfPos, DerefChain derefChain, BorrowKind borrow,
      TypePath strippedTypePath, Type strippedType, int n, int k
    ) {
      exists(Type t |
        noCompatibleNonBlanketLikeTargetCandNthLookupType(afc, selfPos, derefChain, borrow,
          strippedTypePath, strippedType, n, t)
      |
        k = -1
        or
        hasNoCompatibleNonBlanketLikeTargetForNthLookupTypeToIndex(afc, selfPos, derefChain, borrow,
          strippedTypePath, strippedType, n, k - 1) and
        exists(ImplOrTraitItemNode i |
          i =
            getKthNonBlanketLikeCandidateForNthLookupType(afc, selfPos, derefChain, borrow,
              strippedTypePath, strippedType, n, t, k) and
          afc.hasIncompatibleTarget(i, selfPos, derefChain, borrow, t)
        )
      )
    }

    pragma[nomagic]
    private predicate hasNoCompatibleNonBlanketLikeTargetForNthLookupType(
      AssocFunctionCall afc, FunctionPosition selfPos, DerefChain derefChain, BorrowKind borrow,
      TypePath strippedTypePath, Type strippedType, int n
    ) {
      exists(int last |
        last =
          getLastNonBlanketLikeCandidateForNthLookupType(afc, selfPos, derefChain, borrow,
            strippedTypePath, strippedType, n) and
        hasNoCompatibleNonBlanketLikeTargetForNthLookupTypeToIndex(afc, selfPos, derefChain, borrow,
          strippedTypePath, strippedType, n, last)
      )
    }

    pragma[nomagic]
    private predicate hasNoCompatibleNonBlanketLikeTarget(
      AssocFunctionCall afc, FunctionPosition selfPos, DerefChain derefChain, BorrowKind borrow
    ) {
      exists(Type strippedType |
        hasNoCompatibleNonBlanketLikeTargetForNthLookupType(afc, selfPos, derefChain, borrow, _,
          strippedType, getLastLookupTypeIndex(afc, strippedType))
      )
    }

    pragma[nomagic]
    predicate hasNoCompatibleTarget(
      AssocFunctionCall afc, FunctionPosition selfPos, DerefChain derefChain, BorrowKind borrow
    ) {
      hasNoCompatibleNonBlanketLikeTarget(afc, selfPos, derefChain, borrow) and
      // todo: replace with ranked recursion if needed
      forall(ImplItemNode i | blanketLikeCandidate(afc, _, selfPos, i, _, _, _) |
        afc.hasIncompatibleBlanketLikeTarget(i, selfPos, derefChain, borrow)
      )
    }

    pragma[nomagic]
    predicate hasNoCompatibleNonBlanketTarget(
      AssocFunctionCall afc, FunctionPosition selfPos, DerefChain derefChain, BorrowKind borrow
    ) {
      hasNoCompatibleNonBlanketLikeTarget(afc, selfPos, derefChain, borrow) and
      // todo: replace with ranked recursion if needed
      forall(ImplItemNode i |
        blanketLikeCandidate(afc, _, selfPos, i, _, _, _) and
        not i.isBlanketImplementation()
      |
        afc.hasIncompatibleBlanketLikeTarget(i, selfPos, derefChain, borrow)
      )
    }
  }

  pragma[nomagic]
  private AssocFunctionDeclaration getAssocFunctionSuccessor(
    ImplOrTraitItemNode i, string name, int arity
  ) {
    result = i.getASuccessor(name) and
    arity = result.getNumberOfParamsInclSelf()
  }

  private newtype TAssocFunctionCallCand =
    MkAssocFunctionCallCand(
      AssocFunctionCall afc, FunctionPosition selfPos, DerefChain derefChain, BorrowKind borrow
    ) {
      exists(afc.getANonPseudoSelfTypeAt(selfPos, derefChain, borrow, _))
    }

  /** A call with a dereference chain and a potential borrow at a given position. */
  final private class AssocFunctionCallCand extends MkAssocFunctionCallCand {
    AssocFunctionCall afc_;
    FunctionPosition selfPos_;
    DerefChain derefChain;
    BorrowKind borrow;

    AssocFunctionCallCand() { this = MkAssocFunctionCallCand(afc_, selfPos_, derefChain, borrow) }

    AssocFunctionCall getAssocFunctionCall() { result = afc_ }

    ItemNode getEnclosingItemNode() { result.getADescendant() = afc_ }

    Type getTypeAt(TypePath path) {
      result =
        substituteLookupTraits(afc_,
          afc_.getANonPseudoSelfTypeAt(selfPos_, derefChain, borrow, path))
    }

    pragma[nomagic]
    predicate hasNoCompatibleNonBlanketTarget() {
      afc_.hasNoCompatibleNonBlanketTarget(selfPos_, derefChain, borrow)
    }

    pragma[nomagic]
    predicate hasSignature(
      AssocFunctionCall afc, FunctionPosition selfPos, TypePath strippedTypePath, Type strippedType,
      string name, int arity
    ) {
      strippedType = this.getTypeAt(strippedTypePath) and
      (
        isComplexRootStripped(strippedTypePath, strippedType)
        or
        selfPos_.isTypeQualifier() and strippedTypePath.isEmpty()
      ) and
      afc = afc_ and
      afc.hasNameAndArity(name, arity) and
      selfPos = selfPos_
    }

    /**
     * Holds if the inherent function inside `impl` with matching name and arity can be
     * ruled out as a candidate for this call.
     */
    pragma[nomagic]
    private predicate hasIncompatibleInherentTarget(Impl impl) {
      SelfArgIsNotInstantiationOfInherent::argIsNotInstantiationOf(this, impl, _, _)
    }

    pragma[nomagic]
    predicate hasNoInherentTargetCheck() {
      exists(
        TypePath strippedTypePath, Type strippedType, string name, int arity,
        TypeOption typeQualifier, TypeOption traitQualifier, boolean hasReceiver,
        boolean targetMustBeMethod
      |
        // Calls to inherent functions are always of the form `x.m(...)` or `Foo::bar(...)`,
        // where `Foo` is a type. In case `bar` is a method, we can use both the type qualifier
        // and the type of the first argument to rule out candidates
        selfPos_.isTypeQualifier() and targetMustBeMethod = false
        or
        selfPos_.asPosition() = 0 and targetMustBeMethod = true
      |
        afc_.hasSyntacticInfo(name, arity, typeQualifier, traitQualifier, hasReceiver) and
        (if hasReceiver = true then targetMustBeMethod = true else any()) and
        this.hasSignature(_, selfPos_, strippedTypePath, strippedType, name, arity) and
        forall(Impl i |
          i.isInherent() and
          (
            assocFunctionInfoNonBlanketLikeCheck(_, name, arity, selfPos_, i, _, strippedTypePath,
              strippedType, typeQualifier, traitQualifier, targetMustBeMethod)
            or
            assocFunctionInfoNonBlanketLikeTypeParamCheck(_, name, arity, selfPos_, i, _,
              strippedTypePath, typeQualifier, traitQualifier, targetMustBeMethod)
          )
        |
          this.hasIncompatibleInherentTarget(i)
        )
      )
    }

    /**
     * Holds if this function call has no inherent target, i.e., it does not
     * resolve to a function in an `impl` block for the type of the receiver.
     */
    pragma[nomagic]
    predicate hasNoInherentTarget() {
      afc_.hasTrait()
      or
      afc_.hasNoInherentTarget(selfPos_, derefChain, borrow)
    }

    pragma[nomagic]
    private predicate selfArgIsInstantiationOf(ImplOrTraitItemNode i, string name, int arity) {
      SelfArgIsInstantiationOf::argIsInstantiationOf(this, i, _) and
      afc_.hasNameAndArity(name, arity)
    }

    pragma[nomagic]
    AssocFunctionDeclaration resolveCallTargetCand(ImplOrTraitItemNode i) {
      exists(string name, int arity |
        this.selfArgIsInstantiationOf(i, name, arity) and
        result = getAssocFunctionSuccessor(i, name, arity)
      )
    }

    /** Gets the associated function targeted by this call, if any. */
    pragma[nomagic]
    AssocFunctionDeclaration resolveCallTarget(ImplOrTraitItemNode i) {
      result = this.resolveCallTargetCand(i) and
      not FunctionOverloading::functionResolutionDependsOnArgument(i, result, _, _)
      or
      OverloadedCallArgsAreInstantiationsOf::argsAreInstantiationsOf(this, i, result)
    }

    string toString() {
      result = afc_ + " at " + selfPos_ + " [" + derefChain.toString() + "; " + borrow + "]"
    }

    Location getLocation() { result = afc_.getLocation() }
  }

  /**
   * Provides logic for resolving implicit `Deref::deref` calls.
   */
  private module ImplicitDeref {
    private newtype TCallDerefCand =
      MkCallDerefCand(AssocFunctionCall afc, FunctionPosition selfPos, DerefChain derefChain) {
        afc.supportsAutoDerefAndBorrow() and
        afc.hasReceiverAtPos(selfPos) and
        afc.hasNoCompatibleTarget(selfPos, derefChain, TSomeBorrowKind(true)) and
        exists(afc.getSelfTypeAtNoBorrow(selfPos, derefChain, TypePath::nil()))
      }

    /** A call with a dereference chain. */
    private class CallDerefCand extends MkCallDerefCand {
      AssocFunctionCall afc;
      FunctionPosition selfPos;
      DerefChain derefChain;

      CallDerefCand() { this = MkCallDerefCand(afc, selfPos, derefChain) }

      Type getTypeAt(TypePath path) {
        result = substituteLookupTraits(afc, afc.getSelfTypeAtNoBorrow(selfPos, derefChain, path)) and
        result != TNeverType() and
        result != TUnknownType()
      }

      string toString() { result = afc + " [" + derefChain.toString() + "]" }

      Location getLocation() { result = afc.getLocation() }
    }

    private module CallSatisfiesDerefConstraintInput implements SatisfiesTypeInputSig<CallDerefCand>
    {
      pragma[nomagic]
      predicate relevantConstraint(CallDerefCand mc, Type constraint) {
        exists(mc) and
        constraint.(TraitType).getTrait() instanceof DerefTrait
      }
    }

    private module CallSatisfiesDerefConstraint =
      SatisfiesType<CallDerefCand, CallSatisfiesDerefConstraintInput>;

    pragma[nomagic]
    private AssociatedTypeTypeParameter getDerefTargetTypeParameter() {
      result.getTypeAlias() = any(DerefTrait ft).getTargetType()
    }

    /**
     * Gets the type of the receiver of `afc` at `path` after applying the implicit
     * dereference inside `impl`, following the existing dereference chain `derefChain`.
     */
    pragma[nomagic]
    Type getDereferencedCandidateReceiverType(
      AssocFunctionCall afc, FunctionPosition selfPos, DerefImplItemNode impl,
      DerefChain derefChain, TypePath path
    ) {
      exists(CallDerefCand cdc, TypePath exprPath |
        cdc = MkCallDerefCand(afc, selfPos, derefChain) and
        CallSatisfiesDerefConstraint::satisfiesConstraintThrough(cdc, impl, _, exprPath, result) and
        exprPath.isCons(getDerefTargetTypeParameter(), path)
      )
    }
  }

  private module ArgSatisfiesBlanketLikeConstraintInput implements
    BlanketImplementation::SatisfiesBlanketConstraintInputSig<AssocFunctionCallCand>
  {
    pragma[nomagic]
    predicate hasBlanketCandidate(
      AssocFunctionCallCand afcc, ImplItemNode impl, TypePath blanketPath,
      TypeParam blanketTypeParam
    ) {
      exists(AssocFunctionCall afc, FunctionPosition selfPos, BorrowKind borrow |
        afcc = MkAssocFunctionCallCand(afc, selfPos, _, borrow) and
        blanketLikeCandidate(afc, _, selfPos, impl, _, blanketPath, blanketTypeParam) and
        // Only apply blanket implementations when no other implementations are possible;
        // this is to account for codebases that use the (unstable) specialization feature
        // (https://rust-lang.github.io/rfcs/1210-impl-specialization.html), as well as
        // cases where our blanket implementation filtering is not precise enough.
        if impl.isBlanketImplementation() then afcc.hasNoCompatibleNonBlanketTarget() else any()
      )
    }
  }

  private module ArgSatisfiesBlanketLikeConstraint =
    BlanketImplementation::SatisfiesBlanketConstraint<AssocFunctionCallCand,
      ArgSatisfiesBlanketLikeConstraintInput>;

  /**
   * A configuration for matching the type of an argument against the type of
   * a function at a function-call adjusted position relevant for dispatch
   * (such as a `self` parameter).
   */
  private module SelfArgIsInstantiationOfInput implements
    IsInstantiationOfInputSig<AssocFunctionCallCand, AssocFunctionType>
  {
    pragma[nomagic]
    additional predicate potentialInstantiationOf0(
      AssocFunctionCallCand afcc, ImplOrTraitItemNode i, AssocFunctionType selfType
    ) {
      exists(
        AssocFunctionCall afc, FunctionPosition selfPos, Function f, TypePath strippedTypePath,
        Type strippedType
      |
        afcc.hasSignature(afc, selfPos, strippedTypePath, strippedType, _, _)
      |
        nonBlanketLikeCandidate(afc, f, selfPos, i, selfType, strippedTypePath, strippedType)
        or
        blanketLikeCandidate(afc, f, selfPos, i, selfType, _, _) and
        ArgSatisfiesBlanketLikeConstraint::satisfiesBlanketConstraint(afcc, i)
      )
    }

    pragma[nomagic]
    predicate potentialInstantiationOf(
      AssocFunctionCallCand afcc, TypeAbstraction abs, AssocFunctionType constraint
    ) {
      potentialInstantiationOf0(afcc, abs, constraint) and
      if abs.(Impl).hasTrait()
      then
        // inherent functions take precedence over trait functions, so only allow
        // trait functions when there are no matching inherent functions
        afcc.hasNoInherentTarget()
      else any()
    }

    predicate relevantConstraint(AssocFunctionType constraint) {
      assocFunctionInfo(_, _, _, _, _, constraint, _, _, _, _, _)
    }
  }

  private module SelfArgIsInstantiationOf {
    import ArgIsInstantiationOf<AssocFunctionCallCand, SelfArgIsInstantiationOfInput>

    pragma[nomagic]
    predicate argIsNotInstantiationOf(
      AssocFunctionCall afc, ImplOrTraitItemNode i, FunctionPosition selfPos, DerefChain derefChain,
      BorrowKind borrow, AssocFunctionType selfType
    ) {
      exists(TypePath path |
        argIsNotInstantiationOf(MkAssocFunctionCallCand(afc, selfPos, derefChain, borrow), i,
          selfType, path) and
        not path.isEmpty()
      )
    }

    pragma[nomagic]
    predicate argIsInstantiationOf(
      AssocFunctionCall afc, ImplOrTraitItemNode i, FunctionPosition selfPos, DerefChain derefChain,
      BorrowKind borrow, AssocFunctionType selfType
    ) {
      argIsInstantiationOf(MkAssocFunctionCallCand(afc, selfPos, derefChain, borrow), i, selfType)
    }
  }

  /**
   * A configuration for anti-matching the type of an argument against the type of
   * a function at a function-call adjusted position relevant for dispatch
   * (such as a `self` parameter) in a blanket (like) implementation.
   */
  private module SelfArgIsNotInstantiationOfBlanketLikeInput implements
    IsInstantiationOfInputSig<AssocFunctionCallCand, AssocFunctionType>
  {
    pragma[nomagic]
    predicate potentialInstantiationOf(
      AssocFunctionCallCand afcc, TypeAbstraction abs, AssocFunctionType constraint
    ) {
      exists(AssocFunctionCall afc, FunctionPosition selfPos |
        afcc = MkAssocFunctionCallCand(afc, selfPos, _, _) and
        blanketLikeCandidate(afc, _, selfPos, abs, constraint, _, _) and
        if abs.(Impl).hasTrait()
        then
          // inherent functions take precedence over trait functions, so only allow
          // trait functions when there are no matching inherent functions
          afcc.hasNoInherentTarget()
        else any()
      )
    }
  }

  private module SelfArgIsNotInstantiationOfBlanketLike =
    ArgIsInstantiationOf<AssocFunctionCallCand, SelfArgIsNotInstantiationOfBlanketLikeInput>;

  /**
   * A configuration for anti-matching the type of an argument against the type of
   * a function at a function-call adjusted position relevant for dispatch (such as
   * a `self` parameter) in an inherent function.
   */
  private module SelfArgIsNotInstantiationOfInherentInput implements
    IsInstantiationOfInputSig<AssocFunctionCallCand, AssocFunctionType>
  {
    pragma[nomagic]
    predicate potentialInstantiationOf(
      AssocFunctionCallCand afcc, TypeAbstraction abs, AssocFunctionType constraint
    ) {
      SelfArgIsInstantiationOfInput::potentialInstantiationOf0(afcc, abs, constraint) and
      abs.(Impl).isInherent() and
      exists(AssocFunctionCall afc, FunctionPosition selfPos |
        afcc = MkAssocFunctionCallCand(afc, selfPos, _, _)
      |
        selfPos.isTypeQualifier() or
        afc.hasReceiverAtPos(selfPos)
      )
    }
  }

  private module SelfArgIsNotInstantiationOfInherent =
    ArgIsInstantiationOf<AssocFunctionCallCand, SelfArgIsNotInstantiationOfInherentInput>;

  /**
   * A configuration for matching the types of positional arguments against the
   * types of parameters, when needed to disambiguate the call.
   */
  private module OverloadedCallArgsAreInstantiationsOfInput implements
    ArgsAreInstantiationsOfInputSig
  {
    predicate toCheck(ImplOrTraitItemNode i, Function f, TypeParameter traitTp, FunctionPosition pos) {
      FunctionOverloading::functionResolutionDependsOnArgument(i, f, traitTp, pos)
    }

    class Call extends AssocFunctionCallCand {
      Type getArgType(FunctionPosition pos, TypePath path) {
        result = this.getAssocFunctionCall().getTypeAt(pos, path)
      }

      predicate hasTargetCand(ImplOrTraitItemNode i, Function f) {
        f = this.resolveCallTargetCand(i)
      }
    }
  }

  private module OverloadedCallArgsAreInstantiationsOf {
    import ArgsAreInstantiationsOf<OverloadedCallArgsAreInstantiationsOfInput>

    pragma[nomagic]
    predicate argsAreNotInstantiationsOf(AssocFunctionCall afc, ImplOrTraitItemNode i) {
      argsAreNotInstantiationsOf(MkAssocFunctionCallCand(afc, _, _, _), i, _)
    }
  }
}

/**
 * A matching configuration for resolving types of function call expressions
 * like `foo.bar(baz)` and `Foo::bar(baz)`.
 */
private module FunctionCallMatchingInput implements MatchingWithEnvironmentInputSig {
  import FunctionPositionMatchingInput

  private newtype TDeclaration =
    TFunctionDeclaration(ImplOrTraitItemNodeOption i, FunctionDeclaration f) { f.isFor(i) }

  final class Declaration extends TFunctionDeclaration {
    ImplOrTraitItemNodeOption i;
    FunctionDeclaration f;

    Declaration() { this = TFunctionDeclaration(i, f) }

    FunctionDeclaration getFunction() { result = f }

    predicate isAssocFunction(ImplOrTraitItemNode i_, Function f_) {
      i_ = i.asSome() and
      f_ = f
    }

    TypeParameter getTypeParameter(TypeParameterPosition ppos) {
      result = f.getTypeParameter(i, ppos)
    }

    Type getDeclaredType(FunctionPosition pos, TypePath path) {
      result = f.getParameterType(i, pos, path)
      or
      pos.isReturn() and
      result = f.getReturnType(i, path)
    }

    string toString() {
      i.isNone() and result = f.toString()
      or
      result = f.toStringExt(i.asSome())
    }

    Location getLocation() { result = f.getLocation() }
  }

  pragma[nomagic]
  private TypeMention getAdditionalTypeParameterConstraint(TypeParameter tp, Declaration decl) {
    result =
      tp.(TypeParamTypeParameter)
          .getTypeParam()
          .getAdditionalTypeBound(decl.getFunction(), _)
          .getTypeRepr()
  }

  bindingset[decl]
  TypeMention getATypeParameterConstraint(TypeParameter tp, Declaration decl) {
    result = Input2::getATypeParameterConstraint(tp) and
    exists(decl)
    or
    result = getAdditionalTypeParameterConstraint(tp, decl)
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

  private string noDerefChainBorrow() {
    exists(DerefChain derefChain, BorrowKind borrow |
      derefChain.isEmpty() and
      borrow.isNoBorrow() and
      result = encodeDerefChainBorrow(derefChain, borrow)
    )
  }

  abstract class Access extends ContextTyping::ContextTypedCallCand {
    abstract AstNode getNodeAt(FunctionPosition pos);

    bindingset[derefChainBorrow]
    abstract Type getInferredType(string derefChainBorrow, FunctionPosition pos, TypePath path);

    abstract Declaration getTarget(string derefChainBorrow);

    /**
     * Holds if the return type of this call at `path` may have to be inferred
     * from the context.
     */
    abstract predicate hasUnknownTypeAt(string derefChainBorrow, FunctionPosition pos, TypePath path);
  }

  private class AssocFunctionCallAccess extends Access instanceof AssocFunctionResolution::AssocFunctionCall
  {
    AssocFunctionCallAccess() {
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

    override AstNode getNodeAt(FunctionPosition pos) {
      result = AssocFunctionResolution::AssocFunctionCall.super.getNodeAt(pos)
    }

    pragma[nomagic]
    private Type getInferredSelfType(FunctionPosition pos, string derefChainBorrow, TypePath path) {
      exists(DerefChain derefChain, BorrowKind borrow |
        result = super.getSelfTypeAt(pos, derefChain, borrow, path) and
        derefChainBorrow = encodeDerefChainBorrow(derefChain, borrow) and
        super.hasReceiverAtPos(pos)
      )
    }

    pragma[nomagic]
    private Type getInferredNonSelfType(FunctionPosition pos, TypePath path) {
      if
        // index expression `x[i]` desugars to `*x.index(i)`, so we must account for
        // the implicit deref
        pos.isReturn() and
        this instanceof IndexExpr
      then
        path.isEmpty() and
        result instanceof RefType
        or
        exists(TypePath suffix |
          result = super.getTypeAt(pos, suffix) and
          path = TypePath::cons(getRefTypeParameter(_), suffix)
        )
      else (
        not super.hasReceiverAtPos(pos) and
        result = super.getTypeAt(pos, path)
      )
    }

    bindingset[derefChainBorrow]
    override Type getInferredType(string derefChainBorrow, FunctionPosition pos, TypePath path) {
      result = this.getInferredSelfType(pos, derefChainBorrow, path)
      or
      result = this.getInferredNonSelfType(pos, path)
    }

    private AssocFunctionDeclaration getTarget(ImplOrTraitItemNode i, string derefChainBorrow) {
      exists(DerefChain derefChain, BorrowKind borrow |
        derefChainBorrow = encodeDerefChainBorrow(derefChain, borrow) and
        result = super.resolveCallTarget(i, _, derefChain, borrow) // mutual recursion; resolving method calls requires resolving types and vice versa
      )
    }

    override Declaration getTarget(string derefChainBorrow) {
      exists(ImplOrTraitItemNode i | result.isAssocFunction(i, this.getTarget(i, derefChainBorrow)))
    }

    pragma[nomagic]
    override predicate hasUnknownTypeAt(string derefChainBorrow, FunctionPosition pos, TypePath path) {
      exists(ImplOrTraitItemNode i |
        this.hasUnknownTypeAt(i, this.getTarget(i, derefChainBorrow), pos, path)
      )
      or
      derefChainBorrow = noDerefChainBorrow() and
      forex(ImplOrTraitItemNode i, Function f |
        f = CallExprImpl::getResolvedFunction(this) and
        f = i.getAnAssocItem()
      |
        this.hasUnknownTypeAt(i, f, pos, path)
      )
    }
  }

  private class NonAssocFunctionCallAccess extends Access instanceof NonAssocCallExpr,
    CallExprImpl::CallExprCall
  {
    pragma[nomagic]
    override Type getTypeArgument(TypeArgumentPosition apos, TypePath path) {
      result = NonAssocCallExpr.super.getTypeArgument(apos, path)
    }

    override AstNode getNodeAt(FunctionPosition pos) {
      result = NonAssocCallExpr.super.getNodeAt(pos)
    }

    pragma[nomagic]
    private Type getInferredType(FunctionPosition pos, TypePath path) {
      result = super.getInferredType(pos, path)
    }

    bindingset[derefChainBorrow]
    override Type getInferredType(string derefChainBorrow, FunctionPosition pos, TypePath path) {
      exists(derefChainBorrow) and
      result = this.getInferredType(pos, path)
    }

    pragma[nomagic]
    private Declaration getTarget() {
      result =
        TFunctionDeclaration(ImplOrTraitItemNodeOption::none_(),
          super.resolveCallTargetViaPathResolution())
    }

    override Declaration getTarget(string derefChainBorrow) {
      result = this.getTarget() and
      derefChainBorrow = noDerefChainBorrow()
    }

    pragma[nomagic]
    override predicate hasUnknownTypeAt(string derefChainBorrow, FunctionPosition pos, TypePath path) {
      derefChainBorrow = noDerefChainBorrow() and
      exists(FunctionDeclaration f, TypeParameter tp |
        f = super.resolveCallTargetViaPathResolution() and
        pos.isReturn() and
        tp = f.getReturnType(_, path) and
        not tp = f.getParameterType(_, _, _) and
        // check that no explicit type arguments have been supplied for `tp`
        not exists(TypeArgumentPosition tapos |
          this.hasTypeArgument(tapos) and
          TTypeParamTypeParameter(tapos.asTypeParam()) = tp
        )
      )
    }
  }
}

private module FunctionCallMatching = MatchingWithEnvironment<FunctionCallMatchingInput>;

pragma[nomagic]
private Type inferFunctionCallType0(
  FunctionCallMatchingInput::Access call, FunctionPosition pos, AstNode n, DerefChain derefChain,
  BorrowKind borrow, TypePath path
) {
  exists(TypePath path0 |
    n = call.getNodeAt(pos) and
    exists(string derefChainBorrow |
      FunctionCallMatchingInput::decodeDerefChainBorrow(derefChainBorrow, derefChain, borrow)
    |
      result = FunctionCallMatching::inferAccessType(call, derefChainBorrow, pos, path0)
      or
      call.hasUnknownTypeAt(derefChainBorrow, pos, path0) and
      result = TUnknownType()
    )
  |
    if
      // index expression `x[i]` desugars to `*x.index(i)`, so we must account for
      // the implicit deref
      pos.isReturn() and
      call instanceof IndexExpr
    then path0.isCons(getRefTypeParameter(_), path)
    else path = path0
  )
}

pragma[nomagic]
private Type inferFunctionCallTypeNonSelf(AstNode n, FunctionPosition pos, TypePath path) {
  exists(FunctionCallMatchingInput::Access call |
    result = inferFunctionCallType0(call, pos, n, _, _, path) and
    not call.(AssocFunctionResolution::AssocFunctionCall).hasReceiverAtPos(pos)
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
private Type inferFunctionCallTypeSelf(
  FunctionCallMatchingInput::Access call, AstNode n, DerefChain derefChain, TypePath path
) {
  exists(FunctionPosition pos, BorrowKind borrow, TypePath path0 |
    call.(AssocFunctionResolution::AssocFunctionCall).hasReceiverAtPos(pos) and
    result = inferFunctionCallType0(call, pos, n, derefChain, borrow, path0)
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
    t0 = inferFunctionCallTypeSelf(call, n, derefChain0, path0) and
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

private Type inferFunctionCallTypePreCheck(
  AstNode n, ContextTyping::FunctionPositionKind kind, TypePath path
) {
  exists(FunctionPosition pos |
    result = inferFunctionCallTypeNonSelf(n, pos, path) and
    if pos.isPosition()
    then kind = ContextTyping::PositionalKind()
    else kind = ContextTyping::ReturnKind()
  )
  or
  exists(FunctionCallMatchingInput::Access a |
    result = inferFunctionCallTypeSelf(a, n, DerefChain::nil(), path) and
    if a.(AssocFunctionResolution::AssocFunctionCall).hasReceiver()
    then kind = ContextTyping::SelfKind()
    else kind = ContextTyping::PositionalKind()
  )
}

/**
 * Gets the type of `n` at `path`, where `n` is either a function call or an
 * argument/receiver of a function call.
 */
private predicate inferFunctionCallType =
  ContextTyping::CheckContextTyping<inferFunctionCallTypePreCheck/3>::check/2;

abstract private class Constructor extends Addressable {
  final TypeParameter getTypeParameter(TypeParameterPosition ppos) {
    typeParamMatchPosition(this.getTypeItem().getGenericParamList().getATypeParam(), result, ppos)
  }

  abstract TypeItem getTypeItem();

  abstract TypeRepr getParameterTypeRepr(int pos);

  Type getReturnType(TypePath path) {
    result = TDataType(this.getTypeItem()) and
    path.isEmpty()
    or
    result = TTypeParamTypeParameter(this.getTypeItem().getGenericParamList().getATypeParam()) and
    path = TypePath::singleton(result)
  }

  Type getDeclaredType(FunctionPosition pos, TypePath path) {
    result = this.getParameterType(pos.asPosition(), path)
    or
    pos.isReturn() and
    result = this.getReturnType(path)
  }

  Type getParameterType(int pos, TypePath path) {
    result = this.getParameterTypeRepr(pos).(TypeMention).getTypeAt(path)
  }
}

private class StructConstructor extends Constructor instanceof Struct {
  override TypeItem getTypeItem() { result = this }

  override TypeRepr getParameterTypeRepr(int i) {
    result = [super.getTupleField(i).getTypeRepr(), super.getNthStructField(i).getTypeRepr()]
  }
}

private class VariantConstructor extends Constructor instanceof Variant {
  override TypeItem getTypeItem() { result = super.getEnum() }

  override TypeRepr getParameterTypeRepr(int i) {
    result = [super.getTupleField(i).getTypeRepr(), super.getNthStructField(i).getTypeRepr()]
  }
}

/**
 * A matching configuration for resolving types of constructions of enums and
 * structs, such as `Result::Ok(42)`, `Foo { bar: 1 }` and `None`.
 */
private module ConstructionMatchingInput implements MatchingInputSig {
  import FunctionPositionMatchingInput

  class Declaration = Constructor;

  abstract class Access extends AstNode {
    abstract Type getInferredType(FunctionPosition pos, TypePath path);

    abstract Declaration getTarget();

    abstract AstNode getNodeAt(AccessPosition apos);

    abstract Type getTypeArgument(TypeArgumentPosition apos, TypePath path);

    /**
     * Holds if the return type of this construction expression at `path` may
     * have to be inferred from the context. For example in `Result::Ok(42)` the
     * error type has to be inferred from the context.
     */
    pragma[nomagic]
    predicate hasUnknownTypeAt(FunctionPosition pos, TypePath path) {
      exists(Declaration d, TypeParameter tp |
        d = this.getTarget() and
        pos.isReturn() and
        tp = d.getReturnType(path) and
        not exists(FunctionPosition pos2 | not pos2.isReturn() and tp = d.getDeclaredType(pos2, _)) and
        // check that no explicit type arguments have been supplied for `tp`
        not exists(TypeArgumentPosition tapos |
          exists(this.getTypeArgument(tapos, _)) and
          TTypeParamTypeParameter(tapos.asTypeParam()) = tp
        )
      )
    }
  }

  private class NonAssocCallAccess extends Access, NonAssocCallExpr,
    ContextTyping::ContextTypedCallCand
  {
    NonAssocCallAccess() {
      this instanceof CallExprImpl::TupleStructExpr or
      this instanceof CallExprImpl::TupleVariantExpr
    }

    override Type getTypeArgument(TypeArgumentPosition apos, TypePath path) {
      result = NonAssocCallExpr.super.getTypeArgument(apos, path)
    }

    override AstNode getNodeAt(AccessPosition apos) {
      result = NonAssocCallExpr.super.getNodeAt(apos)
    }

    override Type getInferredType(FunctionPosition pos, TypePath path) {
      result = NonAssocCallExpr.super.getInferredType(pos, path)
    }

    override Declaration getTarget() { result = this.resolveCallTargetViaPathResolution() }
  }

  abstract private class StructAccess extends Access instanceof PathAstNode {
    pragma[nomagic]
    override Type getInferredType(AccessPosition apos, TypePath path) {
      result = inferType(this.getNodeAt(apos), path)
    }

    pragma[nomagic]
    override Declaration getTarget() { result = resolvePath(super.getPath()) }

    pragma[nomagic]
    override Type getTypeArgument(TypeArgumentPosition apos, TypePath path) {
      // Handle constructions that use `Self {...}` syntax
      exists(TypeMention tm, TypePath path0 |
        tm = super.getPath() and
        result = tm.getTypeAt(path0) and
        path0.isCons(TTypeParamTypeParameter(apos.asTypeParam()), path)
      )
    }
  }

  private class StructExprAccess extends StructAccess, StructExpr {
    override Type getTypeArgument(TypeArgumentPosition apos, TypePath path) {
      result = super.getTypeArgument(apos, path)
      or
      exists(TypePath suffix |
        suffix.isCons(TTypeParamTypeParameter(apos.asTypeParam()), path) and
        result = CertainTypeInference::inferCertainType(this, suffix)
      )
    }

    override AstNode getNodeAt(AccessPosition apos) {
      result =
        this.getFieldExpr(pragma[only_bind_into](this.getNthStructField(apos.asPosition())
              .getName()
              .getText())).getExpr()
      or
      result = this and apos.isReturn()
    }
  }

  /** A potential nullary struct/variant construction such as `None`. */
  private class PathExprAccess extends StructAccess, PathExpr {
    PathExprAccess() { not exists(CallExpr ce | this = ce.getFunction()) }

    override AstNode getNodeAt(AccessPosition apos) { result = this and apos.isReturn() }
  }
}

private module ConstructionMatching = Matching<ConstructionMatchingInput>;

pragma[nomagic]
private Type inferConstructionTypePreCheck(
  AstNode n, ContextTyping::FunctionPositionKind kind, TypePath path
) {
  exists(ConstructionMatchingInput::Access a, FunctionPosition pos |
    n = a.getNodeAt(pos) and
    if pos.isPosition()
    then kind = ContextTyping::PositionalKind()
    else kind = ContextTyping::ReturnKind()
  |
    result = ConstructionMatching::inferAccessType(a, pos, path)
    or
    a.hasUnknownTypeAt(pos, path) and
    result = TUnknownType()
  )
}

private predicate inferConstructionType =
  ContextTyping::CheckContextTyping<inferConstructionTypePreCheck/3>::check/2;

/**
 * A matching configuration for resolving types of operations like `a + b`.
 */
private module OperationMatchingInput implements MatchingInputSig {
  private import codeql.rust.elements.internal.OperationImpl::Impl as OperationImpl
  import FunctionPositionMatchingInput

  class Declaration extends FunctionCallMatchingInput::Declaration {
    private Method getSelfOrImpl() {
      result = f
      or
      f.implements(result)
    }

    pragma[nomagic]
    private predicate borrowsAt(FunctionPosition pos) {
      exists(TraitItemNode t, string path, string method |
        this.getSelfOrImpl() = t.getAssocItem(method) and
        path = t.getCanonicalPath(_) and
        exists(int borrows | OperationImpl::isOverloaded(_, _, path, method, borrows) |
          pos.asPosition() = 0 and borrows >= 1
          or
          pos.asPosition() = 1 and
          borrows >= 2
        )
      )
    }

    pragma[nomagic]
    private predicate derefsReturn() { this.getSelfOrImpl() = any(DerefTrait t).getDerefFunction() }

    Type getDeclaredType(FunctionPosition pos, TypePath path) {
      exists(TypePath path0 |
        result = super.getDeclaredType(pos, path0) and
        if
          this.borrowsAt(pos)
          or
          pos.isReturn() and this.derefsReturn()
        then path0.isCons(getRefTypeParameter(_), path)
        else path0 = path
      )
    }
  }

  class Access extends AssocFunctionResolution::OperationAssocFunctionCall {
    Type getTypeArgument(TypeArgumentPosition apos, TypePath path) { none() }

    pragma[nomagic]
    Type getInferredType(FunctionPosition pos, TypePath path) {
      result = inferType(this.getNodeAt(pos), path)
    }

    Declaration getTarget() {
      exists(ImplOrTraitItemNode i |
        result.isAssocFunction(i, this.resolveCallTarget(i, _, _, _)) // mutual recursion
      )
    }
  }
}

private module OperationMatching = Matching<OperationMatchingInput>;

pragma[nomagic]
private Type inferOperationTypePreCheck(
  AstNode n, ContextTyping::FunctionPositionKind kind, TypePath path
) {
  exists(OperationMatchingInput::Access a, FunctionPosition pos |
    n = a.getNodeAt(pos) and
    result = OperationMatching::inferAccessType(a, pos, path) and
    if pos.asPosition() = 0
    then kind = ContextTyping::SelfKind()
    else
      if pos.isPosition()
      then kind = ContextTyping::PositionalKind()
      else kind = ContextTyping::ReturnKind()
  )
}

private predicate inferOperationType =
  ContextTyping::CheckContextTyping<inferOperationTypePreCheck/3>::check/2;

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

private module AwaitSatisfiesTypeInput implements SatisfiesTypeInputSig<AwaitTarget> {
  pragma[nomagic]
  predicate relevantConstraint(AwaitTarget term, Type constraint) {
    exists(term) and
    constraint.(TraitType).getTrait() instanceof FutureTrait
  }
}

private module AwaitSatisfiesType = SatisfiesType<AwaitTarget, AwaitSatisfiesTypeInput>;

pragma[nomagic]
private Type inferAwaitExprType(AstNode n, TypePath path) {
  exists(TypePath exprPath |
    AwaitSatisfiesType::satisfiesConstraint(n.(AwaitExpr).getExpr(), _, exprPath, result) and
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
 * A matching configuration for resolving types of deconstruction patterns like
 * `let Foo { bar } = ...` or `let Some(x) = ...`.
 */
private module DeconstructionPatMatchingInput implements MatchingInputSig {
  import FunctionPositionMatchingInput

  class Declaration = ConstructionMatchingInput::Declaration;

  class Access extends Pat instanceof PathAstNode {
    Access() { this instanceof TupleStructPat or this instanceof StructPat }

    Type getTypeArgument(TypeArgumentPosition apos, TypePath path) { none() }

    AstNode getNodeAt(AccessPosition apos) {
      this =
        any(StructPat sp |
          result =
            sp.getPatField(pragma[only_bind_into](sp.getNthStructField(apos.asPosition())
                  .getName()
                  .getText())).getPat()
        )
      or
      result = this.(TupleStructPat).getField(apos.asPosition())
      or
      result = this and
      apos.isReturn()
    }

    Type getInferredType(AccessPosition apos, TypePath path) {
      result = inferType(this.getNodeAt(apos), path)
      or
      // The struct/enum type is supplied explicitly as a type qualifier, e.g.
      // `let Foo::<Bar>::Variant { ... } = ...` or
      // `let Option::<Foo>::Some(x) = ...`.
      apos.isReturn() and
      result = super.getPath().(TypeMention).getTypeAt(path)
    }

    Declaration getTarget() { result = resolvePath(super.getPath()) }
  }
}

private module DeconstructionPatMatching = Matching<DeconstructionPatMatchingInput>;

/**
 * Gets the type of `n` at `path`, where `n` is a pattern for a constructor,
 * either a struct pattern or a tuple-struct pattern.
 */
pragma[nomagic]
private Type inferDeconstructionPatType(AstNode n, TypePath path) {
  exists(DeconstructionPatMatchingInput::Access a, FunctionPosition apos |
    n = a.getNodeAt(apos) and
    result = DeconstructionPatMatching::inferAccessType(a, apos, path)
  )
}

final private class ForIterableExpr extends Expr {
  ForIterableExpr() { this = any(ForExpr fe).getIterable() }

  Type getTypeAt(TypePath path) { result = inferType(this, path) }
}

private module ForIterableSatisfiesTypeInput implements SatisfiesTypeInputSig<ForIterableExpr> {
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

private module ForIterableSatisfiesType =
  SatisfiesType<ForIterableExpr, ForIterableSatisfiesTypeInput>;

pragma[nomagic]
private Type inferForLoopExprType(AstNode n, TypePath path) {
  // type of iterable -> type of pattern (loop variable)
  exists(ForExpr fe, TypePath exprPath, AssociatedTypeTypeParameter tp |
    n = fe.getPat() and
    ForIterableSatisfiesType::satisfiesConstraint(fe.getIterable(), _, exprPath, result) and
    exprPath.isCons(tp, path)
  |
    tp = getIntoIteratorItemTypeParameter()
    or
    // TODO: Remove once we can handle the `impl<I: Iterator> IntoIterator for I` implementation
    tp = getIteratorItemTypeParameter() and
    inferType(fe.getIterable()) != getArrayTypeParameter()
  )
}

pragma[nomagic]
private Type inferClosureExprType(AstNode n, TypePath path) {
  exists(ClosureExpr ce |
    n = ce and
    (
      path = TypePath::singleton(TDynTraitTypeParameter(_, any(FnTrait t).getTypeParam())) and
      result.(TupleType).getArity() = ce.getNumberOfParams()
      or
      exists(TypePath path0 |
        result = ce.getRetType().getTypeRepr().(TypeMention).getTypeAt(path0) and
        path = closureReturnPath().append(path0)
      )
    )
    or
    exists(Param p |
      p = ce.getAParam() and
      not p.hasTypeRepr() and
      n = p.getPat() and
      result = TUnknownType() and
      path.isEmpty()
    )
  )
}

pragma[nomagic]
private TupleType inferArgList(ArgList args, TypePath path) {
  exists(CallExprImpl::DynamicCallExpr dce |
    args = dce.getArgList() and
    result.getArity() = dce.getNumberOfSyntacticArguments() and
    path.isEmpty()
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
      any(AssocFunctionResolution::AssocFunctionCall afc)
          .argumentHasImplicitDerefChainBorrow(e, derefChain, bk) and
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
    result = call.(NonAssocCallExpr).resolveCallTargetViaPathResolution()
    or
    exists(ImplOrTraitItemNode i |
      i instanceof TraitItemNode and dispatch = true
      or
      i instanceof ImplItemNode and dispatch = false
    |
      result = call.(AssocFunctionResolution::AssocFunctionCall).resolveCallTarget(i, _, _, _) and
      not call instanceof CallExprImpl::DynamicCallExpr and
      not i instanceof Builtins::BuiltinImpl
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
    forall(TypePath prefix |
      CertainTypeInference::hasInferredCertainType(n, prefix) and
      prefix.isPrefixOf(path)
    |
      not CertainTypeInference::certainTypeConflict(n, prefix, path, result)
    ) and
    (
      result = inferAssignmentOperationType(n, path)
      or
      result = inferTypeEquality(n, path)
      or
      result = inferFunctionCallType(n, path)
      or
      result = inferConstructionType(n, path)
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
      result = inferDereferencedExprPtrType(n, path)
      or
      result = inferForLoopExprType(n, path)
      or
      result = inferClosureExprType(n, path)
      or
      result = inferArgList(n, path)
      or
      result = inferDeconstructionPatType(n, path)
      or
      result = inferUnknownTypeFromAnnotation(n, path)
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
      filepath.matches("%/main.rs") and
      startline = 103
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
    Input2::conditionSatisfiesConstraint(abs, condition, constraint, transitive)
  }

  predicate debugInferShorthandSelfType(ShorthandSelfParameterMention self, TypePath path, Type t) {
    self = getRelevantLocatable() and
    t = self.getTypeAt(path)
  }

  predicate debugInferFunctionCallType(AstNode n, TypePath path, Type t) {
    n = getRelevantLocatable() and
    t = inferFunctionCallType(n, path)
  }

  predicate debugInferConstructionType(AstNode n, TypePath path, Type t) {
    n = getRelevantLocatable() and
    t = inferConstructionType(n, path)
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
