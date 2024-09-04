typedef unsigned char Bytef;
typedef unsigned long uLong;
typedef uLong uLongf;
typedef unsigned int uInt;

struct z_stream {
    Bytef *next_in;
    Bytef *next_out;
    uInt avail_out;
};

void inflateInit(z_stream *infstream);
void inflate(z_stream *infstream, int i);
void inflateEnd(z_stream *infstream);

void UnsafeInflate(char *input) {
    unsigned char output[1024];

    z_stream infstream;
    infstream.next_in = (Bytef *) input; // input char array
    infstream.avail_out = sizeof(output); // size of output
    infstream.next_out = output; // output char array

    inflateInit(&infstream);
    inflate(&infstream, 0); // BAD
}


struct gzFile {
};

gzFile gzopen(char *str, const char *rb);
unsigned int gzread(gzFile gz_file, unsigned char *str, int i);
bool gzfread(char *str, int i, int i1, gzFile gz_file);
char *gzgets(gzFile gz_file, char *buffer, int i);

void UnsafeGzread(char *fileName) {
    gzFile inFileZ = gzopen(fileName, "rb");
    unsigned char unzipBuffer[8192];
    while (true) {
        if (gzread(inFileZ, unzipBuffer, 8192) <= 0) { // BAD
            break;
        }
    }
}

void UnsafeGzfread(char *fileName) {
    gzFile inFileZ = gzopen(fileName, "rb");
    while (true) {
        char buffer[1000];
        if (!gzfread(buffer, 999, 1, inFileZ)) { // BAD
            break;
        }
    }
}

void UnsafeGzgets(char *fileName) {
    gzFile inFileZ = gzopen(fileName, "rb");
    char *buffer = new char[4000000000];
    char *result;
    while (true) {
        result = gzgets(inFileZ, buffer, 1000000000); // BAD
        if (result == nullptr) {
            break;
        }
    }
}

int uncompress(Bytef *dest, uLongf *destLen, const Bytef *source, uLong sourceLen);

void InflateString(char *input) {
    unsigned char output[1024];

    uLong source_length = 500;
    uLong destination_length = sizeof(output);

    uncompress(output, &destination_length, (Bytef *) input, source_length); // BAD
}

void zlib_test(int argc, char **argv) {
    UnsafeGzfread(argv[2]);
    UnsafeGzgets(argv[2]);
    UnsafeInflate(argv[2]);
    UnsafeGzread(argv[2]);
    InflateString(argv[2]);
}
