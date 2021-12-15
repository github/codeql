int f() {
  int i;
  int total = 0;

  for (i = 0; i < 10; i = i+1) {  // GOOD: comparison could be either true or false.
    total += i;
  }

  for (i = 0; i < 10; i = i+1) {  // BAD: comparison is always true, because i <= 5. 
    i = i % 5;
    total += i;
  }

  return total;
}
