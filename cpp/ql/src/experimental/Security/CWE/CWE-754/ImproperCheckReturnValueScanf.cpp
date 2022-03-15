...
  r = scanf("%i", &i);
  if (r == 1) // GOOD
    return i;
  else
    return -1;
...
  scanf("%i", &i); // BAD
  return i;
...
