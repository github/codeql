/**
 * Provides classes for modeling built-in operations.  Built-in operations are
 * typically compiler specific and are used by libraries and generated code.
 */

import semmle.code.cpp.exprs.Expr

/**
 * A C/C++ built-in operation. This is the root QL class encompassing
 * built-in functionality.
 */
class BuiltInOperation extends Expr, @builtin_op {
  override string getAPrimaryQlClass() { result = "BuiltInOperation" }
}

/**
 * A C/C++ built-in operation that is used to support functions with variable numbers of arguments.
 * This includes `va_start`, `va_end`, `va_copy`, and `va_arg`.
 */
class VarArgsExpr extends BuiltInOperation, @var_args_expr { }

/**
 * A C/C++ `__builtin_va_start` built-in operation (used by some
 * implementations of `va_start`).
 * ```
 * __builtin_va_list ap;
 * __builtin_va_start(ap, last_named_param);
 * ```
 */
class BuiltInVarArgsStart extends BuiltInOperation, @vastartexpr {
  override string toString() { result = "__builtin_va_start" }

  override string getAPrimaryQlClass() { result = "BuiltInVarArgsStart" }

  /**
   * Gets the `va_list` argument.
   */
  final Expr getVAList() { result = getChild(0) }

  /**
   * Gets the argument that specifies the last named parameter before the ellipsis.
   */
  final VariableAccess getLastNamedParameter() { result = getChild(1) }
}

/**
 * A C/C++ `__builtin_va_end` built-in operation (used by some implementations
 * of `va_end`).
 * ```
 * __builtin_va_start(ap, last_named_param);
 * ap = __builtin_va_arg(ap, long);
 * __builtin_va_end(ap);
 * ```
 */
class BuiltInVarArgsEnd extends BuiltInOperation, @vaendexpr {
  override string toString() { result = "__builtin_va_end" }

  override string getAPrimaryQlClass() { result = "BuiltInVarArgsEnd" }

  /**
   * Gets the `va_list` argument.
   */
  final Expr getVAList() { result = getChild(0) }
}

/**
 * A C/C++ `__builtin_va_arg` built-in operation (used by some implementations
 * of `va_arg`).
 * ```
 * ap = __builtin_va_arg(ap, long);
 * ```
 */
class BuiltInVarArg extends BuiltInOperation, @vaargexpr {
  override string toString() { result = "__builtin_va_arg" }

  override string getAPrimaryQlClass() { result = "BuiltInVarArg" }

  /**
   * Gets the `va_list` argument.
   */
  final Expr getVAList() { result = getChild(0) }
}

/**
 * A C/C++ `__builtin_va_copy` built-in operation (used by some implementations
 * of `va_copy`).
 * ```
 * va_list ap, aq;
 * __builtin_va_start(ap, last_named_param);
 * va_copy(aq, ap);
 * ```
 */
class BuiltInVarArgCopy extends BuiltInOperation, @vacopyexpr {
  override string toString() { result = "__builtin_va_copy" }

  override string getAPrimaryQlClass() { result = "BuiltInVarArgCopy" }

  /**
   * Gets the destination `va_list` argument.
   */
  final Expr getDestinationVAList() { result = getChild(0) }

  /**
   * Gets the the source `va_list` argument.
   */
  final Expr getSourceVAList() { result = getChild(1) }
}

/**
 * A Microsoft C/C++ `__noop` expression, which does nothing.
 * ```
 * __noop;
 * ```
 */
class BuiltInNoOp extends BuiltInOperation, @noopexpr {
  override string toString() { result = "__noop" }

  override string getAPrimaryQlClass() { result = "BuiltInNoOp" }
}

/**
 * DEPRECATED: Use `BuiltInOperationBuiltInOffsetOf` instead.
 */
deprecated class BuiltInOperationOffsetOf = BuiltInOperationBuiltInOffsetOf;

/**
 * A C/C++ `__builtin_offsetof` built-in operation (used by some implementations
 * of `offsetof`).  The operation retains its semantics even in the presence
 * of an overloaded `operator &`).  This is a GNU/Clang extension.
 * ```
 * struct S {
 *   int a, b;
 * };
 * int d = __builtin_offsetof(struct S, b); // usually 4
 * ```
 */
class BuiltInOperationBuiltInOffsetOf extends BuiltInOperation, @offsetofexpr {
  override string toString() { result = "__builtin_offsetof" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationBuiltInOffsetOf" }
}

/**
 * A C/C++ `__INTADDR__` built-in operation (used by some implementations
 * of `offsetof`).  The operation retains its semantics even in the presence
 * of an overloaded `operator &`).  This is an EDG extension.
 * ```
 * struct S {
 *   int a, b;
 * };
 * int d = __INTADDR__(struct S, b); // usually 4
 * ```
 */
class BuiltInIntAddr extends BuiltInOperation, @intaddrexpr {
  override string toString() { result = "__INTADDR__" }

  override string getAPrimaryQlClass() { result = "BuiltInIntAddr" }
}

/**
 * A C++ `__has_assign` built-in operation (used by some implementations of
 * the `<type_traits>` header).
 *
 * Returns `true` if the type has a copy assignment operator.
 * ```
 * bool v = __has_assign(MyType);
 * ```
 */
class BuiltInOperationHasAssign extends BuiltInOperation, @hasassignexpr {
  override string toString() { result = "__has_assign" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationHasAssign" }
}

/**
 * A C++ `__has_copy` built-in operation (used by some implementations of the
 * `<type_traits>` header).
 *
 * Returns `true` if the type has a copy constructor.
 * ```
 * std::integral_constant< bool, __has_copy(_Tp)> hc;
 * ```
 */
class BuiltInOperationHasCopy extends BuiltInOperation, @hascopyexpr {
  override string toString() { result = "__has_copy" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationHasCopy" }
}

/**
 * A C++ `__has_nothrow_assign` built-in operation (used by some
 * implementations of the `<type_traits>` header).
 *
 * Returns `true` if a copy assignment operator has an empty exception
 * specification.
 * ```
 * std::integral_constant< bool, __has_nothrow_assign(_Tp)> hnta;
 * ```
 */
class BuiltInOperationHasNoThrowAssign extends BuiltInOperation, @hasnothrowassign {
  override string toString() { result = "__has_nothrow_assign" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationHasNoThrowAssign" }
}

/**
 * A C++ `__has_nothrow_constructor` built-in operation (used by some
 * implementations of the `<type_traits>` header).
 *
 * Returns `true` if the default constructor has an empty exception
 * specification.
 * ```
 * bool v = __has_nothrow_constructor(MyType);
 * ```
 */
class BuiltInOperationHasNoThrowConstructor extends BuiltInOperation, @hasnothrowconstr {
  override string toString() { result = "__has_nothrow_constructor" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationHasNoThrowConstructor" }
}

/**
 * A C++ `__has_nothrow_copy` built-in operation (used by some implementations
 * of the `<type_traits>` header).
 *
 * Returns `true` if the copy constructor has an empty exception specification.
 * ```
 * std::integral_constant< bool, __has_nothrow_copy(MyType) >;
 * ```
 */
class BuiltInOperationHasNoThrowCopy extends BuiltInOperation, @hasnothrowcopy {
  override string toString() { result = "__has_nothrow_copy" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationHasNoThrowCopy" }
}

/**
 * A C++ `__has_trivial_assign` built-in operation (used by some implementations
 * of the `<type_traits>` header).
 *
 * Returns `true` if the type has a trivial assignment
 * operator (`operator =`).
 * ```
 * bool v = __has_trivial_assign(MyType);
 * ```
 */
class BuiltInOperationHasTrivialAssign extends BuiltInOperation, @hastrivialassign {
  override string toString() { result = "__has_trivial_assign" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationHasTrivialAssign" }
}

/**
 * A C++ `__has_trivial_constructor` built-in operation (used by some
 * implementations of the `<type_traits>` header).
 *
 * Returns `true` if the type has a trivial constructor.
 * ```
 * bool v = __has_trivial_constructor(MyType);
 * ```
 */
class BuiltInOperationHasTrivialConstructor extends BuiltInOperation, @hastrivialconstr {
  override string toString() { result = "__has_trivial_constructor" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationHasTrivialConstructor" }
}

/**
 * A C++ `__has_trivial_copy` built-in operation (used by some implementations
 * of the `<type_traits>` header).
 *
 * Returns true if the type has a trivial copy constructor.
 * ```
 * std::integral_constant< bool, __has_trivial_copy(MyType) > htc;
 * ```
 */
class BuiltInOperationHasTrivialCopy extends BuiltInOperation, @hastrivialcopy {
  override string toString() { result = "__has_trivial_copy" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationHasTrivialCopy" }
}

/**
 * A C++ `__has_trivial_destructor` built-in operation (used by some
 * implementations of the `<type_traits>` header).
 *
 * Returns `true` if the type has a trivial destructor.
 * ```
 * bool v = __has_trivial_destructor(MyType);
 * ```
 */
class BuiltInOperationHasTrivialDestructor extends BuiltInOperation, @hastrivialdestructor {
  override string toString() { result = "__has_trivial_destructor" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationHasTrivialDestructor" }
}

/**
 * A C++ `__has_user_destructor` built-in operation (used by some
 * implementations of the `<type_traits>` header).
 *
 * Returns true if the type has a user-declared destructor.
 * ```
 * bool v = __has_user_destructor(MyType);
 * ```
 */
class BuiltInOperationHasUserDestructor extends BuiltInOperation, @hasuserdestr {
  override string toString() { result = "__has_user_destructor" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationHasUserDestructor" }
}

/**
 * A C++ `__has_virtual_destructor` built-in operation (used by some
 * implementations of the `<type_traits>` header).
 *
 * Returns `true` if the type has a virtual destructor.
 * ```
 * template<typename _Tp>
 *   struct has_virtual_destructor
 *   : public integral_constant<bool, __has_virtual_destructor(_Tp)>
 *   { };
 * ```
 */
class BuiltInOperationHasVirtualDestructor extends BuiltInOperation, @hasvirtualdestr {
  override string toString() { result = "__has_virtual_destructor" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationHasVirtualDestructor" }
}

/**
 * A C++ `__is_abstract` built-in operation (used by some implementations of the
 * `<type_traits>` header).
 *
 * Returns `true` if the class has at least one pure virtual function.
 * ```
 * bool v = __is_abstract(MyType);
 * ```
 */
class BuiltInOperationIsAbstract extends BuiltInOperation, @isabstractexpr {
  override string toString() { result = "__is_abstract" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsAbstract" }
}

/**
 * A C++ `__is_base_of` built-in operation (used by some implementations of the
 * `<type_traits>` header).
 *
 * Returns `true` if the first type is a base class of the second type, of if both types are the same.
 * ```
 * bool v = __is_base_of(MyType, OtherType);
 * ```
 */
class BuiltInOperationIsBaseOf extends BuiltInOperation, @isbaseofexpr {
  override string toString() { result = "__is_base_of" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsBaseOf" }
}

/**
 * A C++ `__is_class` built-in operation (used by some implementations of the
 * `<type_traits>` header).
 *
 * Returns `true` if the type is a `class` or a `struct`.
 * ```
 * bool v = __is_class(MyType);
 * ```
 */
class BuiltInOperationIsClass extends BuiltInOperation, @isclassexpr {
  override string toString() { result = "__is_class" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsClass" }
}

/**
 * A C++ `__is_convertible_to` built-in operation (used by some implementations
 * of the `<type_traits>` header).
 *
 * Returns `true` if the first type can be converted to the second type.
 * ```
 * bool v = __is_convertible_to(MyType, OtherType);
 * ```
 */
class BuiltInOperationIsConvertibleTo extends BuiltInOperation, @isconvtoexpr {
  override string toString() { result = "__is_convertible_to" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsConvertibleTo" }
}

/**
 * A C++ `__is_empty` built-in operation (used by some implementations of the
 * `<type_traits>` header).
 *
 * Returns `true` if the type has no instance data members.
 * ```
 * bool v = __is_empty(MyType);
 * ```
 */
class BuiltInOperationIsEmpty extends BuiltInOperation, @isemptyexpr {
  override string toString() { result = "__is_empty" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsEmpty" }
}

/**
 * A C++ `__is_enum` built-in operation (used by some implementations of the
 * `<type_traits>` header).
 *
 * Returns true if the type is an `enum`.
 * ```
 * bool v = __is_enum(MyType);
 * ```
 */
class BuiltInOperationIsEnum extends BuiltInOperation, @isenumexpr {
  override string toString() { result = "__is_enum" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsEnum" }
}

/**
 * A C++ `__is_pod` built-in operation (used by some implementations of the
 * `<type_traits>` header).
 *
 * Returns `true` if the type is a `class`, `struct` or `union`,  WITHOUT
 * (1) constructors, (2) private or protected non-static members, (3) base
 *  classes, or (4) virtual functions.
 * ```
 * bool v = __is_pod(MyType);
 * ```
 */
class BuiltInOperationIsPod extends BuiltInOperation, @ispodexpr {
  override string toString() { result = "__is_pod" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsPod" }
}

/**
 * A C++ `__is_polymorphic` built-in operation (used by some implementations
 * of the `<type_traits>` header).
 *
 * Returns `true` if the type has at least one virtual function.
 * ```
 * bool v = __is_polymorphic(MyType);
 * ```
 */
class BuiltInOperationIsPolymorphic extends BuiltInOperation, @ispolyexpr {
  override string toString() { result = "__is_polymorphic" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsPolymorphic" }
}

/**
 * A C++ `__is_union` built-in operation (used by some implementations of the
 * `<type_traits>` header).
 *
 * Returns `true` if the type is a `union`.
 * ```
 * bool v = __is_union(MyType);
 * ```
 */
class BuiltInOperationIsUnion extends BuiltInOperation, @isunionexpr {
  override string toString() { result = "__is_union" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsUnion" }
}

/**
 * DEPRECATED: Use `BuiltInOperationBuiltInTypesCompatibleP` instead.
 */
deprecated class BuiltInOperationBuiltInTypes = BuiltInOperationBuiltInTypesCompatibleP;

/**
 * A C++ `__builtin_types_compatible_p` built-in operation (used by some
 * implementations of the `<type_traits>` header).
 *
 * Returns `true` if the two types are the same (modulo qualifiers).
 * ```
 * template<typename _Tp1, typename _Tp2>
 *   struct types_compatible
 *   : public integral_constant<bool, __builtin_types_compatible_p(_Tp1, _Tp2) >
 *   { };
 * ```
 */
class BuiltInOperationBuiltInTypesCompatibleP extends BuiltInOperation, @typescompexpr {
  override string toString() { result = "__builtin_types_compatible_p" }
}

/**
 * A clang `__builtin_shufflevector` expression.
 *
 * It outputs a permutation of elements from one or two input vectors.
 * Please see
 * https://releases.llvm.org/3.7.0/tools/clang/docs/LanguageExtensions.html#langext-builtin-shufflevector
 * for more information.
 * ```
 * // Concatenate every other element of 4-element vectors V1 and V2.
 * V3 = __builtin_shufflevector(V1, V2, 0, 2, 4, 6);
 * ```
 */
class BuiltInOperationBuiltInShuffleVector extends BuiltInOperation, @builtinshufflevector {
  override string toString() { result = "__builtin_shufflevector" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationBuiltInShuffleVector" }
}

/**
 * A clang `__builtin_convertvector` expression.
 *
 * Allows for conversion of vectors of equal element count and compatible
 * element types. Please see
 * https://releases.llvm.org/3.7.0/tools/clang/docs/LanguageExtensions.html#builtin-convertvector
 * for more information.
 * ```
 * float  vf  __attribute__((__vector_size__(16)));
 * typedef double  vector4double  __attribute__((__vector_size__(32)));
 * // convert from a vector of 4 floats to a vector of 4 doubles.
 * vector4double vd = __builtin_convertvector(vf, vector4double);
 * ```
 */
class BuiltInOperationBuiltInConvertVector extends BuiltInOperation, @builtinconvertvector {
  override string toString() { result = "__builtin_convertvector" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationBuiltInConvertVector" }
}

/**
 * A clang `__builtin_addressof` function (can be used to implement C++'s
 * `std::addressof`).
 *
 * This function disregards any overloads created for `operator &`.
 * ```
 * int a = 1;
 * int *b = __builtin_addressof(a);
 * ```
 */
class BuiltInOperationBuiltInAddressOf extends UnaryOperation, BuiltInOperation, @builtinaddressof {
  /** Gets the function or variable whose address is taken. */
  Declaration getAddressable() {
    result = this.getOperand().(Access).getTarget()
    or
    // this handles the case where we are taking the address of a reference variable
    result = this.getOperand().(ReferenceDereferenceExpr).getChild(0).(Access).getTarget()
  }

  override string getAPrimaryQlClass() { result = "BuiltInOperationBuiltInAddressOf" }

  override string getOperator() { result = "__builtin_addressof" }
}

/**
 * The `__is_trivially_constructible` built-in operation (used by some
 * implementations of the `<type_traits>` header).
 *
 * Returns `true` if the type has a trivial default
 * constructor, copy constructor or move constructor.
 * ```
 * template<typename T, typename... Args>
 *   struct is_trivially_constructible
 *   : public integral_constant<bool, __is_trivially_constructible(T, Args...) >
 *   { };
 * ```
 */
class BuiltInOperationIsTriviallyConstructible extends BuiltInOperation,
  @istriviallyconstructibleexpr {
  override string toString() { result = "__is_trivially_constructible" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsTriviallyConstructible" }
}

/**
 * The `__is_destructible` built-in operation (used by some implementations
 * of the `<type_traits>` header).
 *
 * Returns `true` if the type's destructor is not `delete`d and is accessible
 * in derived `class`es, and whose base `class` and all non-static data members
 * are also destructible.
 * ```
 * bool v = __is_destructible(MyType);
 * ```
 */
class BuiltInOperationIsDestructible extends BuiltInOperation, @isdestructibleexpr {
  override string toString() { result = "__is_destructible" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsDestructible" }
}

/**
 * The `__is_nothrow_destructible` built-in operation (used by some
 * implementations of the `<type_traits>` header).
 *
 * Returns `true` if the type is destructible and whose destructor, and those
 * of member data and any super`class`es all have an empty exception
 * specification.
 * ```
 * bool v = __is_nothrow_destructible(MyType);
 * ```
 */
class BuiltInOperationIsNothrowDestructible extends BuiltInOperation, @isnothrowdestructibleexpr {
  override string toString() { result = "__is_nothrow_destructible" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsNothrowDestructible" }
}

/**
 * The `__is_trivially_destructible` built-in operation (used by some
 * implementations of the `<type_traits>` header).
 *
 * Returns `true` if the type is destructible and whose destructor, and those
 * of member data and any superclasses are all trivial.
 * ```
 * bool v = __is_trivially_destructible(MyType);
 * ```
 */
class BuiltInOperationIsTriviallyDestructible extends BuiltInOperation, @istriviallydestructibleexpr {
  override string toString() { result = "__is_trivially_destructible" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsTriviallyDestructible" }
}

/**
 * The `__is_trivially_assignable` built-in operation (used by some
 * implementations of the `<type_traits>` header).
 *
 * Returns `true` if the assignment operator `C::operator =(const C& c)` is
 * trivial.
 * ```
 * template<typename T>
 *   struct is_trivially_assignable
 *   : public integral_constant<bool, __is_trivially_assignable(T) >
 *   { };
 * ```
 */
class BuiltInOperationIsTriviallyAssignable extends BuiltInOperation, @istriviallyassignableexpr {
  override string toString() { result = "__is_trivially_assignable" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsTriviallyAssignable" }
}

/**
 * The `__is_nothrow_assignable` built-in operation (used by some
 * implementations of the `<type_traits>` header).
 *
 * Returns true if there exists a `C::operator =(const C& c) nothrow`
 * assignment operator (i.e, with an empty exception specification).
 * ```
 * bool v = __is_nothrow_assignable(MyType);
 * ```
 */
class BuiltInOperationIsNothrowAssignable extends BuiltInOperation, @isnothrowassignableexpr {
  override string toString() { result = "__is_nothrow_assignable" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsNothrowAssignable" }
}

/**
 * The `__is_standard_layout` built-in operation (used by some implementations
 * of the `<type_traits>` header).
 *
 * Returns `true` if the type is a primitive type, or a `class`, `struct` or
 * `union` WITHOUT (1) virtual functions or base classes, (2) reference member
 * variable or (3) multiple occurrences of base `class` objects, among other
 * restrictions.  Please see
 * https://en.cppreference.com/w/cpp/named_req/StandardLayoutType
 * for more information.
 * ```
 * bool v = __is_standard_layout(MyType);
 * ```
 */
class BuiltInOperationIsStandardLayout extends BuiltInOperation, @isstandardlayoutexpr {
  override string toString() { result = "__is_standard_layout" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsStandardLayout" }
}

/**
 * The `__is_trivially_copyable` built-in operation (used by some
 * implementations of the `<type_traits>` header).
 *
 * Returns `true` if instances of this type can be copied by trivial
 * means.  The copying is done in a manner similar to the `memcpy`
 * function.
 */
class BuiltInOperationIsTriviallyCopyable extends BuiltInOperation, @istriviallycopyableexpr {
  override string toString() { result = "__is_trivially_copyable" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsTriviallyCopyable" }
}

/**
 * The `__is_literal_type` built-in operation (used by some implementations of
 * the `<type_traits>` header).
 *
 * Returns `true` if the type is a scalar type, a reference type or an array of
 * literal types, among others. Please see
 * https://en.cppreference.com/w/cpp/named_req/LiteralType
 * for more information.
 *
 * ```
 * template <typename _Tp>
 * std::integral_constant< bool, __is_literal_type(_Tp)> ilt;
 * ```
 */
class BuiltInOperationIsLiteralType extends BuiltInOperation, @isliteraltypeexpr {
  override string toString() { result = "__is_literal_type" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsLiteralType" }
}

/**
 * The `__has_trivial_move_constructor` built-in operation (used by some
 * implementations of the `<type_traits>` header).
 *
 * Returns true if the move (`&&`) constructor can be generated by the
 * compiler, with semantics of the `memcpy` operation.
 * ```
 * template <typename _Tp>
 * std::integral_constant< bool, __has_trivial_move_constructor(_Tp)> htmc;
 * ```
 */
class BuiltInOperationHasTrivialMoveConstructor extends BuiltInOperation,
  @hastrivialmoveconstructorexpr {
  override string toString() { result = "__has_trivial_move_constructor" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationHasTrivialMoveConstructor" }
}

/**
 * The `__has_trivial_move_assign` built-in operation (used by some
 * implementations of the `<type_traits>` header).
 *
 * Returns if the move-assign operator `C::operator =(C &&c)` is trivial.
 * ```
 * template<typename T>
 *   struct has_trivial_move_assign
 *   : public integral_constant<bool, __has_trivial_move_assign(T) >
 *   { };
 * ```
 */
class BuiltInOperationHasTrivialMoveAssign extends BuiltInOperation, @hastrivialmoveassignexpr {
  override string toString() { result = "__has_trivial_move_assign" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationHasTrivialMoveAssign" }
}

/**
 * The `__has_nothrow_move_assign` built-in operation (used by some
 * implementations of the `<type_traits>` header).
 *
 * Returns `true` if the type has a `C::operator=(C&& c) nothrow`, that is,
 * an assignment operator with an empty exception specification.
 * ```
 * bool v = __has_nothrow_move_assign(MyType);
 * ```
 */
class BuiltInOperationHasNothrowMoveAssign extends BuiltInOperation, @hasnothrowmoveassignexpr {
  override string toString() { result = "__has_nothrow_move_assign" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationHasNothrowMoveAssign" }
}

/**
 * The `__is_constructible` built-in operation (used by some implementations
 * of the `<type_traits>` header).
 *
 * Returns `true` if the type can be constructed using specified arguments
 * (or none).
 * ```
 * template<typename T, typename... Args>
 *   struct is_constructible
 *   : public integral_constant<bool, __is_constructible(T, Args...) >
 *   { };
 * ```
 */
class BuiltInOperationIsConstructible extends BuiltInOperation, @isconstructibleexpr {
  override string toString() { result = "__is_constructible" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsConstructible" }
}

/**
 * The `__is_nothrow_constructible` built-in operation (used by some
 * implementations of the `<type_traits>` header).
 *
 * Returns `true` if the type is constructable and all its constructors have an
 * empty exception specification (i.e., are declared with `nothrow`);
 * ```
 * bool v = __is_nothrow_constructible(MyType);
 * ```
 */
class BuiltInOperationIsNothrowConstructible extends BuiltInOperation, @isnothrowconstructibleexpr {
  override string toString() { result = "__is_nothrow_constructible" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsNothrowConstructible" }
}

/**
 * The `__has_finalizer` built-in operation.  This is a Microsoft extension.
 *
 * Returns `true` if the type defines a _finalizer_ `C::!C(void)`, to be called
 * from either the regular destructor or the garbage collector.
 * ```
 * bool v = __has_finalizer(MyType);
 * ```
 */
class BuiltInOperationHasFinalizer extends BuiltInOperation, @hasfinalizerexpr {
  override string toString() { result = "__has_finalizer" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationHasFinalizer" }
}

/**
 * The `__is_delegate` built-in operation.  This is a Microsoft extension.
 *
 * Returns `true` if the function has been declared as a `delegate`, used in
 * message forwarding.  Please see
 * https://docs.microsoft.com/en-us/cpp/extensions/delegate-cpp-component-extensions
 * for more information.
 */
class BuiltInOperationIsDelegate extends BuiltInOperation, @isdelegateexpr {
  override string toString() { result = "__is_delegate" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsDelegate" }
}

/**
 * The `__is_interface_class` built-in operation.  This is a Microsoft extension.
 *
 * Returns `true` if the type has been declared as an `interface`.  Please see
 * https://docs.microsoft.com/en-us/cpp/extensions/interface-class-cpp-component-extensions
 * for more information.
 */
class BuiltInOperationIsInterfaceClass extends BuiltInOperation, @isinterfaceclassexpr {
  override string toString() { result = "__is_interface_class" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsInterfaceClass" }
}

/**
 * The `__is_ref_array` built-in operation.  This is a Microsoft extension.
 *
 * Returns `true` if the object passed in is a _platform array_.  Please see
 * https://docs.microsoft.com/en-us/cpp/extensions/arrays-cpp-component-extensions
 * for more information.
 * ```
 * array<int>^ x = gcnew array<int>(10);
 * bool b = __is_ref_array(array<int>);
 * ```
 */
class BuiltInOperationIsRefArray extends BuiltInOperation, @isrefarrayexpr {
  override string toString() { result = "__is_ref_array" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsRefArray" }
}

/**
 * The `__is_ref_class` built-in operation.  This is a Microsoft extension.
 *
 * Returns `true` if the type is a _reference class_.  Please see
 * https://docs.microsoft.com/en-us/cpp/extensions/classes-and-structs-cpp-component-extensions
 * for more information.
 * ```
 * ref class R {};
 * bool b = __is_ref_class(R);
 * ```
 */
class BuiltInOperationIsRefClass extends BuiltInOperation, @isrefclassexpr {
  override string toString() { result = "__is_ref_class" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsRefClass" }
}

/**
 * The `__is_sealed` built-in operation.  This is a Microsoft extension.
 *
 * Returns `true` if a given class or virtual function is marked as `sealed`,
 * meaning that it cannot be extended or overridden.  The `sealed` keyword
 * is similar to the C++11 `final` keyword.
 * ```
 * ref class X sealed {
 *   virtual void f() sealed { }
 * };
 * ```
 */
class BuiltInOperationIsSealed extends BuiltInOperation, @issealedexpr {
  override string toString() { result = "__is_sealed" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsSealed" }
}

/**
 * The `__is_simple_value_class` built-in operation.  This is a Microsoft extension.
 *
 * Returns `true` if passed a value type that contains no references to the
 * garbage-collected heap.
 * ```
 * ref class R {};             // __is_simple_value_class(R) == false
 * value struct V {};          // __is_simple_value_class(V) == true
 * value struct V2 {           // __is_simple_value_class(V2) == false
 *   R ^ r;   // not a simple value type
 * };
 * ```
 */
class BuiltInOperationIsSimpleValueClass extends BuiltInOperation, @issimplevalueclassexpr {
  override string toString() { result = "__is_simple_value_class" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsSimpleValueClass" }
}

/**
 * The `__is_value_class` built-in operation.  This is a Microsoft extension.
 *
 * Returns `true` if passed a value type.  Please see
 * https://docs.microsoft.com/en-us/cpp/extensions/classes-and-structs-cpp-component-extensions
 * For more information.
 * ```
 * value struct V {};
 * bool v = __is_value_class(V);
 * ```
 */
class BuiltInOperationIsValueClass extends BuiltInOperation, @isvalueclassexpr {
  override string toString() { result = "__is_value_class" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsValueClass" }
}

/**
 * The `__is_final` built-in operation (used by some implementations of the
 * `<type_traits>` header).
 *
 * Returns `true` if the `class` has been marked with the `final` specifier.
 * ```
 * template<typename T>
 *   struct is_final
 *   : public integral_constant<bool, __is_final(T) >
 *   { };
 * ```
 */
class BuiltInOperationIsFinal extends BuiltInOperation, @isfinalexpr {
  override string toString() { result = "__is_final" }

  override string getAPrimaryQlClass() { result = "BuiltInOperationIsFinal" }
}

/**
 * The `__builtin_choose_expr` expression.  This is a GNU/Clang extension.
 *
 * The expression functions similarly to the ternary `?:` operator, except
 * that it is evaluated at compile-time.
 * ```
 * int sz = __builtin_choose_expr(__builtin_types_compatible_p(int, long), 4, 8);
 * ```
 */
class BuiltInChooseExpr extends BuiltInOperation, @builtinchooseexpr {
  override string toString() { result = "__builtin_choose_expr" }

  override string getAPrimaryQlClass() { result = "BuiltInChooseExpr" }
}

/**
 * Fill operation on a vector. This is a GNU extension.
 *
 * A single scalar value is used to populate all the elements in a vector.
 * In the example below, the scalar value is `25`:
 * ```
 * typedef int v16i __attribute__((vector_size(16)));
 * v16i src, dst;
 * dst = src << 25;
 * ```
 */
class VectorFillOperation extends UnaryOperation, @vec_fill {
  override string getOperator() { result = "(vector fill)" }

  override string getAPrimaryQlClass() { result = "VectorFillOperation" }
}

/**
 * The GNU `__builtin_complex` operation.
 */
class BuiltInComplexOperation extends BuiltInOperation, @builtincomplex {
  override string toString() { result = "__builtin_complex" }

  override string getAPrimaryQlClass() { result = "BuiltInComplexOperation" }

  /** Gets the operand corresponding to the real part of the complex number. */
  Expr getRealOperand() { this.hasChild(result, 0) }

  /** Gets the operand corresponding to the imaginary part of the complex number. */
  Expr getImaginaryOperand() { this.hasChild(result, 1) }
}
