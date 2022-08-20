void testFunction(int i1, int i2, int i3, bool b1, bool b2, bool b3, char c1)
{
  
  if(b1||b2&&b3) //BAD
    return;
  if((b1||b2)&&b3) //GOOD
    return;
  if(b1||(b2&&b3)) //GOOD
    return;

  if(b1||b2&i1) //BAD
    return;
  if((b1||b2)&i1) //GOOD
    return;
  if(b1||b2&1) //GOOD
    return;
  if(b1&&b2&0) //GOOD
    return;
  if(b1||b2|i1) //BAD
    return;
  if((b1||b2)|i1) //GOOD
    return;

  if(i1|i2&c1) //BAD
    return;
  if((i1|i2)&i3) //GOOD
    return;
  if(i1^i2&c1) //BAD
    return;
  if((i1^i2)&i3) //GOOD
    return;
  
  if(i1|i2^c1) //BAD
    return;
  if((i1|i2)^i3) //GOOD
    return;
  
  if(b1|b2^b3) //BAD
    return;
  if((b1|b2)^b3) //GOOD
    return;
  
}
