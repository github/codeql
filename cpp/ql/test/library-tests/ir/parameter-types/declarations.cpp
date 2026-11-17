// The parameter is declared as `char *argv[]` in `test.cpp`.
void array_param_with_pointer_declaration(char **argv);

// The parameter is declared as `char **argv` in `test.cpp`.
void pointer_param_with_array_declaration(char *argv[]);

// The parameter is declared as `void f()` in `test.cpp`.
void function_param_with_pointer_declaration(void (*f)());

// The parameter is declared as `const int x` in `test.cpp`.
void const_param_with_non_const_declaration(int x);

// The parameter is declared as `size_t n` in `test.cpp`.
void typedef_param_with_underlying_type_declaration(unsigned long n);
