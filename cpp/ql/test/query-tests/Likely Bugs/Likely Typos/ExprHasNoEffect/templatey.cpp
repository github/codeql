template <typename T>
void foo(T x, T y)
{
  x << y; // GOOD (effect depends on T)
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
  foo(x, x); // BAD [NOT DETECTED]
  streamable y;
  foo(y, y); // BAD [NOT DETECTED]
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
  add_numbers(accum, 4); // GOOD
  add_numbers(accum, 10); // GOOD
  pointless_add_numbers(accum, 20); // BAD
}
