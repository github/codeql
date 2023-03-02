func bitwise() {
  _ = ~1
  _ = 1 & 2
  _ = 1 | 2
  _ = 1 ^ 2
  _ = 1 << 0
  _ = 1 >> 0

  // bitwise operations with overflow
  _ = 1 &<< 1
  _ = 1 &>> 1

  // pointwise bitwise operations
  let a = SIMD4<Int>(1, 2, 3, 4)
  let b = SIMD4<Int>(4, 3, 2, 1)
  let m = a .< b
  _ = m .& m
  _ = m .| m
  _ = m .^ m
}
