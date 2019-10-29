struct P { int a, b; };
bool check_pointer_overflow(P *ptr) {
    // x86-64 gcc 9.2 -O2: deleted
    // x86-64 clang 9.9.9 -O2: deleted
    // x64 msvc v19.22 /O2: not deleted
    return ptr + 0x12345678 < ptr; // BAD
}
bool check_pointer_overflow(P *ptr, P *ptr_end) {
    // x86-64 gcc 9.2 -O2: not deleted
    // x86-64 clang 9.0.0 -O2: not deleted
    // x64 msvc v19.22 /O2: not deleted
    return ptr + 4 >= ptr_end; // GOOD
}
