
template<class T>
struct X
{
  public:
    operator T*() { return (T*)1; };
};

template<typename P>
  struct S;

template<typename Q>
  struct S<Q*>
  {
  public:
    operator Q*() { return (Q*)2; }
  };

void f(void) {
  struct X<int> x;
  (int *)x;
  struct S<int *> s;
  (int *)s;
}

