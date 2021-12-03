template <typename T>
int fn(T out) {
  typedef int y[sizeof(out) + 1];
  return 0;
}

int main() {
  return fn(0);
}
