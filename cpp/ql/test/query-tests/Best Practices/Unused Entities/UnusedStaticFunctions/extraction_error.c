// semmle-extractor-options: --expect_errors

static void my_function1_called() {} // GOOD
static void my_function2_called_after_error() {} // GOOD
static void my_function3_not_called() {} // BAD [NOT DETECTED]

int main(void) {
	my_function1_called();

--- compilation stops here because this line is not valid C code ---

	my_function2_called_after_error();

	return 0;
}
