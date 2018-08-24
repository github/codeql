/**
 * Provides an implementation of Hash consing.
 * See https://en.wikipedia.org/wiki/Hash_consing
 *
 * The predicate `hashCons` converts an expression into a `HC`, which is an
 * abstract type presenting the hash-cons of the expression. If two
 * expressions have the same `HC` then they are structurally equal.
 *
 * Important note: this library ignores the possibility that the value of
 * an expression might change between one occurrence and the next. For
 * example:
 *
 * ```
 * x = a+b;
 * a++;
 * y = a+b;
 * ```
 *
 * In this example, both copies of the expression `a+b` will hash-cons to
 * the same value, even though the value of `a` has changed. This is the
 * intended behavior of this library. If you care about the value of the
 * expression being the same, then you should use the GlobalValueNumbering
 * library instead.
 *
 * To determine if the expression `x` is structurally equal to the
 * expression `y`, use the library like this:
 *
 * ```
 * hashCons(x) = hashCons(y)
 * ```
 */

/*
 * Note to developers: the correctness of this module depends on the
 * definitions of HC, hashCons, and analyzableExpr being kept in sync with
 * each other. If you change this module then make sure that the change is
 * symmetric across all three.
 */

import cpp

/** Used to represent the hash-cons of an expression. */
private cached newtype HCBase =
  HC_IntLiteral(int val, Type t) { mk_IntLiteral(val,t,_) }
  or
  HC_FloatLiteral(float val, Type t) { mk_FloatLiteral(val,t,_) }
  or
  HC_StringLiteral(string val, Type t) {mk_StringLiteral(val,t,_)}
  or
  HC_Variable(Variable x) {
     mk_Variable(x, _)
  }
  or
  HC_FieldAccess(HC s, Field f) {
    mk_DotFieldAccess(s,f,_) or
    mk_PointerFieldAccess_with_deref(s,f,_) or
    mk_ImplicitThisFieldAccess_with_deref(s,f,_)
  }
  or
  HC_Deref(HC p) {
    mk_Deref(p,_) or
    mk_PointerFieldAccess(p,_,_) or
    mk_ImplicitThisFieldAccess_with_qualifier(p,_,_)
  }
  or
  HC_ThisExpr(Function fcn) {
    mk_ThisExpr(fcn,_) or
    mk_ImplicitThisFieldAccess(fcn,_,_)
  }
  or
  HC_Conversion(Type t, HC child) { mk_Conversion(t, child, _) }
  or
  HC_BinaryOp(HC lhs, HC rhs, string opname) {
    mk_BinaryOp(lhs, rhs, opname, _)
  }
  or
  HC_UnaryOp(HC child, string opname) { mk_UnaryOp(child, opname, _) }
  or
  HC_ArrayAccess(HC x, HC i) {
    mk_ArrayAccess(x,i,_)
  }
  or
  HC_NonmemberFunctionCall(Function fcn, HC_Args args) {
    mk_NonmemberFunctionCall(fcn, args, _)
  }
  or
  HC_MemberFunctionCall(Function trg, HC qual, HC_Args args) {
    mk_MemberFunctionCall(trg, qual, args, _)
  }
  or
  // Any expression that is not handled by the cases above is
  // given a unique number based on the expression itself.
  HC_Unanalyzable(Expr e) { not analyzableExpr(e,_) }

private cached newtype HC_Args =
  HC_EmptyArgs(Function fcn) {
    any()
  }
  or HC_ArgCons(Function fcn, HC hc, int i, HC_Args list) {
    mk_ArgCons(fcn, hc, i, list, _)
  }
/**
 * HC is the hash-cons of an expression. The relationship between `Expr`
 * and `HC` is many-to-one: every `Expr` has exactly one `HC`, but multiple
 * expressions can have the same `HC`. If two expressions have the same
 * `HC`, it means that they are structurally equal. The `HC` is an opaque
 * value. The only use for the `HC` of an expression is to find other
 * expressions that are structurally equal to it. Use the predicate
 * `hashCons` to get the `HC` for an `Expr`.
 *
 * Note: `HC` has `toString` and `getLocation` methods, so that it can be
 * displayed in a results list. These work by picking an arbitrary
 * expression with this `HC` and using its `toString` and `getLocation`
 * methods.
 */
class HC extends HCBase {
  HC() { this instanceof HCBase }

  /** Gets an expression that has this HC. */
  Expr getAnExpr() {
    this = hashCons(result)
  }

  /** Gets the kind of the HC. This can be useful for debugging. */
  string getKind() {
    if this instanceof HC_IntLiteral then result = "IntLiteral" else
    if this instanceof HC_FloatLiteral then result = "FloatLiteral" else
    if this instanceof HC_StringLiteral then result = "StringLiteral" else
    if this instanceof HC_Variable then result = "Variable" else
    if this instanceof HC_FieldAccess then result = "FieldAccess" else
    if this instanceof HC_Deref then result = "Deref" else
    if this instanceof HC_ThisExpr then result = "ThisExpr" else
    if this instanceof HC_Conversion then result = "Conversion" else
    if this instanceof HC_BinaryOp then result = "BinaryOp" else
    if this instanceof HC_UnaryOp then result = "UnaryOp" else
    if this instanceof HC_ArrayAccess then result = "ArrayAccess" else
    if this instanceof HC_Unanalyzable then result = "Unanalyzable" else
    if this instanceof HC_NonmemberFunctionCall then result = "NonmemberFunctionCall" else
    if this instanceof HC_MemberFunctionCall then result = "MemberFunctionCall" else
    result = "error"
  }

  /**
   * Gets an example of an expression with this HC.
   * This is useful for things like implementing toString().
   */
  private Expr exampleExpr() {
    // Pick the expression with the minimum source location string. This is
    // just an arbitrary way to pick an expression with this `HC`.
    result =
       min(Expr e
       | this = hashCons(e)
       | e order by e.getLocation().toString())
  }

  /** Gets a textual representation of this element. */
  string toString() {
    result = exampleExpr().toString()
  }

  /** Gets the primary location of this element. */
  Location getLocation() {
    result = exampleExpr().getLocation()
  }
}

private predicate analyzableIntLiteral(Literal e) {
  strictcount (e.getValue().toInt()) = 1 and
  strictcount (e.getType().getUnspecifiedType()) = 1
}

private predicate mk_IntLiteral(int val, Type t, Expr e) {
  analyzableIntLiteral(e) and
  val = e.getValue().toInt() and
  t = e.getType().getUnspecifiedType() and
  t instanceof IntegralType
}
private predicate analyzableFloatLiteral(Literal e) {
  strictcount (e.getValue().toFloat()) = 1 and
  strictcount (e.getType().getUnspecifiedType()) = 1
}

private predicate mk_FloatLiteral(float val, Type t, Expr e) {
  analyzableFloatLiteral(e) and
  val = e.getValue().toFloat() and
  t = e.getType().getUnspecifiedType() and
  t instanceof FloatingPointType
}

private predicate analyzableStringLiteral(Literal e) {
  strictcount(e.getValue()) = 1 and
  strictcount(e.getType().getUnspecifiedType()) = 1
}

private predicate mk_StringLiteral(string val, Type t, Expr e) {
  analyzableStringLiteral(e) and
  val = e.getValue() and
  t = e.getType().getUnspecifiedType() and
  t.(ArrayType).getBaseType() instanceof CharType
  
}

private predicate analyzableDotFieldAccess(DotFieldAccess access) {
  strictcount (access.getTarget()) = 1 and
  strictcount (access.getQualifier().getFullyConverted()) = 1
}

private predicate mk_DotFieldAccess(
  HC qualifier, Field target, DotFieldAccess access) {
  analyzableDotFieldAccess(access) and
  target = access.getTarget() and
  qualifier = hashCons(access.getQualifier().getFullyConverted())
}

private predicate analyzablePointerFieldAccess(PointerFieldAccess access) {
  strictcount (access.getTarget()) = 1 and
  strictcount (access.getQualifier().getFullyConverted()) = 1
}

private predicate mk_PointerFieldAccess(
  HC qualifier, Field target,
  PointerFieldAccess access) {
   analyzablePointerFieldAccess(access) and
  target = access.getTarget() and
  qualifier = hashCons(access.getQualifier().getFullyConverted())
}

/*
 * `obj->field` is equivalent to `(*obj).field`, so we need to wrap an
 * extra `HC_Deref` around the qualifier.
 */
private predicate mk_PointerFieldAccess_with_deref(
  HC new_qualifier, Field target, PointerFieldAccess access) {
  exists (HC qualifier
  | mk_PointerFieldAccess(qualifier, target, access) and
    new_qualifier = HC_Deref(qualifier))
}

private predicate analyzableImplicitThisFieldAccess(
  ImplicitThisFieldAccess access) {
  strictcount (access.getTarget()) = 1 and
  strictcount (access.getEnclosingFunction()) = 1
}

private predicate mk_ImplicitThisFieldAccess(
  Function fcn, Field target,
  ImplicitThisFieldAccess access) {
  analyzableImplicitThisFieldAccess(access) and
  target = access.getTarget() and
  fcn = access.getEnclosingFunction()
}

private predicate mk_ImplicitThisFieldAccess_with_qualifier(
  HC qualifier, Field target,
  ImplicitThisFieldAccess access) {
  exists (Function fcn
  | mk_ImplicitThisFieldAccess(fcn, target, access) and
    qualifier = HC_ThisExpr(fcn))
}

private predicate mk_ImplicitThisFieldAccess_with_deref(
  HC new_qualifier, Field target, ImplicitThisFieldAccess access) {
  exists (HC qualifier
  | mk_ImplicitThisFieldAccess_with_qualifier(
      qualifier, target, access) and
    new_qualifier = HC_Deref(qualifier))
}

private predicate analyzableVariable(VariableAccess access) {
  not (access instanceof FieldAccess) and
  strictcount (access.getTarget()) = 1
}

private predicate mk_Variable(Variable x, VariableAccess access) {
  analyzableVariable(access) and
  x = access.getTarget()
}

private predicate analyzableConversion(Conversion conv) {
  strictcount (conv.getType().getUnspecifiedType()) = 1 and
  strictcount (conv.getExpr()) = 1
}

private predicate mk_Conversion(Type t, HC child, Conversion conv) {
  analyzableConversion(conv) and
  t = conv.getType().getUnspecifiedType() and
  child = hashCons(conv.getExpr())
}

private predicate analyzableBinaryOp(BinaryOperation op) {
  op.isPure() and
  strictcount (op.getLeftOperand().getFullyConverted()) = 1 and
  strictcount (op.getRightOperand().getFullyConverted()) = 1 and
  strictcount (op.getOperator()) = 1
}

private predicate mk_BinaryOp(
  HC lhs, HC rhs, string opname, BinaryOperation op) {
  analyzableBinaryOp(op) and
  lhs = hashCons(op.getLeftOperand().getFullyConverted()) and
  rhs = hashCons(op.getRightOperand().getFullyConverted()) and
  opname = op.getOperator()
}

private predicate analyzableUnaryOp(UnaryOperation op) {
  not (op instanceof PointerDereferenceExpr) and
  strictcount (op.getOperand().getFullyConverted()) = 1 and
  strictcount (op.getOperator()) = 1
}

private predicate mk_UnaryOp(HC child, string opname, UnaryOperation op) {
  analyzableUnaryOp(op) and
  child = hashCons(op.getOperand().getFullyConverted()) and
  opname = op.getOperator()
}

private predicate analyzableThisExpr(ThisExpr thisExpr) {
  strictcount(thisExpr.getEnclosingFunction()) = 1
}

private predicate mk_ThisExpr(Function fcn, ThisExpr thisExpr) {
  analyzableThisExpr(thisExpr) and
  fcn = thisExpr.getEnclosingFunction()
}

private predicate analyzableArrayAccess(ArrayExpr ae) {
  strictcount (ae.getArrayBase().getFullyConverted()) = 1 and
  strictcount (ae.getArrayOffset().getFullyConverted()) = 1
}

private predicate mk_ArrayAccess(
  HC base, HC offset, ArrayExpr ae) {
  analyzableArrayAccess(ae) and
  base = hashCons(ae.getArrayBase().getFullyConverted()) and
  offset = hashCons(ae.getArrayOffset().getFullyConverted())
}

private predicate analyzablePointerDereferenceExpr(
  PointerDereferenceExpr deref) {
  strictcount (deref.getOperand().getFullyConverted()) = 1
}

private predicate mk_Deref(
  HC p, PointerDereferenceExpr deref) {
  analyzablePointerDereferenceExpr(deref) and
  p = hashCons(deref.getOperand().getFullyConverted())
}

private predicate analyzableNonmemberFunctionCall(
  FunctionCall fc) {
  forall(int i | exists(fc.getArgument(i)) | strictcount(fc.getArgument(i)) = 1) and
  strictcount(fc.getTarget()) = 1 and
  not fc.getTarget().isMember()
}

private predicate mk_NonmemberFunctionCall(
  Function fcn,
  HC_Args args,
  FunctionCall fc
) {
  fc.getTarget() = fcn and
  analyzableNonmemberFunctionCall(fc) and
  (
    exists(HC head, HC_Args tail |
      args = HC_ArgCons(fcn, head, fc.getNumberOfArguments() - 1, tail) and
      mk_ArgCons(fcn, head, fc.getNumberOfArguments() - 1, tail, fc)
    )
    or
    fc.getNumberOfArguments() = 0 and
    args = HC_EmptyArgs(fcn)
  )
}

private predicate analyzableMemberFunctionCall(
  FunctionCall fc) {
  forall(int i | exists(fc.getArgument(i)) | strictcount(fc.getArgument(i)) = 1) and
  strictcount(fc.getTarget()) = 1 and
  strictcount(fc.getQualifier()) = 1
}

private predicate analyzableFunctionCall(
  FunctionCall fc
) {
  analyzableNonmemberFunctionCall(fc)
  or
  analyzableMemberFunctionCall(fc)
}

private predicate mk_MemberFunctionCall(
  Function fcn,
  HC qual,
  HC_Args args,
  FunctionCall fc
) {
  fc.getTarget() = fcn and
  analyzableMemberFunctionCall(fc) and
  hashCons(fc.getQualifier()) = qual and
  (
    exists(HC head, HC_Args tail |
      args = HC_ArgCons(fcn, head, fc.getNumberOfArguments() - 1, tail) and
      mk_ArgCons(fcn, head, fc.getNumberOfArguments() - 1, tail, fc)
    )
    or
    fc.getNumberOfArguments() = 0 and
    args = HC_EmptyArgs(fcn)
  )
}

/*
private predicate   analyzableImplicitThisFunctionCall(FunctionCall fc) {
  forall(int i | exists(fc.getArgument(i)) | strictcount(fc.getArgument(i)) = 1) and
  strictcount(fc.getTarget()) = 1 and
  fc.getQualifier().(ThisExpr).isCompilerGenerated() and
  fc.getTarget().isMember()
}

private predicate mk_ImplicitThisFunctionCall(Function fcn, Function targ, HC_Args args, FunctionCall fc) {
  analyzableImplicitThisFunctionCall(fc) and
  fc.getTarget() = targ and
  fc.getEnclosingFunction() = fcn and
  analyzableImplicitThisFunctionCall(fc) and
  (
    exists(HC head, HC_Args tail |
      args = HC_ArgCons(targ, head, fc.getNumberOfArguments() - 1, tail) and
      mk_ArgCons(targ, head, fc.getNumberOfArguments() - 1, tail, fc)
    )
    or
    fc.getNumberOfArguments() = 0 and
    args = HC_EmptyArgs(targ)
  )
}

private predicate mk_ImplicitThisFunctionCall_with_qualifier(
  Function fcn,
  Function targ,
  HC qual,
  HC_Args args,
  FunctionCall fc) {
  mk_ImplicitThisFunctionCall(fcn, targ, args, fc) and
  qual = HC_ThisExpr(fcn)
}
*/
private predicate mk_ArgCons(Function fcn, HC hc, int i, HC_Args list, FunctionCall fc) {
  analyzableFunctionCall(fc) and
  fc.getTarget() = fcn and
  hc = hashCons(fc.getArgument(i).getFullyConverted()) and
  (
    exists(HC head, HC_Args tail |
      list = HC_ArgCons(fcn, head, i - 1, tail) and
      mk_ArgCons(fcn, head, i - 1, tail, fc) and
      i > 0
    )
    or
    i = 0 and
    list = HC_EmptyArgs(fcn)
  )
}

/** Gets the hash-cons of expression `e`. */
cached HC hashCons(Expr e) {
  exists (int val, Type t
  | mk_IntLiteral(val, t, e) and
    result = HC_IntLiteral(val, t))
  or
  exists (float val, Type t
  | mk_FloatLiteral(val, t, e) and
    result = HC_FloatLiteral(val, t))
  or
  exists (string val, Type t
  | mk_StringLiteral(val, t, e) and
    result = HC_StringLiteral(val, t))
  or
  // Variable with no SSA information.
  exists (Variable x
  | mk_Variable(x, e) and
    result = HC_Variable(x))
  or
  exists (HC qualifier, Field target
  | mk_DotFieldAccess(qualifier, target, e) and
    result = HC_FieldAccess(qualifier, target))
  or
  exists (HC qualifier, Field target
  | mk_PointerFieldAccess_with_deref(qualifier, target, e) and
    result = HC_FieldAccess(qualifier, target))
  or
  exists (HC qualifier, Field target
  | mk_ImplicitThisFieldAccess_with_deref(qualifier, target, e) and
    result = HC_FieldAccess(qualifier, target))
  or
  exists (Function fcn
  | mk_ThisExpr(fcn, e) and
    result = HC_ThisExpr(fcn))
  or
  exists (Type t, HC child
  | mk_Conversion(t, child, e) and
    result = HC_Conversion(t, child))
  or
  exists (HC lhs, HC rhs, string opname
  | mk_BinaryOp(lhs, rhs, opname, e) and
    result = HC_BinaryOp(lhs, rhs, opname))
  or
  exists (HC child, string opname
  | mk_UnaryOp(child, opname, e) and
    result = HC_UnaryOp(child, opname))
  or
  exists (HC x, HC i
  | mk_ArrayAccess(x, i, e) and
    result = HC_ArrayAccess(x, i))
  or
  exists (HC p
  | mk_Deref(p, e) and
    result = HC_Deref(p))
  or
  exists(Function fcn, HC_Args args
  | mk_NonmemberFunctionCall(fcn, args, e) and
    result = HC_NonmemberFunctionCall(fcn, args)
  )
  or
  exists(Function fcn, HC qual, HC_Args args
  | mk_MemberFunctionCall(fcn, qual, args, e) and
    result = HC_MemberFunctionCall(fcn, qual, args)
  )

  or
  (not analyzableExpr(e,_) and result = HC_Unanalyzable(e))
}
/**
 * Holds if the expression is explicitly handled by `hashCons`.
 * Unanalyzable expressions still need to be given a hash-cons,
 * but it will be a unique number that is not shared with any other
 * expression.
 */
predicate analyzableExpr(Expr e, string kind) {
  (analyzableIntLiteral(e) and kind = "IntLiteral") or
  (analyzableFloatLiteral(e) and kind = "FloatLiteral") or
  (analyzableStringLiteral(e) and kind = "StringLiteral") or
  (analyzableDotFieldAccess(e) and kind = "DotFieldAccess") or
  (analyzablePointerFieldAccess(e) and kind = "PointerFieldAccess") or
  (analyzableImplicitThisFieldAccess(e) and kind = "ImplicitThisFieldAccess") or
  (analyzableVariable(e) and kind = "Variable") or
  (analyzableConversion(e) and kind = "Conversion") or
  (analyzableBinaryOp(e) and kind = "BinaryOp") or
  (analyzableUnaryOp(e) and kind = "UnaryOp") or
  (analyzableThisExpr(e) and kind = "ThisExpr") or
  (analyzableArrayAccess(e) and kind = "ArrayAccess") or
  (analyzablePointerDereferenceExpr(e) and kind = "PointerDereferenceExpr") or
  (analyzableNonmemberFunctionCall(e) and kind = "NonmemberFunctionCall") or
  (analyzableMemberFunctionCall(e) and kind = "MemberFunctionCall")
}
