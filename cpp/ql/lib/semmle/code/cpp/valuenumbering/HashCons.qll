/**
 * Provides an implementation of Hash consing.
 * See https://en.wikipedia.org/wiki/Hash_consing
 *
 * The predicate `hashCons` converts an expression into a `HashCons`, which is an
 * abstract type presenting the hash-cons of the expression. If two
 * expressions have the same `HashCons` then they are structurally equal.
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
cached
private newtype HCBase =
  HC_IntLiteral(int val, Type t) { mk_IntLiteral(val, t, _) } or
  HC_EnumConstantAccess(EnumConstant val, Type t) { mk_EnumConstantAccess(val, t, _) } or
  HC_FloatLiteral(float val, Type t) { mk_FloatLiteral(val, t, _) } or
  HC_StringLiteral(string val, Type t) { mk_StringLiteral(val, t, _) } or
  HC_Nullptr() { mk_Nullptr(_) } or
  HC_Variable(Variable x) { mk_Variable(x, _) } or
  HC_FieldAccess(HashCons s, Field f) { mk_DotFieldAccess(s, f, _) } or
  HC_Deref(HashCons p) { mk_Deref(p, _) } or
  HC_PointerFieldAccess(HashCons qual, Field target) { mk_PointerFieldAccess(qual, target, _) } or
  HC_ThisExpr(Function fcn) { mk_ThisExpr(fcn, _) } or
  HC_ImplicitThisFieldAccess(Function fcn, Field target) {
    mk_ImplicitThisFieldAccess(fcn, target, _)
  } or
  HC_Conversion(Type t, HashCons child) { mk_Conversion(t, child, _) } or
  HC_BinaryOp(HashCons lhs, HashCons rhs, string opname) { mk_BinaryOp(lhs, rhs, opname, _) } or
  HC_UnaryOp(HashCons child, string opname) { mk_UnaryOp(child, opname, _) } or
  HC_ArrayAccess(HashCons x, HashCons i) { mk_ArrayAccess(x, i, _) } or
  HC_NonmemberFunctionCall(Function fcn, HC_Args args) { mk_NonmemberFunctionCall(fcn, args, _) } or
  HC_ExprCall(HashCons hc, HC_Args args) { mk_ExprCall(hc, args, _) } or
  HC_MemberFunctionCall(Function trg, HashCons qual, HC_Args args) {
    mk_MemberFunctionCall(trg, qual, args, _)
  } or
  // Hack to get around argument 0 of allocator calls being an error expression
  HC_AllocatorArgZero(Type t) { mk_AllocatorArgZero(t, _) } or
  HC_NewExpr(Type t, HC_Alloc alloc, HC_Init init) { mk_NewExpr(t, alloc, init, _) } or
  HC_NewArrayExpr(Type t, HC_Alloc alloc, HC_Extent extent, HC_Init init) {
    mk_NewArrayExpr(t, alloc, extent, init, _)
  } or
  HC_SizeofType(Type t) { mk_SizeofType(t, _) } or
  HC_SizeofExpr(HashCons child) { mk_SizeofExpr(child, _) } or
  HC_AlignofType(Type t) { mk_AlignofType(t, _) } or
  HC_AlignofExpr(HashCons child) { mk_AlignofExpr(child, _) } or
  HC_UuidofOperator(Type t) { mk_UuidofOperator(t, _) } or
  HC_TypeidType(Type t) { mk_TypeidType(t, _) } or
  HC_TypeidExpr(HashCons child) { mk_TypeidExpr(child, _) } or
  HC_ClassAggregateLiteral(Class c, HC_Fields hcf) { mk_ClassAggregateLiteral(c, hcf, _) } or
  HC_ArrayAggregateLiteral(Type t, HC_Array hca) { mk_ArrayAggregateLiteral(t, hca, _) } or
  HC_DeleteExpr(HashCons child) { mk_DeleteExpr(child, _) } or
  HC_DeleteArrayExpr(HashCons child) { mk_DeleteArrayExpr(child, _) } or
  HC_ThrowExpr(HashCons child) { mk_ThrowExpr(child, _) } or
  HC_ReThrowExpr() or
  HC_ConditionalExpr(HashCons cond, HashCons trueHC, HashCons falseHC) {
    mk_ConditionalExpr(cond, trueHC, falseHC, _)
  } or
  HC_NoExceptExpr(HashCons child) { mk_NoExceptExpr(child, _) } or
  // Any expression that is not handled by the cases above is
  // given a unique number based on the expression itself.
  HC_Unanalyzable(Expr e) { not analyzableExpr(e, _) }

/** Used to implement optional init on `new` expressions */
private newtype HC_Init =
  HC_NoInit() or
  HC_HasInit(HashCons hc) { mk_HasInit(hc, _) }

/**
 * Used to implement optional allocator call on `new` expressions
 */
private newtype HC_Alloc =
  HC_NoAlloc() or
  HC_HasAlloc(HashCons hc) { mk_HasAlloc(hc, _) }

/**
 * Used to implement optional extent expression on `new[]` exprtessions
 */
private newtype HC_Extent =
  HC_NoExtent() or
  HC_HasExtent(HashCons hc) { mk_HasExtent(hc, _) }

/** Used to implement hash-consing of argument lists */
private newtype HC_Args =
  HC_EmptyArgs() { any() } or
  HC_ArgCons(HashCons hc, int i, HC_Args list) { mk_ArgCons(hc, i, list, _) }

/**
 * Used to implement hash-consing of struct initizializers.
 */
private newtype HC_Fields =
  HC_EmptyFields(Class c) { exists(ClassAggregateLiteral cal | c = cal.getUnspecifiedType()) } or
  HC_FieldCons(Class c, int i, Field f, HashCons hc, HC_Fields hcf) {
    mk_FieldCons(c, i, f, hc, hcf, _)
  }

private newtype HC_Array =
  HC_EmptyArray(Type t) { exists(ArrayAggregateLiteral aal | aal.getUnspecifiedType() = t) } or
  HC_ArrayCons(Type t, int i, HashCons hc, HC_Array hca) { mk_ArrayCons(t, i, hc, hca, _) }

/**
 * HashCons is the hash-cons of an expression. The relationship between `Expr`
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
class HashCons extends HCBase {
  /** Gets an expression that has this HC. */
  Expr getAnExpr() { this = hashCons(result) }

  /** Gets the kind of the HC. This can be useful for debugging. */
  string getKind() {
    if this instanceof HC_IntLiteral
    then result = "IntLiteral"
    else
      if this instanceof HC_EnumConstantAccess
      then result = "EnumConstantAccess"
      else
        if this instanceof HC_FloatLiteral
        then result = "FloatLiteral"
        else
          if this instanceof HC_StringLiteral
          then result = "StringLiteral"
          else
            if this instanceof HC_Nullptr
            then result = "Nullptr"
            else
              if this instanceof HC_Variable
              then result = "Variable"
              else
                if this instanceof HC_FieldAccess
                then result = "FieldAccess"
                else
                  if this instanceof HC_Deref
                  then result = "Deref"
                  else
                    if this instanceof HC_ThisExpr
                    then result = "ThisExpr"
                    else
                      if this instanceof HC_Conversion
                      then result = "Conversion"
                      else
                        if this instanceof HC_BinaryOp
                        then result = "BinaryOp"
                        else
                          if this instanceof HC_UnaryOp
                          then result = "UnaryOp"
                          else
                            if this instanceof HC_ArrayAccess
                            then result = "ArrayAccess"
                            else
                              if this instanceof HC_Unanalyzable
                              then result = "Unanalyzable"
                              else
                                if this instanceof HC_NonmemberFunctionCall
                                then result = "NonmemberFunctionCall"
                                else
                                  if this instanceof HC_MemberFunctionCall
                                  then result = "MemberFunctionCall"
                                  else
                                    if this instanceof HC_NewExpr
                                    then result = "NewExpr"
                                    else
                                      if this instanceof HC_NewArrayExpr
                                      then result = "NewArrayExpr"
                                      else
                                        if this instanceof HC_SizeofType
                                        then result = "SizeofTypeOperator"
                                        else
                                          if this instanceof HC_SizeofExpr
                                          then result = "SizeofExprOperator"
                                          else
                                            if this instanceof HC_AlignofType
                                            then result = "AlignofTypeOperator"
                                            else
                                              if this instanceof HC_AlignofExpr
                                              then result = "AlignofExprOperator"
                                              else
                                                if this instanceof HC_UuidofOperator
                                                then result = "UuidofOperator"
                                                else
                                                  if this instanceof HC_TypeidType
                                                  then result = "TypeidType"
                                                  else
                                                    if this instanceof HC_TypeidExpr
                                                    then result = "TypeidExpr"
                                                    else
                                                      if this instanceof HC_ArrayAggregateLiteral
                                                      then result = "ArrayAggregateLiteral"
                                                      else
                                                        if this instanceof HC_ClassAggregateLiteral
                                                        then result = "ClassAggregateLiteral"
                                                        else
                                                          if this instanceof HC_DeleteExpr
                                                          then result = "DeleteExpr"
                                                          else
                                                            if this instanceof HC_DeleteArrayExpr
                                                            then result = "DeleteArrayExpr"
                                                            else
                                                              if this instanceof HC_ThrowExpr
                                                              then result = "ThrowExpr"
                                                              else
                                                                if this instanceof HC_ReThrowExpr
                                                                then result = "ReThrowExpr"
                                                                else
                                                                  if this instanceof HC_ExprCall
                                                                  then result = "ExprCall"
                                                                  else
                                                                    if
                                                                      this instanceof
                                                                        HC_ConditionalExpr
                                                                    then result = "ConditionalExpr"
                                                                    else
                                                                      if
                                                                        this instanceof
                                                                          HC_NoExceptExpr
                                                                      then result = "NoExceptExpr"
                                                                      else
                                                                        if
                                                                          this instanceof
                                                                            HC_AllocatorArgZero
                                                                        then
                                                                          result =
                                                                            "AllocatorArgZero"
                                                                        else result = "error"
  }

  /**
   * Gets an example of an expression with this HC.
   * This is useful for things like implementing toString().
   */
  private Expr exampleExpr() {
    // Pick the expression with the minimum source location string. This is
    // just an arbitrary way to pick an expression with this `HC`.
    result =
      min(Expr e |
        this = hashCons(e)
      |
        e
        order by
          exampleLocationString(e.getLocation()), e.getLocation().getStartColumn(),
          e.getLocation().getEndLine(), e.getLocation().getEndColumn()
      )
  }

  /** Gets a textual representation of this element. */
  string toString() { result = exampleExpr().toString() }

  /** Gets the primary location of this element. */
  Location getLocation() { result = exampleExpr().getLocation() }
}

/**
 * Gets the absolute path of a known location or "~" for an unknown location. This ensures that
 * expressions with unknown locations are ordered after expressions with known locations when
 * selecting an example expression for a HashCons value.
 */
private string exampleLocationString(Location l) {
  if l instanceof UnknownLocation then result = "~" else result = l.getFile().getAbsolutePath()
}

private predicate analyzableIntLiteral(Literal e) {
  strictcount(e.getValue().toInt()) = 1 and
  strictcount(e.getUnspecifiedType()) = 1 and
  e.getUnspecifiedType() instanceof IntegralType
}

private predicate mk_IntLiteral(int val, Type t, Expr e) {
  analyzableIntLiteral(e) and
  val = e.getValue().toInt() and
  t = e.getUnspecifiedType()
}

private predicate analyzableEnumConstantAccess(EnumConstantAccess e) {
  strictcount(e.getValue().toInt()) = 1 and
  strictcount(e.getUnspecifiedType()) = 1 and
  e.getUnspecifiedType() instanceof Enum
}

private predicate mk_EnumConstantAccess(EnumConstant val, Type t, Expr e) {
  analyzableEnumConstantAccess(e) and
  val = e.(EnumConstantAccess).getTarget() and
  t = e.getUnspecifiedType()
}

private predicate analyzableFloatLiteral(Literal e) {
  strictcount(e.getValue().toFloat()) = 1 and
  strictcount(e.getUnspecifiedType()) = 1 and
  e.getUnspecifiedType() instanceof FloatingPointType
}

private predicate mk_FloatLiteral(float val, Type t, Expr e) {
  analyzableFloatLiteral(e) and
  val = e.getValue().toFloat() and
  t = e.getUnspecifiedType()
}

private predicate analyzableNullptr(NullValue e) {
  strictcount(e.getUnspecifiedType()) = 1 and
  e.getType() instanceof NullPointerType
}

private predicate mk_Nullptr(Expr e) { analyzableNullptr(e) }

private predicate analyzableStringLiteral(Literal e) {
  strictcount(e.getValue()) = 1 and
  strictcount(e.getUnspecifiedType()) = 1 and
  e.getUnspecifiedType().(ArrayType).getBaseType() instanceof CharType
}

private predicate mk_StringLiteral(string val, Type t, Expr e) {
  analyzableStringLiteral(e) and
  val = e.getValue() and
  t = e.getUnspecifiedType() and
  t.(ArrayType).getBaseType() instanceof CharType
}

private predicate analyzableDotFieldAccess(DotFieldAccess access) {
  strictcount(access.getTarget()) = 1 and
  strictcount(access.getQualifier().getFullyConverted()) = 1
}

private predicate mk_DotFieldAccess(HashCons qualifier, Field target, DotFieldAccess access) {
  analyzableDotFieldAccess(access) and
  target = access.getTarget() and
  qualifier = hashCons(access.getQualifier().getFullyConverted())
}

private predicate analyzablePointerFieldAccess(PointerFieldAccess access) {
  strictcount(access.getTarget()) = 1 and
  strictcount(access.getQualifier().getFullyConverted()) = 1
}

private predicate mk_PointerFieldAccess(HashCons qualifier, Field target, PointerFieldAccess access) {
  analyzablePointerFieldAccess(access) and
  target = access.getTarget() and
  qualifier = hashCons(access.getQualifier().getFullyConverted())
}

private predicate analyzableImplicitThisFieldAccess(ImplicitThisFieldAccess access) {
  strictcount(access.getTarget()) = 1 and
  strictcount(access.getEnclosingFunction()) = 1
}

private predicate mk_ImplicitThisFieldAccess(
  Function fcn, Field target, ImplicitThisFieldAccess access
) {
  analyzableImplicitThisFieldAccess(access) and
  target = access.getTarget() and
  fcn = access.getEnclosingFunction()
}

private predicate analyzableVariable(VariableAccess access) {
  not access instanceof FieldAccess and
  strictcount(access.getTarget()) = 1
}

private predicate mk_Variable(Variable x, VariableAccess access) {
  analyzableVariable(access) and
  x = access.getTarget()
}

private predicate analyzableConversion(Conversion conv) {
  strictcount(conv.getUnspecifiedType()) = 1 and
  strictcount(conv.getExpr()) = 1
}

private predicate mk_Conversion(Type t, HashCons child, Conversion conv) {
  analyzableConversion(conv) and
  t = conv.getUnspecifiedType() and
  child = hashCons(conv.getExpr())
}

private predicate analyzableBinaryOp(BinaryOperation op) {
  strictcount(op.getLeftOperand().getFullyConverted()) = 1 and
  strictcount(op.getRightOperand().getFullyConverted()) = 1 and
  strictcount(op.getOperator()) = 1
}

private predicate mk_BinaryOp(HashCons lhs, HashCons rhs, string opname, BinaryOperation op) {
  analyzableBinaryOp(op) and
  lhs = hashCons(op.getLeftOperand().getFullyConverted()) and
  rhs = hashCons(op.getRightOperand().getFullyConverted()) and
  opname = op.getOperator()
}

private predicate analyzableUnaryOp(UnaryOperation op) {
  not op instanceof PointerDereferenceExpr and
  strictcount(op.getOperand().getFullyConverted()) = 1 and
  strictcount(op.getOperator()) = 1
}

private predicate mk_UnaryOp(HashCons child, string opname, UnaryOperation op) {
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
  strictcount(ae.getArrayBase().getFullyConverted()) = 1 and
  strictcount(ae.getArrayOffset().getFullyConverted()) = 1
}

private predicate mk_ArrayAccess(HashCons base, HashCons offset, ArrayExpr ae) {
  analyzableArrayAccess(ae) and
  base = hashCons(ae.getArrayBase().getFullyConverted()) and
  offset = hashCons(ae.getArrayOffset().getFullyConverted())
}

private predicate analyzablePointerDereferenceExpr(PointerDereferenceExpr deref) {
  strictcount(deref.getOperand().getFullyConverted()) = 1
}

private predicate mk_Deref(HashCons p, PointerDereferenceExpr deref) {
  analyzablePointerDereferenceExpr(deref) and
  p = hashCons(deref.getOperand().getFullyConverted())
}

private predicate analyzableNonmemberFunctionCall(FunctionCall fc) {
  forall(int i | i in [0 .. fc.getNumberOfArguments() - 1] |
    strictcount(fc.getArgument(i).getFullyConverted()) = 1
  ) and
  strictcount(fc.getTarget()) = 1 and
  not exists(fc.getQualifier())
}

private predicate mk_NonmemberFunctionCall(Function fcn, HC_Args args, FunctionCall fc) {
  fc.getTarget() = fcn and
  analyzableNonmemberFunctionCall(fc) and
  (
    exists(HashCons head, HC_Args tail |
      mk_ArgConsInner(head, tail, fc.getNumberOfArguments() - 1, args, fc)
    )
    or
    fc.getNumberOfArguments() = 0 and
    args = HC_EmptyArgs()
  )
}

private predicate analyzableExprCall(ExprCall ec) {
  forall(int i | i in [0 .. ec.getNumberOfArguments() - 1] |
    strictcount(ec.getArgument(i).getFullyConverted()) = 1
  ) and
  strictcount(ec.getExpr().getFullyConverted()) = 1
}

private predicate mk_ExprCall(HashCons hc, HC_Args args, ExprCall ec) {
  hc.getAnExpr() = ec.getExpr() and
  (
    exists(HashCons head, HC_Args tail |
      mk_ArgConsInner(head, tail, ec.getNumberOfArguments() - 1, args, ec)
    )
    or
    ec.getNumberOfArguments() = 0 and
    args = HC_EmptyArgs()
  )
}

private predicate analyzableMemberFunctionCall(FunctionCall fc) {
  forall(int i | i in [0 .. fc.getNumberOfArguments() - 1] |
    strictcount(fc.getArgument(i).getFullyConverted()) = 1
  ) and
  strictcount(fc.getTarget()) = 1 and
  strictcount(fc.getQualifier().getFullyConverted()) = 1
}

private predicate mk_MemberFunctionCall(Function fcn, HashCons qual, HC_Args args, FunctionCall fc) {
  fc.getTarget() = fcn and
  analyzableMemberFunctionCall(fc) and
  hashCons(fc.getQualifier().getFullyConverted()) = qual and
  (
    exists(HashCons head, HC_Args tail |
      mk_ArgConsInner(head, tail, fc.getNumberOfArguments() - 1, args, fc)
    )
    or
    fc.getNumberOfArguments() = 0 and
    args = HC_EmptyArgs()
  )
}

private predicate analyzableCall(Call c) {
  analyzableNonmemberFunctionCall(c)
  or
  analyzableMemberFunctionCall(c)
  or
  analyzableExprCall(c)
}

/**
 * Holds if `fc` is a call to `fcn`, `fc`'s first `i` arguments have hash-cons
 * `list`, and `fc`'s argument at index `i` has hash-cons `hc`.
 */
private predicate mk_ArgCons(HashCons hc, int i, HC_Args list, Call c) {
  analyzableCall(c) and
  hc = hashCons(c.getArgument(i).getFullyConverted()) and
  (
    exists(HashCons head, HC_Args tail |
      mk_ArgConsInner(head, tail, i - 1, list, c) and
      i > 0
    )
    or
    i = 0 and
    list = HC_EmptyArgs()
  )
}

// avoid a join ordering issue
pragma[noopt]
private predicate mk_ArgConsInner(HashCons head, HC_Args tail, int i, HC_Args list, Call c) {
  list = HC_ArgCons(head, i, tail) and
  mk_ArgCons(head, i, tail, c)
}

/**
 * The 0th argument of an allocator call in a new expression is always an error expression;
 * this works around it
 */
private predicate analyzableAllocatorArgZero(ErrorExpr e) {
  exists(NewOrNewArrayExpr new |
    new.getAllocatorCall().getChild(0) = e and
    strictcount(new.getUnspecifiedType()) = 1
  ) and
  strictcount(NewOrNewArrayExpr new | new.getAllocatorCall().getChild(0) = e) = 1
}

private predicate mk_AllocatorArgZero(Type t, ErrorExpr e) {
  analyzableAllocatorArgZero(e) and
  exists(NewOrNewArrayExpr new |
    new.getAllocatorCall().getChild(0) = e and
    t = new.getUnspecifiedType()
  )
}

private predicate mk_HasInit(HashCons hc, NewOrNewArrayExpr new) {
  hc = hashCons(new.(NewExpr).getInitializer().getFullyConverted()) or
  hc = hashCons(new.(NewArrayExpr).getInitializer().getFullyConverted())
}

private predicate mk_HasAlloc(HashCons hc, NewOrNewArrayExpr new) {
  hc = hashCons(new.(NewExpr).getAllocatorCall().getFullyConverted()) or
  hc = hashCons(new.(NewArrayExpr).getAllocatorCall().getFullyConverted())
}

private predicate mk_HasExtent(HashCons hc, NewArrayExpr new) {
  hc = hashCons(new.getExtent().getFullyConverted())
}

private predicate analyzableNewExpr(NewExpr new) {
  strictcount(new.getAllocatedType().getUnspecifiedType()) = 1 and
  count(new.getAllocatorCall().getFullyConverted()) <= 1 and
  count(new.getInitializer().getFullyConverted()) <= 1
}

private predicate mk_NewExpr(Type t, HC_Alloc alloc, HC_Init init, NewExpr new) {
  analyzableNewExpr(new) and
  t = new.getAllocatedType().getUnspecifiedType() and
  (
    alloc = HC_HasAlloc(hashCons(new.getAllocatorCall().getFullyConverted()))
    or
    not exists(new.getAllocatorCall().getFullyConverted()) and
    alloc = HC_NoAlloc()
  ) and
  (
    init = HC_HasInit(hashCons(new.getInitializer().getFullyConverted()))
    or
    not exists(new.getInitializer().getFullyConverted()) and
    init = HC_NoInit()
  )
}

private predicate analyzableNewArrayExpr(NewArrayExpr new) {
  strictcount(new.getAllocatedType().getUnspecifiedType()) = 1 and
  count(new.getAllocatorCall().getFullyConverted()) <= 1 and
  count(new.getInitializer().getFullyConverted()) <= 1 and
  count(new.getExtent().getFullyConverted()) <= 1
}

private predicate mk_NewArrayExpr(
  Type t, HC_Alloc alloc, HC_Extent extent, HC_Init init, NewArrayExpr new
) {
  analyzableNewArrayExpr(new) and
  t = new.getAllocatedType() and
  (
    alloc = HC_HasAlloc(hashCons(new.getAllocatorCall().getFullyConverted()))
    or
    not exists(new.getAllocatorCall().getFullyConverted()) and
    alloc = HC_NoAlloc()
  ) and
  (
    init = HC_HasInit(hashCons(new.getInitializer().getFullyConverted()))
    or
    not exists(new.getInitializer().getFullyConverted()) and
    init = HC_NoInit()
  ) and
  (
    extent = HC_HasExtent(hashCons(new.getExtent().getFullyConverted()))
    or
    not exists(new.getExtent().getFullyConverted()) and
    extent = HC_NoExtent()
  )
}

private predicate analyzableDeleteExpr(DeleteExpr e) {
  strictcount(e.getAChild().getFullyConverted()) = 1
}

private predicate mk_DeleteExpr(HashCons hc, DeleteExpr e) {
  analyzableDeleteExpr(e) and
  hc = hashCons(e.getAChild().getFullyConverted())
}

private predicate analyzableDeleteArrayExpr(DeleteArrayExpr e) {
  strictcount(e.getAChild().getFullyConverted()) = 1
}

private predicate mk_DeleteArrayExpr(HashCons hc, DeleteArrayExpr e) {
  analyzableDeleteArrayExpr(e) and
  hc = hashCons(e.getAChild().getFullyConverted())
}

private predicate analyzableSizeofType(SizeofTypeOperator e) {
  strictcount(e.getUnspecifiedType()) = 1 and
  strictcount(e.getTypeOperand()) = 1
}

private predicate mk_SizeofType(Type t, SizeofTypeOperator e) {
  analyzableSizeofType(e) and
  t = e.getTypeOperand()
}

private predicate analyzableSizeofExpr(Expr e) {
  e instanceof SizeofExprOperator and
  strictcount(e.getAChild().getFullyConverted()) = 1
}

private predicate mk_SizeofExpr(HashCons child, SizeofExprOperator e) {
  analyzableSizeofExpr(e) and
  child = hashCons(e.getAChild())
}

private predicate analyzableUuidofOperator(UuidofOperator e) { strictcount(e.getTypeOperand()) = 1 }

private predicate mk_UuidofOperator(Type t, UuidofOperator e) {
  analyzableUuidofOperator(e) and
  t = e.getTypeOperand()
}

private predicate analyzableTypeidType(TypeidOperator e) {
  count(e.getAChild()) = 0 and
  strictcount(e.getResultType()) = 1
}

private predicate mk_TypeidType(Type t, TypeidOperator e) {
  analyzableTypeidType(e) and
  t = e.getResultType()
}

private predicate analyzableTypeidExpr(Expr e) {
  e instanceof TypeidOperator and
  strictcount(e.getAChild().getFullyConverted()) = 1
}

private predicate mk_TypeidExpr(HashCons child, TypeidOperator e) {
  analyzableTypeidExpr(e) and
  child = hashCons(e.getAChild())
}

private predicate analyzableAlignofType(AlignofTypeOperator e) {
  strictcount(e.getUnspecifiedType()) = 1 and
  strictcount(e.getTypeOperand()) = 1
}

private predicate mk_AlignofType(Type t, AlignofTypeOperator e) {
  analyzableAlignofType(e) and
  t = e.getTypeOperand()
}

private predicate analyzableAlignofExpr(AlignofExprOperator e) {
  strictcount(e.getExprOperand()) = 1
}

private predicate mk_AlignofExpr(HashCons child, AlignofExprOperator e) {
  analyzableAlignofExpr(e) and
  child = hashCons(e.getAChild())
}

/**
 * Gets the hash cons of field initializer expressions [0..i), where i > 0, for
 * the class aggregate literal `cal` of type `c`, where `head` is the hash cons
 * of the i'th initializer expression.
 */
HC_Fields aggInitExprsUpTo(ClassAggregateLiteral cal, Class c, int i) {
  exists(Field f, HashCons head, HC_Fields tail |
    result = HC_FieldCons(c, i - 1, f, head, tail) and
    mk_FieldCons(c, i - 1, f, head, tail, cal)
  )
}

private predicate mk_FieldCons(
  Class c, int i, Field f, HashCons hc, HC_Fields hcf, ClassAggregateLiteral cal
) {
  analyzableClassAggregateLiteral(cal) and
  cal.getUnspecifiedType() = c and
  exists(Expr e |
    e = cal.getFieldExpr(f).getFullyConverted() and
    f.getInitializationOrder() = i and
    (
      hc = hashCons(e) and
      hcf = aggInitExprsUpTo(cal, c, i)
      or
      hc = hashCons(e) and
      i = 0 and
      hcf = HC_EmptyFields(c)
    )
  )
}

private predicate analyzableClassAggregateLiteral(ClassAggregateLiteral cal) {
  forall(int i | exists(cal.getChild(i)) |
    strictcount(cal.getChild(i).getFullyConverted()) = 1 and
    strictcount(Field f | cal.getChild(i) = cal.getFieldExpr(f)) = 1 and
    strictcount(Field f, int j |
      cal.getFieldExpr(f) = cal.getChild(i) and j = f.getInitializationOrder()
    ) = 1
  )
}

private predicate mk_ClassAggregateLiteral(Class c, HC_Fields hcf, ClassAggregateLiteral cal) {
  analyzableClassAggregateLiteral(cal) and
  c = cal.getUnspecifiedType() and
  (
    hcf = aggInitExprsUpTo(cal, c, cal.getNumChild())
    or
    cal.getNumChild() = 0 and
    hcf = HC_EmptyFields(c)
  )
}

private predicate analyzableArrayAggregateLiteral(ArrayAggregateLiteral aal) {
  forall(int i | exists(aal.getChild(i)) | strictcount(aal.getChild(i).getFullyConverted()) = 1) and
  strictcount(aal.getUnspecifiedType()) = 1
}

/**
 * Gets the hash cons of array elements in [0..i), where i > 0, for
 * the array aggregate literal `aal` of type `t`.
 */
private HC_Array arrayElemsUpTo(ArrayAggregateLiteral aal, Type t, int i) {
  exists(HC_Array tail, HashCons head |
    result = HC_ArrayCons(t, i - 1, head, tail) and
    mk_ArrayCons(t, i - 1, head, tail, aal)
  )
}

private predicate mk_ArrayCons(Type t, int i, HashCons hc, HC_Array hca, ArrayAggregateLiteral aal) {
  analyzableArrayAggregateLiteral(aal) and
  t = aal.getUnspecifiedType() and
  hc = hashCons(aal.getChild(i)) and
  (
    hca = arrayElemsUpTo(aal, t, i)
    or
    i = 0 and
    hca = HC_EmptyArray(t)
  )
}

private predicate mk_ArrayAggregateLiteral(Type t, HC_Array hca, ArrayAggregateLiteral aal) {
  t = aal.getUnspecifiedType() and
  (
    exists(HashCons head, HC_Array tail, int numElements |
      numElements = aal.getNumChild() and
      hca = HC_ArrayCons(t, numElements - 1, head, tail) and
      mk_ArrayCons(t, numElements - 1, head, tail, aal)
    )
    or
    aal.getNumChild() = 0 and
    hca = HC_EmptyArray(t)
  )
}

private predicate analyzableThrowExpr(ThrowExpr te) {
  strictcount(te.getExpr().getFullyConverted()) = 1
}

private predicate mk_ThrowExpr(HashCons hc, ThrowExpr te) {
  analyzableThrowExpr(te) and
  hc.getAnExpr() = te.getExpr().getFullyConverted()
}

private predicate analyzableReThrowExpr(ReThrowExpr rte) { any() }

private predicate mk_ReThrowExpr(ReThrowExpr te) { any() }

private predicate analyzableConditionalExpr(ConditionalExpr ce) {
  strictcount(ce.getCondition().getFullyConverted()) = 1 and
  strictcount(ce.getThen().getFullyConverted()) = 1 and
  strictcount(ce.getElse().getFullyConverted()) = 1
}

private predicate mk_ConditionalExpr(
  HashCons cond, HashCons trueHc, HashCons falseHc, ConditionalExpr ce
) {
  analyzableConditionalExpr(ce) and
  cond.getAnExpr() = ce.getCondition() and
  trueHc.getAnExpr() = ce.getThen() and
  falseHc.getAnExpr() = ce.getElse()
}

private predicate analyzableNoExceptExpr(NoExceptExpr nee) {
  strictcount(nee.getAChild().getFullyConverted()) = 1
}

private predicate mk_NoExceptExpr(HashCons child, NoExceptExpr nee) {
  analyzableNoExceptExpr(nee) and
  nee.getExpr().getFullyConverted() = child.getAnExpr()
}

/** Gets the hash-cons of expression `e`. */
cached
HashCons hashCons(Expr e) {
  exists(int val, Type t |
    mk_IntLiteral(val, t, e) and
    result = HC_IntLiteral(val, t)
  )
  or
  exists(EnumConstant val, Type t |
    mk_EnumConstantAccess(val, t, e) and
    result = HC_EnumConstantAccess(val, t)
  )
  or
  exists(float val, Type t |
    mk_FloatLiteral(val, t, e) and
    result = HC_FloatLiteral(val, t)
  )
  or
  exists(string val, Type t |
    mk_StringLiteral(val, t, e) and
    result = HC_StringLiteral(val, t)
  )
  or
  exists(Variable x |
    mk_Variable(x, e) and
    result = HC_Variable(x)
  )
  or
  exists(HashCons qualifier, Field target |
    mk_DotFieldAccess(qualifier, target, e) and
    result = HC_FieldAccess(qualifier, target)
  )
  or
  exists(HashCons qualifier, Field target |
    mk_PointerFieldAccess(qualifier, target, e) and
    result = HC_PointerFieldAccess(qualifier, target)
  )
  or
  exists(Function fcn, Field target |
    mk_ImplicitThisFieldAccess(fcn, target, e) and
    result = HC_ImplicitThisFieldAccess(fcn, target)
  )
  or
  exists(Function fcn |
    mk_ThisExpr(fcn, e) and
    result = HC_ThisExpr(fcn)
  )
  or
  exists(Type t, HashCons child |
    mk_Conversion(t, child, e) and
    result = HC_Conversion(t, child)
  )
  or
  exists(HashCons lhs, HashCons rhs, string opname |
    mk_BinaryOp(lhs, rhs, opname, e) and
    result = HC_BinaryOp(lhs, rhs, opname)
  )
  or
  exists(HashCons child, string opname |
    mk_UnaryOp(child, opname, e) and
    result = HC_UnaryOp(child, opname)
  )
  or
  exists(HashCons x, HashCons i |
    mk_ArrayAccess(x, i, e) and
    result = HC_ArrayAccess(x, i)
  )
  or
  exists(HashCons p |
    mk_Deref(p, e) and
    result = HC_Deref(p)
  )
  or
  exists(Function fcn, HC_Args args |
    mk_NonmemberFunctionCall(fcn, args, e) and
    result = HC_NonmemberFunctionCall(fcn, args)
  )
  or
  exists(HashCons hc, HC_Args args |
    mk_ExprCall(hc, args, e) and
    result = HC_ExprCall(hc, args)
  )
  or
  exists(Function fcn, HashCons qual, HC_Args args |
    mk_MemberFunctionCall(fcn, qual, args, e) and
    result = HC_MemberFunctionCall(fcn, qual, args)
  )
  or
  // works around an extractor issue
  exists(Type t |
    mk_AllocatorArgZero(t, e) and
    result = HC_AllocatorArgZero(t)
  )
  or
  exists(Type t, HC_Alloc alloc, HC_Init init |
    mk_NewExpr(t, alloc, init, e) and
    result = HC_NewExpr(t, alloc, init)
  )
  or
  exists(Type t, HC_Alloc alloc, HC_Extent extent, HC_Init init |
    mk_NewArrayExpr(t, alloc, extent, init, e) and
    result = HC_NewArrayExpr(t, alloc, extent, init)
  )
  or
  exists(Type t |
    mk_SizeofType(t, e) and
    result = HC_SizeofType(t)
  )
  or
  exists(HashCons child |
    mk_SizeofExpr(child, e) and
    result = HC_SizeofExpr(child)
  )
  or
  exists(Type t |
    mk_TypeidType(t, e) and
    result = HC_TypeidType(t)
  )
  or
  exists(HashCons child |
    mk_TypeidExpr(child, e) and
    result = HC_TypeidExpr(child)
  )
  or
  exists(Type t |
    mk_UuidofOperator(t, e) and
    result = HC_UuidofOperator(t)
  )
  or
  exists(Type t |
    mk_AlignofType(t, e) and
    result = HC_AlignofType(t)
  )
  or
  exists(HashCons child |
    mk_AlignofExpr(child, e) and
    result = HC_AlignofExpr(child)
  )
  or
  exists(Class c, HC_Fields hfc |
    mk_ClassAggregateLiteral(c, hfc, e) and
    result = HC_ClassAggregateLiteral(c, hfc)
  )
  or
  exists(Type t, HC_Array hca |
    mk_ArrayAggregateLiteral(t, hca, e) and
    result = HC_ArrayAggregateLiteral(t, hca)
  )
  or
  exists(HashCons child |
    mk_DeleteExpr(child, e) and
    result = HC_DeleteExpr(child)
  )
  or
  exists(HashCons child |
    mk_DeleteArrayExpr(child, e) and
    result = HC_DeleteArrayExpr(child)
  )
  or
  exists(HashCons child |
    mk_ThrowExpr(child, e) and
    result = HC_ThrowExpr(child)
  )
  or
  mk_ReThrowExpr(e) and
  result = HC_ReThrowExpr()
  or
  exists(HashCons cond, HashCons thenHC, HashCons elseHC |
    mk_ConditionalExpr(cond, thenHC, elseHC, e) and
    result = HC_ConditionalExpr(cond, thenHC, elseHC)
  )
  or
  mk_Nullptr(e) and
  result = HC_Nullptr()
  or
  not analyzableExpr(e, _) and result = HC_Unanalyzable(e)
}

/**
 * Holds if the expression is explicitly handled by `hashCons`.
 * Unanalyzable expressions still need to be given a hash-cons,
 * but it will be a unique number that is not shared with any other
 * expression.
 */
predicate analyzableExpr(Expr e, string kind) {
  analyzableIntLiteral(e) and kind = "IntLiteral"
  or
  analyzableEnumConstantAccess(e) and kind = "EnumConstantAccess"
  or
  analyzableFloatLiteral(e) and kind = "FloatLiteral"
  or
  analyzableStringLiteral(e) and kind = "StringLiteral"
  or
  analyzableNullptr(e) and kind = "Nullptr"
  or
  analyzableDotFieldAccess(e) and kind = "DotFieldAccess"
  or
  analyzablePointerFieldAccess(e) and kind = "PointerFieldAccess"
  or
  analyzableImplicitThisFieldAccess(e) and kind = "ImplicitThisFieldAccess"
  or
  analyzableVariable(e) and kind = "Variable"
  or
  analyzableConversion(e) and kind = "Conversion"
  or
  analyzableBinaryOp(e) and kind = "BinaryOp"
  or
  analyzableUnaryOp(e) and kind = "UnaryOp"
  or
  analyzableThisExpr(e) and kind = "ThisExpr"
  or
  analyzableArrayAccess(e) and kind = "ArrayAccess"
  or
  analyzablePointerDereferenceExpr(e) and kind = "PointerDereferenceExpr"
  or
  analyzableNonmemberFunctionCall(e) and kind = "NonmemberFunctionCall"
  or
  analyzableMemberFunctionCall(e) and kind = "MemberFunctionCall"
  or
  analyzableExprCall(e) and kind = "ExprCall"
  or
  analyzableNewExpr(e) and kind = "NewExpr"
  or
  analyzableNewArrayExpr(e) and kind = "NewArrayExpr"
  or
  analyzableSizeofType(e) and kind = "SizeofTypeOperator"
  or
  analyzableSizeofExpr(e) and kind = "SizeofExprOperator"
  or
  analyzableAlignofType(e) and kind = "AlignofTypeOperator"
  or
  analyzableAlignofExpr(e) and kind = "AlignofExprOperator"
  or
  analyzableUuidofOperator(e) and kind = "UuidofOperator"
  or
  analyzableTypeidType(e) and kind = "TypeidType"
  or
  analyzableTypeidExpr(e) and kind = "TypeidExpr"
  or
  analyzableClassAggregateLiteral(e) and kind = "ClassAggregateLiteral"
  or
  analyzableArrayAggregateLiteral(e) and kind = "ArrayAggregateLiteral"
  or
  analyzableDeleteExpr(e) and kind = "DeleteExpr"
  or
  analyzableDeleteArrayExpr(e) and kind = "DeleteArrayExpr"
  or
  analyzableThrowExpr(e) and kind = "ThrowExpr"
  or
  analyzableReThrowExpr(e) and kind = "ReThrowExpr"
  or
  analyzableConditionalExpr(e) and kind = "ConditionalExpr"
  or
  analyzableNoExceptExpr(e) and kind = "NoExceptExpr"
  or
  analyzableAllocatorArgZero(e) and kind = "AllocatorArgZero"
}
