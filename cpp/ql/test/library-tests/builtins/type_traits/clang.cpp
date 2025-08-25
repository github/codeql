// semmle-extractor-options: --clang --clang_version 190000

struct S {
    void f() {}
    int o;
};

using f_type = decltype(&S::f);
using o_type = decltype(&S::o);

struct T;

bool b_is_same1 = __is_same(int, int);
bool b_is_same2 = __is_same(int, float);

bool b_is_function1 = __is_function(void(int));
bool b_is_function2 = __is_function(int);

bool b_is_array1 = __is_array(int[]);
bool b_is_array2 = __is_array(int);

unsigned long b_array_rank1 = __array_rank(int[42][42]);
unsigned long b_array_rank2 = __array_rank(int);

unsigned long b_array_extent1 = __array_extent(int[42][42], 1);
unsigned long b_array_extent2 = __array_extent(int[42][42], 2);
unsigned long b_array_extent3 = __array_extent(int, 0);

bool bok_is_arithmetic1 = __is_arithmetic(S);
bool bok_is_arithmetic2 = __is_arithmetic(int);

bool bok_is_complete_type1 = __is_complete_type(S);
bool bok_is_complete_type2 = __is_complete_type(T);

bool bok_is_compound1 = __is_compound(S);
bool bok_is_compound2 = __is_compound(int);

bool bok_is_const1 = __is_const(const int);
bool bok_is_const2 = __is_const(int);

bool bok_is_floating_point1 = __is_floating_point(int);
bool bok_is_floating_point2 = __is_floating_point(float);

bool bok_is_fundamental1 = __is_fundamental(S);
bool bok_is_fundamental2 = __is_fundamental(int);

bool bok_is_integral1 = __is_integral(float);
bool bok_is_integral2 = __is_integral(int);

bool bok_is_lvalue_reference1 = __is_lvalue_reference(int&);
bool bok_is_lvalue_reference2 = __is_lvalue_reference(int);

bool bok_is_member_function_pointer1 = __is_member_function_pointer(f_type);
bool bok_is_member_function_pointer2 = __is_member_function_pointer(o_type);

bool bok_is_member_object_pointer1 = __is_member_object_pointer(f_type);
bool bok_is_member_object_pointer2 = __is_member_object_pointer(o_type);

bool bok_is_member_pointer1 = __is_member_pointer(f_type);
bool bok_is_member_pointer2 = __is_member_pointer(o_type);
bool bok_is_member_pointer3 = __is_member_pointer(int);

bool bok_is_object1 = __is_object(int);
bool bok_is_object2 = __is_object(int&);

bool bok_is_pointer1 = __is_pointer(int);
bool bok_is_pointer2 = __is_pointer(int*);

bool bok_is_reference1 = __is_reference(int);
bool bok_is_reference2 = __is_reference(int&);

bool bok_is_rvalue_reference1 = __is_rvalue_reference(int&&);
bool bok_is_rvalue_reference2 = __is_rvalue_reference(int);

bool bok_is_scalar1 = __is_scalar(int);
bool bok_is_scalar2 = __is_scalar(int[]);

bool bok_is_signed1 = __is_signed(int);
bool bok_is_signed2 = __is_signed(unsigned int);

bool bok_is_unsigned1 = __is_unsigned(int);
bool bok_is_unsigned2 = __is_unsigned(unsigned int);

bool bok_is_void1 = __is_void(void);
bool bok_is_void2 = __is_void(int);

bool bok_is_volatile1 = __is_volatile(volatile int);
bool bok_is_volatile2 = __is_volatile(int);

struct S2 {
    S2() {}
};

bool bok_is_trivial1 = __is_trivial(int);
bool bok_is_trivial2 = __is_trivial(S2);

bool bok_reference_binds_to_temporary1 = __reference_binds_to_temporary(int&, long&);
bool bok_reference_binds_to_temporary2 = __reference_binds_to_temporary(int const &, long&);

bool b_is_same_as1 = __is_same_as(int, int);
bool b_is_same_as2 = __is_same_as(int, float);

bool b_is_bounded_array1 = __is_bounded_array(int[]);
bool b_is_bounded_array2 = __is_bounded_array(int[42]);

bool b_is_unbounded_array1 = __is_unbounded_array(int[]);
bool b_is_unbounded_array2 = __is_unbounded_array(int[42]);

bool b_is_referenceable1 = __is_referenceable(int);
bool b_is_referenceable2 = __is_referenceable(void);

bool b_is_trivially_equality_comparable1 = __is_trivially_equality_comparable(int);
bool b_is_trivially_equality_comparable2 = __is_trivially_equality_comparable(void);

enum class E {
    a, b
};

bool b_is_scoped_enum1 = __is_scoped_enum(E);
bool b_is_scoped_enum2 = __is_scoped_enum(int);

bool b_is_trivially_relocatable1 = __is_trivially_relocatable(int);
bool b_is_trivially_relocatable2 = __is_trivially_relocatable(void);
