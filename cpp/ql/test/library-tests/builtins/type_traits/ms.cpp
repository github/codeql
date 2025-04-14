// semmle-extractor-options: --microsoft --microsoft_version 1600
class empty {
};

class has_assign {
    has_assign & operator=(has_assign x);
};

class has_copy {
    has_copy(has_copy &x);
};

class has_nothrow_assign {
    has_nothrow_assign & operator=(has_assign x) throw();
};

class no_has_nothrow_constructor {
    no_has_nothrow_constructor();
};

class has_nothrow_constructor {
    has_nothrow_constructor() throw();
};

class has_nothrow_copy {
    has_nothrow_copy(has_nothrow_copy &x) throw();
};

class has_user_destructor {
    ~has_user_destructor();
};

class has_virtual_destructor {
    virtual ~has_virtual_destructor();
};

class has_noexcept_destructor {
    ~has_noexcept_destructor() noexcept(false);
};

class abstract {
    virtual void someFun() = 0;
};

class C1 {};
class C2 : C1 {};
class C3 : C2 {};
class C4 : C1 {};
class C5 {};

class method {
    void someFun();
};

class data {
    int i;
};

class method_data {
    void someFun();
    int i;
};

enum an_enum {
    a, b, c
};

union a_union {
    int i;
    double d;
};

struct a_struct {
    int i;
    double d;
};

struct a_struct_plus : a_struct {
    int j;
};

struct a_final_struct final {
    int i;
    double d;
};

void f(void) {
    bool b_has_assign_1 = __has_assign(empty);
    bool b_has_assign_2 = __has_assign(has_assign);

    bool b_has_copy_1 = __has_copy(empty);
    bool b_has_copy_2 = __has_copy(has_copy);

    bool b_has_nothrow_assign_1 = __has_nothrow_assign(empty);
    bool b_has_nothrow_assign_2 = __has_nothrow_assign(has_assign);
    bool b_has_nothrow_assign_3 = __has_nothrow_assign(has_nothrow_assign);

    bool b_has_nothrow_constructor_1 = __has_nothrow_constructor(empty);
    bool b_has_nothrow_constructor_2 = __has_nothrow_constructor(no_has_nothrow_constructor);
    bool b_has_nothrow_constructor_3 = __has_nothrow_constructor(has_nothrow_constructor);

    bool b_has_nothrow_copy_1 = __has_nothrow_copy(empty);
    bool b_has_nothrow_copy_2 = __has_nothrow_copy(has_copy);
    bool b_has_nothrow_copy_3 = __has_nothrow_copy(has_nothrow_copy);

    bool b_has_trivial_assign_1 = __has_trivial_assign(empty);
    bool b_has_trivial_assign_2 = __has_trivial_assign(has_assign);

    bool b_has_trivial_constructor_1 = __has_trivial_constructor(empty);
    bool b_has_trivial_constructor_2 = __has_trivial_constructor(no_has_nothrow_constructor);
    bool b_has_trivial_constructor_3 = __has_trivial_constructor(has_nothrow_constructor);

    bool b_has_trivial_copy_1 = __has_trivial_copy(empty);
    bool b_has_trivial_copy_2 = __has_trivial_copy(has_copy);

    bool b_has_user_destructor_1 = __has_user_destructor(empty);
    bool b_has_user_destructor_2 = __has_user_destructor(has_user_destructor);
    bool b_has_user_destructor_3 = __has_user_destructor(has_virtual_destructor);

    bool b_has_virtual_destructor_1 = __has_virtual_destructor(empty);
    bool b_has_virtual_destructor_2 = __has_virtual_destructor(has_user_destructor);
    bool b_has_virtual_destructor_3 = __has_virtual_destructor(has_virtual_destructor);

    bool b_is_abstract_1 = __is_abstract(empty);
    bool b_is_abstract_2 = __is_abstract(abstract);
    bool b_is_abstract_3 = __is_abstract(method);

    bool b_is_base_of_1 = __is_base_of(C1,C1);
    bool b_is_base_of_2 = __is_base_of(C1,C2);
    bool b_is_base_of_3 = __is_base_of(C1,C3);
    bool b_is_base_of_4 = __is_base_of(C1,C5);
    bool b_is_base_of_5 = __is_base_of(C3,C2);
    bool b_is_base_of_6 = __is_base_of(C3,C1);
    bool b_is_base_of_7 = __is_base_of(C2,C4);
    bool b_is_base_of_8 = __is_base_of(int,int);
    bool b_is_base_of_9 = __is_base_of(int,long);
    bool b_is_base_of_10 = __is_base_of(long,int);
    bool b_is_base_of_11 = __is_base_of(int,double);
    bool b_is_base_of_12 = __is_base_of(double,int);

    bool b_is_class_1 = __is_class(empty);
    bool b_is_class_2 = __is_class(an_enum);
    bool b_is_class_3 = __is_class(a_union);
    bool b_is_class_4 = __is_class(a_struct);
    bool b_is_class_5 = __is_class(int);

    bool b_is_convertible_to_1 = __is_convertible_to(C1,C1);
    bool b_is_convertible_to_2 = __is_convertible_to(C1,C2);
    bool b_is_convertible_to_3 = __is_convertible_to(C1,C3);
    bool b_is_convertible_to_4 = __is_convertible_to(C1,C5);
    bool b_is_convertible_to_5 = __is_convertible_to(C3,C2);
    bool b_is_convertible_to_6 = __is_convertible_to(C3,C1);
    bool b_is_convertible_to_7 = __is_convertible_to(C2,C4);
    bool b_is_convertible_to_8 = __is_convertible_to(int,int);
    bool b_is_convertible_to_9 = __is_convertible_to(int,long);
    bool b_is_convertible_to_10 = __is_convertible_to(long,int);
    bool b_is_convertible_to_11 = __is_convertible_to(int,double);
    bool b_is_convertible_to_12 = __is_convertible_to(double,int);

    bool b_is_empty_1 = __is_empty(empty);
    bool b_is_empty_2 = __is_empty(method);
    bool b_is_empty_3 = __is_empty(data);
    bool b_is_empty_4 = __is_empty(method_data);
    bool b_is_empty_5 = __is_empty(abstract);

    bool b_is_enum_1 = __is_enum(empty);
    bool b_is_enum_2 = __is_enum(an_enum);
    bool b_is_enum_3 = __is_enum(a_union);

    bool b_is_polymorphic_1 = __is_polymorphic(empty);
    bool b_is_polymorphic_2 = __is_polymorphic(abstract);
    bool b_is_polymorphic_3 = __is_polymorphic(method);

    bool b_is_union_1 = __is_union(empty);
    bool b_is_union_2 = __is_union(an_enum);
    bool b_is_union_3 = __is_union(a_union);
    bool b_is_union_4 = __is_union(a_struct);
    bool b_is_union_5 = __is_union(int);

    bool b_is_trivially_constructible1 = __is_trivially_constructible(a_struct);
    bool b_is_trivially_constructible2 = __is_trivially_constructible(empty);
    bool b_is_trivially_constructible3 = __is_trivially_constructible(has_copy);

    bool b_is_destructible1 = __is_destructible(a_struct);
    bool b_is_destructible2 = __is_destructible(empty);
    bool b_is_destructible3 = __is_destructible(has_copy);
    bool b_is_destructible4 = __is_destructible(has_user_destructor);

    bool b_is_nothrow_destructible1 = __is_nothrow_destructible(a_struct);
    bool b_is_nothrow_destructible2 = __is_nothrow_destructible(empty);
    bool b_is_nothrow_destructible3 = __is_nothrow_destructible(has_copy);
    bool b_is_nothrow_destructible4 = __is_nothrow_destructible(has_user_destructor);
    bool b_is_nothrow_destructible5 = __is_nothrow_destructible(has_noexcept_destructor);

    bool b_is_trivially_destructible1 = __is_trivially_destructible(a_struct);
    bool b_is_trivially_destructible2 = __is_trivially_destructible(empty);
    bool b_is_trivially_destructible3 = __is_trivially_destructible(has_copy);
    bool b_is_trivially_destructible4 = __is_trivially_destructible(has_user_destructor);
    bool b_is_trivially_destructible5 = __is_trivially_destructible(has_noexcept_destructor);

    bool b_is_trivially_assignable1 = __is_trivially_assignable(a_struct,a_struct);
    bool b_is_trivially_assignable2 = __is_trivially_assignable(a_struct,empty);
    bool b_is_trivially_assignable3 = __is_trivially_assignable(a_struct,int);

    bool b_is_nothrow_assignable1 = __is_nothrow_assignable(a_struct,a_struct);
    bool b_is_nothrow_assignable2 = __is_nothrow_assignable(a_struct,empty);
    bool b_is_nothrow_assignable3 = __is_nothrow_assignable(a_struct,int);

    bool b_is_standard_layout1 = __is_standard_layout(a_struct);
    bool b_is_standard_layout2 = __is_standard_layout(a_struct_plus);

    bool b_is_trivially_copyable1 = __is_trivially_copyable(empty);
    bool b_is_trivially_copyable2 = __is_trivially_copyable(has_copy);

    bool b_is_literal_type1 = __is_literal_type(empty);
    bool b_is_literal_type2 = __is_literal_type(has_user_destructor);

    bool b_has_trivial_move_constructor1 = __has_trivial_move_constructor(empty);
    bool b_has_trivial_move_constructor2 = __has_trivial_move_constructor(has_copy);
    bool b_has_trivial_move_constructor3 = __has_trivial_move_constructor(has_user_destructor);

    bool b_has_trivial_move_assign1 = __has_trivial_move_assign(empty);
    bool b_has_trivial_move_assign2 = __has_trivial_move_assign(has_copy);
    bool b_has_trivial_move_assign3 = __has_trivial_move_assign(has_assign);

    bool b_has_nothrow_move_assign1 = __has_nothrow_move_assign(empty);
    bool b_has_nothrow_move_assign2 = __has_nothrow_move_assign(has_copy);
    bool b_has_nothrow_move_assign3 = __has_nothrow_move_assign(has_assign);
    bool b_has_nothrow_move_assign4 = __has_nothrow_move_assign(has_nothrow_assign);

    bool b_is_constructible1 = __is_constructible(int);
    bool b_is_constructible2 = __is_constructible(int,float);
    bool b_is_constructible3 = __is_constructible(int,float,float);

    bool b_is_nothrow_constructible1 = __is_nothrow_constructible(int);
    bool b_is_nothrow_constructible2 = __is_nothrow_constructible(int,float);
    bool b_is_nothrow_constructible3 = __is_nothrow_constructible(int,float,float);

    bool b_has_finalizer1 = __has_finalizer(empty);

    bool b_is_delegate1 = __is_delegate(empty);

    bool b_is_interface_class1 = __is_interface_class(empty);

    bool b_is_ref_array1 = __is_ref_array(empty);

    bool b_is_ref_class1 = __is_ref_class(empty);

    bool b_is_sealed1 = __is_sealed(empty);

    bool b_is_simple_value_class1 = __is_simple_value_class(empty);

    bool b_is_value_class1 = __is_value_class(empty);

    bool b_is_final1 = __is_final(a_struct);
    bool b_is_final2 = __is_final(a_final_struct);

    bool b_is_assignable1 = __is_assignable(a_struct,a_struct);
    bool b_is_assignable2 = __is_assignable(a_struct,empty);
    bool b_is_assignable3 = __is_assignable(a_struct,int);

    bool b_is_aggregate1 = __is_aggregate(a_struct);
    bool b_is_aggregate2 = __is_aggregate(int);

    bool b_has_unique_object_representations1 = __has_unique_object_representations(int);
    bool b_has_unique_object_representations2 = __has_unique_object_representations(float);

    bool b_is_layout_compatible1 = __is_layout_compatible(int, long);
    bool b_is_layout_compatible2 = __is_layout_compatible(int*, int* const);

    bool b_is_pointer_interconvertible_base_of1 = __is_pointer_interconvertible_base_of(empty, empty);
    bool b_is_pointer_interconvertible_base_of2 = __is_pointer_interconvertible_base_of(empty, abstract);

    bool b_is_trivially_copy_assignable1 = __is_trivially_copy_assignable(has_assign);
    bool b_is_trivially_copy_assignable2 = __is_trivially_copy_assignable(int);

    bool b_is_assignable_no_precondition_check1 = __is_assignable_no_precondition_check(a_struct, a_struct);
    bool b_is_assignable_no_precondition_check2 = __is_assignable_no_precondition_check(a_struct, empty);
    bool b_is_assignable_no_precondition_check3 = __is_assignable_no_precondition_check(a_struct, int);

    bool b_is_pointer_interconvertible_with_class1 = __is_pointer_interconvertible_with_class(a_struct, &a_struct::i);
    bool b_is_pointer_interconvertible_with_class2 = __is_pointer_interconvertible_with_class(a_struct, &a_struct::d);

    bool b_is_corresponding_member1 = __is_corresponding_member(a_struct, a_struct, &a_struct::i, &a_struct::i);
    bool b_is_corresponding_member2 = __is_corresponding_member(a_struct, a_struct, &a_struct::i, &a_struct::d);

    bool b_is_valid_winrt_type = __is_valid_winrt_type(int);
    bool b_is_win_class = __is_win_class(int);
    bool b_is_win_interface = __is_win_interface(int);
}
