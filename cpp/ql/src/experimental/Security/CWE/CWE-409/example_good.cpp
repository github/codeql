#include "zlib.h"

void SafeGzread(gzFile inFileZ) {
    const int MAX_READ = 1024 * 1024 * 4;
    const int BUFFER_SIZE = 8192;
    unsigned char unzipBuffer[BUFFER_SIZE];
    unsigned int unzippedBytes;
    unsigned int totalRead = 0;
    while (true) {
        unzippedBytes = gzread(inFileZ, unzipBuffer, BUFFER_SIZE);
        totalRead += unzippedBytes;
        if (unzippedBytes <= 0) {
            break;
        }

        if (totalRead > MAX_READ) {
            // Possible decompression bomb, stop processing.
            break;
        } else {
            // process buffer
        }
    }
}
