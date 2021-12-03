
void do_something_with(bool b)
{
  // ...
}

void do_something_else_with(int i)
{
  // ...
}

void test_if(int x, int y)
{
  bool b = x < y;
  do_something_with(b);

  if (bool c = x < y) { // ConditionalDeclExpr
    do_something_with(c);
    x++;
  }
}

void test_while(int x, int y)
{
  while (int d = x - y) { // ConditionalDeclExpr
    do_something_else_with(d);
  }
}

void test_for(int x, int y)
{
  for (int i = 0; bool c = x < y; x++) { // ConditionalDeclExpr
    do_something_with(c);
  }
}
