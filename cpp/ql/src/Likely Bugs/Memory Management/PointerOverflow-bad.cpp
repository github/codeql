bool not_in_range(T *ptr, T *ptr_end, size_t a) {
    return ptr + a >= ptr_end || ptr + a < ptr; // BAD
}
