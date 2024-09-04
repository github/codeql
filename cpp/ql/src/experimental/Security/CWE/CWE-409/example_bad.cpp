#include "zlib.h"

void UnsafeGzread(gzFile inFileZ) {
    const int BUFFER_SIZE = 8192;
    unsigned char unzipBuffer[BUFFER_SIZE];
    unsigned int unzippedBytes;
    while (true) {
        unzippedBytes = gzread(inFileZ, unzipBuffer, BUFFER_SIZE);
        if (unzippedBytes <= 0) {
            break;
        }

        // process buffer
    }
}
