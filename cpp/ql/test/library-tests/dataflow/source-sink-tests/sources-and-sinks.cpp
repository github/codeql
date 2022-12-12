char *getenv(const char *name);
char *secure_getenv(const char *name);
wchar_t *_wgetenv(const wchar_t *name);

void test_getenv() {
    void *var1 = getenv("VAR"); // $ local_source=6:18 local_source=6:18
    void *var2 = secure_getenv("VAR"); // $ local_source=7:18 local_source=7:18
    void *var3 = _wgetenv(L"VAR"); // $ local_source=8:18 local_source=8:18
}

int send(int, const void*, int, int);

void test_send(char* buffer, int length) {
  send(0, buffer, length, 0); // $ remote_sink
}

struct iovec {
  void  *iov_base;
  unsigned iov_len;
};

int readv(int, const struct iovec*, int);
int writev(int, const struct iovec*, int);

void test_readv_and_writev(iovec* iovs) {
  readv(0, iovs, 16); // $ MISSING: remote_source
  writev(0, iovs, 16); // $ remote_sink
}
