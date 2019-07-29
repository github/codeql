import semmle.code.cpp.exprs.Expr

/**
 * A C/C++ builtin operation.
 */
abstract class BuiltInOperation extends Expr {
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
}

/**
 * A C++ `__has_copy` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationHasCopy extends BuiltInOperation, @hascopyexpr {
  override string toString() { result = "__has_copy" }
}

/**
 * A C++ `__has_nothrow_assign` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationHasNoThrowAssign extends BuiltInOperation, @hasnothrowassign {
  override string toString() { result = "__has_nothrow_assign" }
}

/**
 * A C++ `__has_nothrow_constructor` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationHasNoThrowConstructor extends BuiltInOperation, @hasnothrowconstr {
  override string toString() { result = "__has_nothrow_constructor" }
}

/**
 * A C++ `__has_nothrow_copy` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationHasNoThrowCopy extends BuiltInOperation, @hasnothrowcopy {
  override string toString() { result = "__has_nothrow_copy" }
}

/**
 * A C++ `__has_trivial_assign` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationHasTrivialAssign extends BuiltInOperation, @hastrivialassign {
  override string toString() { result = "__has_trivial_assign" }
}

/**
 * A C++ `__has_trivial_constructor` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationHasTrivialConstructor extends BuiltInOperation, @hastrivialconstr {
  override string toString() { result = "__has_trivial_constructor" }
}

/**
 * A C++ `__has_trivial_copy` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationHasTrivialCopy extends BuiltInOperation, @hastrivialcopy {
  override string toString() { result = "__has_trivial_copy" }
}

/**
 * A C++ `__has_trivial_destructor` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationHasTrivialDestructor extends BuiltInOperation, @hastrivialdestructor {
  override string toString() { result = "__has_trivial_destructor" }
}

/**
 * A C++ `__has_user_destructor` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationHasUserDestructor extends BuiltInOperation, @hasuserdestr {
  override string toString() { result = "__has_user_destructor" }
}

/**
 * A C++ `__has_virtual_destructor` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationHasVirtualDestructor extends BuiltInOperation, @hasvirtualdestr {
  override string toString() { result = "__has_virtual_destructor" }
}

/**
 * A C++ `__is_abstract` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationIsAbstract extends BuiltInOperation, @isabstractexpr {
  override string toString() { result = "__is_abstract" }
}

/**
 * A C++ `__is_base_of` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationIsBaseOf extends BuiltInOperation, @isbaseofexpr {
  override string toString() { result = "__is_base_of" }
}

/**
 * A C++ `__is_class` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationIsClass extends BuiltInOperation, @isclassexpr {
  override string toString() { result = "__is_class" }
}

/**
 * A C++ `__is_convertible_to` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationIsConvertibleTo extends BuiltInOperation, @isconvtoexpr {
  override string toString() { result = "__is_convertible_to" }
}

/**
 * A C++ `__is_empty` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationIsEmpty extends BuiltInOperation, @isemptyexpr {
  override string toString() { result = "__is_empty" }
}

/**
 * A C++ `__is_enum` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationIsEnum extends BuiltInOperation, @isenumexpr {
  override string toString() { result = "__is_enum" }
}

/**
 * A C++ `__is_pod` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationIsPod extends BuiltInOperation, @ispodexpr {
  override string toString() { result = "__is_pod" }
}

/**
 * A C++ `__is_polymorphic` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationIsPolymorphic extends BuiltInOperation, @ispolyexpr {
  override string toString() { result = "__is_polymorphic" }
}

/**
 * A C++ `__is_union` expression (used by some implementations of the type_traits header).
 */
class BuiltInOperationIsUnion extends BuiltInOperation, @isunionexpr {
  override string toString() { result = "__is_union" }
}

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
}

/**
 * A clang `__builtin_convertvector` expression.
 */
class BuiltInOperationBuiltInConvertVector extends BuiltInOperation, @builtinconvertvector {
  override string toString() { result = "__builtin_convertvector" }
}

/**
 * A clang `__builtin_addressof` expression (can be used to implement C++'s std::addressof).
 */
class BuiltInOperationBuiltInAddressOf extends UnaryOperation, BuiltInOperation, @builtinaddressof {
  /** Gets the function or variable whose address is taken. */
  Declaration getAddressable() {
       result = this.getOperand().(Access).getTarget()
       // this handles the case where we are taking the address of a reference variable
    or result = this.getOperand().(ReferenceDereferenceExpr).getChild(0).(Access).getTarget()
  }

  override string getCanonicalQLClass() { result = "BuiltInOperationBuiltInAddressOf" }

  override string getOperator() { result = "__builtin_addressof" }
}

/**
 * The `__is_trivially_constructible` type trait.
 */
class BuiltInOperationIsTriviallyConstructible extends BuiltInOperation, @istriviallyconstructibleexpr {
  override string toString() { result = "__is_trivially_constructible" }
}

/**
 * The `__is_destructible` type trait.
 */
class BuiltInOperationIsDestructible extends BuiltInOperation, @isdestructibleexpr {
  override string toString() { result = "__is_destructible" }
}

/**
 * The `__is_nothrow_destructible` type trait.
 */
class BuiltInOperationIsNothrowDestructible extends BuiltInOperation, @isnothrowdestructibleexpr {
  override string toString() { result = "__is_nothrow_destructible" }
}

/**
 * The `__is_trivially_destructible` type trait.
 */
class BuiltInOperationIsTriviallyDestructible extends BuiltInOperation, @istriviallydestructibleexpr {
  override string toString() { result = "__is_trivially_destructible" }
}

/**
 * The `__is_trivially_assignable` type trait.
 */
class BuiltInOperationIsTriviallyAssignable extends BuiltInOperation, @istriviallyassignableexpr {
  override string toString() { result = "__is_trivially_assignable" }
}

/**
 * The `__is_nothrow_assignable` type trait.
 */
class BuiltInOperationIsNothrowAssignable extends BuiltInOperation, @isnothrowassignableexpr {
  override string toString() { result = "__is_nothrow_assignable" }
}

/**
 * The `__is_standard_layout` type trait.
 */
class BuiltInOperationIsStandardLayout extends BuiltInOperation, @isstandardlayoutexpr {
  override string toString() { result = "__is_standard_layout" }
}

/**
 * The `__is_trivially_copyable` type trait.
 */
class BuiltInOperationIsTriviallyCopyable extends BuiltInOperation, @istriviallycopyableexpr {
  override string toString() { result = "__is_trivially_copyable" }
}

/**
 * The `__is_literal_type` type trait.
 */
class BuiltInOperationIsLiteralType extends BuiltInOperation, @isliteraltypeexpr {
  override string toString() { result = "__is_literal_type" }
}

/**
 * The `__has_trivial_move_constructor` type trait.
 */
class BuiltInOperationHasTrivialMoveConstructor extends BuiltInOperation, @hastrivialmoveconstructorexpr {
  override string toString() { result = "__has_trivial_move_constructor" }
}

/**
 * The `__has_trivial_move_assign` type trait.
 */
class BuiltInOperationHasTrivialMoveAssign extends BuiltInOperation, @hastrivialmoveassignexpr {
  override string toString() { result = "__has_trivial_move_assign" }
}

/**
 * The `__has_nothrow_move_assign` type trait.
 */
class BuiltInOperationHasNothrowMoveAssign extends BuiltInOperation, @hasnothrowmoveassignexpr {
  override string toString() { result = "__has_nothrow_move_assign" }
}

/**
 * The `__is_constructible` type trait.
 */
class BuiltInOperationIsConstructible extends BuiltInOperation, @isconstructibleexpr {
  override string toString() { result = "__is_constructible" }
}

/**
 * The `__is_nothrow_constructible` type trait.
 */
class BuiltInOperationIsNothrowConstructible extends BuiltInOperation, @isnothrowconstructibleexpr {
  override string toString() { result = "__is_nothrow_constructible" }
}

/**
 * The `__has_finalizer` type trait.
 */
class BuiltInOperationHasFinalizer extends BuiltInOperation, @hasfinalizerexpr {
  override string toString() { result = "__has_finalizer" }
}

/**
 * The `__is_delegate` type trait.
 */
class BuiltInOperationIsDelegate extends BuiltInOperation, @isdelegateexpr {
  override string toString() { result = "__is_delegate" }
}

/**
 * The `__is_interface_class` type trait.
 */
class BuiltInOperationIsInterfaceClass extends BuiltInOperation, @isinterfaceclassexpr {
  override string toString() { result = "__is_interface_class" }
}

/**
 * The `__is_ref_array` type trait.
 */
class BuiltInOperationIsRefArray extends BuiltInOperation, @isrefarrayexpr {
  override string toString() { result = "__is_ref_array" }
}

/**
 * The `__is_ref_class` type trait.
 */
class BuiltInOperationIsRefClass extends BuiltInOperation, @isrefclassexpr {
  override string toString() { result = "__is_ref_class" }
}

/**
 * The `__is_sealed` type trait.
 */
class BuiltInOperationIsSealed extends BuiltInOperation, @issealedexpr {
  override string toString() { result = "__is_sealed" }
}

/**
 * The `__is_simple_value_class` type trait.
 */
class BuiltInOperationIsSimpleValueClass extends BuiltInOperation, @issimplevalueclassexpr {
  override string toString() { result = "__is_simple_value_class" }
}

/**
 * The `__is_value_class` type trait.
 */
class BuiltInOperationIsValueClass extends BuiltInOperation, @isvalueclassexpr {
  override string toString() { result = "__is_value_class" }
}

/**
 * The `__is_final` type trait.
 */
class BuiltInOperationIsFinal extends BuiltInOperation, @isfinalexpr {
  override string toString() { result = "__is_final" }
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
