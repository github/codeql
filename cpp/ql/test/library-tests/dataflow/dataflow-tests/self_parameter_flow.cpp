void incr(unsigned char **ps) // $ ast-def=ps ir-def=*ps ir-def=**ps 
{
  *ps += 1;
}

void callincr(unsigned char *s) // $ ast-def=s 
{
  incr(&s);
}

void test(unsigned char *s) // $ ast-def=s
{
  callincr(s); // $ flow
}