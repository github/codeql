int brotli_test(int argc, const char **argv);
int libarchive_test(int argc, const char **argv);
int minizip_test(int argc, const char **argv);
int zlib_test(int argc, const char **argv);
int zstd_test(int argc, const char **argv);

int main(int argc, const char **argv) {
    brotli_test(argc, argv);
    libarchive_test(argc, argv);
    minizip_test(argc, argv);
    zlib_test(argc, argv);
    zstd_test(argc, argv);
    return 0;
}
