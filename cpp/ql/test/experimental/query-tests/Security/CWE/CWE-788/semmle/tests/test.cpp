int tmpFunc()
{
  return 12;
}
void testFunction()
{
  int i1,i2,i3;
  bool b1,b2,b3;
  char c1,c2,c3;
  b1 = -b2; // $ Alert[cpp/operator-precedence-logic-error-when-use-bool-type] //BAD
  b1 = !b2; //GOOD
  b1++; // $ Alert[cpp/operator-precedence-logic-error-when-use-bool-type] //BAD
  ++b1; // $ Alert[cpp/operator-precedence-logic-error-when-use-bool-type] //BAD
  if(i1=tmpFunc()!=i2) // $ Alert[cpp/operator-precedence-logic-error-when-use-bool-type] //BAD
    return;
  if(i1=tmpFunc()!=11) // $ Alert[cpp/operator-precedence-logic-error-when-use-bool-type] //BAD
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
