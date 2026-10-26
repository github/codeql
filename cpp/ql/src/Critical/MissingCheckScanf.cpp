{
  int i, j, r;

  r = scanf("%d %d", &i, &j);

  use(i); // BAD: i is not guarded

  if (r >= 1) {
    use(i); // GOOD: i is guarded correctly
    use(j); // BAD: j is guarded incorrectly
  }

  if (r != 2)
    return;

  use(j); // GOOD: j is guarded correctly
}
