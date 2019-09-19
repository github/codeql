import semmle.code.cpp.exprs.Expr

/**
 * A C/C++ builtin operation.
 */
abstract class BuiltInOperation extends Expr {
  override string getCanonicalQLClass() { result = "BuiltInOperation" }
}

/**
 * A C/C++ `__builtin_va_start` expression (used by some implementations of `va_start`).
 */
class BuiltInVarArgsStart extends BuiltInOperation, @vastartexpr {
  override string toString() { result = "__builtin_va_start" }

  override string getCanonicalQLClass() { result = "BuiltInVarArgsStart" }
}

/**
 * A C/C++ `__builtin_va_end` expression (used by some implementations of `va_end`).
 */
class BuiltInVarArgsEnd extends BuiltInOperation, @vaendexpr {
  override string toString() { result = "__builtin_va_end" }

  override string getCanonicalQLClass() { result = "BuiltInVarArgsEnd" }
}

/**
 * A C/C++ `__builtin_va_arg` expression (used by some implementations of `va_arg`).
 */
class BuiltInVarArg extends BuiltInOperation, @vaargexpr {
  override string toString() { result = "__builtin_va_arg" }

  override string getCanonicalQLClass() { result = "BuiltInVarArg" }
}

/**
 * A C/C++ `__builtin_va_copy` expression (used by some implementations of `va_copy`).
 */
class BuiltInVarArgCopy extends BuiltInOperation, @vacopyexpr {
  override string toString() { result = "__builtin_va_copy" }

  override string getCanonicalQLClass() { result = "BuiltInVarArgCopy" }
}

/**
 * A Microsoft C/C++ `__noop` expression, which does nothing.
 */
class BuiltInNoOp extends BuiltInOperation, @noopexpr {
  override string toString() { result = "__noop" }

  override string getCanonicalQLClass() { result = "BuiltInNoOp" }
}

/**
 * A C++ `__offsetof` expression (used by some implementations of offsetof in the presence of user-defined `operator&`).
 */
class BuiltInOperationOffsetOf extends BuiltInOperation, @offsetofexpr {
  override string toString() { result = "__offsetof" }

  override string getCanonicalQLClass() { result = "BuiltInOperationOffsetOf" }
}

/**
 * A C/C++ `__INTADDR__` expression, used by EDG to implement `offsetof` in the presence of user-defined `operator&`.
 */
class BuiltInIntAddr extends BuiltInOperation, @intaddrexpr {
  override string toString() { result = "__INTADDR__" }

  override string getCanonicalQLClass() { result = "BuiltInIntAddr" }
}

/**
 * A C++ `__has_assign` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationHasAssign extends BuiltInOperation, @hasassignexpr {
  override string toString() { result = "__has_assign" }

  override string getCanonicalQLClass() { result = "BuiltInOperationHasAssign" }
}

/**
 * A C++ `__has_copy` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationHasCopy extends BuiltInOperation, @hascopyexpr {
  override string toString() { result = "__has_copy" }

  override string getCanonicalQLClass() { result = "BuiltInOperationHasCopy" }
}

/**
 * A C++ `__has_nothrow_assign` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationHasNoThrowAssign extends BuiltInOperation, @hasnothrowassign {
  override string toString() { result = "__has_nothrow_assign" }

  override string getCanonicalQLClass() { result = "BuiltInOperationHasNoThrowAssign" }
}

/**
 * A C++ `__has_nothrow_constructor` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationHasNoThrowConstructor extends BuiltInOperation, @hasnothrowconstr {
  override string toString() { result = "__has_nothrow_constructor" }

  override string getCanonicalQLClass() { result = "BuiltInOperationHasNoThrowConstructor" }
}

/**
 * A C++ `__has_nothrow_copy` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationHasNoThrowCopy extends BuiltInOperation, @hasnothrowcopy {
  override string toString() { result = "__has_nothrow_copy" }

  override string getCanonicalQLClass() { result = "BuiltInOperationHasNoThrowCopy" }
}

/**
 * A C++ `__has_trivial_assign` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationHasTrivialAssign extends BuiltInOperation, @hastrivialassign {
  override string toString() { result = "__has_trivial_assign" }

  override string getCanonicalQLClass() { result = "BuiltInOperationHasTrivialAssign" }
}

/**
 * A C++ `__has_trivial_constructor` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationHasTrivialConstructor extends BuiltInOperation, @hastrivialconstr {
  override string toString() { result = "__has_trivial_constructor" }

  override string getCanonicalQLClass() { result = "BuiltInOperationHasTrivialConstructor" }
}

/**
 * A C++ `__has_trivial_copy` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationHasTrivialCopy extends BuiltInOperation, @hastrivialcopy {
  override string toString() { result = "__has_trivial_copy" }

  override string getCanonicalQLClass() { result = "BuiltInOperationHasTrivialCopy" }
}

/**
 * A C++ `__has_trivial_destructor` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationHasTrivialDestructor extends BuiltInOperation, @hastrivialdestructor {
  override string toString() { result = "__has_trivial_destructor" }

  override string getCanonicalQLClass() { result = "BuiltInOperationHasTrivialDestructor" }
}

/**
 * A C++ `__has_user_destructor` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationHasUserDestructor extends BuiltInOperation, @hasuserdestr {
  override string toString() { result = "__has_user_destructor" }

  override string getCanonicalQLClass() { result = "BuiltInOperationHasUserDestructor" }
}

/**
 * A C++ `__has_virtual_destructor` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationHasVirtualDestructor extends BuiltInOperation, @hasvirtualdestr {
  override string toString() { result = "__has_virtual_destructor" }

  override string getCanonicalQLClass() { result = "BuiltInOperationHasVirtualDestructor" }
}

/**
 * A C++ `__is_abstract` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationIsAbstract extends BuiltInOperation, @isabstractexpr {
  override string toString() { result = "__is_abstract" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsAbstract" }
}

/**
 * A C++ `__is_base_of` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationIsBaseOf extends BuiltInOperation, @isbaseofexpr {
  override string toString() { result = "__is_base_of" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsBaseOf" }
}

/**
 * A C++ `__is_class` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationIsClass extends BuiltInOperation, @isclassexpr {
  override string toString() { result = "__is_class" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsClass" }
}

/**
 * A C++ `__is_convertible_to` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationIsConvertibleTo extends BuiltInOperation, @isconvtoexpr {
  override string toString() { result = "__is_convertible_to" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsConvertibleTo" }
}

/**
 * A C++ `__is_empty` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationIsEmpty extends BuiltInOperation, @isemptyexpr {
  override string toString() { result = "__is_empty" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsEmpty" }
}

/**
 * A C++ `__is_enum` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationIsEnum extends BuiltInOperation, @isenumexpr {
  override string toString() { result = "__is_enum" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsEnum" }
}

/**
 * A C++ `__is_pod` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationIsPod extends BuiltInOperation, @ispodexpr {
  override string toString() { result = "__is_pod" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsPod" }
}

/**
 * A C++ `__is_polymorphic` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationIsPolymorphic extends BuiltInOperation, @ispolyexpr {
  override string toString() { result = "__is_polymorphic" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsPolymorphic" }
}

/**
 * A C++ `__is_union` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationIsUnion extends BuiltInOperation, @isunionexpr {
  override string toString() { result = "__is_union" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsUnion" }
}

/**
 * DEPRECATED: Use `BuiltInOperationBuiltInTypesCompatibleP` instead.
 */
deprecated class BuiltInOperationBuiltInTypes = BuiltInOperationBuiltInTypesCompatibleP;

/**
 * A C++ `__builtin_types_compatible_p` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationBuiltInTypesCompatibleP extends BuiltInOperation, @typescompexpr {
  override string toString() { result = "__builtin_types_compatible_p" }
}

/**
 * A clang `__builtin_shufflevector` expression.
 */
class BuiltInOperationBuiltInShuffleVector extends BuiltInOperation, @builtinshufflevector {
  override string toString() { result = "__builtin_shufflevector" }

  override string getCanonicalQLClass() { result = "BuiltInOperationBuiltInShuffleVector" }
}

/**
 * A clang `__builtin_convertvector` expression.
 */
class BuiltInOperationBuiltInConvertVector extends BuiltInOperation, @builtinconvertvector {
  override string toString() { result = "__builtin_convertvector" }

  override string getCanonicalQLClass() { result = "BuiltInOperationBuiltInConvertVector" }
}

/**
 * A clang `__builtin_addressof` expression (can be used to implement C++'s std::addressof).
 */
class BuiltInOperationBuiltInAddressOf extends UnaryOperation, BuiltInOperation, @builtinaddressof {
  /** Gets the function or variable whose address is taken. */
  Declaration getAddressable() {
    result = this.getOperand().(Access).getTarget()
    or
    // this handles the case where we are taking the address of a reference variable
    result = this.getOperand().(ReferenceDereferenceExpr).getChild(0).(Access).getTarget()
  }

  override string getCanonicalQLClass() { result = "BuiltInOperationBuiltInAddressOf" }

  override string getOperator() { result = "__builtin_addressof" }
}

/**
 * The `__is_trivially_constructible` type trait.
 */
class BuiltInOperationIsTriviallyConstructible extends BuiltInOperation,
  @istriviallyconstructibleexpr {
  override string toString() { result = "__is_trivially_constructible" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsTriviallyConstructible" }
}

/**
 * The `__is_destructible` type trait.
 */
class BuiltInOperationIsDestructible extends BuiltInOperation, @isdestructibleexpr {
  override string toString() { result = "__is_destructible" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsDestructible" }
}

/**
 * The `__is_nothrow_destructible` type trait.
 */
class BuiltInOperationIsNothrowDestructible extends BuiltInOperation, @isnothrowdestructibleexpr {
  override string toString() { result = "__is_nothrow_destructible" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsNothrowDestructible" }
}

/**
 * The `__is_trivially_destructible` type trait.
 */
class BuiltInOperationIsTriviallyDestructible extends BuiltInOperation, @istriviallydestructibleexpr {
  override string toString() { result = "__is_trivially_destructible" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsTriviallyDestructible" }
}

/**
 * The `__is_trivially_assignable` type trait.
 */
class BuiltInOperationIsTriviallyAssignable extends BuiltInOperation, @istriviallyassignableexpr {
  override string toString() { result = "__is_trivially_assignable" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsTriviallyAssignable" }
}

/**
 * The `__is_nothrow_assignable` type trait.
 */
class BuiltInOperationIsNothrowAssignable extends BuiltInOperation, @isnothrowassignableexpr {
  override string toString() { result = "__is_nothrow_assignable" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsNothrowAssignable" }
}

/**
 * The `__is_standard_layout` type trait.
 */
class BuiltInOperationIsStandardLayout extends BuiltInOperation, @isstandardlayoutexpr {
  override string toString() { result = "__is_standard_layout" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsStandardLayout" }
}

/**
 * The `__is_trivially_copyable` type trait.
 */
class BuiltInOperationIsTriviallyCopyable extends BuiltInOperation, @istriviallycopyableexpr {
  override string toString() { result = "__is_trivially_copyable" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsTriviallyCopyable" }
}

/**
 * The `__is_literal_type` type trait.
 */
class BuiltInOperationIsLiteralType extends BuiltInOperation, @isliteraltypeexpr {
  override string toString() { result = "__is_literal_type" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsLiteralType" }
}

/**
 * The `__has_trivial_move_constructor` type trait.
 */
class BuiltInOperationHasTrivialMoveConstructor extends BuiltInOperation,
  @hastrivialmoveconstructorexpr {
  override string toString() { result = "__has_trivial_move_constructor" }

  override string getCanonicalQLClass() { result = "BuiltInOperationHasTrivialMoveConstructor" }
}

/**
 * The `__has_trivial_move_assign` type trait.
 */
class BuiltInOperationHasTrivialMoveAssign extends BuiltInOperation, @hastrivialmoveassignexpr {
  override string toString() { result = "__has_trivial_move_assign" }

  override string getCanonicalQLClass() { result = "BuiltInOperationHasTrivialMoveAssign" }
}

/**
 * The `__has_nothrow_move_assign` type trait.
 */
class BuiltInOperationHasNothrowMoveAssign extends BuiltInOperation, @hasnothrowmoveassignexpr {
  override string toString() { result = "__has_nothrow_move_assign" }

  override string getCanonicalQLClass() { result = "BuiltInOperationHasNothrowMoveAssign" }
}

/**
 * The `__is_constructible` type trait.
 */
class BuiltInOperationIsConstructible extends BuiltInOperation, @isconstructibleexpr {
  override string toString() { result = "__is_constructible" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsConstructible" }
}

/**
 * The `__is_nothrow_constructible` type trait.
 */
class BuiltInOperationIsNothrowConstructible extends BuiltInOperation, @isnothrowconstructibleexpr {
  override string toString() { result = "__is_nothrow_constructible" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsNothrowConstructible" }
}

/**
 * The `__has_finalizer` type trait.
 */
class BuiltInOperationHasFinalizer extends BuiltInOperation, @hasfinalizerexpr {
  override string toString() { result = "__has_finalizer" }

  override string getCanonicalQLClass() { result = "BuiltInOperationHasFinalizer" }
}

/**
 * The `__is_delegate` type trait.
 */
class BuiltInOperationIsDelegate extends BuiltInOperation, @isdelegateexpr {
  override string toString() { result = "__is_delegate" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsDelegate" }
}

/**
 * The `__is_interface_class` type trait.
 */
class BuiltInOperationIsInterfaceClass extends BuiltInOperation, @isinterfaceclassexpr {
  override string toString() { result = "__is_interface_class" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsInterfaceClass" }
}

/**
 * The `__is_ref_array` type trait.
 */
class BuiltInOperationIsRefArray extends BuiltInOperation, @isrefarrayexpr {
  override string toString() { result = "__is_ref_array" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsRefArray" }
}

/**
 * The `__is_ref_class` type trait.
 */
class BuiltInOperationIsRefClass extends BuiltInOperation, @isrefclassexpr {
  override string toString() { result = "__is_ref_class" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsRefClass" }
}

/**
 * The `__is_sealed` type trait.
 */
class BuiltInOperationIsSealed extends BuiltInOperation, @issealedexpr {
  override string toString() { result = "__is_sealed" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsSealed" }
}

/**
 * The `__is_simple_value_class` type trait.
 */
class BuiltInOperationIsSimpleValueClass extends BuiltInOperation, @issimplevalueclassexpr {
  override string toString() { result = "__is_simple_value_class" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsSimpleValueClass" }
}

/**
 * The `__is_value_class` type trait.
 */
class BuiltInOperationIsValueClass extends BuiltInOperation, @isvalueclassexpr {
  override string toString() { result = "__is_value_class" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsValueClass" }
}

/**
 * The `__is_final` type trait.
 */
class BuiltInOperationIsFinal extends BuiltInOperation, @isfinalexpr {
  override string toString() { result = "__is_final" }

  override string getCanonicalQLClass() { result = "BuiltInOperationIsFinal" }
}

/**
 * The `__builtin_choose_expr` type trait.
 */
class BuiltInChooseExpr extends BuiltInOperation, @builtinchooseexpr {
  override string toString() { result = "__builtin_choose_expr" }
}

/**
 * Fill operation on a GNU vector.
 */
class VectorFillOperation extends UnaryOperation, @vec_fill {
  override string getOperator() { result = "(vector fill)" }
}
