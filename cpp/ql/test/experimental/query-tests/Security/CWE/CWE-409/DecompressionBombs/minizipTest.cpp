typedef signed int int32_t;

void *mz_stream_os_create();

int32_t mz_zip_reader_open_file(void *handle, const char *path);

int32_t mz_zip_reader_open_file_in_memory(void *handle, const char *path);

void *mz_zip_reader_create();

int32_t mz_zip_reader_goto_first_entry(void *pVoid);

int32_t mz_stream_os_open(void *pVoid, const char *path, int write);

void mz_stream_os_close(void *pVoid);

void mz_stream_os_delete(void **pVoid);

void mz_zip_reader_close(void *pVoid);

void mz_zip_reader_delete(void **pVoid);

int32_t mz_zip_reader_entry_save(void *pVoid, int stream, int write);


void UnzOpen(const char *string);

int32_t mz_zip_entry_read(void *pVoid, void *buf, int32_t i);

void *mz_zip_create() {
    return nullptr;
}

int minizip_test(int argc, const char **argv) {
    void *zip_handle = mz_zip_create();
    int32_t bytes_read;
    int32_t err;
    char buf[4096];
    do {
        bytes_read = mz_zip_entry_read(zip_handle, (char *) argv[1], sizeof(buf)); // BAD
        if (bytes_read < 0) {
            err = bytes_read;
        }
        // Do something with buf bytes
    } while (err == 1 && bytes_read > 0);


    const char *entry_path = "c:\\entry.dat";

    void *zip_reader = mz_zip_reader_create();

    mz_zip_reader_open_file(zip_reader, argv[1]);
    mz_zip_reader_goto_first_entry(zip_reader);
    void *entry_stream = mz_stream_os_create();
    mz_stream_os_open(entry_stream, entry_path, 1);
    int file_stream;
    int mz_stream_os_write;
    mz_zip_reader_entry_save(zip_reader, file_stream, mz_stream_os_write); // BAD
    // the above sink is same as "mz_zip_reader_entry_save", "mz_zip_reader_entry_read", "mz_zip_reader_entry_save_process",
    // "mz_zip_reader_entry_save_file", "mz_zip_reader_entry_save_buffer", "mz_zip_reader_save_all" and "mz_zip_entry_read" functions
    mz_stream_os_close(entry_stream);
    mz_stream_os_delete(&entry_stream);
    mz_zip_reader_close(zip_reader);
    mz_zip_reader_delete(&zip_reader);


    UnzOpen(argv[3]); // BAD
    return 0;
}

void UnzOpen(const char *path);

int32_t mz_zip_reader_entry_save(void *pVoid, int stream, int write);

void mz_zip_reader_delete(void **pVoid);

void mz_zip_reader_close(void *pVoid);

void mz_stream_os_delete(void **pVoid);

void mz_stream_os_close(void *pVoid);

int32_t mz_stream_os_open(void *pVoid, const char *path, int write);

int32_t mz_zip_reader_goto_first_entry(void *pVoid);

void *mz_zip_reader_create();

int32_t mz_zip_reader_open_file(void *handle, const char *path);

int32_t mz_zip_reader_open_file_in_memory(void *handle, const char *path);

void *mz_stream_os_create();
