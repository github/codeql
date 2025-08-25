typedef signed int int32_t;

void *mz_zip_reader_create();
int32_t mz_zip_reader_open_file(void *handle, const char *path);
int32_t mz_zip_reader_goto_first_entry(void *pVoid);
int32_t mz_zip_reader_entry_save(void *pVoid, int stream, int write);
int32_t mz_zip_entry_read(void *pVoid, void *buf, int32_t i);
void UnzOpen(const char *string);

void *mz_zip_create();

void minizip_test(int argc, const char **argv) {
    void *zip_handle = mz_zip_create();
    int32_t bytes_read;
    char buf[4096];
    while(true) {
        bytes_read = mz_zip_entry_read(zip_handle, (char *) argv[1], sizeof(buf)); // BAD
        if (bytes_read <= 0) {
            break;
        }
    }

    void *zip_reader = mz_zip_reader_create();
    mz_zip_reader_open_file(zip_reader, argv[1]);
    mz_zip_reader_goto_first_entry(zip_reader);
    mz_zip_reader_entry_save(zip_reader, 0, 0); // BAD

    UnzOpen(argv[3]); // BAD
}
