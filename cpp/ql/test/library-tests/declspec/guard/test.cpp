// codeql-extractor-compiler: cl

void f(__declspec(guard(overflow)) size_t length) {
}

__declspec(guard(ignore))
void g(void) {
}
