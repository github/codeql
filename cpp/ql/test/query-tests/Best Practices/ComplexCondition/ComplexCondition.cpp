void complex_condition(bool a, bool b, bool c, bool d, bool e, bool f, bool g, bool h, bool i, bool j,
    bool k, bool l, bool m, bool n, bool o) {
  if (a || b && c || d && e || f && g || h && i || j && k || l && m || n && o) { // $ Alert
  }
}

void not_complex_condition(bool a, bool b, bool c, bool d, bool e, bool f) {
  if (a && b || c && d || e && f) {
  }
}
