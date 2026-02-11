#define    ARCHIVE_EOF     1
#define    ARCHIVE_OK      0
#define    ARCHIVE_WARN    (-20)

struct archive;
struct archive_entry;
typedef int size_t;
typedef int la_int64_t;

archive *archive_read_new();
int archive_read_open_filename(archive *pArchive, const char *filename, int i);
int archive_read_next_header(archive *a, archive_entry **entry);
int archive_entry_size(archive_entry *pEntry);
int archive_read_data_block(archive *pArchive, const void **pVoid, size_t *pInt, la_int64_t *pInt1);

static int read_data(archive *ar) {
    for (;;) {
        const void *buff;
        size_t size;
        la_int64_t offset;

        int r = archive_read_data_block(ar, &buff, &size, &offset); // BAD
        if (r == ARCHIVE_EOF)
            return ARCHIVE_OK;
        if (r < ARCHIVE_OK)
            return r;
    }
}

void libarchive_test(int argc, const char **argv) {
    archive *a = archive_read_new();
    archive_entry *entry;

    archive_read_open_filename(a, argv[1], 10240);
    for (;;) {
        archive_read_next_header(a, &entry);
        if (archive_entry_size(entry) > 0) {
            if (read_data(a) < ARCHIVE_WARN)
                break;
        }
    }
}
