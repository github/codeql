#define Z_NULL  0
#  define FAR
typedef unsigned char Byte;
typedef Byte FAR Bytef;
typedef unsigned int uInt;
#define Z_BEST_COMPRESSION       9
#define Z_FINISH        4
#define Z_NO_FLUSH      0


typedef struct {
    int *zalloc;
    int *zfree;
    Bytef *next_in;
    Bytef *next_out;
    int *opaque;
    uInt avail_out;
    uInt avail_in;
} z_stream;


void deflateInit(z_stream *defstream, int i);

void deflate(z_stream *defstream, int i);

void deflateEnd(z_stream *defstream);

void inflateInit(z_stream *infstream);

void inflate(z_stream *infstream, int i);

void inflateEnd(z_stream *infstream);

namespace std {
    template<class charT>
    struct char_traits;

    template<class charT, class traits = char_traits<charT> >
    class basic_ostream {
    public:
        typedef charT char_type;
    };

    template<class charT, class traits>
    basic_ostream<charT, traits> &operator<<(basic_ostream<charT, traits> &, const charT *);

    typedef basic_ostream<char> ostream;

    extern ostream cout;
}

int UnsafeInflate(char *a) {
    // placeholder for the Uncompressed (inflated) version of "a"
    char c[1024000];

    z_stream infstream;
    infstream.zalloc = Z_NULL;
    infstream.zfree = Z_NULL;
    infstream.opaque = Z_NULL;
    // setup "b" as the input and "c" as the compressed output
    // TOTHINK: Here we can add additional step from Right operand to z_stream variable access
    infstream.avail_in = (uInt) (1000); // size of input
    infstream.next_in = (Bytef *) a; // input char array
    infstream.avail_out = (uInt) sizeof(c); // size of output
    infstream.next_out = (Bytef *) c; // output char array

    // uLong  total_out; /* total number of bytes output so far */
    // the actual DE-compression work.
    inflateInit(&infstream);
    inflate(&infstream, Z_NO_FLUSH); // BAD
    inflateEnd(&infstream);


    return 0;
}


typedef struct {
} gzFile;

gzFile gzopen(char *str, const char *rb);


void exit(int i);

unsigned int gzread(gzFile gz_file, unsigned char *str, int i);

void gzclose(gzFile gz_file);

std::ostream operator<<(const std::ostream &lhs, unsigned char rhs);


int UnsafeGzread(char *fileName) {
    gzFile inFileZ = gzopen(fileName, "rb");
    if (&inFileZ == nullptr) {
        exit(0);
    }
    unsigned char unzipBuffer[8192];
    unsigned int unzippedBytes;
    while (true) {
        unzippedBytes = gzread(inFileZ, unzipBuffer, 8192); // BAD
        if (unzippedBytes > 0) {
            std::cout << unzippedBytes;
        } else {
            break;
        }
    }
    gzclose(inFileZ);
    return 0;
}

bool gzfread(char *str, int i, int i1, gzFile gz_file);

int UnsafeGzfread(char *fileName) {
    gzFile inFileZ = gzopen(fileName, "rb");
    if (&inFileZ == nullptr) {
        exit(0);
    }
    while (true) {
        char buffer[1000];
        if (!gzfread(buffer, 999, 1, inFileZ)) { // BAD
            break;
        }
    }
    gzclose(inFileZ);
    return 0;
}

char *gzgets(gzFile gz_file, char *buffer, int i);

int UnsafeGzgets(char *fileName) {
    gzFile inFileZ = gzopen(fileName, "rb");
    if (&inFileZ == nullptr) {
        exit(0);
    }
    char *buffer = new char[4000000000];
    char *result;
    while (true) {
        result = gzgets(inFileZ, buffer, 1000000000); // BAD
        if (result == nullptr) {
            break;
        }
    }
    return 0;
}

typedef unsigned long uLong;
typedef long unsigned int size_t;
typedef uLong uLongf;
typedef unsigned char Bytef;
#define Z_OK            0

int uncompress(Bytef *dest, uLongf *destLen,
               const Bytef *source, uLong sourceLen) { return 0; }

bool InflateString(const unsigned char *input, const unsigned char *output, size_t output_length) {
    uLong source_length;
    source_length = (uLong) 500;
    uLong destination_length;
    destination_length = (uLong) output_length;

    int result = uncompress((Bytef *) output, &destination_length,
                            (Bytef *) input, source_length); // BAD

    return result == Z_OK;
}

int zlib_test(int argc, char **argv) {
    UnsafeGzfread(argv[2]);
    UnsafeGzgets(argv[2]);
    UnsafeInflate(argv[2]);
    UnsafeGzread(argv[2]);
    const unsigned char *output;
    InflateString(reinterpret_cast<const unsigned char *>(argv[1]), output, 1024 * 1024 * 1024);
}
