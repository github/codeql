template <typename T>
void foo(T x, T y)
{
  x << y;
};

struct streamable
{
};

void operator<<(streamable& lhs, streamable& rhs)
{
}

int main()
{
  int x = 3;
  foo(x, x);
  streamable y;
  foo(y, y);
  return 0;
}

int add_numbers(int& lhs, int rhs)
{
  return lhs += rhs;
}

int pointless_add_numbers(int lhs, int rhs)
{
  return lhs += rhs;
}

void call_add_numbers()
{
  int accum = 0;
  add_numbers(accum, 4);
  add_numbers(accum, 10);
  pointless_add_numbers(accum, 20);
}
