// Let's just check a few things...
static_assert(3 + 4 == 7, "Addition is sane");
static_assert(3 / 4 == 0, "Division rounds down");

int add(int x, int y)
{
  static_assert(sizeof(x) == sizeof(y), "Type sizes are sane");
  return x + y;
}

static_assert(1, L"Look at this wide-char string containing a \0 byte");
