void def(void) {
   int a = 1;
   int *p = &a;
   p = &(int)a;
}

// codeql-extractor-compiler: cl
