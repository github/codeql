// semmle-extractor-options: -std=c++17

// Test cases that illustrate known bad ASTs that we have to work around in IR generation.
namespace Bad {
  struct S {
    int x;

    template<int t>
    int MemberFunction(int y) {
      return t + x + y;
    }
  };

  void CallBadMemberFunction() {
    S s = {};
    s.MemberFunction<6>(1);  // Not marked as member function in AST.
  }

  struct Point {
    int x;
    int y;
    Point() {
    }
  };

  void CallCopyConstructor(const Point& a) {
    Point b = a;  // Copy constructor contains literal expressions with no values.
  }
}
