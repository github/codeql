bool check_pointer_overflow(P *ptr) {
    return ptr + 0x12345678 < ptr; // BAD
}
