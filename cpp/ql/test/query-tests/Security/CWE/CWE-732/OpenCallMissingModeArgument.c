typedef unsigned int mode_t;

#define O_CREAT 0100

int open(const char *pathname, int flags, ...);

int openat(int dirfd, const char *pathname, int flags, ...);

const char *a_file = "/a_file";

void test_open() {
  open(a_file, O_CREAT);
  open(a_file, O_CREAT, 0);
  openat(0, a_file, O_CREAT);
  openat(0, a_file, O_CREAT, 0);
}
