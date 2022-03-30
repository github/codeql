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
    return ptr_end - ptr > 4; // GOOD
}

struct Q {
	#define Q_SIZE 32
	char arr[Q_SIZE];
	char *begin() { return &arr[0]; }
	char *end() { return &arr[Q_SIZE]; }
};

void foo(int untrusted_int) {
	Q q;
    if (q.begin() + untrusted_int > q.end() || // GOOD (for the purpose of this test)
          q.begin() + untrusted_int < q.begin()) // BAD [NOT DETECTED]
      throw q;
}

typedef unsigned long size_t;

bool not_in_range_bad(Q *ptr, Q *ptr_end, size_t a) {
    return ptr + a >= ptr_end || // GOOD (for the purpose of this test)
        ptr + a < ptr; // BAD
}

bool not_in_range_good(Q *ptr, Q *ptr_end, size_t a) {
    return a >= ptr_end - ptr; // GOOD
}

bool in_range(Q *ptr, Q *ptr_end, size_t a) {
    return a < ptr_end - ptr; // GOOD
}

extern "C" void abort(void);

#define MYASSERT(cond) if (cond) abort()

void assert_not_in_range_bad(Q *ptr, Q *ptr_end, size_t a) {
    MYASSERT(ptr + a >= ptr_end || ptr + a < ptr); // BAD
    MYASSERT(ptr + a >= ptr_end); // GOOD (for the purpose of this test)
    MYASSERT(ptr + a < ptr); // BAD
}

#define IS_LESS_THAN(lhs, rhs) ((lhs) < (rhs))

bool not_in_range_macro(Q *ptr, Q *ptr_end, size_t a) {
    return ptr + a >= ptr_end || IS_LESS_THAN(ptr + a, ptr); // GOOD (meant to be excluded)
}
