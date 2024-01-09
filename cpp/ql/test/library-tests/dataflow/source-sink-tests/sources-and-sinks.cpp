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

typedef unsigned int wint_t;

// getc variants
int getc(FILE *stream);
wint_t getwc(FILE *stream);
int _getc_nolock(FILE *stream);
wint_t _getwc_nolock(FILE *stream);

int getch(void);
int _getch(void);
wint_t _getwch(void);
int _getch_nolock(void);
wint_t _getwch_nolock(void);
int getchar(void);
wint_t getwchar();
int _getchar_nolock(void);
wint_t _getwchar_nolock(void);

void test_getchar(FILE *stream) {
  int a = getc(stream); // $ MISSING: remote_source
  wint_t b = getwc(stream); // $ MISSING: remote_source
  int c = _getc_nolock(stream); // $ MISSING: remote_source
  wint_t d = _getwc_nolock(stream); // $ MISSING: remote_source

  int e = getch(); // $ MISSING: local_source
  int f = _getch(); // $ MISSING: local_source
  wint_t g = _getwch(); // $ MISSING: local_source
  int h = _getch_nolock(); // $ MISSING: local_source
  wint_t i = _getwch_nolock(); // $ MISSING: local_source
  int j = getchar(); // $ MISSING: local_source
  wint_t k = getwchar(); // $ MISSING: local_source
  int l = _getchar_nolock(); // $ MISSING: local_source
  wint_t m = _getwchar_nolock(); // $ MISSING: local_source
}
