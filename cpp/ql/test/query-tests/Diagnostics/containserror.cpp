// semmle-extractor-options: --expect_errors

void containserror() {
	#error An error!
}

void error_with_placeholder() {
	const char *x = "Foo1 $@ bar1 $@ baz1";
	const char *x = "Foo2 $@ bar2 $@ baz2";
}