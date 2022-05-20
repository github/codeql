typedef unsigned char uint8_t;
#define SIZE (32)

void test_buffer_overrun_in_for_loop()
{
    uint8_t data[SIZE] = {0};
    for (int x = 0; x < SIZE * 2; x++) {
        data[x] = 0x41; // BAD [NOT DETECTED]
    }
}

void test_buffer_overrun_in_while_loop_using_pointer_arithmetic()
{
    uint8_t data[SIZE] = {0};
    int offset = 0;
    while (offset < SIZE * 2) {
        *(data + offset) = 0x41; // BAD [NOT DETECTED]
        offset++;
    }
}

void test_buffer_overrun_in_while_loop_using_array_indexing()
{
    uint8_t data[SIZE] = {0};
    int offset = 0;
    while (offset < SIZE * 2) {
        data[offset] = 0x41; // BAD [NOT DETECTED]
        offset++;
    }
}

int main(int argc, char *argv[])
{
    test_buffer_overrun_in_for_loop();
    test_buffer_overrun_in_while_loop_using_pointer_arithmetic();
    test_buffer_overrun_in_while_loop_using_array_indexing();

    return 0;
}
