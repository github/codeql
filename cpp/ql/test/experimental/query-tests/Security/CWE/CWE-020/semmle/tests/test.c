void workFunction_0(char *s) {
  int len = 5, len1;
  char buf[80], buf1[8];
  if(len<0) return;
  memset(buf,0,len); //GOOD
  memset(buf1,0,len1); //BAD
  if(len1<0) return;
}
