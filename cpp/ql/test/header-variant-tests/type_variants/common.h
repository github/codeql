int printf(...);

void print_int(int x) {
  printf("%d\n", x);
}

void common_function() {
  for(IteratorT itr = first(); itr != last(); ++itr) {
    print_int(*itr);
  }
}
