typedef struct _IO_FILE FILE;

FILE *fopen_orDie(const char *filename, const char *instruction);

typedef long unsigned int size_t;

const size_t ZSTD_DStreamInSize();

void *const malloc_orDie(const size_t size);

const size_t ZSTD_DStreamOutSize();

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

ZSTD_DCtx *const ZSTD_createDCtx();

void CHECK(bool b, const char *string);

size_t fread_orDie(void *const pVoid, const size_t read, FILE *const pFile);

void CHECK_ZSTD(const size_t ret);

void fwrite_orDie(void *const pVoid, size_t pos, FILE *const pFile);

void exit(int i);

void fclose_orDie(FILE *const pFile);

void free(void *const pVoid);

const size_t ZSTD_decompressStream(ZSTD_DCtx *const pCtx, ZSTD_outBuffer *pS, ZSTD_inBuffer *pS1);

void ZSTD_freeDCtx(ZSTD_DCtx *const pCtx);

static void decompressFile_orDie(const char *fname) {
    FILE *const fin = fopen_orDie(fname, "rb");
    size_t const buffInSize = ZSTD_DStreamInSize();
    void *const buffIn = malloc_orDie(buffInSize);
    FILE *stdout;
    FILE *const fout = stdout;
    size_t const buffOutSize = ZSTD_DStreamOutSize();  /* Guarantee to successfully flush at least one complete compressed block in all circumstances. */
    void *const buffOut = malloc_orDie(buffOutSize);

    ZSTD_DCtx *const dctx = ZSTD_createDCtx();
    CHECK(dctx != nullptr, "ZSTD_createDCtx() failed!");
    size_t const toRead = buffInSize;
    size_t read;
    size_t lastRet = 0;
    int isEmpty = 1;
    while ((read = fread_orDie(buffIn, toRead, fin))) {
        isEmpty = 0;
        ZSTD_inBuffer input = {buffIn, read, 0};
        while (input.pos < input.size) {
            ZSTD_outBuffer output = {buffOut, buffOutSize, 0};
            size_t const ret = ZSTD_decompressStream(dctx, &output, &input);
            CHECK_ZSTD(ret);
            fwrite_orDie(buffOut, output.pos, fout);
            lastRet = ret;
        }
    }
    if (isEmpty) {
        exit(1);
    }
    if (lastRet != 0) {
        exit(1);
    }
    ZSTD_freeDCtx(dctx);
    fclose_orDie(fin);
    fclose_orDie(fout);
    free(buffIn);
    free(buffOut);
}


void zstd_test(int argc, const char **argv) {
    const char *const inFilename = argv[1];
    decompressFile_orDie(inFilename);
}
