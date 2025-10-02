bindingset[section, a, b]
pragma[inline_late]
private predicate section_byteLate(Section section, int a, int b, int byte) {
  section_byte(section, a, b, byte)
}

bindingset[offset]
pragma[inline_late]
private QlBuiltins::BigInt read8Bytes(Section s, QlBuiltins::BigInt offset) {
  exists(int b0, int b1, int b2, int b3, int b4, int b5, int b6, int b7 |
    b0 = s.getByte(offset) and
    b1 = s.getByte(offset + 1.toBigInt()) and
    b2 = s.getByte(offset + 2.toBigInt()) and
    b3 = s.getByte(offset + 3.toBigInt()) and
    b4 = s.getByte(offset + 4.toBigInt()) and
    b5 = s.getByte(offset + 5.toBigInt()) and
    b6 = s.getByte(offset + 6.toBigInt()) and
    b7 = s.getByte(offset + 7.toBigInt()) and
    result =
      b0.toBigInt() + b1.toBigInt().bitShiftLeft(8) + b2.toBigInt().bitShiftLeft(16) +
        b3.toBigInt().bitShiftLeft(24) + b4.toBigInt().bitShiftLeft(32) +
        b5.toBigInt().bitShiftLeft(40) + b6.toBigInt().bitShiftLeft(48) +
        b7.toBigInt().bitShiftLeft(56)
  )
}

class Section extends @section {
  int getVirtualAddress() { section(this, _, result, _) }

  string getName() { section(this, result, _, _) }

  int getOffset() { section(this, _, _, result) }

  string toString() { result = this.getName() }

  bindingset[offset]
  pragma[inline_late]
  int getByte(QlBuiltins::BigInt offset) {
    exists(int a, int b |
      a = (offset / "4294967297".toBigInt()).toInt() and
      b = (offset % "4294967297".toBigInt()).toInt() and
      section_byteLate(this, a, b, result)
    )
  }

  bindingset[offset]
  pragma[inline_late]
  QlBuiltins::BigInt read8Bytes(QlBuiltins::BigInt offset) { result = read8Bytes(this, offset) }
}

class TextSection extends Section {
  TextSection() { text_section(this) }
}

class RDataSection extends Section {
  RDataSection() { rdata_section(this) }
}
