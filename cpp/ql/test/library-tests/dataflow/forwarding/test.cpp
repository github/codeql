template<typename T>
struct Container {
  template<typename... Args>
  void emplace(Args&&... args);
};

struct Element {
  int x;
  Element(int); // element_int
  Element(short); // element_short
  Element(unsigned long); // element_ul
  Element(const char*, int x); // element_const_char_ptr_int
  Element(char*, int x); // element_char_ptr_int
};

struct RefElement {
  RefElement(int&& x); // element_ref_int_rref
  RefElement(int& x); // element_ref_int_lref
  RefElement(const int& x); // element_ref_const_int_ref
  RefElement(const char* const&, int x); // element_ref_const_char_ptr_const_ref_int
  RefElement(const char* const volatile&, int x); // element_ref_const_char_ptr_const_volatile_ref_int
  RefElement(const char*&&, int, int); // element_ref_pointer_rref
  RefElement(const char*&, int, int, int); // element_ref_pointer_lref
};

struct ElementWithDefaultArgument {
  int x;
  ElementWithDefaultArgument(int x, int = 0); // element_default_int
};

struct ElementWithOverloadedArity {
  int x;
  ElementWithOverloadedArity(int first); // element_overload_arith_1
  ElementWithOverloadedArity(int, int second); // element_overload_arith_2
};

struct ElementFromMutablePointer {
  ElementFromMutablePointer(char*, int); // element_from_mutable_ptr
};

void test() {
  {
    Container<Element> c;
    c.emplace(42); // $ targets=element_int SPURIOUS: targets=element_short targets=element_ul
  }
  {
    Container<ElementWithDefaultArgument> c;
    c.emplace(42); // $ targets=element_default_int
    c.emplace(42, 1); // $ targets=element_default_int
  }
  {
    Container<ElementWithOverloadedArity> c;
    c.emplace(42); // $ targets=element_overload_arith_1
    c.emplace(42, 1); // $ targets=element_overload_arith_2
  }
  {
    Container<Element> c;
    c.emplace("abc", 42); // $ targets=element_const_char_ptr_int
    c.emplace((char*)nullptr, 42); // $ targets=element_char_ptr_int SPURIOUS: targets=element_const_char_ptr_int
  }
  {
    Container<Element> c;
    Container<RefElement> cr;
    {
      const int x = 42;
      c.emplace(x); // $ targets=element_int SPURIOUS: targets=element_short targets=element_ul
      cr.emplace(x); // $ targets=element_ref_const_int_ref
    }
    {
      int x = 42;
      c.emplace(x); // $ targets=element_int SPURIOUS: targets=element_short targets=element_ul
      cr.emplace(x); // $ targets=element_ref_int_lref SPURIOUS: targets=element_ref_const_int_ref
    }
    c.emplace(42); // $ targets=element_int SPURIOUS: targets=element_short targets=element_ul
    cr.emplace(42); // $ targets=element_ref_int_rref SPURIOUS: targets=element_ref_const_int_ref
    cr.emplace("abc", 42); // $ targets=element_ref_const_char_ptr_const_ref_int
    const char buffer[] = "abc";
    cr.emplace(buffer, 42); // $ targets=element_ref_const_char_ptr_const_ref_int
  }
  {
  	Container<Element> container;
    short shortValue = 42;
    unsigned long longValue = 42;
    container.emplace(shortValue); // $ targets=element_short SPURIOUS: targets=element_int targets=element_ul
    container.emplace(longValue); // $ targets=element_ul SPURIOUS: targets=element_int targets=element_short
  }
}


void test_invalid_pointer_conversion() {
  Container<ElementFromMutablePointer> container;
  container.emplace("abc", 42); // no targets
}

void test_volatile_reference_binding() {
  Container<RefElement> container;
  const char* volatile pointer = "abc";
  container.emplace(pointer, 42); // $ targets=element_ref_const_char_ptr_const_volatile_ref_int
  container.emplace("abc", 42); // $ targets=element_ref_const_char_ptr_const_ref_int
}

struct ImplicitConversion {
  ImplicitConversion(int = 0, int = 0);
  ImplicitConversion(const char* const&);
};

struct ExplicitConversion {
  explicit ExplicitConversion(int);
};

struct DeletedConversion {
  DeletedConversion(int) = delete;
};

struct RequiredArgumentConversion {
  RequiredArgumentConversion(int, int);
};

struct LvalueConversion {
  LvalueConversion(int&);
};

struct RvalueConversion {
  RvalueConversion(int&&);
};

struct ChainedConversion {
  ChainedConversion(ImplicitConversion);
};

struct ElementFromImplicitConversion {
  explicit ElementFromImplicitConversion(ImplicitConversion); // element_conversion_value
  ElementFromImplicitConversion(const ImplicitConversion&, int); // element_conversion_const_ref
  ElementFromImplicitConversion(ImplicitConversion&&, int, int); // element_conversion_rref
  ElementFromImplicitConversion(ImplicitConversion&, int, int, int); // element_conversion_lref
  ElementFromImplicitConversion(const volatile ImplicitConversion&, int, int, int, int); // element_conversion_const_volatile_ref
};

struct ElementFromUnavailableConversion {
  ElementFromUnavailableConversion(ExplicitConversion); // element_explicit_conversion
  ElementFromUnavailableConversion(DeletedConversion, int); // element_deleted_conversion
  ElementFromUnavailableConversion(RequiredArgumentConversion, int, int); // element_required_argument_conversion
};

struct ElementFromReferenceConversion {
  ElementFromReferenceConversion(LvalueConversion); // element_lvalue_conversion
  ElementFromReferenceConversion(RvalueConversion, int); // element_rvalue_conversion
};

struct ElementFromChainedConversion {
  ElementFromChainedConversion(ChainedConversion); // element_chained_conversion
  ElementFromChainedConversion(ImplicitConversion, ImplicitConversion); // element_two_conversions
};

void test_implicit_conversion() {
  Container<ElementFromImplicitConversion> container;
  container.emplace(42); // $ targets=element_conversion_value
  container.emplace("abc"); // $ targets=element_conversion_value
  container.emplace(42, 0); // $ targets=element_conversion_const_ref
  container.emplace(42, 0, 0); // $ targets=element_conversion_rref
  container.emplace(42, 0, 0, 0); // no targets
  container.emplace(42, 0, 0, 0, 0); // no targets
}

void test_unavailable_implicit_conversion() {
  Container<ElementFromUnavailableConversion> container;
  container.emplace(42); // no targets
  container.emplace(42, 0); // no targets
  container.emplace(42, 0, 0); // no targets
}

void test_implicit_conversion_input_references() {
  Container<ElementFromReferenceConversion> container;
  int value = 42;
  const int constValue = 42;
  volatile int volatileValue = 42;
  container.emplace(value); // $ targets=element_lvalue_conversion
  container.emplace(42); // no targets
  container.emplace(constValue); // no targets
  container.emplace(volatileValue); // no targets
  container.emplace(42, 0); // $ targets=element_rvalue_conversion
  container.emplace(value, 0); // no targets
  container.emplace(static_cast<const int&&>(constValue), 0); // no targets
  container.emplace(static_cast<volatile int&&>(volatileValue), 0); // no targets
}

void test_implicit_conversion_limit() {
  Container<ElementFromChainedConversion> container;
  container.emplace(42); // no targets
  ImplicitConversion converted(42);
  container.emplace(converted); // $ targets=element_chained_conversion
  container.emplace(42, 42); // $ targets=element_two_conversions

  Container<ElementFromImplicitConversion> references;
  references.emplace(converted, 0, 0); // no target
  const ImplicitConversion constConverted(42);
  references.emplace(constConverted, 0, 0, 0); // no target
}

struct ValueConversionOperator {
  operator int();
};

struct LvalueConversionOperator {
  operator int&() &;
};

struct RvalueConversionOperator {
  operator int&&() &&;
};

struct ConstConversionOperator {
  operator const int&() const &;
};

struct VolatileConversionOperator {
  operator const volatile int&() const volatile;
};

struct ExplicitConversionOperator {
  explicit operator int();
};

struct DeletedConversionOperator {
  operator int() = delete;
};

struct ChainedConversionOperator {
  operator ValueConversionOperator&();
};

struct ArrayConversionOperator {
  using Buffer = const char[4];
  operator Buffer&() const;
};

struct ElementFromConversionOperator {
  explicit ElementFromConversionOperator(int); // element_operator_value
  ElementFromConversionOperator(int&, int); // element_operator_lref
  ElementFromConversionOperator(const int&, int, int); // element_operator_const_ref
  ElementFromConversionOperator(int&&, int, int, int); // element_operator_rref
  ElementFromConversionOperator(const volatile int&, int, int, int, int); // element_operator_const_volatile_ref
};

void test_value_conversion_operator() {
  Container<ElementFromConversionOperator> container;
  ValueConversionOperator value;
  const ValueConversionOperator constValue;
  volatile ValueConversionOperator volatileValue;
  container.emplace(value); // $ targets=element_operator_value
  container.emplace(ValueConversionOperator()); // $ targets=element_operator_value
  container.emplace(constValue); // $ SPURIOUS: targets=element_operator_value
  container.emplace(volatileValue); // $ SPURIOUS: targets=element_operator_value
  container.emplace(value, 0); // no targets
  container.emplace(value, 0, 0); // $ targets=element_operator_const_ref
  container.emplace(value, 0, 0, 0); // $ targets=element_operator_rref
  container.emplace(value, 0, 0, 0, 0); // no targets
}

void test_lvalue_conversion_operator() {
  Container<ElementFromConversionOperator> container;
  LvalueConversionOperator value;
  const LvalueConversionOperator constValue;
  volatile LvalueConversionOperator volatileValue;
  container.emplace(value); // $ targets=element_operator_value
  container.emplace(value, 0); // $ targets=element_operator_lref
  container.emplace(value, 0, 0); // $ targets=element_operator_const_ref
  container.emplace(value, 0, 0, 0); // no targets
  container.emplace(value, 0, 0, 0, 0); // $ targets=element_operator_const_volatile_ref
  container.emplace(value, ValueConversionOperator()); // $ targets=element_operator_lref
  container.emplace(LvalueConversionOperator()); // $ SPURIOUS: targets=element_operator_value
  container.emplace(constValue);  // $ SPURIOUS: targets=element_operator_value
  container.emplace(volatileValue); // $ SPURIOUS: targets=element_operator_value
}

void test_rvalue_conversion_operator() {
  Container<ElementFromConversionOperator> container;
  RvalueConversionOperator value;
  const RvalueConversionOperator constValue;
  container.emplace(value);  // $ SPURIOUS: targets=element_operator_value
  container.emplace(static_cast<const RvalueConversionOperator&&>(constValue)); // $ SPURIOUS: targets=element_operator_value
  container.emplace(RvalueConversionOperator()); // $ targets=element_operator_value
  container.emplace(RvalueConversionOperator(), 0); // no targets
  container.emplace(RvalueConversionOperator(), 0, 0); // $ targets=element_operator_const_ref
  container.emplace(RvalueConversionOperator(), 0, 0, 0); // $ targets=element_operator_rref
  container.emplace(RvalueConversionOperator(), 0, 0, 0, 0); // no targets
}

void test_conversion_operator_qualification() {
  Container<ElementFromConversionOperator> container;
  const ConstConversionOperator constValue;
  volatile ConstConversionOperator volatileValue;
  container.emplace(constValue, 0, 0); // $ targets=element_operator_const_ref
  container.emplace(ConstConversionOperator(), 0, 0); // $ targets=element_operator_const_ref
  container.emplace(constValue, 0); // no targets
  container.emplace(constValue, 0, 0, 0); // no targets
  container.emplace(volatileValue); // $ targets=element_operator_value

  const volatile VolatileConversionOperator constVolatileValue;
  container.emplace(constVolatileValue, 0, 0, 0, 0); // $ targets=element_operator_const_volatile_ref
  container.emplace(constVolatileValue, 0, 0); // no targets
  container.emplace(constVolatileValue, 0); // no targets
}

void test_conversion_operator_limit() {
  Container<ElementFromConversionOperator> container;
  container.emplace(ExplicitConversionOperator()); // no targets
  container.emplace(DeletedConversionOperator()); // no targets
  container.emplace(ChainedConversionOperator()); // no targets

  Container<ElementFromImplicitConversion> converted;
  converted.emplace(ValueConversionOperator()); // no targets
}

void test_array_conversion_operator() {
  Container<RefElement> container;
  container.emplace(ArrayConversionOperator(), 42); // $ targets=element_ref_const_char_ptr_const_ref_int
  container.emplace(ArrayConversionOperator(), 0, 0); // $ SPURIOUS: targets=element_ref_pointer_rref
  container.emplace(ArrayConversionOperator(), 0, 0, 0); // no targets
}

void test_pointer_value_categories() {
  Container<RefElement> container;
  const char buffer[] = "abc";
  const char* pointer = buffer;
  const char* const constPointer = buffer;
  container.emplace(buffer, 0, 0); // $ targets=element_ref_pointer_rref
  container.emplace(pointer, 0, 0); // no target
  container.emplace(static_cast<const char*&&>(pointer), 0, 0); // $ targets=element_ref_pointer_rref
  container.emplace(static_cast<const char* const&&>(constPointer), 0, 0); // no target
  container.emplace(buffer, 0, 0, 0); // no targets
  container.emplace(pointer, 0, 0, 0); // $ targets=element_ref_pointer_lref
  container.emplace(constPointer, 0, 0, 0); // no target
  container.emplace(static_cast<const char*&&>(pointer), 0, 0, 0); // no target
}

enum ArithmeticEnum { arithmeticValue = 42 };
enum class ScopedArithmeticEnum { value = 42 };

struct ElementFromArithmetic {
  ElementFromArithmetic(long); // element_arithmetic_long
  ElementFromArithmetic(double, int); // element_arithmetic_double
  ElementFromArithmetic(bool, int, int); // element_arithmetic_bool
  ElementFromArithmetic(const long&, int, int, int); // element_arithmetic_const_ref
  ElementFromArithmetic(long&&, int, int, int, int); // element_arithmetic_rref
};

void test_arithmetic_conversions() {
  Container<ElementFromArithmetic> container;
  short value = 42;
  long longValue = 42;
  container.emplace(value); // $ targets=element_arithmetic_long
  container.emplace(1.5f, 0); // $ targets=element_arithmetic_double
  container.emplace(arithmeticValue); // $ targets=element_arithmetic_long
  container.emplace(42, 0, 0); // $ targets=element_arithmetic_bool
  container.emplace(value, 0, 0, 0); // $ targets=element_arithmetic_const_ref
  container.emplace(value, 0, 0, 0, 0); // $ targets=element_arithmetic_rref
  container.emplace(longValue, 0, 0, 0, 0); // no target
  container.emplace(ScopedArithmeticEnum::value); // no targets
}

void test_standard_and_user_defined_conversions() {
  short value = 42;
  Container<ElementFromImplicitConversion> before;
  before.emplace(value); // $ targets=element_conversion_value
  Container<ElementFromArithmetic> after;
  after.emplace(ValueConversionOperator()); // $ targets=element_arithmetic_long
  after.emplace(ValueConversionOperator(), 0, 0, 0); // $ targets=element_arithmetic_const_ref
}

struct ElementFromQualifiedPointer {
  ElementFromQualifiedPointer(const char*); // element_qualified_pointer
  ElementFromQualifiedPointer(const char* const&, int); // element_qualified_pointer_const_ref
  ElementFromQualifiedPointer(const char*&&, int, int); // element_qualified_pointer_rref
  ElementFromQualifiedPointer(const char*&, int, int, int); // element_qualified_pointer_lref
  ElementFromQualifiedPointer(const char**, int, int, int, int); // element_qualified_double_pointer
  ElementFromQualifiedPointer(const char* const*, int, int, int, int, int); // element_qualified_const_double_pointer
};

void test_pointer_qualification_conversions() {
  Container<ElementFromQualifiedPointer> container;
  char buffer[] = "abc";
  char* pointer = buffer;
  char** doublePointer = &pointer;
  const char* constPointer = buffer;
  container.emplace(buffer); // $ targets=element_qualified_pointer
  container.emplace(pointer); // $ targets=element_qualified_pointer
  container.emplace(pointer, 0); // $ targets=element_qualified_pointer_const_ref
  container.emplace(buffer, 0, 0); // $ targets=element_qualified_pointer_rref
  container.emplace(static_cast<char*&&>(pointer), 0, 0); // $ targets=element_qualified_pointer_rref
  container.emplace(pointer, 0, 0, 0); // no target
  container.emplace(doublePointer, 0, 0, 0, 0); // no target
  container.emplace(doublePointer, 0, 0, 0, 0, 0); // $ MISSING: targets=element_qualified_const_double_pointer
  Container<ElementFromMutablePointer> mutableContainer;
  mutableContainer.emplace(constPointer, 42); // no target
}

struct ConversionBase {
  operator int() const;
};

struct ConversionDerived : ConversionBase {};
struct ConversionFurtherDerived : ConversionDerived {};

struct ElementFromBase {
  ElementFromBase(ConversionBase); // element_base_value
  ElementFromBase(ConversionBase&, int); // element_base_lref
  ElementFromBase(const ConversionBase&, int, int); // element_base_const_ref
  ElementFromBase(ConversionBase&&, int, int, int); // element_base_rref
  ElementFromBase(ConversionBase*, int, int, int, int); // element_base_pointer
  ElementFromBase(const ConversionBase*, int, int, int, int, int); // element_const_base_pointer
};

struct ElementFromDerived {
  ElementFromDerived(ConversionDerived&); // element_derived_lref
  ElementFromDerived(ConversionDerived*, int); // element_derived_pointer
};

void test_inheritance_conversions() {
  ConversionFurtherDerived derived;
  const ConversionDerived constDerived{};
  ConversionBase base;
  Container<ElementFromBase> container;
  container.emplace(derived); // $ targets=element_base_value
  container.emplace(derived, 0); // $ targets=element_base_lref
  container.emplace(constDerived, 0, 0); // $ targets=element_base_const_ref
  container.emplace(ConversionDerived(), 0, 0, 0); // $ targets=element_base_rref
  container.emplace(derived, 0, 0, 0); // no targets
  container.emplace(constDerived, 0); // no targets
  container.emplace(&derived, 0, 0, 0, 0); // $ MISSING: targets=element_base_pointer
  container.emplace(&constDerived, 0, 0, 0, 0); // no targets
  container.emplace(&constDerived, 0, 0, 0, 0, 0); // $ MISSING: targets=element_const_base_pointer
  Container<ElementFromDerived> downcast;
  downcast.emplace(base); // no targets
  downcast.emplace(&base, 0); // no targets
  Container<ElementFromConversionOperator> inherited;
  inherited.emplace(derived); // $ targets=element_operator_value
}

struct ElementFromStandardPointer {
  ElementFromStandardPointer(void*); // element_void_pointer
  ElementFromStandardPointer(const void*, int); // element_const_void_pointer
  ElementFromStandardPointer(int*, int, int); // element_int_pointer
  ElementFromStandardPointer(bool, int, int, int, int); // element_pointer_bool
};

void test_standard_pointer_conversions() {
  Container<ElementFromStandardPointer> container;
  int value = 42;
  const int constValue = 42;
  container.emplace(&value); // $ MISSING: targets=element_void_pointer
  container.emplace(&constValue); // no targets
  container.emplace(&constValue, 0); // $ MISSING: targets=element_const_void_pointer
  container.emplace(nullptr); // $ MISSING: targets=element_void_pointer
  container.emplace(nullptr, 0, 0); // $ MISSING: targets=element_int_pointer
  container.emplace(0, 0, 0); // no targets
  container.emplace(&value, 0, 0, 0, 0); // $ MISSING: targets=element_pointer_bool
  container.emplace(nullptr, 0, 0, 0, 0); // no targets
  void* opaque = &value;
  container.emplace(opaque, 0, 0); // no targets
}

using Callback = int (*)(int);
using NothrowCallback = int (*)(int) noexcept;
int callback(int);
int nothrowCallback(int) noexcept;
double differentCallback(int);

struct ElementFromCallback {
  ElementFromCallback(Callback); // element_callback
  ElementFromCallback(NothrowCallback, int); // element_nothrow_callback
  ElementFromCallback(const Callback&, int, int); // element_callback_const_ref
};

void test_function_conversions() {
  Container<ElementFromCallback> container;
  Callback pointer = callback;
  NothrowCallback nothrowPointer = nothrowCallback;
  container.emplace(callback); // $ targets=element_callback
  container.emplace(nothrowCallback); // $ targets=element_callback
  container.emplace(nothrowPointer); // $ targets=element_callback
  container.emplace(nothrowCallback, 0); // $ targets=element_nothrow_callback
  container.emplace(pointer, 0); // $ SPURIOUS: targets=element_nothrow_callback
  container.emplace(callback, 0); // $ SPURIOUS: targets=element_nothrow_callback
  container.emplace(callback, 0, 0); // $ targets=element_callback_const_ref
  container.emplace(nullptr); // $ MISSING: targets=element_callback
  container.emplace(differentCallback); // no targets
  Container<ElementFromStandardPointer> boolean;
  boolean.emplace(callback, 0, 0, 0, 0); // $ MISSING: targets=element_pointer_bool
  boolean.emplace(callback); // no targets
}

void test_standard_conversion_phases() {
  Container<ElementFromArithmetic> arithmetic;
  long value = 42;
  arithmetic.emplace(value, 0, 0, 0, 0); // no targets
  arithmetic.emplace(&value); // no targets
  arithmetic.emplace(nullptr, 0, 0); // no targets
  arithmetic.emplace(ValueConversionOperator(), 0, 0, 0, 0); // $ targets=element_arithmetic_rref

  Container<ElementFromImplicitConversion> converted;
  char buffer[] = "abc";
  converted.emplace(buffer); // $ targets=element_conversion_value
  converted.emplace(&value); // no targets
  converted.emplace(ScopedArithmeticEnum::value); // no targets
}

void test_pointer_aliases() {
  using Character = const char;
  using Pointer = Character*;
  using NestedPointer = Pointer*;
  Pointer pointer = "abc";
  NestedPointer nested = &pointer;
  Pointer const constPointer = pointer;
  Pointer volatile volatilePointer = pointer;
  Container<ElementFromQualifiedPointer> container;
  container.emplace(pointer); // $ targets=element_qualified_pointer
  container.emplace(nested, 0, 0, 0, 0); // $ targets=element_qualified_double_pointer
  container.emplace(&constPointer, 0, 0, 0, 0, 0); // $ targets=element_qualified_const_double_pointer
  container.emplace(&constPointer, 0, 0, 0, 0); // no targets
  container.emplace(&volatilePointer, 0, 0, 0, 0); // no targets
  container.emplace(&volatilePointer, 0, 0, 0, 0, 0); // $ MISSING: targets=element_qualified_const_double_pointer

  using CallbackAlias = Callback;
  CallbackAlias callbackPointer = callback;
  Container<ElementFromCallback> callbacks;
  callbacks.emplace(callbackPointer); // $ targets=element_callback
  callbacks.emplace(callbackPointer, 0, 0); // $ targets=element_callback_const_ref
  Container<ElementFromStandardPointer> pointers;
  pointers.emplace(callbackPointer); // no targets
}