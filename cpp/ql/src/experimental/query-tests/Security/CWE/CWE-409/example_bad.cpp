#include <iostream>
#include <vector>
#include "zlib.h"
#include <cstdio>
#include <cstring>

int UnsafeInflate(int argc, char *argv[]) {
    // original string len = 36
    char a[50] = "Hello Hello Hello Hello Hello Hello!";
    // placeholder for the compressed (deflated) version of "a"
    char b[50];
    // placeholder for the Uncompressed (inflated) version of "b"
    char c[50];
    printf("Uncompressed size is: %lu\n", strlen(a));
    printf("Uncompressed string is: %s\n", a);
    printf("\n----------\n\n");

    // STEP 1.
    // zlib struct
    z_stream defstream;
    defstream.zalloc = Z_NULL;
    defstream.zfree = Z_NULL;
    defstream.opaque = Z_NULL;
    // setup "a" as the input and "b" as the compressed output
    defstream.avail_in = (uInt) strlen(a) + 1; // size of input, string + terminator
    defstream.next_in = (Bytef *) a; // input char array
    defstream.avail_out = (uInt) sizeof(b); // size of output
    defstream.next_out = (Bytef *) b; // output char array

    // the actual compression work.
    deflateInit(&defstream, Z_BEST_COMPRESSION);
    deflate(&defstream, Z_FINISH);
    deflateEnd(&defstream);

    // This is one way of getting the size of the output
    printf("Compressed size is: %lu\n", strlen(b));
    printf("Compressed string is: %s\n", b);
    printf("\n----------\n\n");
    // STEP 2.
    // inflate b into c
    // zlib struct
    z_stream infstream;
    infstream.zalloc = Z_NULL;
    infstream.zfree = Z_NULL;
    infstream.opaque = Z_NULL;
    // setup "b" as the input and "c" as the compressed output
    // TOTHINK: Here we can add additional step from Right operand to z_stream variable access
    infstream.avail_in = (uInt) ((char *) defstream.next_out - b); // size of input
    infstream.next_in = (Bytef *) b; // input char array
    infstream.avail_out = (uInt) sizeof(c); // size of output
    infstream.next_out = (Bytef *) c; // output char array

    // uLong  total_out; /* total number of bytes output so far */
    // the actual DE-compression work.
    inflateInit(&infstream);
    std::cout << infstream.total_out << std::endl;
    inflate(&infstream, Z_NO_FLUSH);
    std::cout << infstream.total_out << std::endl;
    inflateEnd(&infstream);

    printf("Uncompressed size is: %lu\n", strlen(c));
    printf("Uncompressed string is: %s\n", c);
    return 0;
}

int UnsafeGzread() {
    std::cout << "enter compressed file name!\n" << std::endl;
    char fileName[100];
    std::cin >> fileName;
    gzFile inFileZ = gzopen(fileName, "rb");
    if (inFileZ == nullptr) {
        printf("Error: Failed to gzopen %s\n", fileName);
        exit(0);
    }
    unsigned char unzipBuffer[8192];
    unsigned int unzippedBytes;
    std::vector<unsigned char> unzippedData;
    while (true) {
        unzippedBytes = gzread(inFileZ, unzipBuffer, 8192);
        if (unzippedBytes > 0) {
            unzippedData.insert(unzippedData.end(), unzipBuffer, unzipBuffer + unzippedBytes);
        } else {
            break;
        }
    }
    for (auto &&i: unzippedData)
        std::cout << i;
    gzclose(inFileZ);
    return 0;
}

int UnsafeGzfread() {
    std::cout << "enter compressed file name!\n" << std::endl;
    char fileName[100];
    std::cin >> fileName;
    gzFile inFileZ = gzopen(fileName, "rb");
    if (inFileZ == nullptr) {
        printf("Error: Failed to gzopen %s\n", fileName);
        exit(0);
    }
    while (true) {
        char buffer[1000];
        if (!gzfread(buffer, 999, 1, inFileZ)) {
            break;
        }
    }
    gzclose(inFileZ);
    return 0;
}

int UnsafeGzgets() {
    std::cout << "enter compressed file name!\n" << std::endl;
    char fileName[100];
    std::cin >> fileName;
    gzFile inFileZ = gzopen(fileName, "rb");
    if (inFileZ == nullptr) {
        printf("Error: Failed to gzopen %s\n", fileName);
        exit(0);
    }
    char *buffer = new char[4000000000];
    char *result = gzgets(inFileZ, buffer, 1000000000);
    while (true) {
        result = gzgets(inFileZ, buffer, 1000000000);
        if (result == nullptr) {
            break;
        }
    }
    return 0;
}
