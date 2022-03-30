static int abs(int x) {
   /* This is wrong for INT_MIN. */
   if(x > 0)
     return x;
   else
     return -x;
}
// semmle-extractor-options: -std=c99
