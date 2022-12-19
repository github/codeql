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

struct FILE;

int fscanf(FILE *stream, const char *format, ...);
int scanf(const char *format, ...);

void test_scanf(FILE *stream, int *d, char *buf) {
  scanf(""); // Not a local source, as there are no output arguments
  fscanf(stream, ""); // Not a remote source, as there are no output arguments
  scanf("%d", d); // $ local_source
  fscanf(stream, "%d", d);  // $ remote_source
  scanf("%d %s", d, buf); // $ local_source=40:18 local_source=40:21
  fscanf(stream, "%d %s", d, buf);  // $ remote_source=41:27 remote_source=41:30
}

struct addrinfo;

int getaddrinfo(const char *hostname, const char *servname,
                const struct addrinfo *hints, struct addrinfo **res);

void test_inet(char *hostname, char *servname, struct addrinfo *hints) {
  addrinfo *res;
  int ret = getaddrinfo(hostname, servname, hints, &res); // $ remote_source
}
