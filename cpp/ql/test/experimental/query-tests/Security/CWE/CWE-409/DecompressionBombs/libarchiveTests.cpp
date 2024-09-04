#define    ARCHIVE_EXTRACT_TIME            (0x0004)
#define    ARCHIVE_EXTRACT_PERM            (0x0002)
#define    ARCHIVE_EXTRACT_ACL                (0x0020)
#define    ARCHIVE_EXTRACT_FFLAGS            (0x0040)
#define    ARCHIVE_EOF      1    /* Found end of archive. */
#define    ARCHIVE_OK      0    /* Operation was successful. */
#define    ARCHIVE_WARN    (-20)    /* Partial success. */


int archive_read_next_header(struct archive *a, struct archive_entry **entry);

struct archive *archive_read_new();

archive *archive_write_disk_new();

void archive_read_support_format_all(archive *pArchive);

void archive_read_support_filter_all(archive *pArchive);

void archive_write_disk_set_options(archive *pArchive, int flags);

void archive_write_disk_set_standard_lookup(archive *pArchive);

int archive_read_open_filename(archive *pArchive, const char *filename, int i);

struct archive_entry;

int archive_write_header(archive *pArchive, archive_entry *entry);

int archive_entry_size(archive_entry *pEntry);

typedef int size_t;
typedef int la_int64_t;

int archive_read_data_block(archive *pArchive, const void **pVoid, size_t *pInt, la_int64_t *pInt1);

int archive_write_data_block(archive *pArchive, const void *pVoid, size_t size, la_int64_t offset);

int archive_write_finish_entry(archive *pArchive);

void archive_read_close(archive *pArchive);

void archive_read_free(archive *pArchive);

void archive_write_close(archive *pArchive);

void archive_write_free(archive *pArchive);

static int copy_data(struct archive *ar, struct archive *aw) {
    int r;
    const void *buff;
    size_t size;
    la_int64_t offset;

    for (;;) {
        archive_read_data_block(ar, &buff, &size, &offset); // BAD
        if (r == ARCHIVE_EOF)
            return (ARCHIVE_OK);
        if (r < ARCHIVE_OK)
            return (r);
        archive_write_data_block(aw, buff, size, offset);
        if (r < ARCHIVE_OK) {
            return (r);
        }
    }
}

static void extract(const char *filename) {
    struct archive *a;
    struct archive *ext;
    struct archive_entry *entry;
    int flags;
    int r;
    /* Select which attributes we want to restore. */
    flags = ARCHIVE_EXTRACT_TIME;
    flags |= ARCHIVE_EXTRACT_PERM;
    flags |= ARCHIVE_EXTRACT_ACL;
    flags |= ARCHIVE_EXTRACT_FFLAGS;

    a = archive_read_new();
    archive_read_support_format_all(a);
    archive_read_support_filter_all(a);
    ext = archive_write_disk_new();
    archive_write_disk_set_options(ext, flags);
    archive_write_disk_set_standard_lookup(ext);
    if ((archive_read_open_filename(a, filename, 10240)))
        return;
    for (;;) {
        archive_read_next_header(a, &entry);
        archive_write_header(ext, entry);
        if (archive_entry_size(entry) > 0) {
            copy_data(a, ext);
            if (r < ARCHIVE_WARN)
                break;
        }
        archive_write_finish_entry(ext);
        if (r < ARCHIVE_WARN)
            break;
    }
    archive_read_close(a);
    archive_read_free(a);
    archive_write_close(ext);
    archive_write_free(ext);
}


void libarchive_test(int argc, const char **argv) {
    extract(argv[1]);
}
