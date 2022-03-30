
void call_f(int x);

void call_f(int x)
{
}

void call_g()
{
  void (*f_ptr)(int);

  call_f(123);

  f_ptr = &call_f;
  f_ptr(456);
}
