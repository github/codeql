bool not_in_range(T *ptr, size_t a) {
    return ptr + a < ptr; // BAD
}
