#ifdef _MSC_VER
#define restrict __restrict
#else
#define restrict __restrict__
#endif

typedef unsigned long size_t;

typedef struct {
    size_t we_wordc;
    char **we_wordv;
    size_t we_offs;
} wordexp_t;

enum {
    WRDE_APPEND = (1 << 1),
    WRDE_NOCMD = (1 << 2)
};

int wordexp(const char *restrict s, wordexp_t *restrict p, int flags);

int main(int argc, char** argv) { // $ Source
  char *filePath = argv[2];

  {
    // BAD: the user string is injected directly into `wordexp` which performs command substitution

    wordexp_t we;
    wordexp(filePath, &we, 0); // $ Alert
  }

  {
    // GOOD: command substitution is disabled

    wordexp_t we;
    wordexp(filePath, &we, WRDE_NOCMD);
  }

  {
    // GOOD: command substitution is disabled

    wordexp_t we;
    wordexp(filePath, &we, WRDE_NOCMD | WRDE_APPEND);
  }
}
