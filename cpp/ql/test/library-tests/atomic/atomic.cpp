template <typename T>
struct atomic_box
{
  mutable _Atomic(T) value;
};

int main() {
  _Atomic int a;
  _Atomic(int) b;
  _Atomic int *c, d;
  _Atomic(int*) e, f;
  atomic_box<int> g;
  _Atomic const int h = 0;
  const _Atomic(int) i = 0;
  _Atomic(_Atomic(int)*) j;
  _Atomic int* _Atomic k;
  int m = 0;
  
  a = m;
  m = a;
}
