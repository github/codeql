// semmle-extractor-options: --expect_errors

UNKNOWN_TYPE test_error_value() {
	UNKNOWN_TYPE x;
	return x; // GOOD: Error return type
}

void* test_error_pointer() {
	UNKNOWN_TYPE x;
	return &x; // GOOD: Don't know what &x means
}

int* test_error_pointer_member() {
	UNKNOWN_TYPE x;
	return &x.y; // GOOD: Don't know what x.y means
}
