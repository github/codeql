template <typename T>
void f() {
  T t = 4;
  t + t;
  some_function(&t, sizeof(T), sizeof(t), alignof(T), alignof(t));
}

void g();

int main() {
  return 0;
}
