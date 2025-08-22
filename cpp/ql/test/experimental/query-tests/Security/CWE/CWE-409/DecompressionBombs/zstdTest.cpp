typedef long unsigned int size_t;
struct FILE;

FILE *fopen_orDie(const char *filename, const char *instruction);
size_t fread_orDie(void *const pVoid, const size_t read, FILE *const pFile);
void *const malloc_orDie(const size_t size);

struct ZSTD_DCtx;
typedef struct ZSTD_inBuffer_s {
    const void *src;
    size_t size;
    size_t pos;
} ZSTD_inBuffer;
typedef struct ZSTD_outBuffer_s {
    void *dst;
    size_t size;
    size_t pos;
} ZSTD_outBuffer;

const size_t ZSTD_DStreamInSize();
const size_t ZSTD_DStreamOutSize();
ZSTD_DCtx *const ZSTD_createDCtx();
const size_t ZSTD_decompressStream(ZSTD_DCtx *const pCtx, ZSTD_outBuffer *pS, ZSTD_inBuffer *pS1);
void CHECK_ZSTD(const size_t ret);

void zstd_test(int argc, const char **argv) {
    FILE *const fin = fopen_orDie(argv[1], "rb");
    size_t const buffInSize = ZSTD_DStreamInSize();
    void *const buffIn = malloc_orDie(buffInSize);
    size_t const buffOutSize = ZSTD_DStreamOutSize();
    void *const buffOut = malloc_orDie(buffOutSize);

    ZSTD_DCtx *const dctx = ZSTD_createDCtx();
    size_t read;
    while ((read = fread_orDie(buffIn, buffInSize, fin))) {
        ZSTD_inBuffer input = {buffIn, read, 0};
        while (input.pos < input.size) {
            ZSTD_outBuffer output = {buffOut, buffOutSize, 0};
            size_t const ret = ZSTD_decompressStream(dctx, &output, &input); // BAD  
            CHECK_ZSTD(ret);
        }
    }
}
