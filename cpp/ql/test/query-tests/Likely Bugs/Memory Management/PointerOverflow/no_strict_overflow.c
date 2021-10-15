// semmle-extractor-options: -fno-strict-overflow

int not_in_range_nostrict(int *ptr, int *ptr_end, unsigned int a) {
    return ptr + a < ptr_end || // GOOD (for the purpose of this test)
        ptr + a < ptr; // GOOD (due to compiler options)
}
