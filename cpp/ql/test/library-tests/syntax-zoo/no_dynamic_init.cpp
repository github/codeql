extern "C" int printf(const char*, ...);

struct Magic {
  ~Magic() {
    printf("Goodbye cruel world.\n");
  }
};

static int f() {
  static Magic m;
  return 0;
}
