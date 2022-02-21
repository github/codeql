typedef unsigned int mode_t;

#define O_RDWR     0x0002
#define O_CLOEXEC  0x0040
#define O_NONBLOCK 0x0080
#define O_CREAT    0x0200
#define O_APPEND   0x0800
#define O_TMPFILE  0x2000

int open(const char *pathname, int flags, ...);

int openat(int dirfd, const char *pathname, int flags, ...);

const char *a_file = "/a_file";

void test_open() {
  open(a_file, O_NONBLOCK); // GOOD
  open(a_file, O_RDWR | O_CLOEXEC); // GOOD
  open(a_file, O_APPEND); // GOOD
  open(a_file, O_CREAT); // BAD
  open(a_file, O_CREAT, 0); // GOOD
  open(a_file, O_TMPFILE); // BAD
  open(a_file, O_TMPFILE, 0); // GOOD
  openat(0, a_file, O_APPEND); // GOOD
  openat(0, a_file, O_CREAT); // BAD
  openat(0, a_file, O_CREAT, 0); // GOOD
  openat(0, a_file, O_TMPFILE); // BAD
  openat(0, a_file, O_TMPFILE, 0); // GOOD
}
