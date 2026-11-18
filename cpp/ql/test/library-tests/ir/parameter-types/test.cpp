typedef unsigned long size_t;

void pointer_param(char **argv) { // $ type="glval<char **>"
}

void array_param(char *argv[]) { // $ type="glval<char **>"
}

// The parameter is declared as `char **argv` in `declarations.cpp`.
void array_param_with_pointer_declaration(char *argv[]) { // $ type="glval<char **>"
}

// The parameter is declared as `char *argv[]` in `declarations.cpp`.
void pointer_param_with_array_declaration(char **argv) { // $ type="glval<char **>"
}

// The parameter is declared as `void (*f)()` in `declarations.cpp`.
void function_param_with_pointer_declaration(void f()) { // $ type="glval<..(*)(..)>"
}

// The parameter is declared as `int x` in `declarations.cpp`.
void const_param_with_non_const_declaration(const int x) { // $ type="glval<const int>"
}

// The parameter is declared as `unsigned long n` in `declarations.cpp`.
void typedef_param_with_underlying_type_declaration(size_t n) { // $ type="glval<size_t>"
}
