uint32_t limit = get_limit();
uint32_t total = 0;

while (limit - total > 0) { // BAD: if `total` is greater than `limit` this will underflow and continue executing the loop.
  total += get_data();
}

while (total < limit) { // GOOD: never underflows here because there is no arithmetic.
  total += get_data();
}

while ((int64_t)limit - total > 0) { // GOOD: never underflows here because the result always fits in an `int64_t`.
  total += get_data();
}
