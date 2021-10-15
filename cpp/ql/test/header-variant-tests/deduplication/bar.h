const char* bar()
{
#ifndef BAR
  return "bar";
#else
  return "baz";
#endif
}
