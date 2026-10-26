function getValue(items, needle) {
  for (const [key, value] of items) {
    if (key.equals(needle)) {
      return value.get();
    }
  }
  const value = "dfg"; // should not affect scoping above
  return null;
}
