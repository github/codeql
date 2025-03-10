function findValue(values, x, start, end) {
  let i;
  for (i = start; i < end; ++i) {
    if (values[i] === x) {
        return i;
    }
  }
  if (i < end) { // $ Alert
    return i;
  }
  return -1;
}
