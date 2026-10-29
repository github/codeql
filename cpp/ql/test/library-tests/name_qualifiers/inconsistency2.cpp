namespace {
template <typename T> T f() {
  T::x;
  return {};
}
struct s {
  static int x;
};
struct t {
  s x = f<const s>();
};
}
