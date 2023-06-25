#include <iostream>
#include <vector>
#include "zlib.h"
int UnsafeRead() {
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

   for ( auto &&i: unzippedData)
       std::cout << i;
    gzclose(inFileZ);

    return 0;
}