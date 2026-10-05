void use(double);

void test()
{
  for (float f = 0.0f; f < 1.0f; f = f + 0.1f) // $ Alert
  {
    use(f);
  }

  for (double d = 0.0; d < 10.0; d++) // $ Alert
  {
    use(d);
  }

  long double ld; // $ Alert
  for (ld = 10.0; ld > 0.0; ld--)
  {
    use(ld);
  }

  for (double c = 0.0; c < 1.0; c += 0.1) // $ MISSING: Alert (compound assignment updates are not recognized)
  {
    use(c);
  }

  for (int i = 0; i < 10; i++) // GOOD: integer loop counter
  {
    use(i * 0.1);
  }
}

typedef float real;

void test_typedef()
{
  for (real r = 0.0f; r < 1.0f; r = r + 0.5f) // $ Alert
  {
    use(r);
  }
}
