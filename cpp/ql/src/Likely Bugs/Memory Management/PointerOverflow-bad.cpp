bool not_in_range(T *ptr, T *ptr_end, size_t i) {
    return ptr + i >= ptr_end || ptr + i < ptr; // BAD
}
