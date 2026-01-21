class OptionalHeader extends @optional_header {
  QlBuiltins::BigInt getImageBase() {
    exists(int a, int b |
      optional_header(this, a, b, _) and
      result = a.toBigInt() * "4294967297".toBigInt() + b.toBigInt()
    )
  }

  int getEntryPoint() { optional_header(this, _, _, result) }

  string toString() { result = "Optional header" }
}
