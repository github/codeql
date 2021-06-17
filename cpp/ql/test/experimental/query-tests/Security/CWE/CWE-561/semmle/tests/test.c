void testFunction(char c1)
{


  switch(c1){ // GOOD
    case 12:
      break;
    case 10:
      break;
    case 9:
      break;
  }
  
  switch(c1){ // BAD
    case 12:
      break;
    case 10:
      break;
    case 9:
      break;
  dafault:
  }
  
  switch(c1){ // BAD
      c1=c1*2;
    case 12:
      break;
    case 10:
      break;
    case 9:
      break;
  }

  
  if((c1<6)&&(c1>0))
  switch(c1){ // BAD
    case 7:
      break;
    case 5:
      break;
    case 3:
      break;
    case 1:
      break;
  }
  
  if((c1<6)&&(c1>0))
  switch(c1){ // BAD
    case 3:
      break;
    case 1:
      break;
  }
  
}
