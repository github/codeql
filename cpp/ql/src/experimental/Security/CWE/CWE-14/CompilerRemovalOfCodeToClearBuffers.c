// BAD: the memset call will probably be removed.
void getPassword(void) {
  char pwd[64];
  if (GetPassword(pwd, sizeof(pwd))) {
    /* Checking of password, secure operations, etc. */
  }
  memset(pwd, 0, sizeof(pwd));
}
// GOOD: in this case the memset will not be removed.
void getPassword(void) {
  char pwd[64];
 
  if (retrievePassword(pwd, sizeof(pwd))) {
     /* Checking of password, secure operations, etc. */
  }
  memset_s(pwd, 0, sizeof(pwd));
}
// GOOD: in this case the memset will not be removed.
void getPassword(void) {
  char pwd[64];
  if (retrievePassword(pwd, sizeof(pwd))) {
    /* Checking of password, secure operations, etc. */
  }
  SecureZeroMemory(pwd, sizeof(pwd));
}
// GOOD: in this case the memset will not be optimized.
void getPassword(void) {
  char pwd[64];
  if (retrievePassword(pwd, sizeof(pwd))) {
    /* Checking of password, secure operations, etc. */
  }
#pragma optimize("", off)
  memset(pwd, 0, sizeof(pwd));
#pragma optimize("", on)
}
