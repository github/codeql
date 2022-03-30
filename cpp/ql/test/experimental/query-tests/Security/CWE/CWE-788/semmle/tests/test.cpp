int tmpFunc()
{
  return 12;
}
void testFunction()
{
  int i1,i2,i3;
  bool b1,b2,b3;
  char c1,c2,c3;
  b1 = -b2; //BAD
  b1 = !b2; //GOOD
  b1++; //BAD
  ++b1; //BAD
  if(i1=tmpFunc()!=i2) //BAD
    return;
  if(i1=tmpFunc()!=11) //BAD
    return;
  if((i1=tmpFunc())!=i2) //GOOD
    return;
  if((i1=tmpFunc())!=11) //GOOD
    return;
  if(i1=tmpFunc()!=1) //GOOD
    return;
  if(i1=tmpFunc()==b1) //GOOD
    return;
}
