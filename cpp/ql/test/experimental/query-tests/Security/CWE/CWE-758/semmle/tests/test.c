char tmpFunction1(char * buf)
{
  buf[1]=buf[1] + buf[2] + buf[3];
  return buf[1];
}
char tmpFunction2(char * buf)
{
  buf[2]=buf[1] + buf[2] + buf[3];
  return buf[2];
}
void workFunction_0(char *s, char * buf) {
  int intA;
  intA = tmpFunction1(buf) + tmpFunction2(buf);  // BAD
  intA = tmpFunction1(buf);  //GOOD
  intA += tmpFunction2(buf);  // GOOD
  buf[intA] = intA++; // BAD
  intA++;
  buf[intA] = intA; // GOOD
}
