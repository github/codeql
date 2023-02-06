// semmle-extractor-options: --gnu --gnu_version 80000
typedef int v4i __attribute__((vector_size (16)));

void f() {
  v4i a = {1,2,3,4};
  v4i b = {5,6,7,8};
  v4i mask_1 = {3,0,1,2};
  v4i mask_2 = {3,5,4,2};

  v4i res_1 = __builtin_shuffle(a, mask_1);
  v4i res_2 = __builtin_shuffle(a, b, mask_2);
}
