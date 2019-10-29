bool check_pointer_overflow(P *ptr, P *ptr_end) {
    return ptr + 4 >= ptr_end; // GOOD
}
