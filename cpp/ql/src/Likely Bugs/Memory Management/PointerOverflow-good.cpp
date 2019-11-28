bool not_in_range(T *ptr, T *ptr_end, size_t i) {
    return i >= ptr_end - ptr; // GOOD
}