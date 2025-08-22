// semmle-extractor-options: --expect_errors

UNKNOWN_TYPE test_error_value() {
	UNKNOWN_TYPE x;
	return x; // GOOD: Error return type
}

void* test_error_pointer() {
	UNKNOWN_TYPE x;
	return &x; // BAD [FALSE NEGATIVE]
}

int* test_error_pointer_member() {
	UNKNOWN_TYPE x;
	return &x.y; // BAD [FALSE NEGATIVE]
}
