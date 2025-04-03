import csharp

/**
 * A hash-cons representation of an expression.
 *
 * Note: Here is how you go about adding a hash cons for a new expression:
 *
 * Step 1: Add a branch to this IPA type.
 * Step 2: Add a disjunct to `numberableExpr`.
 * Step 3: Add a disjunct to `nonUniqueHashCons`.
 *
 * Notes on performance:
 * - Care must be taken not to have `numberableExpr` depend on `THashCons`.
 *   Since `THashCons` already depends on `numberableExpr` this would introduce
 *   unnecessary recursion that would ruin performance.
 * - This library uses lots of non-linear recursion (i.e., more than one
 *   recursive call in a single disjunct). Care must be taken to ensure good
 *   performance when dealing with non-linear recursion. For example, consider
 *   a snippet such as:
 *   ```ql
 *   predicate foo(BinaryExpr bin) {
 *     interesting(bin) and
 *     foo(bin.getLeft()) and
 *     foo(bin.getRight())
 *   }
 *   ```
 *   to ensure that `foo` is joined optimally it should be rewritten to:
 *
 *   ```ql
 *   pragma[nomagic]
 *   predicate fooLeft(BinaryExpr bin) {
 *     interesting(bin) and
 *     foo(bin.getLeft())
 *   }
 *
 *   pragma[nomagic]
 *   predicate fooRight(BinaryExpr bin) {
 *     interesting(bin) and
 *     foo(bin.getRight())
 *   }
 *
 *   predicate foo(BinaryExpr bin) {
 *     fooLeft(bin) and
 *     fooRight(bin)
 *   }
 *   ```
 */
cached
private newtype THashCons =
  TVariableAccessHashCons(LocalScopeVariable v) { variableAccessHashCons(_, v) } or
  TConstantHashCons(Type type, string value) { constantHashCons(_, type, value) } or
  TFieldAccessHashCons(Field field, THashCons qualifier) {
    fieldAccessHashCons(_, field, qualifier)
  } or
  TPropertyAccessHashCons(Property prop, THashCons qualifier) {
    propertyAccessHashCons(_, prop, qualifier)
  } or
  TBinaryHashCons(string operator, THashCons left, THashCons right) {
    binaryHashCons(_, operator, left, right)
  } or
  TThisHashCons() or
  TBaseHashCons() or
  TTypeAccessHashCons(Type t) { typeAccessHashCons(_, t) } or
  TDefaultValueWithoutTypeHashCons() or
  TDefaultValueWithTypeHashCons(THashCons typeAccess) {
    defaultValueWithTypeHashCons(_, typeAccess)
  } or
  TIndexerAccessHashCons(Indexer i) { indexerAccessHashCons(_, i) } or
  TEventAccessHashCons(Event ev) { eventAccessHashCons(_, ev) } or
  TDynamicMemberAccessHashCons(DynamicMember dm) { dynamicMemberAccessHashCons(_, dm) } or
  TTypeOfHashCons(THashCons typeAccess) { typeOfHashCons(_, typeAccess) } or
  TUnaryHashCons(string operator, THashCons operand) { unaryHashCons(_, operator, operand) } or
  TConditionalHashCons(THashCons cond, THashCons then_, THashCons else_) {
    conditionalHashCons(_, cond, then_, else_)
  } or
  TMethodCallHashCons(string name, CallHashCons::TListPartialHashCons args) {
    methodCallHashCons(_, name, args)
  } or
  TConstructorInitializerCallHashCons(string name, CallHashCons::TListPartialHashCons args) {
    constructorInitializerCallHashCons(_, name, args)
  } or
  TOperatorCallHashCons(string name, CallHashCons::TListPartialHashCons args) {
    operatorCallHashCons(_, name, args)
  } or
  TDelegateLikeCallHashCons(THashCons expr, CallHashCons::TListPartialHashCons args) {
    delegateLikeCallHashCons(_, expr, args)
  } or
  TObjectCreationHashCons(string name, CallHashCons::TListPartialHashCons args) {
    objectCreationHashCons(_, name, args)
  } or
  TCastHashCons(Type targetType, THashCons expr) { castHashCons(_, targetType, expr) } or
  TAssignmentHashCons(string operator, THashCons left, THashCons right) {
    assignmentHashCons(_, operator, left, right)
  } or
  TArrayAccessHashCons(THashCons index, THashCons qualifier) {
    arrayAccessHashCons(_, index, qualifier)
  } or
  TArrayInitializerHashCons(ArrayInitializerHashCons::TListPartialHashCons list) {
    arrayInitializerHashCons(_, list)
  } or
  TArrayCreationHashCons(THashCons initializer, ArrayCreationHashCons::TListPartialHashCons lengths) {
    arrayCreationHashCons(_, initializer, lengths)
  } or
  TLocalVariableDeclWithInitializerHashCons(Variable v, THashCons initializer) {
    localVariableDeclWithInitializerHashCons(_, v, initializer)
  } or
  TLocalVariableDeclWithoutInitializerHashCons(Variable v) {
    localVariableDeclWithoutInitializerHashCons(_, v)
  } or
  TDefineSymbolHashCons(string name) { defineSymbolHashCons(_, name) } or
  TUniqueHashCons(Expr e) { uniqueHashCons(e) }

private predicate variableAccessHashCons(LocalScopeVariableAccess va, LocalScopeVariable v) {
  numberableExpr(va) and
  va.getTarget() = v
}

private predicate constantHashCons(Literal lit, Type t, string value) {
  numberableExpr(lit) and
  lit.getType() = t and
  lit.getValue() = value
}

private predicate fieldAccessHashCons(FieldAccess fa, Field f, THashCons qualifier) {
  numberableExpr(fa) and
  hashCons(fa.getQualifier()) = qualifier and
  fa.getTarget() = f
}

private predicate propertyAccessHashCons(PropertyAccess pa, Property prop, THashCons qualifier) {
  numberableExpr(pa) and
  hashCons(pa.getQualifier()) = qualifier and
  pa.getTarget() = prop
}

pragma[nomagic]
private predicate binaryHashConsLeft(BinaryOperation binary, THashCons h) {
  numberableExpr(binary) and
  hashCons(binary.getLeftOperand()) = h
}

pragma[nomagic]
private predicate binaryHashConsRight(BinaryOperation binary, THashCons h) {
  numberableExpr(binary) and
  hashCons(binary.getRightOperand()) = h
}

private predicate binaryHashCons(
  BinaryOperation binary, string operator, THashCons left, THashCons right
) {
  binaryHashConsLeft(binary, left) and
  binaryHashConsRight(binary, right) and
  binary.getOperator() = operator
}

private predicate unaryHashCons(UnaryOperation unary, string operator, THashCons operand) {
  numberableExpr(unary) and
  hashCons(unary.getOperand()) = operand and
  unary.getOperator() = operator
}

pragma[nomagic]
private predicate conditionalHashConsCond(ConditionalExpr condExpr, THashCons cond) {
  numberableExpr(condExpr) and
  hashCons(condExpr.getCondition()) = cond
}

pragma[nomagic]
private predicate conditionalHashConsThen(ConditionalExpr condExpr, THashCons then_) {
  numberableExpr(condExpr) and
  hashCons(condExpr.getThen()) = then_
}

pragma[nomagic]
private predicate conditionalHashConsElse(ConditionalExpr condExpr, THashCons else_) {
  numberableExpr(condExpr) and
  hashCons(condExpr.getElse()) = else_
}

private predicate conditionalHashCons(
  ConditionalExpr condExpr, THashCons cond, THashCons then_, THashCons else_
) {
  numberableExpr(condExpr) and
  conditionalHashConsCond(condExpr, cond) and
  conditionalHashConsThen(condExpr, then_) and
  conditionalHashConsElse(condExpr, else_)
}

private predicate typeAccessHashCons(TypeAccess ta, Type t) { ta.getTarget() = t }

private predicate indexerAccessHashCons(IndexerAccess ia, Indexer i) { ia.getTarget() = i }

private predicate eventAccessHashCons(EventAccess ea, Event e) { ea.getTarget() = e }

private predicate dynamicMemberAccessHashCons(DynamicMemberAccess dma, DynamicMember dm) {
  dma.getTarget() = dm
}

private predicate thisHashCons(ThisAccess ta) { any() }

private predicate baseHashCons(BaseAccess ba) { any() }

private predicate defaultValueWithTypeHashCons(DefaultValueExpr dve, THashCons typeAccess) {
  hashCons(dve.getTypeAccess()) = typeAccess
}

private predicate defaultValueWithoutTypeHashCons(DefaultValueExpr dve) {
  not exists(dve.getTypeAccess())
}

private predicate castHashCons(Cast cast, Type targetType, THashCons expr) {
  // By not using hashCons(cast.getTypeAccess) we avoid unnecessary non-linear recursion
  targetType = cast.getType() and
  hashCons(cast.getExpr()) = expr
}

pragma[nomagic]
private predicate assignmentHashConsLeft(Assignment a, THashCons left) {
  numberableAssignment(a) and
  hashCons(a.getLValue()) = left
}

pragma[nomagic]
private predicate assignmentHashConsRight(Assignment a, THashCons right) {
  numberableAssignment(a) and
  hashCons(a.getRValue()) = right
}

private predicate assignmentHashCons(Assignment a, string operator, THashCons left, THashCons right) {
  a.getOperator() = operator and
  assignmentHashConsLeft(a, left) and
  assignmentHashConsRight(a, right)
}

private predicate typeOfHashCons(TypeofExpr typeOf, THashCons typeAccess) {
  numberableExpr(typeOf) and
  hashCons(typeOf.getTypeAccess()) = typeAccess
}

private predicate arrayAccessHashCons(ArrayAccess aa, THashCons index, THashCons qualifier) {
  numberableExpr(aa) and
  // TODO: This is a bit lazy. We should really do something similar to what we do for all arguments
  index = hashCons(unique( | | aa.getAnIndex())) and
  qualifier = hashCons(aa.getQualifier())
}

private signature module ListHashConsInputSig {
  class List {
    string toString();
  }

  Expr getExpr(List l, int i);
}

private module ListHashCons<ListHashConsInputSig Input> {
  private import Input

  int getNumberOfExprs(List list) { result = count(int i | exists(getExpr(list, i)) | i) }

  private predicate listArgsAreNumberable(List list, int remaining) {
    getNumberOfExprs(list) = remaining
    or
    exists(Expr e |
      listArgsAreNumberable(list, remaining + 1) and
      e = getExpr(list, remaining) and
      numberableExpr(e)
    )
  }

  final class FinalList = List;

  class NumberableList extends FinalList {
    NumberableList() { listArgsAreNumberable(this, 0) }
  }

  pragma[nomagic]
  predicate listHashCons(NumberableList list, TListPartialHashCons args) {
    listPartialHashCons(list, getNumberOfExprs(list), args)
  }

  pragma[nomagic]
  private predicate listPartialHashCons(NumberableList list, int index, TListPartialHashCons head) {
    exists(list) and
    index = 0 and
    head = TNilArgument()
    or
    exists(TListPartialHashCons prev, THashCons prevHashCons |
      listPartialHashCons(list, index - 1, pragma[only_bind_out](prev)) and
      listArgHashCons(list, index - 1, pragma[only_bind_into](prevHashCons)) and
      head = TArgument(prev, prevHashCons)
    )
  }

  pragma[nomagic]
  private predicate listArgHashCons(NumberableList list, int index, THashCons arg) {
    hashCons(getExpr(list, index)) = arg
  }

  newtype TListPartialHashCons =
    TNilArgument() or
    TArgument(TListPartialHashCons head, THashCons arg) {
      exists(NumberableList call, int index |
        listArgHashCons(call, index, arg) and
        listPartialHashCons(call, index, head)
      )
    }
}

private module CallHashConsInput implements ListHashConsInputSig {
  class List = Call;

  Expr getExpr(List l, int i) { result = l.getArgument(i) }
}

private module CallHashCons = ListHashCons<CallHashConsInput>;

private predicate methodCallHashCons(
  MethodCall call, string name, CallHashCons::TListPartialHashCons args
) {
  numberableExpr(call) and
  call.getTarget().getName() = name and
  CallHashCons::listHashCons(call, args)
}

private predicate constructorInitializerCallHashCons(
  ConstructorInitializer call, string name, CallHashCons::TListPartialHashCons args
) {
  CallHashCons::listHashCons(call, args) and
  call.getTarget().getName() = name
}

private predicate operatorCallHashCons(
  OperatorCall call, string name, CallHashCons::TListPartialHashCons args
) {
  CallHashCons::listHashCons(call, args) and
  call.getTarget().getName() = name
}

private predicate delegateLikeCallHashCons(
  DelegateLikeCall call, THashCons expr, CallHashCons::TListPartialHashCons args
) {
  numberableExpr(call) and
  CallHashCons::listHashCons(call, args) and
  hashCons(call.getExpr()) = expr
}

private predicate objectCreationHashCons(
  ObjectCreation oc, string name, CallHashCons::TListPartialHashCons args
) {
  oc.getTarget().getName() = name and
  CallHashCons::listHashCons(oc, args)
}

private module ArrayInitializerHashConsInput implements ListHashConsInputSig {
  class List extends ArrayInitializer {
    List() {
      // For performance reasons we restrict this to "small" array initializers.
      this.getNumberOfElements() < 256
    }
  }

  Expr getExpr(List l, int i) { result = l.getElement(i) }
}

private module ArrayInitializerHashCons = ListHashCons<ArrayInitializerHashConsInput>;

private module ArrayCreationHashConsInput implements ListHashConsInputSig {
  class List = ArrayCreation;

  Expr getExpr(List l, int i) { result = l.getLengthArgument(i) }
}

private module ArrayCreationHashCons = ListHashCons<ArrayCreationHashConsInput>;

private predicate arrayCreationHashCons(
  ArrayCreation ac, THashCons initializer, ArrayCreationHashCons::TListPartialHashCons lengths
) {
  tHashCons(ac.getInitializer()) = initializer and
  ArrayCreationHashCons::listHashCons(ac, lengths)
}

private predicate arrayInitializerHashCons(
  ArrayInitializer ai, ArrayInitializerHashCons::TListPartialHashCons list
) {
  ArrayInitializerHashCons::listHashCons(ai, list)
}

private predicate localVariableDeclWithInitializerHashCons(
  LocalVariableDeclExpr lvd, LocalVariable v, THashCons initializer
) {
  lvd.getVariable() = v and
  tHashCons(lvd.getInitializer()) = initializer
}

private predicate localVariableDeclWithoutInitializerHashCons(
  LocalVariableDeclExpr lvd, LocalVariable v
) {
  lvd.getVariable() = v and
  not exists(lvd.getInitializer())
}

private predicate defineSymbolHashCons(DefineSymbolExpr dse, string name) { dse.getName() = name }

pragma[nomagic]
private predicate numberableBinaryLeftExpr(BinaryOperation binary) {
  numberableExpr(binary.getLeftOperand())
}

pragma[nomagic]
private predicate numberableBinaryRightExpr(BinaryOperation binary) {
  numberableExpr(binary.getRightOperand())
}

private predicate numberableBinaryExpr(BinaryOperation binary) {
  numberableBinaryLeftExpr(binary) and
  numberableBinaryRightExpr(binary)
}

pragma[nomagic]
private predicate numberableDelegateLikeCallExpr(DelegateLikeCall dc) {
  numberableExpr(dc.getExpr())
}

private predicate numberableCall(Call c) {
  c instanceof CallHashCons::NumberableList and
  (
    c instanceof MethodCall
    or
    c instanceof ConstructorInitializer
    or
    c instanceof OperatorCall
    or
    numberableDelegateLikeCallExpr(c)
    or
    c instanceof ObjectCreation
  )
}

pragma[nomagic]
private predicate numberableConditionalCond(ConditionalExpr cond) {
  numberableExpr(cond.getCondition())
}

pragma[nomagic]
private predicate numberableConditionalThen(ConditionalExpr cond) { numberableExpr(cond.getThen()) }

pragma[nomagic]
private predicate numberableConditionalElse(ConditionalExpr cond) { numberableExpr(cond.getElse()) }

private predicate numberableConditional(ConditionalExpr cond) {
  numberableConditionalCond(cond) and
  numberableConditionalThen(cond) and
  numberableConditionalElse(cond)
}

private predicate numberableDefaultValue(DefaultValueExpr dve) {
  not exists(dve.getTypeAccess())
  or
  numberableExpr(dve.getTypeAccess())
}

private predicate numberableCast(Cast cast) { numberableExpr(cast.getExpr()) }

private predicate numberableAssignment(Assignment a) {
  numberableExpr(a.getLValue()) and
  numberableExpr(a.getRValue())
}

private predicate numberableTypeOfAccess(TypeofExpr typeOf) {
  numberableExpr(typeOf.getTypeAccess())
}

private predicate numberableArrayAccess(ArrayAccess aa) {
  numberableExpr(aa.getQualifier()) and
  count(aa.getAnIndex()) = 1
}

private predicate numberableArrayInitializer(ArrayInitializer init) {
  init.getNumberOfElements() < 256 and
  init instanceof ArrayInitializerHashCons::NumberableList
}

private predicate numberableArrayCreation(ArrayCreation ac) {
  numberableExpr(ac.getInitializer()) and
  ac instanceof ArrayCreationHashCons::NumberableList
}

private predicate numberableLocalVariableDecl(LocalVariableDeclExpr lvd) {
  not exists(lvd.getInitializer())
  or
  numberableExpr(lvd.getInitializer())
}

/**
 * Holds if `e` can be assigned a non-unique hashcons.
 *
 * Note: This predicate _must not_ depend on `THashCons`.
 */
private predicate numberableExpr(Expr e) {
  e instanceof LocalScopeVariableAccess
  or
  e instanceof FieldAccess
  or
  e instanceof Literal
  or
  e instanceof TypeAccess
  or
  e instanceof IndexerAccess
  or
  e instanceof EventAccess
  or
  e instanceof DynamicMemberAccess
  or
  e instanceof DefineSymbolExpr
  or
  numberableExpr(e.(FieldAccess).getQualifier())
  or
  numberableExpr(e.(PropertyAccess).getQualifier())
  or
  numberableBinaryExpr(e)
  or
  numberableExpr(e.(UnaryOperation).getOperand())
  or
  numberableCall(e)
  or
  numberableConditional(e)
  or
  e instanceof ThisAccess
  or
  e instanceof BaseAccess
  or
  numberableDefaultValue(e)
  or
  numberableCast(e)
  or
  numberableAssignment(e)
  or
  numberableTypeOfAccess(e)
  or
  numberableArrayAccess(e)
  or
  numberableArrayInitializer(e)
  or
  numberableArrayCreation(e)
  or
  numberableLocalVariableDecl(e)
}

/**
 * Gets the non-unique hashcons for `e`, if any.
 */
private THashCons nonUniqueHashCons(Expr e) {
  exists(LocalScopeVariable v |
    variableAccessHashCons(e, v) and
    result = TVariableAccessHashCons(v)
  )
  or
  exists(Type type, string value |
    constantHashCons(e, type, value) and
    result = TConstantHashCons(type, value)
  )
  or
  exists(Field field, THashCons qualifier |
    fieldAccessHashCons(e, field, qualifier) and
    result = TFieldAccessHashCons(field, qualifier)
  )
  or
  exists(Property prop, THashCons qualifier |
    propertyAccessHashCons(e, prop, qualifier) and
    result = TPropertyAccessHashCons(prop, qualifier)
  )
  or
  exists(string operator, THashCons left, THashCons right |
    binaryHashCons(e, operator, left, right) and
    result = TBinaryHashCons(operator, left, right)
  )
  or
  exists(string operator, THashCons operand |
    unaryHashCons(e, operator, operand) and
    result = TUnaryHashCons(operator, operand)
  )
  or
  exists(THashCons cond, THashCons then_, THashCons else_ |
    conditionalHashCons(e, cond, then_, else_) and
    result = TConditionalHashCons(cond, then_, else_)
  )
  or
  exists(Type t |
    typeAccessHashCons(e, t) and
    result = TTypeAccessHashCons(t)
  )
  or
  exists(Indexer i |
    indexerAccessHashCons(e, i) and
    result = TIndexerAccessHashCons(i)
  )
  or
  exists(Event ev |
    eventAccessHashCons(e, ev) and
    result = TEventAccessHashCons(ev)
  )
  or
  exists(DynamicMember dm |
    dynamicMemberAccessHashCons(e, dm) and
    result = TDynamicMemberAccessHashCons(dm)
  )
  or
  exists(string name, CallHashCons::TListPartialHashCons args |
    methodCallHashCons(e, name, args) and
    result = TMethodCallHashCons(name, args)
  )
  or
  exists(string name, CallHashCons::TListPartialHashCons args |
    constructorInitializerCallHashCons(e, name, args) and
    result = TConstructorInitializerCallHashCons(name, args)
  )
  or
  exists(string name, CallHashCons::TListPartialHashCons args |
    operatorCallHashCons(e, name, args) and
    result = TOperatorCallHashCons(name, args)
  )
  or
  exists(THashCons expr, CallHashCons::TListPartialHashCons args |
    delegateLikeCallHashCons(e, expr, args) and
    result = TDelegateLikeCallHashCons(expr, args)
  )
  or
  exists(string name, CallHashCons::TListPartialHashCons args |
    objectCreationHashCons(e, name, args) and
    result = TObjectCreationHashCons(name, args)
  )
  or
  thisHashCons(e) and
  result = TThisHashCons()
  or
  baseHashCons(e) and
  result = TBaseHashCons()
  or
  defaultValueWithoutTypeHashCons(e) and
  result = TDefaultValueWithoutTypeHashCons()
  or
  exists(THashCons typeAccess |
    defaultValueWithTypeHashCons(e, typeAccess) and
    result = TDefaultValueWithTypeHashCons(typeAccess)
  )
  or
  exists(THashCons operand, Type targetType |
    castHashCons(e, targetType, operand) and
    result = TCastHashCons(targetType, operand)
  )
  or
  exists(string operator, THashCons left, THashCons right |
    assignmentHashCons(e, operator, left, right) and
    result = TAssignmentHashCons(operator, left, right)
  )
  or
  exists(THashCons typeAccess |
    typeOfHashCons(e, typeAccess) and
    result = TTypeOfHashCons(typeAccess)
  )
  or
  exists(THashCons index, THashCons qualifier |
    arrayAccessHashCons(e, index, qualifier) and
    result = TArrayAccessHashCons(index, qualifier)
  )
  or
  exists(ArrayInitializerHashCons::TListPartialHashCons list |
    arrayInitializerHashCons(e, list) and
    result = TArrayInitializerHashCons(list)
  )
  or
  exists(THashCons initializer, ArrayCreationHashCons::TListPartialHashCons lengths |
    arrayCreationHashCons(e, initializer, lengths) and
    result = TArrayCreationHashCons(initializer, lengths)
  )
  or
  exists(Variable v, THashCons initializer |
    localVariableDeclWithInitializerHashCons(e, v, initializer) and
    result = TLocalVariableDeclWithInitializerHashCons(v, initializer)
  )
  or
  exists(Variable v |
    localVariableDeclWithoutInitializerHashCons(e, v) and
    result = TLocalVariableDeclWithoutInitializerHashCons(v)
  )
  or
  exists(string name |
    defineSymbolHashCons(e, name) and
    result = TDefineSymbolHashCons(name)
  )
}

private predicate uniqueHashCons(Expr e) { not numberableExpr(e) }

private THashCons tHashCons(Expr e) {
  result = nonUniqueHashCons(e)
  or
  uniqueHashCons(e) and
  result = TUniqueHashCons(e)
}

/**
 * Gets the hashcons of `e`, if any.
 *
 * To check if `e1` has the same structure as `e2`
 * use `hashCons(e1).getAnExpr() = e2`.
 */
cached
HashCons hashCons(Expr e) { result = tHashCons(e) }

/**
 * A representation of the "structure" of an expression.
 */
class HashCons extends THashCons {
  Expr getAnExpr() { this = hashCons(result) }

  /** Gets the unique representative expression with this hashcons. */
  private Expr getReprExpr() {
    result =
      min(Location loc, Expr e |
        e = this.getAnExpr() and
        loc = e.getLocation()
      |
        e order by loc.getFile().getAbsolutePath(), loc.getStartLine(), loc.getStartColumn()
      )
  }

  /**
   * Gets the string representation of this hash cons.
   *
   * This is the `toString` of an arbitrarily chosen expression with this
   * hashcons.
   */
  string toString() { result = this.getReprExpr().toString() }

  /**
   * Gets the location of this hashcons.
   *
   * This is the location of an arbitrarily chosen expression with this
   * hashcons.
   */
  Location getLocation() { result = this.getReprExpr().getLocation() }
}
