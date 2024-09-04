typedef long unsigned int size_t;
typedef unsigned char uint8_t;
typedef enum {
} BrotliDecoderResult;

BrotliDecoderResult BrotliDecoderDecompress(
        size_t encoded_size,
        const uint8_t encoded_buffer[],
        size_t *decoded_size,
        uint8_t decoded_buffer[]) { return static_cast<BrotliDecoderResult>(0); };

void strncpy(char *string, const char *string1, int i);

typedef struct BrotliDecoderStateStruct BrotliDecoderState;

BrotliDecoderResult BrotliDecoderDecompressStream(
        BrotliDecoderState *state, size_t *available_in, const uint8_t **next_in,
        size_t *available_out, uint8_t **next_out, size_t *total_out) { return static_cast<BrotliDecoderResult>(0); };

namespace std {
    void strncpy(char *string, const char *string1, int i) {

    }
}

int brotli_test(int argc, const char **argv) {
    uint8_t *output = nullptr;
    BrotliDecoderDecompress(1024 * 1024, (uint8_t *) argv[2], // BAD
                            reinterpret_cast<size_t *>(1024 * 1024 * 1024), output);
    uint8_t **output2 = nullptr;
    const uint8_t **input2 = nullptr;
    std::strncpy(reinterpret_cast<char *>(input2), argv[2], 32);
    BrotliDecoderDecompressStream(0, reinterpret_cast<size_t *>(1024 * 1024),
                                  input2, reinterpret_cast<size_t *>(1024 * 1024 * 1024), // BAD
                                  output2,
                                  reinterpret_cast<size_t *>(1024 * 1024 * 1024));
    return 0;
}
