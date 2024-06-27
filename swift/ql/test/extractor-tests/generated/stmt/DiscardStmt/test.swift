@_moveOnly
struct S {
  __consuming func f() {
    discard self
  }
  deinit {}
}
