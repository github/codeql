
namespace foo {
  namespace bar {
    void f(int i) {
      int j;
      try {
        for (i = 0; i < 3; i++) {
          int k;
        }
      }
      catch (int e) {
      }
    }
  }
}

template<typename T>
T var = 42;

int g() {
  requires(int l) { l; };

  return var<int>;
}

// semmle-extractor-options: -std=c++20
