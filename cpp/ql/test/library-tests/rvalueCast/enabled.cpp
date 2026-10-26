void enabled(void) {
   int a = 1;
   int *p = &a;
   p = &(int)a;
}

// semmle-extractor-options: --microsoft --edg --no_preserve_lvalues_with_same_type_casts --expect_errors
