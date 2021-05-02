void workFunction_0(char *s) {
  int intIndex = 10;
  char buf[80];
  while(intIndex > 2) // GOOD
  {
    buf[intIndex] = 1;
    intIndex--;
  }
  intIndex = 10;
  while(intIndex > 2)
  {
    buf[intIndex] = 1;
    int intIndex; // BAD
    intIndex--;
  }
  intIndex = 10;
  while(intIndex > 2) // GOOD
  {
    buf[intIndex] = 1;
    intIndex -= 2;
    int intIndex;
    intIndex--;
  }
  intIndex = 10;
  while(intIndex > 2) // GOOD
  {
    buf[intIndex] = 1;
    --intIndex;
    int intIndex;
    intIndex--;
  }
}
