// semmle-extractor-options: --clang
void builtin(void) {
  __attribute__((vector_size(16U))) int vec2 = { 0, 1, 2, 3 };
  __attribute__((vector_size(16UL))) int vec = { 0, 1, 2, 3 };
  __builtin_shufflevector(vec, vec, 3, 2, 1, 0); 
}
