int f1();
int f2(int x);

int g1()
{
  return 1;
}

int g2(int x) {
  return x <= 1 ? g1() : g2(x - 1);
}

int h(int x, int y, int z)

{
  if (x * y) return z;
  if (y * z) return x;
  if (z * x) return y;
  
  // Oh well, return something:
  return 0;
}

void uncalled_with_default_args(int i = g1(), int j = g1()) { }

void called_with_default_args_defaulting(int i = g1(), int j = g1()) { }
void call_with_default_args_defaulting(void) {
    called_with_default_args_defaulting();
}

void called_with_default_args_specified(int i = g1(), int j = g1()) { }
void call_with_default_args_specified(void) {
    called_with_default_args_specified(1, 2);
}
