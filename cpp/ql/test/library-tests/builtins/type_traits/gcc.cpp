// semmle-extractor-options: --gnu_version 150000

__attribute__ ((aligned(8))) int v;
bool b_has_attribute1 = __builtin_has_attribute(v, aligned);
bool b_has_attribute2 = __builtin_has_attribute(v, aligned(4));


struct a_struct {
    int i;
    double d;
};

bool b_is_pointer_interconvertible_with_class1 = __builtin_is_pointer_interconvertible_with_class(&a_struct::i);
bool b_is_pointer_interconvertible_with_class2 = __builtin_is_pointer_interconvertible_with_class(&a_struct::d);

bool b_is_corresponding_member1 = __builtin_is_corresponding_member(&a_struct::i, &a_struct::i);
bool b_is_corresponding_member2 = __builtin_is_corresponding_member(&a_struct::i, &a_struct::d);

bool b_is_nothrow_convertible1 = __is_nothrow_convertible(int, int);
bool b_is_nothrow_convertible2 = __is_nothrow_convertible(a_struct, int);

bool b_is_convertible1 = __is_convertible(int, int);
bool b_is_convertible2 = __is_convertible(a_struct, int);

bool b_reference_constructs_from_temporary1 = __reference_constructs_from_temporary(int&&, int);
bool b_reference_constructs_from_temporary2 = __reference_constructs_from_temporary(int&&, int&&);

bool b_reference_converts_from_temporary1 = __reference_converts_from_temporary(int&&, int);
bool b_reference_converts_from_temporary2 = __reference_converts_from_temporary(int&&, int&&);

using f_type = void(*)() noexcept;

bool b_is_invocable1 = __is_invocable(f_type);
bool b_is_invocable2 = __is_invocable(f_type, bool);

bool b_is_nothrow_invocable1 = __is_nothrow_invocable(f_type);
bool b_is_nothrow_invocable2 = __is_nothrow_invocable(f_type, bool);
