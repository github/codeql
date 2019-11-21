
typedef struct foo {
	int x;
} foo;

foo foomaker();

void test() {
	foo bar[] = {
		foomaker()
	};
}

// codeql-extractor-compiler: cl-1800
