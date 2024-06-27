fun testWhen(i: Int): Int {
  return when(i) {
    0 -> 1
    1 -> 2
    2 -> return 3
    3 -> throw Exception("No threes please")
    else -> 999
  }
}

