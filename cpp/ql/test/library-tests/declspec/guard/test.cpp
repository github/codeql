// semmle-extractor-options: --microsoft

void f(__declspec(guard(overflow)) size_t length) {
}

__declspec(guard(ignore))
void g(void) {
}
