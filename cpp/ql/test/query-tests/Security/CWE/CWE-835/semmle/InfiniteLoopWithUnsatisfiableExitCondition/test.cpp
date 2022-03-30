void test00(int n) {
  int i = 0;
  if (n <= 0) {
    return;
  }
  while (1) {
    // BAD: condition is never true, so loop will not terminate.
    if (i == n) {
      break;
    }
  }
}

void test01(int n) {
  int i = 0;
  if (n <= 0) {
    return;
  }
  for (;;) {
    // BAD: condition is never true, so loop will not terminate.
    if (i == n) {
      break;
    }
  }
}

void test02(int n) {
  int i = 0;
  if (n <= 0) {
    return;
  }
  while (1) {
    // GOOD: condition is true after n iterations.
    if (i == n) {
      break;
    }
    i++;
  }
}

void test03(int n) {
  int i = 0;
  // GOOD: obviously infinite, so presumably deliberate.
  while (1) {
    i++;
  }
}

void test04(int n) {
  int i = 0;
  // GOOD: obviously infinite, so presumably deliberate.
  for (;;) {
    i++;
  }
}

int test05() {
  int i = 0;
  int result = 0;

  // BAD: loop condition is always true.
  for (i = 0; i >= 0; i = (i + 1) % 256)
  {
    result++;
  }
  return result;
}

int test06() {
  int i = 0;
  int result = 0;

  for (i = 0; i >= 0; i = (i + 1) % 256)
  {
    // GOOD: this condition is satisfiable.
    if (i == 10)
    {
      break;
    }
    result++;
  }
  return result;
}

int test07()
{
  int i = 0;
  int result = 0;

  // GOOD: this condition is satisfiable.
  for(i = 0; i < 11; i = (i + 1) % 256)
  {
    result++;
  }
  return result;
}

void test08(int n) {
  int i, j;
  if (n <= 0) {
    return;
  }

  // The function exit is unreachable from this loop, even though it
  // terminates. We should not report a result for this loop because this
  // loop is not responsible for the problem.
  for (i = 0; i < n; i++) {}

  for (i = 0;;) {
    // BAD: condition is never true, so loop will not terminate.
    if (i == n) {
      break;
    }

    // Another loop which is not responsible for the problem.
    for (j = 0; j < n; j++) {}
  }
}

void test09(char *str) {
  char c;

  while (true)
  {
    c = *(str++);

    if (c < 'a' && c > 'z') // BAD: this condition is always false.
      return;
  }
}

void test10(char *str) {
  char c;

  while (true)
  {
    c = *(str++);

    if (c < 'a' || c > 'z') // GOOD: this condition is satisfiable.
      return;
  }
}
