import javascript

query predicate test_query21(JSDocTag t, string res) {
  t.getTitle() = "param" and not exists(t.getName()) and res = "@param tag is missing name."
}
