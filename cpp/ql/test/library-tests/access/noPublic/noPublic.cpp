// Some of our libraries depend on the resulting access of a hypothetical
// public member. This test verifies that the database contains QL
// `AccessSpecifier` instances for both `private` and `public` even when
// extracting a program that does not contain those keywords. Indeed, this
// program contains nothing at all except this comment.
