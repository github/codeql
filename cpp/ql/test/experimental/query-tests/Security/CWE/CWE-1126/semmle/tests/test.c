void workFunction_0(char *s) {
  int intIndex = 10;
  char buf[80];
  while(intIndex > 2) // GOOD
  {
    buf[intIndex] = 1;
    intIndex--;
  }
  while(intIndex > 2)
  {
    buf[intIndex] = 1;
    int intIndex; // BAD
    intIndex--;
  }
}
