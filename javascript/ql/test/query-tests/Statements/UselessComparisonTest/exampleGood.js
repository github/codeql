function findValue(values, x, start, end) {
  for (let i = start; i < end; ++i) {
    if (values[i] === x) {
        return i;
    }
  }
  return -1;
}
