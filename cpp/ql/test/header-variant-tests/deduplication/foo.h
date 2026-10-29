const char* foo()
{
  return "foo";
}

#ifdef FOO
int foo_defined;
#else
int foo_not_defined;
#endif
