
struct S : ~Copyable {
  __consuming func f() {
    discard self
  }
  deinit {}
}
