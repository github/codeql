typedef char chars[10];
typedef int jmp_buf[16];

class C { public:

static int bad1(char xs[10]) // $ Alert
{
  return sizeof(xs);
}

static int bad2(char xs[]) // $ Alert
{
  return sizeof(xs);
}

static int bad3(chars xs) // $ Alert
{
  return sizeof(xs);
}

static int bad4(chars const xs) // $ Alert
{
  return sizeof(xs);
}

static int good1(char (&xs)[10])
{
  return sizeof(xs);
}

static int good2(chars& xs)
{
  return sizeof(xs);
}

static void good_longjmp(jmp_buf j)
{
}

static void bad_longjmp(int j[16]) // $ Alert
{
}

template <typename T, unsigned N>
static unsigned array_size(T(&)[N])
{
  return N;
}

template <typename T>
static void no_op(T&& arg)
{
}

};

int main()
{
  chars c;
  C::no_op(c);
  return C::array_size(c);
}
