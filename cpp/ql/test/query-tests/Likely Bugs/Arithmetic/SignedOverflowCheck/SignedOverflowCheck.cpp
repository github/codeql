// Signed-comparison tests

/* 1. Signed-signed comparison.  The semantics are undefined. */
bool cannotHoldAnother8(int n1) {
    // clang 8.0.0 -O2: deleted (silently)
    // gcc 9.2 -O2: deleted (silently)
    // msvc 19.22 /O2: not deleted
    return n1 + 8 < n1; // BAD
}

/* 2. Signed comparison with a narrower unsigned type.  The narrower
      type gets promoted to the (signed) larger type, and so the
      semantics are undefined. */
bool cannotHoldAnotherUShort(int n1, unsigned short delta) {
    // clang 8.0.0 -O2: deleted (silently)
    // gcc 9.2 -O2: deleted (silently)
    // msvc 19.22 /O2: not deleted
    return n1 + delta < n1; // BAD
}

/* 3. Signed comparison with a non-narrower unsigned type.  The
      signed type gets promoted to (a possibly wider) unsigned type,
      and the resulting comparison is unsigned. */
bool cannotHoldAnotherUInt(int n1, unsigned int delta) {
    // clang 8.0.0 -O2: not deleted
    // gcc 9.2 -O2: not deleted
    // msvc 19.22 /O2: not deleted
    return n1 + delta < n1; // GOOD
}
