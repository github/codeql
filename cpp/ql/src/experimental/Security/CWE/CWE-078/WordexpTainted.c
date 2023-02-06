
int main(int argc, char** argv) {
  char *filePath = argv[2];

  {
    // BAD: the user-controlled string is injected
    // directly into `wordexp` which performs command substitution

    wordexp_t we;
    wordexp(filePath, &we, 0);
  }

  {
    // GOOD: command substitution is disabled

    wordexp_t we;
    wordexp(filePath, &we, WRDE_NOCMD);
  }
}
