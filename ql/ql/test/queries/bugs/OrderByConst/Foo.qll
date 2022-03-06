string foo() {
  result = concat(string x | x = [0 .. 10].toString() | x order by x desc, ", ") // BAD
  or
  result = concat(string x | x = [0 .. 10].toString() | x, ", " order by x desc) // GOOD
}

class Even extends int {
  bindingset[this]
  Even() { this % 2 = 0 }
}
