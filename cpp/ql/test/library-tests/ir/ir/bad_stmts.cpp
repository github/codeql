// semmle-extractor-options: -std=c++17 --expect_errors

// Test cases that illustrate known bad ASTs that we have to work around in IR generation.
namespace Bad {
  void errorExpr() {
    int &intref = 0;
    int x = 0[0];
    x = 1[1];
  }
}
