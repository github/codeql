void test1(int *p) {
  int x;
  x = *p;
  if (p == nullptr) { // BAD
    return;
  }
}

void test2(int *p) {
  int x = *p;
  if (x > 100)
    return;
  if (!p) // BAD
    return;
}

void test_indirect(int **p) {
  int x;
  x = **p;
  if (*p == nullptr) { // BAD [NOT DETECTED]
    return;
  }
}

struct ContainsIntPtr {
  int **intPtr;
};

bool check_curslist(ContainsIntPtr *cip) {
  // both the deref and the null check come from the same instruction, but it's
  // an AliasedDefinition instruction.
  return *cip->intPtr != nullptr; // GOOD
}
