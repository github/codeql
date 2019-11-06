bool check_pointer_overflow(P *ptr, P *ptr_end) {
    return ptr_end - ptr >= 4; // GOOD
}
