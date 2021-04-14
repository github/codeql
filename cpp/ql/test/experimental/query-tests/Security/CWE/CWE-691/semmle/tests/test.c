int tmpFunction(){
  return 5;
}
void workFunction_0(char *s) {
  int intSize;
  char buf[80];
  if(intSize>0 && intSize<80 && memset(buf,0,intSize)) return; // GOOD
  if(intSize>0 & intSize<80 & memset(buf,0,intSize)) return; // BAD
  if(intSize>0 && tmpFunction()) return;
  if(intSize<0 & tmpFunction()) return; // BAD
}
void workFunction_1(char *s) {
  int intA,intB;

  if(intA + intB) return; // BAD [NOT DETECTED]
  if(intA + intB>4) return; // GOOD
  if(intA>0 && (intA + intB)) return; // BAD [NOT DETECTED]
  while(intA>0)
  {
    if(intB - intA<10) break;
    intA--;
  }while(intA>0); // BAD [NOT DETECTED]
  while(intA>0)
  {
    if(intB - intA<10) break;
    intA--;
  } // GOOD
}
