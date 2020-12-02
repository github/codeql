
typedef struct foo {
	int x;
} foo;

foo foomaker();

void test() {
	foo bar[] = {
		foomaker()
	};
}

// semmle-extractor-options: --microsoft --microsoft_version 1800
