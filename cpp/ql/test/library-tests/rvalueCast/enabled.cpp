void enabled(void) {
   int a = 1;
   int *p = &a;
   p = &(int)a;
}

// semmle-extractor-options: --microsoft /Zc:rvalueCast --expect_errors
