import cpp

// The typing rules for array indexing in C/C++ are quite subtle.
// It is important that array indexing is handled correctly in
// StackAddressEscapes.ql, so the purpose of this test is to make
// sure that the types behave in the way that we expect.
from ArrayExpr arrayExpr
select arrayExpr,
  arrayExpr.getArrayBase().getUnspecifiedType().toString() + ", " +
    arrayExpr.getArrayBase().getFullyConverted().getUnspecifiedType().toString() + ", " +
    arrayExpr.getUnspecifiedType().toString()
