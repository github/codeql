extern "C" int printf(const char*, ...);

struct Magic {
  ~Magic() {
    printf("Goodbye cruel world.\n");
  }
};

int main() {
  static Magic m;
  return 0;
}
