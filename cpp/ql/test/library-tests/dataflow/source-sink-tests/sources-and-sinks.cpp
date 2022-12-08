char *getenv(const char *name);
char *secure_getenv(const char *name);
wchar_t *_wgetenv(const wchar_t *name);

void test_getenv() {
    void *var1 = getenv("VAR"); // $ local_source
    void *var2 = secure_getenv("VAR"); // $ local_source
    void *var3 = _wgetenv(L"VAR"); // $ local_source
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
  readv(0, iovs, 16); // $ remote_source
  writev(0, iovs, 16); // $ remote_sink
}
