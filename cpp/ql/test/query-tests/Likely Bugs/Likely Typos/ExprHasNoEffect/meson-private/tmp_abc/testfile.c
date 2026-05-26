typedef long long size_t;

size_t strlen(const char *s);

int main() {
  strlen(""); // GOOD: the source file occurs in a `meson-private/tmp.../testfile.c` directory
  return 0;
}
