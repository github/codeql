func choose(_ c: Bool, _ a: Int, _ b: Int, _ d: Int) -> Int {
  return c ? a : b .& d
}
