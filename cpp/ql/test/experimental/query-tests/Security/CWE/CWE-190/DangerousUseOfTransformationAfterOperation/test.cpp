void testCall (unsigned long);
void functionWork(char aA[10],unsigned int aUI) {

  unsigned long aL;
  char *aP;
  int aI;

  aI = (aUI*8)/10; // GOOD
  aI = aUI*8; // BAD
  aP = aA+aI;
  aI = (int)aUI*8; // GOOD
  
  aL = (unsigned long)(aI*aI); // BAD
  aL = ((unsigned long)aI*aI); // GOOD
  
  testCall((unsigned long)(aI*aI)); // BAD
  testCall(((unsigned long)aI*aI)); // GOOD
  
  if((unsigned long)(aI*aI) > aL) // BAD
    return;
  if(((unsigned long)aI*aI) > aL) // GOOD
    return;
}
