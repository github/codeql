static int atomic_increment_i(int* ptr)
{
  return __atomic_fetch_add(ptr, 1, 0);
}

static double atomic_increment_c(char* ptr)
{
  return __atomic_fetch_add(ptr, 1, 0);
}

static int atomic_increment_i4(int* ptr)
{
  return __atomic_fetch_add_4(ptr, 1, 0);
}

static char atomic_increment_c1(char* ptr)
{
  return __atomic_fetch_add_1(ptr, 1, 0);
}
// semmle-extractor-options: --gnu_version 40700
