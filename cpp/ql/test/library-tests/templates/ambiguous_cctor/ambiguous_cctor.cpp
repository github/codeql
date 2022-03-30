struct copyable
{
  copyable(const copyable&);
  template <typename T> copyable(const T&);
};

template <typename T>
struct templated
{
  copyable method() {
    return T();
  }
};

int main() {
  struct templated<int> s;
  // s.method(); TODO: This causes DBCheck failures
  return 0;
}
