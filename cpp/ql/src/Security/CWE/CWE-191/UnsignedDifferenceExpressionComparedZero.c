unsigned limit = get_limit();
unsigned total = 0;
while (limit - total > 0) { // wrong: if `total` is greater than `limit` this will underflow and continue executing the loop.
  total += get_data();
}