// semmle-extractor-options: --c++14

const int int_const = 1;
extern const int extern_int_const = 1;
extern const int extern_int_const_noinit;

int int_var;
int int_arr[4];
int int_arr_arr[4][4];

int *const const_ptr = &int_var;

void sideEffect();
using fptr = void (*)();
using fref = void (&)();



// All variables in this function are initialized to constants, as witnessed by
// the `constexpr` annotation that compiles under C++14.
void constantAddresses(int param) {
    constexpr int *ptr_int = &int_var;
    constexpr int *ptr_deref_chain = &*&int_var;
    constexpr int *ptr_array = &int_arr[1] + 1;
    constexpr int (*ptr_to_array)[4] = &int_arr_arr[1] + 1;
    constexpr int *array2d = &int_arr_arr[1][1] + 1;
    constexpr int *const_ints = &int_arr_arr[int_const][extern_int_const];

    // Commented out because clang and EDG disagree on whether this is
    // constant.
    //constexpr int *stmtexpr_int = &int_arr[ ({ 1; }) ];

    constexpr int *comma_int = &int_arr[ ((void)0, 1) ];
    constexpr int *comma_addr = ((void)0, &int_var);
    constexpr int *ternary_true = int_const ? &int_var : &param;
    constexpr int *ternary_false = !int_const ? &param : &int_var;
    constexpr int *ternary_overflow = (unsigned char)256 ? &param : &int_var;
    constexpr int *ternary_ptr_cond = (&int_arr+1) ? &int_var : &param;;
    constexpr int *ptr_subtract = &int_arr[&int_arr[1] - &int_arr[0]];

    constexpr int *constexpr_va = ptr_subtract + 1;

    constexpr int &ref_int = int_var;
    constexpr int &ref_array2d = int_arr_arr[1][1];
    constexpr int &ref_va = ref_array2d;
    constexpr int &ref_va_arith = *(&ref_array2d + 1);

    constexpr fptr fp_implicit = sideEffect;
    constexpr fptr fp_explicit = &sideEffect;
    constexpr fptr fp_chain_addressof = &**&**sideEffect;
    constexpr fptr fp_chain_deref = **&**&**sideEffect;
    constexpr fptr fp_shortchain_deref = *&sideEffect;

    constexpr fref fr_int = sideEffect;
    constexpr fref fr_deref = *&sideEffect;
    constexpr fref fr_2deref = **sideEffect;
    constexpr fref fr_va = fr_int;

    constexpr const char *char_ptr = "str";
    constexpr const char *char_ptr_1 = "str" + 1;
    constexpr char char_arr[] = "str";
}




// All variables in this function are initialized to non-const values. Writing
// `constexpr` in front of any of the variables will be a compile error
// (C++14).
void nonConstantAddresses(const int param, int *const pparam, int &rparam, fref frparam) {
    int *int_param = &int_arr[param];
    int *int_noinit = &int_arr[extern_int_const_noinit];

    int *side_effect_stmtexpr = &int_arr[ ({ sideEffect(); 1; }) ];
    int *side_effect_comma_int = &int_arr[ (sideEffect(), 1) ];
    int *side_effect_comma_addr = (sideEffect(), &int_var);
    int *side_effect_comma_addr2 = ((void)(sideEffect(), 1), &int_var);
    int *ternary_int = &int_arr[int_const ? param : 1];
    const int *ternary_addr = int_const ? &param : &int_var;
    int *va_non_constexpr = pparam;

    int *&&ref_to_temporary = &int_var; // reference to temporary is not a const
    int &ref_param = rparam;

    fref fr_param = frparam;
}
