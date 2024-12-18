{
  int i, j;

  // BAD: The result is only checked against zero
  if (scanf("%d %d", &i, &j)) { 
      use(i);
      use(j);
  }

  // BAD: The result is only checked against zero
  if (scanf("%d %d", &i, &j) == 0) { 
    i = 0;
    j = 0;
  }
  use(i);
  use(j);

  if (scanf("%d %d", &i, &j) == 2) { 
      // GOOD: the result is checked against 2
  }

  // GOOD: the result is compared directly
  int r = scanf("%d %d", &i, &j);
  if (r < 2) {
    return;
  }
  if (r == 1) { 
    j = 0;
  }
}
