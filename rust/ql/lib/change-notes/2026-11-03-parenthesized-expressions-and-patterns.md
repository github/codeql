---
category: minorAnalysis
---
* The Rust AST no longer exposes `ParenExpr` and `ParenPat` nodes. Parenthesized expressions and patterns are represented by their inner entities instead.
* The `rust/access-after-lifetime-ended` query now detects more accesses through pointers to struct fields created by `std::ptr::addr_of!` and `std::ptr::addr_of_mut!`.
