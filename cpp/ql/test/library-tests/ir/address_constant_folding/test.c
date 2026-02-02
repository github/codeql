#define NULL ((void*)0)

int global_var;

void test_address_null_comparison(int param_var) {
    int local_var;

    if (&global_var == NULL) {}  // $ MISSING: VariableAddress=global_var
    if (&global_var != NULL) {}  // $ MISSING: VariableAddress=global_var
    if (&global_var) {}          // $ VariableAddress=global_var
    if (!&global_var) {}         // $ MISSING: VariableAddress=global_var

    if (&local_var == NULL) {}   // $ VariableAddress=local_var
    if (&local_var != NULL) {}   // $ VariableAddress=local_var
    if (&local_var) {}           // $ VariableAddress=local_var
    if (!&local_var) {}          // $ VariableAddress=local_var

    if (&param_var == NULL) {}   // $ VariableAddress=param_var
    if (&param_var != NULL) {}   // $ VariableAddress=param_var
    if (&param_var) {}           // $ VariableAddress=param_var
    if (!&param_var) {}          // $ VariableAddress=param_var
}
