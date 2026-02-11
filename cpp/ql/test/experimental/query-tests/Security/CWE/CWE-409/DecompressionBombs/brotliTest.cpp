typedef long unsigned int size_t;
typedef unsigned char uint8_t;

enum BrotliDecoderResult {};
struct BrotliDecoderState;

BrotliDecoderResult BrotliDecoderDecompress(
        size_t encoded_size, const uint8_t encoded_buffer[],
        size_t *decoded_size, uint8_t decoded_buffer[]);

BrotliDecoderResult BrotliDecoderDecompressStream(
        BrotliDecoderState *state, size_t *available_in, const uint8_t **next_in,
        size_t *available_out, uint8_t **next_out, size_t *total_out);

void brotli_test(int argc, const char **argv) {
    uint8_t output[1024];
    size_t output_size = sizeof(output);
    BrotliDecoderDecompress(1024, (uint8_t *) argv[2], &output_size, output); // BAD

    size_t input_size = 1024;
    const uint8_t *input_p = (const uint8_t*)argv[2];
    uint8_t *output_p = output;
    size_t out_size;
    BrotliDecoderDecompressStream(0, &input_size, &input_p, &output_size, // BAD
                                  &output_p, &out_size);
}
