unsigned int ntohl(unsigned int netlong);

void test_ntohl(
        unsigned int netlong0, unsigned int netlong1, unsigned int netlong2,
        int * arr, unsigned int arr_size) {
    unsigned int hostlong0 = ntohl(netlong0);
    unsigned int hostlong1 = ntohl(netlong1);
    unsigned int hostlong2 = ntohl(netlong2);

    int val0 = arr[hostlong0];

    if (hostlong1 < arr_size) {
        int val1 = arr[hostlong1];
    }

    for (unsigned int i = 0; i < hostlong2; ++i) {
        int val2 = arr[i];
    }
}
