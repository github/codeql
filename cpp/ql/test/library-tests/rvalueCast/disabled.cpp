void disabled(void) {
   int a = 1;
   int *p = &a;
   p = &(int)a;
}

// semmle-extractor-options: --microsoft --edg --preserve_lvalues_with_same_type_casts
