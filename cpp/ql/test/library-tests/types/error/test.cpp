// codeql-extractor-compiler-options: -Xsemmle--expect_errors

int &intref = 0; // ErrorExpr with ErroneousType
