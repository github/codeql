...
  int i1;
  char c1;
...
  if((c1<50)&&(c>10))
  switch(c1){
    case 300: // BAD: the code will not be executed
...  
  if((i1<5)&&(i1>0))
  switch(i1){ // BAD
    case 21: // BAD: the code will not be executed
...
  switch(c1){
...
  dafault: // BAD: maybe it will be right `default`
...
  }

...
  switch(c1){ 
      i1=c1*2; // BAD: the code will not be executed
    case 12:
...
  switch(c1){ // GOOD
    case 12:
      break;
    case 10:
      break;
    case 9:
      break;
    default:
      break;
  }
...
