void complex_condition_one(bool a, bool b, bool c, bool d, bool e, bool f, bool g, bool h, bool i, bool j,
    bool k, bool l) {
  if (a && b || c && d || e && f || g && h || i && j || k && l) { // $ Alert
  }
}

void complex_condition_two(bool a, bool b, bool c, bool d, bool e, bool f, bool g, bool h, bool i, bool j,
    bool k, bool l, bool m) {
  if (a || b && c || d && e || f && g || h && i || j && k || l && m) { // $ Alert
  }
}

void five_logical_operations_is_not_enough(bool a, bool b, bool c, bool d, bool e, bool f) {
  if (a && b || c && d || e && f) {
  }
}
