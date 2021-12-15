template <typename T>
struct Parameterized {
  ~Parameterized() { throw "destructor"; }
};

struct Concrete {
  Parameterized<int> member;
};

int main() { Concrete c; }
