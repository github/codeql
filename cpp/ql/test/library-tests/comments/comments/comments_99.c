static int abs(int x) {
   /* This is wrong for INT_MIN. */
   if(x > 0)
     return x;
   else
     return -x;
}
// codeql-extractor-compiler-options: -std=c99
